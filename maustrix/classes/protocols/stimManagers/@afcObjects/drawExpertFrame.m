function [doFramePulse, expertCache, dynamicDetails, textLabel, i, dontclear, indexPulse] = ...
    drawExpertFrame(stimulus,stim,i,phaseStartTime,totalFrameNum,window,textLabel,destRect,...
    filtMode,expertCache,ifi,scheduledFrameNum,dropFrames,dontclear,dynamicDetails)
% implements expert mode for images - calls PTB drawing functions directly, leaving drawText and drawingFinished to stimOGL
%
% state.destRect
% state.floatprecision
% state.filtMode
% state.window
% state.img
%
% stimManager.selectedSizes
% stimManager.selectedRotations

indexPulse=false;

% increment i
if dropFrames
    i=scheduledFrameNum;
else
    i=i+1;
end
doFramePulse=true;
floatprecision=0;

% % try simple thing for now
% imagestex=Screen('MakeTexture',state.window,state.img,0,0,state.floatprecision);
% 
% % Draw images texture, rotated by "rotation":
% newDestRect=state.destRect*stimManager.selectedSize;
% Screen('DrawTexture', state.window, imagestex,[],newDestRect, ...
%     stimManager.selectedRotations, state.filtMode);
Screen('FillRect', window, 0);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE); % necessary to do the transparency blending

imgToProcess=stimulus.image;

imagetex=Screen('MakeTexture',window,imgToProcess,0,0,floatprecision);
% draw
Screen('DrawTexture',window,imagetex);
% clear imagetex from vram
Screen('Close',imagetex);


% disable alpha blending (for text)
Screen('BlendFunction',window,GL_ONE,GL_ZERO);

end % end function
