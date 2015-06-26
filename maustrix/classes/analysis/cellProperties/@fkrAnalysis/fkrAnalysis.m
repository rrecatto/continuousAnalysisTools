classdef fkrAnalysis < physiologyAnalysis
    properties (Access = private)
        stimInfo
        cumulativeData
    end
    
    methods
        %% constructor
        function ao = fkrAnalysis(subject,trials,channels,dataPath,stim,c)
            ao = ao@physiologyAnalysis(subject,trials,channels,dataPath);

            ao.stimInfo = stim;
            if ~isempty(c)
                ao.cumulativeData=c;
            end
        end
        
        function out = getType(ao)
            out = getType(ifFeatureGoRightWithTwoFlank,ao.stimInfo);
        end
        

        function plot2axis(ao,plotsRequested,ax)
            
            
                      
            if isempty(ao.cumulativeData)
                ao.textPlot('no analysis');
                return
            end
            
            %using some pre-existing code in flankers right now
            params.plotsRequested=plotsRequested;
            sm=ifFeatureGoRightWithTwoFlank;
            %ao.glmPlot(ao.cumulativeData)
            
            plotRaster(sm,ao.cumulativeData);
            %doRatePerCondition(sm,ao.cumulativeData,'on')
            %doRatePerCondition(sm,ao.cumulativeData,'off')
            %plotPSTH(sm,ao.cumulativeData);
        end

        function glmPlot(ao,c)
           

            %set g.data.info
            g=glmTool;
            warning('''ere')
            keyboard
            subFolder=getAnalysisSubFolder(singleUnit('x',[]),ao.trials);
            g.dataPath=fullfile(ao.dataPath,ao.subject,'analysis',subFolder);
            g.dataSource='glmSource.mat';
            
            reload=0;
            if reload
                %reloads a previous one
                g=g.loadData('path2mat')
            else
                %make the data and load it
                g=g.loadData('rlab',param)
            end

            g.addDataType('contrast',contrastVector);
            g.useFeatures={'contrast'};
            g.trainTimeRangeSec=[0 Inf];          %all of data for training
            [g fTrain]=g.createPredictors(g.trainTimeRangeSec,false);  % build model
            g=g.estimateSpikeProb(fTrain,fTrain); % predict spikes with GLM
            g.plotBetas('contrast')
            
        end
        
        function ao=flushAnalysis(ao)
            ao.cumulativeData=[];
            disp('flanker flushed')
        end
                
        function ao = updateAnalysis(ao,c)
            if iscell(c)
                c = c{1}{1}.trode_1;
            else
                c=c.trode_1;
            end
            
            %unchecked struct goes in (sloppy checking)
            c=rmfield(c,{'spikeWaveforms','eyeSig'});   %remove the big offenders
            ao.cumulativeData=c;
        end
    end
end