function out=stimMgrOKForTrialMgr(sm,tm)
if isa(tm,'trialManager')
    switch class(tm)
        case {'freeDrinks','freeDrinksCenterOnly','freeDrinksSidesOnly','freeDrinksAlternate'}
            out=1;
        case 'nAFC'
            out=1;
        case 'goNoGo'
            out=1;
        otherwise
            out=0;
    end
else
    error('need a trialManager object')
end