% This function takes the full number of discrete points of the surface and
% discretizes it evenly into discPoints based on the number of samples


function discPoints = discSurface(points, numSamples)

    % Get half of the points since it repeats
    rows = length(points(:,1));
    newLength = round(rows/2);
    points = points(1:newLength, :);

    % Number of points to iterate through
    numIterate = round(newLength / numSamples);

    % Discretize
    discPoints = points(1:numIterate:newLength, :);

end

