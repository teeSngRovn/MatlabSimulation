%----------data---------%
m1 = rand() * 10 ^ 23;
m2 = rand() * 10 ^ 23;
m3 = rand() * 10 ^ 23;
m4 = rand() * min([m1, m2, m3]) / 100;

pos1 = [rand() * 10 ^ 7, rand() * 10 ^ 7, rand() * 10 ^ 7];
pos2 = [rand() * 10 ^ 7, rand() * 10 ^ 7, rand() * 10 ^ 7];
pos3 = [rand() * 10 ^ 7, rand() * 10 ^ 7, rand() * 10 ^ 7];
pos4 = [rand() * 10 ^ 7, rand() * 10 ^ 7, rand() * 10 ^ 7];

v1 = [rand() * 1000, rand() * 1000, rand() * 1000];
v2 = [rand() * 1000, rand() * 1000, rand() * 1000];
v3 = [rand() * 1000, rand() * 1000, rand() * 1000];
v4 = [rand() * 1000, rand() * 1000, rand() * 1000];

G = 6.67 * 10 ^ -11;
dt  = 0.005;

%-------main-------%
figure
colordef black 
grid on
axis equal
view(3)
hold on

planet1 = plot3(pos1(1), pos1(2), pos1(3), 'b:.', 'markersize', 20);
planet2 = plot3(pos2(1), pos2(2), pos2(3), 'r:.', 'markersize', 20);
planet3 = plot3(pos3(1), pos3(2), pos3(3), 'y:.', 'markersize', 20);
planet4 = plot3(pos4(1), pos4(2), pos4(3), 'g:.', 'markersize', 20);

h1 = animatedline('color', 'b');
h2 = animatedline('color', 'r');
h3 = animatedline('color', 'y');
h4 = animatedline('color', 'g');

xlabel('X')
ylabel('Y')
zlabel('Z')


frame = 0;
while true
    %%big planet
    r12 = normest(pos2 - pos1);
    r23 = normest(pos3 - pos2);
    r31 = normest(pos1 - pos3);
    
    
    F12_val = G * m1 * m2 / (r12 ^ 2);
    F23_val = G * m2 * m3 / (r23 ^ 2);
    F31_val = G * m3 * m1 / (r31 ^ 2);
  
    
    F12_dir = (pos2 - pos1) / r12;
    F23_dir = (pos3 - pos2) / r23;
    F31_dir = (pos1 - pos3) / r31;
    
    a1 = ((F12_val * F12_dir) - (F31_val * F31_dir)) / m1;
    a2 = ((F23_val * F23_dir) - (F12_val * F12_dir)) / m2;
    a3 = ((F31_val * F31_dir) - (F23_val * F23_dir)) / m3;
    
    pos1 = pos1 + v1 * dt + 0.5 * a1 * dt ^ 2;
    pos2 = pos2 + v2 * dt + 0.5 * a2 * dt ^ 2;
    pos3 = pos3 + v3 * dt + 0.5 * a3 * dt ^ 2;
    
    v1 = v1 + a1 * dt;
    v2 = v2 + a2 * dt;
    v3 = v3 + a3 * dt;
    %%small planet
    r41 = normest(pos1 - pos4);
    r42 = normest(pos2 - pos4);
    r43 = normest(pos3 - pos4);
    
    F41_val = G * m4 * m1 / (r41 ^ 2);
    F42_val = G * m4 * m3 / (r42 ^ 2);
    F43_val = G * m4 * m3 / (r43 ^ 2);
    
    F41_dir = (pos1 - pos4) / r41;
    F42_dir = (pos2 - pos4) / r42;
    F43_dir = (pos3 - pos4) / r43;
    
    a4 = ((F41_val * F41_dir) + (F42_val * F42_dir) + (F43_val * F43_dir)) / m4;
    
    pos4 = pos4 + v4 * dt + 0.5 * a4 * dt ^ 2;
    
    v4 = v4 + a4 * dt;
    
    %%draw animation
    frame = frame + 1;
    if frame == 5000
        frame = 0;
        
        set(planet1, 'Xdata', pos1(1), 'Ydata', pos1(2), 'Zdata', pos1(3));
        set(planet2, 'Xdata', pos2(1), 'Ydata', pos2(2), 'Zdata', pos2(3));
        set(planet3, 'Xdata', pos3(1), 'Ydata', pos3(2), 'Zdata', pos3(3));
        set(planet4, 'Xdata', pos4(1), 'Ydata', pos4(2), 'Zdata', pos4(3));
        
        addpoints(h1, pos1(1), pos1(2), pos1(3));
        addpoints(h2, pos2(1), pos2(2), pos2(3));
        addpoints(h3, pos3(1), pos3(2), pos3(3));
        addpoints(h4, pos4(1), pos4(2), pos4(3));
        
        drawnow
    end
    
    if r12 == 0 || r23 == 0 || r31 == 0
        break
    end
end