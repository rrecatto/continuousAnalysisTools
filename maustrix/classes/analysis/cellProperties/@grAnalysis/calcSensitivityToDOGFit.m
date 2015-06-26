function s = calcSensitivityToDOGFit(s,params)
if ~exist('params','var')||isempty(params)
    params.sensitivitySearchMethod = 'ExhaustiveParamSpace';
end

% only fit for SFGratings
if ~strcmp(getType(s),'sfGratings')
    error('can only run this model on an SF gratings analysis');
end
% obtain the f1 and the fs
F1 = mean(s.f1,1);
F1SEM = s.f1SEM;
conversion = getDegPerPix(s); % degrees/pix
FS = 1./(conversion*(s.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
minF1 = min(F1);
model = s.model.DOGFit;
fitSensitivity = {};
switch params.sensitivitySearchMethod
    case 'ExhaustiveParamSpace'
        for currAlgoNum = 1:length(model.fitValues)
            
            chosenRFCurr = model.fitValues{currAlgoNum}.chosenRF;
            searchRangeScale = 2;
            
            fitSensitivityCurr.sensitivitySearchMethod = params.sensitivitySearchMethod;
            fitSensitivityCurr.baseRF = chosenRFCurr;
            fitSensitivityCurr.searchRangeScale = searchRangeScale;
            
            % get a log scale around current values and use this to get a fit
            rf.RC = logspace(log10(chosenRFCurr.RC/searchRangeScale),log10(searchRangeScale*chosenRFCurr.RC),25);
            rf.RS = logspace(log10(chosenRFCurr.RS/searchRangeScale),log10(searchRangeScale*chosenRFCurr.RS),25);
            rf.KC = logspace(log10(chosenRFCurr.KC/searchRangeScale),log10(searchRangeScale*chosenRFCurr.KC),25);
            rf.KS = logspace(log10(chosenRFCurr.KS/searchRangeScale),log10(searchRangeScale*chosenRFCurr.KS),25);
            
            stim.FS = FS;
            stim.m = 0.5;
            stim.c = 1;
            
            
            temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
            
            f1s = temp.f1;
            clear temp;
            
            fvals = nan(length(rf.RC),length(rf.RS),length(rf.KC),length(rf.KS));
            
            f1 = F1-minF1;
            
            for i = 1:length(rf.RC)
                fprintf('param num %d of %d\n',i,length(rf.RC));
                for j = 1:length(rf.RS)
                    for k = 1:length(rf.KC)
                        for l = 1:length(rf.KS)
                            f1Fit = squeeze(f1s(i,j,k,l,:));
                            fvals(i,j,k,l) = sum((makerow(f1Fit)-makerow(f1)).^2)/sum(f1.^2);
                        end
                    end
                end
            end
            fitSensitivityCurr.rf = rf;
            fitSensitivityCurr.fvals = fvals;
            fitSensitivity{currAlgoNum} = fitSensitivityCurr;
        end
    otherwise
        error('unknown sensitivity search method');
end
if isfield(s.model.DOGFit,'fitSensitivity')
    s.model.DOGFit.fitSensitivity = {s.model.DOGFit.fitSensitivity;fitSensitivity};
else
    s.model.DOGFit.fitSensitivity = fitSensitivity;
end


end