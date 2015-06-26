function out = getFact(s,which)
if ischar(which)&&strcmp(which,'default')
    which = {'timeToMaxDev'};
end
if ~iscell(which)
    error('''which'' needs to be a cell vector')
end

if length(which{1}==1) % how to send in the params
    params=[];
    which = which{1};
else
    params = which{2};
    which = which{1};
end

switch which
    case 'timeToMaxDev'
        pos = s.findPixel('maxDeviation');
        temp = linspace(-s.timeWindow(1),s.timeWindow(2),size(s.STA,3));
        out = temp(pos(3));
    case 'timeToFirstMaxDev'
        highTempParams.mode = 'center';
        highTempParams.precisionInMS = 1;
        highTempParams.channels = 1;
        STA = s.getTemporalKernelAtHighPrecision(highTempParams);
        timeCourse = linspace(-s.timeWindow(1),s.timeWindow(2),length(STA));
        relevantTimeCourse = (timeCourse<0);
        STA = STA(relevantTimeCourse);
        timeCourse = timeCourse(relevantTimeCourse);
        STA = fliplr(STA);timeCourse = fliplr(timeCourse);
        STD_STA = std(STA);
        STA = abs(STA-127.5);
        whichGreater = (STA)>STD_STA;
        STA(~whichGreater) = 0;
        pks = findpeaks(STA);
        out = timeCourse(pks.loc(1));
    case 'halfWidthAtFirstMax'
        highTempParams.mode = 'center';
        highTempParams.precisionInMS = 1;
        highTempParams.channels = 1;
        STA = s.getTemporalKernelAtHighPrecision(highTempParams);
        timeCourse = linspace(-s.timeWindow(1),s.timeWindow(2),length(STA));
        relevantTimeCourse = (timeCourse<0);
        STA = STA(relevantTimeCourse);
        timeCourse = timeCourse(relevantTimeCourse);
        STA = fliplr(STA);timeCourse = fliplr(timeCourse);
        STD_STA = std(STA);
        STA = abs(STA-127.5);
        STA_Orig = STA;
        whichGreater = (STA)>STD_STA;
        STA(~whichGreater) = 0;
        pks = findpeaks(STA);
        yValMax = STA(pks.loc(1));
        STA_LeftIntact = STA_Orig;STA_LeftIntact(pks.loc(1):end) = yValMax;
        STA_RigtIntact = STA_Orig;STA_RigtIntact(1  :pks.loc(1)) = yValMax;
        leftPos = find(STA_LeftIntact>yValMax/2,1,'first');
        rigtPos = find(STA_RigtIntact<yValMax/2,1,'first');
        out = rigtPos-leftPos;
    case 'duration'
        pos = s.findPixel('maxDeviation');
        time = linspace(-s.timeWindow(1),s.timeWindow(2),size(s.STA,3));
        significant = zeros(size(time));
        relevantSTA = squeeze(s.STA(pos(1),pos(2),:));
        relevantSTV = squeeze(s.STV(pos(1),pos(2),:));
        relevantSEM = relevantSTV/s.numSpikes*1.96;
        for i = 1:length(time)
            if relevantSTA(i)>127.5
                if relevantSTA(i)-relevantSEM(i)>127.5
                    significant(i) = true;
                end
            else
                if relevantSTA(i)+relevantSEM(i)<127.5
                    significant(i) = true;
                end
            end
        end
        minSig = find(significant,1,'first');
        maxSig = find(significant,1,'last');
        timeMinSig = time(minSig);
        timeMaxSig = time(maxSig);
        out = timeMaxSig-timeMinSig;
    case 'normalizedAmplitude'
        sm = whiteNoise;
        pos = s.findPixel('maxDeviation');
        dev = diff(minmax(getTemporal(s,pos)));
        white = whiteVal(sm);
        
        [meanStim stdStim] = getMeanLuminanceAndStd(sm,s.stimInfo);
        stdStim = stdStim*white;
        out = dev/stdStim;
    case 'rfCenter'
        [cenX,cenY,rX,rY]= getRFCentreAndSize(s);
        out = [cenX,cenY];
    case 'rfSize'
        [cenX,cenY,rX,rY]= getRFCentreAndSize(s);
        out = [rX,rY];
    case 'rawAnalysis'
        out.STA = s.STA;
        pos = s.findPixel('maxDeviation');
        out.toi_center = pos(3);
        pos = s.findPixel('surround');
        out.toi_surround = pos(3);
        out.im_centre = s.STA(:,:,out.toi_center);
        out.im_surround = s.STA(:,:,out.toi_surround);
    case 'fftOfSTA'
        out = s.getFftOfSTA;
end
end
