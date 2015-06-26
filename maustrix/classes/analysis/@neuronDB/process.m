function db=process(db,which,mode)
if ~exist('which','var') || isempty(which)
    which='lastAnalysis';
end

if ~exist('mode','var') || isempty(mode)
    mode=db.mode;
end

[aInd nID subAInd]=db.selectIndexTool(which);
x=db.getFlatFacts({'thresholdVoltage'});



if any(strcmp(class(which),{'double'}))
    which='neuronIDs';
end

neurons=unique(nID);
numNeurons=length(neurons);
for i=1:numNeurons
    whichLogical=nID==neurons(i);
    whichInd=find(whichLogical);
    switch which
        case 'lastNeuron'
            trials=db.data{end}.trials; % non-contiguous trials cause a problem!
            p.subjectID=db.data{end}.subject;
            %this is just using the first thrV in the cell... failt
            %to be sensitive to differences b/c processing the
            %whole cell
            p.thrV=x.thresholdVoltage{aInd(i)};
        case 'lastAnalysis'
            trials=minmax(db.data{end}.analyses{end}.trials);
            p.subjectID=db.data{end}.subject;
            p.thrV=db.data{end}.thresholdVoltage{end};
        case {'all','neuronIDs'}
            trials=db.data{neurons(i)}.trials; % non-contiguous trials cause a problem!
            p.subjectID=db.data{neurons(i)}.subject;
            p.thrV=x.thresholdVoltage{aInd(whichInd(1))};  % the first one only
        otherwise
            which
            error('bad selection')
    end
    
    %mask logic
    fullTrialList=min(trials):max(trials);
    mask=setdiff(fullTrialList,trials);
    
    %start building a parameters of the calls to runAnalysis
    p.channels={db.data{neurons(i)}.channels};  % all singleUnits have only a single set of channels
    p.analysisMode=mode;
    p.standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','getBasicParams.m'); % warning... this is just a record and has no effect
    p.cellBoundary={'trialRange',minmax(trials),'trialMask',mask};
    
    %default parameters are faster and no inspect for pre-processing
    switch p.analysisMode
        case {'onlySort','onlyDetect','onlyDetectAndSort','overwriteAll'}
            p.fni=true;
        otherwise
            p.fni=false;
    end
    
    if IsLinux
        path=recordsPathLUT('\\132.239.158.169\datanetOutput','Win2Lx');  %on balaji's work station
        p.recordsPath.neuralRecordLoc = path;
        p.recordsPath.stimRecordLoc = path;
        p.recordsPath.spikeRecordLoc = path;
        p.recordsPath.analysisLoc = path;
        p.recordsPath.eyeRecordLoc = path;
    else
        path='\\132.239.158.169\datanetOutput';  %on balaji's work station
        p.recordsPath.neuralRecordLoc = path;
        p.recordsPath.stimRecordLoc = path;
        p.recordsPath.spikeRecordLoc = path;
        p.recordsPath.analysisLoc = path;
        p.recordsPath.eyeRecordLoc = path;
    end
    
    %mem helper - might be able to force something through
    if 0
        db=[];
        pack
    end
    
    %try
    analysis = runAnalysis('subjectID',p.subjectID,'channels',p.channels,'thrV',p.thrV,'cellBoundary',p.cellBoundary,'standardParams',p.standardParams,'forceNoInspect',p.fni,'recordsPaths',p.recordsPath,'analysisMode',p.analysisMode);
    if ~isempty(analysis)
        results.analysis{neurons(i)}=analysis;
    end
    %                  catch ex
    %                      keyboard
    %                      results.analysis{neurons(i)}=ex;
    %                      action=[p.analysisMode '- FAILED on neuron ' num2str(neurons(i))];
    %                      db=db.registerAction(action,ex);
    %                  end
end

action=[p.analysisMode '-' which];
db=db.registerAction(action,p);
end