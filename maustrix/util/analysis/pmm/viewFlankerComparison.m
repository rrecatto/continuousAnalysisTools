function [delta CI deltas CIs]=viewFlankerComparison(names,params,cMatrix,statTypes,subjects,diffEdges,alpha,doFigAndSub,addTrialNums,addNames,...
    multiComparePerPlot, objectColors, displaySignificance,labelAxis,encodeSideRule,viewPopulationMeanAndCI,yScaling,padFraction)
% params- from getFlankerStats
% names-  from getFlankerStats
% cMatrix- cell array 2xN numberComparison  example with N=1 comparison:
%   {[1],[2 3 4]} compares the 1st to the 2nd to 4th conditions lumped together
%   note: if using any MCMC stats, only one condition can be compared to
%   another (no group comparisons allowed-- have to define group and rerun ch)
%   defaults to one that makes sense for params.settings.conditionType == 8flanks or colin+3
% statTypes - defaults to the ones in names.stats without dprime
% statTypes - defaults to all ones in names.subjects, (if passed in, subjects must be in this list)
%
% delta - the differences between conditions for all rats combined
% CI    - the confidence interval between conditions for all rats combined
% deltas- the differences for each rat
% CIs   - confidence intervals for each rat
%
%example: [delta CI]=viewFlankerComparison(names,params)



if ~exist('params','var') || isempty(params)
    %usually this is passed in
    %get some default stats to run this code
    [junk1 junk2 names params]=getFlankerStats({'230','233'});
end


if ~exist('subjects','var') || isempty(subjects)
    subjects=names.subjects;
end

if ~exist('statTypes','var') || isempty(statTypes)
    statTypes=names.stats;
    %statTypes=statTypes(~strcmp(statTypes,'dpr')); %remove dprime
end
numStats=size(statTypes,2);


if ~exist('diffEdges','var') || isempty(diffEdges)
    createDefaultDiffEdges=true;
    nBins=10;
    diffEdges=nan(length(statTypes),nBins+1);
    %     minX=-6;
    %     maxX=6;
    %     diffEdges=linspace(minX,maxX,13);
    % else
    %     minX=min(diffEdges);
    %     maxX=max(diffEdges);
else
    createDefaultDiffEdges=false;
    minX=min(diffEdges);
    maxX=max(diffEdges);
    if size(diffEdges,1)==1
        diffEdges=repmat(diffEdges,numStats,1)
    end
end

if ~exist('alpha','var') || isempty(alpha)
    alpha=0.05;
end

if ~exist('doFigAndSub','var') || isempty(doFigAndSub)
    doFigAndSub=true;
end

if ~exist('addTrialNums','var') || isempty(addTrialNums)
    addTrialNums=true;
end

if ~exist('addNames','var') || isempty(addNames)
    addNames=false;
else
    if islogical(addNames)
        labeledNames=subjects; %will only be used if addNames = true.
    elseif strcmp(class(addNames),'cell') && length(addNames)==length(subjects)
        labeledNames=addNames; % cell array of strings
        addNames=true;
    else
        error('addNames must be true or false or cell array of strings, length subjects')
    end
end


if ~exist('multiComparePerPlot','var') || isempty(multiComparePerPlot)
    multiComparePerPlot=false;
end

if ~exist('objectColors','var') || isempty(objectColors)
    objectColors.histSig=[.8 0 0];
    objectColors.histInsig=[0 0 0];
    objectColors.subjectSig=[.8 0 0];
    objectColors.subjectInsig=[0 0 0];
end


if ~exist('displaySignificance','var') || isempty(displaySignificance)
    displaySignificance=true;
end

if ~exist('labelAxis','var') || isempty(labelAxis)
    labelAxis=true;
end

if ~exist('encodeSideRule','var') || isempty(encodeSideRule)
    encodeSideRule=true;
end

if ~exist('viewPopulationMeanAndCI','var') || isempty(viewPopulationMeanAndCI)
    viewPopulationMeanAndCI=true;
end


if ~exist('yScaling','var') || isempty(yScaling)
    yScaling=[40 20 20 20];
end
dataFraction=yScaling(1)/sum(yScaling);
gapFraction=yScaling(2)/sum(yScaling);
histFraction=yScaling(3)/sum(yScaling);
basementFraction=yScaling(4)/sum(yScaling);

if ~exist('padFraction','var') || isempty(padFraction)
padFraction=0.05;
end


conditionType=params.settings.conditionType;

if ~exist('cMatrix','var') || isempty(cMatrix)
    switch conditionType
        case 'colin+3'
            cMatrix={[1],[2];
                [1],[3];
                [1],[4];
                [1],[2,3,4];
                [2],[3];};
        case 'colin+3&nfMix'
            cMatrix={[1],[2];
                [1],[4];
                [1],[5]};
        case '8flanks'
            cMatrix={[1 8],[2 7];
                [1 8],[3 6];
                [1 8],[4 5];
                [1 8],[2:6];};
        case '8flanks+'
            cMatrix={[9],[10];
                [9],[12]};
        case {'8flanks+&nfBlock','8flanks+&nfMix'}
            cMatrix={[9],[10];
                [9],[14];
                [10],[14]};
        case {'noFlank&nfBlock'}
            cMatrix={[1],[2]};
        case {'colin+1&devs','2flanks&devs'}
            dimming=fliplr([1:4]/5)';
            cMatrix={[1],[2];
                [3],[4];
                [5],[6];
                [7],[8]};
            comparisonColor=dimming*[1 0 0];
            %             cMatrix={[1],[8];
            %                 [3],[8];
            %                 [5],[8];
            %                 [7],[8];
            %                 [2],[8];
            %                 [4],[8];
            %                 [6],[8];
            %                 [8],[8]};
            %             comparisonColor=[dimming*[1 0 0]; dimming*[0 1 1]];
        case 'allBlockIDs&2Phases'
            ids=unique(params.factors.blockID);
            for i=1:length(ids)
                cMatrix{i,1}=i;
                cMatrix{i,2}=i+length(ids);
            end
        case 'colin+3&blockedContrasts'
              cMatrix={[1],[2];
                [5],[6];
                [9],[10];
                [13],[14];};
        otherwise
            conditionType
            error('this condition type has no default comparisons -- the must be specified in 3rd arg in ')
    end
end

numSubjects=length(subjects);
numComparison=size(cMatrix,1);

if ~exist('comparisonColor','var') || isempty(comparisonColor)
    comparisonColor=jet(numComparison);
end

if doFigAndSub
    figure
end

if numStats==1 || (multiComparePerPlot)
    squareStats=true
    %fill up a square of subplots
    disp('since only one stat or multiComparePerPlot, making a square marix of plots')
    disp('rather than ploting numComparisions x numStats')
else
    squareStats=false
    %force each stat to be colum, with rows being the same comparisoon and
    %different stats
end

CIs=zeros(numComparison,numStats,numSubjects,2);
deltas=zeros(numComparison,numStats,numSubjects);
numSamples=zeros(numComparison,numStats,numSubjects);

for k=1:numSubjects
    
    subjectInd=find(strcmp(subjects{k},names.subjects))';
    more.hits=params.raw.numHits(subjectInd,:)';
    more.misses=params.raw.numMisses(subjectInd,:)';
    more.CRs=params.raw.numCRs(subjectInd,:)';
    more.FAs=params.raw.numFAs(subjectInd,:)';
    more.numAttempted=params.raw.numAttempt(subjectInd,:)';
    more.numCorrect=params.raw.numCorrect(subjectInd,:)';
    
    for i=1:size(cMatrix,1)
        for j=1:size(statTypes,2)
            statInd=find(strcmp(statTypes{j},names.stats));
            switch statTypes{j}
                case {'pctCorrect', 'yes', 'hits', 'CRs','FAs'}
                    [deltas(i,j,k) CIs(i,j,k,1:2) numSamples(i,j,k)] = compareAtoBbinofit(more,cMatrix{i,1},cMatrix{i,2},statTypes{j},alpha);
                    deltas(i,j,k)=deltas(i,j,k)*100;
                    CIs(i,j,k,1:2)=CIs(i,j,k,1:2)*100;
                    xlabelStrings{j}=sprintf('change in %s',statTypes{j});
                case {'distanceROC'}
                    if all(ismember({'hits','CRs'},names.stats))
                        [a aCI ns(1)] = compareAtoBbinofit(more,cMatrix{i,1},cMatrix{i,2},'hits',alpha);
                        [b bCI ns(2)] = compareAtoBbinofit(more,cMatrix{i,1},cMatrix{i,2},'CRs',alpha);
                        
                        er=100*sqrt(diff(aCI)^2+diff(bCI)^2)/2; %the diagonal CI in each direction
                        deltas(i,j,k)=100*sqrt(a^2+b^2);
                        CIs(i,j,k,1:2)=deltas(i,j,k)+[-er er];
                        numSamples(i,j,k)=min(ns); %just keeping num samples from the smaller comparison
                        xlabelStrings{j}=sprintf('change in %s',statTypes{j});
                    else
                        error('distanceROC needs both hits and CRs... and needs to be defined after both for now')
                    end
                case {'dpr','RT','crit'}
                    
                    deltas(i,j,k)=...
                        mean(params.stats(k,cMatrix{i,1},statInd))-... %difference
                        mean(params.stats(k,cMatrix{i,2},statInd));%works on the average of the statistics, not a weighed average
                    
                    %                      deltas(i,j,k)=log(...     %beware: if negative dprime, log ratio gets imaginary numbers
                    %                         mean(params.stats(k,cMatrix{i,1},statInd))./...%log ratio
                    %                         mean(params.stats(k,cMatrix{i,2},statInd)));%works on the average of the statistics, not a weighed average
                    
                    CIs(i,j,k,1:2)=0; %nan, 0 condiders all significant, nan = none significant... should use MCMC for significance
                    numSamples(i,j,k)=sum(more.numAttempted([cMatrix{i,1} cMatrix{i,2}])); %unknown
                    xlabelStrings{j}=sprintf('change in %s',statTypes{j});
                case {'dprimeMCMC'}
                    
                    if size(cMatrix{i,1},2)>1 || size(cMatrix{i,2},2)>1
                        a=cMatrix{i,1}
                        b=cMatrix{i,2}
                        conditionType
                        names.conditions
                        error('dprime can only compare single conditions, not groups-- you may need a new grouped condition')
                    end
                    
                    
                    theDiff=params.mcmc.samples{subjectInd,cMatrix{i,1},statInd}-params.mcmc.samples{subjectInd,cMatrix{i,2},statInd};
                    deltas(i,j,k)=median(theDiff);
                    sorted=sort(theDiff);
                    ciInds=round(size(sorted,2).*[alpha/2 1-alpha/2]);
                    CIs(i,j,k,1:2)=sorted(ciInds);
                    numSamples(i,j,k)=sum(more.numAttempted([cMatrix{i,1} cMatrix{i,2}]));
                    xlabelStrings{j}=sprintf('difference of %s',statTypes{j});
                    
                    %                     sampleRatio=params.mcmc.samples{k,cMatrix{i,1},statInd}./params.mcmc.samples{k,cMatrix{i,2},statInd};
                    %                     if any(sampleRatio<0)
                    %                         find(sampleRatio<0)
                    %                         sum(sampleRatio<0)
                    %                         error('log of negatives will cause complex numbers')
                    %                     end
                    %                     logSampleRatio=log(sampleRatio);
                    %                     deltas(i,j,k)=median(logSampleRatio);
                    %                     sorted=sort(logSampleRatio);
                    %                     ciInds=round(size(sorted,2).*[alpha 1-alpha]);
                    %                     CIs(i,j,k,1:2)=sorted(ciInds);
                    %                     numSamples(i,j,k)=sum(more.numAttempted([cMatrix{i,1} cMatrix{i,2}]));
                    %                     xlabelStrings{j}=sprintf('log ratio of %s',statTypes{j});
                case {'biasMCMC', 'criterionMCMC','pctCorrectMCMC'}
                    
                    %param2==B minus param1==A just like in
                    %diffOfBino...WRONG! --> compareAtoBbinofit flips it
                    %back to the sensible A-B
                    sampleDiff=params.mcmc.samples{k,cMatrix{i,1},statInd}-params.mcmc.samples{k,cMatrix{i,2},statInd};
                    deltas(i,j,k)=median(sampleDiff);
                    sorted=sort(sampleDiff);
                    ciInds=round(size(sorted,2).*[alpha 1-alpha]);
                    CIs(i,j,k,1:2)=sorted(ciInds);
                    numSamples(i,j,k)=sum(more.numAttempted([cMatrix{i,1} cMatrix{i,2}]));
                    xlabelStrings{j}=sprintf('change in %s',statTypes{j});
                    
                    %figure; hist(sampleDiff,100);  xlabel('p1-p2'); ylabel('count');
                    %title(sprintf('one rat- all %d samples  [%2.2f %2.2f]',length(sampleDiff),sorted(ciInds)));
                    %set(gca,'xtickLabel',[-5 -2.5 0 ],'xtick',[-5 -2.5 0 ],'yTick',[0 20 40], 'yTickLabel',[0 20 40])
                    %cleanUpFigure
                otherwise
                    statTypes{j}
                    error('bad type');
            end
        end
        
        %generate name
        Aname=[cell2mat([names.conditions(cMatrix{i,1})]') repmat('&',length(cMatrix{i,1}),1)]';
        Aname=Aname(1:end-1);
        Bname=[cell2mat([names.conditions(cMatrix{i,2})]') repmat('&',length(cMatrix{i,2}),1)]';
        Bname=Bname(1:end-1);
        comparisonNames{i,1}=sprintf('(%s) - (%s)',Aname,Bname);
        
    end
end

%combined analysis
combined.hits=sum(params.raw.numHits,1)';
combined.misses=sum(params.raw.numMisses,1)';
combined.CRs=sum(params.raw.numCRs,1)';
combined.FAs=sum(params.raw.numFAs,1)';
combined.numAttempted=sum(params.raw.numAttempt,1)';
combined.numCorrect=sum(params.raw.numCorrect,1)';
for i=1:numComparison
    for j=1:numStats
        
        if ~strcmp('distanceROC',statTypes{j})
            %normal populations setup
            statInd=find(strcmp(statTypes{j},names.stats));
            if size(cMatrix{i,1},2)==1 && size(cMatrix{i,2},2)==1
                popStats=...
                    (params.stats(:,cMatrix{i,1},statInd)'-...%difference
                    params.stats(:,cMatrix{i,2},statInd)');   %works on the average of the statistics, not a weighed average
            else
                popStats=...
                    mean(params.stats(:,cMatrix{i,1},statInd)')-...%difference
                    mean(params.stats(:,cMatrix{i,2},statInd)');   %works on the average of the statistics, not a weighed average
            end
        else
            %distanceROC population setup
            if size(cMatrix{i,1},2)==1 && size(cMatrix{i,2},2)==1
                statInd=find(strcmp({'hits'},names.stats)); %to get the second value, b=CRs
                a= (params.stats(:,cMatrix{i,1},statInd)'-...%difference
                    params.stats(:,cMatrix{i,2},statInd)');   %works on the average of the statistics, not a weighed average
                
                statInd=find(strcmp({'CRs'},names.stats)); %to get the second value, b=CRs
                b= (params.stats(:,cMatrix{i,1},statInd)'-...%difference
                    params.stats(:,cMatrix{i,2},statInd)');   %works on the average of the statistics, not a weighed average
                popStats=100*sqrt(a.^2+b.^2);
            else
                error('group comparisons not supported for ROC distance')
            end
        end
        
        switch statTypes{j}
            case {'pctCorrect', 'yes', 'hits', 'CRs','FAs'}
                [delta(i,j) CI(i,j,1:2)]=compareAtoBbinofit(combined,cMatrix{i,1},cMatrix{i,2},statTypes{j},alpha);
                delta(i,j)=delta(i,j)*100;
                CI(i,j,1:2)=CI(i,j,1:2)*100;
                statInd=find(strcmp(statTypes{j},names.stats));
                popStats=100*popStats;
                CI2(i,j,1:2)=mean(popStats) + [-1 1]*std(popStats); % delta+/- stdPop
                %disp(sprintf('uber: %2.2g %2.2g stds: %2.2g %2.2g',CI(i,j,1),CI(i,j,2),CI2(i,j,1),CI2(i,j,2)))
            case {'biasMCMC', 'criterionMCMC','dprimeMCMC','dpr','crit','RT','distanceROC'}
                delta(i,j)=mean(popStats);
                stdPop=std(popStats);
                CI(i,j,1:2)=delta(i,j) + [-stdPop stdPop]; % delta+/- stdPop
                CI2=CI;
            case 'pctCorrectMCMC'
                sampleDiff=[];
                statInd=find(strcmp(statTypes{j},names.stats));
                for k=1:numSubjects
                    %subjectInd=find(strcmp(subjects{k},names.subjects))';
                    sampleDiff=[sampleDiff (params.mcmc.samples{k,cMatrix{i,1},statInd}-params.mcmc.samples{k,cMatrix{i,2},statInd})];
                end
                delta(i,j)=median(sampleDiff);
                sorted=sort(sampleDiff);
                ciInds=round(size(sorted,2).*[alpha/2 1-alpha/2]);
                CI(i,j,1:2)=sorted(ciInds);
                CI2=CI;  
            otherwise
                statTypes{j}
                error('bad type');
        end
        
        [junk sigTTest(i,j)] = ttest(popStats,0,.05,'both');
        sigSignRank(i,j) = signrank(popStats,0);
        [friedmanTest(i,j) table fstats]= friedman(params.stats(:,[cMatrix{i,[1 2]}],statInd),1,'off')
        
        %         %temp hack for mult compare on a known kind
        %         kind=[9 10 11 12];
        %         [junk table fstats]= friedman(params.stats(:,kind,statInd),1,'off');
        %         [c,m,h,nms] = multcompare(fstats,'ctype','hsd','display','off');
        %         kids=sort(find(ismember(kind,[cMatrix{i,[1 2]}])))
        %         comparison=find(c(:,1)==kids(1) & c(:,2)==kids(2));
        %         friedmanTest(i,j)= ~( c(comparison,3)>0 || c(comparison,5)<0) % the ~ makes it mimck a low p value when true and a high one when false
        
        if length(popStats)>=4
            nonNormal(i,j)=lillietest(popStats);
        else
            nonNormal(i,j)=false;  % not enough evidence to test that its non-normal
        end
    end
end


% %test
% combined.hits=(params.raw.numHits)';
% combined.misses=(params.raw.numMisses)';
% combined.CRs=(params.raw.numCRs)';
% combined.FAs=(params.raw.numFAs)';
% combined.numAttempted=(params.raw.numAttempt)';
% combined.numCorrect=(params.raw.numCorrect)';
% for i=1:numComparison
%     for j=1:numStats
%         [d c]=compareAtoBbinofit(combined,cMatrix{i,1},cMatrix{i,2},statTypes{j},alpha);
%     end
% end


%%
whichComparison=[1:numComparison];
numComparison=length(whichComparison);




% pass this control from outside...
for j=1:numStats
    maxBinHeight=0;
    maxBinCount=0;
    if createDefaultDiffEdges
        theseValues=CIs(:,j,:,:);
        thoseValues=deltas(:,j,:);
        edgeValue=max(abs([theseValues(:); thoseValues(:) ]))*1.1;
        if isinf(edgeValue)
            % CI can be inf, then just use the data
            edgeValue=max(abs([ thoseValues(:) ]))*1.1;
        end
        minX=-edgeValue;
        maxX=edgeValue;
        diffEdges(j,:)=linspace(minX,maxX,nBins+1);
    end

    totalFigureHeight=diff([minX maxX]); % maintain sqaurness of numerical values, for later rotation
    %small loop to find maxBinHeight per statistic
    for i=whichComparison
        try
            sigSubjects=sign(CIs(i,j,:,2))==sign(CIs(i,j,:,1));
            sigCount=histc(permute(deltas(i,j,find(sigSubjects==1)),[3 2 1])', diffEdges(j,:)); % make a matrix...
            insigCount=histc(permute(deltas(i,j,find(~sigSubjects)),[3 2 1])', diffEdges(j,:));
            count=[sigCount; insigCount];
        catch
            keyboard
        end
        
        doSubPlot(doFigAndSub,squareStats,multiComparePerPlot,numStats, numComparison,i,j);
        
        maxBinHeight=histFraction*totalFigureHeight;
        if ~multiComparePerPlot
            countVal=count*(maxBinHeight/max(sum(count)));
            %             histHandle=bar(diffEdges(j,1:end-1),countVal(1:end-1),'histc');
            rlabHist(diffEdges(j,:),countVal(:,1:end-1), [objectColors.histSig; objectColors.histInsig]);
        end
        hold on
        plot(minmax(diffEdges(j,:)), [0 0] ,'k'); %always plot black line over plot if hist, black line if no hist
        maxBinCount=max(maxBinCount, max(sum(count)));
        
    end
    
    if multiComparePerPlot
        interComparisonSpace=4;  % how big the gap between comparisions is, in units of one subject gap
        %statSpace=5;
        inds=([1:numComparison]-1)*(numSubjects+interComparisonSpace)+(numSubjects/2);
        %comparisonYVals=maxBinHeight*(1.1+((statSpace*inds)/( (numSubjects+interComparisonSpace)*numComparison )));
        comparisonYVals=totalFigureHeight*(histFraction+gapFraction/2+dataFraction*(inds/max(inds)));
    else
        statSpace=2;
    end
    
    %main loop
    for i=whichComparison
        doSubPlot(doFigAndSub,squareStats,multiComparePerPlot,numStats, numComparison,i,j);
        for k=1:numSubjects
            subjectInd=find(strcmp(subjects{k},subjects))';
            %assign color
            if multiComparePerPlot
                color=comparisonColor(i,:);
            else
                if sign(CIs(i,j,subjectInd,2))==sign(CIs(i,j,subjectInd,1))
                    color=objectColors.subjectSig;
                else
                    color=objectColors.subjectInsig;
                end
            end
            
            %             dateRange=[datenum('21-Jun-2008') datenum('19-Oct-2008')];  %dangerous.  have to validate. try []
            if encodeSideRule
                if ifYesIsLeftRat(subjects{k})%,dateRange)
                    mark= 'o';
                else
                    mark= '^';
                end
            else
                mark= '.'
            end
            
            if multiComparePerPlot
                ind=(i-1)*(numSubjects+interComparisonSpace)+subjectInd;
                %yVal=maxBinHeight*(1.1+((statSpace*ind)/((numSubjects+interComparisonSpace)*numComparison)));
                %yVal=maxBinHeight*(1.1+((statSpace*ind)/((numSubjects+interComparisonSpace)*numComparison)));
                yVal=totalFigureHeight*(histFraction+gapFraction/2+dataFraction*(ind/( (numSubjects+interComparisonSpace)*numComparison )));
            else
                %yVal=maxBinHeight*1.25 +*(1.1+((statSpace*k)/numSubjects));
                yVal=totalFigureHeight*(histFraction+gapFraction/2+dataFraction*(subjectInd/numSubjects));
            end
            
            thisRatsShuffledIDs=cellfun(@(x) ~isempty(x),strfind(names.subjects,[subjects{k} '-']));
            hasShuffledData=any(thisRatsShuffledIDs);
            drawShuffledBound=1;
            if hasShuffledData && drawShuffledBound
                if ismember(statTypes(j),{'pctCorrect', 'yes', 'hits', 'CRs','FAs'})
                    thisStatID=find(strcmp(names.stats,statTypes(j)));
                    shuffledDist=(params.stats(thisRatsShuffledIDs,cMatrix{i,1},thisStatID)-... %A-B
                    params.stats(thisRatsShuffledIDs,cMatrix{i,2},thisStatID))*100;%
                else
                    error('not approved yet for shuffled comparision..check delta method above')
                    %does not need CI, so all stats are prob fine..  but check the *100 for pct, etc
                     shuffledDist=params.stats(thisRatsShuffledIDs,cMatrix{i,1},thisStatID)-... %A-B
                    params.stats(thisRatsShuffledIDs,cMatrix{i,2},thisStatID);%
                end
                shuffledDist=sort(shuffledDist);
                lowTail=ceil(length(shuffledDist)*0.05);  %only does the low tail, else 0.025
                blip=totalFigureHeight*dataFraction/(numSubjects*2);
                %plot(shuffledDist(lowTail([1 1])),yVal+[-blip blip],'color',[0.8 0.8 0.8]);
                fill([shuffledDist(lowTail([1 1])); maxX; maxX],yVal+blip*[-1 1 1 -1],'r','faceColor',[0.9 0.9 0.9],'edgeColor',[0.9 0.9 0.9]);
                %explainShuffleCI(shuffledDist,deltas(i,j,subjectInd))
            
            end
            
            plot([0 0], [0 totalFigureHeight*(1-basementFraction)],'k');
            
            if multiComparePerPlot
                %plot([CIs(i,j,subjectInd,1) CIs(i,j,subjectInd,2)], [yVal yVal], 'color', color);
                %plot(deltas(i,j,subjectInd), yVal,mark, 'markerSize', 7, 'color', color);  % supress per subject
            else
                plot([CIs(i,j,subjectInd,1) CIs(i,j,subjectInd,2)], [yVal yVal], 'color', color);
                thisMark=plot(deltas(i,j,subjectInd), yVal,mark, 'markerSize', 7, 'color', color);
                
                set(thisMark,'Marker',getMarkerSymbolForSubject(subjects(k)));
                if addNames && ismember(labeledNames(k),{'r6','r7'}) 
                    set(thisMark,'MarkerFaceColor',color);  %filled solid
                else
                    set(thisMark,'MarkerFaceColor',[1 1 1]);  %open
                end
            end
            
            
            if addTrialNums
                t=text(maxX, yVal, num2str(numSamples(i,j,subjectInd)));
                set(t, 'HorizontalAlignment', 'right');
            end
            if addNames
                t=text(-maxX*1.05, yVal, labeledNames(k)); %thisMark
                %t=text(maxX*0.9, yVal,
                %sprintf('%s-%s-%d',labeledNames{k},subjects{k},subjectInd)); to test and confrim
                set(t, 'HorizontalAlignment', 'right');
            end
            set(gca, 'TickLength', [0 0]);
            set(gca, 'XTickLabel', []);
        end
        
        %population effect
        if i<=size(CI,1) %only for some comparisons
            
            %assign color
            if multiComparePerPlot
                color=comparisonColor(i,:);
            else
                if sign(CI(i,j,1))==sign(CI(i,j,2))
                    %more lenient thresh: sign(CI(i,j,1))==sign(CI(i,j,2))
                    %stricter thresh: abs(delta(i,j))>(CI(i,j,2)-CI(i,j,1))*(2/2)
                    color=objectColors.subjectSig;
                else
                    color=objectColors.subjectInsig;
                end
            end
            
            if multiComparePerPlot
                populationYVal=comparisonYVals(i);
            else
                populationYVal= -totalFigureHeight*(basementFraction/2);
            end
            
            if viewPopulationMeanAndCI
                %plot([CI(i,j,1) CI(i,j,2)], repmat(populationYVal,1,2), 'color', color,'lineWidth',4); %   population errorbar
                plot([CI2(i,j,1) CI2(i,j,2)], repmat(populationYVal,1,2), 'color', color,'lineWidth',2); %   population std, except MCMC
                plot(delta(i,j), populationYVal, '.', 'markerSize', 7, 'color', color);
            end
            
            forceFriedmans=false;
            if forceFriedmans
                %sigMsg=sprintf('p= %s 1ttt\np= %s ft',prettySciNotation(sigTTest(i,j)) ,prettySciNotation(friedmanTest(i,j) ));
                if friedmanTest(i,j) < 0.05
                    sigMsg='*'
                else
                    sigMsg='';
                end
            else
                if nonNormal(i,j)
                    %show t-test for reference, but include sign rank
                    %sigMsg=sprintf('p= %s 1-tail t-test\np= %s sign rank test',prettySciNotation(sigTTest(i,j)) ,prettySciNotation(sigSignRank(i,j) ));
                    sigMsg=sprintf('p= %s 1ttt\np= %s srt',prettySciNotation(sigTTest(i,j)) ,prettySciNotation(sigSignRank(i,j) ));
                else
                    %t-test is good enough cuz it passed lille test
                    %sigMsg=sprintf('p= %s 1-tail t-test',prettySciNotation(sigTTest(i,j)));
                    %sigMsg=sprintf('p=%s',prettySciNotation(sigTTest(i,j)));
                    sigMsg=sprintf('%s',prettySciNotation(sigTTest(i,j)));
                end
            end
            addLillie=false;
            if addLillie && nonNormal(i,j)
                sigMsg=[sigMsg '-notNorm'];
            end
            
            disp(sigMsg);
            if displaySignificance
                %sigYVal= -totalFigureHeight*(basementFraction*3/4);
                sigYVal= (totalFigureHeight*(gapFraction+histFraction/2));
                
                sigXVal=maxX*.5; %delta(i,j)
                text(sigXVal,sigYVal,sigMsg,'HorizontalAlignment','center')
            end
            
        end
        
        padwidth=totalFigureHeight*padFraction;
        pad=[-padwidth padwidth -padwidth padwidth];
        axis([minX maxX -totalFigureHeight*basementFraction totalFigureHeight*(1-basementFraction)]+pad)
        %rectangle('Position', [ minX-padwidth -totalFigureHeight*basementFraction-padwidth totalFigureHeight+padwidth*2 totalFigureHeight+padwidth*2], 'EdgeColor',[0 1 0])
        if ~multiComparePerPlot
            set(gca, 'YTickLabel', maxBinCount);
            set(gca, 'YTick', maxBinHeight);
        else
            set(gca, 'YTickLabel', comparisonNames);
            set(gca, 'YTick', comparisonYVals);
        end
    end
end

for j=1:numStats
    doSubPlot(doFigAndSub,squareStats,multiComparePerPlot,numStats, numComparison,numComparison,j);
    labeledEdges=[min(diffEdges(j,:)) 0 max(diffEdges(j,:))];
    set(gca, 'XTick', labeledEdges);
    labeledEdgeStrings={num2str(labeledEdges(1),'%2.2g'),num2str(labeledEdges(2),'%2.2g'),num2str(labeledEdges(3),'%2.2g'); };
    set(gca, 'XTickLabel', labeledEdgeStrings);
    
    if labelAxis
        xlabel(xlabelStrings{j});
    end
end

for i=1:numComparison
    if ~multiComparePerPlot
        doSubPlot(doFigAndSub,squareStats,multiComparePerPlot,numStats, numComparison,i,1);
        if labelAxis
            ylabel(comparisonNames{i}); %this is not really the ylabel
        end
        %     else
        %         ylabel()
    end
    %maybe use figure text
end


%subplot(numComparison,numStats,1);
%ylabel('# rats');

%savePlotsToPNG(true,gcf,figName,'C:\Documents and Settings\rlab\Desktop\graphs\');


%peek at some rats
% deltas*100
% i=6; j=1; k=find(strcmp(subjects,'229')); phaseEffect229 = [deltas(i,j,k) (CIs(i,j,k,1)-CIs(i,j,k,2))/2]
% i=4; j=1; k=find(strcmp(subjects,'231')); popoutEffect231= [deltas(i,j,k) (CIs(i,j,k,1)-CIs(i,j,k,2))/2]
% i=1; j=1; collinEffectAll= [delta(i,j) (CI(i,j,2)-CI(i,j,1))/2]
%% summary - combine all rats data




% subplot(1,numStats,j)
% er=(CI(:,j,2)-CI(:,j,1))
% %b=barh(delta(:,j))
% %colormap(gray)
% bar(delta(:,j))
% colormap([.8,.8,.8])
% hold on
% errorbar(delta(:,j),er,'k')
% axis([0 6 -4 4])
% title(statTypes{j})
% set(gca, 'XTickLabel', comparisonNames);
% end
%


function doSubPlot(doFigAndSub,squareStats,multiComparePerPlot,numStats, numComparison,i,j)

if doFigAndSub
    if squareStats
        if multiComparePerPlot
            II=ceil(sqrt(numStats));
            JJ=II-(1)*(II^2-II>=numStats);
            subplot(II, JJ,j);
        else
            II=ceil(sqrt(numComparison));
            JJ=II-(1)*(II^2-II>=numComparison);
            subplot(II, JJ,i);
        end
        
    else
        if multiComparePerPlot
            subplot(1, numStats,j); %this is probably never used
        else
            subplot(numComparison, numStats,(i-1)*numStats+j);
        end
        
    end
end


function string=prettySciNotation(value)

x=num2str(value,'%1.0e');
ind=strfind(x,'e')
sigDigs=x(1:ind-1);
exp=x(ind+1:end);
zeroExpInds=strfind(exp,'0');
sigExp=exp; sigExp(zeroExpInds)=[];
%string=sprintf('%se^{%s}',sigDigs,sigExp);
%string=sprintf('%s x 10^{%s}',sigDigs,sigExp);
string=sprintf('%sx10^{%s}',sigDigs,sigExp);


