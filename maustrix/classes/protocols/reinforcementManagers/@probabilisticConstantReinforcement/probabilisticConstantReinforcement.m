function r=probabilisticConstantReinforcement(varargin)
% ||constantReinforcement||  class constructor.
% r=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,...
%   msPenalty,fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msPuff)

        r.rewardSizeULorMS=0;
        r.rewardProbability = 0;

switch nargin
    case 0
        % if no input arguments, create a default object


        r = class(r,'probabilisticConstantReinforcement',reinforcementManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'probabilisticConstantReinforcement'))
            r = varargin{1};
        else
            error('Input argument is not a probabilisticConstantReinforcement object')
        end
    case 9
        r = class(r,'probabilisticConstantReinforcement',...
            reinforcementManager(varargin{5},varargin{9},varargin{8},varargin{6},varargin{7},varargin{3},varargin{4}));
        r = setRewardSizeULorMSAndRewardProbability(r,varargin{1},varargin{2});
    otherwise
        error('Wrong number of input arguments')
end