function out = estimateErrorOnRF(s,params)
if ~exist('params','var') || isempty(params)
    params.spikeFractions = [0.5 0.75 0.9 0.95 0.99];
    params.numRepeats = [100 100 100 100 100];
end
if length(params.spikeFractions)~=length(params.numRepeats)
    disp('Spike fractions:');
    params.spikeFractions;
    disp('Num Repeats:');
    params.numRepeats;
    
    error('set number of repeats for each spike fraction value');
end

% setup structure size
out(length(params.spikeFractions)).fraction = [];
out(length(params.spikeFractions)).numRepeats = [];
out(length(params.spikeFractions)).numSpikes = [];
out(length(params.spikeFractions)).cenX = [];
out(length(params.spikeFractions)).cenY = [];
out(length(params.spikeFractions)).rX = [];
out(length(params.spikeFractions)).rY = [];

% loop

for i = 1:length(params.spikeFractions)
    fraction = params.spikeFractions(i);
    numRepeats = params.numRepeats(i);
    fitParams = struct;
    
    % initialize values
    out(i).fraction = fraction;
    out(i).numRepeats = numRepeats;
    out(i).numSpikes = nan(1,numRepeats);
    out(i).cenX = nan(1,numRepeats);
    out(i).cenY = nan(1,numRepeats);
    out(i).rX = nan(1,numRepeats);
    out(i).rY = nan(1,numRepeats);
    
    analysisParams.fraction = fraction;
    analysisParams.channels = getChannels(s);
    repBar = waitbar(0,'%offractions done');
    for j = 1:numRepeats
        waitbar(j/numRepeats,repBar,sprintf('fraction %d of %d : %2.2f % done',i,length(params.spikeFractions),(j-1)/numRepeats*100));
        [sta stv numSpikes] = reAnalyzeUsingFractionOfSpikes(s,analysisParams);
        fitParams.inputSTA = sta;
        [cenX cenY rX rY] = getRFCentreAndSize(s,fitParams);
        out(i).cenX(j) = cenX;
        out(i).cenY(j) = cenY;
        out(i).numSpikes(j) = numSpikes;
        out(i).rX(j) = rX;
        out(i).rY(j) = rY;
    end
    close(repBar);
end


end