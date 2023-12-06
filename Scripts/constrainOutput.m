function predFinal = constrainOutput(pred, points)
%CONSTRAINOUTPUT This function will take a prediction from the ML model and
%constrain the output to be one of the points located in the variable
%points. It will iterate through the points and determine the closest point
%to the prediction

    % Create matrix of the prediction
    predMat = pred .* ones(length(points(:,1)), 3);

    % Difference matrix of the discretized points and the prediction
    diffMat = abs(points - predMat);

    % Minimize the total distance between the prediction and the
    % discretized surface
    totalDist = vecnorm(diffMat,2,2);
    [~,ind] = min(totalDist);

    % Get the new prediction
    predFinal = points(ind);

end

