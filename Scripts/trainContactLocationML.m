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

    numTouches = length(touchdata.PL);      % Number of touches
    %Thomas branch test





end
