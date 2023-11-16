%% Clean
close all; clear; clc;

%% Import 
load('Training_Data_ConeSkinData_RND_9PL_2.mat');

% Extrapolate sensor data
% Clean the data for when the sensor data is incomplete
i = 1;
while(i < length(touchData.PL))
   if(isempty(touchData.PL(i).sensorStateAvg))
       touchData.PL(i) = []; %Delete the row of data
       continue;
   end        
   i = i + 1; %Update iteration
end

% Clean data number of touches
numTouches = length(touchData.PL);     

% Get the x, y, and z touch positions in a matrix
% Get the sensor data in a matrix
touchPosMat = zeros(numTouches, 3);
sensorStateMat = zeros(numTouches, length(touchData.PL(1).sensorStateAvg));
distanceMat = zeros(numTouches, length(touchData.PL(1).sensorStateAvg));

% Capacitcance to distance
epsilon = 1;
area = 1;

for i = 1:numTouches
    touchPosMat(i,:) = touchData.PL(i).touchPos;   
    sensorStateMat(i,:) = touchData.PL(i).sensorStateAvg;
    distanceMat(i,:) = epsilon * area ./ sensorStateMat(i,:);
end


%% For loop test
numSensors = length(sensorStateMat(1,:));
stepSize = 0.0001;

% Max and minimum values
xMin = min(touchPosMat(:,1));
xMax = max(touchPosMat(:,1));

yMin = min(touchPosMat(:,2));
yMax = max(touchPosMat(:,2));

zMin = min(touchPosMat(:,3));
zMax = max(touchPosMat(:,3));


% Loop through all sensors
test = 0;
for j = 1:numSensors
    % Measurements for a given sensor
    sensorMeas = distanceMat(:,j);

    % For a given sensor, loop through all touch positions
    for i = 1:numTouches
        currTouch = touchPosMat(i,:);

        minDist = 99999;
        for x = xMin:stepSize:xMax
            for y = yMin:stepSize:yMax
                for z = zMin:stepSize:zMax

                end
            end
        end
    end
end













