function out=stimMgrOKForTrialMgr(sm,tm)
if isa(tm,'trialManager')
    switch class(tm)
        case 'freeDrinks'
            out=0;
        case 'nAFC'
            out=1;
        case {'autopilot','reinforcedAutopilot'}
            out=1;
        case 'goNoGo'
            out=1;
        case 'changeDetectorTM'
            out = 1;
        otherwise
            out=0;
    end
else
    error('need a trialManager object')
end