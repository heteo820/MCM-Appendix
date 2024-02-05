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
xlabel('X Longitude');
ylabel('Y Latitude');
zlabel('Height (Z axis)');
shading interp; 
colorbar; 
v_yl=200;
vs=300;
L=111e3;
Xh0=20.3944*L*cos(36.5251/180*pi); Yh0=36.5251*L;
Vh=3500;
%潜水器失事位置和速度
Xs0=Xh0+randn*L/10;Ys0=Yh0+randn*L/10; Hs0=-3000;
for i=1:size(Dp,1)
    if Dp(i,2)-Xs0/L/cos(36.5251/180*pi)<dx && Dp(i,3)-Xs0/L<dy
        Hs0=max(Hs0,Dp(i,1)+10);
    end
end
vxs0=180;vys0=-240;vhs0=0;
vhd=900;
vha=1000;
arange=7500;
XX=[0.125185,0.0257262;-0.425,0.393;-0.749,-0.278;-0.349,-0.904;0.375,-1.046;1.022,-0.696;1.350,-0.040;1.282,0.688;0.867,1.288;0.222,1.629;-0.505,1.655;-1.177,1.378;-1.684,0.859;-1.957,0.187;-1.966,-0.537;-1.721,-1.218;-1.258,-1.775;-0.639,-2.148;0.066,-2.304;0.785,-2.233;1.448,-1.948;1.997,-1.480;2.388,-0.874;2.593,-0.183;2.599,0.537;2.411,1.233;2.046,1.853;1.533,2.358;0.908,2.715;0.214,2.905;-0.505,2.918];
XX=XX*(2*arange/5/1.25);
N=31;
vxs=zeros(1,N);vys=zeros(1,N);vhs=zeros(1,N);
Xs=zeros(1,N);Ys=zeros(1,N);Hs=zeros(1,N);
xa=zeros(1,N);ya=zeros(1,N);ha=zeros(1,N);
xd=zeros(1,N);yd=zeros(1,N);hd=zeros(1,N);
Xh=zeros(1,N);Yh=zeros(1,N);
vxs(1)=vxs0;vys(1)=vys0;
Xs(1)=Xs0;Ys(1)=Ys0;Hs(1)=Hs0;
xa(1)=Xh0;ya(1)=Yh0;ha(1)=0;
xd(1)=Xh0;yd(1)=Yh0;hd(1)=0;
Xh(1)=Xh0;Yh(1)=Yh0;

for t=2:N
    if t==2
        Xh(t)=Xh(t-1);Yh(t)=Yh(t-1);
    elseif sqrt((xa(t-1)-Xs(t-1))^2+(ya(t-1)-Ys(t-1))^2+(ha(t-1)-Hs(t-1))^2)<arange
        if (Xh(t-1)-Xs(t-1))<2000
            Xh(t)=Xh(t-1)+sign(Xs(t-1)-Xh(t-1))*2000;
        else
            Xh(t)=Xs(t-1);
        end
        if (Yh(t-1)-Ys(t-1))<2000
            Yh(t)=Yh(t-1)+sign(Ys(t-1)-Yh(t-1))*2000;
        else
            Yh(t)=Ys(t-1);
        end
    else
        Xh(t)=Xh(t-1)+XX(t,1);Yh(t)=Yh(t-1)+XX(t,2);
    end
    if flag==0
        vxs(t)=min(max(vxs(t-1)+100*rand,-172),172);
        vys(t)=min(max(vxs(t-1)+100*rand,-172),172);
        Xs(t)=Xs(t-1)+vxs(t-1);Ys(t)=Ys(t-1)+vys(t-1);
        for i=1:size(Dp,1)
            if abs(Dp(i,2)-Xs(t)/L/cos(36.5251/180*pi))<dx && abs(Dp(i,3)-Ys(t)/L)<dy
                Hs(t)=max(Hs(t-1),Dp(i,1)+10);    
            end
        end
    else
        Xs(t)=Xs(t-1);Ys(t)=Ys(t-1);Hs(t)=Hs(t-1)+500;
        Hs(t)=min(Hs(t),0);
    end
    if t==2
        ha(t)=ha(t)-vha;
        xa(t)=xa(t-1);ya(t)=ya(t-1);
    else
        ha(t)=ha(t-1);
        xa(t)=0.8*(Xh(t)-xa(t-1))+xa(t-1);ya(t)=0.8*(Yh(t)-ya(t-1))+ya(t-1);
    end
    flag=1;
    if sqrt((xa(t-1)-Xs(t-1))^2+(ya(t-1)-Ys(t-1))^2+(ha(t-1)-Hs(t-1))^2)>arange
        xd(t)=Xh(t);yd(t)=Yh(t);hd(t)=-10;
        flag=0;
    else
        if abs(hd(t-1)-Hs(t-1))<600
            hd(t)=Hs(t)+10;
        else
            hd(t)=hd(t-1)-600;
            flag=0;
        end
        if abs(xd(t-1)-Xs(t-1))<300
            xd(t)=Xs(t);
        else
            xd(t)=xd(t-1)+sign(Xs(t-1)-xd(t-1))*400;
            flag=0;
        end
        if abs(yd(t-1)-Ys(t-1))<300
            yd(t)=Ys(t);
        else
            yd(t)=yd(t-1)+sign(Ys(t-1)-yd(t-1))*400;
            flag=0;
        end
        for i=1:size(Dp,1)
            if abs(Dp(i,2)-xd(t)/L/cos(36.5251/180*pi))<dx && abs(Dp(i,3)-yd(t)/L)<dy
                hd(t)=max(hd(t),Dp(i,1)+10);
            end
        end
    end
    scatter3(Xh(t)/(L*cos(36.5251/180*pi)),Yh(t)/L,0,'red');hold on;
    scatter3(xa(t)/(L*cos(36.5251/180*pi)),ya(t)/L,ha(t),'yellow');hold on;
    scatter3(Xs(t)/(L*cos(36.5251/180*pi)),Ys(t)/L,Hs(t),'black');hold on;
    scatter3(xd(t)/(L*cos(36.5251/180*pi)),yd(t)/L,hd(t),'cyan');hold on;
end
legend('Depth','Rescue Boats','Sonar','Submersible','Rescue Submarine')
legend('Location', 'NorthWest');  