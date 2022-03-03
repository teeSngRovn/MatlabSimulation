%----------data---------%

m1 = rand() * 10 ^ 22;
m2 = rand() * 10 ^ 15;
m3 = rand() * 10 ^ 13;

pos1 = [rand() * 10 ^ 6, rand() * 10 ^ 6, rand() * 10 ^ 6];
pos2 = [rand() * 10 ^ 6, rand() * 10 ^ 6, rand() * 10 ^ 6];
pos3 = [rand() * 10 ^ 6, rand() * 10 ^ 6, rand() * 10 ^ 6];
pos = [0,0,0];

v1 = [rand() * 10 ^ 3, rand() * 10 ^ 3, rand() * 10 ^ 3];
v2 = [rand() * 10 ^ 3, rand() * 10 ^ 3, rand() * 10 ^ 3];
v3 = [rand() * 10 ^ 3, rand() * 10 ^ 3, rand() * 10 ^ 3];

G = 6.67 * 10 ^ -11;
dt  = 0.005;

%-------main-------%
figure
colordef black 
grid off
axis equal
view(3)
hold on

planet1 = plot3(pos1(1) - pos(1), pos1(2) - pos(2), pos1(3) - pos(3), 'r:.', 'markersize', 70);
planet2 = plot3(pos2(1) - pos(1), pos2(2) - pos(2), pos2(3) - pos(3), 'b:.', 'markersize', 20);
planet3 = plot3(pos3(1) - pos(1), pos3(2) - pos(2), pos3(3) - pos(3), 'w:.', 'markersize', 5);

h1 = animatedline('color', 'r');
h2 = animatedline('color', 'b');
h3 = animatedline('color', 'w');

xlabel('X')
ylabel('Y')
zlabel('Z')


frame = 0;
while true
    r12 = normest(pos2 - pos1);
    r23 = normest(pos3 - pos2);
    r31 = normest(pos1 - pos3);
        
    F12_val = G * m1 * m2 / (r12 ^ 2);
    F23_val = G * m2 * m3 / (r23 ^ 2);
    F31_val = G * m3 * m1 / (r31 ^ 2);
  
    F12_dir = (pos2 - pos1) / r12;
    F23_dir = (pos3 - pos2) / r23;
    F31_dir = (pos1 - pos3) / r31;
    
    a1 = (F12_val * F12_dir - F31_val * F31_dir) / m1;
    a2 = (F23_val * F23_dir - F12_val * F12_dir) / m2;
    a3 = (F31_val * F31_dir - F23_val * F23_dir) / m3;
    
    pos1 = pos1 + v1 * dt + 0.5 * a1 * dt ^ 2;
    pos2 = pos2 + v2 * dt + 0.5 * a2 * dt ^ 2;
    pos3 = pos3 + v3 * dt + 0.5 * a3 * dt ^ 2;
    pos = [0,0,0];
    
    v1 = v1 + a1 * dt;
    v2 = v2 + a2 * dt;
    v3 = v3 + a3 * dt;
    
    %%draw animation
    frame = frame + 1;
    if frame == 500
        frame = 0;
        
        set(planet1, 'Xdata', pos1(1) - pos(1), 'Ydata', pos1(2) - pos(2), 'Zdata', pos1(3) - pos(3));
        set(planet2, 'Xdata', pos2(1) - pos(1), 'Ydata', pos2(2) - pos(2), 'Zdata', pos2(3) - pos(3));
        set(planet3, 'Xdata', pos3(1) - pos(1), 'Ydata', pos3(2) - pos(2), 'Zdata', pos3(3) - pos(3));
        
        addpoints(h1, pos1(1) - pos(1), pos1(2) - pos(2), pos1(3) - pos(3));
        addpoints(h2, pos2(1) - pos(1), pos2(2) - pos(2), pos2(3) - pos(3));
        addpoints(h3, pos3(1) - pos(1), pos3(2) - pos(2), pos3(3) - pos(3));
        
        drawnow
    end
    
end