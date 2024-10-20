%Finds the SNR of the touchdata

function avgSNR = evalSNR(touchData)
    touchData.CPL.std = std(touchData.CPL.sensorStateRaw, 0, 1);

    for i = 1:touchData.numSensors
        touchData.SNR(i) = 20*log10(max(touchData.LIN.sensorStateAvg(:, i))/touchData.CPL.std(i));
    end

    avgSNR = mean(touchData.SNR);
end