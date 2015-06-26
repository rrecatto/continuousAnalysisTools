function [sess, recordingFile, recordingConfiguration]=openNidaqForRecording(whichAnalogChans,digitalChans,sampRate,inputRanges,recordingFile,neuralFilename,chunkCount)
portAssociations = ...
    {'Frames','port0/line1';...
    'Index','';...
    'Stim','port0/line0';...
    'Phase','port0/line3';...
    'Left','port0/line13';...
    'Center','';...
    'Right','port0/line12';...
    'RewL','port0/line11';...
    'RewC','port0/line9';...
    'RewR','port0/line8';...
    'LED1','';...
    'LED2','';...
    };


if ~exist('recordingFile','var') || isempty(recordingFile)
    mkdir('data');
    recordingFile=fullfile('.' , 'data' , ['data.' datestr(now,30) '.daq']);
end

config='SingleEnded'; %'Differential' or 'NonReferencedSingleEnded' or 'SingleEnded'

vendors = daq.getVendors;
if ~ismember('ni',{vendors.ID});
    error(['cannot start NIDAQ wthout a ni device. make sure you have a ni device and' ...
    ' have the appropriate driver software installed']);
end

devices = daq.getDevices;

if length(devices)>1
    error('need to figure out the way to get at device selection in the future. now jsut assume there is only one device');
end

% create a session
sess =daq.createSession('ni');
deviceID = devices.ID;
subSystemTypes = {devices.Subsystems.SubsystemType};

try
    numAnalogChansAvail = devices.Subsystems(strcmp(subSystemTypes,'AnalogInput')).NumberOfChannelsAvailable;
    if numAnalogChansAvail<length(whichAnalogChans)
        error('requested numChans > available numChans');
    elseif any(whichAnalogChans>numAnalogChansAvail)
        error('requesting channel number greater than available channel number');
    end
catch
    error('do you have analogInput?');
end

try
    numDigitalChansAvail = devices.Subsystems(strcmp(subSystemTypes,'DigitalIO')).NumberOfChannelsAvailable;
    if numDigitalChansAvail<length(digitalChans)
        error('requested num digitalChans > numDigitalChansAvail');
    end
catch
    error('do you have DigitalIO?');
end

% check if the digital chans are authorized
digitalPorts = cell(size(digitalChans));
for i = 1:length(digitalChans)
    if ~ismember(digitalChans{i}, portAssociations(:,1))
        fprintf('%s not authorized',digitalChans{i})
        error('add only authorized channels to the device')
    else
        digitalPorts{i} = portAssociations(strcmp(portAssociations(:,1),digitalChans{i}),2);
        if isempty(digitalPorts{i})
            error('first set the port association before trying to record it');
        end
    end
end

% now add the channels to session.
recordingConfiguration = {};
fprintf('\nAdding Digital Channels: ');
% digitals first
for i = 1:length(digitalChans)
    sess.addDigitalChannel(deviceID,digitalPorts{i},'InputOnly');
    recordingConfiguration{end+1} = digitalChans{i};
    fprintf('%s...',digitalChans{i});
end
fprintf('\nAdding Analog Channels: ');
%analogs next
ch = sess.addAnalogInputChannel(deviceID,whichAnalogChans-1,'Voltage'); %ai channels are zero based
for i = 1:length(whichAnalogChans)
    try
        ch(i).InputType = config;
        ch(i).Range = double(inputRanges(i,:));
        recordingConfiguration{end+1} = sprintf('phys%d',whichAnalogChans(i));
        fprintf('%d.',whichAnalogChans(i));
    catch ex
        getReport(ex)
        keyboard
    end
end
fprintf('\n');
sess.IsContinuous = true;
sess.Rate = sampRate;
% sess.NotifyWhenDataAvailableExceeds = sampRate*1; % going to force Notify
% to auto
sess.NotifyWhenDataAvailableExceeds = sampRate*0.3; % every 300 ms

sess.ChunkNum = chunkCount;
sess.ChunkWritten = false;
sess.IsLastChunk = false;
sess.NeuralRecordsName = neuralFilename;
sess.NeuralData = nan(length(recordingConfiguration),sampRate*30); % will be called every 20 seconds . the 30 second thignie is only for backup 
sess.NeuralDataTimes = [nan nan];
sess.NumDataPointsWritten = 0;
sess.OverFlow = [];
sess.OverFlowDataAdded = false;