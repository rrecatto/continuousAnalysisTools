function [out scale] = errorStim(stimManager,numFrames)
scale=0;
x = double(rand(1,1,numFrames)>.5);
errorStimIsOnlyBlack = true;
if errorStimIsOnlyBlack 
    out = zeros(size(x));
else
    out = x;
end
end