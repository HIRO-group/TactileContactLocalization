%Produces a sensor image heatmap

function sensorImage(touchData)
    count = 1;
    cData = zeros(touchData.numTX, touchData.numRX);
    %Format the data
    for t = 1:touchData.numTX
        for r = 1:touchData.numRX
            cData(t,r) = touchData.LIN.sensorStateAvg(24,count);
            count = count + 1;
        end
    end

    f = figure();

    %title("Example Sensor Image")
    heatmap(cData, 'Colormap', hot, 'Title', 'Example Sensor Image', 'XLabel', "Transmitter Wire Number (TX)", 'YLabel', "Receiver Wire Number (RX)");
    annotation('textarrow',[0.96,1],[0.5,0.5],'string','Sensor Value', ...
      'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90);
end