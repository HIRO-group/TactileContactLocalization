%Produce a graph of the SNR values for each different set

clc; close all; clear;

% Specify the directory containing the .m files
directoryPath = "../Training_Data"; % Change this to your directory path

% Get a list of all .m files in the directory
files = dir(fullfile(directoryPath, '*.mat'));

SNR = zeros(1,length(files));
PLs = zeros(1,length(files));

% Loop through each file and load it
for k = 1:length(files)
    % Construct the full file path
    filePath = fullfile(directoryPath, files(k).name);
    
    % Load the .m file
    % Note: This will just run the script. If the .m files are functions,
    % you will need to call them with appropriate arguments.
    load(filePath);

    SNR(k) = mean(evalSNR(touchData));
    PLs(k) = length(touchData.PL);
end

figure();
hold on;
grid on;
scatter(PLs, SNR, 'k', 'filled');
title("Average Sensor SNR per Contact Model");
xlabel("Point Logs Used for Training");
ylabel("Average SNR (dB)");
hold off;