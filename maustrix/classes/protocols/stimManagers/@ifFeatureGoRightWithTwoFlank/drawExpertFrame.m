function [doFramePulse expertCache dynamicDetails textLabel i dontclear indexPulse] = ...
    drawExpertFrame(stimulus,stim,i,phaseStartTime,totalFrameNum,window,textLabel,destRect,...
    filtMode,expertCache,ifi,scheduledFrameNum,dropFrames,dontclear,dynamicDetails)
% remains untested
% not used: phaseStartTime, destRect, filtMode, ifi
% maybe should use: expertCache, scheduledFrameNum, dropFrames, dontclear
%
% old functioning: [dynDetails
% textString]=doDynamicPTBFrame(t,phase,stimDetails,frame,timeSinceTrial,eyeRecords,RFestimate, w,textString)
% new signature: [doFramePulse expertCache dynamicDetails textLabel i dontclear] = ...
%drawExpertFrame(stimulus,stim,i,phaseStartTime,window,textLabel,destRect,filtMode,expertCache,ifi,scheduledFrameNum,dropFrames,dontclear)
%
% fixed problems:
%1) mysterious white box solved when
%   -all non-sm tex's flushed out in clean up of trial
%   -no more reinflation allowed
%   -confirmed with plots and stimulus.cache.typeSz
%2) black values fixed, requires some uint8
%
%remainging problem worth tracking down:
%1) repitition number flickers, suggesting that it's wrong
% (need to turn on detailed text to help view this)


%properties of screen
filterMode=1; %0 = Nearest neighbour filtering, 1 = Bilinear
modulateColor=[];  % should be empty of interferes with global alpha
textureShader=[];

%setup
typeInd = [];
oInd = [];
pInd = [];
destinationRect=[];
globalAlpha=[];  % will get overwritten per texture

%init
doFramePulse=true;
texNum=0;
expertCache=[];

if dropFrames
    i=scheduledFrameNum;
else
    i=i+1;
end


try  
    %ERROR CHECK
    if i <4 %==1  OLD STIMOGL somehow it might start on 3 or 4, not one?
        if ~isDynamicRender(stimulus)
            stimulus.renderMode
            error('cannot use pbt mode if trialManager is not set to the appropriate renderMode');
        end
        
        badFirstTex=all(size(Screen('GetImage', stimulus.cache.textures(1),[],[],2))==[1 1 3]); % used to be a one pixel tex from ITL, should no longe happens after pmmEvent('whiteBoxFixed')
        if badFirstTex
            error('the tex problem happened')
        end
    end
    
    
    %%% LOGIC
    [targetIsOn flankerIsOn effectiveFrame cycleNum sweptID repetition]=isTargetFlankerOn(stimulus,i);
    textLabel=sprintf('%2.2g stim#: %2.2g stimID: %2.2g rep: %2.2g', effectiveFrame,cycleNum,sweptID,repetition);
    
    if effectiveFrame==1 & sweptID==1
        indexPulse=true;
    else
        indexPulse=false;
    end
    
    
    %update dynamic values if there
    if ~isempty(stimulus.dynamicSweep)
        [stim dynamicDetails]=setDynamicDetails(stimulus,stim,sweptID,dynamicDetails);
    end
    
    %update dynamic values if there
    if ~isempty(stimulus.dynamicFlicker)
        [stim dynamicDetails]=setDynamicFlicker(stimulus,stim,effectiveFrame,dynamicDetails);
    end
    
    %set up target
    if targetIsOn
        
        %INDS FOR PATCH MODE -- type for many
        texNum=texNum+1;
        pInd(texNum)= find(stimulus.phase==stim.flankerPhase);
        if stim.correctResponseIsLeft==1
            typeInd(texNum)=2; %left
            oInd(texNum)= find(stimulus.goLeftOrientations==stim.targetOrientation);
        elseif stim.correctResponseIsLeft==-1
            typeInd(texNum)=1; %right
            oInd(texNum)= find(stimulus.goRightOrientations==stim.targetOrientation);
        end
        %PARAMS FOR GABOR RENDERING MODE - not all use
        params(texNum,:)= [Inf  stimulus.pixPerCycs  stim.targetPhase stim.targetOrientation  1  stimulus.thresh  1/2   1/2 ];
        %BASIC STUFF -- all use
        globalAlpha(texNum) = stim.targetContrast;
        destinationRect(texNum,:)=stim.PTBStimRects(1,:); %target is 1, top is 2, bottom is 3
        
        if stimulus.displayTargetAndDistractor
            texNum=texNum+1; %distractor
            if stim.correctResponseIsLeft==1
                if stimulus.distractorYokedToTarget
                    typeInd(texNum)=2; %left
                    oInd(texNum)= find(stimulus.goLeftOrientations==stim.targetOrientation);
                else
                    typeInd(texNum)=4; %distractor
                    oInd(texNum)= find(stimulus.distractorOrientations==stim.distractorOrientation);
                end
            elseif stim.correctResponseIsLeft==-1
                if stimulus.distractorYokedToTarget
                    typeInd(texNum)=1; %right
                    oInd(texNum)= find(stimulus.goRightOrientations==stim.targetOrientation);
                else
                    typeInd(texNum)=4; %distractor
                    oInd(texNum)= find(stimulus.distractorOrientations==stim.distractorOrientation);
                end
            end
            pInd(texNum)= find(stimulus.phase==stim.distractorPhase);
            globalAlpha(texNum) = stim.distractorContrast;
            destinationRect(texNum,:)=stim.PTBStimRects(4,:); %distractor is 4
            params(texNum,:)= [Inf  stimulus.pixPerCycs  stim.distractorPhase distractorOrientation  1  stimulus.thresh  1/2   1/2 ];
        end
    end
    
    %set up flanker
    if flankerIsOn
        %choose indices
        if stimulus.topYokedToBottomFlankerOrientation & stimulus.topYokedToBottomFlankerContrast
            texNum=texNum+1;
            typeInd(texNum)=3; %flanker
            oInd(texNum)= find(stimulus.flankerOrientations==stim.flankerOrientation);
            pInd(texNum)= find(stimulus.phase==stim.flankerPhase);
            globalAlpha(texNum) = stim.flankerContrast;
            destinationRect(texNum,:)=stim.PTBStimRects(2,:); %top is 2, bottom is 3
            params(texNum,:)= [Inf  stimulus.pixPerCycs  stim.flankerPhase stim.flankerOrientation  1  stimulus.thresh  1/2   1/2 ];
            
            texNum=texNum+1;
            typeInd(texNum)=3; %flanker
            oInd(texNum)= oInd(texNum-1);
            pInd(texNum)= pInd(texNum-1);
            globalAlpha(texNum) =  globalAlpha(texNum-1);
            destinationRect(texNum,:)=stim.PTBStimRects(3,:); %top is 2, bottom is 3
            params(texNum,:)= [Inf  stimulus.pixPerCycs  stim.flankerPhase stim.flankerOrientation  1  stimulus.thresh  1/2   1/2 ];
            
        else
            error('topYokedToBottomFlankerContrast and topYokedToBottomFlankerOrientation must equal 1')
        end
        if stimulus.displayTargetAndDistractor
            if stimulus.distractorFlankerYokedToTargetFlanker
                if stimulus.topYokedToBottomFlankerOrientation & stimulus.topYokedToBottomFlankerContrast
                    texNum=texNum+1;
                    typeInd(texNum)=3; %distractorFlanker(type 5) is drawn as a flanker(type 3)
                    oInd(texNum)= find(stimulus.flankerOrientations==stim.flankerOrientation);
                    pInd(texNum)= find(stimulus.phase==stim.flankerPhase);
                    globalAlpha(texNum) = stim.distractorFlankerContrast;
                    destinationRect(texNum,:)=stim.PTBStimRects(5,:); %top is 5, bottom is 6
                    params(texNum,:)= [Inf  stimulus.pixPerCycs  stim.flankerPhase stim.flankerOrientation  1  stimulus.thresh  1/2   1/2 ];
                    
                    texNum=texNum+1;
                    typeInd(texNum)=3; %distractorFlanker(type 5) is drawn as a flanker(type 3)
                    oInd(texNum)= oInd(texNum-1);
                    pInd(texNum)= pInd(texNum-1);
                    globalAlpha(texNum) =  globalAlpha(texNum-1);
                    destinationRect(texNum,:)=stim.PTBStimRects(6,:); %top is 5, bottom is 6
                    params(texNum,:)= [Inf  stimulus.pixPerCycs  stim.flankerPhase stim.flankerOrientation  1  stimulus.thresh  1/2   1/2 ];
                else
                    error('topYokedToBottomFlankerContrast and topYokedToBottomFlankerOrientation must equal 1')
                end
            else
                error('distractorFlankerYokedToTargetFlanker must = 1');
            end
        end
    end
    
    %always need this in order to wipe out the existing image from before...
    Screen('FillRect',window, stim.backgroundColor);
    %end
    
    
    
    if targetIsOn || flankerIsOn
        version=stimulus.renderMode(strfind(stimulus.renderMode,'-')+1:end);
        switch version
            case 'precachedInsertion'
                %this first version of the code slavishly reproduces the method used in the
                %ratrixGeneral renderMode...in the future could be used to validate a
                %version where Gaussian Mask are stored seperate from grating and
                %orientations is handled by PTB and phase is handled by choice of
                %sourceRect or fast computation
                
                
                %Screen('BlendFunction', window,GL_SRC_ALPHA,GL_ONE); % blend source then add it
                %do i need this? how often?  does not seem to help...
                %Gaborium demo uses it only once at the begining
                
                %[resident texidresident] = Screen('PreloadTextures', window)
                
                %draw the patches
                N=size(oInd,2);
                %                         for n=1:N
                %                             disp(sprintf('frame=%d n=%d',i,n))
                %                             stimulus.cache.textures
                %                             thisTex=stimulus.cache.textures(typeInd(n),oInd(n),pInd(n))
                %                             screen('drawTexture',window,stimulus.cache.textures(typeInd(n),oInd(n),pInd(n)),[],destinationRect(n,:),[],filterMode,globalAlpha(n),modulateColor,textureShader)
                %                             %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader]);
                %                         end
                
                
                texInds=sub2ind(size(stimulus.cache.textures),typeInd(1:N), oInd(1:N),pInd(1:N));
                %ALL AT ONCE IS OPTIMIZED
                %                         texInds=texInds
                %                         window=window
                %                         tex=stimulus.cache.textures(texInds)
                %                         srcRect=[]
                %                         dRect=destinationRect(1:N,:)'
                %                         rAngles=[]
                %                         filter=repmat(filterMode,1,N)
                %                         alpha=globalAlpha(1:N)
                %                         modColor=modulateColor
                %                         textShade=textureShader
                Screen('DrawTextures', window, stimulus.cache.textures(texInds) ,[] , destinationRect(1:N,:)', [], repmat(filterMode,1,N), globalAlpha(1:N), modulateColor, textureShader);
                %Screen('DrawTextures', windowPointer, texturePointer(s) [, sourceRect(s)] [, destinationRect(s)] [, rotationAngle(s)] [, filterMode(s)] [, globalAlpha(s)] [, modulateColor(s)] [, textureShader] [, specialFlags] [, auxParameters]);
                
                %                         mainIm=unique(Screen('GetImage', window))
                %                         oneTex=unique(Screen('GetImage', stimulus.cache.textures(1)))
                
                inspect=0;
                if inspect & i==200 && rand <.5 % mean(before(:)==255)>0.012  %
                    %bkgndColor=stim.backgroundColor
                    %[typeSz txs]=getTypeSizeOfTextures(stimulus, false)
                    %sca
                    %keyboard
                    inspectTexturesAndStop(stimulus,window,texInds)
                end
                
                
            case {'maskTimesGrating'}
                error('not tested yet')
                %this 2nd version of the code coped from  ratrixGeneral-maskTimesGrating
                % Gaussian Mask are stored seperate and gratings are recalculated
                
                %[resident texidresident] = Screen('PreloadTextures', window)
                
                
                maskInd = stimulus.stdGaussMask==details.stdGaussMask
                WHITE=double(intmax(class(stim)));
                %         above=zeros(size(patch),class(stim));
                %         below=above;
                %         above(sign(patch)==1)=(patch(sign(patch)==1));
                %         below(sign(patch)==-1)=(-patch(sign(patch)==-1));
                %         stim(pos(1):pos(2),pos(3):pos(4))=stim(pos(1):pos(2),pos(3):pos(4))+above-below;
                
                %draw the patches
                for n=1:size(params,1)
                    contrast=1; %relying on global alpha
                    grating=computeGabors(params(1,:),0.5,stim.patchX2,stim.patchX2,stimulus.gratingType,'normalizeVertical',0);
                    patch=(WHITE*contrast)*(s.cache.maskVideo(maskInd).*(grating{n}-0.5));
                    tex= screen('makeTexture',window,patch);
                    screen('drawTexture',window,tex,[],destinationRect(n,:),[],filterMode,globalAlpha(n),modulateColor,textureShader)
                    %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader]);
                end
            case {'onePatchPerPhase'}
                %this 3rd version of the code
                % one grating per phase is precomputed,
                % orientation handled by PTB's internal rotation
                
                
                %[resident texidresident] = Screen('PreloadTextures', window)
                
                
                rotAngles=rad2deg(params(:,4)');
                
                internalRotation=0; % a stim parameter? set in details by onePatchPerPhase?
                if internalRotation
                    sflags = kPsychUseTextureMatrixForRotation;
                    ind=1; % all phase tex the same size, so just use the first
                    srcRect = CenterRect([0 0 stim.patchX2 stim.patchX2], Screen('Rect', stimulus.cache.textures(ind)));
                    %                         srcRect = repmat(srcRect,length(pInd),1);
                    %                         apparently only needs one of them
                else
                    sflags = 0;
                    srcRect = [];
                end
                
                for i=1:length(stimulus.phase)
                    which=find(params(:,3)==stimulus.phase(i)); %which stims get drawn this phase
                    if length(which)>0
                        i=i
                        window=window
                        tex=stimulus.cache.textures(i)
                        srcRect=srcRect'
                        dRect=destinationRect(which,:)'
                        rAngles=rotAngles(which)
                        filter=repmat(filterMode,1,length(which))
                        alpha=globalAlpha(which)
                        modColor=modulateColor
                        textShade=textureShader
                        sflags=sflags
                        Screen('DrawTextures', window, stimulus.cache.textures(i), srcRect', destinationRect(which,:)', rotAngles(which), repmat(filterMode,1,length(which)), globalAlpha(which),modulateColor,textureShader, sflags);
                    end
                end
                
                %all at once
                
                %                     Screen('DrawTextures', window, stimulus.cache.textures([pInd]), srcRect', destinationRect', rotAngles, repmat(filterMode,1,length(pInd)), globalAlpha,modulateColor,textureShader, sflags);
                
            case {'onePatch'}
                % phase handled by source selection
                error('never used')
                
            otherwise
                error('bad version')
        end
    end
    
    
    noise = 0;
    if noise
        Screen('TransformTexture')
    end
    
    %Screen('DrawingFinished', window);
    
catch ex
    sca
    pInd
    oInd
    typeInd
    destinationRect
    globalAlpha
    %texIndss
    
    filterMode
    modulateColor
    textureShader
    
    %stimulus.cache.textures(texInds)
    getReport(ex)
    sca
    keyboard
    
    %     ex.stack.line
    %     ex.stack.name
    %     ex.stack.file
    ShowCursor;
    
    rethrow(ex);
end
end

function inspectTexturesAndStop(stimulus,window,texInds)

[oldmaximumvalue oldclampcolors] = Screen('ColorRange', window);
x=Screen('GetImage', window);
xd=Screen('GetImage', window,[],[],2);
tx1=Screen('GetImage', stimulus.cache.textures(texInds(1)));
tx2=Screen('GetImage', stimulus.cache.textures(texInds(2)));
tx3=Screen('GetImage', stimulus.cache.textures(texInds(3)));

tx1d=Screen('GetImage', stimulus.cache.textures(texInds(1)),[],[],2);
tx2d=Screen('GetImage', stimulus.cache.textures(texInds(2)),[],[],2);

[typeSz txs]=getTypeSizeOfTextures(stimulus, false);
sca

%stimulus.cache.typeSz
figure; hist(double(xd(:)),255)
fractionWhite=mean(xd(:)==1)
screenRange=minmax(double(xd(:)'))
tx1Range=minmax(double(tx1d(:)'))
tx2Range=minmax(double(tx2d(:)'))
if any(typeSz(:)~=stimulus.cache.typeSz(:))
    [type feature]=find(typeSz~=stimulus.cache.typeSz);
    badValues=typeSz(unique(type),feature);
    val=unique(txs{unique(type)})
    disp(sprintf('szX and szY have changed! : [%d   %d] its val is: %4.4f',badValues,val))
else
    disp('sizes match... yay')
end

keyboard


figure; imagesc(x)
figure; imagesc(tx1)
figure; hist(double(x(200:end,:)),255)
end

function [typeSz txs]=getTypeSizeOfTextures(stimulus, inspect)

temp=cumprod(size(stimulus.cache.textures));
stimulus.cache.textures
numTexs=temp(end)
for i=1:numTexs
    fprintf('getting tex: %d',stimulus.cache.textures(i));
    txs{i}=Screen('GetImage', stimulus.cache.textures(i),[],[],2);
    [type o p]=ind2sub(size(stimulus.cache.textures),i); %type,o,p
    typeSz(i,:)=[type o p size(txs{i}) stimulus.cache.textures(i)];
end

try
    plus=max(stimulus.cache.textures(:))+1;
     xtraTex=Screen('GetImage',plus ,[],[],2)
     xtraTypeSz=[nan nan nan size(xtraTex) plus]
catch
    sca 
    keyboard
end

if inspect
    sca
    keyboard
    %%
    figure; colormap(gray)
    count=0
    for t=1:3
        for o=1:2
            which=find(typeSz(:,1)==t & typeSz(:,2)==o)
            typeSz(which,:)
            for i=1:length(which)
                count=count+1;
                subplot(6,length(which),count); imagesc( txs{which(i)}(:,:,1));
                set(gca,'yTickLabel',t,'yTick',size(txs{which(i)},1)/2)
                set(gca,'xTickLabel',typeSz(which(i),7),'xTick',size(txs{which(i)},1)/2)
            end
        end
    end
end

end

