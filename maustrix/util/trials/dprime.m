function [dpr,anal] = dprime(responses,answers,varargin);
% DPRIME: calculate d prime (ROC analysis), as well as other useful
% performance measures, for response data. %% Usage: [dpr,anal] = dprime(responses,answers,[options]);%
% args in:
%%   responses: vector of size numtrials representing the button 
%   the subject actually pressed. 
%
%   answers: vector of size numtrials giving the number of the %   subject should have pressed to be correct on the given task.
%
%   Currently, if no key is pressed (or the correct response to a trial
%   is not to press a key), this is represented by a 0 in either the
%   responses or answers vector. Sometimes stimulus code represents this by
%   NaNs; check your code in advance.%%% args out:
%
%   dpr: measure of dprime for behavioral data
%%   anal: struct with fields containing performance measures for the data.%
% options: 
%%   'noKeypressVal',[value]: value in responses/answers which reflects no key was
%   pressed. Default = 0.
%
%   'absentVal',[value]: value in responses/answers which reflects stimulus
%   was absent/was reported as absent. Default = 1.
%
%   'presentVal',[value]: value in responses/answers which reflects
%   stimulus was present/was reported as present. Default = 3.
%%   'silent': Don't print out the results of analysis in the command
%   window.%
% This only analyzes responses for those trials in which the subject
% pressed a key. Unless the 'silent' option is given, it also prints out
% the results of the analysis in the command window.%
% For more information on how dprime is calculated and what it means (and
% what assumptions it makes), see:
%%  http://www.cns.nyu.edu/~david/sdt/sdt.html%%
% 10/03 ras. Adapted from code by Michael Silver.if nargin < 2
% 05/07 pmm. presentVal reflects convention of right=3 for signal present

if nargin < 2
	help dprime
    	return
end

noKeypressVal = 0;
absentVal = 1;
presentVal = 3;  %stim is present if response is 3, which is right
silentFlag = 0;

%%%%% parse the option flags
for i = 1:length(varargin)
    switch lower(varargin{i})
        case 'silent',
            silentFlag = 1;
        otherwise,
            if (i < length(varargin)) & (isnumeric(varargin{i+1}))
                cmd = sprintf('%s = %i;',varargin{i},varargin{i+1});
                eval(cmd);
            end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ok = find(responses~=noKeypressVal);
ll = length(ok);
if ll > 0
        correct = answers(ok);
        nr = responses(ok);
        newPerformance = (nr == correct);
        hits = sum((nr == presentVal) & (correct == presentVal));
        correctRejects = sum((nr ==absentVal) & (correct == absentVal));
        misses = sum((nr == absentVal) & (correct == presentVal));
        falseAlarms = sum((nr == presentVal) & (correct == absentVal));
        yes = sum(nr == presentVal);
        no = sum(nr == absentVal);
        ps = sum(correct == presentVal);
        ns = sum(correct == absentVal);
        nh = hits / ll;
        nm = misses / ll;
        ncr = correctRejects / ll;
        nfa = falseAlarms / ll;
        dpr = sqrt(2) * (erfinv((hits - misses)/ps) + erfinv((correctRejects - falseAlarms)/ns));
else    
        dpr=nan;
        disp('No responses recorded from subject');
        answers
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% print out results unless squelched
if ~silentFlag
    fprintf('Hits: %4.1f%%\n', 100*nh);
    fprintf('Misses: %4.1f%%\n', 100*nm);
    fprintf('Correct rejections: %4.1f%%\n', 100*ncr);
    fprintf('False alarms: %4.1f%%\n', 100*nfa);
    fprintf('Overall performance: %4.1f%%\n',100*sum(newPerformance/ll));
    fprintf('d-prime = %5.2f\n', dpr);
    fprintf('Response bias: %4.1f%%\n', 100*(yes / (yes + no)));
end

%%%% create anal struct if requested
if nargout > 1
    anal.hits = hits;
    anal.correctRejects = correctRejects;
    anal.misses = misses;
    anal.falseAlarms = falseAlarms;
    anal.hitsPercent = 100*nh;
    anal.correctRejectsPercent = 100*ncr;
    anal.missesPercent = 100*nm;
    anal.falseAlarmsPercent = 100*nfa;
    anal.dprime = dpr;
    anal.responseBias = 100*(yes / (yes+no));
end

return
