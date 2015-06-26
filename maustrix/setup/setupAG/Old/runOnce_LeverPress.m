function runOnce_LeverPress

dataPath=fullfile(fileparts(fileparts(getRatrixPath)),'ratrixData',filesep);

try
    [success, mac]=getMACaddress();
    if ~success
        mac='000000000000';
    end
catch
    mac='000000000000';
end

machines={{'1U',mac,[1 1 1]}};
rx=createRatrixWithDefaultLeverPressStations(machines,dataPath,'localTimed');
permStorePath=fullfile(dataPath,'PermanentTrialRecordStore');
mkdir(permStorePath);
rx=setStandAlonePath(rx,permStorePath);
fprintf('created new ratrix\n')

pMotion = @mouseTraining_Motion_Lever;

switch mac
    case 'A41F729211B1' %gLab-Behavior6
        
        sub = subject('999','virtual','none','none','02/27/2014','unknown','unknown','Jackson Laboratories','none','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pMotion('999'),true,true,true,5,rx,'mouseTraining_OD','bas');
        
        sub = subject('L001','mouse','c57bl/6j','female','03/21/2014','unknown','a 03/21/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pMotion('L001'),true,true,true,1,rx,'mouseTraining_OD','bas');
        
        sub = subject('L002','mouse','c57bl/6j','female','03/21/2014','unknown','a 03/21/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pMotion('L002'),true,true,true,1,rx,'mouseTraining_OD','bas');
    case 'BC305BD38BFB' % ephys-stimPC
        sub = subject('310','mouse','c57bl/6j','female','08/03/2013','unknown','unknown','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pMotion('310'),true,true,true,4,rx,'mouseTraining_OD','bas');
        
        sub = subject('999','virtual','none','none','02/27/2014','unknown','unknown','Jackson Laboratories','none','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pMotion('999'),true,true,true,5,rx,'mouseTraining_OD','bas');
    otherwise
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
end

end