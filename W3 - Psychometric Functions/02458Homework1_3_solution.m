%%% psychometric function %%%

x = [.4 .9 1.2 1.7 2.3];
N = 50;
u = 1.5;
sigma = .5;

PC = normcdf((x-u)/sigma);


%CountObs = binornd(ones(size(PC))*N,PC);
%fix
CountObs = [1     6    13    32    49];
PObs = CountObs/ N;

close all
figure
subplot(1,2,1)

plot(x,PC);
hold on
plot(x,PObs,'r');

subplot(1,2,2)
plot(x,norminv(PObs),'r')

% y=[x 1] [b1 b2]'

xx = [x; ones(size(x))]';
b = inv(xx'*xx)*xx'*norminv(PObs)';

sigma_est = 1/b(1)
u_est = -b(2)*sigma

%%% d' for intensity 1 vs 2? (2-1)/sigma = 2;

d_prime = (2-1)/sigma_est