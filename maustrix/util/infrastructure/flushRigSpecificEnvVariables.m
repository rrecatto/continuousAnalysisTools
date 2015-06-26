function succ = flushRigSpecificEnvVariables
succ = false;
if exist(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'),'file')
    delete(fullfile(getRatrixPath,'bootstrap','rigSetup.mat'));
end
setenv('MACHINETYPE','');
setenv('DATAIP','');
setenv('STIMIP','');
setenv('ANALYSISIP','');
setenv('DAQFOLDER','');
setenv('EVENTSFOLDER','');
setenv('SCRATCHFOLDER','');
end