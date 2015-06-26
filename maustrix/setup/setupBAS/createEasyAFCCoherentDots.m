function ts = createEasyAFCCoherentDots(trialManager, performanceCrit, sch, svnRev, svnCheckMode)
% makes a basic, easy drifting grating training step
% correct response = side toward which grating drifts?

numDots = {100,100};                            % Number of dots to display
bkgdNumDots = {0,0};                        % task irrelevant dots
dotCoherence = {0.8, 0.8};                      % Percent of dots to move in a specified direction
bkgdCoherence = {0.2, 0.2};                     % percent of bkgs dots moving in the specified direction
dotSpeed = {2,2};                               % How fast do our little dots move (dotSize/sec)
bkgdSpeed = {0.9,0.9};                          % speed of bkgd dots
dotDirection = {[pi],[0]};                % 0 is to the right. pi is to the left
bkgdDirection = {[0:pi/4:2*pi],[0:pi/4:2*pi]};  % 0 is to the right. pi is to the left
dotColor = {[1 1 1 0.5],[1 1 1 0.5]};           % can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
bkgdDotColor = {[1 0 1 0.5],[1 0 1 0.5]};       % can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
dotSize = {[60],[60]};                          % Width of dots in pixels
bkgdSize = {[30],[30]};                         % Width in pixels
dotShape = {{'circle'},{'circle'}};             % 'circle' or 'rectangle'
bkgdShape = {{'square'},{'square'}};            % 'circle' or 'square'
renderMode = {'flat'};                          % {'flat'} or {'perspective',[renderDistances]}{'perspective',[1 5]}; 
renderDistance = NaN;                           % is 1 for flat and is a range for perspective
maxDuration = {inf, inf};                       % in seconds (inf is until response)
background = 0;                                 % black background
maxWidth=1920;
maxHeight=1080;
scaleFactor=0;
interTrialLuminance={.5,120};
doCombos = true;

AFCDOTS = afcCoherentDots(numDots,bkgdNumDots, dotCoherence,bkgdCoherence, dotSpeed,bkgdSpeed, dotDirection,bkgdDirection,...
               dotColor,bkgdDotColor, dotSize,bkgdSize, dotShape,bkgdShape, renderMode, maxDuration,background,...
               maxWidth,maxHeight,scaleFactor,interTrialLuminance, doCombos);

% training step using other objects as passed in
ts = trainingStep(trialManager, AFCDOTS, performanceCrit, sch, svnRev, svnCheckMode);