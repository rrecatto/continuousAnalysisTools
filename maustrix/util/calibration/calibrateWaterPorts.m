function calibrateWaterPorts(MSPortsOpen,numTimesPortsOpen)
%CALIBRATEWATERPORTS Use this function to measure the amount of water
%ejected by the ports.

if ~exist('MSPortsOpen','var')||isempty(MSPortsOpen)||~isreal(MSPortsOpen)||~(MSPortsOpen>0)
    error('must provide MSPortsOpen that is a positive real number');
end

if ~exist('numTimesPortsOpen','var')||isempty(numTimesPortsOpen)
    numTimesPortsOpen = 25;
end


[~,mac] = getMACaddress;

dataPath=fullfile(fileparts(fileparts(getRatrixPath)),'ratrixData',filesep);
path=fullfile(dataPath, 'Stations',sprintf('station%s','1U'));

rewardMethod = 'localTimed';

switch mac
    case 'A41F7278B4DE' %gLab-Behavior1
        pportaddr = 'D010';
    case 'A41F729213E2' %gLab-Behavior2
        pportaddr = 'D010';
    case 'A41F726EC11C' %gLab-Behavior3
        pportaddr = 'D010';
    case '7845C4256F4C' %gLab-Behavior4
        pportaddr = 'D010';
    case '7845C42558DF' %gLab-Behavior5
        pportaddr = 'D010';
    case 'A41F729211B1' %gLab-Behavior6
        pportaddr = 'D010';
    case 'BC305BD38BFB' %ephys-stim
        pportaddr = '0378';
    otherwise
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
end


s=makeDefaultStation('1U',path,mac,uint8([1 1 1]),[],rewardMethod,pportaddr,'',false); % soundON is not set here

setValves(s,[0 0 0]);
for i = 1:numTimesPortsOpen
    i
    setValves(s,[1 1 1]);
    WaitSecs(MSPortsOpen/1000);
    setValves(s,[0 0 0])
    WaitSecs(0.5);
end
end

