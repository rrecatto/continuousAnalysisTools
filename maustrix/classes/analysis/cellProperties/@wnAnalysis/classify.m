function out = classify(s,requested)
out = {};
if ischar(requested)
    requested = {requested};
end
sm = whiteNoise;
[mean std] = getMeanLuminanceAndStd(sm,s.stimInfo);
white = whiteVal(sm);
meanValue = mean*white;
for i = 1:length(requested)
    switch requested{i}
        case 'ONOFFDerivative' % looks at the derivative of the STA
            maxPos = findPixel(s,'maxSTA');
            minPos = findPixel(s,'minSTA');
            % find derivative
            derMax = diff(squeeze(s.STA(maxPos(1),maxPos(2),:)));
            derMin = diff(squeeze(s.STA(minPos(1),minPos(2),:)));
            [maxDerInMax] = max(abs(derMax));
            [maxDerInMin] = max(abs(derMin));
            if maxDerInMax>maxDerInMin
                out{end+1} = 'ON';
            else
                out{end+1} = 'OFF';
            end
        case 'ONOFFTotWt' % looks at the weight on the lobes
            sm = whiteNoise;
            maxPos = findPixel(s,'maxSTA');
            minPos = findPixel(s,'minSTA');
            sumAbsMax = sum(abs(squeeze(s.STA(maxPos(1),maxPos(2),:))-meanValue));
            sumAbsMin = sum(abs(squeeze(s.STA(minPos(1),minPos(2),:))-meanValue));
            if sumAbsMax>sumAbsMin
                ON = sum(squeeze(s.STA(XMax,YMax,:))-meanValue)>0;
            else
                ON = sum(squeeze(s.STA(XMin,YMin,:))-meanValue)>0;
            end
            if ON
                out{end+1} = 'ON';
            else
                out{end+1} = 'OFF';
            end
        case 'ONOFFFirstSigDef'
            whichPos = findPixel(s,'maxDeviation');
            allowedTimes = linspace(-s.timeWindow(1),s.timeWindow(2),length(s.STA(1,1,:)))<0;
            allowedSTA = s.STA(whichPos(1),whichPos(2),allowedTimes)-meanValue;
            allowedCI95= sqrt(s.STV(whichPos(1),whichPos(2),allowedTimes)/s.numSpikes)*1.96;
            whichFirstSig = max(find(abs(allowedSTA)-allowedCI95>0));
            if allowedSTA(whichFirstSig>0)
                out{end+1} = 'ON';
            else
                out{end+1} = 'OFF';
            end
        case 'ONOFFMaxDev'
            whichPos = findPixel(s,'maxDeviation');
            temporal = getTemporal(s,whichPos)-meanValue;
            criterion = abs(max(temporal))>abs(min(temporal));
            switch criterion
                case true
                    out{end+1} = 'ON';
                case false
                    out{end+1} = 'OFF';
            end
        otherwise
            error('unknown classification method requested');
    end
end
end
