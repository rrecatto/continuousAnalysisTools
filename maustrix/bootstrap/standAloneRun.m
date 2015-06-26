function standAloneRun(subjectID,ratrixPath,setupFile,recordInOracle,backupToServer,testMode)
%standAloneRun([ratrixPath],[setupFile],[subjectID],[recordInOracle],[backupToServer])
%
% ratrixPath (optional, string path to preexisting ratrix 'db.mat' file)
% defaults to checking for db.mat in ...\<ratrix install directory>\..\ratrixData\ServerData\
% if none present, makes new ratrix located there, with a dummy subject
%
% setupFile (optional, name of a setProtocol file on the path, typically in the setup directory)
% defaults to 'setProtocolDEMO'
% if subject already exists in ratrix and has a protocol, default is no action
%
% subjectID (optional, must be string id of subject -- will add to ratrix if not already present)
% default is some unspecified subject in ratrix (you can't depend on which
% one unless there is only one)
%
% recordInOracle (optional, must be logical, default false)
% if true, subject must be in oracle database and history file name loading from
% database will be exercised.
%
% backupOnServer (optional, must be logical or a path to the server, default false)
% if true, will also replicate to a hard-coded server path
% all trial record indexing (standAlonePath) is still handled locally

%
setupEnvironment;

if ~exist('recordInOracle','var') || isempty(recordInOracle)
    recordInOracle = false;
elseif ~islogical(recordInOracle)
    error('recordInOracle must be logical')
end

if ~exist('backupToServer','var') || isempty(backupToServer)
    [backupToServer, xtraServerBackupPath] = getExtraBackupServers();    
elseif islogical(backupToServer);
    xtraServerBackupPath='\\Reinagel-lab.AD.ucsd.edu\RLAB\Rodent-Data\behavior\standAloneRecords';
elseif isDirRemote(backupToServer)
    xtraServerBackupPath=backupToServer;
    backupToServer=true;
else
    error('backupToServer must be logical or a valid path')
end

if ~exist('testMode','var') || isempty(testMode)
    testMode = false;
end

if exist('ratrixPath','var') && ~isempty(ratrixPath)
    if isdir(ratrixPath)
        rx=ratrix(ratrixPath,0);
    else
        ratrixPath
        error('if ratrixPath supplied, it must be a path to a preexisting ratrix ''db.mat'' file')
    end
else
    dataPath=fullfile(fileparts(fileparts(getRatrixPath)),'ratrixData',filesep);
    defaultLoc=fullfile(dataPath, 'ServerData');
    d=dir(fullfile(defaultLoc, 'db.mat'));

    if length(d)==1
        rx=ratrix(defaultLoc,0);
        fprintf('loaded ratrix from default location\n')
    else
        try
            [success mac]=getMACaddress();
            if ~success
                mac='000000000000';
            end
        catch
            mac='000000000000';
        end

        machines={{'1U',mac,[1 1 1]}};
        rx=createRatrixWithDefaultStations(machines,dataPath,'localTimed');
        permStorePath=fullfile(dataPath,'PermanentTrialRecordStore');
        mkdir(permStorePath);
        rx=setStandAlonePath(rx,permStorePath);
        fprintf('created new ratrix\n')
    end
end

%ensure that this subject is allowed to run here
[correctBox, whichBox] = ensureCorrectBoxForSubject(subjectID);
if ~correctBox
    whichBox
    error('run animal on the correct box please');
end

needToAddSubject=false;
needToCreateSubject=false;
if ~exist('subjectID','var') || isempty(subjectID)
    ids=getSubjectIDs(rx);
    if length(ids)>0
        subjectID=ids{1};
    else
        subjectID='demo1';
        needToCreateSubject=true;
        needToAddSubject=true;
    end
else
    subjectID=lower(subjectID);
    try
        isSubjectInRatrix=getSubjectFromID(rx,subjectID);
    catch ex
        if ~isempty(strfind(ex.message,'request for subject id not contained in ratrix'))
            if recordInOracle
                sub =createSubjectsFromDB({subjectID});
                if isempty(sub)
                    subjectID
                    error('subject not defined in oracle database')
                else
                    needToAddSubject=true;
                end
            else
                needToCreateSubject=true;
                needToAddSubject=true;
            end
        else
            rethrow(ex)
        end
    end
end

if needToCreateSubject
    warning('creating dummy subject')
    sub = subject(subjectID, 'rat', 'long-evans', 'male', '05/10/2005', '01/01/2006', 'unknown', 'wild caught');
end
auth='bas';

if needToAddSubject
    rx=addSubject(rx,sub,auth);
end

if (~exist('setupFile','var') || isempty(setupFile)) && ~isa(getProtocolAndStep(getSubjectFromID(rx,subjectID)),'protocol')
    setupFile='setProtocolDEMO';
end

if exist('setupFile','var') && ~isempty(setupFile)
    x=what(fileparts(which(setupFile)));
    if isempty(x) || isempty({x.m}) || ~any(ismember(lower({setupFile,[setupFile '.m']}),lower(x.m)))
        setupFile
        error('if setupFile supplied, it must be the name of a setProtocol file on the path (typically in the setup directory)')
    end

    su=str2func(setupFile); %weird, str2func does not check for existence!
    rx=su(rx,{subjectID});
    %was:  r=feval(setupFile, r,{getID(sub)});
    %but edf notes: eval is bad style
    %http://www.mathworks.com/support/tech-notes/1100/1103.html
    %http://blogs.mathworks.com/loren/2005/12/28/evading-eval/
end

[isExperimentSubject, xtraExptBackupPath, experiment] = identifySpecificExperiment(subjectID);

try
    deleteOnSuccess = true; 
    
    if backupToServer
        if isExperimentSubject
            replicationPaths={getStandAlonePath(rx),xtraServerBackupPath};
            for z = 1:length(xtraExptBackupPath)
                replicationPaths{end+1}=xtraExptBackupPath{z};
            end
        else
            replicationPaths={getStandAlonePath(rx),xtraServerBackupPath};
        end
    else
        replicationPaths={getStandAlonePath(rx)};
    end

    replicateTrialRecords(replicationPaths,deleteOnSuccess, recordInOracle);

    s=getSubjectFromID(rx,subjectID);

    [rx ids] = emptyAllBoxes(rx,'starting trials in standAloneRun',auth);
    boxIDs=getBoxIDs(rx);
    rx=putSubjectInBox(rx,subjectID,boxIDs(1),auth);    
    b=getBoxIDForSubjectID(rx,getID(s));
    st=getStationsForBoxID(rx,b);
    %struct(st(1))
    maxTrialsPerSession = 250;
    exitByFinishingTrialQuota = true;
    while exitByFinishingTrialQuota
        [rx,exitByFinishingTrialQuota]=doTrials(st(1),rx,maxTrialsPerSession,[],~recordInOracle);
        replicateTrialRecords(replicationPaths,deleteOnSuccess, recordInOracle);
    end
    [rx ids] = emptyAllBoxes(rx,'done running trials in standAloneRun',auth);
    if ~testMode
        compilePath=fullfile(fileparts(getStandAlonePath(rx)),'CompiledTrialRecords');
        mkdir(compilePath);
        dailyAnalysisPath = fullfile(fileparts(getStandAlonePath(rx)),'DailyAnalysis');
        mkdir(dailyAnalysisPath);
        compileDetailedRecords([],{subjectID},[],getStandAlonePath(rx),compilePath);
        
        selection.type = 'animal status';
        selection.filter = 'all';
        selection.filterVal = [];
        selection.filterParam = [];
        selection.titles = {sprintf('subject %s',subjectID)};
        selection.subjects = {subjectID};
        fs=analysisPlotter(selection,compilePath,true);
%         subjectAnalysis(compilePath);
    end
    cleanup;
    % testing
    clear all
catch ex
    disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
    
    [~, b] = getMACaddress();
    c = clock;
    message = {sprintf('Failed for subject::%s at time::%d:%d on %d-%d-%d',subjectID,c(4),c(5),c(2),c(3),c(1)),getReport(ex,'extended','hyperlinks','off')};
    switch b
        case 'A41F7278B4DE' %gLab-Behavior1
            gmail('sbalaji1984@gmail.com','Error in Rig 1',message);
        case 'A41F729213E2' %gLab-Behavior2
            gmail('sbalaji1984@gmail.com','Error in Rig 2',message);
        case 'A41F726EC11C' %gLab-Behavior3
            gmail('sbalaji1984@gmail.com','Error in Rig 3',message);
        case '7845C4256F4C' %gLab-Behavior4
            gmail('sbalaji1984@gmail.com','Error in Rig 4',message);
        case '7845C42558DF' %gLab-Behavior5
            gmail('sbalaji1984@gmail.com','Error in Rig 5',message);
        case 'A41F729211B1' %gLab-Behavior6
            gmail('sbalaji1984@gmail.com','Error in Rig 6',message);
        case 'BC305BD38BFB' %gLab-Behavior6
            gmail('sbalaji1984@gmail.com','Error in ephys-stim',message);
        otherwise
            warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
            keyboard;
    end
    replicateTrialRecords(replicationPaths,deleteOnSuccess, recordInOracle);
    cleanup;
    rethrow(ex)
end
end
function cleanup
sca
FlushEvents('mouseUp','mouseDown','keyDown','autoKey','update');
ListenChar(0)
ShowCursor(0)
end

function [backupToserver, xtraServerBackupPath] = getExtraBackupServers
backupToserver = false;
xtraServerBackupPath = '';
[a, b] = getMACaddress();
switch b
    case 'A41F7278B4DE' %gLab-Behavior1
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Permanent';
    case 'A41F729213E2' %gLab-Behavior2 'A41F729213E2','001D7DA80EFC'
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Permanent';
    case 'A41F726EC11C' %gLab-Behavior3
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Permanent';
    case '7845C4256F4C' %gLab-Behavior4
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Permanent';
    case '7845C42558DF' %gLab-Behavior5
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Permanent';
    case 'A41F729211B1' %gLab-Behavior6
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box6\Permanent';
    case 'BC305BD38BFB' %ephys-stim
        backupToserver = true;
        xtraServerBackupPath='\\ghosh-nas.ucsd.edu\ghosh\Behavior\ephys-stim\Permanent';
    case '180373337162' %ephys-data
        backupToServer = false;
    otherwise
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
end
end

function [correctBox, whichBox] = ensureCorrectBoxForSubject(subjID)
allowedTestSubjects = {'demo1','999'};

Box1Subjects = {'223','251','252','241','263'};
Box2Subjects = {'232','253','254','242','259'};
Box3Subjects = {'255','256','243','248','260'};
Box4Subjects = {'228','237','238','244','261'};
Box5Subjects = {'227','246','247','249'};
Box6Subjects = {'L001','L002'};
BoxEPhysSubjects = {'310'};
Subjects = {Box1Subjects,Box2Subjects,Box3Subjects,Box4Subjects,Box5Subjects,Box6Subjects,BoxEPhysSubjects};
currSubj = {subjID,subjID,subjID,subjID,subjID,subjID,subjID};
whichBox = find(cellfun(@ismember,currSubj,Subjects));
[junk, mac] = getMACaddress();
correctBox = false;
switch mac
    case 'A41F7278B4DE' %gLab-Behavior1
        if whichBox==1
            correctBox = true;
        end
    case 'A41F729213E2' %gLab-Behavior2
        if whichBox==2
            correctBox = true;
        end
    case 'A41F726EC11C' %gLab-Behavior3
        if whichBox==3
            correctBox = true;
        end
    case '7845C4256F4C' %gLab-Behavior4
        if whichBox==4
            correctBox = true;
        end
    case '7845C42558DF' %gLab-Behavior5
        if whichBox==5
            correctBox = true;
        end
    case 'A41F729211B1' %gLab-Behavior6
        if whichBox==6
            correctBox = true;
        end
    case 'BC305BD38BFB' %ephys-stim
        if whichBox==7
            correctBox = true;
        end
end

if ismember(subjID, allowedTestSubjects)
    correctBox = true;
end
end

function [isExperimentSubject, xtraExptBackupPath, experiments] = identifySpecificExperiment(subjectID);
isExperimentSubject = false;
xtraExptBackupPath = '';
experiments = '';


onGoingExperiments = {...
    'PV-V1-hM3D';...
    'PV-TRN-hM3D';...
    'V1Lesion';...
    'SCLesion';...
    'RocheProject';...
    'ORSweeps';...
    'VarDur';...
    'Motion';...
    'Reversal';...
    };

onGoingExperimentSubjects = {...
    {'61','63','65','67','69','200','201'};...
    {'60','64','66','202','211','212'};...
    {'22','23','25','26','37','38','40','45','47','48','50','53','56','59'};...
    {'60','61','65','66','95','98','200','201','202','205','209','210','211'};...
    {'213','216','220','221','225','226'};...
    {'218','223','227','228','232'};...
    {'246','247','248','249','250','223'};...
    {'241','242','243','244','245'};...
    {'237','238','239','240','251','252','253','254','255','256','257','258'};...
    };

experimentBackupLocation = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-TRN-hM3D\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\SCLesion\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\RocheProject\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\ORSweeps\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\VarDur\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Motion\Permanent';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Reversal\Permanent';...
};

x = cellfun(@any,cellfun(@ismember,onGoingExperimentSubjects,repmat({subjectID},size(onGoingExperimentSubjects)),'UniformOutput',false));
isExperimentSubject = any(x);

if isExperimentSubject
    xtraExptBackupPath = experimentBackupLocation(x);
end

experiments = onGoingExperiments(x);
end

