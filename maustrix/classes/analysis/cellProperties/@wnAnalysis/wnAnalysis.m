classdef wnAnalysis < physiologyAnalysis
    properties (SetAccess = private)
        stimInfo
        STA
        STV
        STC
        timeWindow
        numSpikes
    end
    properties (Transient = true);
        relevantIndex
    end
    
    methods
        %% constructor
        function s = wnAnalysis(subject,trials,channels,dataPath,stim,c,monitor,rigState)
            s = s@physiologyAnalysis(subject,trials,channels,dataPath,monitor,rigState);
            s.stimInfo = stim;

            %keyboard
            if ~isempty(c)
                s = updateAnalysis(s,c);
            end            
        end % wnAnalysis

        function plotGLM(ao,mode)
            
            if ~exist('mode','var') || isempty(mode)
                mode=4;
            end
            
            %make tool and define paths
            g=glmTool({'photoDiode'},30);
            g.dataPath=fullfile(ao.dataPath,ao.subject,'analysis',ao.sourceFolder);
            g.dataSource='glmSource.mat';

            reload=0;
            if reload
                %reloads a previous one
                g=g.loadData('path2mat')
            else
                %make the data and load it
                [param.spikes param.frames]=ao.getSpikes;
                param.stimInfo=ao.stimInfo;
                param.info=ao.STA;
                g=g.loadData('rlab',param)
            end

            timeSamps=[-30:-1];  %samples before the spike
            LFPtimeSamps=[-301:10:-1];
            samplingRate=500;
                        
            switch mode
                case 1
                    %only photodiode
                    g.useFeatures={'photoDiode'};
                    g.temporalFeatureSampling={timeSamps};
                case 2
                    %add spike history
                    g.useFeatures={'photoDiode','spikes'};
                    g.temporalFeatureSampling={timeSamps,timeSamps};
                case 3
                    %add theta
                    theta=ao.getPowerOfLFP([3 7],samplingRate);
                    g=g.addData('theta',theta);
                    g.useFeatures={'photoDiode','spikes','theta'};
                    g.temporalFeatureSampling={timeSamps,timeSamps,[-1000:333:-1]};
                case 31
                    %add alphaBeta (their combined power)
                    alphaBeta=ao.getPowerOfLFP([8 30],samplingRate);
                    g=g.addData('alphaBeta',alphaBeta);
                    g.useFeatures={'photoDiode','spikes','alphaBeta'};
                    g.temporalFeatureSampling={timeSamps,timeSamps,timeSamps};
               case 4
                    %add both
                    theta=ao.getPowerOfLFP([3 7],samplingRate);
                    g=g.addData('theta',theta);
                    alphaBeta=ao.getPowerOfLFP([8 30],samplingRate);
                    g=g.addData('alphaBeta',alphaBeta);
                    g.useFeatures={'photoDiode','spikes','theta','alphaBeta'};
                    g.temporalFeatureSampling={timeSamps,timeSamps,[-1000:333:-1],[-1001:125:-1]};
                otherwise
                    mode
                    error('bad selection')
            end
             

            g.trainTimeRangeSec=[0 Inf];          %all of data for training
            [g fTrain]=g.createPredictors(g.trainTimeRangeSec,false);  % build model
            g=g.estimateSpikeProb; % predict spikes with GLM
            g.plotBetas(g.useFeatures)
            
      end
        
        function s = updateAnalysis(s,c)
            if iscell(c)
                c = c{1}{1};
            end
            if isstruct(c) && isfield(c.(createTrodeName(s.channels)),'cumulativeSTA')
                if length(size(c.(createTrodeName(s.channels)).cumulativeSTA))==3
                    s.STA = c.(createTrodeName(s.channels)).cumulativeSTA;
                    s.STV = c.(createTrodeName(s.channels)).cumulativeSTV;
                    if isfield(c.(createTrodeName(s.channels)),'timeWindowMsStim')
                        s.timeWindow = c.(createTrodeName(s.channels)).timeWindowMsStim;
                    else
                        warning('setting stuff manually');
                        s.timeWindow = [300 50];
                    end
                    s.numSpikes = c.(createTrodeName(s.channels)).cumulativeNumSpikes;
                    s.relevantIndex = 'maxDeviation';
                elseif length(size(c.(createTrodeName(s.channels)).cumulativeSTA))==2
                    s.STA(1,1,:) = c.(createTrodeName(s.channels)).cumulativeSTA;
                    s.STV(1,1,:) = c.(createTrodeName(s.channels)).cumulativeSTV;
                    s.timeWindow = c.(createTrodeName(s.channels)).timeWindowMsStim;
                    s.numSpikes = c.(createTrodeName(s.channels)).cumulativeNumSpikes;
                    s.relevantIndex = 'maxDeviation';
                else
                    error('now why would this ever happen???');
                end
                
            else
                error('needs a cumulative analysis');
            end
        end
       
        
        function s = set.relevantIndex(s,criterion)
            if ~exist('criterion','var')||isempty(criterion)
                criterion = 'maxDeviation';
            end
            if ~ischar(criterion)
                error('criterion should be a character');
            end
            s.relevantIndex = findPixel(s,criterion);
        end
        
        function out = get.relevantIndex(s)
            if isempty(s.relevantIndex)
                criterion = 'maxDeviation';
                out = findPixel(s,criterion);
            else
                out = s.relevantIndex;
            end
        end
        
    end
end
