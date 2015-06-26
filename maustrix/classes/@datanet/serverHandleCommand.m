function [quit, specificCommand, response, retval] = serverHandleCommand(datanet,con,cmd,specificCommand,params)
% This function gets called by handleCommands, which loops through available commands. This function just does the switch statement on cmd
% and decides what to execute on the data (server) side.
% INPUTS:
%	datanet - the server-side datanet object; should already have a pnet connection with proper timeouts set
%	cmd - the command from the server side to handle
%	specificCommand - if nonempty, a specificCommand that is expected by the client (set during handleCommands by previous call to serverHandleCommand)
%   params - a struct containing additional parameters passed from handleCommands
% OUTPUTS:
%	quit - not sure what this quit flag means just yet...
%	specificCommand - return to handleCommands if the current cmd requires a specific command be the next in line
%	response - a response message to send to the client (usually an ack)
%	retval - something from the client that needs to be saved by the server (typically an element of events_data)

quit = false;
constants = getConstants(datanet);
response = [];
retval=[];
MAXSIZE=1024*1024;
CMDSIZE=1;

% ===================================================
if strmatch(datanet.type, 'stim')
    error('must be called on datanet of type ''data''');
end

% ===================================================
try
	success=false;
	if ~isempty(specificCommand) && cmd~=specificCommand
		error('received a faulty command %d when waiting for the specific command %d',cmd,specificCommand);
	end
	switch cmd
		case constants.stimToDataCommands.S_TRIAL_START_EVENT_CMD
			% mark start of trial - how do we add an event to events_data, which is all the way out in physiologyServer?
			response=constants.dataToStimResponses.D_TRIAL_START_EVENT_ACK;
            retval(end+1).type='trial start';
            
			
			% create the neuralRecords file with that will get appended to by physServer in 30sec chunks
			cparams=pnet_getvar(con);
            retval(end).time=cparams.time; % should also have a timestamp from client
			filename=cparams.neuralFilename;
            stimFilename = cparams.stimFilename;
			fullFilename = fullfile(datanet.storepath, 'neuralRecords', filename);
            [~, filenameBase] = fileparts(fullFilename);
            fullFilenameRaw = fullfile(datanet.storepath,'neuralRecordsRaw',filenameBase);
            if params.recording
                disp('saving matlab basic details');
                numChunks = [];
                samplingRate=params.samplingRate;
                electrodeDetails = params.electrodeDetails;
                save(fullFilename, 'samplingRate');
                save(fullFilename, 'numChunks','-append');
                save(fullFilename, 'stimFilename','-append');
                save(fullFilename, 'electrodeDetails','-append');
                
                disp('making sure things are closed as they should be ');
                params.ai.stop();
                params.ai.SaveFile.close();
                
                
                disp('opening new file for recording');
                filenameRHD = sprintf('%s.rhd',fullFilenameRaw);
                filenameRHD
                params.ai.SaveFile.open(rhd2000.savefile.Format.intan, filenameRHD);
                params.ai.run_continuously();
            end
			retval(end).neuralFilename = fullFilename; % return filename for appending by physServer
            
            retval(end).neuralFilenameRaw = fullFilenameRaw;
            retval(end).datablock = params.datablock;
            retval(end).ai = params.ai;
            
            retval(end).stimFilename = fullfile(datanet.storepath,'stimRecords',cparams.stimFilename);
            retval(end).trialNumber=cparams.trialNumber;
            retval(end).stimManagerClass=cparams.stimManagerClass;
            retval(end).stepName=cparams.stepName;
            retval(end).stepNumber=cparams.stepNumber;
            fprintf('got trial start command from ratrix\n')
		case constants.stimToDataCommands.S_TRIAL_END_EVENT_CMD
			% mark end of trial - how do we add an event to events_data, which is all the way out in physiologyServer?
			response=constants.dataToStimResponses.D_TRIAL_END_EVENT_ACK;
            cparams=pnet_getvar(con);
            retval(end+1).time=cparams.time; % timestamp from client
            retval(end).type='trial end';
            
			% 4/11/09 - send remaining neural data for this trial (from last 30sec chunk time to now end of trial event)
            if params.recording
                try
                    disp('saving data for trial end');
                    params.ai.stop();
                    % while params.ai.FIFOPercentageFull>1 % until very little of what is remaining 
                    while true
                        params.datablock.read_next(params.ai);
                        if ~ params.datablock.HasData
                            break
                        end
                        params.datablock.save();
                    end
                    
                    disp('closing previous trial file')
                    params.ai.SaveFile.close();
                catch ex
                    getReport(ex)
                    disp('failed to get neural records');
                    keyboard
                end
            end
            
            retval(end).datablock = params.datablock;
            retval(end).ai = params.ai;
            
            fprintf('got trial end command from ratrix\n')
        case constants.stimToDataCommands.S_ERROR_RECOVERY_METHOD
            % whether client pressed 'Restart' or 'Quit'
            response=constants.dataToStimResponses.D_ERROR_METHOD_RECEIVED;
            cparams=pnet_getvar(con);
            retval(end+1).errorMethod=cparams.method;
            fprintf('got error recovery method from client\n')
        case constants.omniMessages.END_OF_DOTRIALS
            % this handles a k+q from the client
            quit=true;
            fprintf('we got a client kill!\n');
            
		otherwise
			error('unknown command');
	end
	
	% now check to see if another command is available
	cmd=pnet(con,'read',CMDSIZE,'double','noblock');
	if isempty(cmd) % no commands available, so just return
		return;
	else
		commandAvailable=true;
    end
catch ex
    if isfield(params,'ai') && ~isempty(params.ai)
        params.ai.stop();
        params.ai.SaveFile.close();
    end
	disp(['CAUGHT ER: ' getReport(ex)]);
    % do some cleanup here
end


end % end function
