%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aleksander Frese (s163859), Sebastian Sbirna (s190553)
% Homework 2, Part 2, Question 3
% 13 0CT 2019
% Supervisor: Tobias Andersen
% 02458 Cognitive Modeling
% Technical University of Denmark (DTU)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc;
clearvars;
%format longG
%format long g;
%format bank

%%%%%% GENERATING

a = rand(1,1000)*100; % sample 1000 numbers randomly from a uniform dist. - fruit determination
b = rand(1,1000)*100; % sample 1000 numbers randomly from uniform dist. - state determination
fruits = zeros(1,1000); % list of fruits, 1 = juju, 2 = mongo, 3 = chakava
state = zeros(1,1000); % list of fruit states (ripe, unripe), 0 = unripe, 1 = ripe
wl = zeros(1,1000); % list of wavelengths (emitted by each fruit)
ripe_probs = zeros(1,1000); % list of ripe probabilities (of each fruit being ripe)
monkey_picks = zeros(1,1000); % list of fruits that the monkey picks, 1 = picked

% def standard deviations
juju_std = 50;
mongo_std = 20;
chak_std = 100;

% def mean for different states
juju_ripe = 600;
juju_unripe = 500;
mongo_ripe = 580;
mongo_unripe = 520;
chak_ripe = 400;
chak_unripe = 550;

% determine the fruit, given the proability distributions for the fruits
% juju = 10%, mongo = 50%, chakava = 40%
% determine fruit state (ripe vs unripe)
for idx = 1:numel(a)
    val = a(idx); % determine fruit
    if val >= 0 && val < 10 % fruit is juju, 10% probability range
        fruits(idx) = 1;
        val2 = b(idx); % determine state
        if val2 >= 0 && val2 < 15 % ripe juju
            state(idx) = 1;
            wl(idx) = generateWl(juju_ripe, juju_std); % generate juju with ripe wl
        else
            wl(idx) = generateWl(juju_unripe, juju_std); % generate juju with unripe wl
        end
    elseif val >= 10 && val < 60 % fruit is mongo, 50% prob range
        fruits(idx) = 2;
        val2 = b(idx); % determine state
        if val2 >= 0 && val2 < 80 % ripe mongo
            state(idx) = 1;
            wl(idx) = generateWl(mongo_ripe, mongo_std); % generate mongo with ripe wl
        else
            wl(idx) = generateWl(mongo_unripe, mongo_std); % generate mongo with unripe wl
        end
    else % fruit is chakava, 40% prob range
        fruits(idx) = 3;
        val2 = b(idx); % determine state
        if val2 >= 0 && val2 < 10 % ripe chakava
            state(idx) = 1;
            wl(idx) = generateWl(chak_ripe, chak_std); % generate chakava with ripe wl
        else
            wl(idx) = generateWl(chak_unripe, chak_std); % generate chakava with unripe wl
        end
    end
end

%%%% at this point we have all fruits, states and wavelenghts
% testing
%n1 = sum(fruits==1);
%n2 = sum(fruits==2);
%n3 = sum(fruits==3);
%fprintf('%d appears %d times\n',1,n1);
%fprintf('%d appears %d times\n',2,n2);
%fprintf('%d appears %d times, which is %d percent\n',3,n3,(n3*100/1000));

%%%%%% FRUIT PICKING

for idx = 1:numel(wl)
    val = wl(idx);
    val_ceil = val + 5; % the monkey can identify the wavelength with +/- 5 nm accuracy, so from the monkey's POV it needs to evaluate a spectrum of wavelengths, not an single wavelength value
    val_floor = val - 5; % the monkey can identify the wavelength with +/- 5 nm accuracy, so from the monkey's POV it needs to evaluate a spectrum of wavelengths, not an single wavelength value
    ripe_probs(idx) = probRipe(val_ceil, val_floor, fruits(idx)); % get probability of fruit being ripe
    if ripe_probs(idx) >= 0.5 % if the fruit reflecting light of a wavelength in the given spectrum has a 50% or higher probability of being ripe, then the monkey picks the fruit
        monkey_picks(idx) = 1;
    end
end


%%%%% VALIDATION
% how many ripe fruits did the monkey pick?
% how many ripe fruits did the monkey leave?
% how many unripe fruits did the monkey pick?
% how many unripe fruits did the monkey leave?
ripes = sum(state==1);
unripes = sum(state==0);
ripe_picks = 0;
ripe_leave = 0;
unripe_picks = 0;
unripe_leave = 0;
for idx = 1:numel(fruits)
    if state(idx) == 1 && monkey_picks(idx) == 1
        ripe_picks = ripe_picks + 1;
    elseif state(idx) == 1 && monkey_picks(idx) == 0
        ripe_leave = ripe_leave + 1;
    elseif state(idx) == 0 && monkey_picks(idx) == 1
        unripe_picks = unripe_picks + 1;
    elseif state(idx) == 0 && monkey_picks(idx) == 0
        unripe_leave = unripe_leave + 1;
    end
end

%ripe_picks_perc = num2str((ripe_picks./ripes)*100,'%.1f') ;
ripe_picks_perc = (ripe_picks./ripes)*100;
ripe_leave_perc = (ripe_leave./ripes)*100;
unripe_picks_perc = (unripe_picks./unripes)*100;
unripe_leave_perc = (unripe_leave./unripes)*100;

fprintf('There were %d ripe fruits\n',ripes);
fprintf('The monkey picked %d ripe fruits (%.1f percent of ripe fruits)\n',ripe_picks, ripe_picks_perc);
fprintf('The monkey left %d ripe fruits (%.1f percent of ripe fruits)\n',ripe_leave, ripe_leave_perc);
fprintf('There were %d unripe fruits\n',sum(state==0));
fprintf('The monkey picked %d unripe fruits (%.1f percent of unripe fruits)\n',unripe_picks, unripe_picks_perc);
fprintf('The monkey left %d unripe fruits (%.1f percent of unripe fruits)\n',unripe_leave, unripe_leave_perc);


%%%%% FUNCTIONS

% function to generate a wavelength for a fruit
% inspo: https://se.mathworks.com/help/matlab/math/random-numbers-with-specific-mean-and-variance.html
function wl = generateWl(wl_mean, wl_std)
    wl = wl_std.*randn() + wl_mean;
end

% function to calculate the probability of a fruit reflecting light in a
% given wavelength spectrum being ripe
% applying Bayes
function prob = probRipe(wl_ceil, wl_floor, fruit)
    % def standard deviations
    juju_std = 50;
    mongo_std = 20;
    chak_std = 100;

    % def mean for different states
    juju_ripe = 600;
    juju_unripe = 500;
    mongo_ripe = 580;
    mongo_unripe = 520;
    chak_ripe = 400;
    chak_unripe = 550;

    if fruit == 1 % juju
        mean_ripe = juju_ripe;
        mean_unripe = juju_unripe;
        std = juju_std;
        ripe = 0.1;
    elseif fruit == 2 % mongo
        mean_ripe = mongo_ripe;
        mean_unripe = mongo_unripe;
        std = mongo_std;
        ripe = 0.5;
    else
        mean_ripe = chak_ripe;
        mean_unripe = chak_unripe;
        std = chak_std;
        ripe = 0.4;
    end
    
    p_ripe = normcdf((wl_ceil-mean_ripe)/std) - normcdf((wl_floor-mean_ripe)/std); % normcdf is the same as getting the area under the curve to the left of the z-score
    p_unripe = normcdf((wl_ceil-mean_unripe)/std) - normcdf((wl_floor-mean_unripe)/std); % normcdf is the same as getting the area under the curve to the left of the z-score
    prob = (p_ripe*ripe)/(p_ripe*ripe+p_unripe*(1-ripe));
end