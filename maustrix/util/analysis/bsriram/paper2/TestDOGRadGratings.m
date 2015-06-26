%% n = 3
selectionParams.includeNIDs = 1:db.numNeurons;
[aIndsRad nIDsRad subAIndsRad] = db.selectIndexTool('radiiGratings',selectionParams);
[aIndsSF nIDsSF subAIndsSF] = db.selectIndexTool('sfGratings',selectionParams);
numAxesInFig = 0;
f = figure;
figList= [];
qualities = [];
for whichID = 1:db.numNeurons
    
    try
        % does it have both analyses?
        if ~ismember(whichID,nIDsRad)||~ismember(whichID,nIDsSF)
            continue
        end
        % else its okay to go ahead
        % get SFAnalysisNum(s)
        sfAnalyses = subAIndsSF(ismember(nIDsSF,whichID));
        radAnalyses = subAIndsRad(ismember(nIDsRad,whichID));
        %keyboard
        radSFs = nan(size(sfAnalyses));
        for anNum = 1:length(sfAnalyses)
            radSFs(anNum) = db.data{whichID}.analyses{sfAnalyses(anNum)}.stimInfo.stimulusDetails.radii;
        end
        sfAnalysisNum = sfAnalyses(radSFs>0.25);
        sfAnalysisNum = sfAnalysisNum(1); %in case there are multiple
        
        % get model
%         keyboard
        sfAnalysis = db.data{whichID}.analyses{sfAnalysisNum};
        fitDetails = sfAnalysis.model.DOGFit;
        convFactor = getDegPerPix(sfAnalysis);
        vals = 1./(convFactor*(sfAnalysis.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
        minmaxSF = minmax(vals);
        SFForFit = logspace(log10(minmaxSF(1)),log10(minmaxSF(2)),50);
        quals = [];
        whichBal= fitDetails.fitValues{1}.chosenRF;
        quals(end+1) = whichBal.quality;
        whichSupra = fitDetails.fitValues{2}.chosenRF;
        quals(end+1) = whichSupra.quality;
        whichSub = fitDetails.fitValues{3}.chosenRF;
        quals(end+1) = whichSub.quality;
        preferenceParams.mode = 'supraBetterThanRestBy';
        preferenceParams.betterBy = 0.02;
        whichPreferred = getPreferredModel(fitDetails,preferenceParams);
        whichPreferredRC = whichPreferred.chosenRF.RC;
        
        for radAnalysisNum = 1:length(radAnalyses)
%             disp('hi');
            if numAxesInFig==1
                f = figure;
                figList(end+1)= f;
                numAxesInFig = 0;
            else
                figure(f);
            end
            radAnalysis = db.data{whichID}.analyses{radAnalyses(radAnalysisNum)};
            numAxesInFig = numAxesInFig+1;
            axRad = subplot(1,1,numAxesInFig);
            radPlotParams.subtractShuffleEstimate = true;
            radPlotParams.color= 'k';
            radPlotParams.normalize = true;
            radAnalysis.plot2ax(axRad,{'f1',radPlotParams}); hold on;
            ylims = get(gca,'ylim');
            
            
            
            stim.m = 0.5;stim.c = radAnalysis.stimInfo.stimulusDetails.contrasts;
            %         keyboard
            convFactor = getDegPerPix(radAnalysis);vals = 1./(convFactor*(radAnalysis.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
%             keyboard
            stim.FS = vals;stim.maskRs = getRadii(radAnalysis);
            stim.maskRs = logspace(log10(0.1),log10(50),100);
            % balanced
            chosenRF = whichBal;
            rf = chosenRF;
                    rf.thetaMin = min([-30,-3*rf.RS]);
                    rf.thetaMax = max([+30,+3*rf.RS]);
            rf.thetaMin = -30;
            rf.thetaMax = 30;
            rf.dTheta = 0.01;
            if isfield(rf,'ETA'),rmfield(rf,'ETA'),end;
            %         keyboard
            outRad = radGratings(rf,stim,'1D-DOG');
            plot(stim.maskRs,outRad.f1/max(outRad.f1),'k','linewidth',3);
%             temp = corrcoef(outRad.f1,);
%             qualities(end+1,1) = 
            % supra
            chosenRF = whichSupra;
            rf = chosenRF;
                    rf.thetaMin = min([-30,-3*rf.RS]);
                    rf.thetaMax = max([+30,+3*rf.RS]);
            rf.thetaMin = -30;
            rf.thetaMax = 30;
            rf.dTheta = 0.01;
            if isfield(rf,'ETA'),rmfield(rf,'ETA'),end;
            outRad = radGratings(rf,stim,'1D-DOG');
            plot(stim.maskRs,outRad.f1/max(outRad.f1),'b','linewidth',3)
            
            % sub
            chosenRF = whichSub;
            rf = chosenRF;
                    rf.thetaMin = min([-30,-3*rf.RS]);
                    rf.thetaMax = max([+30,+3*rf.RS]);
            rf.thetaMin = -30;
            rf.thetaMax = 30;
            rf.dTheta = 0.01;
            if isfield(rf,'ETA'),rmfield(rf,'ETA'),end;
            outRad = radGratings(rf,stim,'1D-DOG');
            plot(stim.maskRs,outRad.f1/max(outRad.f1),'rx','linewidth',3)
            set(gca,'ylim',[0 1.1*ylims(2)]);
            
            ONOFFTxt = db.data{whichID}.getONOFF({'binarySpatial','ONOFFMaxDev'});
            RCTxt = sprintf('rc=%2.2f',whichPreferredRC);
%             keyboard
            str = {ONOFFTxt{1},RCTxt};
            text(0.95,0.95,str,'units','normalized','verticalalignment','top','horizontalalignment','right');
            saveLoc= '/Users/balaji/Dropbox/extrafigs/';
            filename=sprintf('n%d_a%d.pdf',whichID,radAnalysisNum);
            set(gca,'box','on','linewidth',3,'fontname','Fontin Sans','fontsize',15);
            set(get(gca,'title'),'fontname','Fontin Sans','fontsize',15);
            ylabPosn = get(get(gca,'ylabel'),'position');
            set(get(gca,'ylabel'),'fontname','Fontin Sans','fontsize',15,'position',[-5 ylabPosn(2) ylabPosn(3)]);
            set(get(gca,'xlabel'),'string','Aperture Radius(°)');
            xlabPosn = get(get(gca,'xlabel'),'position');
            set(get(gca,'xlabel'),'fontname','Fontin Sans','fontsize',15,'position',[xlabPosn(1) xlabPosn(2)*1.2 xlabPosn(3)]);
%             plot2svg(fullfile(saveLoc,filename),f);
            print(f,fullfile(saveLoc,filename),'-dpdf');
            
            close(f);
            pause(1);
        end
    catch ex
        fprintf('error on nID=%d\n',whichID);
%         close(f)
        throw(ex);
    end
end


%% RAD_balanced
eta =  (chosenRF.KS*(chosenRF.RS)*(chosenRF.RS))/(chosenRF.KC*(chosenRF.RC)*(chosenRF.RC));

chosenRF = whichBal;
db.data{whichID}.analyses{radAnalysis}.plot2ax(axRad,'default'); hold on;
stim.m = 0.5;
stim.c = 1;

convFactor = getDegPerPix(db.data{whichID}.analyses{radAnalysis});
vals = 1./(convFactor*(db.data{whichID}.analyses{radAnalysis}.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
stim.FS = vals;
stim.maskRs = linspace(0,55,200);

rf = [];
rf.RC = chosenRF.RC;
rf.RS = chosenRF.RS;
rf.KC = chosenRF.KC;
rf.KS = chosenRF.KS;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.A = 1;
rf.ETA = eta

outRad = radGratings(rf,stim,'1D-DOG');
plot(stim.maskRs,outRad.f1,'k','linewidth',3)

%% RAD_SubBal
chosenRF = whichSub;
db.data{whichID}.analyses{radAnalysis}.plot2ax(axRad,'default'); hold on;
stim.m = 0.5;
stim.c = 1;

convFactor = getDegPerPix(db.data{whichID}.analyses{radAnalysis});
vals = 1./(convFactor*(db.data{whichID}.analyses{radAnalysis}.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
stim.FS = vals;
stim.maskRs = linspace(0,55,200);

rf = [];
rf.RC = chosenRF.RC;
rf.RS = chosenRF.RS;
rf.KC = chosenRF.KC;
rf.KS = chosenRF.KS;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.A = 1;
rf.ETA = eta;

outRad = radGratings(rf,stim,'1D-DOG');
plot(stim.maskRs,outRad.f1,'r','linewidth',3)

%%
chosenRF = whichSupra;
db.data{whichID}.analyses{radAnalysis}.plot2ax(axRad,'default'); hold on;
stim.m = 0.5;
stim.c = 1;

convFactor = getDegPerPix(db.data{whichID}.analyses{radAnalysis});
vals = 1./(convFactor*(db.data{whichID}.analyses{radAnalysis}.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
stim.FS = vals;
stim.maskRs = linspace(0,55,200);

rf = [];
rf.RC = chosenRF.RC;
rf.RS = chosenRF.RS;
rf.KC = chosenRF.KC;
rf.KS = chosenRF.KS;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.A = 1;
rf.ETA = eta;

outRad = radGratings(rf,stim,'1D-DOG');
plot(stim.maskRs,outRad.f1,'b','linewidth',3)

%% simulate the SF Fit

axSF  = axes('position',[0.8 0.8 0.1 0.1]);
% SF
% plot data
db.data{whichID}.analyses{sfAnalysis}.plot2ax(axSF,'default'); hold on;
minF1 = min(mean(db.data{whichID}.analyses{sfAnalysis}.f1,1));

stim.m = 0.5;
stim.c = 1;
stim.FS = SFForFit;

rf = [];
rf.RC = chosenRF.RC;
rf.RS = chosenRF.RS;
rf.KC = chosenRF.KC;
rf.KS = chosenRF.KS;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.A = 1;

outSF = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(axSF,log10(outSF.FS),minF1+squeeze(outSF.f1),'k','linewidth',3);

