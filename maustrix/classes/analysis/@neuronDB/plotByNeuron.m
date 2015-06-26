function varargout = plotByNeuron(db,what,which) % ('unit',[1:8]) or ('tfGrating',[1:18]) or ('sfGrating',[2 5 8])
hans = [];
if nargin==2
    which = what;
    what = {'unit'};
end
if ischar(which)&&strcmp(which,'all')
    which = 1:db.numNeurons;
end
if ischar(what)
    what ={what};
end

%this set up plots per unit, for those who want it
N=length(which);
[xx yy]=getGoodArrangement(N);

for i = 1:length(what)
    switch what{i}
        case 'unit'
            for j = 1:length(which)
                hans(end+1) = figure;
                plot(db.data{which(j)},hans(end));
            end
        case {'tfGrating','sfGrating','gaussianFullField','binarySpatial'}
            hans(end+1) = figure;
            for j = 1:length(which)
                axhan = subplot(xx,yy,j);
                plot(getAnalysis(db.data{which(j)},what{i}),axhan);
            end
        case 'isi'
            hans(end+1) = figure;
            for j = 1:length(which)
                axhan = subplot(xx,yy,j);
                db.data{which(j)}.plotISI;
                if i~=1
                    set(gca,'ytick',[],'xtick',[])
                end
                title(sprintf('neuron %d',db.neuronID(which(j))))
            end
        otherwise
            error('bad request')
    end
end
varargout{1} = hans;
end
