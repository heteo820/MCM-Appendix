tStart = tic; 
[~,parts] = Read('dsj1000.tsp');
parts = parts';
PartNum=10;
parts=parts(:,1:PartNum);
maxx=max(parts(1,:));
minx=min(parts(1,:));
maxy=max(parts(2,:));
miny=min(parts(2,:));
for i=1:PartNum
    parts(1,i)=(parts(1,i)-minx)/(maxx-minx)*0.5+20.25;
    parts(2,i)=(parts(2,i)-miny)/(maxy-miny)*0.5+36.25;
end
dep=100*randn(1,PartNum)-2000;
parts(3,:)=dep;
maxGEN = 1000;
popSize = 100;
croProbabilty = 0.9; 
mutProbabilty = 0.1;
 
gbest = Inf;
distances = calculateDistance(parts);
pop = zeros(popSize, PartNum);
for i=1:popSize
    pop(i,:) = randperm(PartNum); 
end
offspring = zeros(popSize,PartNum);
minPathes = zeros(maxGEN,1);
 
for  gen=1:maxGEN
    [fval, sumDistance, minPath, maxPath] = fitness(distances, pop);
 
    tournamentSize=4; 
    for k=1:popSize
        tourPopDistances=zeros( tournamentSize,1);
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
        parent1  = min(tourPopDistances);
        [parent1X,parent1Y] = find(sumDistance==parent1,1, 'first');
        parent1Path = pop(parent1X(1,1),:);
 
 
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
        parent2  = min(tourPopDistances);
        [parent2X,parent2Y] = find(sumDistance==parent2,1, 'first');
        parent2Path = pop(parent2X(1,1),:);
 
        subPath = crossover(parent1Path, parent2Path, croProbabilty);%交叉
        subPath = mutate(subPath, mutProbabilty);%变异
 
        offspring(k,:) = subPath(1,:);
        
        minPathes(gen,1) = minPath; 
    end
    fprintf('Time:%d  min:%.2fKM \n', gen,minPath);

    pop = offspring;
    if minPath < gbest
        gbest = minPath;
        paint(parts, pop, gbest, sumDistance,gen);

    end
end
figure 
plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
title('Convergence Curve (Shortest Path for Each Generation)');
set(gca,'ytick',0:100:5000); 
ylabel('Length/km');
xlabel('Iterations');

grid on
tEnd = toc(tStart);
fprintf('Time:%d m  %f s.\n', floor(tEnd/60), rem(tEnd,60));