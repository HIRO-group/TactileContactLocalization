%% Script to test the linear regression machine learning functionality
close all; clear; clc;


%% fitlm
% The last column in the dataset array is the response variable
% Right now I think you can only have one response variable so we will have
% three models with x, y, and z as the response variables

% Number of samples and sensors
numSamples = 1000;
numSensors = 100;

predictVars = rand(numSamples, numSensors);
responseVars = linspace(1,5,numSamples)';

mdl = fitlm(predictVars, responseVars);







