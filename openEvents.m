function [timestamps eventID eventChannel] = openEvents(filename)
% [uint8 int64 uint8 uint8 uint8] = openEvents(String)
%  Modified version of OpenEphys's 'load_open_ephys_data' function to store
%  data in more convenient form for processing.
%
%  PARAMETERS:
%    filename = string path to events file
%
%  RETURN VALUES: (as defined on https://open-ephys.atlassian.net/wiki/display/OEW/Data+format)
%    eventType = all the events that are saved have type TTL = 3 ; Network Event = 5
%    timestamps = to align with timestamps from the continuous records
%    processorID = the processor this event originated from
%    eventID = code associated with this event, 1 for rising edge, 0 for falling edge
%    eventChannel = the channel this event is associated with
%
% link also helps in understanding the format of the EVENT files.
%  https://groups.google.com/forum/#!topic/open-ephys/ndfHlYxN2dE

filetype = filename(max(strfind(filename,'.'))+1:end); % parse filetype

fid = fopen(filename);
filesize = getfilesize(fid);

% constants
NUM_HEADER_BYTES = 1024;
SAMPLES_PER_RECORD = 1024;
RECORD_SIZE = 8 + 16 + SAMPLES_PER_RECORD*2 + 10; % size of each continuous record in bytes
RECORD_MARKER = [0 1 2 3 4 5 6 7 8 255]';
RECORD_MARKER_V0 = [0 0 0 0 0 0 0 0 0 255]';

% constants for pre-allocating matrices:
MAX_NUMBER_OF_SPIKES = 1e6;
MAX_NUMBER_OF_RECORDS = 1e6;
MAX_NUMBER_OF_CONTINUOUS_SAMPLES = 1e8;
MAX_NUMBER_OF_EVENTS = 1e6;
SPIKE_PREALLOC_INTERVAL = 1e6;

%-----------------------------------------------------------------------
%------------------------- EVENT DATA ----------------------------------
%-----------------------------------------------------------------------

if strcmp(filetype, 'events')

    disp(['Loading events file...']);

    index = 0;

    hdr = fread(fid, NUM_HEADER_BYTES, 'char*1');
    eval(char(hdr'));
    info.header = header;

    if (isfield(info.header, 'version'))
        version = info.header.version;
    else
        version = 0.0;
    end

    % pre-allocate space for event data
    data = zeros(MAX_NUMBER_OF_EVENTS, 1);
    timestamps = zeros(MAX_NUMBER_OF_EVENTS, 1);
    info.sampleNum = zeros(MAX_NUMBER_OF_EVENTS, 1);
    info.nodeId = zeros(MAX_NUMBER_OF_EVENTS, 1);
    info.eventType = zeros(MAX_NUMBER_OF_EVENTS, 1);
    info.eventId = zeros(MAX_NUMBER_OF_EVENTS, 1);

    if (version >= 0.2)
        recordOffset = 15;
    else
        recordOffset = 13;
    end

    while ftell(fid) + recordOffset < filesize % at least one record remains

        index = index + 1;

        if (version >= 0.1)
            timestamps(index) = fread(fid, 1, 'int64', 0, 'l');
        else
            timestamps(index) = fread(fid, 1, 'uint64', 0, 'l');
        end


        info.sampleNum(index) = fread(fid, 1, 'int16'); % implemented after 11/16/12
        info.eventType(index) = fread(fid, 1, 'uint8');
        info.nodeId(index) = fread(fid, 1, 'uint8');
        info.eventId(index) = fread(fid, 1, 'uint8');
        data(index) = fread(fid, 1, 'uint8'); % save event channel as 'data' (maybe not the best thing to do)

        if version >= 0.2
            info.recordingNumber(index) = fread(fid, 1, 'uint16');
        end

    end

    % crop the arrays to the correct size
    eventChannel = data(1:index);
    timestamps = timestamps(1:index);
    info.sampleNum = info.sampleNum(1:index);
    info.processorID = info.nodeId(1:index);
    info.eventType = info.eventType(1:index);
    eventID = info.eventId(1:index);

end

fclose(fid); % close the file

if (isfield(info.header,'sampleRate'))
    if ~ischar(info.header.sampleRate)
      timestamps = timestamps./info.header.sampleRate; % convert to seconds
    end
end

end


function filesize = getfilesize(fid)

fseek(fid,0,'eof');
filesize = ftell(fid);
fseek(fid,0,'bof');

end
