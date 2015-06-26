function gotAck = startClientTrials(datanet,subjectID,protocolDetails,startEyelink,rigParams,subjectDetails)
% This function sends a command to the client to set the correct datanet_storepath (for stimRecords) and then 
% to start running trials, and waits for an ack.
% INPUTS:
%	datanet - the server-side datanet object; should have a valid pnet connection with parameters (timeout) already set
%	subjectID - the ID string of the subject to start (pass to standAloneRun)
%	protocol - the name of the protocol file to run (pass to standAloneRun)
%   determines if the eyelink should be run
% OUTPUTS:
%	gotAck - true if we get an ack from the client

% tell client computer to start running trials and send an ack
if ~exist('startEyelink','var')||isempty(startEyelink)
    startEyelink = true;
end
gotAck = false;
constants=getConstants(datanet);
commands=[];
commands.cmd=constants.dataToStimCommands.D_SET_STOREPATH_CMD;
params=[];
params.storepath=getStorePath(datanet);
commands.arg=params;
gotAck = sendCommandAndWaitForAck(datanet,commands);

protocol = protocolDetails.protocolName;
trainingStepNum = protocolDetails.trainingStepNum;

commands=[];
commands.cmd=constants.dataToStimCommands.D_START_TRIALS_CMD;
subjParams=[];
subjParams.id=subjectID;
subjParams.protocol=protocol;
subjParams.startEyelink=startEyelink;
subjParams.rigParams = rigParams;
subjParams.subjectDetails = subjectDetails;
subjParams.trainingStepNum = trainingStepNum;

commands.arg=subjParams;
gotAck = sendCommandAndWaitForAck(datanet,commands);

end % end function