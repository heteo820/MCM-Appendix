a = 0.1; b = 0.2; 
t = linspace(0, 4.6*pi, 1000); 
xx=zeros(1,1000);yy=zeros(1,1000);
%Mobile Points
xx=t/5/pi;yy=sin(t/5/pi);
%stationary points
%xx=xx*0;%yy=yy*0;
x = (a + b*t) .* cos(t)+xx;
y = (a + b*t) .* sin(t)+yy;
z = t;figure;
plot(x, y, 'g');hold on;
plot(xx,yy, 'r');hold on;
grid on;
legend('Main Ship Route','Submarine Prediction Route')
title('Search and Rescue Routes for Mobile Points');
xlabel('X/(5km)');ylabel('Y/(5km)');
XX=[0.125185,0.0257262;-0.425,0.393;-0.749,-0.278;-0.349,-0.904;0.375,-1.046;1.022,-0.696;1.350,-0.040;1.282,0.688;0.867,1.288;0.222,1.629;-0.505,1.655;-1.177,1.378;-1.684,0.859;-1.957,0.187;-1.966,-0.537;-1.721,-1.218;-1.258,-1.775;-0.639,-2.148;0.066,-2.304;0.785,-2.233;1.448,-1.948;1.997,-1.480;2.388,-0.874;2.593,-0.183;2.599,0.537;2.411,1.233;2.046,1.853;1.533,2.358;0.908,2.715;0.214,2.905;-0.505,2.918];
for k=1:31
XX(k,1)=XX(k,1)+xx(33*(k-1)+1);
XX(k,2)=XX(k,2)+yy(33*(k-1)+1);
end
scatter(XX(:,1),XX(:,2), 'MarkerFaceColor', 'y')