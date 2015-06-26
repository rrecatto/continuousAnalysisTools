function s=fillLUT(s,method,linearizedRange,plotOn);
%function s=fillLUT(s,method,linearizedRange [,plotOn]);
%stim=fillLUT(stim,'linearizedDefault');
%note: this calculates and fits gamma with finminsearch each time
%might want a fast way to load the default which is the same each time
%edf wants to migrate this to a ststion method  - this code is redundant
%for each stim -- ACK!

if ~exist('linearizedRange','var') || isempty(linearizedRange)
    linearizedRange = [0 1];
end

if ~exist('plotOn','var')
    plotOn=0;
end

useUncorrected=0;

switch method
    case 'mostRecentLinearized'    
        method
        error('that method for getting a LUT is not defined');
    case 'tempLinearRedundantCode'   
        LUTBitDepth=8;
        numColors=2^LUTBitDepth; maxColorID=numColors-1; fraction=1/(maxColorID); 
        ramp=[0:fraction:1];
        grayColors= [ramp;ramp;ramp]';
        %maybe ask for red / green / blue gun only
        linearizedCLUT=grayColors;
    case '2009Trinitron255GrayBoxInterpBkgnd.5'
         
        conn=dbConn();
        mac='0018F35DFAC0'  % from the phys rig
        timeRange=[datenum('06-09-2009 23:01','mm-dd-yyyy HH:MM') datenum('06-11-2009 23:59','mm-dd-yyyy HH:MM')];
        cal=getCalibrationData(conn,mac,timeRange);
        closeConn(conn)

        LUTBitDepth=8;
        spyderCdPerMsquared=cal.measuredValues;
        stim=cal.details.method{2};
        vals=double(reshape(stim(:,:,1,:),[],size(stim,4)));
        if all(diff(spyderCdPerMsquared)>0) && length(spyderCdPerMsquared)==length(vals)
            range=diff(spyderCdPerMsquared([1 end]));
            floorSpyder=spyderCdPerMsquared(1);
            desiredVals=linspace(floorSpyder+range*linearizedRange(1),floorSpyder+range*linearizedRange(2),2^LUTBitDepth);
            newLUT = interp1(spyderCdPerMsquared,vals,desiredVals,'linear')/vals(end); %consider pchip
            linearizedCLUT = repmat(newLUT',1,3);
        else
            error('vals not monotonic -- should fit parametrically or check that data collection OK')
        end
    case 'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5'
        conn=dbConn();
        [junk mac] = getMACaddress();
        
        if ~strcmp(mac,'001D7D9ACF80')% how come mac changed??? it was this prev... 00095B8E6171
            warning('using uncorrected gamma for non-rig monitors')
            LUTBitDepth=8;
            numColors=2^LUTBitDepth; maxColorID=numColors-1; fraction=1/(maxColorID);
            ramp=[0:fraction:1];
            grayColors= [ramp;ramp;ramp]';
            %maybe ask for red / green / blue gun only
            uncorrected=grayColors;
            useUncorrected=1;
        else
            % going to consider saving the calibration in a local file. see
            % if the local file was created that day. elase download and
            % use file
            checkLocal = true;
            downloadCLUT = true;
            if checkLocal
                a = dir(getRatrixPath);
                if true || (any(ismember({a.name},'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat')) && ...
                        datenum(a(ismember({a.name},'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat')).date)>floor(now))
                    temp = load(fullfile(getRatrixPath,'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat'));
                    linearizedCLUT = temp.cal.linearizedCLUT;
                    downloadCLUT = false;
                end
            end
            if downloadCLUT
                timeRange=[datenum('05-15-2011 00:01','mm-dd-yyyy HH:MM') datenum('05-15-2011 23:59','mm-dd-yyyy HH:MM')];
                cal=getCalibrationData(conn,mac,timeRange);
                closeConn(conn)
                linearizedCLUT = cal.linearizedCLUT;
                % now save cal
                filename = fullfile(getRatrixPath,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat');
                save(filename,'cal');
            end
        end
    case 'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5'
        conn=dbConn();
        [junk mac] = getMACaddress();
        
        if ~strcmp(mac,'00095B8E6171')
            warning('using uncorrected gamma for non-rig monitors')
            LUTBitDepth=8;
            numColors=2^LUTBitDepth; maxColorID=numColors-1; fraction=1/(maxColorID);
            ramp=[0:fraction:1];
            grayColors= [ramp;ramp;ramp]';
            %maybe ask for red / green / blue gun only
            linearizedCLUT=grayColors;
        else
            % going to consider saving the calibration in a local file. see
            % if the local file was created that day. elase download and
            % use file
            checkLocal = true;
            downloadCLUT = true;
            if checkLocal
                a = dir(getRatrixPath);
                if any(ismember({a.name},'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat')) && ...
                    datenum(a(ismember({a.name},'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat')).date)>floor(now)
                    temp = load(fullfile(getRatrixPath,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat'));
                    linearizedCLUT = temp.cal.linearizedCLUT;
                    downloadCLUT = false;
                end
            end
            if downloadCLUT
                timeRange=[datenum('03-19-2011 00:01','mm-dd-yyyy HH:MM') datenum('03-19-2011 15:00','mm-dd-yyyy HH:MM')];
                cal=getCalibrationData(conn,mac,timeRange);
                closeConn(conn)
                linearizedCLUT = cal.linearizedCLUT;
                % now save cal
                filename = fullfile(getRatrixPath,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat');
                save(filename,'cal');
            end
        end
    case 'calibrateNow'
        %[measured_R measured_G measured_B] measureRGBscale()
        method
        error('that method for getting a LUT is not defined');
    case 'localCalibStore'
        try
            temp = load(fullfile(getRatrixPath,'monitorCalibration','tempCLUT.mat'));
            linearizedCLUT = temp.linearizedCLUT;
        catch ex
            disp('did you store local calibration details at all????');
            rethrow(ex)
        end
    otherwise
        method
        error('that method for getting a LUT is not defined');
end

method
s.LUT=linearizedCLUT;
