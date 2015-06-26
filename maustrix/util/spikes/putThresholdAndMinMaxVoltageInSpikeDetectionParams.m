function spikeDetectionParams=putThresholdAndMinMaxVoltageInSpikeDetectionParams(spikeDetectionParams,thrV,numTrodes,defaultMinMax)
% this function will return a struct array of spikeDetectionParams, with
% the appropriate changes to threshHoldVolts and minmaxVolts based on thrV
%
% acceptible thrV examples:
%
% [-Inf 0.2]    --> [minThreshDetect maxThreshDetect]
%               --> spikeDetectionParams(allTrodes).threshHoldVolts=[-Inf 0.2]
%               --> spikeDetectionParams(allTrodes).minmaxVolts=defaultMinMax (which is interestingly setable)
%
% [-Inf 0.2 1 ] --> [minThreshDetect maxThreshDetect minThreshDetect]
%               --> spikeDetectionParams(allTrodes).threshHoldVolts=[-Inf 0.2]
%               --> spikeDetectionParams(allTrodes).minmaxVolts=[-1 1]
%
% [0.6 0.2 -1 3] --> [minThreshDetect maxThreshDetect minThreshBlocked maxThreshBlocked]
%               --> spikeDetectionParams(allTrodes).threshHoldVolts=[0.6 0.2]
%               --> spikeDetectionParams(allTrodes).minmaxVolts=[ -1 3]
%
% independant control works as well:
% [-0.2 Inf 1;
%  -0.2 Inf 0.5;
%  -Inf 0.2 1]
% --> sets the thresh and minMaxVolt independantly for 3 trodes


if ~exist('defaultMinMax','var') || isempty(defaultMinMax)
   defaultMinMax=[-Inf Inf]; %don't remove large voltages
end

if length(spikeDetectionParams)==numTrodes
    % okay the are equal... do nothing
elseif length(spikeDetectionParams)==1
    % make them equal
    spikeDetectionParams = repmat(spikeDetectionParams,numTrodes,1);
else
    error(sprintf('spikeDetectionParams must be length of 1 or numTrodes(=%d), but its %d',numTrodes,length(spikeDetectionParams)))
end

if size(thrV,1)==numTrodes
    % okay the are equal... do nothing
elseif size(thrV,1)==1
    % make them equal
    thrV = repmat(thrV,numTrodes,1);
else
    error(sprintf('num specified vThreshholds must be 1 or numTrodes(=%d), but its %d',numTrodes,size(thrV,1)))
end

%set threshHoldVolts and minmaxVolts into spikeDetectionParams for each trode 
for currTrode = 1:numTrodes
    spikeDetectionParams(currTrode).threshHoldVolts=thrV(currTrode,1:2);
    if size(thrV,2)<3
        spikeDetectionParams(currTrode).minmaxVolts=defaultMinMax; 
    elseif size(thrV,2)==3
        mag=abs(thrV(currTrode,3));
        spikeDetectionParams(currTrode).minmaxVolts=[-mag mag];
    else
        if thrV(currTrode,3)<0 && thrV(currTrode,4)>0
            spikeDetectionParams(currTrode).minmaxVolts=thrV(currTrode,[3 4]);
        else
            requested=thrV(currTrode,[3 4])
            error(sprintf('requesed minmaxVolts was %s, but min and max mut be negative and positve, respectively',mat2str(requested), thrV(currTrode,[3 4])))
        end
    end
    
    if (spikeDetectionParams(currTrode).minmaxVolts(1)>spikeDetectionParams(currTrode).threshHoldVolts(1) && ~isinf(spikeDetectionParams(currTrode).threshHoldVolts(1))) ||...
            (spikeDetectionParams(currTrode).minmaxVolts(2)<spikeDetectionParams(currTrode).threshHoldVolts(2) && ~isinf(spikeDetectionParams(currTrode).threshHoldVolts(2)))
         currTrode
         minmaxVolts=spikeDetectionParams(currTrode).minmaxVolts
         threshHoldVolts=spikeDetectionParams(currTrode).threshHoldVolts
        error('minmaxVolts will block the detection threshhold')
    end
end