function setupRig(reEvaluate)
% SETUPRIG(REEVALUATE) Sets up the machine for stim, data or analysis
%   This function uses the setenv function to set the most important rig
%   specific values. Most importantly info about the identity of data and
%   stim computers and the folders for analysis and data acquisition.
%
%   See also FLUSHRIGSPECIFICENVVARIABLES.

if ~exist('reEvaluate','var')||isempty(reEvaluate)
    reEvaluate = false;
elseif ~islogical(reEvaluate)
    error('reEvaluate needs to be a logical');
end
if reEvaluate
    flushRigSpecificEnvVariables();
end
if ~exist(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'),'file')
    q = questdlg('Press "Yes" if this is a part of a physiology rig.','Is this computer part of a phys rig?');
else
    temp = load(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'));
    if isfield(temp,'isRig') && ~temp.isRig
        q = 'No';
    else
        q = 'Yes';
    end
end
switch q
    case 'Yes'
        if ~exist(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'),'file')
            succ = getAndLoadEnvVariables;
        else
            env = load(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'));
            succ = loadEnvVariables(env);
        end
        if succ
            fprintf('\nRig is setup for physiology.\n');
        end
    case 'No'
        if ~exist(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'),'file')
            isRig = false;
            save(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'),'isRig');
        end
    case 'Cancel'
        fprintf('\nOK, doing nothing to the environment variables\n');
end
end

function succ = getAndLoadEnvVariables
succ = false;
env = struct;
% env.variableNames = {'MACHINETYPE','DATAIP','STIMIP','ANALYSISIP','DAQFOLDER','EVENTSFOLDER','SCRATCHFOLDER'};
% IP address
IPAddr = getIPAddress();

% 'stim' or 'data'
isData = false;
isStim = false;
isAnalysis = false;
pString = sprintf('The current machine has IP:%s. Is this a "stim" or "data" machine?',IPAddr);
machineTypeOptions = {'stim','data','analysis'};
[Selection,ok] = listdlg('ListString',machineTypeOptions,'Name','Stim or Data?','PromptString',pString,'SelectionMode','single');
if ~ok
    error('need to specify if data or stim machine');
else
    env.MACHINETYPE = machineTypeOptions{Selection};
end
switch Selection
    case 'data'
        isData = true;
        env.DATAIP = IPAddr;
    case 'stim'
        isStim = true;
        env.STIMIP = IPAddr;
    case 'analysis'
        isAnalysis = true;
        env.ANALYSISIP = IPAddr;
end

if ~isData % get data IP
    done = false;
    while ~done
        prompt = {'Enter IP Address:'};
        dlg_title = 'Data Machine';
        num_lines = 1;
        def = {'132.239.159.247'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(answer)
            errordlg('need to input an ip address');
        else
            dataIP = answer{1};
            fprintf('\n IP address for data machine is %s. Going to ping for responses.\n',dataIP);
            succ = ping(dataIP);
            if succ
                done = true;
                env.DATAIP = dataIP;
                fprintf('\n Success! IP address for data machine set to %s.\n',dataIP);
            else
                errStr = sprintf('specified IP (%s) not accessible',dataIP);
                errordlg(errStr);
            end
        end
    end
end

if ~isStim % get stim IP
    done = false;
    while ~done
        prompt = {'Enter IP Address:'};
        dlg_title = 'Stim Machine';
        num_lines = 1;
        def = {'132.239.159.67'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(answer)
            errordlg('need to input an ip address');
        else
            stimIP = answer{1};
            fprintf('\n IP address for stim machine is %s. Going to ping for responses.\n',stimIP);
            succ = ping(stimIP);
            if succ
                done = true;
                env.STIMIP = stimIP;
                fprintf('\n Success! IP address for stim machine set to %s.\n',stimIP);
            else
                errStr = sprintf('specified IP (%s) not accessible',stimIP);
                errordlg(errStr);
            end
        end
    end
end

if ~isAnalysis % get analysis IP
    done = false;
    while ~done
        prompt = {'Enter IP Address:'};
        dlg_title = 'Analysis Machine';
        num_lines = 1;
        def = {''};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(answer)
            errordlg('need to input an ip address');
        else
            analysisIP = answer{1};
            if isempty(analysisIP)
                fprintf('\nAnalsyis location not set. This is fine...\n');
                env.ANALYSISIP = '';
                done = true;
            else
                fprintf('\n IP address for analysis machine is %s. Going to ping for responses.\n',analysisIP);
                succ = ping(analysisIP);
                if succ
                    done = true;
                    env.ANALYSISIP = analysisIP;
                    fprintf('\n Success! IP address for analysis machine set to %s.\n',analysisIP);
                else
                    errStr = sprintf('specified IP (%s) not accessible',analysisIP);
                    errordlg(errStr);
                end
            end
        end
    end
end

done = false;
while ~done
    prompt = {'Enter IP Address:'};
    dlg_title = 'Eye Machine';
    num_lines = 1;
    def = {''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        errordlg('need to input an ip address');
    else
        eyeIP = answer{1};
        if isempty(eyeIP)
            fprintf('Eye tracker location not set. This is fine...\n');
            env.EYEIP = '';
            done = true;
        else
            succ = ping(eyeIP);
            if succ
                done = true;
                env.EYEIP = eyeIP;
            else
                errStr = sprintf('specified IP (%s) not accessible',eyeIP);
                errordlg(errStr);
            end
        end
    end
end



% get DAQFOLDER, EVENTSFOLDER, SCRATCHFOLDER
done = false;
firstTime = true;
while ~done
    prompt = {'Enter DAQ Folder:','Enter Events Folder:','Enter Scratch Folder:'};
    dlg_title = 'Folders for data';
    num_lines = 1;
    if firstTime
        firstTime = false;
        DAQDefault = sprintf('\\\\%s\\datanetOutput',env.DATAIP);
        EventsDefault = sprintf('\\\\%s\\eventsData',env.DATAIP);
        ScratchDefault = sprintf('\\\\%s\\onTheFly',env.DATAIP);
    else
        DAQDefault = answer{1};
        EventsDefault = answer{2};
        ScratchDefault = answer{3};
    end
    def = {DAQDefault,EventsDefault,ScratchDefault};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        errordlg('need to input an ip address');
        firstTime = true;
    else
        DAQOK = false;
        EVENTSOK = false;
        SCRATCHOK = false;
        
        if isdir(answer{1})
            DAQOK = true;
        end
        if isdir(answer{2})
            EVENTSOK = true;
        end
        if isdir(answer{3})
            SCRATCHOK = true;
        end
        
        if ~DAQOK || ~EVENTSOK || ~SCRATCHOK
            errormsg = {'','','','',''};
            if DAQOK
                errormsg{1} = '\color{black}\rm DAQ path is OK';
            else
                errormsg{1} = '\color{red}\bf    DAQ path is BAD';
            end
            if EVENTSOK
                errormsg{2} = '\color{black}\rm Events path is OK';
            else
                errormsg{2} = '\color{red}\bf    Events path is BAD';
            end
            if SCRATCHOK
                errormsg{3} = '\color{black}\rm Scratch path is OK';
            else
                errormsg{3} = '\color{red}\bf    Scratch path is BAD';
            end
            errormsg{5} = '\color{black}\bf Ensure that all folders are accessible';
            x = errordlg(errormsg);
            xTextChildren = get(x,'Children');
            set(get(xTextChildren(2),'Children'),'Interpreter','tex');
        else
            done = true;
            env.DAQFOLDER = answer{1};
            env.EVENTSFOLDER = answer{2};
            env.SCRATCHFOLDER = answer{3};
        end
    end
end

% now save rigSetup.m in the appropriate place
filename = fullfile(getRatrixPath,'bootstrap','rigSetup.mat');
MACHINETYPE = env.MACHINETYPE;
DATAIP = env.DATAIP;
STIMIP = env.STIMIP;
ANALYSISIP = env.ANALYSISIP;
EYEIP = env.EYEIP;
DAQFOLDER = env.DAQFOLDER;
EVENTSFOLDER = env.EVENTSFOLDER;
SCRATCHFOLDER = env.SCRATCHFOLDER;

save(filename,'MACHINETYPE','DATAIP','STIMIP','ANALYSISIP','EYEIP','DAQFOLDER','EVENTSFOLDER','SCRATCHFOLDER');

succ = loadEnvVariables(env);
end

function succ = loadEnvVariables(env)
succ = false;
variables = fieldnames(env);
if any(~ismember(variables,{'MACHINETYPE','DATAIP','STIMIP','ANALYSISIP','EYEIP','DAQFOLDER','EVENTSFOLDER','SCRATCHFOLDER'}))
    error('cannot add arbitrary environment variables');
end
setenv('MACHINETYPE',env.MACHINETYPE);
setenv('DATAIP',env.DATAIP);
setenv('STIMIP',env.STIMIP);
setenv('ANALYSISIP',env.ANALYSISIP);
setenv('EYEIP',env.EYEIP);
setenv('DAQFOLDER',env.DAQFOLDER);
setenv('EVENTSFOLDER',env.EVENTSFOLDER);
setenv('SCRATCHFOLDER',env.SCRATCHFOLDER);

end