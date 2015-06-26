function out=stimMgrOKForTrialMgr(sm,tm)
if isa(tm,'trialManager')
    switch class(tm)
        case {'autopilot','reinforcedAutopilot'}
            out=1;
        otherwise
            out=0;
    end
else
    error('need a trialManager object')
end