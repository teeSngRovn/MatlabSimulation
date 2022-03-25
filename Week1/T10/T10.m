x = [-1:0.0001:1];
freq = 1 - abs(x);
freq = freq / sum(freq);
X = randsrc(100,10000,[x;freq]);
Y = sum(X);
NormX = [-100:0.0001:100];
VAR = var(Y);
MEAN = mean(Y);
NormY = 1/sqrt(2*pi*VAR).*exp(-(NormX-MEAN).^2./(2*VAR));

edge = [-100:1:100];

%----------------plot---------------%
hold on;
histogram(Y,edge,'Normalization','probability');
plot(NormX,NormY);

