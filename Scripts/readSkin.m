% Reading in skin sensor the data 

% Inputs:
% skinObj -> Serial Port Connection to arduino

%Outputs:
% dataClean -> [1xn] vector of reported sensor values
% NOTE: It wont always necessarily return the same value of inputs as
% number of sensors. This handles incomplete sensor value reports from the
% arduino by returning whatever it did find. Make sure to account for this
% when recording data

function dataClean = readSkin(skinObj)

    data = readline(skinObj);
    seperatedData = split(data, ',');
    dataClean = zeros(1, length(seperatedData));
%     if length(dataClean) > 
%         error("Unexpected read size!");
%     end
    for i = 1:length(dataClean)

        val = str2double(seperatedData(i));
        if ~isnan(val)
            dataClean(i) = val;
        end
    end
    %If time is included in the measurement
    %skinObj.UserData.Time = str2double(seperatedData(end));
end