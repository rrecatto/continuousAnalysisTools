function full=getFlatFacts(db,facts)
if ~exist('facts','var') || isempty(facts)
    facts={'analysisType','thresholdVoltage','quality','included'};
end

%init
for j=1:length(facts)
    full.(facts{j})=[];
end

factsPlus=[facts 'neuronID'];
%collect
if ~isempty(db.data)
    for i=1:db.numNeurons
        this=db.data{i}.getAnalysisFacts(facts);
        numAnalyses=length(this.(facts{1}));
        this.neuronID=repmat(db.neuronID(i),1,numAnalyses);
        for j=1:length(factsPlus)
            if i==1
                full.(factsPlus{j})=[this.(factsPlus{j})(:)];
            else
                full.(factsPlus{j})=[full.(factsPlus{j})(:); this.(factsPlus{j})(:)];
            end
        end
    end
else
    error('no data to get facts from... this can happen if the class constructor for single unit is broken')
end
end