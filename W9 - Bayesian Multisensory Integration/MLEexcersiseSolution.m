clear

xA = load('xAlapse.txt');
xV = load('xVlapse.txt');
xAV = load('xAVlapse.txt');


%% histograms
figure
histogram(xA,10,'Normalization','pdf','FaceColor','r')
hold on
histogram(xV,10,'Normalization','pdf','FaceColor','g')
histogram(xAV,10,'Normalization','pdf','FaceColor','b')

%% estimate params
params0 =[mean(xA) std(xA) mean(xV) std(xV)];

[optparams,fval] = fminunc(@ (x) errorfun(x,xA,xV,xAV),params0);


%% plot model pdfs
x =-50:.1:30;

muAest = optparams(1); muVest = optparams(3);
sigmaAest = optparams(2); sigmaVest = optparams(4);
sigma2Aest = optparams(2)^2; sigma2Vest = optparams(4)^2;


wAest = sigma2Vest / (sigma2Aest + sigma2Vest);
muAVest =  wAest*muAest + (1-wAest)*muVest;
sigmaAVest =sqrt(sigma2Aest*sigma2Vest/(sigma2Aest+sigma2Vest));


plot(x,normpdf(x,muAest,sigmaAest),'r');
plot(x,normpdf(x,muVest,sigmaVest),'g');
plot(x,normpdf(x,muAVest,sigmaAVest),'b');

%% empirical estimates
optparams
[mean(xA) std(xA) mean(xV) std(xV)]


function negLL = errorfun(params, xA, xV, xAV)

sigmaA = params(2);
sigmaV = params(4);
sigma2A = params(2)^2;
sigma2V = params(4)^2;

muA = params(1);
muV=params(3);

wA = sigma2V / (sigma2A + sigma2V);

muAV = wA*muA + (1-wA)*muV;
sigmaAV = sqrt(sigma2A*sigma2V/(sigma2A+sigma2V));

negLL = -sum(log(normpdf(xA,muA,sigmaA))) - sum(log(normpdf(xV,muV,sigmaV))) - sum(log(normpdf(xAV,muAV,sigmaAV)));


end
