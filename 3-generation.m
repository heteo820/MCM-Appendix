function [ output_args ] = paint( cities, pop, minPath, totalDistances,gen)
    gNumber=gen;
    Dth=xlsread('F:\dm\Ionian.xlsx');
Dp=Dth(:,3:5);
dy=0.0042;
dx=0.0042;
x = Dp(:, 2);
y = Dp(:, 3);
z = Dp(:, 1);
[X, Y] = meshgrid(linspace(min(x), max(x), 100), ...
                  linspace(min(y), max(y), 100));
Z = griddata(x, y, z, X, Y, 'cubic');
figure;
surf(X, Y, Z);hold on;
title('Ionian seafloor 3D');
xlabel('X axis');
ylabel('Y axis');
zlabel('Height (Z axis)');
shading interp; 
colorbar; 
    [~, length] = size(cities);
    xDots = cities(1,:);
    yDots = cities(2,:);
    zDots = cities(3,:);
    %figure(1);
    title('GA TSP');
    plot3(xDots,yDots,zDots, 'p', 'MarkerSize', 14, 'MarkerFaceColor', 'Red');
    xlabel('Longitude');
    ylabel('Latitude');
    zlabel('Depth');
    xlim([20 21])
    ylim([36 37])
    hold on
    [minPathX,~] = find(totalDistances==minPath,1, 'first');
    bestPopPath = pop(minPathX, :);
    bestX = zeros(1,length);    bestY = zeros(1,length); bestZ = zeros(1,length);
    for j=1:length
       bestX(1,j) = cities(1,bestPopPath(1,j));
       bestY(1,j) = cities(2,bestPopPath(1,j));
       bestZ(1,j) = cities(3,bestPopPath(1,j));
    end
    title('GA TSP');
    plot3(bestX(1,:),bestY(1,:),bestZ(1,:), 'red', 'LineWidth', 1.25);
    legend('Suspected Submersible Target', 'Path');
    grid on
     drawnow
    hold off
end