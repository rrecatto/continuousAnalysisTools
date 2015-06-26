function [doFramePulse, expertCache, dynamicDetails, textLabel, i, dontclear, indexPulse] = ...
    drawExpertFrame(stimulus,stim,i,phaseStartTime,totalFrameNum,window,textLabel,destRect,filtMode,...
    expertCache,ifi,scheduledFrameNum,dropFrames,dontclear,dynamicDetails)
% 11/14/08 - implementing expert mode for gratings
% this function calculates an expert frame, and then makes and draws the texture; nothing needs to be done in runRealTimeLoop
% this should be a stimManager-specific implementation (if expert mode is supported for the given stimulus)

floatprecision=1;

% increment i
if dropFrames
    i=scheduledFrameNum;
else
    i=i+1;
end

doFramePulse=true;
indexPulse = false;


% expertCache should contain masktexs and annulitexs
if isempty(expertCache)
    expertCache.masktexs=[];
    expertCache.annulitexs=[];
end

black=0.0;
white=1.0;
gray = (white-black)/2;

%stim.velocities is in cycles per second
cycsPerFrameVelCenter = stim.driftfrequenciesCenter*ifi; % in units of cycles/frame
cycsPerFrameVelSurround = stim.driftfrequenciesSurround*ifi; % in units of cycles/frame
offsetCenter = 2*pi*cycsPerFrameVelCenter*i;
offsetSurround = 2*pi*cycsPerFrameVelSurround*i;

% Create a 1D vector x based on the frequency pixPerCycs
% make the grating twice the normal width (to cover entire screen if rotated)
xCenter = (1:stim.width*2)*2*pi/stim.pixPerCycsCenter;
xSurround = (1:stim.width*2)*2*pi/stim.pixPerCycsSurround;
switch stim.waveform
    case 'sine'
        gratingCenter=stim.contrastsCenter*cos(xCenter + offsetCenter+stim.phasesCenter)/2+stimulus.mean; 
        gratingSurround=stim.contrastsSurround*cos(xSurround + offsetSurround+stim.phasesSurround)/2+stimulus.mean; 
    case 'square'
        gratingCenter=stim.contrastsCenter*square(xCenter + offsetCenter+stim.phasesCenter)/2+stimulus.mean;
        gratingSurround=stim.contrastsSurround*square(xSurround + offsetSurround+stim.phasesSurround)/2+stimulus.mean;
end
% Make grating texture
gratingtexCenter=Screen('MakeTexture',window,gratingCenter,0,0,floatprecision);
gratingtexSurround=Screen('MakeTexture',window,gratingSurround,0,0,floatprecision);

% set srcRect
srcRectCenter=[0 0 size(gratingCenter,2) 1];
srcRectSurround=[0 0 size(gratingSurround,2) 1];

% Draw grating texture, rotated by "angle" for surround:
destWidth = destRect(3)-destRect(1);
destHeight = destRect(4)-destRect(2);
destRectForGratingSurround = [destRect(1)-destWidth/2, destRect(2)-destHeight, destRect(3)+destWidth/2,destRect(4)+destHeight];
Screen('DrawTexture', window, gratingtexSurround, srcRectSurround, destRectForGratingSurround,(180/pi)*stim.orientationsSurround, filtMode);
try
    if ~isempty(stim.surroundMask)
        % Draw gaussian mask over grating: We need to subtract 0.5 from
        % the real size to avoid interpolation artifacts that are
        % created by the gfx-hardware due to internal numerical
        % roundoff errors when drawing rotated images:
        % Make mask to texture
        Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % necessary to do the transparency blending
        if isempty(expertCache.masktexs)
            expertCache.masktexs= Screen('MakeTexture',window,double(stim.surroundMask{1}),0,0,floatprecision);
        end
        % Draw mask texture: (with no rotation)
        Screen('DrawTexture', window, expertCache.masktexs, [], destRect,[], filtMode);
    end
catch
    sca;
    keyboard
end
dst2Rect = [0 0 stim.centerSize stim.centerSize];
dst2Rect = CenterRect(dst2Rect,destRect);
% Disable alpha-blending, restrict following drawing to alpha channel:
Screen('Blendfunction', window, GL_ONE, GL_ZERO, [0 0 0 1]);

% Clear 'dstRect' region of framebuffers alpha channel to zero:
Screen('FillRect', window, [0 0 0 0], dst2Rect);

% Fill circular 'dstRect' region with an alpha value of 255:
Screen('FillOval', window, [0 0 0 255], dst2Rect);

Screen('Blendfunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA, [1 1 1 1]);

% Draw 2nd grating texture, but only inside alpha == 255 circular
% aperture, and at an angle of 90 degrees:
Screen('DrawTexture', window, gratingtexCenter, [0 0 stim.centerSize stim.centerSize], dst2Rect, stim.orientationsCenter);

% clear the gratingtex from vram
Screen('Close',gratingtexCenter);
Screen('Close',gratingtexSurround);
end % end function