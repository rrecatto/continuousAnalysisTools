function varargout = sparseNoise(frameDurationMS,totalDurationSecs,stimParams,rigParams)
if ~exist('stimParams','var')||isempty(stimParams)
    stimParams.sizeRange = [1 10]; % deg
    stimParams.numOvalsPerFrame = 7;
end
if ~exist('frameDurationMS','var')||isempty(frameDurationMS)
    frameDurationMS = 20*1/Screen('NominalFrameRate',0)*1000;
end
if ~exist('totalDurationSecs','var')||isempty(totalDurationSecs)
    totalDurationSecs = 30;
end
if ~exist('rigParams','var')||isempty(rigParams)
    rigParams.pixPerDeg = 20;%mm
end


allRes = Screen('Resolutions',0);
widths = [allRes.width];
heights = [allRes.height];
colDepths = [allRes.pixelSize];

widthToCheck = max(widths); 
potentialHeights = heights(widths == max(widths));
heightToCheck = max(potentialHeights);
potentialDepth = colDepths(widths==widthToCheck & heights==heightToCheck);
depthToCheck = max(potentialDepth);
which = (widths==widthToCheck)&(heights==heightToCheck)&(colDepths==depthToCheck);
chosenRes = allRes(which);
width = chosenRes.width;
height = chosenRes.height;

numRealFramePerStimFrame = ceil((frameDurationMS/1000)*Screen('NominalFrameRate',0));
numStimFrames = ceil(totalDurationSecs*1000/frameDurationMS);

% now create the stims;

whichScreen = 0;
window = Screen(whichScreen, 'OpenWindow');


white = WhiteIndex(window); % pixel value for white
black = BlackIndex(window); % pixel value for black
gray = (white+black)/2;
inc = white-black;

pixMin = stimParams.sizeRange(1)*rigParams.pixPerDeg;
pixMax = stimParams.sizeRange(2)*rigParams.pixPerDeg;

rects = nan(numStimFrames,stimParams.numOvalsPerFrame,5);
for i = 1:numStimFrames
    for j = 1:stimParams.numOvalsPerFrame
        ok = false;
        while ~ok
            currRectCen = [ceil(randIn(1,width)) ceil(randIn(1,height))];
            currRectSize = [ceil(randIn(pixMin,pixMax)) ceil(randIn(pixMin,pixMax))];
            if currRectCen(1)-currRectSize(1)/2 >0 && currRectCen(1)+currRectSize(1)/2<width &&...
                    currRectCen(2)-currRectSize(2)/2 >0 && currRectCen(2)+currRectSize(2)/2<height
                ok = true;
            end
        end
        rects(i,j,:) = [currRectCen(1)-currRectSize(1)/2 currRectCen(2)-currRectSize(2)/2 ...
            currRectCen(1)+currRectSize(1)/2 currRectCen(2)+currRectSize(2) ...
            black+(rand>0.5)*inc];
    end
end



Screen(window, 'FillRect', gray);
% 
% sca;
% keyboard
for i = 1:numStimFrames
    currColors = repmat(squeeze(rects(i,:,5)),3,1);
    currRects = squeeze(rects(i,:,1:4))';
    for repNum = 1:numRealFramePerStimFrame
        Screen('FillOval',window,currColors,currRects);
        Screen(window,'Flip');
    end
end
Screen('CloseAll');
varargout = {rects};
end

function out = randIn(min,max)
out = min+rand*(max-min);
end