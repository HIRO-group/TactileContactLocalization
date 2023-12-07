% Discretize the surface of the obj file

% Inputs:
% f, v -> facets and vertices of the object

%Outputs:
% points -> [nx3] matrix of discrete surface points

function points = discretizeSurface(f, v)

    % Number of facets
    fnum = length(f(:,1));
    
    % Surface points
    pointsPerFacet = 100;
    points = zeros(140, 3);
    
    % Discretize the surface of the obj file
    verts = zeros(1,3);
    rowInd = 1;
    
    % Skip a certain amount of facets
    skipNum = 0; % One every 5
    boolTemp = 1;

    for i = 1:fnum
    
        indices = f(i,:);
    
        % Get the corresponding vertices
        v1 = v(indices(1), :);
        v2 = v(indices(2), :);
        v3 = v(indices(3), :);
    
        % Calculate which two are farther apart
        d1 = norm(v1 - v2);
        d2 = norm(v2 - v3);
        d3 = norm(v3 - v1);
    
        % Calculate which is the minimum
        [~, ind] = min([d1, d2, d3]);
    
        % Calculate the midpoint of the two vertices near each other
        % ind and ind2 are the close ones, ind3 is the far one
        if(ind == 3)
            ind2 = 1;
            ind3 = 2;
        elseif(ind == 2)
            ind2 = 3;
            ind3 = 1;
        else
            ind2 = 2;
            ind3 = 3;
        end
    
        midPoint = 0.5 * (v(indices(ind), :) + v(indices(ind2), :));
    
        % Interpolate
        thirdPoint = v(indices(ind3), :);
        xVals = linspace(midPoint(1), thirdPoint(1), pointsPerFacet);
        yVals = linspace(midPoint(2), thirdPoint(2), pointsPerFacet);
        zVals = linspace(midPoint(3), thirdPoint(3), pointsPerFacet);
    
        % Save values
        for j = 1:length(xVals)
            points(rowInd, :) = [xVals(j), yVals(j), zVals(j)];
            rowInd = rowInd + 1;
        end
    
    end

end

