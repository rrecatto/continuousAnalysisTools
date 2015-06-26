function [doFramePulse expertCache dynamicDetails textLabel i dontclear indexPulse] = ...
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

imgs=stimulus.images;
for j=1:size(imgs,1) % for each actual image, not the entire screen
    if ~isempty(imgs{j,1})
        % if not empty, then rotate and draw
        imgToProcess=imgs{j,1};
        % rotate
        imagetex=Screen('MakeTexture',window,imgToProcess,0,0,floatprecision);
        
        % get img bounds in terms of normalized 0-1, then apply destRect
        destHeight=destRect(4)-destRect(2);
        destWidth=destRect(3)-destRect(1);
        normImg=[imgs{j,2}(1) 0 imgs{j,2}(2) stim.height];
        normImg=normImg ./ [stim.width stim.height stim.width stim.height];
        thisDestRect=[destWidth*normImg(1)+destRect(1) destHeight*normImg(2)+destRect(2)...
            destWidth*normImg(3)+destRect(1) destHeight*normImg(4)+destRect(2)];
        % do image scaling now
        thisDestHeight=thisDestRect(4)-thisDestRect(2)+1;
        newHeight=thisDestHeight*stimulus.selectedSizes(j);
        deltaHeight=(thisDestHeight-newHeight)/2;
        
        thisDestWidth=thisDestRect(3)-thisDestRect(1)+1;
        newWidth=thisDestWidth*stimulus.selectedSizes(j);
        deltaWidth=(thisDestWidth-newWidth)/2;
        
        newDestRect=[thisDestRect(1)+deltaWidth thisDestRect(2)+deltaHeight thisDestRect(3)-deltaWidth thisDestRect(4)-deltaHeight];
        % draw
        Screen('DrawTexture',window,imagetex,[],newDestRect,stimulus.selectedRotations(j),filtMode);
        % clear imagetex from vram
        Screen('Close',imagetex);
    end
end

% disable alpha blending (for text)
Screen('BlendFunction',window,GL_ONE,GL_ZERO);

end % end function
