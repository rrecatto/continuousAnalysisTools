function result = AM2300Control(mode,varargin)
if ~exist('mode','var')||isempty(mode)
    mode = 'default';
end

% #DEFINES are here;
% PIN# : [[9 8 7 6 5 4 3 2]]
% will come here later!!!
allOff = '00000000';
defState = '00000010';
PulsePOSITIVE = '00000111';
PulseNEGATIVE = '00000101';


% the stimulus isolator is essentially a current source, battery powered so it is electrically isolated from electrical noise that could harm tissue.
% it takes TTL command signals (0/+5V voltages) into its serial port, and outputs a specific current over its banana plugs output.
% because it is a current source, the output current is supposed to be relatively independent of the resistance over which it is pushing the current.
% 
% please read the manual to make sure you know what you're doing...  below are just my rough notes from memory
%
% first check the battery level on the stimulus isolator: set power to off, push battery/test button. light should come on.
% you don't want to be connected to AC, so charge up if necessary.
% rechargable batteries can be ruined by certain charging practices, so see the manual for whether you need to recharge fully, etc.
% 
% manually verify that you get expected current over a ~1k resistor:
% 	hook up the stim isolater (still not plugging into control cable) so that it will push the current over the resistor. 
% 	put the multimeter in series with the resistor (be sure you're using the small current input on the multimeter, NOT the volt
% 	on front panel of stimulus isolator, set baseline to 0, range to 10ua, pulse to .1, so that's 1ua
%   i think you can manually trigger the output by setting the switch to "on" and holding the "test" button, but i can't recall for sure.
% 
% hook up serial and parallel breakout cards to map pins [2 3 4] parallel to [4 8 9] serial (on the stimulus isolator these mean "gate", "sign", "pulse baseline")
% also hook up pins [any 18-25] parallel to [3 and 7] serial (these are the TTL ground lines)
% the grey serial-parallel cable that is with the stim isolator probably has these same mappings -- but need to check to make sure!
%
% don't plug the cable into the stimulus isolator until you have made sure to initialize the pins to zero on the parallel port (see below).
% 
% during the actual experiment, watch your multimeter current reading to make sure you got what you wanted.
% also make sure the stimulus isolator's error light never goes on (which would most likely mean that the resistance it encountered was too high).
% 
% where millisecond-accurate timing is important, most people would use a (eg grass) stimulator, rather than a comptuer, to provide the stimulus isolator with precisely timed control signals.
% http://www.grasstechnologies.com/products/stimulators/stimulators.html
%
% to output TTL signals from matlab:
% navigate to ratrix trunk\classes\util\parallelPort

addr='0378'; %find parallel port address in device manager
% addr = 'D088';

POSITIVE = 1;
NEGATIVE = 0;

switch mode
    case 'default'
        numPulses = 1;
        pulseSign = POSITIVE;
        pulseDuration = 1; %in secs
        interPulseDuration = 1;
    case 'TenQuickPOS'
        numPulses = 10;
        pulseSign = POSITIVE;
        pulseDuration = 0.1; %in secs
        interPulseDuration = 0.1;
    case 'TenQuickNEG'
        numPulses = 10;
        pulseSign = NEGATIVE;
        pulseDuration = 0.1; %in secs
        interPulseDuration = 0.1;
    case 'NRepsPOS'
        numPulses = varargin{1}.numReps;
        pulseSign = POSITIVE;
        pulseDuration = 1; %in secs
        interPulseDuration = 1;
    case 'NRepsNEG'
        numPulses = varargin{1}.numReps;
        pulseSign = NEGATIVE;
        pulseDuration = 1; %in secs
        interPulseDuration = 1;
    otherwise
        error('unnknown mode!');
end
GetSecs;WaitSecs(0.1); %load these psychtoolbox mex routines into memory (avoids timing error in next call) -- note that matlab's pause command is inaccurate
lptwrite(hex2dec(addr), bin2dec('00000000')); %initialize the pins (seem to boot into undefined states)

try
    for i = 1:numPulses
        disp(sprintf('starting pulse#: %d of %d',i,numPulses));
        if pulseSign
            vals = PulsePOSITIVE;
        else
            vals = PulseNEGATIVE;
        end
        lptwrite(hex2dec(addr), bin2dec(vals));
        timeON=GetSecs();
        timeDone= WaitSecs('UntilTime', timeON+pulseDuration);
        lptwrite(hex2dec(addr), bin2dec(defState));
        disp(sprintf('gave pulse for %g secs',timeDone-timeON)) %actual value may be different than requested
        timeOFF = GetSecs();
        WaitSecs('UntilTime',timeOFF+interPulseDuration);
    end
catch ex
    warning('something went wrong!')
    lptwrite(hex2dec(addr), bin2dec('00000000')); %initialize the pins (seem to boot into undefined states)
    rethrow(ex);
end
