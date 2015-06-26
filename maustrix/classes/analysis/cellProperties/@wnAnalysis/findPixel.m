function out = findPixel(s,mode)
sm = whiteNoise;
[mean std] = getMeanLuminanceAndStd(sm,s.stimInfo);
white = whiteVal(sm);
switch mode
    case 'maxSTA'
        indMax = find(s.STA==max(s.STA(:))); % find the index with biggest value
        [XMax YMax tMax]=ind2sub(size(s.STA),indMax); % find the pixel with biggest value
        out = [XMax YMax tMax];
    case 'minSTA'
        indMin = find(s.STA==min(s.STA(:))); % find the index with smallest value
        [XMin YMin tMin]=ind2sub(size(s.STA),indMin); % find the pixel with biggest value
        out = [XMin YMin tMin];
    case 'maxDeviation'
        meanValue = mean*white;
        subtractedSTA = s.STA-meanValue;
        indMaxDev = find(abs(subtractedSTA(:))==max(abs(subtractedSTA(:))));
        [XMaxDev YMaxDev tMaxDev] = ind2sub(size(s.STA),indMaxDev);
        out = [XMaxDev YMaxDev tMaxDev];
    case 'surround'
        ONOFF = classify(s,'ONOFFMaxDev');
        switch ONOFF{1}
            case 'ON'
                out = findPixel(s,'minSTA');
            case 'OFF'
                out = findPixel(s,'maxSTA');
        end
    otherwise
        error('unsupported mode');
end
if size(out,1)>1
    out = out(1,:); % just choose the first row
end
end