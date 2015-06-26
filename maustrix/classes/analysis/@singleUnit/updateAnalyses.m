function s=updateAnalyses(s)
trials=s.trials;
dataPath = getDataPath(s);
analysisSubFolder=s.getAnalysisSubFolder(trials);
analysisPath = fullfile(s.subjectDataPath,'analysis',analysisSubFolder);
params.analysisMode = 'viewAnalysisOnly';
c = getPhysAnalysis(analysisPath,params);
if isempty(c)
    disp(sprintf('empty return: need to run analysis for these trials: [%d %d] ',min(s.trials),max(s.trials)))
else
    
    disp('AVAILABLE IN CUMULATIVE')
    %display  all c
    for i=1:length(c)
        disp(sprintf(' [%d %d] \t%s  \t\t%s',min(c{i}{2}),max(c{i}{2}),c{i}{3}, c{i}{4}))
    end
    disp('')
    disp('SOUGHT BY ANALYSIS OBJECT')
    %display  all c
    for i=1:length(s.analyses)
        theseTrials=s.analyses{i}.trials;
        type=s.analyses{i}.getType();
        disp(sprintf(' [%d %d] \t%s ',min(theseTrials),max(theseTrials), type))
    end
    
    
    %add the analysis
    for i=1:length(s.analyses)
        %find the trial range for this analysis
        theseTrials=s.analyses{i}.trials;
        if all(minmax(c{i}{2})==minmax(theseTrials))
            fprintf('%s.',c{i}{3})
            s.analyses{i}=updateAnalysis(s.analyses{i},c{i}{1});
        else
            trialsInData=c{i}{2};
            trialsInAnalysisObject=theseTrials
            error('bad pairing of trial numbers to the analysis... chec the that you stored them.. this tool wants consequiive ascending trails to match up to records')
        end
    end
end
end