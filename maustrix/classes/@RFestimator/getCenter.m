function [ctr source details]  = getCenter(RFe,subjectID,trialRecords)
% This function calculates the center position of the receptive field, using the parameters on the object.
% The result is returned as a 2-element array [x y] in normalized units as fraction of screen


%TESTING
%sca
%keyboard
%load('\\132.239.158.179\datanet_storage\demo1\analysis\physAnalysis_191-20090205T151316.mat')
%load('\\132.239.158.179\datanet_storage\demo1\analysis\334-20090206T164500\physAnalysis_334-20090206T164500.mat')
%load('\\132.239.158.183\rlab_storage\pmeier\backup\devNeuralData_090310\test\analysis\43-20090323T201947\physAnalysis_43-20090323T201947.mat')
%load('\\132.239.158.183\rlab_storage\pmeier\backup\devNeuralData_090310\test\analysis\20-20090323T201110\physAnalysis_20-20090323T201110.mat')
%load('\\132.239.158.183\rlab_storage\pmeier\backup\devNeuralData_090310\test\stimRecords\stimRecords_20-20090323T201110.mat')

%sca
%keyboard  % need to fix getPhysRecords
%subjectID='test1';  % JUST TO SEE IF IT works;   must DELETE!


details=[];
if strcmp(RFe.centerParams{2},'lastDynamicSettings')
    % doesn't require the analysis to have run... or its data
end


switch RFe.centerParams{1}
    case 'spatialWhiteNoise'
        
        [data success]=getPhysRecords(fullfile(getDataSource(RFe),subjectID),{'dateRange',RFe.dateRange},...
            {'analysis','stim'},RFe.centerParams{1});
        
        if ~success
            error('bad phys load!')
        else
            analysisdata=data.cumulativedata;
            stimulusDetails=data.stimulusDetails;
        end
        
        % for record keeping
        source.subjectID=subjectID;
        source.trialNum=data.trialNum;
        source.timestamp=data.timestamp;
        
        % find brightest point, to select time frame of interest
        ind=find(max(analysisdata.cumulativeSTA(:))==analysisdata.cumulativeSTA(:));
        [x y t]=ind2sub(size(analysisdata.cumulativeSTA),ind);
        STA2d=analysisdata.cumulativeSTA(:,:,t);
        
        switch RFe.centerParams{2}
            case 'fitGaussian'
                stdThresh=RFe.centerParams{3}{1}
                
                [STAenvelope STAparams] =fitGaussianEnvelopeToImage(STA2d,stdThresh,false,false,false);
                view=0;
                if view
                    figure(7)
                    hold off; imagesc(STAenvelope); colormap(gray)
                    hold on; plot(STAparams(2)*size(STAenvelope,2)+1,STAparams(3)*size(STAenvelope,1)+1,'ro')
                end
                if nargout>2
                    details.STAparams=STAparams;
                    details.STAenvelope=STAenvelope;
                    details.STA2d=STA2d;
                end
            case 'fitGaussianSigEnvelope'
                
                %for testing
                %STA2d=computeGabors(stimParams,0.5,64,64,'square','normalizeVertical',0)+ 0.09*(randn(64,64) + 0.1);
                %sigSpots=getSignificantSTASpots(STA,500,[],0.005);
                
                stdThresh=RFe.centerParams{3}{1};
                alpha=RFe.centerParams{3}{2};
                medianFilter=RFe.centerParams{3}{3};
                %fit a guassian to the binary significance image -- conservative
                sigSpots=getSignificantSTASpots(STA2d,analysisdata.cumulativeNumSpikes,stimulusDetails.meanLuminance,stimulusDetails.std,medianFilter,alpha);
                if ~length(union(unique(sigSpots),[0 1]))==2
                    error('more than one RF spot!')
                end
                
                [sigEnvelope sigConservativeParams] =fitGaussianEnvelopeToImage(sigSpots,stdThresh,salse,false,false);
                
                %use the conservative field to narrow a better seach of the STA
                [STAenvelope STAparams] =fitGaussianEnvelopeToImage(STA2d,stdThresh,sigEnvelope,false,false);
                
                view=1;
                if view
                    figure(7)
                    subplot(1,3,1); imagesc(sigSpots); colormap(gray)
                    subplot(1,3,2); imagesc(sigEnvelope); colormap(gray)
                    subplot(1,3,3); imagesc(STAenvelope); colormap(gray)
                end
                
                if nargout>2
                    details.STAparams=STAparams;
                    details.STAenvelope=STAenvelope;
                    details.sigEnvelope=sigEnvelope;
                    details.sigSpots=sigSpots;
                    details.STA2d=STA2d;
                end
            otherwise
                error('unsupported method');
        end
        
        ctr=STAparams(2:3);
    case 'gratingWithChangeableAnnulusCenter'
        switch RFe.centerParams{2}
            case 'lastDynamicSettings'
                %this does not need a phys analysis, rather it needs
                %details of the dymanimic settings in the trialRecords!
                
                %trialRecords.stimManagerClass
                %cands=find(strcmp({trialRecords.stimManagerClass},'gratings'))
                %this only finds the gratings candidates from THIS session,
                %so instead we look for a signature field of gratingWithChangeableAnnulusCenter
                
                ctr=[];
                for i=length(trialRecords):-1:1  % go backwards through the trial records until changeableAnnulusCenter is found and true
                    if isfield(trialRecords(i).stimDetails,'changeableAnnulusCenter') && trialRecords(i).stimDetails.changeableAnnulusCenter==1
                        useTrial=i; % the most recent trial with changeableAnnulusCenter
                        trialRecords(useTrial).stimDetails.width;
                        trialRecords(useTrial).stimDetails.height;
                        
                        whichPhase=1;  % could have a smarter way of doing this by finding it... autopilot uses 1
                        pos=trialRecords(useTrial).phaseRecords(whichPhase).dynamicDetails{end}.annulusDestRec;
                        
                        ctr(1)=mean(pos([1 3]))/trialRecords(useTrial).stimDetails.width; %x
                        ctr(2)=mean(pos([2 4]))/trialRecords(useTrial).stimDetails.height; %y
                        
                        source.subjectID=trialRecords(useTrial).subjectsInBox;
                        source.trialNum=trialRecords(useTrial).trialNumber;
                        source.timestamp=trialRecords(useTrial).date;
                        
                        break
                    end
                end
        end
        if isempty(ctr)
            numTrailsChecked=length(trialRecords)
            error('there are no trials with gratings in the trial history!')
        end
        
        
    otherwise
        RFe.centerParams{2}
        error('bad source')
end

if any(ctr>1) || any(ctr<0)
    warning('center is estimated to be off screen')
    beep; beep
    %force on screen
    ctr(ctr>1)=1;
    ctr(ctr<0)=0;
end


end % end function