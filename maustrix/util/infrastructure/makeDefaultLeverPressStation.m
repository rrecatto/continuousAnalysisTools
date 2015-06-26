function st=makeDefaultLeverPressStation(id,path,mac,physicalLocation,screenNum,rewardMethod,pportaddr,soundOn,startEyelinkIfAvail)

% our standard parallel port pin assignments
% pin register	invert	dir	purpose
%---------------------------------------------------
% 1   control	inv     i/o	localPump infusedTooFar
% 2   data              i/o right reward valve (cooldrive valve 1)
% 3   data              i/o	center reward valve (cooldrive valve 2)
% 4   data              i/o	left reward valve (cooldrive valve 3)
% 5   data              i/o	localPump rezervoir valve (cooldrive valve 4) OR  LED1
% 6   data              i/o eyePuff valve (cooldrive valve 5)
% 7   data              i/o	localPump direction control OR LED 2
% 8   data              i/o indexPulse
% 9   data              i/o framePulse
% 10  status            i   center lick sensor
% 11  status    inv     i	localPump motorRunning
% 12  status            i   right lick sensor
% 13  status            i   left lick sensor
% 14  control	inv     i/o	localPump withdrawnTooFar
% 15  status            i
% 16  control           i/o phasePulse
% 17  control	inv     i/o stimPulse

if ~exist('pportaddr','var') || isempty(pportaddr)
    switch mac
        %some rig stations have special pport setups
        case '0014225E4685' %dell machine w/nvidia card + sound card + nidaq card
            pportaddr='FFF8'; %the pcmcia add on card
        case '001372708179' %dell machine w/ati card
            pportaddr='B888'; %the pci add on card
            
        case 'A41F7278B4DE' %gLab-Behavior1
            pportaddr= 'D010';
        case 'A41F729213E2' %gLab-Behavior2
            pportaddr= 'D010';
        case 'A41F726EC11C' %gLab-Behavior3
            pportaddr= 'D010';
        case '7845C4256F4C' %gLab-Behavior4
            pportaddr= 'D010';
        case '7845C42558DF' %gLab-Behavior5
            pportaddr= 'D010';
        case 'A41F729211B1' %gLab-Behavior6
            pportaddr= 'D010';
        case 'BC305BD38BFB' %ephys-stim
            pportaddr= '0378';
        otherwise
            warning('makeDefaultStation:parallelPortDefaultSetting','setting the parallel port address to 0378. confirm that this is actually the case');
            pportaddr= '0378';
    end
end

if ~exist('rewardMethod','var') || isempty(rewardMethod)
    rewardMethod= 'localTimed';
end

if ~exist('screenNum','var') || isempty(screenNum)
    screenNum=int8(0);
    if length(Screen('Screens'))>1 % some multi head setups
        
        switch mac
            case {'000000000000'}
                %screenNum=int8(max(Screen('Screens')));
                screenNum=int8(0); %normally used for single header phys on CRT
                %screenNum=int8(2); %used for other monitor on OLED tests, or dual header tests
                %screenNum=int8(1); %used for local screen tests
            otherwise
                %pass
        end 
    end
end

if ~exist('soundOn','var') || isempty(soundOn)
    soundOn=true;
    switch mac
        case '000000000000'
            soundOn=false; % use if audio is busted
        otherwise
            %pass
    end
end

dn=[];
et=[];


switch mac
    %some rig stations have eyeTrackers and datanets available
    case {'001D7D9ACF80','00095B8E6171'}  %phys stim machine stolen from 2F
        if  startEyelinkIfAvail % true (temp off for calibration)
            %calc stim should set the method to 'cr-p', calls set
            %resolution should update et
            alpha=12; %deg above...really?
            beta=0;   %deg to side... really?
            settingMethod='none';  % will run with these defaults without consulting user, else 'guiPrompt'
            maxWidth=1;
            maxHeight=1;
            preAllocatedStimSamples=200000; % 300000 300 sec --> 5 min (if no drops)
            et=geometricTracker('cr-p', 2, 3, alpha, beta, int16([1280,1024]), [42,28], int16([maxWidth,maxHeight]), [400,290], 300, -55, 0, 45, 0,settingMethod,preAllocatedStimSamples);
        end
end



stationSpec.id                                = id;
stationSpec.path                              = path;
stationSpec.MACaddress                        = mac;
stationSpec.physicalLocation                  = physicalLocation;
stationSpec.screenNum                         = screenNum;
stationSpec.soundOn                           = soundOn;
stationSpec.rewardMethod                      = rewardMethod;
stationSpec.portSpec.parallelPortAddress      = pportaddr;
stationSpec.portSpec.valveSpec                = int8([4,3,2]); % this is the only difference between a default station and a default lever press station
stationSpec.portSpec.sensorPins               = int8([13,10,12]);
stationSpec.portSpec.framePins                = int8(9);
stationSpec.portSpec.eyePuffPins              = int8(6);
stationSpec.datanet                           = dn;
stationSpec.eyeTracker                        = et;
stationSpec.portSpec.phasePins                = int8(16);
stationSpec.portSpec.stimPins                 = int8(17);
stationSpec.portSpec.indexPins                = int8(8);

if ismac || IsLinux
    stationSpec.portSpec = int8(3);
elseif ispc
    %do nothing
else
    error('unknown OS')
end

if strcmp(mac,'BC305BD38BFB') % true only for ephys-stim
    stationSpec.portSpec.LED1Pin = int8(5);
    stationSpec.portSpec.LED2Pin = int8(7);
else
    stationSpec.portSpec.LED1Pin = int8([]);
    stationSpec.portSpec.LED2Pin = int8([]);
end

st=station(stationSpec);