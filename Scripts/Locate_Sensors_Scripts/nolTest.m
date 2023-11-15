function [locationEstimate] = nolTest(touchData)
% Input: touchData
% Output: locationEstimate, a [nx3] array containing a estimate xyz
% location for each n sensor

    numSensor = touchData.numSensors; 
    numTouch = width(touchData.PL);

    locationEstimate = zeros(0,3);

    % get the min and max x y and z
    xLim = [min(touchData.obj.v(:,1)), max(touchData.obj.v(:,1))];
    yLim = [min(touchData.obj.v(:,2)), max(touchData.obj.v(:,2))];
    zLim = [min(touchData.obj.v(:,3)), max(touchData.obj.v(:,3))];

    numIterations = 100;

    xMat = linspace(xLim(1), xLim(2), numIterations);
    yMat = linspace(yLim(1), yLim(2), numIterations);
    zMat = linspace(zLim(1), zLim(2), numIterations);

    [ii,jj,kk]=meshgrid(xMat,yMat,zMat);
    ii=permute(ii,[1 3 2]);
    jj=permute(jj,[2 1 3]);
    kk=permute(kk,[3  2 1]);
    allCombos=[ii(:) jj(:) kk(:)];

    % now test which combo minimizes the distance function 
    dFunc = @(x,y,z,a,b,c) sqrt((x-a).^2 + (y-b).^2 + (z-c).^2);

    for n = 1:numSensor
        difference = zeros(numIterations*numIterations*numIterations,1);
        for i = 1:numTouch
            dMeasure = 160/touchData.PL(i).sensorStateAvg(n); % current distance data for sensor n at touch i
            touchPos = touchData.PL(i).touchPos;

            % call dFunction for every touch
            dCalc = dFunc(allCombos(:,1), allCombos(:,2), allCombos(:,3), touchPos(1), touchPos(2), touchPos(3));
            difference = (abs(dCalc - dMeasure)).^2 + difference;
        end
        % find the index in which minimum difference occurs
        indexMin = find(difference == min(difference));
        % get that xyz position
        xyzCurr = allCombos(indexMin,:);
        % store that xyz location in sensor location vector
        locationEstimate(n,:) = xyzCurr;
    end
        
    test = 1;

end

