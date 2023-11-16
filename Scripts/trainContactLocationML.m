% Use this function to take in the data selected in the Train_Model_Window
% and return a fully built ML model that predicts contact location

%%%%%%%% INPUTS %%%%%%%%%%
% touchData ->  Data object with all data about sensor values and touch
%               positions

%%%%%%%% OUTPUTS %%%%%%%%%
% model ->      a matlab model object that takes in sensor states and returns a
%               location prediction

function model = trainContactLocationML(touchData)

    % Point Log Data: Sensor data from touching a location on the object
    % >> touchData.PL ->                   [1xn] vector of all Point Log data sets
    % >>>> touchData.PL.touchPos ->        [x,y,z] location of touch
    % >>>> touchData.PL.sensorStateRaw ->  [nxm] vector of all sensor data where n = sample size of point log and m = number of sensors
    % >>>> touchData.PL.sensorStateAvg ->  [1xm] vector of the averages of sensor data by sample size where m = number of sensors

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
    for i = 1:numTouches
        touchPosMat(i,:) = touchData.PL(i).touchPos;   
        sensorStateMat(i,:) = touchData.PL(i).sensorStateAvg;
    end

    % Create the neural net model
    % net = trainNetwork(features,layers,options) trains a neural network for feature classification 
    % or regression tasks (for example, a multilayer perceptron (MLP) neural network) 
    % using the feature data and responses specified by features.

    

    model = trainNetwork(features,layers,options);

end
