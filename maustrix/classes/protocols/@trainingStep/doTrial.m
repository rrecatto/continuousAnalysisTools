function [graduate, keepWorking, secsRemainingTilStateFlip, subject, r, trialRecords, station, manualTs] ...
    =doTrial(ts,station,subject,r,rn,trialRecords,sessionNumber,compiledRecords)
graduate=0;

manualTs=false;
if ~isempty(rn) && strcmp(getSVNCheckMode(ts),'trial') %need to be in bootstrap context cuz updating involves a matlab quit/expects daemon to restart it -- actually probably not necessary, but what if stand alone user has files open in editor that get svn updated?
    if ~isempty(ts.svnRevNum)
        args={ts.svnRevURL ts.svnRevNum};
    else
        args={ts.svnRevURL};
    end
    doQuit=updateRatrixRevisionIfNecessary(args);
    if doQuit
        keepWorking=false;
        secsRemainingTilStateFlip=0;
        return
    end
end

try


    if isa(station,'station') && isa(r,'ratrix') && isa(subject,'subject') && (isempty(rn) || isa(rn,'rnet'))
        if isa(ts,'trainingStep')
            if isa(ts.stimManager,'stimManager')
                %everything is good!
            else
                sca
                ts.stimManager
                class(ts.stimManager)
                class(ts.trialManager)
                class(ts.criterion)
                class(ts.scheduler)
                class(ts)
                class(ts.stimManager)
                error('Its gotta be a stim manager')
            end
        else
            class(ts);
            error('it''s not a trainingStep')
        end

        %class(ts.scheduler)
        [keepDoingTrials, secsRemainingTilStateFlip, updateScheduler, newScheduler] = checkSchedule(ts.scheduler,subject,ts,trialRecords,sessionNumber);

        if keepDoingTrials
            [newTM, updateTM, newSM, updateSM, stopEarly, trialRecords, station]=...
                doTrial(ts.trialManager,station,ts.stimManager,subject,r,rn,trialRecords,sessionNumber,compiledRecords);
            keepWorking=~stopEarly;
            
            % 1/22/09 - check to see if we want to dynamically change trainingStep (look in trialRecords(end).result, if stopEarly is set)
            if stopEarly
                if isfield(trialRecords(end),'result') && ischar(trialRecords(end).result) && strcmp(trialRecords(end).result,'manual training step')
                    manualTs=true;
                end
            end
            
            graduate = checkCriterion(ts.criterion,subject,ts, trialRecords, compiledRecords);

			%END SESSION BY GRADUATION
            if false && graduate % && isempty(getStandAlonePath(r)) %this was phil's quick-fix mentality hack to create an ugly special case for standalone
				% see http://132.239.158.177/trac/rlab_hardware/ticket/282#comment:5
                % edf thinks this is no longer necessary since fli updated trial records to allow multiple stim/trialManager types per file
                keepWorking=0;
            end

            if updateTM
                ts.trialManager=newTM;
            end
            if updateSM
                ts.stimManager=newSM;
            end
            if updateScheduler
                ts.scheduler=newScheduler;
            end

            if updateTM || updateSM || updateScheduler
                % This will update the protocol locally, and also update
                % the subject's protocolversion.autoVersion, which will
                % propagate the changes back to the server upon session end
                [subject r]=changeProtocolStep(subject,ts,r,'trialManager or stimManager or scheduler state change','ratrix');
            end

        else
            disp('*************************INTERTRIAL PERIOD STARTS!*****************************')
            stopEarly = doInterSession(ts, rn, getPTBWindow(station)); % note: we have no records of this
            keepWorking=~stopEarly;
            disp('*************************INTERTRIAL PERIOD ENDS!*****************************')
        end
    else
        sca
        isa(station,'station')
        isa(r,'ratrix')
        isa(subject,'subject')


        error('need station and ratrix and subject and rnet objects')
    end

catch ex
    display(ts)
    %disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
    Screen('CloseAll');
    rethrow(ex)
end