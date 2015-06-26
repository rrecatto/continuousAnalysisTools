function [aboveThresh whichCriteria correct]=aboveThresholdPerformance(confidenceParameter,pctCorrect,trialRecords,inputDetails)

if ~exist('inputDetails','var')||isempty(inputDetails)
    inputDetails = [];
end


if isinteger(confidenceParameter) & all(confidenceParameter>0)
    consecutiveTrials=int32(confidenceParameter);  %use int32 to avoid errors with x(end-n) calls for n>intmax
elseif all(confidenceParameter>=1) & all(confidenceParameter<=0)
    alpha=confidenceParameter;
    error('this method not used yet; code must be adjusted to switch on method') %pmm0802
    [junk, pci] = BINOFIT(X,N,alpha)
    lower=pci(1);
    if lower>pctCorrect
        thisCriteria
    end
else
    error('confidenceParameter must either specify an integer number of trials or a fractional alpha for a binomial confidence lower bound')
end


%determine what type trialRecord are
if isempty(trialRecords) && ~isempty(inputDetails)
    recordType = 'inputDetails';
else
    recordType='largeData'; %circularBuffer
end

aboveThresh=0;
whichCriteria=[];
correct=[];

if ~isempty(trialRecords) || ~isempty(inputDetails)
    %get the correct vector
    switch recordType
        case 'largeData'
            if isfield(trialRecords,'trialDetails')
                td=[trialRecords.trialDetails];
                if isfield(td,'correct')
                    correct=[td.correct];
                end
            else
                correct=[trialRecords.correct];
            end
            %todo
            %'WARNING': make sure to limit this to this session
        case 'circularBuffer'
            %correct=trialRecords.correct; %not used yet
        case 'inputDetails'
            correct = inputDetails;
        otherwise
            error('unknown trialRecords type')
    end

    numCriteria=size(consecutiveTrials,2);
    whichCriteria = zeros(1, numCriteria);
    for i=1:numCriteria
        enoughTrials=size(correct,2)>consecutiveTrials(i)
        if enoughTrials
            recentCorrect=correct(end-consecutiveTrials(i):end);
            thisCriteria = nanmean(recentCorrect)>pctCorrect(i);
            aboveThresh = thisCriteria || aboveThresh;
            if thisCriteria
                whichCriteria(i) = 1;
            end
        end
    end
end
