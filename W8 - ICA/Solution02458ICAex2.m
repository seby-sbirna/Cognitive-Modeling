mu = 0; b = 1; 

%orignial distribution
close all, clear

S = randlpl(0,1,2,1e4);
S = S ./ repmat(sqrt(var(S')'),[1 1e4]); %normalize S. As S will be estimated with unit variance the entire variance lies in the independent components. 

A = rand(2);
%A=[1 rho;0 sqrt(1-rho^2)];
X=A*S;

subplot(1,3,1)
plot(S(1,:),S(2,:),'.')
axis square

%PCA
%[Coeff, Score] = princomp(X);
%plot(Score(:,1),Score(:,2),'x')
%axis square

subplot(1,3,2)
plot(X(1,:),X(2,:),'.')
axis square

%ICA
[Sest, Aest, West] = fastica(X);

subplot(1,3,3)
plot(Sest(1,:),Sest(2,:),'.')
axis square

