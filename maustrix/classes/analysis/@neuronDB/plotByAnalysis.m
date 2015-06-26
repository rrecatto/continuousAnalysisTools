function varargout = plotByAnalysis(db,which)
varargout = {};
figList = [];

figForAn = [];
axForAn = [];

%which = 'sfGratings' OR
%which = {'sfGratings','f1'} OR
%which = {{'sfGratings','f1'},params}

%% error check which
switch class(which)
    case 'char' %(which = 'sfGratings')
        which = which;
        plotRequested = 'default';
        params = struct;
    case 'cell'
        if(length(which))>2
            error('make sure you understand the request format');
        end
        switch class(which{1})
            case 'char' %(which = {'sfGratings','f1'})
                plotRequested = which{2};
                which = which{1};
                params = struct;
            case 'cell' %{{'sfGratings','f1'},params}
                params = which{2};
                plotRequested = which{1}{2};
                which = which{1}{1};
            otherwise
                error('unknown input');
        end
    otherwise
        error('unsupported input format');
end
% we now have params, which and requested plot
% parse params and split it in the relevant way
if ~isstruct(params)
    error('params should be a structure');
end
selectionParams = struct;
paramFields = fieldnames(params);
if ismember('includeNIDs',paramFields)
    selectionParams.includeNIDs = params.includeNIDs;
    params = rmfield(params,'includeNIDs');
end
if ismember('excludeNIDs',paramFields)
    selectionParams.excludeNIDs = params.excludeNIDs;
    params = rmfield(params,'excludeNIDs');
end
if ismember('deleteDupIDs',paramFields)
    selectionParams.deleteDupIDs = params.deleteDupIDs;
    params = rmfield(params,'deleteDupIDs');
end
[aInd nID subAInd]=selectIndexTool(db,which,selectionParams);
facts=db.getFlatFacts({'analysisType'});

%choose a reasonable size to work at
n=length(subAInd);
if isfield(params,'cosyneMode')
    arrangementParams.mode = params.cosyneMode;
    arrangementParams.maxAxesPerFig = 30;
else
    arrangementParams.mode = 'maxAxesPerFig';
    arrangementParams.maxAxesPerFig = 20;
end
[x,y,numFigs] = getGoodArrangement(n,arrangementParams);
%             if n>10
%                 x=5; y=5;  % look at a bunch of things
%             else
%                 x=2; y=3;  % look at one thing
%             end
numSubPerFig=x*y;
%             numFigs=ceil(n/numSubPerFig);

what=which; % this could involve some more logic here...
%-grouping spatial types.
%-overriding what gets passed to analysis

switch upper(plotRequested)
    case {'SPATIALMOVIEFRAMES','POWERSPECTRA'}
        useSeparateFigs = true;
    otherwise
        useSeparateFigs = false;        
end

if useSeparateFigs
    for i = 1:n
        f = figure;
        figList(end+1) = f;
        params.nID = nID(i); % sometimes need to send in current neuron Number
        db.data{nID(i)}.analyses{subAInd(i)}.plot2fig(f,{plotRequested,params});
    end
else
    for j=1:numFigs
        f=figure;
        if isfield(params,'cosyneMode')
            set(f,'Position',[360 32 327 890]);
        end
        figList(end+1) = f;
        for k=1:numSubPerFig
            ind=(j-1)*numSubPerFig+k;
            if ind<=n
                ax=subplot(x,y,k);
                if isfield(params,'plotAnesthDifferently')
                    if (db.data{nID(ind)}.analyses{subAInd(ind)}.getAnesthesia==0)
                        params.color = [0 0 1];
                    else
                        params.color = [1 0 0];
                    end
                end
                db.data{nID(ind)}.analyses{subAInd(ind)}.plot2ax(ax,{plotRequested,params});
                figForAn(end+1) = f;
                axForAn(end+1) = ax;
                if ~isfield(params,'cosyneMode')
                    titleName=sprintf('n%d %s',nID(ind),facts.analysisType{aInd(ind)});
                    title(titleName)
                end
            end
        end
    end
end
figListDetail.nID = nID;
figListDetail.subAInd = subAInd;
figListDetail.figForAn = figForAn;
figListDetail.axForAn = axForAn;
varargout = {figList figListDetail};
end
