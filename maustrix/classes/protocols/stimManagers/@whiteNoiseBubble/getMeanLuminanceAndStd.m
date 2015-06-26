function [meanLuminance std] = getMeanLuminanceAndStd(sm,stimInfo)
if isfield(stimInfo,'stimulusDetails')
    stimInfo = stimInfo.stimulusDetails;
end
switch stimInfo.distribution.type
    case 'gaussian'
        std = stimInfo.distribution.std;
        meanLuminance = stimInfo.distribution.meanLuminance;
    case 'binary'
        p=stimInfo.distribution.probability;
        hiLoDiff=(stimInfo.distribution.hiVal-stimInfo.distribution.lowVal);
        std=hiLoDiff*p*(1-p);
        meanLuminance=(p*stimInfo.distribution.hiVal)+((1-p)*stimInfo.distribution.lowVal);
end

end