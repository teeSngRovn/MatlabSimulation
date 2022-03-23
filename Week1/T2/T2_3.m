figure;
hold on;
grid on;
ylabel('t^* / \circ','FontSize',12)
xlabel('t / \circC','FontSize',12)

t = (-100:0.5:500);
e = 0.21 * t - 10 ^ -4 * t.^2;
t1 = 5 * e;
axis([-100 500 -100 400])
plot(t, t1);