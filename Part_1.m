%% Breathing lab - Part one
clc
clear
close all

% Load data
data_set = load('Part1_recording.mat');
air_flow = data_set.data(:,1);
air_volume = data_set.data(:,2);

% Set subject details
age = 25; % years
height = 171; % cm


% Calculating RV and VC using known approximations
Expected_RV = (19.7*height + 20.1*age - 2421)/1000; % Liter 
Expected_VC = (0.052*height - 0.022*age - 3.6); % Liter 

%% Calculate volumes and capacities from the spirometry test

% RV
RV = min(air_volume); % Liter

% TLC
TLC = max(air_volume); % Liter

% VC
VC = TLC - RV; % Liter

% Identify peaks, in order to calculate RV, ERV and IRV
min_points_ind = find(islocalmin(air_volume,'MinSeparation',300));
max_points_ind = find(islocalmax(air_volume,'MinSeparation',300));

min_points = air_volume(min_points_ind);
max_points = air_volume(max_points_ind);

% TV - mean and std
tidal_volumes = max_points(1:5) - min_points(1:5);

TV = mean(tidal_volumes);

TV_STD = std(tidal_volumes);

% The last normal breathes were not taken because they are affected by the
% 'recovery' from the forced inhale and exhale

% IRV - mean and std
inspiratory_residual_volumes = TLC - max_points(1:5);

IRV = mean(inspiratory_residual_volumes);

IRV_STD = std(inspiratory_residual_volumes);


% ERV - mean and std
expiratory_residual_volumes = min_points(1:5) - RV;

ERV = mean(expiratory_residual_volumes);

ERV_STD = std(expiratory_residual_volumes);

% IC
IC = TV + IRV;

% EC 
EC = TV + ERV;

% FRC
FRC = RV + ERV;


%% Show a spectrogram of the signal

fs = 100; % Hz

figure(1)

spectrogram(air_volume - mean(air_volume),140,100,10000,fs);

title('Spectrogram of air volume measured in the spiromtry test')
xlim([0 5])


