function [stats CI names params] =getFlankerStats(subjects,conditionType,statTypes,filterType,dateRange,goodTrialType,numShuffle,removeNonTilted)
%stats is a matrix that is (i=subject,j=condition,k=statType)
%CI is the same shape with nans for dprime
%names is a structure with the names of the subjects, stats, and conditions
%params is a list of values that were used in the calulation
%
%philip recommends the default:
%   [stats CI names params]=getFlankerStats;
%sample call Pam might like:
%   [stats CI names params]=getFlankerStats({'229','230'},'8flanks',{'pctCorrect','yes'});
%dpr for the two collinear conditions on rat 229 can be viewed with
%    stats(find(strcmp('229',names.subjects)),find(ismember(names.conditions,{'RRR','LLL'})),find(strcmp('dpr',names.stats)))
%to interpret the name code of the condition: example RRR is one of the collinear stims
%   1st Letter is Target: (L)eft    (R)ight or (n)one
%   2nd Letter is Flanker: (L)eft or (R)ight
%   3rd Letter is FlankerPositionAngle: (L)eft or (R)ight
% thus every 'XXX' has a 'nXX' pair which is matched but without the flanker
% also, you can use the value in params.factors if you want to know what
% was used for a given rat on a given condition

if ~exist('subjects','var') || isempty(subjects)
    subjects={'138','139','229','230','233','234','237'}; % right %229 has few samps on 9.4
    %subjects={'227','228','231','232','274'} % left, bigger tilt too
else
    subjects=unique(subjects); %remove repeats
end

if ~exist('conditionType','var') || isempty(conditionType)
    conditionType='8flanks'; %16flanks
end

if ~exist('statTypes','var') || isempty(statTypes)
    statTypes={'pctCorrect','dpr','hits','CRs','yes'};
end

if ~exist('filterType','var') || isempty(filterType)
    filterType='9.4';   %9.4, X.4, preFlanker
end

if ~exist('dateRange','var') || isempty(dateRange)
    dateRange=[datenum('21-Jun-2008') datenum('19-Oct-2008')];
    dateRange=[1 datenum('19-Oct-2008')]; % everything before oct 19
end

if ~exist('goodTrialType','var') || isempty(goodTrialType)
    goodTrialType='withoutAfterError';
end

if ~exist('numShuffle','var') || isempty(numShuffle)
    numShuffle=0;
end

if ~exist('removeNonTilted','var') || isempty(removeNonTilted)
    removeNonTilted=true;
end

%for output
params.settings.conditionType=conditionType;
params.settings.filterType=filterType;
params.settings.dateRange=dateRange;
params.settings.goodTrialType=goodTrialType;


numRealSubjects=length(subjects);
%add shuffle
if numShuffle>0
    for i=1:numRealSubjects
        for j=1:numShuffle
            newSubjects{(i-1)*(numShuffle)+j}=[subjects{i} '-' num2str(j)];
            
        end
    end
    subjects=[subjects newSubjects];
end

%sizes and names
numSubjects=length(subjects);
names.subjects=subjects;


if ~isempty(strfind(conditionType,'all')) ||...
        ~isempty(strfind(conditionType,'&dev')) ||...
        ~isempty(strfind(conditionType,'&contrasts'))
    tempD=filterFlankerData(getSmalls(subjects{1},[dateRange]),filterType);
    tempGoods=getGoods(tempD,goodTrialType);
    %get the num conditions and names form the first rat in the list
    %b/c names are dynamic to the conditions showed.
else
    tempD=[];
    tempGoods=[];
    %tempD=getSmalls('231',[datenum('21-Jun-2008') now]); % only some sample data used to determine num conditions for preallocation
    %tempD.pixPerCyc=nan(size(tempD.date));
end
[a preConditionNames b c]=getFlankerConditionInds(tempD,tempGoods,conditionType);
numConditions=size(preConditionNames,2);  % just for size, also used to confirm names in 'all' mode

numStats=length(statTypes);
names.stats=statTypes;


%initialize
stats=nan(numSubjects,numConditions,numStats);
CI=nan(numSubjects,numConditions,numStats,2);
smallerNan=nan(numSubjects,numConditions,1);
params.raw.numCorrect=smallerNan;
params.raw.numAttempt=smallerNan;
params.raw.numYes=smallerNan;
params.raw.numHits=smallerNan;
params.raw.numMisses=smallerNan;
params.raw.numCRs=smallerNan;
params.raw.numFAs=smallerNan;

if ismember('RT',statTypes)
    rtCategories={'all','correct','incorrect','yes','no','hits','misses','CRs','FAs'};
    numRTcategories=length(rtCategories);
    biggerNan=nan(numSubjects,numConditions,numRTcategories);
    params.RT.mean=biggerNan;
    params.RT.std=biggerNan;
    params.RT.fast=biggerNan;
    params.RT.CI=repmat(biggerNan,[1 1 1 2]);
end

for i=1:numRealSubjects
    
    %get data
    d=getSmalls(subjects{i},dateRange);
    
    % filter it
    d=filterFlankerData(d,filterType);
    
    %exclude flanker trials that don't have a global tilt
    if removeNonTilted
        beforeTilt=isnan(d.flankerPosAngle);
        d=removeSomeSmalls(d,beforeTilt);
    end
    
    tweakCheck=0;
    if tweakCheck
        %             disp('entering fake data')
        %             %use to confirm that plots reveal what you think they do, for
        %             %example,  that pctYes really is just that
        %             [conditionInds names]=getFlankerConditionInds(d,getGoods(d),'colin+3');
        %             oneType=(conditionInds(strcmp(names,'---'),:));
        %             someFraction=0.05>rand(1,length(d.date));
        %             which=oneType & someFraction & ~d.correct;
        %             correctAnswerID=(d.correctResponseIsLeft);
        %             correctAnswerID(correctAnswerID==-1)=3;
        %             incorrectAnswerID=double(d.correctResponseIsLeft==-1);
        %             incorrectAnswerID(incorrectAnswerID==0)=3;
        %             d.response(which)=correctAnswerID(which); %change some responses to "incorrect"
        %             %d.response(which)=correctAnswerID(which); %change some responses to "correct"
        %             %d.response(which)=3; %change some responses to "rightward"
    end
    
    
    [containsContrasts junk whichContrast]=unique(d.targetContrast(~isnan(d.targetContrast)));
    if length(containsContrasts)>2
        containsContrasts
        pctThisContrast=[];
        for cc=1:length(containsContrasts)
            pctThisContrast(cc)=mean(whichContrast==cc);
        end
        msg=sprintf('Will all your subjects have the same contrasts?\n BEWARE: pctCorrect is now a hitRate for condtions w/ contrast>0');
        warndlg(sprintf('more than one contrast is present for %s:\n %s \n %s \n %s',subjects{i},num2str(containsContrasts),['%trials/contrast:  ' num2str(floor(100*pctThisContrast))], msg ))
        meanPct=mean(pctThisContrast(2:end));
        if any(abs(meanPct-pctThisContrast(2:end))>meanPct*0.1)
            warning('greater than 10% count different between contrast conditions')
        end
        if abs((pctThisContrast(1)-sum(pctThisContrast(2:end))))>0.05 & ~special138_139data(d) & ~(ismember(d.info.subject{1},{'234','231'}) && all(d.step==16)) & ~(ismember(d.info.subject{1},{'227', '229', '230', '232', '233'}) && all(d.step==12))
            %old block temp used during reaction time testing b4 bug fix: & ~(ismember(d.info.subject{1},{'234','231'}) && all(d.step==16))
            d.info.subject{1}
            pctThisContrast
            error('every contrast should have a no-contrast pair: check assumption about the distribution of contrasts')
            %some RT analysis have biases with slower (and not present in those analysis) 
            %consider skipping if any of cell filterType.type contains
            %'responseSpeed' or  'responseSpeedPercentile'
        end
        
    end
    
    %define trials good for analysis
    goods=getGoods(d,goodTrialType);
    
    %get indices of each condition type
    [conditionInds names.conditions haveData params.colors d goods]=getFlankerConditionInds(d,goods,conditionType);
    
    if ismember(conditionType,{'blockIDsByTargetContrast'})
        warning(sprintf('skipped check for a dynamic type: %s',conditionType))
        %skip check on some dynamic types
        numConditions=length(names.conditions);
    else
        for n=1:length(names.conditions)
            if ~strcmp(preConditionNames{n},names.conditions{n})
                preConditionNames
                names.conditions
                preConditionNames{n}
                names.conditions{n}
                error('not all rats can be garaunteed to have the same conditions!')
                % probably b/c all mode allows the name and the extact value to be dynamic.
            end
        end
    end
    
    %set up values for dprime, accounting for of side meaning yes
    forceGotoSideToBeDetection=true;
    [d yesType]=addYesResponse(d,[],forceGotoSideToBeDetection);
    switch yesType
        case 'rightMeansYes'
            presentVal=3;
            absentVal=1;
        case 'leftMeansYes'
            presentVal=1;
            absentVal=3;
    end
    
    %confirm nothing funny is going on
    if ~all((d.correctResponseIsLeft==1)==(d.correct==1 & d.response==1) | (d.correct==0 & d.response~=1))
        x=((d.correctResponseIsLeft==1)==(d.correct==1 & d.response==1) | (d.correct==0 & d.response~=1)) ;
        violations=find(~x)
        if  all(goods(violations)==0)
            disp(sprintf('found %d violation of side rule in rat %s, but they already not included in goods anyways',length(violations),d.info.subject{1}))
        else
            results=unique(d.result(x & goods ))
            includedViolations=find(x & goods)
            z=removeSomeSmalls(d,1:length(d.date)~=includedViolations(1))
            error('violates correct response is left; should never happen, regardless of trial manager rules')
        end
        
    end
    
    
    for shuffleIttr=0:numShuffle
        
        switch shuffleIttr
            case 0
                %real subject do nothing
                %i=1:numRealSubjects
            case 1
                %first shuffle - initialize to first shuffle ind
                i=1+numRealSubjects+(i-1)*numShuffle;
            otherwise
                %subsequent shuffle: advance
                i=i+1;
        end
        
        if shuffleIttr>0
            if shuffleIttr==1
                disp('shuffling')
            elseif mod(shuffleIttr,5)==0
                fprintf('-#%d(%2.2f%%)',i,100*i/numSubjects)
            end
            goodInds=find(goods);
            shuffledInds=goodInds(randperm(length(goodInds)));
            
            shuffleMode=2;
            switch shuffleMode
                case 1
                    d.response(goodInds)=d.response(shuffledInds);
                    d.correct(goodInds)=unShuffledCorrectAnswerID(goodInds)==d.response(goodInds); % recalculate "correct" after shuffled
                    d=addYesResponse(d,[],forceGotoSideToBeDetection); %%recalculate "yes" after shuffle
                case 2
                    % an alternate way that matches %correct of the rat, but less good for hit / fa analysis
                    d.correct(goodInds)=d.correct(shuffledInds);
            end
        else
            if numShuffle>0
                %save to determine the correctness of the suffled data
                unShuffledCorrectAnswerID=d.correctAnswerID;  % will get overwritten only by a new rat
                %only need it if some shuffles happen
            end
        end
        
        
        for j=1:numConditions
            these=conditionInds(j,:);
            numAttempt=sum(these);
            if numAttempt>0
                numCorrect=sum(d.correct(these));
                numYes=sum(d.yes(these));
                numHits=sum(d.correctAnswerID(these)==presentVal & d.correct(these));
                numMisses=sum(d.correctAnswerID(these)==presentVal & ~d.correct(these));
                numCRs=sum(d.correctAnswerID(these)==absentVal & d.correct(these));
                numFAs=sum(d.correctAnswerID(these)==absentVal & ~d.correct(these));
            else
                %set all counts to zero
                [numCorrect numYes numHits numMisses numCRs numFAs]=deal(0);
            end
            
            %save and export for outside use
            params.raw.numCorrect(i,j,1)=numCorrect;
            params.raw.numAttempt(i,j,1)=numAttempt;
            params.raw.numYes(i,j,1)=numYes;
            params.raw.numHits(i,j,1)=numHits;
            params.raw.numMisses(i,j,1)=numMisses;
            params.raw.numCRs(i,j,1)=numCRs;
            params.raw.numFAs(i,j,1)=numFAs;
            
            %save values of the factors for outside use
            %just sample from the first relvant ind
            firstInd=min(find(conditionInds(j,:)));
            if  ~isempty(firstInd)
                switch conditionType
                    case {'16flanks','8flanks','8flanks+','allRelativeTFOrientationMag','8flanks+&nfMix','8flanks+&nfBlock','8flanks+&nfMix&nfBlock','8flanks+&thirds','8flanks+&tenths'}
                        params.factors.targetOrientation(i,j)=d.targetOrientation(firstInd);
                        params.factors.flankerOrientation(i,j)=d.flankerOrientation(firstInd);
                        params.factors.flankerPosAngle(i,j)=d.flankerPosAngle(firstInd);
                    case {'popVsNot'}
                        params.factors.targetOrientation(i,j)=d.targetOrientation(firstInd);
                        params.factors.flankerOrientation(i,j)=d.flankerOrientation(firstInd);
                    case {'colin+3','colin-other','colin+3&nfMix'}
                        params.factors.targetOrientation(i,j)=d.targetOrientation(firstInd);
                        params.factors.flankerOrientation(i,j)=d.flankerOrientation(firstInd);
                        params.factors.flankerPosAngle(i,j)=d.flankerPosAngle(firstInd);
                        params.factors.targetPhase(i,j)=d.targetPhase(firstInd);
                        params.factors.flankerPhase(i,j)=d.flankerPhase(firstInd);
                    case {'colin+3&contrasts','colin+3&blockedContrasts'}
                        params.factors.targetOrientation(i,j)=d.targetOrientation(firstInd);
                        params.factors.flankerOrientation(i,j)=d.flankerOrientation(firstInd);
                        params.factors.flankerPosAngle(i,j)=d.flankerPosAngle(firstInd);
                        params.factors.targetPhase(i,j)=d.targetPhase(firstInd);
                        params.factors.flankerPhase(i,j)=d.flankerPhase(firstInd);
                        params.factors.targetContrast(i,j)=d.targetContrast(firstInd);
                    case {'allPhases','3phases'}
                        params.factors.flankerPhase(i,j)=d.flankerPhase(firstInd);
                        params.factors.targetPhase(i,j)=d.targetPhase(firstInd);
                    case {'allDevs'}
                        params.factors.deviation(i,j)=d.deviation(firstInd);
                    case {'colin+3&devs','colin+1&devs','2flanks&devs'}
                        params.factors.targetOrientation(i,j)=d.targetOrientation(firstInd);
                        params.factors.flankerOrientation(i,j)=d.flankerOrientation(firstInd);
                        params.factors.flankerPosAngle(i,j)=d.flankerPosAngle(firstInd);
                        params.factors.targetPhase(i,j)=d.targetPhase(firstInd);
                        params.factors.flankerPhase(i,j)=d.flankerPhase(firstInd);
                    case {'allFlankerContrasts','fiveFlankerContrasts','noFlank&nfBlock','noFlank','flankOrNot','hasFlank&nfMix&nfBlock','fiveFlankerContrastsFullRange'}
                        params.factors.flankerContrast(i,j)=d.flankerContrast(firstInd);
                    case {'allTargetContrasts','blockIDsByTargetContrast'}
                        params.factors.targetContrast(i,j)=d.targetContrast(firstInd);
                    case {'allPhantomTargetContrastsCombined'}
                        params.factors.phantomTargetContrastCombined(i,j)=d.phantomTargetContrastCombined(firstInd);
                    case {'allPixPerCycs&PhantomContrast'}
                        params.factors.phantomTargetContrastCombined(i,j)=d.phantomTargetContrastCombined(firstInd);
                        params.factors.pixPerCycs(i,j)=d.pixPerCycs(firstInd);
                    case {'allBlockIDs','allBlockSegments'}
                        params.factors.blockID(i,j)=d.blockID(firstInd);
                        %params.factors.targetContrast(i,j)=max(d.targetContrast(firstInd),d.phantomContrast(firstInd)); %%temp
                        params.factors.targetContrast(i,j)=max(d.targetContrast(find(conditionInds(j,:))));

                        params.factors.flankerContrast(i,j)=d.flankerContrast(firstInd);
                        params.factors.SOA(i,j)=round(100*(d.actualFlankerOnsetTime(firstInd)-d.actualTargetOnsetTime(firstInd))) ;
                    case {'allBlockIDs&2Phases'}
                        params.factors.blockID(i,j)=d.blockID(firstInd);
                        params.factors.targetContrast(i,j)=max(d.targetContrast(firstInd),d.phantomContrast(firstInd));
                        params.factors.flankerContrast(i,j)=d.flankerContrast(firstInd);
                        params.factors.alignedPhase(i,j)=d.flankerPhase(firstInd)==d.targetPhase(firstInd);
                    case {'allSOAs'}
                        params.factors.actualTargetOnsetTime(i,j)=d.actualTargetOnsetTime(firstInd);
                        params.factors.actualFlankerOnsetTime(i,j)=d.actualFlankerOnsetTime(firstInd);
                        params.factors.SOA(i,j)=round(100*(d.actualFlankerOnsetTime(firstInd)-d.actualTargetOnsetTime(firstInd))) ;
                    otherwise
                        conditionType
                        error('factors not listed yet for that conditionType')
                end
            else
                warning(sprintf('%s has no trials for condtion %d, putting nans in record',subjects{i},j))
                params.factors.targetOrientation(i,j)=nan;
                params.factors.flankerOrientation(i,j)=nan;
                params.factors.flankerPosAngle(i,j)=nan;
                params.factors.targetPhase(i,j)=nan;
                params.factors.flankerPhase(i,j)=nan;
                params.factors.targetContrast(i,j)=nan;
            end
            
            for k=1:numStats
                switch statTypes{k}
                    case 'pctCorrect'
                        [stats(i,j,k)  CI(i,j,k,:)]=binofit(numCorrect,numAttempt);
                    case {'dpr'}
                        stats(i,j,k)=dprime(d.response(conditionInds(j,:)),d.correctAnswerID(conditionInds(j,:)),'presentVal',presentVal,'absentVal',absentVal,'silent');
                        CI(i,j,k,:)=nan;
                    case {'crit'}
                        
                        [junk more]=dprime(d.response(conditionInds(j,:)),d.correctAnswerID(conditionInds(j,:)),'presentVal',presentVal,'absentVal',absentVal,'silent');
                        stats(i,j,k)= -(norminv(more.hitsPercent/100)+norminv(more.falseAlarmsPercent/100))/2;  %cr =-(norminv(h)+norminv(f))/2;
                        CI(i,j,k,:)=nan;
                        
                    case {'criterionMCMC', 'biasMCMC', 'dprimeMCMC','pctCorrectMCMC'}
                        stats(i,j,k)=nan;
                        CI(i,j,k,:)=nan;
                    case 'yes'
                        [stats(i,j,k)  CI(i,j,k,:)]=binofit(numYes,numAttempt);
                    case 'hits'
                        [stats(i,j,k)  CI(i,j,k,:)]=binofit(numHits,numHits+numMisses);
                    case 'CRs'
                        [stats(i,j,k)  CI(i,j,k,:)]=binofit(numCRs,numCRs+numFAs);
                    case 'FAs'
                        [stats(i,j,k)  CI(i,j,k,:)]=binofit(numFAs,numCRs+numFAs);
                    case 'RT'
                        [params.RT.mean(i,j,1:numRTcategories) params.RT.std(i,j,1:numRTcategories) params.RT.fast(i,j,1:numRTcategories) params.RT.CI(i,j,1:numRTcategories,1:2) names.rtCategories params.RT.raw{i,j}]=getResponseStats(d,these,rtCategories);
                        stats(i,j,k)=params.RT.fast(i,j,find(strcmp('no',names.rtCategories)))-params.RT.fast(i,j,find(strcmp('yes',names.rtCategories)));
                        CI(i,j,k,:)=nan;
                    otherwise
                        statTypes{k}
                        error('bad stat request')
                end
            end
            
            
        end
    end
end


%only one runs one call to matbugs for all subjects and conditons and statTypes
mcmcRequest=~cellfun('isempty',strfind(statTypes, 'MCMC')); %logical that is true for every statistic that is MCMC-dependent
if any(mcmcRequest)
    
    x.hits=params.raw.numHits(:);
    x.misses=params.raw.numMisses(:);
    x.FAs=params.raw.numFAs(:);
    x.CRs=params.raw.numCRs(:);
    alpha=0.05;
    [sdtCI details]=dprimeCI(x, 'dprimeMCMC', alpha); % run the MCMChain
    
    statInds=find(mcmcRequest);
    numMCMCstats=length(statInds);
    params.mcmc.samples=repmat({nan},[numSubjects numConditions numStats]);  %init?
    for k=1:length(statInds)
        
        switch statTypes{statInds(k)}
            %intially dprime was handled separately and the code
            %successfuly passes chekcs which compared the mean of the
            %MCMCdprime to the dprime as calculated by Michael Silver
            %but now we do not run this check because we do not have codes
            %that provide analytic estimates of criterion, etc. (one day we
            %could)
            %             case  'dprimeMCMC'
            %                 CI(:,:,statInds(k),1)=reshape(sdtCI.d(:,1), numSubjects, numConditions);
            %                 CI(:,:,statInds(k),2)=reshape(sdtCI.d(:,2), numSubjects, numConditions);
            %                 shortStatName='d';
            %
            %                 fractionalError=abs((stats(:,:,statInds(k))-reshape(details.mcmcStats.mean.(shortStatName), numSubjects, numConditions))./stats(:,:,statInds(k)));
            %                 if all(fractionalError<0.01);
            %                     %d prime are within 1% error
            %                 else
            %                     fractionalError
            %                     stats(:,:,statInds(k))
            %                     reshape(dprMean, numSubjects, numConditions)
            %                     error('dprimes from mcmc and standard calculuation don''t match up.')
            %                 end
            
            case {'criterionMCMC',  'biasMCMC', 'dprimeMCMC'}
                switch statTypes{statInds(k)}
                    case  'criterionMCMC'
                        shortStatName='k';
                    case 'biasMCMC'
                        shortStatName='b';
                    case 'dprimeMCMC'
                        shortStatName='d';
                    otherwise
                        error('bad statTypes')
                end
                CI(:,:,statInds(k),1)=reshape(sdtCI.(shortStatName)(:,1), numSubjects, numConditions);
                CI(:,:,statInds(k),2)=reshape(sdtCI.(shortStatName)(:,2), numSubjects, numConditions);
                
                stats(:,:,statInds(k))=reshape(details.mcmcStats.mean.(shortStatName), numSubjects, numConditions);
                
                %save the raw chain
                %samples has the same format as statsMatrix (i=subject,j=condition,k=statType)
                for i=1:numSubjects
                    for j=1:numConditions
                        %subjects{i}
                        %names.conditions{j}
                        %statTypes{statInds(k)}
                        indTo =sub2ind([numSubjects numConditions numStats],i,j,statInds(k));
                        indFrom = sub2ind([numSubjects numConditions],i,j);
                        %x.hits(indFrom)==params.raw.numHits
                        %                         indTo
                        %                         indFrom
                        %                         pause
                        params.mcmc.samples{indTo}=details.samples.(shortStatName)(1,:,indFrom);
                    end
                end
            case 'pctCorrectMCMC'

                for i=1:numSubjects
                    for j=1:numConditions
                        %subjects{i}
                        %names.conditions{j}
                        %statTypes{statInds(k)}
                        indTo =sub2ind([numSubjects numConditions numStats],i,j,statInds(k));
                        indFrom = sub2ind([numSubjects numConditions],i,j);
                        %x.hits(indFrom)==params.raw.numHits
                        %                         indTo
                        %                         indFrom
                        %                         pause
                        pThere=0.5;  % these fractions should be calcualted from the data, not forced
                        pNotThere=1-pThere;  
                        %calculate pct correct from hit rate and false alarm rate...
                        params.mcmc.samples{indTo}=100*(details.samples.h(1,:,indFrom)*pThere)+((1-details.samples.f(1,:,indFrom))*pNotThere);
                        stats(i,j,statInds(k))=median(params.mcmc.samples{indTo});
                    end
                end
                
                
            otherwise
                statTypes{statInds(k)}
                error('bad mcmcStat');
        end
        
        %error check
    end
end

params.stats=stats; %params really have everything