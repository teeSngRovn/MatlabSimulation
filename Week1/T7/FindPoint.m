%------------data------------%
%Constant
a = 1.378;
b = 0.03183;
R = 8.31451;
eps = 0.001;
%Variable
T = 154.27;
n = 1;
V = (50:0.0005:1000);
P = [V;(n * R * T)./(V*10^-3 - n * b) * 10^-2 - (a * n) ./ ((V*10^-3) .^ 2)];
p = [V(1:length(V)-1);diff(P(2,:))/0.001];
%Function
fun = @(x)(n*R*T)./(x*10^-3 - n*b)*10^-2 - (a*n)./((x*10^-3).^2);

%------------Simulation------------%
pos = [];
for i = 1:length(p(1,:))-1
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
    INTL+INTR
end
%------------FigureConf------------%
figure;
hold on;
grid on;
axis([min(V) max(V) 0 120])
title('$P - V$ Curve','interpreter','latex','fontsize',12)
xlabel('$V / cm^3$','interpreter','latex','fontsize',14)
ylabel('$P / bar$','interpreter','latex','fontsize',14)
%title('$T = 132^\circ$','interpreter','latex')
%------------Plot------------%
plot(V, P(2,:),'linewidth', 1);
plot(POINT1(1),POINT1(2),'o');
plot(POINT3(1),POINT3(2),'o');
%plot(V(1:length(p)), p,'linewidth', 1);

%FUNCTIONS%
function dir = search(P, val, pos)
dir = [];
flag = 1;
for i = pos:length(P(2,:))
    if (abs(P(2,i)-val)<=0.00001)&&(flag==1||flag==2)
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
        dir = [dir,[x y]]
    end
    point1 = dir(1:2);
    point2 = dir(3:4);
    point3 = dir(5:6);
end

