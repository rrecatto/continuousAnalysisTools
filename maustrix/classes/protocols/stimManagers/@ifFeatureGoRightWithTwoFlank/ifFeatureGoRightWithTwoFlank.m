function s=ifFeatureGoRightWithTwoFlank(varargin)
% ||ifFeatureGoRightWithTwoFlank||  class constructor.
%derived from cuedGoToFeatureWithTwoFlank
%function calls below are out of date; use getDefaultParameters; see setFlankerStimRewardAndTrialManager for signature
% s = ifFeatureGoRightWithTwoFlank([pixPerCycs],[goRightOrientations],[goLeftOrientations],[flankerOrientations],topYokedToBottomFlankerOrientation,topYokedToBottomFlankerContrast,[goRightContrast],[goLeftContrast],[flankerContrast],mean,cueLum,cueSize,xPositionPercent,cuePercentTargetEcc,stdGaussMask,flankerOffset,framesJustFlanker,framesTargetOn,thresh,yPositionPercent,toggleStim,typeOfLUT,rangeOfMonitorLinearized,maxCorrectOnSameSide,positionalHint,xPosNoise,yPosNoise,displayTargetAndDistractor,phase,persistFlankersDuringToggle,maxWidth,maxHeight,scaleFactor,interTrialLuminance,percentCorrectionTrials)
% s = ifFeatureGoRightWithTwoFlank([32],[pi/2],[pi/2],[0],1,1,[0.5],[0.5],[0.5],0.5,0,1,0.5,0,1/16,3,int8(8),int8(0),0.001,0.5,1,'useThisMonitorsUncorrectedGamma',[0 1],int8(-1),0,0,0,600,800,0,0.5)
% s = ifFeatureGoRightWithTwoFlank([32],[0],[pi/2],[0],1,1,[0.5],[0.5],[0.5],0.5,0,1,0.5,0,1/16,3,int8(8),int8(0),0.001,0.5,1,4,1280,1024,0,0.5)
%
% p=getDefaultParameters(ifFeatureGoRightWithTwoFlank,'goToRightDetection', '1_9','Oct.09,2007');
% sm=getStimManager(setFlankerStimRewardAndTrialManager(p, 'test'));
% [sm updateSM out scaleFactor type targetPorts distractorPorts details interTrialLuminance] = calcStim(sm,'nAFC',100,3,[1 1 1],1280,1024,[]);
% imagesc(out(:,:,1)); colormap(gray)

% pixPerCycs = 32;
% goRightOrientations = [pi/2];
% goLeftOrientations = [pi/2];
% flankerOrientations = [0,pi/2]; %choose a random orientation from this list
% %
% topYokedToBottomFlankerOrientation =1;
% topYokedToBottomFlankerContrast =1;
% %
% goRightContrast = [0.1,0.2,0.3];    %choose a random contrast from this list each trial
% goLeftContrast = [0];
% flankerContrast = [1];
% %
% mean = 0.5;              %normalized luminance
% cueLum=0;                %luminance of cue sqaure
% cueSize=1;               %roughly in pixel radii
% %
% xPositionPercent = 0.5;  %target position in percent ScreenWidth
% cuePercentTargetEcc=0.6; %fraction of distance from center to target  % NOT USED IN cuedGoToFeatureWithTwoFlank
% stdGaussMask =  3;       %in fraction of vertical height
% flankerOffset = 4;       %distance in stdGaussMask (3.5 just touches edge)
% %
% framesJustCue=int8(30);
% framesStimOn=int8(0);      %if 0, then leave stim on, which is a blank
% thresh = 0.001;
% yPositionPercent = 0.5;
%
%Might be missing some arguments
%here:toggleStim,typeOfLUT,rangeOfMonitorLinearized,maxCorrectOnSameSide,
%and more, see getDefaultParams, or setFlankerStimRewardAndTrialManager
% toggleStim = 1;
% typeOfLUT= 'useThisMonitorsUncorrectedGamma';
% rangeOfMonitorLinearized=[0 1];
% s.maxCorrectOnSameSide=-1;
%
% positionalHint=0.2;
% xPosNoise=0.1;%standard deviation of noise in fractional screen width
% yPosNoise=0;%standard deviation of noise in fractional screen height
% displayTargetAndDistractor = 0;
%
% orientations in radians , these a distributions of possible orientations
% mean, cueLum, cueSize, contrast, yPositionPercent, xPositionPercent normalized (0 <= value <= 1)
% stdGaussMask is the std dev of the enveloping gaussian, in normalized  units of the vertical height of the stimulus image
% thresh is in normalized luminance units, the value below which the stim should not appear
% cuePercentTargetEcc is an vestigal variable not used

switch nargin
    case 0
        % if no input arguments, create a default object

        s.pixPerCycs = [];
        s.goRightOrientations = [];
        s.goLeftOrientations = [];
        s.flankerOrientations = [];
        s.distractorOrientations = [];
        s.distractorFlankerOrientations = [];

        s.topYokedToBottomFlankerOrientation =1;
        s.topYokedToBottomFlankerContrast =1;

        s.goRightContrast = [];
        s.goLeftContrast = [];
        s.flankerContrast = [];

        s.mean = 0;
        s.cueLum=0;
        s.cueSize=1;

        s.xPositionPercent = 0;
        s.cuePercentTargetEcc = 0;
        s.stdGaussMask = 0;
        s.flankerOffset = 0;

        s.flankerOnOff=8;
        s.targetOnOff=0;
        s.thresh = 0;
        s.targetYPosPct = 0;
        s.toggleStim = 0;
        s.typeOfLUT = [];
        s.rangeOfMonitorLinearized=[];
        s.maxCorrectOnSameSide=-1;

        %ADD THESE!
        s.positionalHint=0; %fraction of screen hinted.
        s.xPosNoise=0; %
        s.yPosNoise=0; %

        %%%%%%%%%%%%% NEW VARIABLES CREATED TO SET DISTRACTORS MIRRORED FROM
        %%%%%%%%%%%%% TARGET AND FLANKERS %%%%%%%%%%%%%%%%%%%%% Y.Z
        s.displayTargetAndDistractor=0;
        s.phase=0;
        s.persistFlankersDuringToggle=[];

        s.distractorFlankerYokedToTargetFlanker = 1;
        s.distractorContrast = 0;
        s.distractorFlankerContrast = 0;
        s.distractorYokedToTarget=1;

        s.flankerYokedToTargetPhase =0;
        s.fractionNoFlanks=[];
        %%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%


        s.shapedParameter=[];
        s.shapingMethod=[];
        s.shapingValues=[];

        s.gratingType='square';


        s.framesMotionDelay = [];
        s.numMotionStimFrames = [];
        s.framesPerMotionStim = [];

        s.protocolType=[];
        s.protocolVersion=[];
        s.protocolSettings = [];

        s.flankerPosAngle = [];
        s.percentCorrectionTrials = [];

        s.fpaRelativeTargetOrientation=[];
        s.fpaRelativeFlankerOrientation=[];

        s.blocking=[];
        s.fitRF=[];
        s.dynamicSweep=[];
        
        s.renderMode=[];
        
        s.dynamicFlicker=[];
        
        s.stdsPerPatch=0;

        %start deflated
        s.cache.mask =[];
        s.cache.goRightStim=[];
        s.cache.goLeftStim=[];
        s.cache.flankerStim=[];
        s.cache.distractorStim = [];
        s.cache.distractorFlankerStim= [];

        s.LUT=[];
        

        %     s.goRightStim =zeros(2,2,1);
        %     s.goLeftStim = zeros(2,2,1);
        %     s.flankerStim =zeros(2,2,1);

        s = class(s,'ifFeatureGoRightWithTwoFlank',stimManager());

    case 1
        % if single argument of this class type, return it
        switch class(varargin{1})
            case 'ifFeatureGoRightWithTwoFlank'
                s = varargin{1};
            case 'char'
                p=getDefaultParameters(ifFeatureGoRightWithTwoFlank);
                p.mean=0.5;
                switch varargin{1}
                    case 'def'
                        %do nothing
                    case 'basic'
                         p.flankerOffset=3;
                         p.flankerContrast=1;
                         p.stdGaussMask=1/16;
                         p.pixPerCycs=32;
                         p.phase=0;     
                    case {'sevenLocs','sevenLocsFast'}
                        p.flankerContrast=0;
                        p.goLeftContrast=1;
                        p.goRightContrast=1;
                        p.stdGaussMask=1/16;
                        p.pixPerCycs=32;
                        if strcmp(varargin{1},'sevenLocsFast')
                            p.targetOnOff=int32([100 120]);
                            p.flankerOnOff=int32([100 120]);
                        else
                            p.targetOnOff=int32([100 150]);
                            p.flankerOnOff=int32([100 150]);
                        end
                        p.renderMode='dynamic-precachedInsertion'; % dynamic-maskTimesGrating, dynamic-onePatchPerPhase,or dynamic-onePatch
                        
                        numLocs=7;
                        vals=linspace(0,1,numLocs+2);
                        vals=vals(2:end-1);

                        p.dynamicSweep.sweepMode={'random',1};
                        p.dynamicSweep.sweptValues=[vals];
                        p.dynamicSweep.sweptParameters={'xPositionPercent'};
                        p.dynamicSweep.numRepeats=4;
                        
                        %p.typeOfLUT='2009Trinitron255GrayBoxInterpBkgnd.5';
                        p.typeOfLUT= 'useThisMonitorsUncorrectedGamma';        
                    case {'phys','configPhys','contrastPhys','contrastPhysOnePhase','flankersMatterPhys'...
                        'flankerMattersOnePhase','physFullFieldTarget','physFullFieldContrast'}

                        p.flankerContrast=1;
                        p.goLeftContrast=1;
                        p.goRightContrast=1;
                        p.stdGaussMask=1/16;
                        p.stdGaussMask=1/8;
                        p.pixPerCycs=32;
                        %p.pixPerCycs=128; %768
                        %p.pixPerCycs=180; %768
                        
                        ;
                                                
                        %                         p.targetOnOff=int32([40 60]);
                        %                          p.flankerOnOff=int32([40 60]);
                        p.targetOnOff=int32([200 220]);
                        p.flankerOnOff=int32([200 220]);
                        p.flankerOffset=3;
                        
                        
                        p.goRightOrientations = [pi/12];
                        p.goLeftOrientations =  [pi/12];
                        p.flankerOrientations = [pi/12];
                        p.flankerPosAngle = [pi/12];

                        %temp
                        p.stdGaussMask=1/4;
                        p.pixPerCycs=64
                        p.pixPerCycs=128
                        
                        
                        %p.showText=false;
                        locationMode=3;
                        switch locationMode
                            case 1
                                RFdataSource='\\132.239.158.169\datanet_storage';
                                p.fitRF = RFestimator({'spatialWhiteNoise','fitGaussian',{1}},{'spatialWhiteNoise','fitGaussian',{1}},[],RFdataSource,[now-100 Inf]);
                            case 2 %ERRORS >> NEEDS FIXING
                                RFdataSource='\\132.239.158.169\datanet_storage'; % not actually used for lastDynamicSettings
                                p.fitRF = RFestimator({'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},{'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},[],RFdataSource,[now-100 Inf]);
                            otherwise
                                p.xPositionPercent=.6;% 5/12; %0.3;
                                p.yPositionPercent=.45; %5/8; %0.7;
                                p.xPositionPercent=5/9;
                                p.yPositionPercent=3/7; 
                                p.stdGaussMask=1/10;
                                p.fitRF=[];
                        end
                        
                        %p.goLeftOrientations=p.goLeftOrientations(1);
                        %p.goRightOrientations=p.goRightOrientations(1);
                        %p.flankerOrientations=p.flankerOrientations(1);
                        %p.flankerPosAngle=p.flankerPosAngle(1);
                        
                        p.phase=[pi]*[0 0.5 1 1.5];                       
                        p.renderMode='dynamic-precachedInsertion'; % dynamic-maskTimesGrating, dynamic-onePatchPerPhase,or dynamic-onePatch
                        
                        %p.dynamicSweep.sweepMode={'ordered'};
                        p.dynamicSweep.sweepMode={'random','clock'}; % repeats on a trial are the same, but across trials will be different
                        p.dynamicSweep.sweptValues=[];
                        p.typeOfLUT='2009Trinitron255GrayBoxInterpBkgnd.5';
                        p.typeOfLUT= 'useThisMonitorsUncorrectedGamma';
                        p.rangeOfMonitorLinearized=[0.0 1];
                                                        
                        if strcmp(varargin{1},'phys')
                            kind='contrastPhysOnePhase'; % the default
                        else
                            kind=varargin{1};
                        end
                        
                        switch kind
                            case 'configPhys'
                                %do nothing
                                p.dynamicSweep.sweptParameters={'targetOrientations','flankerOrientations','flankerPosAngle'};% 'flankerOffset'
                                p.dynamicSweep.numRepeats=8;
                            case 'contrastPhys'
                                p.flankerContrast=[0 .25 .5 .75 1];
                                p.goLeftContrast=[0 .25 .5 .75 1];
                                p.goRightContrast=[0 .25 .5 .75 1];
                                p.dynamicSweep.numRepeats=1;

                                p.dynamicSweep.sweptParameters={'targetContrast','flankerContrast','phase'};% 'flankerOrientations'}%,'flankerOffset','flankerPosAngle'};

                            case 'contrastPhysOnePhase'

                                p.flankerContrast=[0 .25 .5 .75 1];
                                p.goLeftContrast=[0 .25 .5 .75 1];
                                p.goRightContrast=[0 .25 .5 .75 1];
                                p.dynamicSweep.numRepeats=6;

                                p.phase=0;% pi/2;
                                p.dynamicSweep.sweptParameters={'targetContrast','flankerContrast'};% 'flankerOrientations'}%,'flankerOffset','flankerPosAngle'};  
                            case 'flankersMatterPhys'
                                p.flankerContrast=[0 1];
                                p.goLeftContrast=[0 1];
                                p.goRightContrast=[0 1];
                                p.dynamicSweep.numRepeats=20;
                                p.dynamicSweep.sweptParameters={'targetContrast','flankerContrast','phase'};% 'flankerOrientations'}%,'flankerOffset','flankerPosAngle'};
                            case 'flankerMattersOnePhase'
                                p.flankerContrast=[0 1];
                                p.goLeftContrast=[0 1];
                                p.goRightContrast=[0 1];
                                p.dynamicSweep.numRepeats=40;  
                                p.phase=pi/2; %choose a good one
                                p.dynamicSweep.sweptParameters={'targetContrast','flankerContrast','phase'};% 'flankerOrientations'}%,'flankerOffset','flankerPosAngle'};  

                            case  'physFullFieldTarget'
                                p.stdGaussMask=Inf;
                                p.flankerContrast=0;
                                p.targetOnOff=int32([40 60]);
                                p.flankerOnOff=int32([40 60]);
                                p.dynamicSweep.sweptParameters={'phase'};
                                p.dynamicSweep.numRepeats=40;
                                p.xPositionPercent=.5;
                                p.yPositionPercent=.5;
                            case 'physFullFieldContrast'
                                p.stdGaussMask=Inf;
                                p.flankerContrast=0;
                                p.targetOnOff=int32([40 60]);
                                p.flankerOnOff=int32([40 60]);
                                
                                %  p.targetOnOff=int32([200 220]);
                                %  p.flankerOnOff=int32([200 220]);
                                
                                p.xPositionPercent=.5;
                                p.yPositionPercent=.5;

                                p.goLeftContrast=[0 .25 .5 .75 1];
                                p.goRightContrast=[0 .25 .5 .75 1];
                                p.dynamicSweep.numRepeats=4;
                                p.dynamicSweep.sweptParameters={'targetContrast','phase'};% 'flankerOrientations'}%,'flankerOffset','flankerPosAngle'};    
                        end
                    case {'horizontalVerticalCalib','horizontalVerticalSFCalib','calibFlankerLocationOrientation','calibFlankerPresence'}
                        %calib stims
                        p.goLeftContrast=1;
                        p.goRightContrast=1;
                        p.pixPerCycs=32; 
                        p.targetOnOff=int32([20 300]);
                        p.flankerOnOff=int32([20 300]);
                        p.targetOnOff=int32([10 80]);
                        p.flankerOnOff=int32([10 80]);
                        
                        ors=[0 pi/2]; %[-pi/12 pi/12]; %
                        p.goRightOrientations = ors;
                        p.goLeftOrientations =  ors;
                        p.flankerOrientations =  ors;
                        
                        switch varargin{1}
                            case {'horizontalVerticalCalib','horizontalVerticalSFCalib'}
                                p.flankerContrast=0;
                                p.stdGaussMask=1/8;
                                numPhases=16;
                                temp=linspace(0,pi*2,numPhases+1)
                                p.phase=temp(1:end-1);
                                p.dynamicSweep.sweptParameters={'targetOrientations','phase'};
                                
                                if strcmp(varargin{1},'horizontalVerticalSFCalib')
                                    p.blocking.blockingMethod='nTrials';
                                    p.blocking.nTrials=1;
                                    p.blocking.shuffleOrderEachBlock=false;
                                    p.blocking.sweptParameters={'pixPerCycs'};
                                    p.pixPerCycs=2.^[2:8]; 
                                    p.blocking.sweptValues=p.pixPerCycs;
                                end
                            case 'calibFlankerLocationOrientation'
                                p.flankerContrast=1;
                                p.flankerPosAngle=p.goRightOrientations;
                                p.stdGaussMask=1/16;
                                p.phase=0;
                                p.flankerOffset=3;
                                p.dynamicSweep.sweptParameters={'targetOrientations','flankerOrientations','flankerPosAngle'};% 'flankerOffset'
                            case 'calibFlankerPresence'
                                p.flankerContrast=[0 1];
                                p.flankerPosAngle=p.goRightOrientations;
                                p.stdGaussMask=1/16;
                                p.phase=0;
                                p.flankerOffset=3;
                                p.dynamicSweep.sweptParameters={'flankerContrast','flankerOrientations','flankerPosAngle'};% 
                        end
                        
                        p.gratingType='sine';
                        p.maxWidth=800;
                        p.maxHeight=600;
                        p.showText=false;
                        locationMode=3;
                        switch locationMode
                            case 1
                                RFdataSource='\\132.239.158.169\datanet_storage';
                                p.fitRF = RFestimator({'spatialWhiteNoise','fitGaussian',{1}},{'spatialWhiteNoise','fitGaussian',{1}},[],RFdataSource,[now-100 Inf]);
                            case 2
                                RFdataSource='\\132.239.158.169\datanet_storage'; % not actually used for lastDynamicSettings
                                p.fitRF = RFestimator({'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},{'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},[],RFdataSource,[now-100 Inf]);
                            otherwise
                                p.xPositionPercent=.5;
                                p.yPositionPercent=.5; 
                                p.fitRF=[];
                        end
                        
                 
                        p.renderMode='dynamic-precachedInsertion'; % dynamic-maskTimesGrating, dynamic-onePatchPerPhase,or dynamic-onePatch
                        p.dynamicSweep.sweepMode={'ordered'};
                        p.dynamicSweep.sweptValues=[];
                        p.dynamicSweep.numRepeats=6;
                        p.typeOfLUT='2009Trinitron255GrayBoxInterpBkgnd.5';
                        p.typeOfLUT= 'useThisMonitorsUncorrectedGamma';

                    case 'testFlicker'
                        
                       %save space for the memory problem of making all the tex's
                        %p.goLeftOrientations=p.goLeftOrientations(1);
                        %p.goRightOrientations=p.goRightOrientations(1);
                        %p.flankerOrientations=p.flankerOrientations(1);
                        
                        %p.stdGaussMask=Inf;
                        p.stdGaussMask=1/16;
                        p.flankerOffset=3;
                        
                        p.flankerContrast=0;
                        p.goLeftContrast=1;
                        p.goRightContrast=1;
                        p.pixPerCycs=32;
                        p.targetOnOff=int32([300 340]);
                        p.flankerOnOff=int32([1 340]);
                        p.renderMode='dynamic-precachedInsertion'; % dynamic-maskTimesGrating, dynamic-onePatchPerPhase,or dynamic-onePatch
                        
                        p.dynamicSweep.sweepMode={'ordered'};
                        p.dynamicSweep.sweptValues=[];
                        p.dynamicSweep.sweptParameters={'targetOrientations'};
                        p.dynamicSweep.numRepeats=20;
                        
                        p.phase=0;%2*pi*[1:8]/8;   
                        
                        %example setup
                        p.dynamicFlicker.flickerMode='random';
                        p.dynamicFlicker.flickeringParameters={'flankerContrast','phase'};
                        p.dynamicFlicker.flickeringValues{1}=[0 0 0 0 0 0 0 0 0 0 0 0 0.2];
                        p.dynamicFlicker.flickeringValues{2}=p.phase;
                        p.dynamicFlicker.framesSavedBeforeAfter=[300 100];
                        
                        
                    case '10'
                        p.renderMode='ratrixGeneral-precachedInsertion';
                    otherwise
                        varargin{1}
                        error('Single input argument is bad')
                end
                 s=getStimManager(setFlankerStimRewardAndTrialManager(p));
            otherwise
                class(varargin{1})
                error('Single input argument is bad')
        end
    case 61
        % create object using specified values

        if all(varargin{1})>0
            s.pixPerCycs=varargin{1};
        else
            error('pixPerCycs must all be > 0')
        end

        if all(isnumeric(varargin{2})) && all(isnumeric(varargin{3})) && all(isnumeric(varargin{4})) && all(isnumeric(varargin{32})) && all(isnumeric(varargin{33}))
            s.goRightOrientations=varargin{2};
            s.goLeftOrientations=varargin{3};
            s.flankerOrientations=varargin{4};
            s.distractorOrientations=varargin{32};
            s.distractorFlankerOrientations=varargin{33};
        else
            varargin{2}
            varargin{3}
            varargin{4}
            varargin{32}
            varargin{33}
            error('target, distractor and flanker orientations must be numbers')
        end

        if varargin{5}==1 %|| varargin{5}==0
            s.topYokedToBottomFlankerOrientation=varargin{5};
        else
            error('topYokedToBottomFlankerOrientation must be 1')
        end

        if varargin{6}==1 %|| varargin{6}==0
            s.topYokedToBottomFlankerContrast=varargin{6};
        else
            error('topYokedToBottomFlankerContrast must be 1')
        end

        if all(varargin{7} >= 0 & varargin{7}<=1)
            s.goRightContrast=varargin{7};
        else
            error('0 <= all goRightContrasts <= 1')
        end

        if all(varargin{8} >= 0 & varargin{8}<=1)
            s.goLeftContrast=varargin{8};
        else
            error('0 <= all goLeftContrast <= 1')
        end

        if all(varargin{9} >= 0 & varargin{9}<=1)
            s.flankerContrast=varargin{9};
        else
            error('0 <= all flankerContrast <= 1')
        end

        if varargin{10} >= 0 && varargin{10}<=1
            s.mean=varargin{10};
        else
            error('0 <= mean <= 1')
        end

        if (varargin{11} >= 0 & varargin{11}<=1) | isempty(varargin{11})
            s.cueLum=varargin{11};
        else
            error('0 <= cueLum <= 1')
        end

        if varargin{12} >= 0 && varargin{12}<=10
            s.cueSize=varargin{12};
        else
            error('0 <= cueSize <= 10')
        end

        if varargin{13} >= 0 && varargin{13}<=1
            s.xPositionPercent=varargin{13};
        else
            error('0 <= xPositionPercent <= 1')
        end

        if varargin{14} >= 0 && varargin{14}<=1
            s.cuePercentTargetEcc=varargin{14};
        else
            error('0 <= cuePercentTargetEcc <= 1')
        end

        if varargin{15} >= 0
            s.stdGaussMask=varargin{15};
        else
            error('0 <= stdGaussMask')
        end

        if varargin{16} >= 0
            s.flankerOffset=varargin{16}; % also check to see if on screen... need stim.screenHeight
        else
            error('0 <= flankerOffset < something with a center that fits on the screen')
        end

        if all(varargin{17} > 0) && isinteger(varargin{17}) && size(varargin{17},2)==2 && varargin{17}(1)<varargin{17}(2)
            s.flankerOnOff=varargin{17};
        else
            error('0 <= flankerOnOff; must be two increasing integers...this will become framesFlankerOnOff')
        end

        if all(varargin{18} > 0) && isinteger(varargin{18}) && size(varargin{18},2)==2 && varargin{18}(1)<varargin{18}(2)
            s.targetOnOff=varargin{18};
        else
            error('0 <= targetOnOff; must be two increasing integers...this will become framesTargetOnOff')
        end


        if varargin{19} >= 0
            s.thresh=varargin{19};
        else
            error('thresh must be >= 0')
        end

        if isnumeric(varargin{20}) && varargin{20} >= 0 && varargin{20}<=1
            s.targetYPosPct=varargin{20};
        else
            error('yPositionPercent must be numeric')
        end

        if (isnumeric(varargin{21}) && (varargin{21}==1 || varargin{21}==1)) || islogical(varargin{21})
            s.toggleStim=varargin{21};
        else
            error('toggleStim must be logical')
        end

        if any(strcmp(varargin{22},{'linearizedDefault','useThisMonitorsUncorrectedGamma','mostRecentLinearized','2009Trinitron255GrayBoxInterpBkgnd.5'}))
            s.typeOfLUT=varargin{22};
        else
            error('typeOfLUT must be linearizedDefault, useThisMonitorsUncorrectedGamma, or mostRecentLinearized')
        end

        if 0<=varargin{23}& varargin{23}<=1 & size(varargin{23},1)==1 & size(varargin{23},2)==2
            s.rangeOfMonitorLinearized=varargin{23};
        else
            error('rangeOfMonitorLinearized must be greater than or =0 and less than or =1')
        end

        if (0<varargin{24}| varargin{24}==-1 )& isinteger(varargin{24})
            s.maxCorrectOnSameSide=varargin{24};
        else
            error('maxCorrectOnSameSide must be an integer greater than 0, or be equal to -1 in order to not limit at all')
        end

        if 0<=varargin{25}& varargin{25}<=1
            s.positionalHint=varargin{25};
        else
            error('positionalHint must be greater than 0, and less than 1')
        end

        if 0<=varargin{26}
            s.xPosNoise=varargin{26};
        else
            error('xPosNoise must be greater than 0')
        end

        if 0<=varargin{27}
            s.yPosNoise=varargin{27};
        else
            error('yPosNoise must be greater than 0')
        end

        if 0==varargin{28}|1==varargin{28};
            s.displayTargetAndDistractor=varargin{28};
        else
            error('displayTargetAndDistractor must be 0 or 1')
        end

        if all(0<=varargin{29}) & all(2*pi>=varargin{29});
            s.phase=varargin{29}; %Phase can now be randomized 07/10/04 pmm
        else
            error('all phases must be >=0 and <=2*pi')
        end

        if (0==varargin{30}) | (1==varargin{30});
            s.persistFlankersDuringToggle=varargin{30};
        else
            error('persistFlankersDuringToggle must be 0 or 1')
        end

        if (0==varargin{31}) | (1==varargin{31});
            s.distractorFlankerYokedToTargetFlanker=varargin{31};
        else
            error('distractorFlankerYokedToTargetFlanker must be 0 or 1')
        end

        %see the other orientations
        %s.distractorOrientations = 0; %32
        %s.distractorFlankerOrientations = 0; %33

        if all(varargin{34} >= 0 & varargin{34}<=1)
            s.distractorContrast=varargin{34};
        else
            error('0 <= all distractorContrast <= 1')
        end

        if all(varargin{35} >= 0 & varargin{35}<=1)
            s.distractorFlankerContrast=varargin{35};
        else
            error('0 <= all distractorFlankerContrast <= 1')
        end

        if (0==varargin{36}) | (1==varargin{36});
            s.distractorYokedToTarget=varargin{36};
        else
            error('distractorYokedToTarget must be 0 or 1')
        end

        if (0==varargin{37}) | (1==varargin{37});
            s.flankerYokedToTargetPhase=varargin{37};
        else
            error('flankerYokedToTargetPhase must be 0 or 1')
        end

        if all(varargin{38} >= 0 & varargin{38}<=1)
            s.fractionNoFlanks=varargin{38};
        else
            error('0 <= all fractionNoFlanks <= 1')
        end

        if (isempty(varargin{39}) | any(strcmp(varargin{39},{'positionalHint', 'stdGaussMask','targetContrast','flankerContrast','xPosNoise'})))
            s.shapedParameter=varargin{39};
        else
            error ('shapedParameter must be positionalHint or stdGaussianMask or targetContrast or flankerContrast or xPosNoise')
        end

        if (isempty(varargin{40}) | any(strcmp(varargin{40},{'exponentialParameterAtConstantPerformance', 'geometricRatioAtCriteria','linearChangeAtCriteria'})))
            s.shapingMethod=varargin{40};
        else
            error ('shapingMethod must be exponentialParameterAtConstantPerformance or geometricRatioAtCriteria or linearChangeAtCriteria')
        end

        if isempty(s.shapingMethod)
            s.shapingValues=[];
        else %only check values if a method is selected
            if (checkShapingValues(ifFeatureGoRightWithTwoFlank(),s.shapingMethod,varargin{41}))
                s.shapingValues=varargin{41};
            else
                error ('wrong fields in shapingValues')
            end
        end

        if  any(strcmp(varargin{42},{'square', 'sine'}))
            s.gratingType=varargin{42};
        else
            error('waveform must be square or sine')
        end

        if  isnumeric(varargin{43}) && length(varargin{43})==1
            s.framesMotionDelay=floor(varargin{43});
        else
            error('framesMotionDelay must be a single number')
        end

        if  isnumeric(varargin{44}) && length(varargin{44})==1
            s.numMotionStimFrames=floor(varargin{44});
        else
            error('numMotionStimFrames must be a single number')
        end

        if  isnumeric(varargin{45}) && length(varargin{45})==1
            s.framesPerMotionStim=floor(varargin{45});
        else
            error('framesPerMotionStim must be a single number')
        end

        if  any(strcmp(varargin{46},{'goToRightDetection', 'goToLeftDetection','tiltDiscrim','goToSide','goNoGo','cuedGoNoGo'}))
            s.protocolType=varargin{46};
        else
            varargin{46}
            error('protocolType must be goToRightDetection or goToLeftDetection or tiltDiscrim or goToSide')
        end

        if  any(strcmp(varargin{47},{'1_0','1_1','1_2','1_3','1_4','1_5','1_6','1_7','1_8','1_9','2_0','2_1','2_2','2_3','2_3reduced','2_4', '2_5validate','2_5','2_6','2_6validate','2_6special'}))
            s.protocolVersion=varargin{47};
        else
            varargin{47}
            error('protocolVersion must be very specific')
        end

        if  any(strcmp(varargin{48},{'Oct.09,2007','Apr.13,2009','May.02,2009','Dec.11,2009'}))
            s.protocolSettings=varargin{48};
        else
            error('protocolSettings must be very specific string')
        end

        if  isnumeric(varargin{49}) && all(size(varargin{49},1)==1)
            s.flankerPosAngle=varargin{49};
        else
            error('flankerPosAngle must be a numeric vector, for now size 1, maybe matrix one day')
        end


        if  varargin{50} >= 0 && varargin{50}<=1 && all(size(varargin{50})==1)
            s.percentCorrectionTrials=varargin{50};
        else
            error('percentCorrectionTrials must be a single numer between 0 and 1')
        end

        if  isnan(varargin{51}) | (isnumeric(varargin{51}) && size(varargin{51},1)==1)

            if ~isnan(varargin{51})
                %error check that the right targets are there
                relatives=varargin{51};
                fpas=s.flankerPosAngle;
                required=repmat(relatives,size(fpas,2),1)-repmat(fpas',1,size(relatives,2));
                if all(ismember(required(:),s.goRightOrientations)) && all(ismember(required(:),s.goLeftOrientations));
                    %good
                else
                    unique(required(:))
                    s.goRightOrientations
                    s.goLeftOrientations
                    error('both goLeft and goRight must have target orientations required for this fpaRelativeTargetOrientation' )
                end
            end
            s.fpaRelativeTargetOrientation=varargin{51};
        else
            error('fpaRelativeTargetOrientation must be a vectors of numbers or NaN')
        end

        if  isnan(varargin{52}) | (isnumeric(varargin{52}) && size(varargin{52},1)==1)

            if ~isnan(varargin{52})
                %error check that the right flankers are there
                relatives=varargin{52};
                fpas=s.flankerPosAngle;
                required=repmat(relatives,size(fpas,2),1)-repmat(fpas',1,size(relatives,2));
                if all(ismember(required(:),s.flankerOrientations))
                    %good
                else
                    unique(required(:))
                    s.flankerOrientations
                    error('flankerOrientations must have flanker orientations required for this fpaRelativeFlankerOrientation' )
                end
            end
            s.fpaRelativeFlankerOrientation=varargin{52};

        else
            error('fpaRelativeTargetOrientation must be a vectors of numbers or NaN')
        end

        if (checkBlocking(ifFeatureGoRightWithTwoFlank(),varargin{53}))
            s.blocking=varargin{53};
        else
            error ('wrong fields in blocking')
        end

        if isa(varargin{54},'RFestimator') || isempty(varargin{54})%(checkFitRF(ifFeatureGoRightWithTwoFlank(),varargin{54}))
            s.fitRF=varargin{54};
        else
            error ('fitRF must be an RFestimator object or empty')
        end

        if (checkDynamicSweep(ifFeatureGoRightWithTwoFlank(),varargin{55}))
            s.dynamicSweep=varargin{55};
        else
            error ('wrong fields in dynamicSweep')
        end

        if  any(strcmp(varargin{56},{'ratrixGeneral-maskTimesGrating', 'ratrixGeneral-precachedInsertion','dynamic-precachedInsertion','dynamic-maskTimesGrating','dynamic-onePatchPerPhase','dynamic-onePatch'}))
            s.renderMode=varargin{56};   
        else
            error('renderMode must be ratrixGeneral-maskTimesGrating, ratrixGeneral-precachedInsertion,dynamic-precachedInsertion, dynamic-maskTimesGrating, dynamic-onePatchPerPhase,or dynamic-onePatch')
        end
        
        if (checkDynamicFlicker(ifFeatureGoRightWithTwoFlank(),varargin{57}))
            s.dynamicFlicker=varargin{57};
        else
            error ('wrong fields in dynamicFlicker')
        end
        
        %s.phase=0; %no longer randomized;   would need movie for that (hieght x width x orientations x phase)
        %maxHeight=varargin{22**old val};

        %determine gabor window size within patch here
        if ~isinf(s.stdGaussMask)
            s.stdsPerPatch=4; %this is an even number that is very reasonable fill of square
        else
            s.stdsPerPatch=0;  % will create infinite radius  
        end
        
        %start deflated
        s.cache.mask =[];
        s.cache.goRightStim=[];
        s.cache.goLeftStim=[];
        s.cache.flankerStim=[];
        s.cache.distractorStim = [];
        s.cache.distractorFlankerStim= [];

        s.LUT=[];

        %error checks
        if ~isempty(s.blocking) && (any(~isnan(s.fpaRelativeFlankerOrientation)) || any(~isnan(s.fpaRelativeTargetOrientation)))
            frfo=s.fpaRelativeFlankerOrientation
            frto=s.fpaRelativeTargetOrientation
            s.blocking
            warning('blocking interferes with fpa relative methods')
            %maybe make sure relative value is being blockwd
        end

        firstSuper=nargin-3;
        s = class(s,'ifFeatureGoRightWithTwoFlank',stimManager(varargin{firstSuper},varargin{firstSuper+1},varargin{firstSuper+2},varargin{firstSuper+3}));

        %s=inflate(s);
        %s=deflate(s);
        %s=inflate(s);
        if ~strcmp(s.typeOfLUT, 'useThisMonitorsUncorrectedGamma')
            disp(sprintf('at start up will be linearizing monitor in range from %s to %s', num2str(s.rangeOfMonitorLinearized(1)), num2str(s.rangeOfMonitorLinearized(2))))
        end
        %s=fillLUT(s,s.typeOfLUT,s.rangeOfMonitorLinearized,0);


    otherwise
        nargin
        size(nargin)
        error('Wrong number of input arguments')
end

% s=setSuper(s,s.stimManager);


