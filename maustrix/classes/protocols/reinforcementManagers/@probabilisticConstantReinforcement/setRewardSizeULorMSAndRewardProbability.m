
function r=setRewardSizeULorMSAndRewardProbability(r, v, p)

        if v>=0 && isreal(v) && isscalar(v) && isnumeric(v)
            r.rewardSizeULorMS=v;
        else
            error('rewardSizeULorMS must be real numeric scalar >=0')
        end
        
        if isscalar(p) && p>=0 && p<=1
            r.rewardProbability = p;
        else
            error('reward probability should be a scalar between 0 and 1');
        end