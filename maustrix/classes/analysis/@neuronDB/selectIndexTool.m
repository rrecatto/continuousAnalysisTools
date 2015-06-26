function [aInd nID subAInd]=selectIndexTool(db,which,params)
%[aInd nID subAInd]=db.selectIndexTool('lastNeuron');
if ~exist('params','var')||isempty(params)
    params = struct;
end
x=db.getFlatFacts({'included','analysisType'});

switch class(which)
    case 'char'
        switch which
            case 'lastNeuron'
                whichLogical=x.neuronID==db.neuronID(end);
                aInd=find(whichLogical)';
                nID=x.neuronID(whichLogical)';
                subAInd=1:length(nID);
            case 'lastAnalysis'
                whichLogical= logical(zeros(1,db.numAnalyses)'); whichLogical(end)=1;
                aInd=find(whichLogical);
                nID=x.neuronID(whichLogical)';
                subAInd=sum(x.neuronID==db.neuronID(end));
            case 'oneNeuron'
                error('not yet')
            case 'oneAnalysis'
                error('not yet')
            case {'all','main'}
                whichLogical= logical(ones(1,db.numAnalyses)');
                aInd=find(whichLogical)';
                nID=x.neuronID(whichLogical)';
                temp=1:db.numAnalyses;
                counter=1;
                for i=1:db.numNeurons
                    %subtract off of a ramp to calculate the Nth analysis per neuron
                    numThis=sum(x.neuronID==i);
                    temp(counter+numThis:end)=temp(counter+numThis:end)-numThis;
                    counter=counter+numThis;
                end
                subAInd=temp;
            case 'NtIncluded'
                error('not yet')
            otherwise
                if ismember(which,x.analysisType);
                    whichLogical=ismember(x.analysisType,which);
                    [aInd nID subAInd]=selectIndexTool(db,'all');
                    aInd=aInd(whichLogical);
                    nID=nID(whichLogical);
                    subAInd=subAInd(whichLogical);
                else
                    which
                    x.analysisType
                    error('bad selection ... must be a known type or an available analysis')
                end
        end
    case {'uint8','uint16','double'}
        if ~all(ismember(which,db.neuronID))
            error('must be a valid neuron in the database')
        else
            neuronsSelected=which;
        end
        whichLogical= ismember(x.neuronID,neuronsSelected);
        aInd=find(whichLogical)';
        nID=x.neuronID(whichLogical)';
        subAInd=[];
        for i=1:length(neuronsSelected)
            subAInd=[subAInd 1:sum(nID==neuronsSelected(i))];
        end
    otherwise
        error('must be a char of known type or a vector of  valid neuron IDs')
end

% how are we going to use params here? here is a use case.
whichLogical = true(1,length(aInd));
paramFields = fieldnames(params);
if ismember('includeNIDs',paramFields)
    whichLogical = whichLogical & ismember(nID,params.includeNIDs);
end
if ismember('excludeNIDs',paramFields)
    whichLogical = whichLogical & ~ismember(nID,params.excludeNIDs);
end
if ismember('deleteDupIDs',paramFields)&&params.deleteDupIDs
    uniqID = unique(nID);
    for i = 1:length(uniqID)
        locs = find(nID==uniqID(i));
        if length(locs)>1
            whichLogical(locs(2:end)) = false;
        end
    end
end
nID = nID(whichLogical);
subAInd = subAInd(whichLogical);
aInd = aInd(whichLogical);



%             if ~exist('indices','var') || isempty(indices)
%                 indices=nID;
%             else
%                 error('selection not handled yet... see code below')
%             end

%             which=zeros(1,db.numAnalyses);
%             if all(indices>0)
%                 which(indices)=1;
%             elseif all(indices<0)
%                 which(end+indices)=1;
%             elseif indices==0 & length(indices)==1
%                 % do none
%             elseif isInf(indices) & length(indices)==1
%                 which=ones(1,db.numAnalyses);
%             else
%                 error('indices must be 0, Inf, all positive or all negative')
%             end
%
%             out=find(which);
end