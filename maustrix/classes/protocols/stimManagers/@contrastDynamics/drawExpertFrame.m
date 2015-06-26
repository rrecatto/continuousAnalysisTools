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
if isempty(expertCache)
    % this happens at the beginning of the trial. this stimManager will do
    % something interesting - it will cache the computed masks at some
    % location and then recall it for future use
    
    expertCache.uniqueRadii = unique(stim.radii);
    expertCache.radiiMasks = {};
    expertCache.currentLocation = [0.5 0.5];
    warning ('need to worry about sending in the currentLocation')
    
    % check if the computed mask function exists
    
    SCRATCHFOLDER = getenv('SCRATCHFOLDER');
    needToCalcMasks = true;
    if exist(fullfile(SCRATCHFOLDER,'radiiMasks.mat'),'file')
        temp = load(fullfile(SCRATCHFOLDER,'radiiMasks.mat'));
        
        if temp.uniqueRadii == unique(stim.radii)
            needToCalcMasks = false;
            for rad = 1:length(expertCache.uniqueRadii)
                expertCache.radiiMasks{rad} = Screen('MakeTexture',window,double(temp.radMasks{rad}),0,0,floatprecision);
            end
        end
    end
    
    if needToCalcMasks
        uniqueRadii = expertCache.uniqueRadii;
        radMasks = {};
        for rad = 1:length(uniqueRadii)
            uniqueRadii(rad)
            mask=[];
            switch radiusType
                case 'gaussian'
                    maskParams=[expertCache.uniqueRadii(rad) 999 0 0 ...
                        1.0 0.00005 expertCache.currentLocation(1) expertCache.currentLocation(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result
                    mask(:,:,1)=ones(stim.height,stim.width,1)*0.5;
                    try
                    mask(:,:,2)=computeGabors(maskParams,0,stim.width,stim.height,...
                        'none', 'normalizeDiagonal',0,0);
                    catch
                        memory
                        whos
                    end
                    mask(:,:,2) = 1-mask(:,:,2);
                case 'hardEdge'
                    %             mask(:,:,1)=ones(2*stim.height,2*stim.width,1)*stimulus.mean;
                    %             [WIDTH HEIGHT] = meshgrid(1:2*stim.width,1:2*stim.height);
                    %             mask(:,:,2)=double((((WIDTH-width*details.location(1)).^2)+((HEIGHT-height*details.location(2)).^2)-((unsortedUniques(i))^2*(height^2)))>0);
                    %             stim.masks{i}=mask;
                    error('not yet');
                    
            end
            radMasks{rad} = mask;
            expertCache.radiiMasks{rad} = Screen('MakeTexture',window,double(mask),0,0,floatprecision);
        end
        save(fullfile(SCRATCHFOLDER,'radiiMasks.mat'),'uniqueRadii','radMasks');
    end
end

% increment i
if dropFrames
    i=scheduledFrameNum;
else
    i=i+1;
end

% stimulus = stimManager
doFramePulse=true;
indexPulse = false;

% ================================================================================

% start calculating frames now
stimLocation = stimulus.stimSpec.location;

% this needs to change

% rand('state',2000);
% lumDiff=stim.distribution.hiVal-stim.distribution.lowVal;
hiVal = 1; loVal = 0; grey = (hiVal+loVal)/2;
expertFrame = grey+(double(rand([9 16])<grey)-grey)*(stim.contrasts(i)/100);

Screen('FillRect', window, stimulus.background*WhiteIndex(window));
% 11/14/08 - moved the make and draw to stimManager specific getexpertFrame b/c they might draw differently

dynTex = Screen('MakeTexture', window, expertFrame,0,0,floatprecision);
Screen('DrawTexture', window, dynTex,[],destRect,[],filtMode);

% Blending for making bubbles
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % necessary to do the transparency blending
Screen('DrawTexture', window, expertCache.radiiMasks{expertCache.uniqueRadii==stim.radii(i)}, [], destRect,[], filtMode);


% clear dynTex from vram
Screen('Close',dynTex);

end % end function