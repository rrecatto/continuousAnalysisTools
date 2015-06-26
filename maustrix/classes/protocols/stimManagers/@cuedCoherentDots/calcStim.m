function [stimulus, updateSM, resolutionIndex, preRequestStim, preResponseStim, discrimStim,postDiscrimStim,interTrialStim, LUT, targetPorts, distractorPorts, ...
    details, interTrialLuminance, text, indexPulses, imagingTasks] = ...
    calcStim(stimulus,trialManagerClass,allowRepeats,resolutions,displaySize,LUTbits,responsePorts,totalPorts,trialRecords)
% 1/30/09 - trialRecords now includes THIS trial
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

[resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[100 60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));

if isnan(resolutionIndex)
    resolutionIndex=1;
end


% updateSM=0;     % For intertrial dependencies
% isCorrection=0;     % For correction trials to force to switch sides

scaleFactor = getScaleFactor(stimulus);
interTrialLuminance = getInterTrialLuminance(stimulus); 
interTrialDuration = getInterTrialDuration(stimulus);

details.pctCorrectionTrials=stimulus.pctCorrectionTrials; % need to change this to be passed in from trial manager
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass);

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
    if length(s.movie_duration)==2
        selectedDuration = s.movie_duration(1) + rand(1)*(s.movie_duration(2)-s.movie_duration(1));
    else
        selectedDuration = s.movie_duration;
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

%% ===================================================================================
% 11/20/08 - fli
% do all random picking here (from coherence, size, contrast, speed as necessary)
%   s.coherence -> selectedCoherence
%   s.dot_size -> selectedDotSize
%   s.contrast -> selectedContrast
%   s.speed -> selectedSpeed
% coherence
if length(s.coherence)==2
    selectedCoherence = s.coherence(1) + rand(1)*(s.coherence(2)-s.coherence(1));
else
    selectedCoherence = s.coherence;
end
% dot_size
if length(s.dot_size)==2
    selectedDotSize = round(s.dot_size(1) + rand(1)*(s.dot_size(2)-s.dot_size(1)));
else
    selectedDotSize = s.dot_size;
end
% contrast
if length(s.contrast)==2
    selectedContrast = s.contrast(1) + rand(1)*(s.contrast(2)-s.contrast(1));
else
    selectedContrast = s.contrast;
end
% speed
if length(s.speed)==2
    selectedSpeed = s.speed(1) + rand(1)*(s.speed(2)-s.speed(1));
else
    selectedSpeed = s.speed;
end

% trial value
p=cumsum(s.rewards_and_probability(2,:));
r = rand(1);
ind = find(r<p,1,'first');
selectedTrialValue = s.rewards_and_probability(1,ind);

% sound
sound_name = s.cue_sounds{1,ind};
sound_duration = s.cue_sounds{2,ind};

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
        frame(sub2ind(size(frame),floor(alldotsxy(:,2)),floor(alldotsxy(:,1)))) = 1;
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

        overboard = alldotsxy(:,1) > s.screen_width | alldotsxy(:,2) > s.screen_height | ...
            floor(alldotsxy(:,1)) <= 0 | floor(alldotsxy(:,2)) <= 0;
        num_out = sum(overboard);
        if (num_out)
            alldotsxy(overboard,:) = [rand(num_out,1)*(s.screen_width-1)+1 ...
                rand(num_out,1)*(s.screen_height-1)+1];
        end

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

%% details.stimStruct = structize(stimulus);
details.dotDirection = dotDirection;
details.dotxy = alldotsxy;
details.coherence = s.coherence;
details.dot_size = s.dot_size;
details.contrast = s.contrast;
details.speed = s.speed;
details.rewards_and_probability = s.rewards_and_probability;
details.cue_sound_name = sound_name;
details.cue_sound_duration = sound_duration;

details.selectedCoherence = selectedCoherence;
details.selectedDotSize = selectedDotSize;
details.selectedContrast = selectedContrast;
details.selectedSpeed = selectedSpeed;
details.selectedDuration = selectedDuration;
details.selectedTrialValue = selectedTrialValue;

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

preResponseStim=preRequestStim;
postDiscrimStim = [];
interTrialStim.duration = interTrialDuration;
details.interTrialDuration = interTrialDuration;
if (strcmp(trialManagerClass,'nAFC') || strcmp(trialManagerClass,'goNoGo')) && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('coherence: %g dot_size: %g contrast: %g speed: %g',selectedCoherence,selectedDotSize,selectedContrast,selectedSpeed);
end