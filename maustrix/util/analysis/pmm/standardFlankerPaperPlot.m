function done=standardFlankerPaperPlot(figID,subjects,dateRange)

done=0;
close all;

if ~exist('figID','var') || isempty(figID)
    figID=[ 2 3 4 6]; % 6
    figID=[5];  % test one of them
    figID=[4 9];  % test one of them
    %figID=[2 4 5 7];  % sup fig ROC d' vs pct correct
    figID=[1];  % test one of them
end

if ~exist('dateRange','var')
    dateRange=[0 pmmEvent('endToggle')];
end

if ~exist('statTypes','var')
    statTypes={'pctCorrect','CRs','FAs','hits','dpr','yes','crit','dprimeMCMC','criterionMCMC'}; % full, requires WINBUGs to be installed... try without MCMC if you need to
    statTypes={'pctCorrect','CRs','FAs','hits','dpr','yes','crit'}; % faster, but no error bars on dprim stats
    %statTypes={'pctCorrect','CRs','FAs','hits','dpr','yes','crit','pctCorrectMCMC'}; % try's the MCMC : confirm: 1) rank order of subjects, 2)which comparison, 3) MCMC params
end

if ~exist('subjects','var')
    %subjects={'228','227','230','233','234','138','139'}; %OLD: sorted for amount
    subjects={'228','227','230','233','234','139','138'}; %puts high-lighted rat (end) on the top
    %subjects={'138','228','230','233'}; % quick for testing, passes lillie-test
    %subjects={'138','228'}; % quick for testing
    %subjects={'234','227','138'}; % quick for testing
end

if ~exist('savePath','var')
    savePath='C:\Documents and Settings\rlab\Desktop\graphs';
    %savePath='L:\Rodent-Data\pmeier\flankerSupport\activeFigures';
    %resolution=300;  % only applies to -dformat
    %figureType= {'png','jpg','bmp','fig','-dpsc','-depsc2','-dtiffn'} %
    %compare many
    %renderer= {'-painters','-zbuffer','-opengl'}  % compare many
    figureType={'-dtiffn','png'};  renderer= {'-opengl'}; resolution=1200; % paper print quality
    %figureType={'png'};  renderer= {'-zbuffer'}; resolution=300; % draft quality
    %figureType={'bmp','fig'}  % as matlab fig looks on screen
end


if ~exist('includeTitles','var')
    includeTitles=false;
end

if ~exist('numShuffle','var')
    numShuffle=0; %1000;
end


allFigID=figID;  % before removing them for processing loop

if any(ismember(figID,1))
    doFig1=true;
    figID(figID==1)=[]; %remove it from the standard list
else
    doFig1=false;
end

if any(ismember(figID,6))
    addFig6=true;
    figID(figID==6)=[]; %remove it from the standard list
else
    addFig6=false;
end

if any(ismember(figID,7))
    addFig7=true;
    figID(figID==7)=[]; %remove it from the standard list
else
    addFig7=false;
end

if any(ismember(figID,8))
    addFig8=true;
    figID(figID==8)=[]; %remove it from the standard list
else
    addFig8=false;
end

if any(ismember(figID,9))
    addFig9=true;
    figID(figID==9)=[]; %remove it from the standard list
else
    addFig9=false;
end


includeModel=0; % this used to add the model at the front, now only 2 figs add it specially
addBarIms=1;  % when false uses fll ims as a fig
addSingleRatPerformance=1;



if doFig1
    %% timeline
    subject='234'
    LearningDateRange=[datenum('21-Jun-2008') datenum('19-Oct-2008')]
    figure(1)
    
    ratrixAxis=subplot(3,2,1)
    ratrixIm= imread('\\reinagel-lab.ad.ucsd.edu\rlab\Rodent-Data\pmeier\flankerSupport\ratrixModuleImage\Ratrix-chamber-zip.tif');
    image(ratrixIm);
    set(gca,'Visible','off','box','off');  %set(gca,'Visible','on','box','on')
  
    modelAxis=subplot(3,2,2)
    modelIm=imread('L:\Rodent-Data\pmeier\flankerSupport\ppt figures in progress\TIFF_models5\modelsAlone5-simple.tif');
    image(modelIm(:,100:500,1:3));
    set(gca,'Visible','off','box','off');  %set(gca,'Visible','on','box','on')
    set(gca,'Visible','off','box','off');  %set(gca,'Visible','on','box','on')
    %set(modelAxis,'OuterPosition',[0.7 0.6 0.2 0.4 ])
        
    performanceAxis=subplot(3,1,2);
    d=getSmalls(subject)
    d=removeSomeSmalls(d,~ismember(d.step,[5 6 7 8 9]))
    %d=removeSomeSmalls(d,d.currentShapedValue >0.32)
    d=removeSomeSmalls(d,d.trialNumber >30000) % don't show all the collection data.. takes up to much space
    d.step(d.currentShapedValue==0.4)=10;  % plot 9.4 as step 10, cuz thats what we call the data collection regime
    d=removeSomeSmalls(d,d.trialNumber >29800) %cleaner high value for num good trials
        %min(d.trialNumber(d.currentShapedValue>0.29 & d.currentShapedValue<0.31) %19963
    d=removeSomeSmalls(d,d.currentShapedValue<0.29 & d.trialNumber>20000);  %this presrves the first 0.2's which go to 19962,  remove reset hiccup data.  i think this is fair
    dayBoundary=false;
    d=rmfield(d,'currentShapedValue');  % ... turns off his plotting
    doPlotPercentCorrect(d,[],200,0,[],[],dayBoundary,true,0,0,0,0)
    set(gca,'YTick',[0.34,0.5 0.75 1])
    set(gca,'YTickLabel',{'step:','50%','75%','100%'})
    steps=unique(d.step);
    nearestTrialNumberForGraduationMark=100; %100 or 1000 or 5000
    for i=1:length(steps)
        firstTrialPerStep(i)=min(find(d.step==steps(i)))
        roundedTrialNumber(i)=round(firstTrialPerStep(i)/nearestTrialNumberForGraduationMark)*nearestTrialNumberForGraduationMark;
        dayPerStep(i)=floor(d.date(firstTrialPerStep(i))-d.date(1));
    end
    plot(get(gca,'XLim'),[.5 .5],'color',[.8 .8 .8]) % chance line
    totalTrialNumber=floor(length(d.date)/nearestTrialNumberForGraduationMark)*nearestTrialNumberForGraduationMark;
    xTick=[roundedTrialNumber([1 2]) totalTrialNumber]
    set(gca,'XTick',xTick)
    set(gca,'XTickLabel',xTick)
    ylabel('% correct')
    totalDays=floor(d.date(end)-d.date(1));
    xlabel(sprintf('trial # (over %d days)',totalDays))
    if includeTitles;  title('training performance'); end
    stimuliAxis=subplot(3,1,3);
    sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast','mean','stdGaussMask','flankerOffset','pixPerCycs'}; % why does contrast have to be last?
    or=(pi/12);
    sweptImageValues={or,or,or,1,0,0.2,1/5,0,64;...
        or,or,or,0.6,0,0.5,1/5 ,0,64;...  0.6 target contrast is used to render close perception of linearized contrast
        or,or,or,0.6,0,0.5,1/5 ,0,32;...
        or,or,or,0.6,0,0.5,1/16,0,32;...
        or,or,or,0.6,0.6*0.2,0.5,1/16,3,32;...
        or,or,or,0.6,0.6*0.4,0.5,1/16,3,32}
    steps=[5:10];
    borderColors=jet(12);
    images=zeros(600,600,3,length(steps),'uint8');  % 'fullZoom600'
    for i=1:length(steps)
        [images(:,:,:,i)]=getStimSweep(sweptImageParameters,{sweptImageValues{i,:}},borderColors(steps(i),:),[],'fullZoom600');
    end
    montageSize=[1 length(steps)];
    montageReorder=[1 :length(steps)];
    montage(images(:,:,:,montageReorder),'DisplayRange',[0,255],'Size', montageSize);
    if includeTitles;  title('stimulus conditions'); end
    %set(gcf,'Position',[10 710 1500 600])
    %xlim=get(gca,'xLim'); imCenters=linspace(xlim(1),xlim(2),length(steps)+2)
    %set(gca,'xTick',imCenters,'XTickLabel',{'a','b'})  %MONTAGE KILLS THE XTICK LABEL?
    %get(gca,'XTickLabel')
    
    op=get(ratrixAxis,'OuterPosition');
    set(ratrixAxis,'OuterPosition',[-0.05 0.64 0.8 0.35 ])
    
    op=get(modelAxis,'OuterPosition');
    set(modelAxis,'OuterPosition',[0.7 0.55 0.3 0.5 ])
    
    op=get(stimuliAxis,'OuterPosition');
    set(stimuliAxis,'OuterPosition',[-0.05 0 1.1 0.25 ])
    
    %labeling does not work very well on this fig... using alternate method
    %settings.alphaLabel='a'; cleanUpFigure(ratrixAxis,settings)
    %settings.alphaLabel='b'; cleanUpFigure(modelAxis,settings)
    %settings.alphaLabel='c'; cleanUpFigure(performanceAxis,settings)
    %settings.alphaLabel='d'; cleanUpFigure(stimuliAxis,settings)
    %settings.alphaLabel=[];
    
    settings.PaperPosition=[.5 .5 3.5 3.5];
    settings.fontSize=10;
    settings.textObjectFontSize=7;
    cleanUpFigure(gcf,settings)
    
    %labels rely on d's position and scale
    text(-100,-150,'d','fontSize',14)
    text(-100,-2000,'c','fontSize',14)
    text(-100,-3200,'a','fontSize',14)
    text(3000,-3200,'b','fontSize',14)
    
    stepNumFnt=7;
    text(50,75,'5','fontSize',stepNumFnt)
    text(650,75,'6','fontSize',stepNumFnt)
    text(1250,75,'7','fontSize',stepNumFnt)
    text(1850,75,'8','fontSize',stepNumFnt)
    text(2450,75,'9','fontSize',stepNumFnt)
    text(3050,75,'10','fontSize',stepNumFnt)

    stepNumFnt=7;
    text(300,675,'Easy','fontSize',stepNumFnt,'HorizontalAlignment','center')
    text(900,675,'Linearized','fontSize',stepNumFnt,'HorizontalAlignment','center')
    text(1500,675,'Thinner','fontSize',stepNumFnt,'HorizontalAlignment','center')
    text(2100,675,'Smaller','fontSize',stepNumFnt,'HorizontalAlignment','center')
    text(2700,675,'+Flanks','fontSize',stepNumFnt,'HorizontalAlignment','center')
    text(3300,675,'Testing','fontSize',stepNumFnt,'HorizontalAlignment','center')
    
    set(ratrixAxis,'OuterPosition',[-0.05 0.64 0.8 0.35 ])
    set(modelAxis,'OuterPosition',[0.7 0.55 0.3 0.5 ])
    saveFigs(savePath,figureType,allFigID,resolution,renderer);
    h=8
    %%
    if 0  % this is old and does not belong here... not sure what its for... intital testing?
        sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
        sweptImageValues={or,or,or,1,[1 0]}
        borderColors=jet(2);
        [images]=getStimSweep(sweptImageParameters,sweptImageValues,borderColors,[],'column');
        montageSize=[1 2];
        montageReorder=[1 2];
        montage(images(:,:,:,montageReorder),'DisplayRange',[0,255],'Size', montageSize);
        if includeTitles;  title('stimulus conditions'); end
    end
    
end


for f=1:length(figID)
    or=(pi/12);
    singleRat='138';  % for single rat plot  (138 for main paper)
    
    
    % factor out common defaults, some may be overwritten
    numBins=10;
    diffEdges=linspace(-5,5,numBins+1);
    dprimeDiffRange=linspace(-0.3,0.3,numBins+1);
    critDiffRange=linspace(-0.2,0.2,numBins+1);
    
    ylab=[50 60 70 80];
    
    subPlotOrder=[1:4];
    sx=2;sy=2;si=0;
    
     % SET UP PLOTS
    figure(figID(f));
    set(figID(f),'Position',[0 40 600 640])
    settings.PaperPosition=[.5 .5 3.5 3.5];
    settings.LineWidth=1.5;
    settings.HgGroupLineWidth=0.5;
    settings.fontSize=10; %12 is 12 on a 3.5 inch wide column.  10 looks better
    settings.MarkerSize=5;%8; 8 is good for dots, x is good for symbols
    settings.textObjectFontSize=7;
    settings.turnOffTics=true;
    settings.box='off';
    
    switch figID(f)
        case 1
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            sweptImageValues={or,or,or,1,0};
            borderColor=[.2 .2 .2];
            montageSize=[1 1];
            montageReorder=[1];
            rocReorder=montageReorder;
            
            
            filter{1}.type='preFlankerStep';
            conditionType='noFlank';  % use the + which groups the base 8 types and gives them a condition name.
            useConds={'noFlank'};            % display these conditions
            condRename={'target only'};     % rename them this way
            colors=[.5 .5 .5];              % assign these colors
            cMatrix={[1],[1]};              % emphasize this comparison, calculate it from first arrow
            arrows=[];                      % arrows from A-->B
            error('untested')
        case 2
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=-or;
            sweptImageValues={or,or,or,1,[1 0 0]};
            borderColor=[ .9 0 0; .2 .5 .2; .4 .9 .4];
            montageSize=[1 3];
            montageReorder=[1 2 3];
            rocReorder=montageReorder;
            barImageOrder=[1 2 3];
            
            
            
            
            %             conditionType='8flanks+&nfMix&nfBlock'  % use the + which groups the base 8 types and gives them a condition name.
            %             useConds={'other','noFm','noFb'};       % display these conditions
            %             arrows={'noFm','other',2}; %...           % arrows from A-->B
            %             %'noFm','noFb'};                   % extra line
            %             ROCuseConds={'noFm','other'};
            
            
            conditionType='hasFlank&nfMix&nfBlock';
            useConds={'hasF','noFm','noFb'};       % display these conditions
            arrows={'noFm','hasF',2}; %...           % arrows from A-->B
            %'noFm','noFb'};                         % extra line
            ROCuseConds={'noFm','hasF'};
            
            filter{1}.type='9.4.1+nf';              % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            condRename={'F^+','F^-','F^-'}; % rename them this way
            barGroups={'mix',[1 2],[77]; 'block',[3],[79]}; % add grouped labels
            
            colors=[.9 0 0; .2 .5 .2; .4 .9 .4];     % assign these colors
            %cMatrix={[13],[14]};                   % emphasize this comparison, calculate it from first arrow
            
            ylab=[50 75 100];
            diffEdges=linspace(-20,20,numBins+1);
            dprimeDiffRange=linspace(-0.8,0.8,numBins+1);
            critDiffRange=linspace(-0.8,0.8,numBins+1);
            
            %alt
            if 0
                montageSize=[1 2];
                montageReorder=[1 2 ];
                rocReorder=montageReorder;
                barImageOrder=[1 2 ];
                useConds={'hasF','noFm'};       % display these conditions
                condRename={'F^+','F^-'}; % rename them this way
                colors=[.9 0 0; .2 .5 .2];     % assign these colors
            end
            
        case 3
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or,or,1,1};
            borderColor=[.9 0 0; 0 .8 .8; 0 .8 .8 ; .2 .2 .2; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ; .9 0 0];
            montageSize=[1 2];
            montageReorder=[1 2];
            barImageOrder=montageReorder;
            rocReorder=montageReorder;
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                   % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            
            fig3version=2;
            switch fig3version
                case 1
                    conditionType='8flanks+';               % lump popout and non-popout groups21
                    useConds={'colin','changeFlank'};       % display these conditions
                    condRename={'col','pop1'};              % rename them this way
                    colors=[.9 0 0; 0 .8 .8 ];                  % assign these colors
                    %cMatrix={[9],[10]};                     % emphasize this comparison, calculate it from first arrow
                    arrows={'changeFlank','colin'};          % arrows from A-->B
                    
                case 2%INCLUDES PARA AND POP2:
                    %sweptImageValues={or,or,or(1),1,1};
                    %...etc for image params
                    conditionType='popVsNot'                % lump popout and non-popout groups
                    useConds={'not','pop'};                 % display these conditions
                    %condRename={'iso-orient','pop-out'};   % rename them this way
                    condRename={'iso','pop'};              % rename them this way
                    colors=[.9 0 0; 0 .8 .8 ];                  % assign these colors
                    %cMatrix={[1],[2]};                      % emphasize this comparison, calculate it from first arrow
                    arrows={'pop','not'};                    % arrows from A-->B
            end
            
            ROCuseConds=arrows;
            
            
            
        case 4
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or,or,1,1};
            borderColor=[.9 0 0; 0 .8 .8 ; 0 .8 .8 ; .2 .2 .2; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ; .9 0 0];
            borderColor(:)=0;  %its been scrambled, not fixed yet
            montageSize=[1 4];
            montageReorder=[1 2 6 5]; %[1 5 2 6]; %[1 4 2 3]; old prioriized position, this new hold target orientation constant
            barImageOrder=montageReorder;
            rocReorder=[1 5];
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                   % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            conditionType='8flanks+';               % lump popout and non-popout groups
            %useConds={'colin','para','changeFlank','changeTarget'};  % display these conditions
            %condRename={'col','par','pop_1','pop_2'};% rename them this way
            useConds={'colin','changeFlank','changeTarget','para'};  % display these conditions
            condRename={'col','pop_1','pop_2','par'};   % rename them this way
            colors=[.9 0 0; 0 .8 .8 ; 0 .8 .8 ; .2 .2 .2];  %[.1 .2 .5] old hybrid color            
            %cMatrix={[1],[2]};                      % emphasize this comparison, calculate it from first arrow
            arrows={'changeFlank','colin'};          % arrows from A-->B
            ROCuseConds=arrows;
            
            

            %%switch to 6 subplots:
            %subPlotOrder=[1 3 5];
            %sx=2;sy=3;
            %settings.PaperPosition=[.5 .5 3.5 5];
        case 5
            %phase
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast','flankerPhase'}; % why does contrast have to be last?
            
            sweptImageValues={-or,-or,-or,1,1,[0 pi]};
            borderColor=[.9 0 0; 0 0 1];
            montageSize=[1 2];
            montageReorder=[1 2];
            barImageOrder=montageReorder;
            rocReorder=montageReorder;
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                      % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            conditionType='colin-other';               % lump popout and non-popout groups
            useConds={'colinear','phaseRev'};          % display these conditions
            condRename={'same','reverse'};             % rename them this way
            colors=borderColor;                        % assign these colors
            %cMatrix={[1],[2]};                        % emphasize this comparison, calculate it from first arrow
            arrows={'phaseRev','colinear'};            % arrows from A-->B  {should this be switched or not?}
            ROCuseConds=arrows;
            
        case 11  %% colinearity in the case where target orientation is always + (R)
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or(1),or,1,1};
            borderColor=[.9 0 0; 0 .8 .8; .2 .2 .2; 0 .8 .8];
            %  montageSize=[1 4];
            %  montageReorder=[1 3 2 4];
            montageSize=[1 2];
            montageReorder=[1 3];
            
            
            barImageOrder=montageReorder;
            rocReorder=[1 2];
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                   % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            conditionType='8flanks+';               % lump popout and non-popout groups
            %useConds={'RRR','RRL','RLR','RLL'};  % display these conditions
            useConds={'RRR','RRL'};  % display these conditions
            condRename=useConds;% rename them this way
            colors=[.9 0 0; .2 .2 .2];%; 0 .8 .8 ; 0 .8 .8 ];                     % assign these colors
            %cMatrix={[1],[2]};                      % emphasize this comparison, calculate it from first arrow
            arrows={'RRL','RRR'};          % arrows from A-->B
            ROCuseConds=arrows;
            
        case 12 %% colinearity in the case where target orientation is always -  (L)
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or(1),or,1,1};
            
            % borderColor=[0 .8 .8; .2 .2 .2; 0 .8 .8; .9 0 0];
            % montageSize=[1 4];
            % montageReorder=[ 4 2 1 3];
            borderColor=[.9 0 0; .2 .2 .2; .2 .2 .2 ; .2 .2 .2 ]
            montageSize=[1 2];
            montageReorder=[ 1 3 ];
            
            
            barImageOrder=montageReorder;
            rocReorder=[1 2];
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                   % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            conditionType='8flanks+';               % lump popout and non-popout groups
            %useConds={'LLL','LLR','LRL','LRR'};  % display these conditions
            useConds={'LLL','LLR'};  % display these conditions
            condRename=useConds;% rename them this way
            colors=[.9 0 0; .2 .2 .2];%; 0 .8 .8 ; 0 .8 .8 ];                     % assign these colors
            %cMatrix={[1],[2]};                      % emphasize this comparison, calculate it from first arrow
            arrows={'LLR','LLL'};          % arrows from A-->B
            ROCuseConds=arrows;
            
            
        case 13  % confrim claim about popouts being differents
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or,or,1,1};
            borderColor=[.9 0 0; 0 .8 .8 ; 0 .8 .8 ; .2 .2 .2; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ; .9 0 0];
            montageSize=[1 2];
            montageReorder=[2 3];
            barImageOrder=montageReorder;
            rocReorder=[2 3];
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                   % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            conditionType='8flanks+';               % lump popout and non-popout groups
            useConds={'changeFlank','changeTarget'};  % display these conditions
            condRename={'pop_1','pop_2'};% rename them this way
            colors=[ 0 .8 .8 ; 0 .8 .8 ];                     % assign these colors
            %cMatrix={[1],[2]};                      % emphasize this comparison, calculate it from first arrow
            arrows={'changeTarget','changeFlank'};          % arrows from A-->B
            ROCuseConds=arrows;
            
        case -4 % not useful; just reduces power by restricting phase
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or,or,1,1};
            borderColor=[.9 0 0; 0 .8 .8 ; 0 .8 .8 ; .2 .2 .2; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ; .9 0 0];
            montageSize=[2 2];
            montageReorder=[1 2 4 3];
            barGroups={}; % add grouped labels
            
            filter{1}.type='9.4';                   % use flanker present at contrast .4 with target at contratst 1.0, and no flanks mixed in to the nf analysis
            conditionType='colin+3';                % lump popout and non-popout groups
            useConds={'---','lll','l-l','-l-'};     % display these conditions
            condRename={'col','par','pop_1','pop_2'};% rename them this way
            colors=[.9 0 0; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ];    % assign these colors
            %cMatrix={[1],[2]};                     % emphasize this comparison, calculate it from first arrow
            arrows={'lll','---'};                   % arrows from A-->B
            
            
        case {14,15}% during later testing phase  (like fig 4 except for filter type)
            
            %images
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast'}; % why does contrast have to be last?
            or=[-1 1]*(or);
            sweptImageValues={or,or,or,1,1};
            borderColor=[.9 0 0; 0 .8 .8 ; 0 .8 .8 ; .2 .2 .2; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ; .9 0 0];
            montageSize=[1 4];
            montageReorder=[1 5 2 6]; %[1 4 2 3]; old prioriized position, this new hold target orientation constant
            barImageOrder=montageReorder;
            rocReorder=[1 5];
            barGroups={}; % add grouped labels
            
            
            switch figID(f)
                case 14
                    filter{1}.type='11';                    %
                case 15
                    filter{1}.type='12';                    %
            end
            
            conditionType='8flanks+';               % lump popout and non-popout groups
            useConds={'colin','para','changeFlank','changeTarget'};  % display these conditions
            condRename={'col','par','pop_1','pop_2'};% rename them this way
            colors=[.9 0 0; .2 .2 .2; 0 .8 .8 ; 0 .8 .8 ];                     % assign these colors
            %cMatrix={[1],[2]};                      % emphasize this comparison, calculate it from first arrow
            arrows={'para','colin'};          % arrows from A-->B
            ROCuseConds=arrows;
            

        otherwise
            figID
            error('bad figID')
    end

%     filter{2}.type='performancePercentile';
% %filter{2}.parameters.whichCondition={'FullTargetContrastSomeFlankerAndMatchedNoSig',[1]};
%     filter{2}.parameters.whichCondition={'everything',[1]};
%     filter{2}.parameters.goodType='withoutAfterError';
%     filter{2}.parameters.performanceMethod='pCorrect';
%     filter{2}.parameters.performanceParameters={[.15 1],'symetricBoxcar',4000};

%      filter{2}.type='responseSpeedPercentile';
%      filter{2}.parameters.range=[0 .9];%whats justified?

    borderColor(:)=1; % this turns all borders white!
    
    
    % OPTIONS: add filters to end of main filter
    
    % GET IMAGES
    antiAliasing=false;
    useSymbolicFlanker=true;
    [images]=getStimSweep(sweptImageParameters,sweptImageValues,borderColor,[],'column',false,antiAliasing,useSymbolicFlanker);
    
    
    % GET STATS
    [stats CI names params]=getFlankerStats(subjects,conditionType,statTypes,filter,dateRange,[], numShuffle);
    
    % assign names and colors for calls below
    labeledNames=assignLabeledNames(subjects);
    %labeledNames=subjects; this is just for pmm's confirmation
    
    cMatrix{1}=find(strcmp(names.conditions,arrows{1,2}));
    cMatrix{2}=find(strcmp(names.conditions,arrows{1,1}));
    
    cMatrixNames{1}=condRename{find(strcmp(useConds,arrows{1,1}))};
    cMatrixNames{2}=condRename{find(strcmp(useConds,arrows{1,2}))};
    
    % overwrite default colors with chosen colors... could turn this off...
    usedConditionIDs=[];
    for c=1:length(useConds)
        usedConditionIDs(c)=find(strcmp(useConds(c),names.conditions));
    end
    params.colors(usedConditionIDs,:)=colors; % this can now be used in doHitFAScatter
    
    if includeModel
        
        %SUBPLOT: model
        si=si+1;
        subplot(sy,sx,subPlotOrder(si));
        set(gca,'Position',[0.07 0.54 0.4 0.4])
        %modelImagePath='L:\Rodent-Data\pmeier\flankerSupport\ppt figures in progress\TIFF_models\models300dpi';
        modelImagePath='\\reinagel-lab.ad.ucsd.edu\rlab\Rodent-Data\pmeier\flankerSupport\ppt figures in progress\TIFF_models_biggerText\modelsAlone3';
        
        if ismember(figID(f)-1,[1:5])
            im=imread(fullfile(modelImagePath,sprintf('Slide%d.TIF',figID(f)-1)));
            %modelName=sprintf('Model %s',63+figID(f));
            %text(.5,.5,modelName)
            imshow(im(:,:,1:3));
        end
        
        axis square;
        set(gca,'Visible','off','box','off')
        %set(gca,'Visible','on','box','on')
        set(gca,'xTick',[]); set(gca,'xTickLabel',[]);
        set(gca,'yTick',[]); set(gca,'yTickLabel',[]);
    end
    
    %SUBPLOT: stims
    if addBarIms
        for i=1:length(barImageOrder)
            barIms{i}=images(:,:,:,barImageOrder(i))
        end
    else
        si=si+1; subplot(sy,sx,subPlotOrder(si));
        montage(images(:,:,:,montageReorder),'DisplayRange',[0,255],'Size', montageSize);
        if includeTitles;  title('stimulus conditions'); end
        %axis square;
        barIms=[];
    end
    
    if addSingleRatPerformance
        %SUBPLOT: single rat performance
        si=si+1; subplot(sy,sx,subPlotOrder(si));
        p=100*stats(strcmp(singleRat,names.subjects),usedConditionIDs,find(strcmp('pctCorrect',names.stats)));
        ci= 100*CI(strcmp(singleRat,names.subjects),usedConditionIDs,find(strcmp('pctCorrect',names.stats)),[1:2]);
        ci=reshape(ci(:),length(usedConditionIDs),2);
        imWidth=0.8; %normalized to barwidth
        doBarPlotWithStims(p,ci,barIms,colors,[50 max(ylab)],'stats&CI',false,barGroups,imWidth)
        if includeTitles;  title(sprintf('single rat performance (%s)',labeledNames{find(strcmp(singleRat,subjects))})); end
        %set(gca,'xTickLabel',condRename); set(gca,'xTick',[1:length(usedConditionIDs)]);  % OLD HORIZONTAL MODE
        set(gca,'xTick',[]) %VERTICAL MODE turns it off and creates text objects
        thisYLim=ylim; amp=range(thisYLim)
        for i=1:length(condRename)
            %text(i,thisYLim(1)-amp/20,condRename{i},'HorizontalAlignment','right','Rotation',90);
            text(i,thisYLim(1)-amp/20,condRename{i},'HorizontalAlignment','center','verticalAlignment','top','Rotation',0); %
        end
        ylabel('% correct (P)'); set(gca,'yTick',ylab); set(gca,'yTickLabel',ylab)
        set(gca,'yLim',[50 max(ylab)]);
        set(gca,'xLim',[.5 length(condRename)+.5]); axis square;
    end
    
    %SUBPLOT: group performance
    si=si+1; subplot(sy,sx,subPlotOrder(si));
    p=100*stats(:,usedConditionIDs,find(strcmp('pctCorrect',names.stats)));
    stat=mean(p);
    ci=[stat; stat]+[-1; 1]*std(p);
    nc=length(usedConditionIDs);
    %doBarPlotWithStims(stat,ci',[],colors,[50 75],'stats&CI',false) % with std error bar
    %doBarPlotWithStims(stat,[stat; stat]',[],colors,[55 70],'stats&CI',false) % no error bar
    hold on;
    axis([0.5 nc+0.5 50 100]); %axis([0 nc+1 50 100])
    if 1 % add connector per subject
        offset=0.0;
        if 0 % add connector for some subjects
            
            %worst
            y2=100*stats(find(y==min(y)),usedConditionIDs,find(strcmp('pctCorrect',names.stats)));
            plot([1:nc]+offset,y2,'k--')
            %best
            y2=100*stats(find(y==max(y)),usedConditionIDs,find(strcmp('pctCorrect',names.stats)));
            plot([1:nc]+offset,y2,'k--')
            %fig a
            y2=100*stats(strcmp(singleRat,names.subjects),usedConditionIDs,find(strcmp('pctCorrect',names.stats)));
            plot([1:nc]+offset,y2,'k--')
        elseif 1 % add connector for all subjects
            for j=1:length(subjects) %size(stats,1) used to be length subjects before shuffles in stats
                subId=find(strcmp(subjects(j),names.subjects));
                y2=100*stats(subId,usedConditionIDs,find(strcmp('pctCorrect',names.stats)));
                plot([1:nc]+offset,y2,'color',[.8 .8 .8])
                f
                %only plot some
                someRats={'r2','r6','r7'} % 138=single, r7 = high and lefty, r6=low and lefty
                someRats={'none'};
                if ismember(labeledNames{j},someRats)
                    rNudge=0.3;
                    lNudge=0.2;
                    switch figID(f)
                        
                        
                        case 2
                            switch labeledNames{j}
                                case {'r3','r2','r5','r6','r7'} % {'r3','r2','r5','r6'}
                                    t=text(nc+rNudge, y2(end),labeledNames(j)); %label subjects
                                otherwise
                                    t=text(1-lNudge, y2(1),labeledNames(j)); %label subjects
                            end
                        case 3
                            switch labeledNames{j}
                                case {'r4','r5','r6','r2','r7'} %{'r4','r5','r6'}
                                    t=text(nc+rNudge, y2(end),labeledNames(j)); %label subjects
                                case {'r2'}
                                    t=text(nc+rNudge, y2(end)+.5,labeledNames(j)); %label subjects
                                otherwise
                                    t=text(1-lNudge, y2(1),labeledNames(j)); %label subjects
                            end
                        case 4
                            switch labeledNames{j}
                                case {'r2','r4','r5','r6','r7'} %{'r2','r4','r5','r6'}
                                    t=text(nc+rNudge, y2(end),labeledNames(j)); %label subjects
                                otherwise
                                    t=text(1-lNudge, y2(1),labeledNames(j)); %label subjects
                            end
                        case 5
                            switch labeledNames{j}
                                case {'r4','r6','r1','r2','r7'} %{'r4','r6','r1'}
                                    t=text(nc+rNudge, y2(end),labeledNames(j)); %label subjects
                                otherwise
                                    t=text(1-lNudge, y2(1),labeledNames(j)); %label subjects
                            end
                        case {11,12,13}
                            t=text(nc+rNudge, y2(end)+.5,labeledNames(j)); %label subjects
                        otherwise
                            t=text(nc+rNudge, y2(end)+.5,labeledNames(j)); %label subjects
                    end
                    set(t, 'HorizontalAlignment', 'center','VerticalAlignment','middle');
                end
                
            end
        end
    end
    
    %add scatter for subjects
    for j=1:length(subjects) %size(stats,1) used to be length subjects before shuffles in stats
        for i=1:length(usedConditionIDs)
            x=repmat(i+offset,1,length(names.subjects));
            %y=100*stats(:,usedConditionIDs(i),find(strcmp('pctCorrect',names.stats)));
            y=100*stats(strcmp(subjects(j),names.subjects),usedConditionIDs(i),find(strcmp('pctCorrect',names.stats)));
            d=plot(x(j),y,'.','MarkerSize',20,'color',colors(i,:));
            set(d,'Marker',getMarkerSymbolForSubject(subjects(j)));
            if ismember(labeledNames(j),{'r6','r7'})
                set(d,'MarkerFaceColor',colors(i,:));  %filled solid
            else
                set(d,'MarkerFaceColor',[1 1 1]);  %open
            end
            %set(d,'MarkerEdgeColor','b','MarkerFaceColor','r')
        end
    end
    
    if includeTitles;  title(sprintf('all rats performance (N=%d)',length(subjects))); end
    
    %set(gca,'xTick',[1:length(usedConditionIDs)]); set(gca,'xTickLabel',condRename)
    set(gca,'xTick',[]) %VERTICAL MODE turns it off and creates text objects
    thisYLim=ylim; amp=range(thisYLim)
    for i=1:length(condRename)
        %text(i,thisYLim(1)-amp/20,condRename{i},'HorizontalAlignment','right','Rotation',90);
        text(i,thisYLim(1)-amp/20,condRename{i},'HorizontalAlignment','center','verticalAlignment','top','Rotation',0); %
    end
    
    
    ylabel('% correct (P)'); set(gca,'yTick',ylab); set(gca,'yTickLabel',ylab)
    set(gca,'yLim',[50 max(ylab)]); axis square;
    
    %SUBPLOT: emphasize comparison
    si=si+1; subplot(sy,sx,subPlotOrder(si));
    alpha=0.05;
    %alpha=1-(1-0.05)^(1/length(subjects)); % adjust for multiple comparisons
    %alpha=1-(1-0.05)^(1/42); % 7 subjects, 6 pairwise
    %alpha=1-(1-0.05)^(1/10000); % crazy test
    doFigAndSub=false;
    addTrialNums=false; % false!
    addNames= labeledNames;
    multiComparePerPlot=false;
    objectColors.histSig=[.2 .2 1]; % use dark blue always
    %objectColors.histSig=colors(find(strcmp(useConds,names.conditions(cMatrix{2}))),:); % use the color of the first comparison
    objectColors.histInsig=[.6 .6 .6];
    objectColors.subjectSig=objectColors.histSig;
    objectColors.subjectInsig=objectColors.histInsig;
    displaySignificance=false;
    labelAxis=false;
    encodeSideRule=false;
    viewPopulationMeanAndCI=false;
    yScaling=[60 10 30 0]%[50 25 25 0];
    padFraction=0;
    
    %normal
    [delta deltaCI deltas deltaCIs]=viewFlankerComparison(names,params,cMatrix,{'pctCorrect'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
        
    % pctCorrectMCMC
    %[delta deltaCI deltas deltaCIs]=viewFlankerComparison(names,params,cMatrix,{'pctCorrectMCMC'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
    
    %VIEW THE SHUFFLES EXPLICITLY
    %addNames=assignLabeledNames(names.subjects);
    %viewFlankerComparison(names,params,cMatrix,{'pctCorrect'},[],diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
    
    %put a gap on the figure
    plot(diffEdges(1),diff(ylim)*(1-((yScaling(1)+yScaling(2)/2))/100),'ws','MarkerFaceColor',[1 1 1])
    
    
    if includeTitles;  title('difference in % correct'); end
    xlabel(sprintf('P(%s) - P(%s)', cMatrixNames{2},cMatrixNames{1}))
    ylabel('count     rat ID    ');
    axis square;
    
    
    
    cleanUpFigure(figID(f),settings)
    
    switch figID(f)
        
        case 2
            subplot(2,2,1); settings.alphaLabel='a'; cleanUpFigure(gca,settings)
            subplot(2,2,2); settings.alphaLabel='b'; cleanUpFigure(gca,settings)
            subplot(2,2,3); 
            settings=rmfield(settings,'alphaLabel'); cleanUpFigure(gca,settings)
            %settings.alphaLabel='c'; cleanUpFigure(gca,settings)

 
            %dunno why this hack is more even than the measured thing
             x=-24;
              text(-24,47, 'c',...
                'fontSize',settings.fontSize,'HorizontalAlignment','right','VerticalAlignment','bottom','fontweight','b');
        
            
            
            modelAxis=subplot(2,2,4); 
            %modelImagePath='\\reinagel-lab.ad.ucsd.edu\rlab\Rodent-Data\pmeier\flankerSupport\ppt figures in progress\TIFF_models5';
            %im=imread(fullfile(modelImagePath,'modelsAlone5-contrastNorm.tif'));
            
            modelImagePath='\\reinagel-lab.ad.ucsd.edu\rlab\Rodent-Data\pmeier\flankerSupport\ppt figures in progress\TIFF_Models9';
            im=imread(fullfile(modelImagePath,'modelsAlone6.tif'));
           
            imshow(im(:,:,1:3));
            set(modelAxis,'Position',[0.54 0.0 0.4 0.5])
            
            set(modelAxis,'Visible','off','box','off')
            
            subplot(2,2,3); 
            ys=ylim; xs=xlim; fractionOutOfCorner=[1.5 1.1]; %these fractions work for tiff's but not figs or bmp's
            x=xs(1)+fractionOutOfCorner(1)*range(xs);
            y=ys(1)+fractionOutOfCorner(2)*range(ys);
            text(x,y, 'd',...
                'fontSize',settings.fontSize,'HorizontalAlignment','right','VerticalAlignment','bottom','fontweight','b');
            
            h=8
           %saveFigs(savePath,figureType,allFigID,resolution,renderer);

        case 4
            %
            
            compareAxis2=subplot(2,2,4); 
            arrows={'para','colin'};          % arrows from A-->B
            cMatrix{1}=find(strcmp(names.conditions,arrows{1,2}));
            cMatrix{2}=find(strcmp(names.conditions,arrows{1,1}));
            cMatrixNames{1}=condRename{find(strcmp(useConds,arrows{1,1}))};
            cMatrixNames{2}=condRename{find(strcmp(useConds,arrows{1,2}))};
            [delta deltaCI deltas deltaCIs]=viewFlankerComparison(names,params,cMatrix,{'pctCorrect'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
            
            plot(diffEdges(1),diff(ylim)*(1-((yScaling(1)+yScaling(2)/2))/100),'ws','MarkerFaceColor',[1 1 1])
            if includeTitles;  title('difference in % correct'); end
            xlabel(sprintf('P(%s) - P(%s)', cMatrixNames{2},cMatrixNames{1}))
            ylabel('count     rat ID    ');
            axis square;
            cleanUpFigure(figID(f),settings)
            
            singleAxis=subplot(2,2,1); settings.alphaLabel='a'; cleanUpFigure(gca,settings)
            groupAxis=subplot(2,2,2); settings.alphaLabel='b'; cleanUpFigure(gca,settings)
            compareAxis=subplot(2,2,3); settings.alphaLabel='c'; cleanUpFigure(gca,settings)
            compareAxis2=subplot(2,2,4); settings.alphaLabel='d'; cleanUpFigure(gca,settings)
          
            

          
            
            %             singleAxis=subplot(3,2,1); settings.alphaLabel='a'; cleanUpFigure(gca,settings)
            %             groupAxis=subplot(3,2,3); settings.alphaLabel='b'; cleanUpFigure(gca,settings)
            %             compareAxis=subplot(3,2,5); settings.alphaLabel='c'; cleanUpFigure(gca,settings)
            %
            %             singleAxis=subplot(3,2,1);
            %             ys=ylim; xs=xlim; fractionOutOfCorner=[1.4 1.1]; %these fractions work for tiff's but not figs or bmp's
            %             x=xs(1)+fractionOutOfCorner(1)*range(xs);
            %             y=ys(1)+fractionOutOfCorner(2)*range(ys);
            %               text(x,y, 'd',...
            %                 'fontSize',settings.fontSize,'HorizontalAlignment','right','VerticalAlignment','bottom','fontweight','b');
            %
            
            
            %             %SUBPLOT: model
            %             modelAxis=subplot(1,2,2);
            %             modelImagePath='\\reinagel-lab.ad.ucsd.edu\rlab\Rodent-Data\pmeier\flankerSupport\ppt figures in progress\TIFF_models5';
            %             im=imread(fullfile(modelImagePath,'modelsAlone5-full.tif'));
            %             imshow(im(:,:,1:3));
            %             set(modelAxis,'Position',[0.54 0.03 0.4 0.9])
            %             %axis square;
            %             set(modelAxis,'Visible','off','box','off')

        otherwise
            %old generic labeling
            %subplot(2,2,1);
            subplot(2,2,2); settings.alphaLabel='b'; cleanUpFigure(gca,settings)
            %put an "a" on the models funny ofset axis in subplot 1
            ys=ylim; xs=xlim; fractionOutOfCorner=[1.7 -1.1]; %these fractions work for tiff's but not figs or bmp's
            x=xs(1)-fractionOutOfCorner(1)*range(xs);
            y=ys(1)-fractionOutOfCorner(2)*range(ys);
            text(x,y, 'a',...
                'fontSize',settings.fontSize,'HorizontalAlignment','right','VerticalAlignment','bottom','fontweight','b');
            subplot(2,2,3); settings.alphaLabel='c'; cleanUpFigure(gca,settings)
            subplot(2,2,4); settings.alphaLabel='d'; cleanUpFigure(gca,settings)
            settings.alphaLabel=[];
    end
    
    
    
    
    if addFig6 && figID(f)==4
        %%
        figure(6)
         %settings.PaperPosition=[.5 .5 3.5 5];
        set(gcf,'Position',[0 40 800 640])
        %set(figure,'position',[50 50 900 600])
        %sub1=subplot('position',[.1 .1 0.5 .8]);
        subplot(2,2,1)
        axis([0 1 0 1])
        doLegend=false;
        doCurve=false;
        doYesLine=false;
        doCorrectLine=false;
        sideText=false; %?
        doErrorBars=3; %ellipse
        displaySignificance=false;
        viewPopulationMeanAndCI=false;
        
        %[a b]=getDprCurve(51, .5, -.1, 1,[.2 .2 .2]);
        %[a b]=getDprCurve(51, 1, -.4, 1,[.2 .2 .2]);
        
        axisTextSpace=0.05; %fraction of lim away from axis
        
        arrows2=arrows;
        arrows2{3}=2;
        doHitFAScatter(stats,CI,names,params,subjects,ROCuseConds,doLegend,doCurve,doYesLine,doCorrectLine,sideText,doErrorBars,arrows2)
        xlabel([])
        ylabel([])
        set(gca,'XTick',[0 1],'XTickLabel',{'0','1'})
        set(gca,'YTick',[0 1],'YTickLabel',{'0','1'})
        text(0.5,-axisTextSpace,'False Alarm Rate','HorizontalAlignment', 'center','VerticalAlignment','top')
        text(-axisTextSpace,0.5,'Hit Rate','HorizontalAlignment', 'center','VerticalAlignment','bottom','Rotation',90)
        if includeTitles;   title(sprintf('%s -> %s', cMatrixNames{1},cMatrixNames{2})); end
        addCornerAxis()
        
        
        
        %add images into ROC
        imBottom=.075; imTop=.4;
        imLeft=.45; imWidth=(imTop-imBottom)*size(images,2)/size(images,1);
        yy=linspace(imBottom,imTop,size(images,1));
        xx=linspace(imLeft,imLeft+imWidth,size(images,2));
        image(xx,yy,images(:,:,:,rocReorder(1)));
        xx=linspace(imLeft+imWidth*1.5,imLeft+imWidth*2.5,size(images,2));
        image(xx,yy,images(:,:,:,rocReorder(2)));
        text(xx(1)-imWidth*0.25,imBottom+(imTop-imBottom)/2,'-');
        
        %add rectangle around each
        rectangle('Position',[imLeft imBottom imWidth imTop-imBottom ],'EdgeColor',[1 0 0])
        rectangle('Position',[imLeft+imWidth*1.5 imBottom imWidth imTop-imBottom ],'EdgeColor',[0 0 1])
        text(imLeft+imWidth/2,imTop+0.01,'col','HorizontalAlignment', 'center','VerticalAlignment','bottom')
        text(imLeft+imWidth*2,imTop+0.01,'par','HorizontalAlignment', 'center','VerticalAlignment','bottom')
        
        zoomRect=[.40 .55 .65 .8];
        plot(zoomRect([1 2]),zoomRect([3 3]),'k' )
        plot(zoomRect([1 2]),zoomRect([4 4]),'k' )
        plot(zoomRect([1 1]),zoomRect([3 4]),'k' )
        plot(zoomRect([2 2]),zoomRect([3 4]),'k' )
        text(mean(zoomRect([1 2])),zoomRect(4),'zoom','HorizontalAlignment', 'center','VerticalAlignment','bottom');
        subplot(2,2,2)
        %sub1=subplot('position',[.3 .5 .2 .2]);
        %('position',[.3 .5 .2 .2])
        arrows2{3}=4
        %[a b]=getDprCurve(51, .5, -.1, 1,[.2 .2 .2]);
        %[a b]=getDprCurve(51, 1, -.4, 1,[.2 .2 .2]);
        doHitFAScatter(stats,CI,names,params,{'230','139'},ROCuseConds,doLegend,doCurve,doYesLine,doCorrectLine,sideText,doErrorBars,arrows2)
        xlabel([])
        ylabel([])
        axis(zoomRect)
        text(.44,.68,'r2');
        text(.52,.755,'r5');
        set(gca,'XTick',[zoomRect(1)  zoomRect(2)],'XTickLabel',{zoomRect(1),zoomRect(2)})
        set(gca,'YTick',zoomRect([3 4]),'YTickLabel',zoomRect([3 4]))
        
        
        text(mean(zoomRect([1 2])),zoomRect(3)-axisTextSpace*diff(ylim),'False Alarm Rate','HorizontalAlignment', 'center','VerticalAlignment','top')
        text(zoomRect(1)-axisTextSpace*diff(xlim),mean(zoomRect([3 4])),'Hit Rate','HorizontalAlignment', 'center','VerticalAlignment','bottom','Rotation',90)
        addCornerAxis()
        
        
        fig6diffEdges=linspace(-8,8,numBins+1);
        
        %subplot('position',[left bottom width height])
        %3/2 is from the ratio of width:height = 900:600
        %sub2=subplot('position',[.7 .1 0.22 .22*(3/2)])
        subplot(2,2,3)
        viewFlankerComparison(names,params,cMatrix,{'hits'},subjects,fig6diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction);
        %cleanMiniStat('Hit Rate')
        %title(['\Delta Hit Rate']); axis square;
        xl=xlim;
        set(gca,'XTick',xl,'XTickLabel',xl)
        text(0,-axisTextSpace*diff(ylim),'\Delta Hit Rate','HorizontalAlignment', 'center','VerticalAlignment','top')
        
        
        %sub3=subplot('position',[.7 (.9-.22*(3/2)) 0.22 .22*(3/2)])
        subplot(2,2,4)
        viewFlankerComparison(names,params,cMatrix,{'FAs'},subjects,fig6diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction);
        % cleanMiniStat('False Alarm Rate')
        % title(['\Delta False Alarm Rate']);  axis square
        set(gca,'XTick',xl,'XTickLabel',xl)
        text(0,-axisTextSpace*diff(ylim),'\Delta False Alarm Rate','HorizontalAlignment', 'center','VerticalAlignment','top')
        
        subplot(2,2,1); settings.alphaLabel='a'; cleanUpFigure(gca,settings)
        subplot(2,2,2); settings.alphaLabel='b'; cleanUpFigure(gca,settings)
        subplot(2,2,3); settings.alphaLabel='c'; cleanUpFigure(gca,settings)
        subplot(2,2,4); settings.alphaLabel='d'; cleanUpFigure(gca,settings)
        settings.alphaLabel=[];
        cleanUpFigure(gcf,settings)
        % set(sub1,'position',[.1 .1 0.5 .8])
        % set(sub2,'position',[.7 .1 0.22 .22*(3/2)])
        % set(sub3,'position',[.7 (.9-.22*(3/2)) 0.22 .22*(3/2)])
        
    end
    
    if addFig7 && ismember(figID(f),[2 4 5])
        %%
        figure(7)
        %%
        switch figID(f)
            case 2
                ff=0;
            case 4
                ff=1;
            case 5
                ff=2;
        end
   
        doLegend=false;
        doCurve=false;
        doYesLine=false;
        doCorrectLine=false;
        sideText=false; %?
        doErrorBars=3; %ellipse
        displaySignificance=false;
        addNames= [];
        arrows{3}=4;
        
        rocIDs(ff+1)=subplot(3,3,(3*ff)+1); doHitFAScatter(stats,CI,names,params,subjects,ROCuseConds,doLegend,doCurve,doYesLine,doCorrectLine,sideText,doErrorBars,arrows)
        xlabel([])
        set(gca,'XTickLabel',{'0','False Alarms','1'})
        %title(sprintf('%s -> %s', cMatrixNames{1},cMatrixNames{2}))
        addCornerAxis();
        settings.LineWidth=1;
        settings.fontSize=12;
        settings.box='on';
        %settings.alphaLabel=sprintf('%s',[97+ff]); cleanUpFigure(gca,settings); settings.alphaLabel=[];
        settings.fontSize=13;
        settings.textObjectFontSize=7;
        
        %add images into ROC
        imBottom=.075; imTop=.4;
        imLeft=.45; imWidth=(imTop-imBottom)*size(images,2)/size(images,1);
        yy=linspace(imBottom,imTop,size(images,1));
        xx=linspace(imLeft,imLeft+imWidth,size(images,2));
        image(xx,yy,images(:,:,:,rocReorder(1)));
        xx=linspace(imLeft+imWidth*1.5,imLeft+imWidth*2.5,size(images,2));
        image(xx,yy,images(:,:,:,rocReorder(2)));
        text(xx(1)-imWidth*0.25,imBottom+(imTop-imBottom)/2,'-');
        
        %         subplot(8,4,(ff*8)+3); viewFlankerComparison(names,params,cMatrix,{'hits'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance); axis square;
        %         subplot(8,4,(ff*8)+4); viewFlankerComparison(names,params,cMatrix,{'CRs'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance); axis square;
        %         subplot(8,4,(ff*8)+7); viewFlankerComparison(names,params,cMatrix,{'yes'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance); axis square;
        %         subplot(8,4,(ff*8)+8); viewFlankerComparison(names,params,cMatrix,{'dpr'},subjects,[],alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance); axis square;
        
        %MANY (use with rocIDs(ff+1)=subplot(4,2,(2*ff)+1))
        %         subplot(8,6,(ff*12)+4); viewFlankerComparison(names,params,cMatrix,{'pctCorrect'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('correct')
        %         subplot(8,6,(ff*12)+5); viewFlankerComparison(names,params,cMatrix,{'yes'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('yes')
        %         subplot(8,6,(ff*12)+6); viewFlankerComparison(names,params,cMatrix,{'hits'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('hit')
        %         if any(ismember(names.stats,'dprimeMCMC')) && any(ismember(names.stats,'criterionMCMC'))
        %             subplot(8,6,(ff*12)+10); viewFlankerComparison(names,params,cMatrix,{'dprimeMCMC'},subjects,dprimeDiffRange,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('d''')
        %             subplot(8,6,(ff*12)+11); viewFlankerComparison(names,params,cMatrix,{'criterionMCMC'},subjects,critDiffRange,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('criterion')
        %         else
        %             subplot(8,6,(ff*12)+10); viewFlankerComparison(names,params,cMatrix,{'dpr'},subjects,dprimeDiffRange,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('d''')
        %             subplot(8,6,(ff*12)+11); viewFlankerComparison(names,params,cMatrix,{'crit'},subjects,critDiffRange,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('criterion')
        %         end
        %         subplot(8,6,(ff*12)+12); viewFlankerComparison(names,params,cMatrix,{'FAs'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('FA')
        
        % FEW (use with use with rocIDs(ff+1)=subplot(4,3,(2*ff)+1))
        subplot(3,3,(ff*3)+2); viewFlankerComparison(names,params,cMatrix,{'pctCorrect'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('correct')
        if any(ismember(names.stats,'dprimeMCMC'))
            subplot(3,3,(ff*3)+3); viewFlankerComparison(names,params,cMatrix,{'dprimeMCMC'},subjects,dprimeDiffRange,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('d''')
        else
            subplot(3,3,(ff*3)+3); viewFlankerComparison(names,params,cMatrix,{'dpr'},subjects,dprimeDiffRange,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors,displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction); cleanMiniStat('d''')
        end
        
        set(gcf,'Position',[0 40 900 900])
        
    end
end

if addFig7
    
    %cleanUpFigure(rocIDs,settings)
    for i=1:9
        subplot(3,3,i); settings.alphaLabel=sprintf('%s',[96+i]); 
        cleanUpFigure(gca,settings); 
    end
    settings.alphaLabel=[];
end

if addFig8
    %%
    figure(8)

    switch 2
        case 1
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast','stdGaussMask','flankerOffset','pixPerCycs'}; % why does contrast have to be last?
            or=(pi/12);
            tc=0.6; %0.6 target contrast is used to render close perception of linearized contrast 1.0
            fc=0.3; %0.3 flanker contrast is used to render close perception of linearized contrast 0.4
            sweptImageValues={...or,or,or,0,0,0.5,1/16,0,32;...
                or,or,or,tc,fc,1/16,3,32;...
                or,or,-or,tc,fc,1/16,3,32;...
                -or,or,or,tc,fc,1/16,3,32;...
                -or,or,-or,tc,fc,1/16,3,32;...
                or,or,or,tc,0,1/16,0,32;...
                
                -or,-or,-or,tc,fc,1/16,3,32;...
                -or,-or,or,tc,fc,1/16,3,32;...
                or,-or,-or,tc,fc,1/16,3,32;...
                or,-or,or,tc,fc,1/16,3,32;...
                -or,-or,-or,tc,0,1/16,0,32;...
                }
            
            borderColors=[.9 0 0; .2 .2 .2;  0 .8 .8 ; 0 .8 .8 ; .1 .5 .1;
                .9 0 0; .2 .2 .2;  0 .8 .8 ; 0 .8 .8 ; .1 .5 .1];
            n=size(borderColors,1);
            images=zeros(500,300,3,n,'uint8');  % 'column'
            antiAliasing=false;
            useSymbolicFlanker=false;
            for i=1:n
                [images(:,:,:,i)]=getStimSweep(sweptImageParameters,{sweptImageValues{i,:}},borderColors(i,:),[],'column',false,antiAliasing,useSymbolicFlanker);
            end
            montageSize=[2 n/2];
            montageReorder=[1 : n];
            hold off
            montage(images(:,:,:,montageReorder),'DisplayRange',[0,255],'Size', montageSize);
            set(gcf,'Position',[10 410 1500 600])
            xSz=diff(xlim);
            ySz=diff(ylim);
            axis([0 xSz 0 ySz*1.2])
            hlfunit=xSz/10;
            vals=linspace(hlfunit,9*hlfunit,5);
            xNames={'col','par','pop_1','pop_2','F^-'};
            set(gca,'xTick',vals,'xTickLabel',xNames)
            for i=1:length(xNames)
                text(vals(i),ySz*1.02,xNames{i},'HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            end
            
            
                hold on
            plot(hlfunit*[0.8 3.2],ySz([1 1])*1.085,'k-');
            plot(hlfunit*[4.7 7.3],ySz([1 1])*1.085,'k-');
            plot(hlfunit*[1.8 6.2],ySz([1 1])*1.14,'k-');
            text(hlfunit*2,ySz*1.085,'iso','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            text(hlfunit*6,ySz*1.085,'pop','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            text(hlfunit*4,ySz*1.14,'F^+','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
        case 2
            
            sweptImageParameters={'flankerOrientation','targetOrientation','flankerPosAngle','targetContrast','flankerContrast','stdGaussMask','flankerOffset','pixPerCycs','flankerPhase'}; % why does contrast have to be last?
            or=(pi/12);
            tc=0.6; %0.6 target contrast is used to render close perception of linearized contrast 1.0
            fc=0.3; %0.3 flanker contrast is used to render close perception of linearized contrast 0.4
            sweptImageValues={...or,or,or,0,0,0.5,1/16,0,32;...
                or,or,or,tc,fc,1/16,3,32,0;...
                or,or,or,tc,fc,1/16,3,32,pi;...
                or,or,-or,tc,fc,1/16,3,32,0;...
                -or,or,or,tc,fc,1/16,3,32,0;...
                -or,or,-or,tc,fc,1/16,3,32,0;...
                or,or,or,tc,0,1/16,0,32,0;...
                
                -or,-or,-or,tc,fc,1/16,3,32,0;...
                -or,-or,-or,tc,fc,1/16,3,32,pi;...
                -or,-or,or,tc,fc,1/16,3,32,0;...
                or,-or,-or,tc,fc,1/16,3,32,0;...
                or,-or,or,tc,fc,1/16,3,32,0;...
                -or,-or,-or,tc,0,1/16,0,32,0;...
                }
            
            borderColors=[.9 0 0; 0.8 0 0; .2 .2 .2;  0 .8 .8 ; 0 .8 .8 ; .1 .5 .1;
                          .9 0 0; 0.8 0 0; .2 .2 .2;  0 .8 .8 ; 0 .8 .8 ; .1 .5 .1];
            n=size(borderColors,1);
            images=zeros(500,300,3,n,'uint8');  % 'column'
            antiAliasing=false;
            useSymbolicFlanker=false;
            for i=1:n
                [images(:,:,:,i)]=getStimSweep(sweptImageParameters,{sweptImageValues{i,:}},borderColors(i,:),[],'column',false,antiAliasing,useSymbolicFlanker);
            end
            montageSize=[2 n/2];
            montageReorder=[1 : n];
            hold off
            montage(images(:,:,:,montageReorder),'DisplayRange',[0,255],'Size', montageSize);
            set(gcf,'Position',[10 410 1500 600])
            xSz=diff(xlim);
            ySz=diff(ylim);
            axis([0 xSz 0 ySz*1.2])
            hlfunit=xSz/12;
            vals=hlfunit*[2 5 7 9 ]
            xNames={'col','par','pop_1','pop_2'};
            set(gca,'xTick',vals,'xTickLabel',xNames)
            for i=1:length(xNames)
                text(vals(i),ySz*1.05,xNames{i},'HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            end
            hold on
            text(hlfunit,ySz*1.0,'samePhase','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            text(hlfunit*3,ySz*1.0,'reversePhase','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            
            
            plot(hlfunit*[1.8 5.2],ySz([1 1])*1.115,'k-');
            plot(hlfunit*[6.7 9.3],ySz([1 1])*1.115,'k-');
            plot(hlfunit*[3.8 8.2],ySz([1 1])*1.17,'k-');
            plot(hlfunit*[0.2 3.9],ySz([1 1])*1.05,'k-');
            text(hlfunit*4,ySz*1.115,'iso','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            text(hlfunit*8,ySz*1.115,'pop','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            text(hlfunit*6,ySz*1.17,'F^+','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            text(hlfunit*11,ySz*1.17,'F^-','HorizontalAlignment', 'center','VerticalAlignment','top','Rotation',0)
            
            
    end
    cleanUpFigure
    %%
end
%%
if addFig9 && figID(f)==4
   figure(9)
    settings.PaperPosition=[.5 .5 3.5 5];
   %cMatrix={[9],[12];[11],[10];[9],[11];[10],[12];[9],[10];[11],[12]}
      cMatrix={[9],[10];[11],[12];[9],[12];[11],[10];[9],[11];[10],[12]}
  for si=1:6;
      subplot(3,2,si);
      displaySignificance=false;
    viewFlankerComparison(names,params,cMatrix(si,:),{'pctCorrect'},subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
    
    cMatrixNames{1}=condRename{find(strcmp(useConds,names.conditions{cMatrix{si,2}}))};
    cMatrixNames{2}=condRename{find(strcmp(useConds,names.conditions{cMatrix{si,1}}))};

    
    %VIEW THE SHUFFLES EXPLICITLY
    %addNames=assignLabeledNames(names.subjects);
    %viewFlankerComparison(names,params,cMatrix,{'pctCorrect'},[],diffEdges,alpha,doFigAndSub,addTrialNums,addNames,multiComparePerPlot,objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
    
    %put a gap on the figure
    plot(diffEdges(1),diff(ylim)*(1-((yScaling(1)+yScaling(2)/2))/100),'ws','MarkerFaceColor',[1 1 1])
    
    if includeTitles;  title('difference in % correct'); end
    xlabel(sprintf('P(%s) - P(%s)', cMatrixNames{2},cMatrixNames{1}))
    ylabel('count     rat ID    ');
    axis square;
  end
  set(gcf,'Position',[0 40 600 640])
  settings.alphaLabel=[];
  cleanUpFigure(gcf,settings)
  subplot(3,2,1); settings.alphaLabel='a'; cleanUpFigure(gca,settings)
  subplot(3,2,2); settings.alphaLabel='b'; cleanUpFigure(gca,settings)
  subplot(3,2,3); settings.alphaLabel='c'; cleanUpFigure(gca,settings)
  subplot(3,2,4); settings.alphaLabel='d'; cleanUpFigure(gca,settings)
  subplot(3,2,5); settings.alphaLabel='e'; cleanUpFigure(gca,settings)
  subplot(3,2,6); settings.alphaLabel='f'; cleanUpFigure(gca,settings)

  %% 
end

clearvars -except savePath figureType allFigID resolution renderer  % save memory for rendering / printing high resolution
saveFigs(savePath,figureType,allFigID,resolution,renderer);
% saveFigs('C:\Documents and Settings\rlab\Desktop\graphs',{'-dtiffn','png'},7,800,{'-opengl'})
done=1;



function cleanMiniStat(statType)
title(['\Delta ' statType])
xlabel([])
ylabel([])
axis square;
set(gca,'YTick',[])

settings.fontSize=12;
settings.textObjectFontSize=7;
settings.MarkerSize=1;
settings.LineWidth=2
cleanUpFigure(gca,settings)

function handles=addCornerAxis()

length=6;
width=0.5;

originFraction=[.2 .8];
lengthFraction=[.1];  % units of horizontal, not diagonal...
ylim=get(gca,'ylim');
xlim=get(gca,'xlim');



start=[xlim(1)+range(xlim)*originFraction(1) ylim(1)+range(ylim)*originFraction(2)];
xEnd=xlim(1)+range(xlim)*(originFraction(1)+[-1 1 ]*(lengthFraction));
yEnd=ylim(1)+range(ylim)*(originFraction(2)+[1  1 ]*(lengthFraction));
xUnit=range(xlim)*lengthFraction;
yUnit=range(ylim)*lengthFraction;
arrow('Start',[start],'Stop',[xEnd(1) yEnd(1)],'Length',length,'Width',width);
arrow('Start',[start],'Stop',[xEnd(2) yEnd(2)],'Length',length,'Width',width);
text(xEnd(1)+xUnit/3,yEnd(1)-yUnit/2,'P','HorizontalAlignment','center','VerticalAlignment','top');
text(xEnd(2)-xUnit/3,yEnd(1)-yUnit/2,'y','HorizontalAlignment','center','VerticalAlignment','top');