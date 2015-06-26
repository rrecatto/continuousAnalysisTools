%% 366
subjectID = '366';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';




% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[20 33]}; %ffgwn
% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[35 37]}; %sfSinGr
% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[38 40]}; %sfSinGr

% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[45 47]}; %orgr1024

% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[53 72]}; %ffgwn300
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[73 92]}; %ffgwn600


%% new cell
% subjectID = '366'; channels={3,6,8,9,12}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[113 125]}; %ffgwn300


% subjectID = '366'; channels={3,6,8,9}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[166 168]}; %or
% trialRange = [166 167 168];
% subjectID = '366'; channels={3,6}; thrV = [-0.1 Inf 0.5]; %cellBoundary={'trialRange',[166 168]}; %or
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[192 222],'trialMask',[192] }; %ffgwnsearch
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[193 222]}; %ffgwnsearch
% 
% subjectID = '366'; channels={3,6,8}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[268 278]}; %or
% trialRange = [268:278];
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[328 340]}; %ffgwn
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[353 361]}; %or
% 
% 
% subjectID = '366'; channels={3}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[367 373]}; %ffgwn
% 
% %% this is just for the sort before and after muscimol......
% %chan 3...whats happeing here?
% subjectID = '366'; channels={3}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[113 172],'trialMask',[138:156 177:180 192 366]}; %ffgwn
% subjectID = '366'; channels={3}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[181 210],'trialMask',[192]}; %ffgwn


subjectID = '366'; channels={13}; thrV = [-0.05 Inf 0.5]; cellBoundary={'trialRange',[133]}; %trf

analysisMode = 'onlyDetectAndSort';
%% ideas for analysisMode implemented
% analysisMode = 'overwriteAll';
% analysisMode = 'onlyAnalyze';
% analysisMode = 'viewAnalysisOnly'; 
% analysisMode = 'onlyDetect';
% analysisMode = 'onlySort';
% analysisMode = 'onlyDetectAndSort';
% analysisMode = 'onlyInspect';
% analysisMode = 'onlyInspectInteractive';

addCurrentAnalysis = true;
analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,'standardParams',standardParams,'analysisMode',analysisMode,'addCurrentAnalysis',addCurrentAnalysis);
