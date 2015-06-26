function pass=checkDynamicSweep(sm,dynamicSweep)
%this function only checks the the second, not the first

pass=0;

if ~isempty(dynamicSweep)
    switch dynamicSweep.sweepMode{1}
        case 'ordered'
            %nothing to do
        case 'random'
            if ~(isnumeric(dynamicSweep.sweepMode{2}) && all(size(dynamicSweep.sweepMode{2})==[1 1])) ...
                    &&  ~(ischar(dynamicSweep.sweepMode{2}) && strcmp(dynamicSweep.sweepMode{2},'clock'))
                error('second argument 2 dynamic sweepMode must be a random seed, or the string ''clock''')
            end
        case 'manual'
            %error('not yet');
            if ~(size(dynamicSweep.sweptValues, 1)==size(dynamicSweep.sweptParameters,2) && isnumeric(dynamicSweep.sweptValues))
                error ('sweptValues must be a matrix m=numParameters x n=numValues')
            end
        otherwise
            dynamicSweep.sweepMode{1}
            error('bad sweep mode');
    end
    if ~(all(ismember(dynamicSweep.sweptParameters,[fields(sm); {'targetOrientations', 'targetContrast'}'])))
        dynamicSweep.sweptParameters
        
        error('sweptParameters must be a cell array of fields on the sm or belong to an acceptable list')
    end
%     if ~isempty(dynamicSweep.sweptValues) & ~strcmp('manual',dynamicSweep.sweepMode{1})
%         error('sweptValues must be empty if in any mode but manual')  %
%         not any more... now it takes the facorial combo of these values
%         if in ordered or random mode
%     end
     if ~((iswholenumber(dynamicSweep.numRepeats) & dynamicSweep.numRepeats>0) || isinf(dynamicSweep.numRepeats))
        error('numRepeats must a whole number greater than 0, or Inf')
    end
    %not used
%     if ~(isnumeric(dynamicSweep.ISI) & dynamicSweep.ISI>=0)
%         error('ISI must be a number >=0')
%     end
%     if ~(isnumeric(dynamicSweep.ISMean) & dynamicSweep.ISMean>=0 & dynamicSweep.ISMean<=1)
%         error('ISMean must be a number between or equal to 0 and 1')
%     end
%     
end

pass=1;

