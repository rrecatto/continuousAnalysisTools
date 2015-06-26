function plotRawSamples(db,nID,aID,offset,timeRangeSec)
%specifically plots the flanker samples
%nID=10;                    % neural ID
%aID=2;                     % analysis ID
%offset=0.4;                % Yaxis spacing in Volts
%timeRangeSec=[9.125 9.3];  % time plotted
%plotRawSamples(db,nID,aID,offset,timeRangeSec)

ao=db.data{nID}.analyses{aID};

%figure out num trials
n=length(ao.trials);

[sp fr]=ao.getSpikes;

hold on
chunk=1;
chunkName=['chunk' num2str(chunk)];
for i=1:n
    disp(sprintf('plotting %d of %d',i,n))
    ND=ao.getNeuralData(i);
    
    frInds=find(fr.chunkIDForCorrectedFrames==chunk & fr.trialNumForCorrectedFrames==ao.trials(i));
    startInd=fr.correctedFrameIndices(frInds(1),1);
    ss=startInd+ND.samplingRate*timeRangeSec(1);
    ee=startInd+ND.samplingRate*timeRangeSec(2);
    plot((-offset*i)+ND.(chunkName).neuralData(ss:ee,3),'k')
end
end
