function out = getFact(s,which)

possibleFacts = {'f1','f0','f2','coh'};
if ~iscell(which)
    error('''which'' needs to be a cell')
end
switch length(which{1})
    case 1
        what = which{1}{1};
        vals = 'all';
    case 2
        what = which{1}{1};
        vals = which{1}{2};
    otherwise
        which
        keyboard
        error('too many inputs');
end
params = which{2}; %is this guaranteed to exist?? i think so
if isfield(params,'mode')
    mode = params.mode;
else
    mode = 'errorIfNoValue';
end

% what can be a cell or a char which = {'f1','maxValue'} OR which = {{'f1','f0'},'maxValue'}
switch class(what)
    case 'char'
        what = {what};
    case 'cell'
        % do nothing
    otherwise
        error('dont know what you are asking');
end

out = {}; % out will be a structure

for i = 1:length(what)
    switch what{i}
        case {'f0','f1','f2','coh'}
            out1 = filter(s,what{i},vals,mode);
            if ~isempty(out1)
                out{end+1} = {out1{1} nanmean(out1{2},1)};
            end
        case {'phaseDensity'}
            out1 = filter(s,what{i},vals,mode);
            if ~isempty(out1)
                out{end+1} = {out1{1} radtodeg(nanmean(out1{2},1))};
            end
        case {'phases'}
            error('maybe you want phaseDensity');
        case {'f0SEM','f1SEM','f2SEM','cohSEM'}
            request = what{i};request(end-2:end) = [];
            out1 = filter(s,request,vals,mode);
            if ~isempty(out1)
                temp = out1{2};
                out{end+1} = {out1{1} nanstd(temp,[],1)/sqrt(length(find(~isnan(temp(:,1)))))};
            end
        case 'f1/f0'
            out1 = filter(s,'f1',vals,mode);
            out2 = filter(s,'f0',vals,mode);
            if ~isempty(out1)
                % remove any row where f0 is empty
                out2{2}=out2{2}(~sum(out2{2}==0,2),:);
                out1{2}=out1{2}(~sum(out2{2}==0,2),:);
                out{end+1} = {out1{1} nanmean(out1{2}./out2{2},1)};
            end
        case 'preferredPhase'
        case 'f1Shuffled'
            out1 = filter(s,'f0',vals,mode);
            if ~isempty(out1)
                out{end+1} = {out1{1} nanmean(nanmean(s.f1Shuffled,3),1)};
            end
        case 'degPerPix'
            out1 = s.getDegPerPix;
            out{end+1} = out1;
        case 'peakF1Condition'
            f1 = nanmean(s.f1,1);
            fs = s.getSFs;
            [junk whichSF] = max(f1);
            out{end+1} = fs(whichSF);
        case 'highSFCutoff'
            if ~strcmp(s.getType,'sfGratings')
                error('not supported');
            end
            f1 = nanmean(s.f1,1)-mean(mean(s.f1Shuffled,3),1);
            fs = s.getSFs;
            fsInterp = logspace(log10(min(fs)),log10(max(fs)),1000);
            f1Interp = interp1(fs,f1,fsInterp);
            fraction = 1/exp(1);
            whichVal = find(f1Interp-fraction*max(f1)>0,1,'last');
            out{end+1} = fsInterp(whichVal);
        case 'fractionalPowerAtLowSF'
            if ~strcmp(s.getType,'sfGratings')
                error('not supported');
            end
            f1 = nanmean(s.f1,1)-mean(mean(s.f1Shuffled,3),1);
            fs = s.getSFs;
            [junk which] = min(fs);
            out{end+1} = f1(which)/max(f1);            
        otherwise
            error('unsupported ''what''');
    end
end
end