function out = getFacts(db,which)
%which = {'gaussianFullField','timeToMaxDev'} OR
%which = {{'sfGratings','f1'},params}

%% error check which
switch class(which)
    case 'char' %(which = 'sfGratings')
        error('there are no default calls to this method');
    case 'cell'
        if(length(which))>2
            error('make sure you understand the request format');
        end
        switch class(which{1})
            case 'char' %(which = {'sfGratings','f1'})
                requestedFact = which{2};
                which = which{1};
                params = struct;
            case 'cell' %{{'sfGratings','f1'},params}
                params = which{2};
                requestedFact = which{1}{2};
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
out = struct;%cell(1,length(aInd));
out.results = cell(1,length(aInd));
for i=1:length(aInd)
%     keyboard
    out.results{i} = db.data{nID(i)}.analyses{subAInd(i)}.getFact({requestedFact,params});
end
out.nID = nID;
out.aInd = aInd;
out.subAInd = subAInd;

end