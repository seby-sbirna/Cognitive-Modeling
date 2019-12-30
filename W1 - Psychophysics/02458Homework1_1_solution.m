%% plot stevens law
c1 = 10; exponent = .33;
c1 = 0.00015; exponent = 3.3;

Intensity = 0:1e-2:10;
plot(Intensity, c1*Intensity.^exponent)
hold on

%plot samples from stevens law
MeasurementPoints = 1:1:10;
Measurements = c1*MeasurementPoints.^exponent;
plot(MeasurementPoints, Measurements,'x')

%% fit fechner's law
% FechnerError = @(x)sum(norm(x(1)*log(MeasurementPoints / x(2)) - Measurements));
% [xbestfit,error] = fminsearch(FechnerError,[1 10]);
% 
% k = xbestfit(1)
% threshold = xbestfit(2)

%% use pseudoinverse instead
A = [log(MeasurementPoints); ones(size(MeasurementPoints))]';
xbestfit=pinv(A)*Measurements'; %inv(A'*A)*A' could be used instead of pinv(A)

k = xbestfit(1)
threshold = exp(-xbestfit(2)/k)

%% plot it
plot(Intensity,k*log(Intensity/threshold),'r')
legend('Stevens','Measurements','Fechner fit')

