function out = getFftOfSTA(s)
params.mode = 'center';
params.precisionInMS = 1;
params.channels = s.channels;
[sta stv numspikes] = s.getTemporalKernelAtHighPrecision(params);


chrParams.tapers = [2 3];
chrParams.err = [0 0.05];
chrParams.Fs = 1000;
[pSTA freqSTA]= mtspectrumc(sta-127.5,chrParams);

numRepeats = 100;

pSTAAll = nan(numRepeats,length(pSTA));
peakPowerFreq = nan(1,numRepeats);
highFreqCutOff = nan(1,numRepeats);
fractionalPowerAtLowTF = nan(1,numRepeats);
for rep = 1:numRepeats
    % sample from sta
    stasamp = sta+(randn(size(sta)).*stv)/numspikes;
    [pSTASamp freqSTA] = mtspectrumc(stasamp-127.5,chrParams);
    pSTAAll(rep,:) = pSTASamp;
    
    peakPowerFreq(rep) = freqSTA(pSTASamp==max(pSTASamp));
    highFreqCutOff(rep) = freqSTA(find(pSTASamp>0.367879441171442*max(pSTASamp),1,'last'));% 0.367879441171442
    fractionalPowerAtLowTF(rep) = pSTASamp(1)/max(pSTASamp);
end
out.pSTA = pSTA;
out.freqSTA = freqSTA;
out.pSTAMean = mean(pSTAAll,1);
out.pSTASTD = std(pSTAAll,[],1);
out.peakPowerFreq = peakPowerFreq;
out.highFreqCutOff = highFreqCutOff;
out.fractionalPowerAtLowTF = fractionalPowerAtLowTF;
end