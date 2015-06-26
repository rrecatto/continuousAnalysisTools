classdef physiologyAnalysis < analysis
    properties
        channels
        data
        monitor
        rig
    end
    
    methods
        function a=physiologyAnalysis(subject,trials,channels,dataPath,monitor,rigState,varargin)
            %should populate superclass fields - is trialNume on or all...
            %          a.subject=physRecords.ratID
            a =a@analysis(subject,trials,dataPath);
            if isnumeric(channels)
                a.channels = channels;
            else
                error('channels should be a numeric value')
            end
            
            if isa(monitor,'monitor')
                a.monitor = monitor;
            else
                error('needs to be a monitor')
            end
            
            if isa(rigState,'rig')
                a.rig = rigState;
            else
                error('need a rig');
            end
            
            if nargin==8
                stim = varargin{1};
                c = varargin{2};

                if ~isempty(c)
                    a = updateAnalysis(a,c);
                end
                a.data.stimInfo = stim;
            end
            %should verify the structure contents that are required.
        end
        
        function plot2axis(a,which,ax)
            if ~exist('ax','var')
                ax=gca;
            end
            x=[which{:}]
            if ischar(x)
                txt=[' ' x];
            else
                txt='ne';
            end
            a.textPlot(sprintf('no%s',txt));
        end
        function out=getType(a)
            out = 'genericPhysAnalysis';
        end
        
        function an = getAnalysis(s)
            path = fullfile(s.dataPath,s.subject,'analysis',s.sourceFolder);
            temp = load(fullfile(path,'physAnalysis.mat'));
            index=s.getPhysIndexForTrials(temp.physAnalysis);
            trodeName=createTrodeName(s.channels);
            an=temp.physAnalysis{index}{1}.(trodeName);
%             an=temp.(trodeName)
        end
        
        function [spikes frames]=getSpikes(s)
            
            if IsLinux
                dataPath = recordsPathLUT(s.dataPath,'Win2Lx');
            else
                dataPath = s.dataPath;
            end
            
            path = fullfile(dataPath,s.subject,'analysis',s.sourceFolder);
            temp = load(fullfile(path,'spikeRecord.mat'));
            filterParams.trialRange=s.trials;
            filterParams.filterMode='theseTrialsOnly';
            spikes = filterSpikeRecords(filterParams,temp.spikeRecord);
            
            trodeName=createTrodeName(s.channels);
            frames=spikes;
            frames=rmfield(frames,trodeName);
            spikes=spikes.(trodeName);
        end
        
        function s=flushAnalysis(s)
           disp('this analysis doesnt ever flush.. the subclass lacks the method') 
        end
        function out = getFiringRate(s)
            [spikes frames]= getSpikes(s);
            out = length(find(spikes.processedClusters))/sum(frames.chunkDuration);
        end
        
        function [data]=getNeuralData(s,NthTrial)
            if ~exist('NthTrial','var') || isempty(NthTrial)
                NthTrial=1;
            end

            subjectDataPath=fullfile(s.dataPath,s.subject);
            [physRecords success filePaths]=getPhysRecords(subjectDataPath,{'trialRange',s.trials(NthTrial([1 1]))},{'neural'});
            data=physRecords;
        end
        function [power]=getPowerOfLFP(s,freqRange,samplingRate)
            %freqRange: inclusive lower bound inclusive upper bound
            
            %init
            power=[];
            cLFP=[];
            trodeName=createTrodeName(s.channels);
            
            %windowSz=500;
            windowSz=ceil(samplingRate/freqRange(1));
            f=freqRange(1):1:freqRange(2);
            nonOverlap=1;
                
            
            %need frames from spike records
            path = fullfile(s.dataPath,s.subject,'analysis',s.sourceFolder);
            SR = load(fullfile(path,'spikeRecord.mat'));
            filterParams.filterMode='theseTrialsOnly';
            
            for i=1:length(s.trials)
                % get the records for LFP
                fileName=['LFPRecord_' num2str(s.trials(i)) '.mat'];
                fullFileName = fullfile(s.dataPath,s.subject,'LFPRecords',fileName);
                temp = load(fullFileName);
                x=temp.LFPRecord.(trodeName);
                LFP=x.data;
                lfpTimes=[x.dataTimes(1):1/x.LFPSamplingRateHz:x.dataTimes(2)];
                
                if windowSz>length(LFP)
                    warning('skipping short neural data');
                    spec=nan(length(f),length(LFP));
                else
                    s.trials(i)
                    
                    %filter to get these frames
                    filterParams.trialRange=s.trials(i);
                    filtered = filterSpikeRecords(filterParams,SR.spikeRecord);
                    try
                        trialBounds=filtered.correctedFrameTimes([1 end]);
                        ft=filtered.correctedFrameTimes;
                        [junk inds]=sort([lfpTimes ft(:,2)']); % co sort, sneaky what to find N nearest frames when we trust that samples wil always exist between 2 frame ends
                        unCosortInds=find([diff(inds)]>1)-[1:size(ft,1)];  % find discontinuity in the sort, and discount the accumating frames
                    catch ex
                        fprintf('trial: %d\n',s.trials(i))
                        warning('uh oh, maybe no spikes this trial .. or ft is not matched in side to the diff of inds...  2 in a row.. or chop?')
                        keyboard
                        rethrow(ex)
                    end
                    if any(abs(minmax(lfpTimes(unCosortInds)-ft(:,2)'))>2/x.LFPSamplingRateHz) % check the that timing is never off by more than 2 samples
                        error('failed to find the lfp inds corresponding to the end of the frame')
                    else
                         LFP=LFP(unCosortInds); 
                         %get one LFP sample per frame
                    end
                        
                    %limit LFP to frame times
                    %ss=round((trialBounds(1)-x.dataTimes(1))*x.LFPSamplingRateHz);
                    %ee=-round((trialBounds(2)-x.dataTimes(2))*x.LFPSamplingRateHz);
                    %LFP=LFP(ss:end-ee);

                    
                    if samplingRate~=temp.LFPRecord.(trodeName).LFPSamplingRateHz
                        error('wrong sampling rate, need to resample... before or after fft?')
                    end
                    
                    %samples on every time step .. a bit slow and overkill
                    [spec F T] = spectrogram(LFP',windowSz,windowSz-nonOverlap,f,samplingRate);
                    spec= [nan(length(f),windowSz-1) spec];
                    
                    if ~all(F'==f)
                        f
                        F'
                        error('you cant always get what chu want');
                    end
                end
                if any(f<(samplingRate/windowSz))
                    f
                    f<(samplingRate/windowSz)
                    error('window size to small for that freq');
                end
                power=[power sum(abs(spec))];
                cLFP=[cLFP LFP'];
               
            end
            %                 subplot(2,1,1); plot(cLFP)
            %                 subplot(2,1,2); plot(power)
            %                 warning('ere')
            %                 keyboard
            
            
        end
        function textPlot(a,txt,ax)
            if ~exist('ax','var')
                ax=gca;
            end
            text(.5,.5,txt);
            set(ax,'xtick',[],'ytick',[]);
        end
        
        function plot(a,varargin)
            if ishandle(varargin{1})&&strcmp(get(varargin{1},'Type'),'axes')
                axes(varargin{1});
                textPlot(a,'no analysis',varargin{1});
            end
        end
        function plotSpikes(s,handle,params)
            if isfield(params,'color')
                col = params.color;
            else
                col = [0 0 1]; %b
            end
            spikes = getSpikes(s);
            axes(handle);
            which = logical(spikes.processedClusters);
            try
                plot((spikes.spikeWaveforms(which,:))','r');
            catch
                warning('unable to plot for some reawson');
                keyboard
                plot(spikes.spikeWaveforms)
            end
        end
            
        function plotISI(s,handle,params)
            if isfield(params,'color')
                col = params.color;
            else
                col = [0 0 1]; %b
            end
            spikes = getSpikes(s);
            axes(handle);
            which = logical(spikes.processedClusters);
            try
                %                 keyboard
                dt = 0.0001;
                bins = 0:dt:.01;
                [x]=histc(diff(spikes.spikeTimestamps(which)),bins);
                bar(bins*1000,x);
                xlim([0 10]);
                if max(x)>0
                    ylim([0 max(x)*1.1]);
                    hold on;
                    plot([1 1],[0,max(x)*1.1],'k','linewidth',3);
                    plot([2 2],[0,max(x)*1.1],'k--','linewidth',1);
                else
                    ylim([0 1]);
                    hold on;
                    plot([1 1],[0,1],'k','linewidth',3);
                    plot([2 2],[0,1],'k--','linewidth',1);
                    text(5,0.5,'no spikes','horizontalalignment','center','verticalalignment','middle');
                end
                
            catch
                warning('unable to plot for some reawson');
                keyboard
                plot(spikes.spikeWaveforms)
            end
        end
        
        function out = getChannels(a)
            out = a.channels;
        end
        function a = updateAnalysis(a,c)
            a.data = c;
        end
        function out = getCompleteLFPRecordsForAnalysis(s)
            trodeName = createTrodeName(s.channels);
            out.LFPData = [];
            out.LFPDataTimes = [];
            path = fullfile(s.dataPath,s.subject,'analysis',s.sourceFolder);
            
            for i=1:length(s.trials)
                % get the records for LFP
                fileName=['LFPRecord_' num2str(s.trials(i)) '.mat'];
                fullFileName = fullfile(s.dataPath,s.subject,'LFPRecords',fileName);
                if ~exist(fullFileName,'file')
                    warning('LFPRecords do not exist...returning empty for the time being');
                    out.LFPData = [];
                    out.LFPDataTimes = [];
                    return
                else
                temp = load(fullFileName);
                x=temp.LFPRecord.(trodeName);
                LFP=makerow(x.data);
                lfpTimes = linspace(x.dataTimes(1),x.dataTimes(2),length(x.data));
                out.LFPData = [out.LFPData LFP];
                out.LFPDataTimes = [out.LFPDataTimes lfpTimes];
                end
            end
        end
        function out = getDegPerPix(s)
            d = getDistanceToMonitor(s.rig);
            xPix = getPixs(s.monitor,1);
            w = getDims(s.monitor,1);
            theta = rad2deg(2*atan(w/(2*d)));
            out = theta/xPix;
        end
        function out = getBurstStats(s) 
            spikeRec = getSpikes(s);
            keyboard
            [burstfract,burstsize,cv,avg_isi,cv_isi] = get_burst_stats(spktimes, preisi, inisi)
        end
    end
end