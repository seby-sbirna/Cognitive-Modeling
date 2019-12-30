

%problem 1

prior_ripe = 0.15;
prior_unripe = 0.85;

%L for Likelihood
L_ripe = normcdf(550,600,50) - normcdf(540,600,50);
L_unripe = normcdf(550,500,50) - normcdf(540,500,50);

display('Answer to Problem 1')
post_ripe = L_ripe*prior_ripe / (L_ripe*prior_ripe + L_unripe*prior_unripe)

%problem 2
prior_juju_ripe = 0.1 * 0.15;
prior_juju_unripe = 0.1 * 0.85;
prior_mongo_ripe = 0.5 * 0.80;
prior_mongo_unripe = 0.5 * 0.20;
prior_chakava_ripe = 0.4 * 0.1;
prior_chakava_unripe = 0.4 * 0.9;

%L for Likelihood
L_juju_ripe     = normcdf(550,600,50)  - normcdf(540,600,50);
L_juju_unripe   = normcdf(550,500,50)  - normcdf(540,500,50);
L_mongo_ripe    = normcdf(550,580,20)  - normcdf(540,580,20);
L_mongo_unripe  = normcdf(550,520,20)  - normcdf(540,520,20);
L_chakava_ripe  = normcdf(550,400,100) - normcdf(540,400,100);
L_chakava_unripe= normcdf(550,550,100) - normcdf(540,550,100);

denominator = L_juju_ripe    * prior_juju_ripe + ...
              L_juju_unripe  * prior_juju_unripe + ...
              L_mongo_ripe   * prior_mongo_ripe + ...
              L_mongo_unripe * prior_mongo_unripe + ...
              L_chakava_ripe * prior_chakava_ripe + ...
              L_chakava_unripe * prior_chakava_unripe;
              

Post_juju_ripe = L_juju_ripe * prior_juju_ripe / denominator;
Post_mongo_ripe = L_mongo_ripe * prior_mongo_ripe / denominator;
Post_chakava_ripe = L_chakava_ripe * prior_chakava_ripe / denominator;

display('Answer to Problem 2')

Post_ripe = Post_juju_ripe + Post_mongo_ripe + Post_chakava_ripe

%problem 3


cumsumpriors = cumsum([prior_juju_ripe prior_juju_unripe ...
                       prior_mongo_ripe prior_mongo_unripe ...
                       prior_chakava_ripe prior_chakava_unripe]);
N_fruits = 1000;
R = rand(N_fruits,1);

%sample 1000 fruits (N_ is for number / count)
%we're sampling from the fruit / ripe priors
%this is basically drawing 1000 samples from a multinomial distribution
N_juju_ripe         = sum(R<cumsumpriors(1));
N_juju_unripe       = sum(R>cumsumpriors(1) & R<cumsumpriors(2));
N_mongo_ripe        = sum(R>cumsumpriors(2) & R<cumsumpriors(3));
N_mongo_unripe      = sum(R>cumsumpriors(3) & R<cumsumpriors(4));
N_chakava_ripe      = sum(R>cumsumpriors(4) & R<cumsumpriors(5));
N_chakava_unripe    = sum(R>cumsumpriors(5));

%each fruit reflects a wavelength sampled from the likelihood
w_juju_ripe         = randn(1,N_juju_ripe)*50+600;
w_juju_unripe       = randn(1,N_juju_unripe)*50+500;
w_mongo_ripe        = randn(1,N_mongo_ripe)*20+580;
w_mongo_unripe      = randn(1,N_mongo_unripe)*20+520;
w_chakava_ripe      = randn(1,N_chakava_ripe)*100+400;
w_chakava_unripe    = randn(1,N_chakava_unripe)*100+550;

w = [w_juju_ripe w_juju_unripe w_mongo_ripe w_mongo_unripe w_chakava_ripe w_chakava_unripe];

%the monkey's likelihood
%this is the same as in problem 1 and 2 only no longer is 540<w<550
%instead, we have a bunch of w's (wavelengths)
L_juju_ripe     = normcdf(w+5,600,50)  - normcdf(w-5,600,50);
L_juju_unripe   = normcdf(w+5,500,50)  - normcdf(w-5,500,50);
L_mongo_ripe    = normcdf(w+5,580,20)  - normcdf(w-5,580,20);
L_mongo_unripe  = normcdf(w+5,520,20)  - normcdf(w-5,520,20);
L_chakava_ripe  = normcdf(w+5,400,100) - normcdf(w-5,400,100);
L_chakava_unripe= normcdf(w+5,550,100) - normcdf(w-5,550,100);

%this part is copied directly from problem 2
denominator = L_juju_ripe    * prior_juju_ripe + ...
              L_juju_unripe  * prior_juju_unripe + ...
              L_mongo_ripe   * prior_mongo_ripe + ...
              L_mongo_unripe * prior_mongo_unripe + ...
              L_chakava_ripe * prior_chakava_ripe + ...
              L_chakava_unripe * prior_chakava_unripe;
             
%still copying from problem 2 - just remember element-wise operators
Post_juju_ripe = L_juju_ripe * prior_juju_ripe ./ denominator;
Post_mongo_ripe = L_mongo_ripe * prior_mongo_ripe ./ denominator;
Post_chakava_ripe = L_chakava_ripe * prior_chakava_ripe ./ denominator;

Post_ripe = Post_juju_ripe + Post_mongo_ripe + Post_chakava_ripe;

%apply the max arg aposteriori decision criterion
pickedfruits = (Post_ripe>.5);

display('Answer to Problem 3')
Indx = cumsum([1 N_juju_ripe N_juju_unripe N_mongo_ripe N_mongo_unripe N_chakava_ripe N_chakava_unripe]);

display(['number of ripe jujus: ' num2str(N_juju_ripe)]) 
display(['number of ripe jujus picked: ' num2str(sum(pickedfruits(Indx(1):Indx(2)-1)))]) 

display(['number of unripe jujus: ' num2str(N_juju_unripe)]) 
display(['number of unripe jujus picked: ' num2str(sum(pickedfruits(Indx(2):Indx(3)-1)))]) 

display(['number of ripe mongos: ',num2str(N_mongo_ripe)]) 
display(['number of ripe mongos picked: ' num2str(sum(pickedfruits(Indx(3):Indx(4)-1)))]) 

display(['number of unripe mongos: ',num2str(N_mongo_unripe)]) 
display(['number of unripe mongos picked: ' num2str(sum(pickedfruits(Indx(4):Indx(5)-1)))]) 

display(['number of ripe chakavas: ',num2str(N_chakava_ripe)]) 
display(['number of ripe chakavas picked: ' num2str(sum(pickedfruits(Indx(5):Indx(6)-1)))]) 

display(['number of unripe chakavas: ',num2str(N_chakava_unripe)]) 
display(['number of unripe chakavas picked: ' num2str(sum(pickedfruits(Indx(6):Indx(7)-1)))])


NumberOfRipeFruits = N_juju_ripe + N_mongo_ripe + N_chakava_ripe
NumberOfRipeFruitsPicked = sum(pickedfruits(Indx(1):Indx(2)-1)) + sum(pickedfruits(Indx(2):Indx(3)-1)) + sum(pickedfruits(Indx(3):Indx(4)-1))
NumberOfRipeFruitsPicked/NumberOfRipeFruits
