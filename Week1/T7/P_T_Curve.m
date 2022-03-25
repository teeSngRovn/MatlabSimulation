%------------FigureConf------------%
%figure;
hold on;
grid on;
axis([130 155 20 60])
title('$O_2\quad P - T\quad Curve$','interpreter','latex','fontsize',12)
subtitle('$n_{O_2}= 1mol\quad V=55cm^3$','interpreter','latex','fontsize',12)
xlabel('$T / K$','interpreter','latex','fontsize',14)
ylabel('$P / bar$','interpreter','latex','fontsize',14)
%----------main-----------%
V0 = 55;
pointx = [];
pointy = [];
for t = 130:0.1:154
    t
    [point1,point2]=FIND(t,V0);
    pointx = [pointx,point1(1)];
    pointy = [pointy,point1(2)];
end
poly = polyfit(pointx,pointy,20);
plot(pointx,pointy,'.');
%----------------FUNCTIONS----------------%

function result = INT(P, px1, px2, C)
    result = 0;
    pos1 = 0;
    pos2 = 0;
    for i = 1:length(P(1,:))
        if P(1,i)==px1
            pos1=i;
        end
        if P(1,i)==px2
            pos2=i;
            break;
        end
    end
    for i = pos1:(pos2-1)
        result = result + (P(1,i+1)-P(1,i))*((P(2,i+1)+P(2,i))/2 - C);
    end
end

function dir = search(P, val, pos)
dir = [];
flag = 1;
for i = pos:length(P(2,:))
    if (abs(P(2,i)-val)<=0.005)&&(flag==1||flag==2)
        dir=[dir i];
        flag = 2;
    else
        if (flag==2)
            flag = 3;
            break;
        end
    end
end
end

function [point1,point2,point3] = make(P,val)
    dir = [];
    pos = (0);
    for k = 1:3
        pos = search(P,val,max(pos)+1);
        i = pos(int32(length(pos)/2));
        x = P(1, i);
        y = P(2, i);
        dir = [dir,[x y]];
    end
    point1 = dir(1:2);
    point2 = dir(3:4);
    point3 = dir(5:6);
end


function [pointl,pointr] = FIND(T,V0)
%--------data--------%
%Constant
a = 1.378;
b = 0.03183;
R = 8.31451;
eps = 0.001;
%Variable
n = 1;
V = (40:0.0005:1000);
P = [V;(n * R * T)./(V*10^-3 - n * b) * 10^-2 - (a * n) ./ ((V*10^-3) .^ 2)];
p = [V(1:length(V)-1);diff(P(2,:))/0.001];
%Function
fun = @(x)(n*R*T)./(x*10^-3 - n*b)*10^-2 - (a*n)./((x*10^-3).^2);

%------------Simulation------------%
pos = [];
for i = 1:length(p)-1
    if p(2,i)*p(2,i+1)<=0
        if p(1,i+1)==0 
            pos = [pos p(1,i+1)];
        else
            pos = [pos p(1,i)];
        end
    end
end

minx = min(pos);
maxx = max(pos);
MIN = fun(minx);
MAX = fun(maxx);
MID = (MIN + MAX) / 2;
[POINT1, POINT2, POINT3] = make(P,MID);
INTL = integral(fun,POINT1(1),POINT2(1)) - MID*(POINT2(1)-POINT1(1));
INTR = integral(fun,POINT2(1),POINT3(1)) - MID*(POINT3(1)-POINT2(1));
%INTL = INT(P,POINT1(1),POINT2(1),MID);
%INTR = INT(P,POINT2(1),POINT3(1),MID);
while (abs(INTL+INTR)>eps)
    if (INTL+INTR)<0
        MAX = MID;
        MID = (MIN+MAX) / 2;
    else
        MIN = MID;
        MID = (MIN+MAX) / 2;
    end
    [POINT1, POINT2, POINT3] = make(P,MID);
    INTL = integral(fun,POINT1(1),POINT2(1)) - MID*(POINT2(1)-POINT1(1));
    INTR = integral(fun,POINT2(1),POINT3(1)) - MID*(POINT3(1)-POINT2(1));
    %INTL = INT(P,POINT1(1),POINT2(1),MID);
    %INTR = INT(P,POINT2(1),POINT3(1),MID);
end
%pointl = POINT1;
%pointr = POINT3;
%if mod(T,3)==0
%    plot(V, P(2,:));
%end
%plot(POINT1(1),POINT1(2),'.');
%plot(POINT3(1),POINT3(2),'.');
if (POINT1(1)<=V0)&&(V0<=POINT3(1))
    pointl = [T, (POINT1(2)+POINT3(2))/2];
    pointr = [];
else
    for i = 1:length(P(1,:))
        if P(1,i)==V0
            pointl = [T, P(2,i)];
            pointr = [];
            break;
        end
    end
end
end