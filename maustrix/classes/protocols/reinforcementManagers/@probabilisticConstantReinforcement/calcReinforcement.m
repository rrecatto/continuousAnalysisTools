function [r, rewardSizeULorMS, requestRewardSizeULorMS, msPenalty, msPuff, msRewardSound, msPenaltySound, updateRM] = ...
    calcReinforcement(r,trialRecords, subject)

[rewardSizeULorMS, requestRewardSizeULorMS, msPenalty, msPuff, msRewardSound, msPenaltySound] = ...
    calcCommonValues(r,r.rewardSizeULorMS,getRequestRewardSizeULorMS(r));
rewardSizeULorMS = rewardSizeULorMS*double(rand<r.rewardProbability);
updateRM=0;