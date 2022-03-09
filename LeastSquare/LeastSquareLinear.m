clear
clc
x = [1, 2, 3, 4, 5, 6, 7];
y = [1.2 ,2.3 ,3.4, 4.5, 4.5, 6.7, 8.9];

linear = polyfit(x, y, 2);
print(linear);
Polynomial = polyval(linear, x);

plot(x, y, 'o', x, Polynomial, '-');