% Updates the specified axis to show an obj file

function plotOBJ(UIAxes, vertices, facets)
    %scatter3(UIAxes, vertices(:,1), vertices(:,2), vertices(:,3),10, 'k', 'filled');
    patch(UIAxes,'Faces',facets,'Vertices',vertices,'FaceColor','Blue','EdgeColor','k','Linestyle',':');
end