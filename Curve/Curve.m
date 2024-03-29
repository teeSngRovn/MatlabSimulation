%-----data-----%
global T_x;
global T_y;
global line;
global point;
global n;
global number;
global appro;

%T_x and T_y so big is trying to ensure function calculate right
%meanwhile, dt big make image seem more smoothly, but it decrease the
%precision because the sampling frequency becomes low by big dt.
dt = 50;
T_x = 3000;
T_y = 7001;


t_x = 0;
t_y = 0;
x = 0;
y = 0;
number=0;
appro=lcm(T_x,T_y);
n = 1;

for i=-10:10
    for j=-10:10
        if appro>lcm(T_x+i,T_y+j)
            appro=lcm(T_x+i,T_y+j);
        end
    end
end


%-----draw-----%
figure
colordef black
grid off
axis equal
axis([-20 20 -20 20]) 
hold on


line1 = animatedline('color', 'r');
line2 = animatedline('color', 'g');
line3 = animatedline('color', 'b');
line4 = animatedline('color', 'c');
line5 = animatedline('color', 'm');
line6 = animatedline('color', 'y');
line7 = animatedline('color', 'w');
line8 = animatedline('color', 'r');
line9 = animatedline('color', 'g');
lineA = animatedline('color', 'b');
lineB = animatedline('color', 'c');
lineC = animatedline('color', 'm');
lineD = animatedline('color', 'y');
lineE = animatedline('color', 'w');

%The bad color version of lisaru
%line=[line1,line2,line3,line4,line5,line6,line7,line8,line9,lineA,lineB,lineC,lineD,lineE];

line = [line2,line9];
point = plot(x, y, 'r:.', 'markersize', 20);

while true
    
    draw(t_x, t_y, 0);

    t_x = t_x + dt;
    t_y = t_y + dt;
    if t_y == T_y
        t_y = 0;
    end
    if t_x == int32(T_x/dt)*dt
        draw(t_x, t_y, 1);
        t_x = 0;
    end
end

function draw(tx, ty, flg)
    global T_x;
    global T_y;
    global line;
    global point;
    global n;
    global number;
    global appro;
    x = 10 * sin(2 * pi / T_x * tx);
    %x = tx;
    %appro=T_x;
    y = 10 * sin(2 * pi / T_y * ty);
    %y = (sqrt(ty)+ty)/sin(2 * pi / T_y * ty)/100+10;
    
    %setpoint trace update the coordinate of the ball is, and it will
    %showup when drawnow function been executed
    %set(point, 'Xdata', x, 'Ydata', y);
    addpoints(line(n), x, y);
    %drawnow here draws the routes of how lisaru image generate
    %it also combine the function of drawing not X-Y by just deleting the
    %comment before "x = tx; appro=T_x;"
    %drawnow
    
    
    if flg
        number = number+1;
    end
    if number==int32(appro/T_x)
        n = mod(n, length(line)) + 1;
        clearpoints(line(n))
        number=0;
        %drawnow here draws a complete lisaru image with motion
        drawnow
    end
end