%% Part 3 - Our application

% This code loads a signal containing the temperature of the subjects breath,
% and calculates a slope that represents the pace of the rise of temperature
% when the subject exhales air. The slope that was calculated is used to 
% determine the probability that the subject suffers from asthma or other
% inflammatory airway disease.

clc
clear
close all

% Set sample frequency
fs = 100;

% Load data

signal_data = load('Free_T1.mat'); % Insert file name here
signal_temp = table2array(signal_data.data.record(:,2));

% Using HPF to overcome baseline wander
signal_temp = highpass(signal_temp,0.2,fs);

% Set time vector
t = (0:length(signal_temp)-1)/fs;

plot(t,signal_temp)


% Finding temperature peaks 
prominence = 0.25*(max(signal_temp) - min(signal_temp));
[peaks,locs] = findpeaks(signal_temp,'MinPeakProminence',prominence);


% Compute slope of the temperature
slopes = [];
slope_counter = 1;

for i = 2:length(peaks)
    
    peak_ind = locs(i);
    peak_value = peaks(i);
    check_window = signal_temp(1:peak_ind);
    
    % Find index of the last time reaching zero before peak
    a_ind = find(check_window<=0);
    a_ind = a_ind(end);
    
    % Find index of the last time reaching 63% of the peak before the peak
    b_ind = find(check_window<=(0.63*peak_value));
    b_ind = b_ind(end);
    
    if (peak_ind-a_ind)<(peak_ind-locs(i-1))
        if peak_value > 0.25
        
            % Slope = delta temp/delta time
            slope = (0.63*peak_value)/(t(b_ind) - t(a_ind)); % delta C/sec
        
            slopes(slope_counter) = slope;
        
            slope_counter = slope_counter + 1;
            
        end
    end
end


% Computing the mean and std of slopes calculated 
mean_slope = mean(slopes);
STD_slope = std(slopes);


% hypothetically, we would now check calculated mean temperature rise rate,
% and compare it to a threshold to decide if the subject is at risk of
% having asthma, or other airway inflammatory disease.



