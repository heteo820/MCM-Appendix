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
xlim([20.25 20.75])
ylim([36.25 36.75])
zlabel('Height (Z axis)');
L=111e3;
Xs0=20.3944*L*cos(36.5251/180*pi); Ys0=36.5251*L;Hs0=-2500;
vt0=-pi/4;vyl0=20000;vylt0=0;vh0=-25;
vs0=300000;
num_motions = 100;
N = 1000;
sigma = 100;
place = zeros(num_motions, N,3);
v = zeros(num_motions, N,5);
    for m = 1:num_motions
            place(m, 1,1) = Xs0;
            place(m, 1,2) = Ys0;
            place(m, 1,3) = Hs0;
            v(m, 1,1)=vs0;
            v(m, 1,2)=vt0;
            v(m, 1,3)=vh0;
            v(m, 1,4)=vyl0;
            v(m, 1,5)=vylt0;
        for i = 2:N
            t1=sigma*randn/10;
            v1=sigma*randn;
            t2=sigma*randn/10;
            v2=sigma*randn/25;
            v3=2*sigma*randn;
            proposed_position(1) = place(m, i-1,1)+min(max(v(m,i,1)+v3,0),vs0)*cos(v(m,i,2)+t1) + (v(m,i,4) + v1)*cos(v(m,i,5)+t2);
            proposed_position(2) = place(m, i-1,2)+min(max(v(m,i,1)+v3,0),vs0)*sin(v(m,i,2)+t1) + (v(m,i,4) + v1)*sin(v(m,i,5)+t2);
            proposed_position(3) = place(m, i-1,3) + (v(m,i,3) + v2);
            alpha = min(1, probability_density(proposed_position) / probability_density(place(m, i-1)));
            if rand <= alpha
                place(m, i,1) = proposed_position(1);
                place(m, i,2) = proposed_position(2);
                place(m, i,3) = proposed_position(3);
                v(m,i,1)=min(max(v(m,i,1)+v3,0),vs0);
                v(m,i,2)=v(m,i,2)+t1;
                v(m,i,2)=min(max(v(m,i,2)+v2,-100),100);
                v(m,i,4)=min(max(v(m,i,4)+v1,0),vyl0);
                v(m,i,5)=v(m,i,5)+t2;
            else
                place(m, i,:) = place(m, i-1,:);
                v(m,i,:)=v(m,i-1,:);
            end
        end
    end
    for m = 1:10:num_motions
        for k=1:100:N
            for i=1:size(Dp,1)
                cnt=0;
                if Dp(i,2)-place(m, k,1)/L/cos(36.5251/180*pi)<dx && Dp(i,3)-place(m, k,2)/L<dy
                    place(m, k,3)=max(place(m, k,3),Dp(i,1)+10);
                    cnt=cnt+1;
                end
                if cnt>3
                    break;
                end
            end
            scatter3(place(m, k,1)/L/cos(36.5251/180*pi),place(m, k,2)/L,place(m, k,3));hold on;
        end
    end
    hold off;
    title('Possible locations of submersibles');
    xlabel('Time');
    ylabel('Location');
function p = probability_density(x)
    p = exp(-0.5 * x.^2); 
end
