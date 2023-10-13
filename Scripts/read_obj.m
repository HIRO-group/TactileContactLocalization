function [facets, vertices] = read_obj(fileName)
%     Description:
%     This function reads an obj file and outputs the faces and vertex information. The shape model is
%     then plotted for visualization. It is assumed that the vertices are listed first, and start on line 1,
%     followed directly by the facets with no blank lines between.
%     Inputs:
%     fileName - file name of obj file
%     Outputs:
%     faces - [n x 3] matrix of vertices that form each face verts - [m x 3] matrix of vertex locations in
%     implied body frame

% Author: Carson Kohlbrenner
% Date: 4/7/23
    
    % Open the file for reading
    fid = fopen(fileName);
    
    % Read the file using textscan
    data = textscan(fid, '%s', 'delimiter', '\n');
    data = data{1};

    %Remove all the data that starts with a comment
    data = data(cellfun(@(s)isempty(regexp(s,'#', 'once')),data));

    %Sort data into vertice and facet matrices
    dataF = data(cellfun(@(s)isempty(regexp(s,'v', 'once')),data));
    dataV = data(cellfun(@(s)isempty(regexp(s,'f', 'once')),data));
    
    %Remove v and f from cells
    vertices = cellfun(@(x) sscanf(x, '%*s %f %f %f')', dataV, 'UniformOutput', false);
    facets = cellfun(@(x) sscanf(x, '%*s %f %f %f')', dataF, 'UniformOutput', false);
    
    %Convert to an array
    vertices = vertcat(vertices{:});
    facets = vertcat(facets{:});

    % Close the file
    fclose(fid);
end