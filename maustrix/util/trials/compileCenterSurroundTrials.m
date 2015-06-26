function compileCenterSurroundTrials(startDate,stopDate,id,source,destination)

if (~exist('startDate','var') || isempty(startDate))
    error('startDate needs to be specified')
end

if (~exist('stopDate','var') || isempty(stopDate))
    stopDate = datestr(today);
end

if ~exist('id','var') || isempty(id) % if ids not given as input, retrieve from oracle or from source
    error('id needs to be specified')
elseif iscell(id) && length(id)>1
    error('only a single id is supported');
elseif ~iscell(id) && ischar(id)
    id = {id};
end

if ~exist('source','var') || isempty(source)
    error('please provide source');
end

if ~exist('destination','var') || isempty(destination)
    error('please provide destination');
end

subjectSource = fullfile(source,id{1});
d = dir(subjectSource);
[junk arrangement] = sort(datenum({d.date}));
dd_name = {d.name};
dd_date = {d.date};
dd_bytes = [d.bytes];
dd_datenum = [d.datenum];
dd_isdir = [d.isdir];
clear d
d.name = dd_name(arrangement);
d.date = dd_date(arrangement);
d.bytes = dd_bytes(arrangement);
d.datenum = dd_datenum(arrangement);
d.isdir = dd_isdir(arrangement);

which = ~ismember(d.name,{'.','..'}) & d.datenum>=datenum(startDate) & d.datenum<=datenum(stopDate);
d.name = d.name(which);
d.date = d.date(which);
d.bytes = d.bytes(which);
d.datenum = d.datenum(which);
d.isdir = d.isdir(which);
compiledTrialRecords = struct;
i = 1;
for ii = 1:length(d.name)
    temp = load(fullfile(subjectSource,d.name{ii}));
    for jj = 1:length(temp.trialRecords)
        compiledTrialRecords.trialNumber(i) = temp.trialRecords(jj).trialNumber;
        compiledTrialRecords.sessionNumber(i) = temp.trialRecords(jj).sessionNumber;
        compiledTrialRecords.datenum(i) = datenum(temp.trialRecords(jj).date);
        compiledTrialRecords.soundOn(i) = temp.trialRecords(jj).station.soundOn;
        compiledTrialRecords.numPorts(i) = temp.trialRecords(jj).station.numPorts;
        compiledTrialRecords.ifi(i) = temp.trialRecords(jj).station.ifi;
        compiledTrialRecords.protocolName{i} = temp.sessionLUT{temp.trialRecords(jj).protocolName};
        compiledTrialRecords.trainingStepNum(i) = temp.trialRecords(jj).trainingStepNum;
        compiledTrialRecords.rewardSizeULorMS(i) = temp.trialRecords(jj).reinforcementManager.rewardSizeULorMS;
        compiledTrialRecords.msPenalty(i) = temp.trialRecords(jj).reinforcementManager.reinforcementManager.msPenalty;
        compiledTrialRecords.scalar(i) = temp.trialRecords(jj).reinforcementManager.reinforcementManager.scalar;
        compiledTrialRecords.requestRewardSizeULorMS(i) = temp.trialRecords(jj).reinforcementManager.reinforcementManager.requestRewardSizeULorMS;
        compiledTrialRecords.stimManagerClass{i} = temp.sessionLUT{temp.trialRecords(jj).stimManagerClass};
        compiledTrialRecords.targetPorts(i) = temp.trialRecords(jj).targetPorts;
        compiledTrialRecords.distractorPorts(i) = temp.trialRecords(jj).distractorPorts;
        compiledTrialRecords.interTrialLuminance(i) = temp.trialRecords(jj).interTrialLuminance;
        compiledTrialRecords.resWidth(i) = temp.trialRecords(jj).resolution.width;
        compiledTrialRecords.resHeight(i) = temp.trialRecords(jj).resolution.height;
        compiledTrialRecords.resHz(i) = temp.trialRecords(jj).resolution.hz;
        if isstruct(temp.trialRecords(jj).stimDetails)&& strcmp(compiledTrialRecords.stimManagerClass{i},'afcGratingsWithOrientedSurround')
            compiledTrialRecords.correctionTrial(i) = temp.trialRecords(jj).stimDetails.correctionTrial;
            compiledTrialRecords.pixPerCycsCenter(i) = temp.trialRecords(jj).stimDetails.pixPerCycsCenter;
            compiledTrialRecords.pixPerCycsSurround(i) = temp.trialRecords(jj).stimDetails.pixPerCycsSurround;
            compiledTrialRecords.driftfrequenciesCenter(i) = temp.trialRecords(jj).stimDetails.driftfrequenciesCenter;
            compiledTrialRecords.driftfrequenciesSurround(i) = temp.trialRecords(jj).stimDetails.driftfrequenciesSurround;
            compiledTrialRecords.orientationsCenter(i) = temp.trialRecords(jj).stimDetails.orientationsCenter;
            compiledTrialRecords.orientationsSurround(i) = temp.trialRecords(jj).stimDetails.orientationsSurround;
            compiledTrialRecords.phasesCenter(i) = temp.trialRecords(jj).stimDetails.phasesCenter;
            compiledTrialRecords.phasesSurround(i) = temp.trialRecords(jj).stimDetails.phasesSurround;
            compiledTrialRecords.contrastsCenter(i) = temp.trialRecords(jj).stimDetails.contrastsCenter;
            compiledTrialRecords.contrastsSurround(i) = temp.trialRecords(jj).stimDetails.contrastsSurround;
            compiledTrialRecords.centerSize(i) = temp.trialRecords(jj).stimDetails.centerSize;
            compiledTrialRecords.pixPerCycsCenter(i) = temp.trialRecords(jj).stimDetails.pixPerCycsCenter;
            
            if all(cellfun(@ischar,{temp.trialRecords(jj).phaseRecords.phaseType})) && ...
                    (any(ismember({temp.trialRecords(jj).phaseRecords.phaseType},'discrim')) && ...
                    any(ismember({temp.trialRecords(jj).phaseRecords.phaseType},'reinforced')))
                whichDiscrim = ismember({temp.trialRecords(jj).phaseRecords.phaseType},'discrim');
                whichReinforced = ismember({temp.trialRecords(jj).phaseRecords.phaseType},'reinforced');
                
                compiledTrialRecords.responseTime(i) = temp.trialRecords(jj).phaseRecords(whichReinforced).responseDetails.startTime - ...
                    temp.trialRecords(jj).phaseRecords(whichDiscrim).responseDetails.startTime;
            else
                compiledTrialRecords.responseTime(i) = NaN;
            end
            
        else
            compiledTrialRecords.correctionTrial(i) = NaN;
            compiledTrialRecords.pixPerCycsCenter(i) = NaN;
            compiledTrialRecords.pixPerCycsSurround(i) = NaN;
            compiledTrialRecords.driftfrequenciesCenter(i) = NaN;
            compiledTrialRecords.driftfrequenciesSurround(i) = NaN;
            compiledTrialRecords.orientationsCenter(i) = NaN;
            compiledTrialRecords.orientationsSurround(i) = NaN;
            compiledTrialRecords.phasesCenter(i) = NaN;
            compiledTrialRecords.phasesSurround(i) = NaN;
            compiledTrialRecords.contrastsCenter(i) = NaN;
            compiledTrialRecords.contrastsSurround(i) = NaN;
            compiledTrialRecords.centerSize(i) = NaN;
            compiledTrialRecords.pixPerCycsCenter(i) = NaN;
            
            compiledTrialRecords.responseTime(i) = NaN;
        end
        
        if ~isempty( temp.trialRecords(jj).trialDetails.correct)
            compiledTrialRecords.correct(i) = double(temp.trialRecords(jj).trialDetails.correct);
        else
            compiledTrialRecords.correct(i) = NaN;
        end
        compiledTrialRecords.didHumanResponse(i) = temp.trialRecords(jj).didHumanResponse;
        compiledTrialRecords.containedForcedRewards(i) = temp.trialRecords(jj).containedForcedRewards;
        compiledTrialRecords.didStochasticResponse(i) = temp.trialRecords(jj).didStochasticResponse;
        compiledTrialRecords.containedManualPokes(i) = temp.trialRecords(jj).containedManualPokes;
        compiledTrialRecords.leftWithManualPokingOn(i) = temp.trialRecords(jj).leftWithManualPokingOn;
        
        i = i+1;
    end
    clear temp
    
end
compiledFileName  = sprintf('%s.compiledTrialRecords_%d-%d.mat',id{1},min(compiledTrialRecords.trialNumber),max(compiledTrialRecords.trialNumber));
save(fullfile(destination,compiledFileName),'compiledTrialRecords');

end