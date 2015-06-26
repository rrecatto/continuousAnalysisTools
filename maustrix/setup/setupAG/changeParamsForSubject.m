function changeParamsForSubject

dataPath=fullfile(fileparts(fileparts(getRatrixPath)),'ratrixData',filesep);
defaultLoc=fullfile(dataPath, 'ServerData');

d=dir(fullfile(defaultLoc, 'db.mat'));

if length(d)==1
    rx=ratrix(defaultLoc,0);
    fprintf('loaded ratrix from default location\n')
else
    error('you are doing something dangerous - are you sure you know what you are doing?');
end

try
    [success, mac]=getMACaddress();
    if ~success
        mac='000000000000';
    end
catch
    mac='000000000000';
end

pOD = @mouseTraining_Return;
switch mac
    case 'A41F7278B4DE' %gLab-Behavior1

    case 'A41F729213E2' %gLab-Behavior2
        
    case 'A41F726EC11C' %gLab-Behavior3
  
    case '7845C4256F4C' %gLab-Behavior4

    case '7845C42558DF' %gLab-Behavior5
        % find the birthdates ets for anumals
        
        subjectID = '227';
        sub = subject(subjectID,'mouse','c57bl/6j','female','04/03/2013','unknown','a 04/03/2013','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('227'),true,true,true,3,rx,'mouseTraining_OD','bas');
        
        subjectID = '246';
        sub = subject(subjectID,'mouse','c57bl/6j','female','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('246'),true,true,true,3,rx,'mouseTraining_OD','bas');
        
        subjectID = '247';
        sub = subject(subjectID,'mouse','c57bl/6j','female','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('247'),true,true,true,3,rx,'mouseTraining_OD','bas');
        
        
        subjectID = '249';
        sub = subject(subjectID,'mouse','c57bl/6j','male','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('249'),true,true,true,3,rx,'mouseTraining_OD','bas');
        
        subjectID = '999';
        sub = subject(subjectID,'mouse','c57bl/6j','male','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
        rx = addSubject(rx, sub, 'bas');
        [sub, rx]=setProtocolAndStep(sub,pOD('999'),true,true,true,3,rx,'mouseTraining_OD','bas');
        
    case 'A41F729211B1' %gLab-Behavior6
        
%         subjectID = 'l001';
%         sub=getSubjectFromID(rx,subjectID);
%         [~, step] = getProtocolAndStep(sub);
%         [~, rx]=setProtocolAndStep(sub,pMotion_Lever('L001'),true,true,true,step,rx,'mouseTraining_OD','bas');
%         % changed from step 1 to 3 on 7/29
%         % increased dot size , increased velocity, reduced dot number and
%         % increased coherence 9/15
%         subjectID = 'l002';
%         sub=getSubjectFromID(rx,subjectID);
%         [~, step] = getProtocolAndStep(sub);
%         [~, rx]=setProtocolAndStep(sub,pMotion_Lever('L002'),true,true,true,step,rx,'mouseTraining_OD','bas');
%         % changed from step 1 to 3 on 7/29
%         % increased dot size , increased velocity, reduced dot number and
%         % increased coherence 9/15
%         
%         sub = subject('l003','mouse','c57bl/6j','female','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
%         rx = addSubject(rx, sub, 'bas');
%         [sub, rx]=setProtocolAndStep(sub,pOD('246'),true,true,true,3,rx,'mouseTraining_OD','bas');
%         
%         sub = subject('l004','mouse','c57bl/6j','female','02/27/2014','unknown','a 02/27/2014','Jackson Laboratories','PV-cre','none');
%         rx = addSubject(rx, sub, 'bas');
%         [sub, rx]=setProtocolAndStep(sub,pOD('246'),true,true,true,3,rx,'mouseTraining_OD','bas');

%         subjectID = '999';
%         sub=getSubjectFromID(rx,subjectID);
%         [~, step] = getProtocolAndStep(sub);
%         [~, rx]=setProtocolAndStep(sub,pOD('999'),true,true,true,step,rx,'mouseTraining_OD','bas');
    otherwise
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
end

end