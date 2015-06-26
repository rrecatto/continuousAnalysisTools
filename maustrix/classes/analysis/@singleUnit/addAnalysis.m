function s = addAnalysis(s,varargin)
switch nargin
    case 2
        if isa(varargin{1},'analysis')
            %add the analysis
            a = varargin{1};
            index=length(s.analyses)+1;
            s.analyses{index}=a;
            s.analysisType{index} = getType(a);
            s.sortQuality(index)=NaN;
            s.eyeQuality(index)=NaN;
            s.analysisQuality(index)=NaN;
            s.rigState{index} = NaN;
            s.ampState{index} = NaN;
            s.included(index)=true;
            s.thresholdVoltage{index}=NaN;
            s.comment{index}='';
        end
    otherwise
        %get the stimDetails
        %Q:why so slow?
        trials=varargin{1};
        thrV=varargin{2};
        sortQuality=varargin{3};
        eyeQuality=varargin{4};
        analysisQuality=varargin{5};
        
        rS.rigState = varargin{6};
        rS.calcMethod = 'default';
        rS.monitor = varargin{11};
        rigState = rig('default',rS);
        
        ampState = varargin{7};
        included = varargin{8};
        anesth = varargin{9};
        comment=varargin{10};
        mon = monitor(varargin{11});
        [physRecords success filePaths]=getPhysRecords(s.subjectDataPath,{'trialRange',[min(trials) min(trials)]},{'stim'},'anything');
        if ~success
            [min(trials) max(trials)]
            s.subjectDataPath
            error('load failed ... check subjectDataPath');
        end
        
        %create stim manager
        sm=eval(physRecords.stimManagerClass);
        
        %ask it for the analysis object
        %(stimManger superclass has a genetric one)
        chans = s.channels;
        dataPath = getDataPath(s);
        analysisSubFolder=s.getAnalysisSubFolder(trials);
        analysisPath = fullfile(s.subjectDataPath,'analysis',analysisSubFolder);
        params.analysisMode = 'viewAnalysisOnly';
        if exist(analysisPath,'dir')
            c = getPhysAnalysis(analysisPath,params);
        else
            trials
            error('first do the analysis!');
        end
        if isempty(c)
            disp('in singleUnit/addAnalysis...')
            keyboard;
        end
%         warning('setting c to empty here.ensures that analyses in other folders do not mess with the creation process');
%         c = [];
        
        a=getPhysAnalysisObject(sm,s.subject,trials,chans,dataPath,physRecords,c,mon,rigState);
        
        a=a.addAnesthesia(anesth);
        
        disp('WARNING: not currently bothering to check that all the trials are the same type')
        a=addTrialNumbersManually(a,trials);
        
        %add the analysis
        index=length(s.analyses)+1;
        s.analyses{index}=a;
        
        %sync the other properties
        s.sortQuality(index)=sortQuality;
        s.eyeQuality(index)=eyeQuality;
        s.analysisQuality(index)=analysisQuality;
        
        s.ampState{index} = ampState;
        
        s.included(index)=included;
        s.thresholdVoltage{index}=thrV;
        s.comment{index}=comment;
        s.analysisType{index}=getType(a);
end
%inform the superclass
s = updateTrialNumbers(s,a);
%inform the analyses
% s = informEachAnalysisOfNewSourceFolder(s);
end