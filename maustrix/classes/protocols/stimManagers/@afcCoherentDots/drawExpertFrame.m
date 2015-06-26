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

% expertCache will have the current state of the system
if isempty(expertCache)
    expertCache.previousXYDots=[];
    expertCache.previousXYBkgd=[];
    expertCache.nextVelDots=[];
    expertCache.nextVelBkgd=[];
end

black=0.0;
white=1.0;
gray = (white-black)/2;

try
if i ==1
    % for the first frame we will set nextVel to 0
    expertCache.nextVelDots=zeros(stim.numDots,2);
    expertCache.nextVelBkgd=zeros(stim.bkgdNumDots,2);
    
    % save current state
    try
        prevState = rng;
    catch
        prevState = rand('seed');
    end
    % seed the random number generator with available values (peppered with
    % the current frame number
    try
        rng(stim.seedVal,stim.rngMethod);
    catch
        rand('seed',stim.seedVal);
    end
    
    
    currentXYDots = rand(stim.numDots,2).*repmat([stim.width,stim.height],stim.numDots,1);
    currentXYBkgd = rand(stim.bkgdNumDots,2).*repmat([stim.width,stim.height],stim.bkgdNumDots,1);
    
    expertCache.previousXYDots=currentXYDots;
    expertCache.previousXYBkgd=currentXYBkgd;
    
    try
        rng(prevState);
    catch
        rand('seed',prevState);
    end
end

% get previous positions. this is same as the random positions chosen for
% the first frame
oldXYDots=expertCache.previousXYDots;
oldXYBkgd=expertCache.previousXYBkgd;

% get velocities calculated from previous frame. no change in velocity for
% first frame
currentXYDots=oldXYDots+expertCache.nextVelDots;
currentXYBkgd=oldXYBkgd+expertCache.nextVelBkgd;

% there needs to be code here that checks for out of boundedness
dotsX = currentXYDots(:,1); 
dotsY = currentXYDots(:,2);
currentXYDots((dotsX<0),1) = dotsX(dotsX<0)+stim.width;
currentXYDots((dotsX>stim.width),1) = dotsX(dotsX>stim.width)-stim.width;
currentXYDots((dotsY<0),2) = dotsY(dotsY<0)+stim.height;
currentXYDots((dotsY>stim.height),1) = dotsY(dotsY>stim.height)-stim.height;


bkgdX = currentXYBkgd(:,1);
bkgdY = currentXYBkgd(:,2);
currentXYBkgd((bkgdX<0),1) = bkgdX(bkgdX<0)+stim.width;
currentXYBkgd((bkgdX>stim.width),1) = bkgdX(bkgdX>stim.width)-stim.width;
currentXYBkgd((bkgdY<0),2) = bkgdY(bkgdY<0)+stim.height;
currentXYBkgd((bkgdY>stim.height),1) = bkgdY(bkgdY>stim.height)-stim.height;

% find dotSize from stim.dotsRenderDistance and stim.bkdgRenderDistance
dotSize = stim.dotSize./stim.dotsRenderDistance;
bkgdSize = stim.bkgdSize./stim.bkgdRenderDistance;

% find dotColor
dotColor = repmat(stim.dotColor,stim.numDots,1);
bkgdColor = repmat(stim.bkgdDotColor, stim.bkgdNumDots,1);

% fill up the background to start with
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('FillRect', window,255*stim.background);
% now the background dots
hasBkgd = ~isempty(currentXYBkgd);
if hasBkgd
    Screen('DrawDots',window,currentXYBkgd',bkgdSize',255*bkgdColor');
end
% and the actual dots
Screen('DrawDots',window,currentXYDots',dotSize',255*dotColor');

% good now these positions go into the expertCache
expertCache.previousXYDots = currentXYDots;
expertCache.previousXYBkgd = currentXYBkgd;

% done with the drawing for this frame - we need to worry about drawing the
% next frame now

% figure out the speeds of the individual dots
dotSpeed = stim.dotSpeed./stim.dotsRenderDistance; % units of dotSize/sec
bkgdSpeed = stim.bkgdSpeed./stim.bkgdRenderDistance; % units of bkgdSize/sec

% choose the coherent ones
try
    prevState = rng;
    rng(stim.seedVal+i,stim.rngMethod);
catch
    prevState = rand('seed');
    rand('seed',stim.seedVal+i);
end
whichCoherentDots = rand(stim.numDots,1)<stim.dotCoherence;
whichCoherentBkgd = rand(stim.bkgdNumDots,1)<stim.bkgdCoherence;
try
    rng(prevState);
catch
    rand('seed',prevState);
end
% choose the chosen stim angle for the coherentOnes
dotDirection = stim.dotDirection.*double(whichCoherentDots);
bkgdDirection = stim.bkgdDirection.*double(whichCoherentBkgd);

% get the x and y velocities by doing the trigonometric transformations
expertCache.nextVelDots = [dotSpeed.*cos(dotDirection) -dotSpeed.*sin(dotDirection)]*stim.dotSize*ifi;
expertCache.nextVelBkgd = [bkgdSpeed.*cos(bkgdDirection) -bkgdSpeed.*sin(bkgdDirection)]*stim.bkgdSize*ifi;

% for the non coherent ones, set velocity to zero. set position to random
expertCache.nextVelDots(~whichCoherentDots,:) = repmat([0 0],sum(double(~whichCoherentDots)),1);
expertCache.nextVelBkgd(~whichCoherentBkgd,:) = repmat([0 0],sum(double(~whichCoherentBkgd)),1);
expertCache.previousXYDots(~whichCoherentDots,:) = repmat([0 0],sum(double(~whichCoherentDots)),1);
expertCache.previousXYBkgd(~whichCoherentBkgd,:) = repmat([0 0],sum(double(~whichCoherentBkgd)),1);
expertCache.previousXYDots = expertCache.previousXYDots + rand(stim.numDots,2).*repmat([stim.width,stim.height],stim.numDots,1).*double([~whichCoherentDots ~whichCoherentDots]);
expertCache.previousXYBkgd = expertCache.previousXYBkgd + rand(stim.bkgdNumDots,2).*repmat([stim.width,stim.height],stim.bkgdNumDots,1).*double([~whichCoherentBkgd ~whichCoherentBkgd]);

catch ex
    getReport(ex)
    sca;
    keyboard
end

end % end function