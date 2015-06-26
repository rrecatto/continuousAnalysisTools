function [f1mean f1sd] = getShuffleEstimate(s)
f1mean = squeeze(mean(mean(s.f1Shuffled,1),3));
f1sd = std(mean(s.f1Shuffled,1),[],3);
end