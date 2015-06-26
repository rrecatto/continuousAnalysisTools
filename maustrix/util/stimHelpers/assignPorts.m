%this should be a static method on trialManagers, but those are only
%available in the new matlab way of doing OOP -- we should eventually
%switch
function [targetPorts distractorPorts details]=assignPorts(details,lastTrialRec,responsePorts,TMclass,allowRepeats)

% figure out if this is a correction trial
lastResult=[];
lastCorrect=[];
lastWasCorrection=0;

switch TMclass
    case {'nAFC' 'oddManOut'}
        if ~isempty(lastTrialRec) % if there were previous trials
            try
                lastResult=find(lastTrialRec.result);
            catch
                lastResult=[];
            end
            if isfield(lastTrialRec,'trialDetails') && isfield(lastTrialRec.trialDetails,'correct')
                lastCorrect=lastTrialRec.trialDetails.correct;
            else
                try
                    lastCorrect=lastTrialRec.correct;
                catch
                    lastCorrect=[];
                end
            end
            
            if any(strcmp(fields(lastTrialRec.stimDetails),'correctionTrial'))
                lastWasCorrection=lastTrialRec.stimDetails.correctionTrial;
            else
                lastWasCorrection=0;
            end
            
            if length(lastResult)>1
                lastResult=lastResult(1);
            end
        end
        
        % determine correct port
        if ~isempty(lastCorrect) && ~isempty(lastResult) && ~lastCorrect && length(lastTrialRec.targetPorts)==1 && (lastWasCorrection || rand<details.pctCorrectionTrials)
            details.correctionTrial=1;
            %'correction trial!'
            targetPorts=lastTrialRec.targetPorts; % same ports are correct
        else
            details.correctionTrial=0;
            targetPorts=responsePorts(ceil(rand*length(responsePorts))); %choose random response port to be correct answer
        end
        distractorPorts=setdiff(responsePorts,targetPorts);
        
    case 'freeDrinks'
        if ~isempty(lastTrialRec)
            try
                pNum = find(strcmp('reinforcement',{lastTrialRec.phaseRecords.phaseLabel}));
                rDetails=lastTrialRec.phaseRecords(pNum-1).responseDetails;
                lastResponse=find(rDetails.tries{end});
            catch err
                lastResponse=[];
            end
            %             sca
            %             keyboard
            %             pNum
            %             rDetails
        else
            lastResponse=[];
        end
        
        if length(lastResponse)>1
            lastResponse=lastResponse(1);
        end
        if allowRepeats
            targetPorts=responsePorts;
        else
            targetPorts=setdiff(responsePorts,lastResponse);
        end
        distractorPorts=[];
        
    case 'freeDrinksCenterOnly'
        targetPorts = [2]; % assumes the center port is port 2....confirm that this is true
        distractorPorts=[];
    case 'freeDrinksSidesOnly'
        targetPorts = [1,3]; % assumes the center port is port 2....confirm that this is true
        distractorPorts=[];
    case 'freeDrinksAlternate'
        twoTrialsAgo = lastTrialRec{2};
        lastTrialRec = lastTrialRec{1};
        if ~isempty(lastTrialRec)
            try
                pNum = find(strcmp('reinforcement',{lastTrialRec.phaseRecords.phaseLabel}));
                rDetails=lastTrialRec.phaseRecords(pNum-1).responseDetails;
                lastResponse=find(rDetails.tries{end});
            catch err
                lastResponse=[];
            end
            %             sca
            %             keyboard
            %             pNum
            %             rDetails
        else
            lastResponse=[];
        end
        
        if ~isempty(twoTrialsAgo)
            try
                pNum = find(strcmp('reinforcement',{twoTrialsAgo.phaseRecords.phaseLabel}));
                rDetails=twoTrialsAgo.phaseRecords(pNum-1).responseDetails;
                secondToLastResponse=find(rDetails.tries{end});
            catch err
                secondToLastResponse=[];
            end
            %             sca
            %             keyboard
            %             pNum
            %             rDetails
        else
            secondToLastResponse=[];
        end
        
        if length(lastResponse)>1
            lastResponse=lastResponse(1);
        end
        
        if length(secondToLastResponse)>1
            secondToLastResponse=secondToLastResponse(1);
        end
        
        if ismember(lastResponse,[1,3])
            targetPorts = [2];
        else
            if secondToLastResponse == 1
                targetPorts = [3];
            else
                targetPorts = [1];
            end
        end
        distractorPorts=[];
        
    case {'autopilot','reinforcedAutopilot'}
        temp = [1,3];
        x = randperm(length(temp));
        targetPorts=temp(x(1));
        distractorPorts=setdiff(responsePorts,temp);
    case 'goNoGo'
        if ~isempty(lastTrialRec) % if there were previous trials
            try
                lastResult=find(lastTrialRec.result);
            catch
                lastResult=[];
            end
            if isfield(lastTrialRec,'trialDetails') && isfield(lastTrialRec.trialDetails,'correct')
                lastCorrect=lastTrialRec.trialDetails.correct;
            else
                try
                    lastCorrect=lastTrialRec.correct;
                catch
                    lastCorrect=[];
                end
            end
            
            if any(strcmp(fields(lastTrialRec.stimDetails),'correctionTrial'))
                lastWasCorrection=lastTrialRec.stimDetails.correctionTrial;
            else
                lastWasCorrection=0;
            end
            
            if length(lastResult)>1
                lastResult=lastResult(1);
            end
        end
        
        % determine correct port
        if ~isempty(lastCorrect) && ~isempty(lastResult) && ~lastCorrect && length(lastTrialRec.targetPorts)==3 && (lastWasCorrection || rand<details.pctCorrectionTrials)
            details.correctionTrial=1;
            %correction trials are a very strange brew for goNoGo... i
            %doubt its what we want...
            
            %'correction trial!'
            targetPorts=lastTrialRec.targetPorts; % same ports are correct
        else
            details.correctionTrial=0;
            targetPorts=responsePorts; %choose all response port to be correct answer
            %pmm:  these apear to be all "go" trials how do we get "no go" trials?
            % i guess the idea of a "trial" is bankrupt in this mode
            % the noGos are all the momement in time of waiting, which
            % could be trials... as long as there is no auditory cue and/or
            % flanker that is correlated with the noGo stimulus
        end
        distractorPorts=setdiff(responsePorts,targetPorts);
    case 'changeDetectorTM'
        targetPorts = 1;
        distractorPorts = [3];
    otherwise
        error('unknown TM class');
end

end % end function