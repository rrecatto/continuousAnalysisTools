function plotModeOfGLM(db)
[aInd nID subAInd]=db.selectIndexTool('gaussianFullField');
close all
aIDs=[1:6 8:10];

% 8: ??? Error using ==> load
% Unable to read file \\132.239.158.158\physdata\231\LFPRecords\LFPRecord_878.mat: No such file or directory.

for i=aIDs
    figure(i);
    for j=1:4
        subplot(2,2,j)
        db.data{nID(i)}.analyses{subAInd(i)}.plotGLM(j);
    end
end
end
