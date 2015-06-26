function out = getStimAndRewardParams(out,subID)

switch lower(subID)
    case '218'
        out.rewardScalar = 0.1;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 8/10
    case '227'
        out.rewardScalar = 0.1;
        out.msPenalty = 15000;
        % reduced reward to 0.25 8/3
        % reward reduced to 0.1 8/10
        % increased pealty to 15000 on 9/13
    case '228'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 8/3
    case '232'
        out.rewardScalar = 0.1;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 on 8/10
    case '237'
        out.rewardScalar = 0.1;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 9/13
    case '238'
        out.rewardScalar = 0.1;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 8/10
    case '239'
        out.rewardScalar = 0.05;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 8/10
        % reduced reward to 0.05 8/20
    case '240'
        out.rewardScalar = 0.05;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 8/10
        % reduced reward to 0.05 8/20
    case '241'
        out.rewardScalar = 0.25;
        out.msPenalty = 15000;
        % reduced reward to 0.5 8/3
        % increased penalty to 15000 on 8/10
        % reduced reward to 0.25 9/13
    case '242'
        out.rewardScalar = 0.15;
        out.msPenalty = 15000;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 9/13
    case '243'
        out.rewardScalar = 0.1;
        out.msPenalty = 15000;
        % reduced reward to 0.25 8/3
        % increased penalty to 15000 9/6
        % reduced reward to 0.1 9/13
    case '244'
        out.rewardScalar = 0.1;
        out.msPenalty = 15000;
        % reduced reward to 0.25 8/3
        % increased penalty to 15000 9/6
        % reduced reward to 0.1 9/13
    case '245'
        out.rewardScalar = 0.05;
        % reduced reward to 0.25 8/3
        % reduced reward to 0.1 8/10
        % reduced reward scalar to 0.02 9/6
    case '247'
        out.rewardScalar = 0.25;
        out.msPenalty = 15000;
        % increased pealty to 15000 on 8/10
        % reduced reward to 0.25 9/13
    case '248'
        out.rewardScalar = 0.25;
        out.msPenalty = 15000;
        % reduced reward to 0.25 9/13
        % increased pealty to 15000 on 9/13
    case '249'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 8/10
    case '250'
        out.rewardScalar = 0.1;
        % reduced reward to 0.25 8/10
        % reduced reward to 0.1 9/13
    case '251'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 9/13
    case '252'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 9/13
    case '253'
        % no change
    case '254'
        % no change
    case '255'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 9/13
    case '256'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 9/13
    case '257'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 9/13
    case '258'
        out.rewardScalar = 0.25;
        % reduced reward to 0.25 9/13
    case '262'
        out.rewardScalar = 0.1;
        out.mePenalty = 15000;
        % reduced reward to 0.1 11/16
        % increased penalty to 15 s 11/16
    case 'L001'
        out.rewardScalar = 0.25;
        % reduced reward 9/4;
    case 'L002'
        out.rewardScalar = 0.25;
        % reduced reward 9/4
    otherwise
        % use the default setup
end
