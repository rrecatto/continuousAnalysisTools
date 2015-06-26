function s=fillLUT(s,method,linearizedRange,plotOn);
%function s=fillLUT(s,method,linearizedRange [,plotOn]);
%stim=fillLUT(stim,'linearizedDefault');
%note: this calculates and fits gamma with finminsearch each time
%might want a fast way to load the default which is the same each time
%edf wants to migrate this to a ststion method  - this code is redundant
%for each stim -- ACK!


if ~exist('plotOn','var')
    plotOn=0;
end

useUncorrected=0;

switch method
    case 'mostRecentLinearized'
         
        method
        error('that method for getting a LUT is not defined');
    case 'linearizedDefault'
        
        %WARNING:  need to get gamma from measurements of ratrix workstation with NEC monitor and new graphics card 

        
        LUTBitDepth=8;
        
        %sample from lower left of triniton, pmm 070106
            %sent=       [0      0.0667    0.1333    0.2000    0.2667    0.3333    0.4000    0.4667    0.5333  0.6000    0.6667    0.7333    0.8000    0.8667    0.9333    1.0000];
            %measured_R= [0.0052 0.0058    0.0068    0.0089    0.0121    0.0167    0.0228    0.0304    0.0398  0.0510    0.065     0.080     0.097     0.117     0.139     0.1645];       
            %measured_G= [0.0052 0.0053    0.0057    0.0067    0.0085    0.0113    0.0154    0.0208    0.0278  0.036     0.046     0.059     0.073     0.089     0.107     0.128 ];
            %measured_B= [0.0052 0.0055    0.0065    0.0077    0.0102    0.0137    0.0185    0.0246    0.0325  0.042     0.053     0.065     0.081     0.098     0.116     0.138];  
  
        %sample values from FE992_LM_Tests2_070111.smr: (actually logged them: pmm 070403) -used physiology graphic card
            sent=       [0      0.0667    0.1333    0.2000    0.2667    0.3333    0.4000    0.4667    0.5333  0.6000    0.6667    0.7333    0.8000    0.8667    0.9333    1.0000];
            measured_R= [0.0034 0.0046    0.0077    0.0128    0.0206    0.0309    0.0435    0.0595    0.0782  0.1005    0.1260    0.1555    0.189     0.227     0.268     0.314 ];
            measured_G= [0.0042 0.0053    0.0073    0.0110    0.0167    0.0245    0.0345    0.047     0.063   0.081     0.103     0.127     0.156     0.187     0.222     0.260 ];
            measured_B= [0.0042 0.0051    0.0072    0.0105    0.0160    0.0235    0.033     0.0445    0.0595  0.077     0.097     0.120     0.1465    0.176     0.208     0.244 ];

            %oldCLUT = Screen('LoadNormalizedGammaTable', w, linearizedCLUT,1);
    case 'useThisMonitorsUncorrectedGamma'
        
        LUTBitDepth=8;
        numColors=2^LUTBitDepth; maxColorID=numColors-1; fraction=1/(maxColorID); 
        ramp=[0:fraction:1];
        grayColors= [ramp;ramp;ramp]';
        %maybe ask for red / green / blue gun only
        uncorrected=grayColors;
        useUncorrected=1;
    case 'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5'
        conn=dbConn();
        [junk mac] = getMACaddress();
        
        if ~strcmp(mac,'001D7D9ACF80')
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
                if true||any(ismember({a.name},'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat')) && ...
                        datenum(a(ismember({a.name},'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat')).date)>floor(now)
                    temp = load(fullfile(getRatrixPath,'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat'));
                    uncorrected = temp.cal.linearizedCLUT;
                    useUncorrected=1; % its already corrected
                    downloadCLUT = false;
                end
            end
            if downloadCLUT
                timeRange=[datenum('05-15-2011 00:01','mm-dd-yyyy HH:MM') datenum('05-15-2011 23:59','mm-dd-yyyy HH:MM')];
                cal=getCalibrationData(conn,mac,timeRange);
                closeConn(conn)
                uncorrected = cal.linearizedCLUT;
                useUncorrected=1; % its already corrected
                % now save cal
                filename = fullfile(getRatrixPath,'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5.mat');
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
                if any(ismember({a.name},'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat')) && ...
                    datenum(a(ismember({a.name},'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat')).date)>floor(now)
                    temp = load(fullfile(getRatrixPath,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat'));
                    uncorrected = temp.cal.linearizedCLUT;
                    useUncorrected=1; % its already corrected
                    downloadCLUT = false;
                end
            end
            if downloadCLUT
                timeRange=[datenum('03-19-2011 00:01','mm-dd-yyyy HH:MM') datenum('03-19-2011 15:00','mm-dd-yyyy HH:MM')];
                cal=getCalibrationData(conn,mac,timeRange);
                closeConn(conn)
                uncorrected = cal.linearizedCLUT;
                useUncorrected=1; % its already corrected
                % now save cal
                filename = fullfile(getRatrixPath,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5.mat');
                save(filename,'cal');
            end
        end
    case 'localCalibStore'
        try
            temp = load(fullfile(getRatrixPath,'monitorCalibration','tempCLUT.mat'));
            uncorrected = temp.linearizedCLUT;
            useUncorrected=1;
        catch ex
            disp('did you store local calibration details at all????');
            rethrow(ex)
        end
    case 'calibrateNow'
        
        %[measured_R measured_G measured_B] measureRGBscale()
        method
        error('that method for getting a LUT is not defined');
    otherwise
        method
        error('that method for getting a LUT is not defined');
end

if useUncorrected
    linearizedCLUT=uncorrected;
else
    linearizedCLUT=zeros(2^LUTBitDepth,3);
    if plotOn
        subplot([311]);
    end
    [linearizedCLUT(:,1) g.R]=fitGammaAndReturnLinearized(sent, measured_R, linearizedRange, 2^LUTBitDepth,plotOn);

    if plotOn
        subplot([312]);
    end
    [linearizedCLUT(:,2) g.G]=fitGammaAndReturnLinearized(sent, measured_G, linearizedRange, 2^LUTBitDepth,plotOn);

    if plotOn
        subplot([313]);
    end
    [linearizedCLUT(:,3) g.B]=fitGammaAndReturnLinearized(sent, measured_B, linearizedRange, 2^LUTBitDepth,plotOn);
end
s.LUT=linearizedCLUT;
