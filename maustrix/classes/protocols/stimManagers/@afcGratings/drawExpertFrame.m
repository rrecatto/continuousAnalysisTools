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
cycsPerFrameVel = stim.driftfrequencies*ifi; % in units of cycles/frame
offset = 2*pi*cycsPerFrameVel*i;

% Create a 1D vector x based on the frequency pixPerCycs
% make the grating twice the normal width (to cover entire screen if rotated)
x = (1:stim.width*2)*2*pi/stim.pixPerCycs;
switch stim.waveform
    case 'sine'
        grating=stim.contrasts*cos(x + offset+stim.phases)/2+stimulus.mean; 
    case 'square'
        grating=stim.contrasts*square(x + offset+stim.phases)/2+stimulus.mean;
end
% Make grating texture
gratingtex=Screen('MakeTexture',window,grating,0,0,floatprecision);

% set srcRect
srcRect=[0 0 size(grating,2) 1];

% Draw grating texture, rotated by "angle":
destWidth = destRect(3)-destRect(1);
destHeight = destRect(4)-destRect(2);
destRectForGrating = [destRect(1)-destWidth/2, destRect(2)-destHeight, destRect(3)+destWidth/2,destRect(4)+destHeight];
Screen('DrawTexture', window, gratingtex, srcRect, destRectForGrating, ...
    (180/pi)*stim.orientations, filtMode);
try
    if ~isempty(stim.masks{1})
        % Draw gaussian mask over grating: We need to subtract 0.5 from
        % the real size to avoid interpolation artifacts that are
        % created by the gfx-hardware due to internal numerical
        % roundoff errors when drawing rotated images:
        % Make mask to texture
        Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % necessary to do the transparency blending
        if isempty(expertCache.masktexs)
            expertCache.masktexs= Screen('MakeTexture',window,double(stim.masks{1}),0,0,floatprecision);
        end
        % Draw mask texture: (with no rotation)
        Screen('DrawTexture', window, expertCache.masktexs, [], destRect,[], filtMode);
    end
    if ~isempty(stim.annuliMatrices{1})
        Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        if isempty(expertCache.annulitexs)
            expertCache.annulitexs=Screen('MakeTexture',window,double(stim.annuliMatrices{1}),0,0,floatprecision);
        end
        % Draw mask texture: (with no rotation)
        Screen('DrawTexture',window,expertCache.annulitexs,[],destRect,[],filtMode);
    end
catch ex
    sca;
    keyboard
end

% clear the gratingtex from vram
Screen('Close',gratingtex);
end % end function