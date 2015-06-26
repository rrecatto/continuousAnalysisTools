function moreStim(stimManager,state)
% implements expert mode for images - calls PTB drawing functions directly, leaving drawText and drawingFinished to stimOGL
%
% state.destRect
% state.floatprecision
% state.filtMode
% state.window
% state.img
%
% stimManager.selectedSizes
% stimManager.selectedRotation

% % try simple thing for now
% imagestex=Screen('MakeTexture',state.window,state.img,0,0,state.floatprecision);
% 
% % Draw images texture, rotated by "rotation":
% newDestRect=state.destRect*stimManager.selectedSize;
% Screen('DrawTexture', state.window, imagestex,[],newDestRect, ...
%     stimManager.selectedRotation, state.filtMode);
Screen('FillRect', state.window, 0);
Screen('BlendFunction', state.window, GL_SRC_ALPHA, GL_ONE); % necessary to do the transparency blending

imgs=stimManager.images;
for i=1:size(imgs,1) % for each actual image, not the entire screen
    if ~isempty(imgs{i,1})
        % if not empty, then rotate and draw
        imgToProcess=imgs{i,1};
        % rotate
        imagetex=Screen('MakeTexture',state.window,imgToProcess,0,0,state.floatprecision);
        thisDestRect=state.destRect;
        thisDestRect(3)=imgs{i,2}(2);
        thisDestRect(1)=imgs{i,2}(1);
        % do image scaling now
        thisDestHeight=thisDestRect(4)-thisDestRect(2)+1;
        newHeight=thisDestHeight*stimManager.selectedSizes(i);
        deltaHeight=(thisDestHeight-newHeight)/2;
        
        thisDestWidth=thisDestRect(3)-thisDestRect(1)+1;
        newWidth=thisDestWidth*stimManager.selectedSizes(i);
        deltaWidth=(thisDestWidth-newWidth)/2;
        
        newDestRect=[thisDestRect(1)+deltaWidth thisDestRect(2)+deltaHeight thisDestRect(3)-deltaWidth thisDestRect(4)-deltaHeight];
        % draw
        Screen('DrawTexture',state.window,imagetex,[],newDestRect,stimManager.selectedRotation,state.filtMode);
    end
end

% disable alpha blending (for text)
Screen('BlendFunction',state.window,GL_ONE,GL_ZERO);

end % end function