% Scales the plot limits based on the data file

function plotOBJ(app, currData)
    currMin = [realmax('double'), realmax('double'), realmax('double')]; 
    currMax = [realmin('double'), realmin('double'), realmin('double')];
    if min(currData.XData,[],'All') < currMin(1)
        currMin(1) = min(currData.XData,[],'All');
    end
    if min(currData.YData,[],'All') < currMin(2)
        currMin(2) = min(currData.YData,[],'All');
    end
    if min(currData.ZData,[],'All') < currMin(3)
        currMin(3) = min(currData.ZData,[],'All');
    end
    if max(currData.XData,[],'All') > currMax(1)
        currMax(1) = max(currData.XData,[],'All');
    end
    if max(currData.YData,[],'All') > currMax(2)
        currMax(2) = max(currData.YData,[],'All');
    end
    if max(currData.ZData,[],'All') > currMax(3)
        currMax(3) = max(currData.ZData,[],'All');
    end
    
    app.UIAxes.XLim = [currMin(1) - abs(.1*currMin(1)), currMax(1) + abs(.1*currMax(1))];
    app.UIAxes.YLim = [currMin(2) - abs(.1*currMin(2)), currMax(2) + abs(.1*currMax(2))];
    app.UIAxes.ZLim = [currMin(3) - abs(.1*currMin(3)), currMax(3) + abs(.1*currMax(3))];
end