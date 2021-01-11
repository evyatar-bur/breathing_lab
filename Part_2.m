%% Part 2 
clc
clear
close all

% Load data
data_set_2 = load('Part2_recording.mat');

resperation = data_set_2.data(:,2);

fs = 1/((data_set_2.isi)*(10^-3));
t = (0:length(resperation)-1)/fs;

figure;
plot(t,resperation)

%% Section 1 - Resting state

% Insperation duration (calculated manually)

insp_durations = [2.69 2.4 2.2];

insp_duration = mean(insp_durations);
insp_STD = std(insp_durations);


% Experation duration (calculated manually)

exp_durations = [1.95 2.24 2.36];

experation = mean(exp_durations);
exp_STD = std(exp_durations);


% Total breathing cycles durations (calculated manually)


breath_durations = [4.91 4.89 4.87];

total_breath_duration = mean(breath_durations);
total_STD = std(breath_durations);

% Calculate resting respration_rate

respration_rates = (1./breath_durations).*60; % breath/minute

RR_rest = mean(respration_rates);
RR_rest_STD = std(respration_rates);


%% Section 2 - Breathing cycle durations and RRs

% Hyperventilation

peaks_hyper = findpeaks(resperation(1700:4220));

Hyper_breath_duration = ((4220-1700)/fs)/length(peaks_hyper);

Hyper_RR = 60/Hyper_breath_duration;

% Hypoventilation

peaks_hypo = findpeaks(resperation(7692:10600),'MinPeakProminence',0.5);

Hypo_breath_duration = ((10600-7692)/fs)/(length(peaks_hypo)+1);

Hypo_RR = 60/Hypo_breath_duration;

%% Cough and read

peaks_C_R = findpeaks(resperation(13760:16710),'MinPeakProminence',0.5);

C_R_breath_duration = ((16710-13760)/fs)/(length(peaks_C_R)+1);

C_R_RR = 60/C_R_breath_duration;



%% Section 3 - Computing coralation between signals

figure(1)
wcoherence(resperation(7700:9880),resperation(14540:16720),fs,'PhaseDisplayVector',1);
title('Cross spectrum of the hypoventilation section vs. the cough and read section')

figure;
wcoherence(resperation(1813:3993),resperation(14540:16720),fs,'PhaseDisplayVector',1);
title('Cross spectrum of the hyperventilation section vs. the cough and read section')



