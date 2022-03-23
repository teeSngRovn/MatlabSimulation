figure;
hold on;
grid on;
xlabel('t / \circC','FontSize',12)
ylabel('$\varepsilon$ / mV','interpreter','latex','FontSize',12)

x = (-100:0.5:500);
y = 0.21 * x - 10 ^ -4 * x.^2;
plot(x,y)