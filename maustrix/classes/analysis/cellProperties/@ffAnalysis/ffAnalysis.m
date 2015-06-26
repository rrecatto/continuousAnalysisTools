classdef ffAnalysis < physiologyAnalysis
    properties
        stimInfo
        sweptParameters
        stim
        spikeCount
        powerEstimationMethod
    end
    properties
        phaseDensity
        rate
        rateSEM
        f0
        f1
        f1SEM
        f2
        coh
        cohSEM
        cohLB
        model
        f1Shuffled
        f1NoiseResamplingN
        f1NoiseSD
    end
    
    methods
        %% constructor
        function s = ffAnalysis(subject,trials,channels,dataPath,stim,c,monitor,rigState)
            s = s@physiologyAnalysis(subject,trials,channels,dataPath,monitor,rigState);
            s.stimInfo = stim;
            s.sweptParameters = getDetails(fullField,stim,'sweptParameters');
            s.powerEstimationMethod = 'autocorr'; %'chronux','directFFT','autocorr'
            if ~isempty(c)
                s = updateAnalysis(s,c);
            end
            
            if all(isnan(s.f1(:)))
                s = calculatePowers(s);
            end
        end
        
        function s = updateAnalysis(s,c)
            if iscell(c)
                c = c{1}{1};
            end
            warning('if you are not using the new type analyses, please change now or this will break');
            if ~isstruct(c) || ~ isfield(c.(createTrodeName(getChannels(s))),'phases')
                error('use new analysis structure. old method is defunct');
            end
            c = c.(createTrodeName(getChannels(s)));
            sm = eval(c.stimInfo.stimulusDetails.stimManagerClass);
            numSweptParameters = length(s.sweptParameters);
            
            s.stimInfo.refreshRate = c.stimInfo.refreshRate; % the refreshrate
            numRepeats = length(unique(c.repeats));
            numTypes = length(unique(c.types));
            s.f0 = nan(numRepeats,numTypes);
            s.f1 = nan(numRepeats,numTypes);
            s.f2 = nan(numRepeats,numTypes);
            s.coh = nan(numRepeats,numTypes);
            s.cohLB = nan(numRepeats,numTypes);
            
            for rep = 1:numRepeats
                for type = 1:numTypes
                    % recreate the stim
                    s.stim{rep,type} = cos(c.phases((c.repeats==rep)&(c.types==type)));
                    s.spikeCount{rep,type} = c.spikeCount((c.repeats==rep)&(c.types==type));
                end
            end
            
        end
        
        function s = calculatePowers(s)
            sm = eval(s.stimInfo.stimulusDetails.stimManagerClass);
            numSweptParameters = length(s.sweptParameters);
            
            numRepeats = size(s.stim,1);
            numTypes = size(s.stim,2);
            
            for rep = 1:numRepeats
                for type = 1:numTypes
                    stim = s.stim{rep,type};
                    spike = s.spikeCount{rep,type};
                    
                    which = ~isnan(stim);
                    stim = stim(which);
                    spike = spike(which);
                    
                    if length(stim)<10 %less than 10 frames
                        continue;
                    end
                    
                    % recreate the stim
                    switch s.powerEstimationMethod
                        case 'directFFT'
                            fStim = fft(stim);
                            fSpike = fft(spike);
                            if ~isempty(fStim) && length(fStim)>10
                                s.f0(rep,type) = fSpike(1)/length(stim)*s.stimInfo.refreshRate; % the DC component
                                pSpike=angle(fStim(2:floor(length(fStim)/2)));
                                fStim=abs(fStim(2:floor(length(fStim)/2))); % get rid of DC and symetry
                                fSpike=abs(fSpike(2:floor(length(fSpike)/2)));
                                indF1 = min(find(fStim==max(fStim)));
                                indF2 = 2*indF1;
                                s.f1(rep,type) = fSpike(indF1)/length(stim)*s.stimInfo.refreshRate;
                                s.phaseDensity(rep,type) = pSpike(indF1);
                                if numel(fSpike)>indF2
                                    s.f2(rep,type) = fSpike(indF2)/length(stim)*s.stimInfo.refreshRate;
                                else
                                    s.f2(rep,type) = nan;
                                end
                                % coherency
                                chrParam.tapers=[3 5]; % same as default, but turns off warning
                                chrParam.err=[2 0.05];  % use 2 for jacknife
                                fscorr=true;
                                % should check chronux's chrParam,trialave=1 to see how to
                                % handle CI's better.. will need to do all repeats at once
                                [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=...
                                    coherencycpb(stim,spike,chrParam,fscorr);
                                
                                N = 100;
                                s.f1NoiseResamplingN = N;
                                spkCurr = squeeze(spike');
                                lSpike = length(spkCurr);
                                f1NoiseCurr = [];
                                for n = 1:N
                                    currRandPerm = randperm(lSpike);
                                    fSpikeNoiseCurr = fft(spkCurr(currRandPerm));
                                    fSpikeNoiseCurr=abs(fSpikeNoiseCurr(2:floor(length(fSpikeNoiseCurr)/2)));
                                    s.f1Shuffled(rep,type,n) = fSpikeNoiseCurr(indF1);
                                end
                                
                                if ~zerosp
                                    peakFreqInds=find(S1>max(S1)*.95); % a couple bins near the peak of
                                    [junk maxFreqInd]=max(S1);
                                    s.coh(rep,type)=mean(C(peakFreqInds)); % mean of coherencey near the peak...what are we doing this?
                                    s.cohLB(rep,type)=Cerr(1,maxFreqInd); % error is at the max Ind
                                else
                                    s.coh(rep,type)=nan;
                                    s.cohLB(rep,type)=nan;
                                end
                                
                            else
                                s.f0(rep,type) = nan;
                                s.f1(rep,type) = nan;
                                s.f2(rep,type) = nan;
                                s.coh(rep,type) = nan;
                                s.cohLB(rep,type) = nan;
                            end
                        case 'chronux'
                            if length(stim)>10 % to handle cases when there is no stim for the relevant data
                                chrParams.tapers = [2 3];
                                chrParams.err = [0 0.05];
                                chrParams.Fs = s.stimInfo.refreshRate;
                                [pStim freqStim]= mtspectrumc(stim,chrParams);
                                [pSpike freqSpike spRate]= mtspectrumpb(squeeze(spike)',chrParams,1); %fscorr is 1
                                
                                N = 100;
                                s.f1NoiseResamplingN = N;
                                spkCurr = squeeze(spike');
                                lSpike = length(spkCurr);
                                f1NoiseCurr = [];
                                for n = 1:N
                                    currRandPerm = randperm(lSpike);
                                    [pSpikeNoiseCurr freqSpikeNoiseCurr spRateNoiseCurr]= mtspectrumpb(spkCurr(currRandPerm),chrParams,1); %fscorr is 1
                                    f1NoiseCurr(n,:) = pSpikeNoiseCurr';
                                end
                                % need to look for the power at the drift
                                % frequency which changes only in tempGratings
                                
                                %                                 warning('no support for cases when drift frequencies is changing along wiht something else...');
                                switch s.sweptParameters{1}
                                    case 'driftfrequencies'
                                        [junk indF1] = min(abs(freqSpike-s.stimInfo.stimulusDetails.driftfrequencies(type)));
                                        [junk indF2] = min(abs(freqSpike-2*s.stimInfo.stimulusDetails.driftfrequencies(type)));
                                        s.f0(rep,type) = spRate;
                                        s.f1(rep,type) = sqrt(pSpike(indF1));
                                        s.f2(rep,type) = sqrt(pSpike(indF2));
                                    otherwise
                                        [junk indF1] = min(abs(freqSpike-s.stimInfo.stimulusDetails.driftfrequencies));
                                        [junk indF2] = min(abs(freqSpike-2*s.stimInfo.stimulusDetails.driftfrequencies));
                                        s.f0(rep,type) = spRate;
                                        s.f1(rep,type) = sqrt(pSpike(indF1));
                                        %                                         keyboard
                                        s.f1Shuffled(rep,type,:) = sqrt(f1NoiseCurr(:,indF1));
                                        s.f2(rep,type) = sqrt(pSpike(indF2));
                                end
                            else
                                s.f0(rep,type) = nan;
                                s.f1(rep,type) = nan;
                                s.f2(rep,type) = nan;
                            end
                        case 'autocorr'
                            if length(stim)>10 % to handle cases when there is no stim for the relevant data
                                
                                [fStimAC freqStimAC] = spectofspike(stim,128,1/s.stimInfo.refreshRate,'none',false);
                                [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,128,1/s.stimInfo.refreshRate,'none',false);
                                
                                peakfInd=min(find(fStimAC==max(fStimAC)));
                                peakf = freqStimAC(peakfInd);
                                
                                N = 100;
                                s.f1NoiseResamplingN = N;
                                spkCurr = squeeze(spike');
                                lSpike = length(spkCurr);
                                f1NoiseCurr = [];
                                for n = 1:N
                                    currRandPerm = randperm(lSpike);
                                    [fSpikeNoiseACCurr freqSpikeNoiseACCurr spRateNoiseACCurr]= spectofspike(spike(currRandPerm),128,1/s.stimInfo.refreshRate,'none',false);
                                    %                                     keyboard
                                    f1NoiseCurr(n,:) = fSpikeNoiseACCurr';
                                end
                                
                                
                                %                                 warning('no support for cases when drift frequencies is changing along wiht something else...');
                                [junk indF1] = min(abs(freqSpikeAC-peakf));
                                [junk indF2] = min(abs(freqSpikeAC-2*peakf));
                                s.f0(rep,type) = spRateAC*s.stimInfo.refreshRate;
                                s.f1(rep,type) = sqrt(fSpikeAC(indF1));
                                s.f2(rep,type) = sqrt(fSpikeAC(indF2));
                                s.f1Shuffled(rep,type,:) = sqrt(f1NoiseCurr(:,indF1));
                            else
                                s.f0(rep,type) = nan;
                                s.f1(rep,type) = nan;
                                s.f2(rep,type) = nan;
                            end
                        otherwise
                            error('unknown method');
                    end
                end
            end
            
            [repInds typeInds]=find(isnan(s.f1));
            s.f0(unique(repInds),:)=nan;   % remove reps with bad power estimates
            s.f1(unique(repInds),:)=nan;   % remove reps with bad power estimates
            s.f2(unique(repInds),:)=nan;   % remove reps with bad power estimates
            s.coh(unique(repInds),:)=nan;   % remove reps with bad power estimates
            s.cohLB(unique(repInds),:)=nan; % remove reps with bad power estimates
            
            switch numSweptParameters
                case 1
                    % do nothing
                case 2
                    if ~isfield(s.stimInfo,'valsSwept')
                        % allowing only special situations right now
                        s.stimInfo.valsSwept{1} = s.stimInfo.stimulusDetails.(s.sweptParameters{1});
                        s.stimInfo.valsSwept{2} = s.stimInfo.stimulusDetails.(s.sweptParameters{2});
                    end
                    numVals1 = length(unique(s.stimInfo.valsSwept{1}));
                    numVals2 = length(unique(s.stimInfo.valsSwept{2}));
                    if numTypes ~= numVals1*numVals2
                        error('something kooky here');
                    end
                    s.f0= reshape(s.f0,[numRepeats,numVals1,numVals2]);
                    s.f1= reshape(s.f1,[numRepeats,numVals1,numVals2]);
                    s.f2= reshape(s.f2,[numRepeats,numVals1,numVals2]);
                    s.coh= reshape(s.coh,[numRepeats,numVals1,numVals2]);
                    s.cohLB= reshape(s.cohLB,[numRepeats,numVals1,numVals2]);
                case 3
                    error('not yet supported')
            end
            
        end
        
        %% classifiers, value calculators and what not
        function out = getType(s)
            out = getType(fullField,s.stimInfo);
        end
        function out = chooseValues(s,params)
            % we have the analysis. now do the choosing and give the output
            switch params.estimationMethod
                case 'highestF0'
                    f0 = sum(s.rate,2);
                    out = s.stimInfo.stimulusDetails.(s.sweptParameters{1})(f0==max(f0));
                case 'highestF1'
                    f1 = s.pow;
                    out = s.stimInfo.stimulusDetails.(s.sweptParameters{1})(f1==max(f1));
                case 'highestCoh'
                    out = s.stimInfo.stimulusDetails.(s.sweptParameters{1})(s.coh==max(s.coh));
                case 'twiceOptimalF1'
                    f1 = s.pow;
                    out = s.stimInfo.stimulusDetails.(s.sweptParameters{1})(f1==max(f1))*2;
                case 'halfOptimalF1'
                    f1 = s.pow;
                    out = s.stimInfo.(s.sweptParameters{1})(f1==max(f1))/2;
                case 'optimalF1GreaterThan'
                    f1 = s.pow;
                    allowedVals=s.stimInfo.stimulusDetails.(s.sweptParameters{1})>params.value;
                    allowedAnalyses = s.f1(allowedVals);
                    out = allowedVals(allowedAnalyses==max(allowedAnalyses));
                case 'optimalF1LessThan'
                    f1 = s.pow;
                    allowedVals=s.stimInfo.stimulusDetails.(s.sweptParameters{1})<params.value;
                    allowedAnalyses = s.f1(allowedVals);
                    out = allowedVals(allowedAnalyses==max(allowedAnalyses));
                otherwise
                    error('unknown method');
            end
        end
        function out = isempty(s)
            out = isempty(s.f0);
        end
        function out = filter(s,what,vals,mode,params)
            if ~exist('params','var')||isempty(params)
                params = struct;
            end
            % what = {'f0','rate'}
            % vals = [512 2048]
            % out = {{vals f0(vals)},{vals; rate(vals)}}
            possibleWhats = {'f0','f1','f2','coh','rate','f0SEM','f1SEM','f2SEM','cohSEM','phaseDensity'};
            
            if length(s.sweptParameters)>1
                error('only supported for one sweptParameter');
            else
                sweptParameter = s.sweptParameters{1};
            end
            switch class(vals)
                case 'double'
                    switch mode
                        case 'errorIfNoValue'
                            if ~ismember(what,possibleWhats)
                                error('%s is not a property of grAnalysis',what);
                            else
                                [tf loc] = ismember(vals,s.stimInfo.stimulusDetails.(sweptParameter));
                                if ~all(tf)
                                    error('asking for vals that dont exist');
                                else
                                    out = {vals s.(what)(:,loc)};
                                end
                            end
                        case 'nearestValue'
                            reqVals = vals;
                            availVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            returnedVals = nan(size(reqVals));
                            for i = 1:length(reqVals)
                                whichVal = find(abs(availVals-reqVals(i))==min(abs(availVals-reqVals(i))));
                                returnedVals(i) = availVals(whichVal);
                            end
                            if ~all(vals==returnedVals)
                                warning('requested and returned values are different');
                            end
                            % now returnedVals are all vals that exist in the
                            % analysis
                            out = filter(s,what,returnedVals,'errorIfNoValue');
                        case 'interpolate'
                            error('not yet');
                        case 'emptyIfNoValue'
                            [tf loc] = ismember(vals,s.stimInfo.stimulusDetails.(sweptParameter));
                            if ~all(tf)
                                out = {};
                            else
                                out = filter(s,what,vals,'errorIfNoValue');
                            end
                        otherwise
                            mode
                            error('unknown mode');
                    end
                case 'char'
                    switch vals
                        case 'maxValueAndLoc'
                            meanWhat = nanmean(s.(what),1);
                            [maxMeanWhat loc] = max(meanWhat);
                            sweepVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            out = {sweepVals(loc) maxMeanWhat};
                        case 'all'
                            actualVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            out = filter(s,what,actualVals,'errorIfNoValue');
                        case 'allGreaterThan'
                            posVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            actualVals = posVals(posVals>params.allGreaterThan);
                            out = filter(s,what,actualVals,'errorIfNoValue');
                        case 'allLessThan'
                            posVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            actualVals = posVals(posVals<params.allLessThan);
                            out = filter(s,what,actualVals,'errorIfNoValue');
                        case 'maxValAndLocForAllGreaterThan'
                            meanWhat = nanmean(s.(what),1);
                            posVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            mask = posVals>params.maxValAndLocForAllGreaterThan;
                            actualVals = posVals(mask);
                            actualMeanWhat = meanWhat(mask);
                            [maxActualMeanWhat loc] = max(actualMeanWhat);
                            out = {actualVals(loc),maxActualMeanWhat};
                        case 'maxValAndLocForAllLessThan'
                            meanWhat = nanmean(s.(what),1);
                            posVals = s.stimInfo.stimulusDetails.(sweptParameter);
                            mask = posVals<params.maxValAndLocForAllLessThan;
                            actualVals = posVals(mask);
                            actualMeanWhat = meanWhat(mask);
                            [maxActualMeanWhat loc] = max(actualMeanWhat);
                            out = {actualVals(loc),maxActualMeanWhat};
                    end
            end
        end
        
        function [vals units] = getCorrectUnits(s)
            if length(s.sweptParameters)==1
                switch s.sweptParameters{1}
                    case 'frequencies'
                        vals = s.stimInfo.stimulusDetails.frequencies;
                        units = 'Hz';
                    case 'radii'
                        vals = s.stimInfo.stimulusDetails.radii*53;
                        units = 'degrees';
                    case 'contrasts'
                        vals = s.stimInfo.stimulusDetails.contrasts*100;
                        units = '%';
                    otherwise
                        s.sweptParameters{1}
                        error('unknown sweptParameter');
                        
                end
            end
        end
        function out = calculateSIs(s,params)
            if length(s.sweptParameters)>1 || ~ismember(s.sweptParameters,'orientations')
                error('only permissible for orientation responses as the only sweptParameter');
            end
            [xVals unit] = getCorrectUnits(s);
            [xVals order] = sort(xVals);
            fftY = fft(params.yVals(order));
            out.OSI = abs(fftY(3))/(abs(fftY(1))+abs(fftY(3)));
            out.DSI = abs(fftY(2))/(abs(fftY(1))+abs(fftY(2)));
            out.SI = max(params.yVals)-min(params.yVals)/(max(params.yVals)+min(params.yVals));
        end
        %% plot functions
        % sets the handle logic only
        function plot(s,varargin)
            switch nargin
                case 1
                    handle = figure;
                    requested = 'default';
                case 2
                    handle = varargin{1};
                    requested = 'default';
                case 3
                    handle = varargin{1};
                    requested = varargin{2};
                otherwise
                    error('unsupported call to plot');
            end
            if strcmp(get(handle,'Type'),'figure')
                plot2fig(s,handle,requested);
            elseif strcmp(get(handle,'Type'),'axes')
                plot2ax(s,handle,requested);
            else
                get(handle,'Type')
                error('unsupported handle type');
            end
        end
        function plot2fig(s,handle,requested)
            if ischar(requested) && strcmp(requested,'default')
                requested = {'Rate','PhaseDensity','F0F1','CalculatedFeatures'};
                requested = {'F0','F1','Modulation','Coherence'};
                requested = {'F0','F1','F2','Spikes'};
            end
            numAxes = length(requested(:));
            [rows cols]= getGoodArrangement(numAxes);
            
            if ~ishandle(handle)||~strcmp(get(handle,'Type'),'figure')
                error('plot2fig takes in a figure handle');
            end
            figure(handle);
            for i = 1:length(requested)
                axHan = subplot(rows,cols,i);
                plot2ax(s,axHan,requested(i));
            end
            textHan = axes('Position',[0.5 0 0.5 0.05]);
            descriptiveText = sprintf('Rat:%s,trials:%d-%d,type:%s',s.subject,min(s.trials),max(s.trials),s.getType);
            text('Position',[1,0.5],'String',descriptiveText,'HorizontalAlignment','Right','VerticalAlignment','Middle');
            set(gca,'XTick',[],'YTick',[]);
        end
        function plot2ax(s,handle,requested)
            if ischar(requested) && strcmp(requested,'default')
                requested = {'F1'};
            end
            %             if length(requested)>1
            %                 error('cannot request multiple plots in axis');
            %             end
            if ~ishandle(handle)||~strcmp(get(handle,'Type'),'axes')
                error('plot2ax takes in a axes handle');
            end
            
            if length(requested)==1 % how to send in the params
                params=struct;
                requested = requested{1};
            else
                params = requested{2};
                requested = requested{1};
            end
            % default color setting
            if isfield(params,'colorAnesthDifferently')
                if getAnesthesia(s)==0
                    params.color = 'b';
                else
                    params.color = 'r';
                end
            end
            %             if isfield(params,'anesthColor') && (getAnesthesia(s)>0)
            %                 params.color = params.anesthColor;
            %                 params = rmfield(params,'anesthColor');
            %             end
            %
            % see if isempty. if yes just put in no analysis do
            % physiologyAnalysis.plot
            if isempty(s)
                textPlot(s,'empty analysis',handle);
                return
            end
            %             requested = {'Rate','PhaseDensity','F0F1','CalculatedFeatures'};
            switch requested
                case 'Rate'
                    plotRate(s,handle,params)
                case 'PhaseDensity'
                    plotPhaseDensity(s,handle,params)
                case 'F0F1'
                    plotF0F1(s,handle,params)
                case 'CalculatedFeatures'
                    plotCalculatedFeatures(s,handle,params)
                case 'F0'
                    plotF0(s,handle,params)
                case 'F1'
                    plotF1(s,handle,params)
                case 'F2'
                    plotF2(s,handle,params)
                case 'Modulation'
                    plotModulation(s,handle,params)
                case 'Coherence'
                    plotCoherence(s,handle,params)
                case 'Spikes'
                    plotSpikes(s,handle,params)
                otherwise
                    error('unknown plot type');
            end
            
        end
        
        function plot2axis(s,requested,handle,params)
            
            fieldsInParams = fieldnames(params);
            plotParams = struct;
            
            %            for i = 1:length(fieldsInParams)
            %                switch fieldsInParams{i};
            %                    case 'colorAnesthDifferently'
            %                        anesth = getAnesthesia(s);
            %                        if params.colorAnesthDifferently && anesth
            %                            plotParams.color = [1 0 0]; %r
            %                        else
            %                            plotParams.color = [0 0 1]; %b
            %                        end
            % %                     case
            % %                     case
            % %                     case
            %                    otherwise
            %                        error('unknown params');
            %                end
            %            end
            
            [requested{ismember('main',requested)}]=deal('F1');
            [requested{ismember('sfGratings',requested)}]=deal('F1');
            [requested{ismember('tfGrating',requested)}]=deal('F1');
            [requested{ismember('orGratings',requested)}]=deal('F1');
            
            plot2ax(s,handle,requested);
            
        end
        function plot1D(s,handle,params)
            if isfield(params,'color')
                col = params.color;
            else
                col = [0 0 1]; %b
            end
            % allows you to plot
            [xVals unit] = getCorrectUnits(s);
            [xVals order] = sort(xVals);
            yVals = makerow(params.yVals(order));
            try
                ySEM = makerow(params.ySEM(order));
            catch
                warning('somethign is messed up');
                ySEM = nan(size(yVals));
            end
            axes(handle); hold on;
            plot(xVals,yVals,'LineWidth',2,'color',col);
            
            %             for i = 1:length(xVals)
            %                 plot([xVals(i) xVals(i)],[yVals(i)+ySEM(i) yVals(i)-ySEM(i)],'LineWidth',1);
            %             end
            if isfield(params,'cosyneMode')
                plot(xVals,yVals+ySEM,'.','MarkerSize',0.5,'color',col);
                plot(xVals,yVals-ySEM,'.','MarkerSize',0.5,'color',col);
                XTicks = xVals;
                XTickLabels = {''};
                XTickLabels = repmat(XTickLabels,1,length(xVals-1));
                XTickLabels{length(xVals)} = sprintf('%2.2f',xVals(end));
                YTicks = max(yVals);
                set(handle,'XTick', XTicks,'XtickLabel',XTickLabels,'YTick',YTicks,'YTickLabel',{});
                axis([0 1.1*max(xVals) 0 1.1*max(yVals+ySEM)]);
                set(handle,'TickLength',[0.02 0.05])
                textPosition = [1.1*max(xVals) 1.1*max(yVals+ySEM)];
                text(textPosition(1),textPosition(2),sprintf('%2.1f',max(yVals)),'HorizontalAlignment','Right','VerticalAlignment','Top')
            else
                xlabel(params.xTitle);ylabel(params.yTitle);
                f = fill([xVals fliplr(xVals)]',[yVals+ySEM fliplr(yVals-ySEM)]',col);
                set(f,'edgeAlpha',0,'faceAlpha',.5);
                set(gca,'XLim',[min(xVals)-0.1*abs(min(xVals)) max(xVals)+0.1*abs(max(xVals))],'YLim',[min(yVals)-0.1*abs(min(yVals)) max(yVals)+0.1*abs(max(yVals))]);
            end
        end
        function plotPolar(s,handle,params)
            if isfield(params,'color')
                col = params.color;
            else
                col = [0 0 1]; %b
            end
            % allows you to plot
            [xVals unit] = getCorrectUnits(s);
            [xVals order] = sort(xVals);
            yVals = makerow(params.yVals(order));
            try
                ySEM = makerow(params.ySEM(order));
            catch
                warning('somethign is messed up');
                ySEM = nan(size(yVals));
            end
            axes(handle); hold on;
            polar([makerow(xVals) xVals(1)],[makerow(yVals) yVals(1)]);
            for i = 1:length(ySEM)
                polar([xVals(i) xVals(i)],[yVals(i)+ySEM(i) yVals(i)-ySEM(i)]);
            end
            details = calculateSIs(s,params);
            text(1,1,{sprintf('OSI:%2.2f',details.OSI),sprintf('DSI:%2.2f',details.DSI),sprintf('SI:%2.2f',details.SI)},...
                'Units','normalized','HorizontalAlignment','Right','VerticalAlignment','Top');
        end
        
        % heavy lifting
        function plotRate(s,handle,params)
        end
        function plotPhaseDensity(s,handle,params)
        end
        function plotF0F1(s,handle,params)
        end
        function plotCalculatedFeatures(s,handle,params)
        end
        function plotF0(s,handle,params)
            if length(s.sweptParameters)==1
                sweptParameter=s.sweptParameters{1};
                params.xVals = s.stimInfo.stimulusDetails.(sweptParameter);
                params.yVals = nanmean(s.f0,1);
                params.ySEM = nanstd(s.f0,[],1)/sqrt(length(find(~isnan(s.f0(:,1))))); %sum all the phasebins first and then take std
                params.xTitle = sweptParameter;
                params.yTitle = 'f0(imp/s)';
                if strcmp(sweptParameter,'orientations')
                    plotPolar(s,handle,params);
                else
                    plot1D(s,handle,params);
                end
                
            else
                error('unsupported');
            end
        end
        function plotF1(s,handle,params)
            if length(s.sweptParameters)==1
                sweptParameter=s.sweptParameters{1};
                params.xVals = s.stimInfo.stimulusDetails.(sweptParameter);
                params.yVals = nanmean(s.f1,1);
                
                [which posn] = sort(params.xVals);
                disp(params.xVals);
                fprintf('\n\n');
                disp(params.yVals(posn)');
                
                
                params.ySEM = nanstd(s.f1,[],1)/sqrt(length(find(~isnan(s.f1(:,1)))));
                params.xTitle = sweptParameter;
                params.yTitle = 'f1(imp/s)';
                if strcmp(sweptParameter,'orientations')
                    plotPolar(s,handle,params);
                else
                    plot1D(s,handle,params);
                end
            else
                error('unsupported');
            end
        end
        function plotF2(s,handle,params)
            if length(s.sweptParameters)==1
                sweptParameter=s.sweptParameters{1};
                params.xVals = s.stimInfo.stimulusDetails.(sweptParameter);
                params.yVals = nanmean(s.f2,1);
                params.ySEM = nanstd(s.f2,[],1)/sqrt(length(find(~isnan(s.f2(:,1)))));
                params.xTitle = sweptParameter;
                params.yTitle = 'f2(imp/s)';
                if strcmp(sweptParameter,'orientations')
                    plotPolar(s,handle,params);
                else
                    plot1D(s,handle,params);
                end
            else
                error('unsupported');
            end
        end
        function plotModulation(s,handle,params)
            if length(s.sweptParameters)==1
                sweptParameter=s.sweptParameters{1};
                params.xVals = s.stimInfo.stimulusDetails.(sweptParameter);
                mod = (s.f1)./(s.f0);
                params.yVals = nanmean(mod,1);
                params.ySEM = nanstd(mod,[],2)/sqrt(length(find(~isnan(mod(:,1)))));
                params.xTitle = sweptParameter;
                params.yTitle = 'mod(f1/f0)';
                if strcmp(sweptParameter,'orientations')
                    plotPolar(s,handle,params);
                else
                    plot1D(s,handle,params);
                end
            else
                error('unsupported');
            end
        end
        function plotCoherence(s,handle,params)
            if length(s.sweptParameters)==1
                sweptParameter=s.sweptParameters{1};
                params.xVals = s.stimInfo.stimulusDetails.(sweptParameter);
                params.yVals = nanmean(s.coh,1);
                params.ySEM = nanstd(s.coh,[],1)/sqrt(length(find(~isnan(s.coh(:,1)))));
                params.xTitle = sweptParameter;
                params.yTitle = 'coherence';
                if strcmp(sweptParameter,'orientations')
                    plotPolar(s,handle,params);
                else
                    plot1D(s,handle,params);
                end
            else
                error('unsupported');
            end
        end
        
    end
end
