function out = chooseSFs(SFe,varargin)

if nargin==2
    searchMode = 'latestSingleUnit';
    singleUnitDetails = varargin{1};
else
    searchMode = 'trawlPhysAnalysis';
end

switch searchMode
    case 'latestSingleUnit'
        % typically sUs are stored in dataSource,ratID,analysis,singleUnits
        unitLocation = fullfile(SFe.dataSource,singleUnitDetails.subjectID,'analysis','singleUnits');
        % find the singleUnit object of interest.
        d = dir(unitLocation);
        d = d(~ismember({d.name},{'.','..'}));
        [junk order] = sort([d.datenum]);
        d = d(order);
        temp = load(fullfile(unitLocation,d(end).name));
        sU = temp.currentUnit;
    otherwise
        error('unknown method');
end

% we have the analysis. now do the choosing and give the output
switch SFe.estimationMethod{1}
    case 'gratingsSF'
        % get the sfGratings object from single unit. always use the last
        % analysis
        sfG = getSFs(sU);
        sfG = sfG(end);
        %get the analysis from the sfGratings object. 
        analysis = getAnalysis(sfG);
    otherwise
        error('unknown method');
end

switch SFe.estimationMethod{2}
    case 'highestF0'
        out = analysis.spatialfrequencies(analysis.rate==max(analysis.rate));
    case 'highestF1'
        out = analysis.spatialfrequencies(analysis.pow==max(analysis.pow));
    case 'highestCoh'
        out = analysis.spatialfrequencies(analysis.coh==max(analysis.coh));
    case '2XOptimalSF'
        out = analysis.spatialfrequencies(analysis.pow==max(analysis.pow))/2;
    case 'highestF1SFGreaterThan'
        whichAllowed = analysis.spatialfrequencies<SFe.estimationMethod{3};
        allowedAnalyses = analysis.pow(whichAllowed);
        allowedSFs = analysis.spatialfrequencies(whichAllowed);
        out = allowedSFs(allowedAnalyses==max(allowedAnalyses));
    otherwise
        error('unknown method');
end
end