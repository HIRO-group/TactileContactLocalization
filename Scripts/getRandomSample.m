% Takes in a patch data set and returns a random point on the associated patch

function [randPoint] = getRandomSample(data)
% Sample 100 random points from the vertices data
    verts = data.Vertices;
    faces = data.Faces;
    
    % pick a random face
    randFace = faces(randi([1, height(faces)]),:);

    % now find and store the vertices associated with the face
    vertSet = verts(randFace,:);

    % remove one of the vertices, with the smallest value b/w
    currMin = intmax;
    for i = 1:width(vertSet)
        currI = vertSet(i,:);
        for j = 1:width(vertSet)
            if i ~= j
                currJ = vertSet(j,:);
                % now subtract them
                currVal = sum(abs(currI - currJ));
                if currVal < currMin
                    currMin = currVal;
                    minI = i;
                    minJ = j;
                end
            end
        end
    end

    % now remove j from set
    newVertSet = [];
    for i = 1:width(vertSet)
        if i ~= minJ
            newVertSet = [newVertSet; vertSet(i,:)];
        end
    end
    
    % now interpolate a random % along the difference b/w the two sets
    diff = newVertSet(2,:) - newVertSet(1,:);
    % direction vector to move in, randomly
    diff = diff;

    randPoint = rand*diff + newVertSet(1,:);
end

