function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] = ...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% 1/30/09 - trialRecords now includes THIS trial
trialManagerClass=class(trialManager);
s = stimulus;
indexPulses=[];
imagingTasks=[];
%LUT = Screen('LoadCLUT', 0);
%LUT=LUT/max(LUT(:));

% TODO:  Change this
% out = 1;

% LUTBitDepth=8;
% numColors=2^LUTBitDepth; maxColorID=numColors-1; fraction=1/(maxColorID);
% ramp=[0:fraction:1];
% LUT= [ramp;ramp;ramp]';
[LUT stimulus updateSM]=getLUT(stimulus,LUTbits);
[junk, mac] = getMACaddress();
switch mac
    case {'A41F7278B4DE','A41F729213E2','A41F726EC11C' } %gLab-Behavior rigs 1,2,3
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    case {'7845C4256F4C', '7845C42558DF','A41F729211B1'} %gLab-Behavior rigs 4,5,6
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    otherwise 
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
end
if isnan(resolutionIndex)
    resolutionIndex=1;
end


% updateSM=0;     % For intertrial dependencies
% isCorrection=0;     % For correction trials to force to switch sides

scaleFactor = getScaleFactor(stimulus);
interTrialLuminance = getInterTrialLuminance(stimulus); 
interTrialDuration = getInterTrialDuration(stimulus);

details.pctCorrectionTrials=getPercentCorrectionTrials(trialManager);
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);

if length(targetPorts)==1
    if targetPorts == 1
        % animal should go left
        dotDirection = pi
    elseif targetPorts == 3
        dotDirection = 0
    else
        error('Zah?  This should never happen!')
    end
    static=false;
    if iscell(s.movie_duration)
        switch s.movie_duration{2}
            case 'selectWithin'
                selectedDuration = s.movie_duration{1}(1) + rand(1)*(s.movie_duration{1}(2)-s.movie_duration{1}(1));
            case 'selectFrom'
                selectedDuration = s.movie_duration{1}(randi(length((s.movie_duration{1}))));
        end
    else
        if length(s.movie_duration)==2
            selectedDuration = s.movie_duration(1) + rand(1)*(s.movie_duration(2)-s.movie_duration(1));
        else
            selectedDuration = s.movie_duration;
        end
    end
else
    % if more than one target port, then we can only have a static image!
    warning('more than one target port found by coherentDots calcStim - calculating a static dots image ONLY!');
    static=true;
    dotDirection=-1;
    selectedDuration=1/hz;
end

num_frames = floor(hz * selectedDuration);

alldotsxy = [rand(s.num_dots,1)*(s.screen_width-1)+1 ...
              rand(s.num_dots,1)*(s.screen_height-1)+1];
dot_history = zeros(s.num_dots,2,num_frames);

dots_movie = uint8(zeros(s.screen_height, s.screen_width, num_frames));

% ===================================================================================
% 11/20/08 - fli
% do all random picking here (from coherence, size, contrast, speed as necessary)
%   s.coherence -> selectedCoherence
%   s.dot_size -> selectedDotSize
%   s.contrast -> selectedContrast
%   s.speed -> selectedSpeed
% coherence
if iscell(s.coherence)
    switch s.coherence{2}
        case 'selectWithin'
            selectedCoherence = s.coherence{1}(1) + rand(1)*(s.coherence{1}(2)-s.coherence{1}(1));
        case 'selectFrom'
            selectedCoherence = s.coherence{1}(randi(length((s.coherence{1}))));
    end
else
    if length(s.coherence)==2
        selectedCoherence = s.coherence(1) + rand(1)*(s.coherence(2)-s.coherence(1));
    else
        selectedCoherence = s.coherence;
    end
end

% dot_size
if iscell(s.dot_size)
    switch s.dot_size{2}
        case 'selectWithin'
            selectedDotSize = s.dot_size{1}(1) + rand(1)*(s.dot_size{1}(2)-s.dot_size{1}(1));
        case 'selectFrom'
            selectedDotSize = s.dot_size{1}(randi(length((s.dot_size{1}))));
    end
else
    if length(s.dot_size)==2
        selectedDotSize = round(s.dot_size(1) + rand(1)*(s.dot_size(2)-s.dot_size(1)));
    else
        selectedDotSize = s.dot_size;
    end
end

% contrast
if iscell(s.contrast)
    switch s.contrast{2}
        case 'selectWithin'
            selectedContrast = s.contrast{1}(1) + rand(1)*(s.contrast{1}(2)-s.contrast{1}(1));
        case 'selectFrom'
            selectedContrast = s.contrast{1}(randi(length((s.contrast{1}))));
    end
else
    if length(s.contrast)==2
        selectedContrast = s.contrast(1) + rand(1)*(s.contrast(2)-s.contrast(1));
    else
        selectedContrast = s.contrast;
    end
end

% speed
if iscell(s.speed)
    switch s.speed{2}
        case 'selectWithin'
            selectedSpeed = s.speed{1}(1) + rand(1)*(s.speed{1}(2)-s.speed{1}(1));
        case 'selectFrom'
            selectedSpeed = s.speed{1}(randi(length((s.speed{1}))));
    end
else
    if length(s.speed)==2
        selectedSpeed = s.speed(1) + rand(1)*(s.speed(2)-s.speed(1));
    else
        selectedSpeed = s.speed;
    end
end
% ===================================================================================
%shape = zeros(dot_size,2);
% Make a square shape
shape = ones(selectedDotSize);

%% Draw those dots!

frame = zeros(s.screen_height,s.screen_width);
frame(sub2ind(size(frame),floor(alldotsxy(:,2)),floor(alldotsxy(:,1)))) = 1;
frame = conv2(frame,shape,'same');
frame(frame > 0) = 255;
dot_history(:,:,1) = alldotsxy;
dots_movie(:,:,1) = uint8(frame);
% alldotsxy(:,1);
% alldotsxy(:,2);

if ~static
    
    vx = selectedSpeed*cos(dotDirection);
    vy = selectedSpeed*sin(dotDirection);

    for i=1:num_frames
        frame = zeros(s.screen_height,s.screen_width);
        try
            frame(sub2ind(size(frame),ceil(alldotsxy(:,2)),ceil(alldotsxy(:,1)))) = 1;
        catch
            min(floor(alldotsxy(:,2)))
            min(floor(alldotsxy(:,1)))
            max(floor(alldotsxy(:,2)))
            max(floor(alldotsxy(:,1)))
            sca;
            keyboard
        end
        frame = conv2(frame,shape,'same');
        frame(frame > 0) = 255;
        dots_movie(:,:,i) = uint8(frame);
        dot_history(:,:,i) = alldotsxy;

        % Randomly find who's going to be coherent and who isn't
        move_coher = rand(s.num_dots,1) < selectedCoherence;
        move_randomly = ~move_coher;

        num_out = sum(move_randomly);

        if (num_out ~= s.num_dots)
            alldotsxy(move_coher,1) = alldotsxy(move_coher,1) + vx;
            alldotsxy(move_coher,2) = alldotsxy(move_coher,2) + vy;
        end
        if (num_out)
            alldotsxy(move_randomly,:) = [rand(num_out,1)*(s.screen_width-1)+1 ...
                rand(num_out,1)*(s.screen_height-1)+1];
        end
        
        % all that are beyond the right
        overboard = alldotsxy(:,1) > s.screen_width;
        num_out = sum(overboard);
        if (num_out)
            alldotsxy(overboard,1) = alldotsxy(overboard,1)- s.screen_width + 1;
        end
        
        % all that are before the left
        overboard = alldotsxy(:,1) < 0;
        num_out = sum(overboard);
        if (num_out)
            alldotsxy(overboard,1) = s.screen_width + alldotsxy(overboard,1) ;
        end
        
        % all that are below the bottom
        overboard = alldotsxy(:,2) > s.screen_height;
        num_out = sum(overboard);
        if (num_out)
            alldotsxy(overboard,2) = alldotsxy(overboard,2)- s.screen_height + 1;
        end
        
        % all that are above the top
        overboard = floor(alldotsxy(:,2)) <= 0;
        num_out = sum(overboard);
        if (num_out)
            alldotsxy(overboard,2) = s.screen_height + alldotsxy(overboard,2);
        end
    end
else
    for i = 1:num_frames
        dots_movie(:,:,i) = frame;
    end
end

out = dots_movie*selectedContrast;
if strcmp(stimulus.replayMode,'loop')
    type='loop';
elseif strcmp(stimulus.replayMode,'once')
    type='cache';
    out(:,:,end+1)=0;
else
    error('unknown replayMode');
end

% details.stimStruct = structize(stimulus);
details.dotDirection = dotDirection;
details.dotxy = alldotsxy;
details.coherence = s.coherence;
details.dot_size = s.dot_size;
details.contrast = s.contrast;
details.speed = s.speed;

details.selectedCoherence = selectedCoherence;
details.selectedDotSize = selectedDotSize;
details.selectedContrast = selectedContrast;
details.selectedSpeed = selectedSpeed;
details.selectedDuration = selectedDuration;

discrimStim=[];
discrimStim.stimulus=out;
discrimStim.stimType=type;
discrimStim.scaleFactor=scaleFactor;
discrimStim.startFrame=0;
discrimStim.autoTrigger=[];

preRequestStim=[];
preRequestStim.stimulus=interTrialLuminance;
preRequestStim.stimType='loop';
preRequestStim.scaleFactor=0;
preRequestStim.startFrame=0;
preRequestStim.autoTrigger=[];
preRequestStim.punishResponses=false;

preResponseStim=discrimStim;
preResponseStim.punishResponses=false;

postDiscrimStim = [];

interTrialStim.duration = interTrialDuration;
details.interTrialDuration = interTrialDuration;

if (strcmp(trialManagerClass,'nAFC') || strcmp(trialManagerClass,'goNoGo')) && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('coherence: %g dot_size: %g contrast: %g speed: %g',selectedCoherence,selectedDotSize,selectedContrast,selectedSpeed);
end