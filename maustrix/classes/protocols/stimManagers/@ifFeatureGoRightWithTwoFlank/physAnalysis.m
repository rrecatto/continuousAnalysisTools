function [analysisdata cumulativedata] = physAnalysis(stimManager,spikeRecord,stimulusDetails,plotParameters,parameters,cumulativedata,eyeData,LFPRecord)
% stimManager is the stimulus manager
% spikes is a logical vector of size (number of neural data samples), where 1 represents a spike happening
% frameIndices is an nx2 array of frame start and stop indices - [start stop], n = number of frames
% stimulusDetails are the stimDetails from calcStim (hopefully they contain all the information needed to reconstruct stimData)
% photoDiode - currently not used
% plotParameters - currently not used


%plotsRequested=plotParameters.plotsRequested
plotsRequested={'viewSort','viewDrops','rasterDensity';
    'plotEyes','spikeAlignment','raster';
    'meanPhotoTargetSpike','PSTH','ratePerCondition'};

plotsRequested={'viewSort','ratePerCondition';
    'raster', 'PSTH'};


%% common - should put in util function for all physAnalysis
%CHOOSE CLUSTER
allSpikes=spikeRecord.spikes; %all waveforms
waveInds=allSpikes; % location of all waveforms
if isfield(spikeRecord,'processedClusters')
    try
        if  length([spikeRecord.processedClusters])~=length(waveInds)
            length([spikeRecord.processedClusters])
            length(waveInds)
            error('spikeDetails does not correspond to the spikeRecord''s spikes');
        end
    catch ex
        warning('oops')
        keyboard
        getReport(ex)
    end
    thisCluster=[spikeRecord.processedClusters]==1;
else
    thisCluster=logical(ones(size(waveInds)));
    %use all (photodiode uses this)
end
spikes=allSpikes;
spikes(~thisCluster)=[]; % remove spikes that dont belong to thisCluster

%SET UP RELATION stimInd <--> frameInd
analyzeDrops=true;
if analyzeDrops
    stimFrames=spikeRecord.stimInds;
    correctedFrameIndices=spikeRecord.correctedFrameIndices;
else
    numStimFrames=max(spikeRecord.stimInds);
    stimFrames=1:numStimFrames;
    firstFramePerStimInd=~[0; diff(spikeRecord.stimInds)==0];
    correctedFrameIndices=spikeRecord.correctedFrameIndices(firstFramePerStimInd);
end

if isempty(stimFrames)
   analysisdata=[];
   warning('no frames... not doing analysis... returning cumulative ''as is''')
   return % end this function
end

% count the number of spikes per frame
% spikeCount is a 1xn vector of (number of spikes per frame), where n = number of frames
spikeCount=zeros(1,size(correctedFrameIndices,1));
for i=1:length(spikeCount) % for each frame
    spikeCount(i)=length(find(spikes>=correctedFrameIndices(i,1)&spikes<=correctedFrameIndices(i,2)));
    %spikeCount(i)=sum(spikes(frameIndices(i,1):frameIndices(i,2)));  % inclusive?  policy: include start & stop
end

samplingRate=parameters.samplingRate;
ifi=1/stimulusDetails.hz;      %in old mode used to be same as empiric (diff(spikeData.frameIndices'))/samplingRate;
ifi2=1/parameters.refreshRate; %parameters.refreshRate might be wrong, so check it
if (abs(ifi-ifi2)/ifi)>0.01  % 1 percent error tolerated
    ifi
    ifi2
    er=(abs(ifi-ifi2)/ifi)
    error('refresh rate doesn''t agree!')
end

if ~isempty(eyeData)
    [px py crx cry]=getPxyCRxy(eyeData);
    eyeSig=[crx-px cry-py];
    eyeSig(end,:)=[]; % remove last ones to match (not principled... what if we should throw out the first ones?)
else
    eyeSig=[];
end


%% now stuff unique to flankers
%SET stimulus and get basic features per frame 
s=setStimFromDetails(stimManager, stimulusDetails);
swept=s.dynamicSweep.sweptParameters;
addToCumulativeData=isfield(cumulativedata,'swept')  && strcmp([cumulativedata.swept{:}],[swept{:}]);
[targetIsOn flankerIsOn effectiveFrame cycleNum sweptID repetition]=isTargetFlankerOn(s,stimFrames);

%  SHIFT sweptID & repetition & cycleNum by half the number of mean screen frames.  
%   the purpose of this is to have the on and off response of a  sweptID condition 
%   be displayed on the same raster. If we don't do this the off response
%   wraps around onto the begining of the next (random) condition
numMeanScreenFrames=min([s.targetOnOff s.flankerOnOff])/2;
% because of wrapping cicularly, the off response to the FIRST condition is
% actually the last ... something better in the long run could avoid this...
% but i believe it is not analyzed in the density which rejects the last
% repitition.

sweptID   =[   sweptID(end-numMeanScreenFrames+1:end);    sweptID(1:end-numMeanScreenFrames) ];
cycleNum  =[  cycleNum(end-numMeanScreenFrames+1:end);   cycleNum(1:end-numMeanScreenFrames) ];
repetition=[repetition(end-numMeanScreenFrames+1:end); repetition(1:end-numMeanScreenFrames) ];
modifiedEffectiveFrame=effectiveFrame;
modifiedEffectiveFrame(1:numMeanScreenFrames)=1:numMeanScreenFrames;  % fix the first section


%useful for plotting, not relied upon for other stuff
droppedFrames=[diff(stimFrames)==0; 0];
    

%%

%assemble a vector struct per frame (like per trial)
d.date=correctedFrameIndices(:,1)'/(samplingRate*60*60*24); %define field just to avoid errors
for i=1:length(swept)
    switch swept{i}
        case {'targetContrast','flankerContrast'}
            d.(swept{i})=s.dynamicSweep.sweptValues(i,sweptID);
        case 'targetOrientations'
            d.targetOrientation=s.dynamicSweep.sweptValues(i,sweptID);
        case 'flankerOrientations'
            d.flankerOrientation=s.dynamicSweep.sweptValues(i,sweptID);
        case 'phase'
            d.targetPhase=s.dynamicSweep.sweptValues(i,sweptID);
            d.flankerPhase=d.targetPhase;
        otherwise
            d.(swept{i})= s.dynamicSweep.sweptValues(i,sweptID);
    end
end

%get the condition inds depending on what was swept
if any(strcmp(swept,'targetOrientations'))...
        && any(strcmp(swept,'flankerOrientations'))...
        && any(strcmp(swept,'flankerPosAngle'))...
        && any(strcmp(swept,'phase'))...
        && size(swept,2)==4;
    conditionType='colin+3';
    [conditionInds conditionNames haveData colors]=getFlankerConditionInds(d,[],conditionType);
    colors(2,:)=colors(3,:); % both pop-outs the same
    colors(4,:)=[.5 .5 .5]; % grey not black
    % elseif any(strcmp(swept,'targetContrast'))...
    %     && any(strcmp(swept,'flankerContrast'))...
    %     && size(swept,2)==2;
    %
    %     %flanker contrast only right now...
    %     [conditionInds conditionNames haveData colors]=getFlankerConditionInds(d,[],'fiveFlankerContrastsFullRange');
    
    %
elseif any(strcmp(swept,'targetOrientations'))...
        && any(strcmp(swept,'phase'))...
        && size(swept,2)==2;
    conditionType='allTargetOrientationAndPhase';
    [conditionInds conditionNames haveData colors]=getFlankerConditionInds(d,[],conditionType);
elseif any(strcmp(swept,'targetContrast'))...
        && any(strcmp(swept,'phase'))...
        && size(swept,2)==2;
    conditionType='allTargetContrastAndPhase'; % best
    %conditionType='allTargetContrasts'; % could use, but not best
    %conditionType='allPhases' % could use, but not best
    [conditionInds conditionNames haveData colors]=getFlankerConditionInds(d,[],conditionType);
else 
    %default to each unique
    conditionsInds=zeros(max(sweptID),length(stimFrames));
    allSweptIDs=unique(sweptID);
    for i=1:length(allSweptIDs)
        conditionInds(i,:)=sweptID==allSweptIDs(i);
        conditionNames{i}=num2str(i);
    end
    colors=jet(length(allSweptIDs));
end


numConditions=size(conditionInds,1); % regroup as flanker conditions
numTrialTypes=length(unique(sweptID)); % whatever the group actually was acording to ths sm
numRepeats=max(repetition);
numUniqueFrames=max(effectiveFrame);
frameDurs=(correctedFrameIndices(:,2)-correctedFrameIndices(:,1))'/samplingRate;
%% set the values into the conditions
f=fields(d);
f(ismember(f,'date'))=[];  % the date is not part of the condition
for i=1:numConditions
    for j=1:length(f)
        firstInstance=min(find(conditionInds(i,:)));
        value=d.(f{j})(firstInstance);
        if length(unique(d.(f{j})(find(conditionInds(i,:)))))~=1
            error('more than 1 unique value in a condition is an error')
        end
        if isempty(value)
            value=nan;
        end
        c.(f{j})(i)=value;
        
        if addToCumulativeData && value~=cumulativedata.conditionValues.(f{j})(i)
            cumulativedata.conditionValues
            f{j}
            cumulativedata.conditionValues.(f{j})(i)
            value
            error('these values must be the same to combine across trials')
        end
    end
end



%% precalc usefull
onsetFrame=diff([0; targetIsOn])>0;
[conditionPerCycle junk]=find(conditionInds(:,onsetFrame));
shiftedFrameOrder=[(1+numMeanScreenFrames):numUniqueFrames  1:numMeanScreenFrames];
%% construct density for spikes and photodiode
events=nan(numRepeats,numTrialTypes,numUniqueFrames);
possibleEvents=events;
photodiode=events;
rasterDensity=ones(numRepeats*numTrialTypes,numUniqueFrames)*0.1;
photodiodeRaster=rasterDensity;
%tOn2=rasterDensity;
fprintf('%d repeats',numRepeats)
for i=1:numRepeats
    fprintf('.%d',i)
    for j=1:numTrialTypes
        for k=1:numUniqueFrames
            thisFrame=shiftedFrameOrder(k);
            which=find(sweptID==j & repetition==i & effectiveFrame==thisFrame);
            events(i,j,thisFrame)=sum(spikeCount(which));
            possibleEvents(i,j,thisFrame)=length(which);
            photodiode(i,j,thisFrame)=sum(spikeRecord.photoDiode(which))/sum(frameDurs(which));
            if isempty(which)
                warning(sprintf('count should be at least 1!, [i j thisFrame] = [%d %d %d]',i,j,thisFrame))
                %the source of this error is the  SHIFT early on... maybe
                %smarter code is needed to handle the shift
                % wacky ideas: tack some on at the end?
                % loop through and shift all dynamically?
            end
            %tOn(i,j,thisFrame)=mean(targetIsOn(which)>0.5); where is should be on
            
            %in last repeat density = 0.1, for parsings and avoiding misleading half data
            if numRepeats~=i
                %y=(j-1)*(numRepeats)+i; % linear in order displayed
                y=(conditionPerCycle(j)-1)*(numRepeats)+i; %unscambled to the order in conditiondInds
                rasterDensity(y,k)=events(i,j,thisFrame)./possibleEvents(i,j,thisFrame);
                photodiodeRaster(y,k)=photodiode(i,j,thisFrame);
                %tOn2(y,thisFrame)=tOn(i,j,thisFrame); where is should be on
            end
        end
    end
end

%%

rasterDensity(isnan(rasterDensity))=0;
photodiodeRaster(photodiodeRaster==0.1)=mean(photodiodeRaster(:)); photodiodeRaster(1)=mean(photodiodeRaster(:));  % a known problem from drops

fullRate=events./(possibleEvents*ifi);
if numRepeats>2
    % don't remove if there is only 1
    fullPhotodiode=photodiode(2:end,:,:);
else
    fullPhotodiode=photodiode;
end
rate=reshape(sum(events,1)./(sum(possibleEvents,1)*ifi),numTrialTypes,numUniqueFrames); % combine repetitions

if numRepeats>2
    rateSEM=reshape(std(events(1:end-1,:,:)./(possibleEvents(1:end-1,:,:)*ifi)),numTrialTypes,numUniqueFrames)/sqrt(numRepeats-1);
    photodiodeSEM=reshape(std(photodiode(1:end-1,:,:)),numTrialTypes,numUniqueFrames)/sqrt(numRepeats-1);
    photodiode=reshape(mean(photodiode(2:end,:,:),1),numTrialTypes,numUniqueFrames); % combine repetitions
else
    rateSEM=nan(size(rate));
    photodiodeSEM=nan(size(rate));
    photodiode=reshape(mean(photodiode,1),numTrialTypes,numUniqueFrames); % combine repetitions
end

% THIS SHOULD BE DELETEABLE, BUT CODE NEEDS TO BE RUN AND INSPECTED regarding
%      frame=shiftedFrameOrder(k)
% %place half the means screen in front and half behind
% % maybe do this b4 on all of them
% rate=rate(:,shiftedFrameOrder);
% rateSEM=rateSEM(:,shiftedFrameOrder);
% rasterDensity=rasterDensity(:,shiftedFrameOrder);
% fullPhotodiode=fullPhotodiode(:,:,shiftedFrameOrder);
% photodiode=photodiode(:,shiftedFrameOrder);
% photodiodeSEM=photodiodeSEM(:,shiftedFrameOrder);
% photodiodeRaster=photodiodeRaster(:,shiftedFrameOrder);


%%  SOME DATA IS STORED PER SPIKE
    spike.times=spikeRecord.spikeTimestamps(thisCluster)';
    cycleOnset=spikeRecord.correctedFrameTimes(onsetFrame,1); % the time that the target starts
    repStartFrame=diff([0; repetition])>0;
    repStartTime=spikeRecord.correctedFrameTimes(repStartFrame,1); % the time that the rep starts
    
    %REMOVE SPIKES THAT ARE BEFORE THE FIRST STIM OF THE TRIAL BY MORE THAN ~ 200ms
    timeToTarget=double(s.targetOnOff(1))*ifi/2;
    tooEarly=spike.times<cycleOnset(1)-timeToTarget;
    spike.times(tooEarly)=[];
    
    %INIT AND SET PROPERTIES FOR EACH SPIKE
    spike.relTimes=zeros(size(spike.times));
    spike.relRepTimes=zeros(size(spike.times));
    spike.frame=zeros(size(spike.times));
    spike.cycle=zeros(size(spike.times));
    spike.condition=zeros(size(spike.times));
    for i=1:length(spike.times)
        spike.cycle(i)=max(find(spike.times(i)>cycleOnset-timeToTarget)); % the stimulus cycle of each spike
        spike.frame(i)=max(find(spike.times(i)>spikeRecord.correctedFrameTimes(:,1))); % the frame of each spike
        spike.relTimes(i)=spike.times(i)-cycleOnset(spike.cycle(i)); % the relative time to the target onset of this cycle
        spike.condition(i)=find(conditionInds(:,spike.frame(i))); % what condition this spike occurred in
        spike.repetition(i)=repetition(spike.frame(i)); % what rep this spike occurred in
        spike.relRepTimes(i)=spike.times(i)-repStartTime(spike.repetition(i)); % the relative time to the rep onset of this cycle
    end
    % save trial info per spike b/c going to have info across many trials
    spike.trial=parameters.trialNumber(ones(1,length(spike.times)))
    

%% ADD to cumulativeData the stuff that was processed

if addToCumulativeData
    
    cumulativedata.trialNumbers=[cumulativedata.trialNumbers parameters.trialNumber];
    cumulativedata.numFrames=[cumulativedata.numFrames length(stimFrames)];
    if  any(cumulativedata.targetOnOff~=double(s.targetOnOff))
        error('not allowed to change targetOnOff between trials')
    end
    
    cumulativedata.spikeWaveforms=[cumulativedata.spikeWaveforms; spikeRecord.spikeWaveforms];
    cumulativedata.processedClusters=[cumulativedata.processedClusters; [spikeRecord.processedClusters]];
    if samplingRate~=cumulativedata.samplingRate;
        error('switched sampling rate across these trials')
    end
    
    cumulativedata.totalDrops=sum(droppedFrames); % this summary statistic is trust worthy
    cumulativedata.droppedFrames=[cumulativedata.droppedFrames; droppedFrames];  % this is a crude concatenation across trials; and find(drops) should not be trusted withouit serious checking of groud facts.
    cumulativedata.eyeSig=[cumulativedata.eyeSig; eyeSig];
    
    %SPIKE
    f=fields(spike);
    for i=1:length(f)
        cumulativedata.spike.(f{i})=[cumulativedata.spike.(f{i}) spike.(f{i})];
    end
    cumulativedata.cycleOnset=[cumulativedata.cycleOnset; cycleOnset];
    cumulativedata.numSpikesAnalyzed=[cumulativedata.numSpikesAnalyzed length(spike.times)];
    
    try
        cumulativedata.conditionPerCycle=[cumulativedata.conditionPerCycle conditionPerCycle];
        %[160 20] failed to join with size [2 1]
    catch
        %hack!
        warning('HACK! avoided a wired error by maing a fake veactor of ones and stuffing in whats here')
        temp=ones(size(cumulativedata.conditionPerCycle,1),1)
        temp(1:length(conditionPerCycle))=conditionPerCycle
        keyboard
        cumulativedata.conditionPerCycle=[cumulativedata.conditionPerCycle cumulativedata.conditionPerCycle()];
    end
   
    
    cumulativedata.photodiodeRaster=cumulativedata.photodiodeRaster + photodiodeRaster; %NEW: a sum of volts
    cumulativedata.rasterDensity=cumulativedata.rasterDensity + rasterDensity;          %NEW: a sum of counts
    %cumulativedata.photodiodeRaster=[cumulativedata.photodiodeRaster; photodiodeRaster]; %OLD: a vertical stack
    %cumulativedata.rasterDensity=[cumulativedata.rasterDensity; rasterDensity]; %OLD: a vertical stack
    
else %reset
    %initialize if trial is new type, or enforce blank if starting fresh
    cumulativedata=[]; %wipe out whatever data we get
    
    %store only once at start:
    cumulativedata.plotsRequested=plotsRequested;
    cumulativedata.targetOnOff=double(s.targetOnOff);
    cumulativedata.ifi=ifi;
    cumulativedata.conditionNames=conditionNames;
    cumulativedata.colors=colors;
    cumulativedata.swept=swept;
    cumulativedata.conditionValues=c; % no need to add, b/c we confrimed they are the same
   
    % store cumulative:
    cumulativedata.trialNumbers=parameters.trialNumber;
    cumulativedata.numFrames=length(stimFrames);
    

    cumulativedata.spikeWaveforms=spikeRecord.spikeWaveforms;
    cumulativedata.processedClusters=[spikeRecord.processedClusters];
    cumulativedata.samplingRate=samplingRate;
    
    cumulativedata.totalDrops=sum(droppedFrames);
    cumulativedata.droppedFrames=droppedFrames;
    cumulativedata.eyeSig=eyeSig;
    
    %SPIKE
    cumulativedata.spike=spike;
    cumulativedata.cycleOnset=cycleOnset;
    cumulativedata.numSpikesAnalyzed=length(spike.times)% more accurate than sum(spikeCount) by a few spikes
    cumulativedata.conditionPerCycle=conditionPerCycle;
    
    cumulativedata.photodiodeRaster=photodiodeRaster;
    cumulativedata.rasterDensity=rasterDensity;
end

analysisdata=[]; % per chunk is not used ever yet.. only cumulatuve saves


%% viewDropsAndCycles
% sometime worth turning on... tho it may interfere with handles
viewDropsAndCycles= 0; %sum(diff(stimFrames)==0)>0; % a side plot when drops exist
if viewDropsAndCycles
    figure
    dropFraction=conv([diff(stimFrames)==0; 0],ones(1,100));
    subplot(6,1,1); plot(effectiveFrame)
    subplot(6,1,2); plot(stimFrames)
    %subplot(6,1,3); plot(cycleNum)
    subplot(6,1,3); plot(dropFraction)
    ylabel(sprintf('drops: %d',sum(diff(stimFrames)==0)))
    subplot(6,1,4); plot(sweptID)
    subplot(6,1,5); plot(repetition)
    subplot(6,1,6); plot(targetIsOn)
end

%% PHOTODIODE
%%
doPhotodiode=0;
if doPhotodiode
    %figure; hold on;
    switch conditionType
        case 'allTargetOrientationAndPhase'
            %%
            %close all
            
            %%
            subplot(1,2,1); hold on
            title(sprintf('grating %dppc',stimulusDetails.pixPerCycs(1)))
            
            ss=1+round(stimulusDetails.targetOnOff(1)/2);
            ee=ss+round(diff(stimulusDetails.targetOnOff))-1;
            or=unique(c.targetOrientation);
            if or(1)==0 && or(2)==pi/2
                l1='V';
                l2='H';
            elseif abs(or(1))==abs(or(2)) && or(1)<0 && or(2)>0
                l1=sprintf('%2.0f CW',180*or(2)/pi);
                l2='CCW';
            else
                l1='or1';
                l2='or2'
            end
            
            for i=1:length(or)
                which=find(c.targetOrientation==or(i));
                pho=photodiode(which,:)';
                [photoTime photoPhase ]=find(pho==max(pho(:)));
                phoSEM=photodiodeSEM(photoPhase,:);
                
                whichPlot='maxPhase'
                switch whichPlot
                    case 'maxPhase'
                        plot(1:numUniqueFrames,[pho(:,photoPhase) pho(:,photoPhase)],'.','color',colors(min(which),:));
                    case 'allRepsMaxPhase'
                        theseData=reshape(fullPhotodiode(:,which(photoPhase),:),size(fullPhotodiode,1),[]);
                        theFrames=repmat([1:numUniqueFrames],size(fullPhotodiode,1),1);
                        plot(theFrames,theseData,'.','color',colors(min(which),:))
                end
                
                h(i)=plot(pho(:,photoPhase),'color',colors(min(which),:));
                %plot([1:length(pho); 1:length(pho)],[pho(:,photoPhase) pho(:,photoPhase)]'+(phoSEM'*[-1 1])','color',colors(min(find(which)),:))
            end
            xlabel('frame #')
            ylabel('sum(volts)')
            legend(h,{l1,l2})
            %set(gca,'xlim',[0 size(pho,1)*2],'ylim',[7 11])
            
            subplot(1,2,2); hold on
            for i=1:length(or)
                which=find(c.targetOrientation==or(i));
                pha=c.targetPhase(which);
                pho=photodiode(which,:)';
                [photoTime photoPhase ]=find(pho==max(pho(:)));
                
                options=optimset('TolFun',10^-14,'TolX',10^-14);
                lb=[0 0 -pi*2]; ub=[6000 4000 2*pi]; % lb=[]; ub=[];
                
                
                p=linspace(0,4*pi,100);
                
                whichPlot='allRepsOneTime';
                switch whichPlot
                    
                    case 'maxTime'
                        params = lsqcurvefit(@(x,xdata) x(1)+x(2)*sin(xdata+x(3)),[1000 100 1],pha,pho(photoTime,:),lb,ub,options); params(3)=mod(params(3),2*pi);
                        plot([pha pha+2*pi]+params(3),[pho(photoTime,:) pho(photoTime,:)],'.','color',colors(min(which),:));
                        
                        %plot([pha pha+2*pi]+params(3),[pho pho],'.','color',colors(min(find(which)),:));
                    case 'allRepsOneTime'
                        params = lsqcurvefit(@(x,xdata) x(1)+x(2)*sin(xdata+x(3)),[1000 100 1],pha,pho(photoTime,:),lb,ub,options); params(3)=mod(params(3),2*pi);
                        theseData=reshape(fullPhotodiode(:,which,photoTime),size(fullPhotodiode,1),[]);
                        thePhases=repmat(pha+params(3),size(fullPhotodiode,1),1);
                        plot(thePhases,theseData,'.','color',colors(min(which),:))
                    case 'allRepsTimeAveraged'
                        
                    case  'timeAveragedRepAveraged'
                        meanPho=mean(pho);
                        validPho=~isnan(meanPho);
                        params = lsqcurvefit(@(x,xdata) x(1)+x(2)*sin(xdata+x(3)),[1000 100 1],pha(validPho),meanPho(validPho),lb,ub,options); params(3)=mod(params(3),2*pi);
                        plot([pha pha+2*pi]+params(3),[mean(pho) mean(pho)],'.','color',colors(min(which),:));
                    case  'stimOnTimeAveragedRepAveraged'
                        meanPho=mean(pho(ss:ee,:));
                        validPho=~isnan(meanPho);
                        params = lsqcurvefit(@(x,xdata) x(1)+x(2)*sin(xdata+x(3)),[1000 100 1],pha(validPho),meanPho(validPho),lb,ub,options); params(3)=mod(params(3),2*pi);
                        plot([pha pha+2*pi]+params(3),[meanPho meanPho],'.','color',colors(min(which),:));
                        
                end
                plot(p,params(1)+params(2)*sin(p),'-','color',colors(min(which),:))
                
                
                amp(i)=params(2);
                mn(i)=params(1);
            end
            meanFloor=min(photodiode(:));
            ratioDC=(mn(1)-meanFloor)/(mn(2)-meanFloor);
            string=sprintf('%s:%s = %2.3f mean  %2.3f amp',l1,l2,ratioDC,abs(amp(1)/amp(2)));
            title(string)
            xlabel('phase (\pi)')
            set(gca,'ytick',[ylim ],'yticklabel',[ylim ])
            set(gca,'xtick',[0 pi 2*pi 3*pi 4*pi],'xticklabel',[0 1 2 3 4],'xlim',[0 6*pi]);%,'ylim',[1525 1600])
            cleanUpFigure
        otherwise
            %% inspect distribution of photodiode output
            close all
            figure;
            subplot(2,2,1); hist(photodiode(:),100)
            xlabel ('luminance (volts)'); ylabel ('count')
            subplot(2,2,2); plot(diff(spikeRecord.correctedFrameTimes',1)*1000,spikeRecord.photoDiode,'.');
            xlabel('frame time (msec)'); ylabel ('luminance (volts)')
            subplot(2,2,3); plot(spikeRecord.spikeWaveforms(8,:)')
            

            %%
            
            subplot(1,2,1); hold on
            for i=1:numConditions
                plot(x,photodiode(i,:),'color',colors(i,:));
                plot([x; x]+(i*0.05),[photodiode(i,:); photodiode(i,:)]+(photodiodeSEM(i,:)'*[-1 1])','color',colors(i,:))
            end
            xlabel('time (msec)');
            set(gca,'XTickLabel',xvals,'XTick',xloc);
            ylabel('sum volts (has errorbars)');
            set(gca,'Xlim',[1 numUniqueFrames])
            
            %rate density over phase... doubles as a legend
            subplot(1,2,2); hold on
            im=zeros([size(rasterDensity) 3]);
            hues=rgb2hsv(colors);  % get colors to match jet
            hues=repmat(hues(:,1)',numRepeats,1); % for each rep
            hues=repmat(hues(:),1,numUniqueFrames);  % for each phase bin
            grey=repmat(all((colors==repmat(colors(:,1),1,3))'),numRepeats,1); % match grey vals to hues
            im(:,:,1)=hues; % hue
            im(grey(:)~=1,:,2)=0.6; % saturation
            im(:,:,3)=rasterDensity/max(rasterDensity(:)); % value
            rgbIm=hsv2rgb(im);
            image(rgbIm);
            axis([0 size(im,2) 0 size(im,1)]+.5);
            set(gca,'YTickLabel',conditionNames,'YTick',size(im,1)*([1:length(conditionNames)]-.5)/length(conditionNames))
            xlabel('time');
            %set(gca,'XTickLabel',{'0','pi','2pi'},'XTick',([0 .5  1]*numPhaseBins)+.5);
            
    end
end

