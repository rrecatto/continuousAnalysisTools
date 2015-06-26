function [doFramePulse, expertCache, dynamicDetails, textLabel, i, dontclear, indexPulse] = ...
    drawExpertFrame(stimulus,stim,i,phaseStartTime,totalFrameNum,window,textLabel,destRect,filtMode,...
    expertCache,ifi,scheduledFrameNum,dropFrames,dontclear,dynamicDetails)
% 10/31/08 - implementing expert mode for whiteNoise
% this function calculates a expert frame, and then makes and draws the texture; nothing needs to be done in runRealTimeLoop
% this should be a stimManager-specific implementation (if expert mode is supported for the given stimulus)
indexPulse=false;
floatprecision=1;

%initialize first frame
if stimulus.blankOn
    doBlank = true;
else
    doBlank = false;
end
radiusType = 'gaussian';
if scheduledFrameNum==1 || i<2
    expertCache.repeatNum = 1;
    expertCache.bubbleNum = 1;
    expertCache.framesPerBubble = stim.bubbleDuration;
    expertCache.numBubbles = stim.numBubbles;
    expertCache.numRepeats = stim.numRepeats;
    expertCache.repeatNum = 1;
    expertCache.allLocations = stim.bubbleLocations;
    expertCache.currentBubbleNumber = 1;
    expertCache.currentLocation = expertCache.allLocations(expertCache.currentBubbleNumber,:);
    expertCache.framesSinceLastflip = 0;
    
    mask=[];
    switch radiusType
        case 'gaussian'
            maskParams=[stim.bubbleSize 999 0 0 ...
                1.0 0.00005 expertCache.currentLocation(1) expertCache.currentLocation(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result
            mask(:,:,1)=ones(stim.height,stim.width,1)*0.5;
            mask(:,:,2)=computeGabors(maskParams,0,stim.width,stim.height,...
                'none', 'normalizeDiagonal',0,0);
            mask(:,:,2) = 1-mask(:,:,2);
        case 'hardEdge'
            %             mask(:,:,1)=ones(2*stim.height,2*stim.width,1)*stimulus.mean;
            %             [WIDTH HEIGHT] = meshgrid(1:2*stim.width,1:2*stim.height);
            %             mask(:,:,2)=double((((WIDTH-width*details.location(1)).^2)+((HEIGHT-height*details.location(2)).^2)-((unsortedUniques(i))^2*(height^2)))>0);
            %             stim.masks{i}=mask;
            error('not yet');
            
    end
    expertCache.currMask = Screen('MakeTexture',window,double(mask),0,0,floatprecision);
%     sca;
%     keyboard
end

% increment i
if dropFrames
    i=scheduledFrameNum;
else
    i=i+1;
    expertCache.framesSinceLastflip = expertCache.framesSinceLastflip+1;
    if mod(expertCache.framesSinceLastflip,expertCache.framesPerBubble)==0
        expertCache.framesSinceLastflip = 0;
        expertCache.currentBubbleNumber = expertCache.currentBubbleNumber+1;
        if mod(expertCache.currentBubbleNumber,expertCache.numBubbles+1)==0
            expertCache.currentBubbleNumber = 1;
            expertCache.repeatNum = expertCache.repeatNum+1;
        end
        expertCache.currentLocation = expertCache.allLocations(expertCache.currentBubbleNumber,:);
        Screen('Close',expertCache.currMask)
        switch radiusType
            case 'gaussian'
                maskParams=[stim.bubbleSize 999 0 0 ...
                    1.0 0.00005 expertCache.currentLocation(1) expertCache.currentLocation(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result
                mask(:,:,1)=ones(stim.height,stim.width,1)*0.5;
                mask(:,:,2)=computeGabors(maskParams,0,stim.width,stim.height,...
                    'none', 'normalizeDiagonal',0,0);
                mask(:,:,2) = 1-mask(:,:,2);
            case 'hardEdge'
                %             mask(:,:,1)=ones(2*stim.height,2*stim.width,1)*stimulus.mean;
                %             [WIDTH HEIGHT] = meshgrid(1:2*stim.width,1:2*stim.height);
                %             mask(:,:,2)=double((((WIDTH-width*details.location(1)).^2)+((HEIGHT-height*details.location(2)).^2)-((unsortedUniques(i))^2*(height^2)))>0);
                %             stim.masks{i}=mask;
                error('not yet');
                
        end
        expertCache.currMask = Screen('MakeTexture',window,double(mask),0,0,floatprecision);
    end
end

% stimulus = stimManager
doFramePulse=true;

% ================================================================================

% start calculating frames now
stimLocation = stimulus.requestedStimLocation;

% set randn/rand to the current frame's precalculated seed value -- 
% make this a method so its always in sync with analysis ... save sha1?
%background

switch stimulus.distribution.type
        case 'gaussian'
            meanLuminance = stim.distribution.meanLuminance;
            std = stim.distribution.std;
            randn('state',stim.seedValues(i));
            expertFrame = randn(stimulus.spatialDim([2 1]))*1*std+meanLuminance;
            expertFrame(expertFrame<0) = 0;
            expertFrame(expertFrame>1) = 1;
        case 'binary'
            rand('state',stim.seedValues(i));
            lumDiff=stim.distribution.hiVal-stim.distribution.lowVal;
            expertFrame = stim.distribution.lowVal+(double(rand(stimulus.spatialDim([2 1]))<stimulus.distribution.probability)*lumDiff);
        otherwise
            error('bad type')
end
    

Screen('FillRect', window, stimulus.background*WhiteIndex(window));
% 11/14/08 - moved the make and draw to stimManager specific getexpertFrame b/c they might draw differently

dynTex = Screen('MakeTexture', window, expertFrame,0,0,floatprecision);
Screen('DrawTexture', window, dynTex,[],stimLocation,[],filtMode);

% Blending for making bubbles
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % necessary to do the transparency blending
Screen('DrawTexture', window, expertCache.currMask, [], destRect,[], filtMode);


% clear dynTex from vram
Screen('Close',dynTex);

end % end function