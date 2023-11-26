%This map plots all the read data points with a color associated with a
%single sensor 

function plotPLMap(UIAxes, touchData, sensorNum)
    %Plot the obj file 
    plotOBJ(UIAxes, touchData.obj.v, touchData.obj.f);
    hold(UIAxes, 'on');
    axis(UIAxes, 'equal');
    colormap(UIAxes, "hot");
    %Plot the touch locations
    scatter3(UIAxes, touchData.LIN.touchPos(:,1), touchData.LIN.touchPos(:,2), touchData.LIN.touchPos(:,3), 200, touchData.LIN.sensorStateAvg(:,sensorNum), 'filled');

    hold(UIAxes, 'off');
end