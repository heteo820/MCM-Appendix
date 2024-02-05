clc, clear;
Dth=xlsread('F:\fm\Bnew\Caribbean.xlsx');
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

title('Caribbean Submarine Rescue Matching Map');
xlabel('Longitude');
ylabel('Latitude');
zlabel('Depth');
shading interp; 
colorbar; 

dy=0.0042;
dx=0.0042;
subnum=5;
Sub=[-65.8364300902150	19.1535903766194	-6870;
-65.3340127835889	19.9534570698862	-6994.47548710479;
-65.1056106246458	19.5408840812415	-4480.74807194832;
-65.4834417916487	19.6797338982105	-6100.18065905044;
-65.2972976930495	19.0365630180485	-3445];
Ship=[-65.4535505600969	19.0205357746582	0;
-65.6011192476168	19.9236756126204	0;
-65.5849066133870	19.6536998890083	0;
-65.8192622397452	19.9326135720486	0;
-65.7446132595120	19.1635123685275	0];

L=111e3;
c=zeros(5);
for i=1:subnum
    for j=1:subnum
        c(i,j)=sqrt((Sub(i,1)-Ship(j,1))^2+(Sub(i,2)-Ship(j,2))^2)+10/L*abs(Sub(i,3));
    end 
end
size = length(c);
line = min((c'));
line = repmat(line',1, size);
c = c - line;
column = min(c);
column = repmat(column, size, 1);
c = c - column;

[axis_line, axis_column] = find(c == 0);
result = [axis_line, axis_column];
z = zeros(size, size);
for i=1:size
    x = find(result(:, 2) == i);
    tpl_size = length(x);
    z(i, 1) = tpl_size;
    for j = 2:tpl_size+1
        test = result(x(j - 1),1);
        z(i, j) = test;
    end
end

tplresult = result;
while true
    mkdline = zeros(1, size);
    mkdColumn = zeros(1, size);
    [tplAnswer, all] = fit(z, 1, (1:size), zeros(1, size), []);
    left = setdiff((1:size), tplAnswer);
    if ~isempty(all)
        disp('all rolution');
        for i = 1:length(all(:, 1))
            fprintf('the %dth solution', i);
            disp(all(i, :));
        end
        break;
    end
    mkdline(left) = 1;
    tpl_mkd = find(mkdline == 1);
    for i = 1:length(tpl_mkd)
        tmp = tpl_mkd(i);
        while true
            tmp = find(tplresult(:, 1) == tmp);
            erase = tmp;
            tmp = tplresult(tmp, 2);
            if isempty(tmp)
                break;
            end
            mkdColumn(tmp) = 1;
            tplresult(erase, :) = [];
            tmp = find(tplresult(:, 2) == tmp);
            erase = tmp;
            tmp = tplresult(tmp, 1);
            if isempty(tmp)
                break;
            end
            mkdline(tmp) = 1;
            tplresult(erase, :) = [];
        end
    end
     line = mkdline;
     column = not(mkdColumn);
     flag = (line')*column;
     subscript = find(flag == 1);
     min = findMin(c, subscript);
     tplline = find(mkdline == 1);
     tplcolumn = find(mkdColumn == 1);
     c(tplline, :) = c(tplline, :) - min;
     c(:, tplcolumn) = c(:, tplcolumn) + min;
     tpl = find(c(subscript) == 0);
     tpl = subscript(tpl);
         y = fix((tpl-1)/5) + 1;
         x = tpl - (y-1)*5;
     tplresult = [result; [x, y]];                              
     for i = 1:length(x)
         z(x(i), 1) = z(x(i), 1) + 1;
         z(x(i), z(x(i), 1)+1) = y(i); 
     end
end
result = all;
clr={'r','g','b','m','c'};
L=111e3;
c=zeros(5);
for i=1:subnum
    for j=1:subnum
        c(i,j)=sqrt((Sub(i,1)-Ship(j,1))^2+(Sub(i,2)-Ship(j,2))^2)+10/L*abs(Sub(i,3));
    end 
end
TT=0;
for k=1:subnum
    scatter3(Sub(k,1),Sub(k,2),Sub(k,3),clr{k},'o','filled');
    scatter3(Ship(all(1,k),1),Ship(all(1,k),2),Ship(all(1,k),3),clr{k},'>','filled');
    legend('Depth','Submarine1','Rescue vessel/main vessel 5','Submarine2','Rescue vessel/main vessel 2','Submarine3','Rescue vessel/main vessel 3','Submarine4','Rescue vessel/main vessel 4','Submarine5','Rescue vessel/main vessel 1')
    TT=max(TT,c(k,all(1,k)));
end
fprintf('Farthest rescue distance：%fkm',TT*L/1000);
