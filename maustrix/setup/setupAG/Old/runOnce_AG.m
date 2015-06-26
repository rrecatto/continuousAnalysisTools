function runOnce_AG

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
rx=createRatrixWithDefaultStations(machines,dataPath,'localTimed');
permStorePath=fullfile(dataPath,'PermanentTrialRecordStore');
mkdir(permStorePath);
rx=setStandAlonePath(rx,permStorePath);
fprintf('created new ratrix\n')

pOD = @mouseTraining_Return;


switch mac
    case 'BC305BD38BFB' % ephys-stim
        sub = subject('999','mouse','c57bl/6j','male','12/30/2012','unknown','unknown','wild caught','unknown','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('999'),true,true,true,8,rx,'mouseTraining_OD','bas');
        % changed protocol to variedDur and to step 5 on 7/29
       
         sub = subject('demo1','mouse','c57bl/6j','male','12/30/2012','unknown','unknown','wild caught','unknown','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('demo1'),true,true,true,8,rx,'mouseTraining_OD','bas');
        % changed protocol to variedDur and to step 5 on 7/29
        
    case 'A41F7278B4DE' %gLab-Behavior1

    case 'A41F729213E2' %gLab-Behavior2

    case 'A41F726EC11C' %gLab-Behavior3

    case '7845C4256F4C' %gLab-Behavior4

    case '7845C42558DF' %gLab-Behavior5
       
        subjectID = '227';
        sub = subject(subjectID,'mouse','c57bl/6j','female','04/03/2013','unknown','a 04/03/2013','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('227'),true,true,true,1,rx,'mouseTraining_OD','bas');
        
        subjectID = '246';
        sub = subject(subjectID,'mouse','c57bl/6j','female','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('246'),true,true,true,1,rx,'mouseTraining_OD','bas');
        
        subjectID = '247';
        sub = subject(subjectID,'mouse','c57bl/6j','female','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('247'),true,true,true,1,rx,'mouseTraining_OD','bas');
        
        
        subjectID = '249';
        sub = subject(subjectID,'mouse','c57bl/6j','male','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('249'),true,true,true,1,rx,'mouseTraining_OD','bas');
        
        subjectID = '999';
        sub = subject(subjectID,'mouse','c57bl/6j','male','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('999'),true,true,true,1,rx,'mouseTraining_OD','bas');
    case 'A41F729211B1' %gLab-Behavior6
        
        sub = subject('999','virtual','none','none','02/27/2014','unknown','unknown','Jackson Laboratories','none','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pMotion('999'),true,true,true,5,rx,'mouseTraining_OD','bas');
    otherwise
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
end

end