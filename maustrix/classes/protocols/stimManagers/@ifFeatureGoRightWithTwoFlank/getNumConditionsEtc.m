function [numConditions numCycles numInstances nthOccurence displayHeight]=getNumConditionsEtc(sm,c)

numConditions=length(c.conditionNames);
numCycles=size(c.conditionPerCycle,1);
%numTrialTypes=numCycles/numConditions; % whatever the group actually was acording to ths sm
numInstances=numCycles/numConditions; % these 2 terms are the same

for i=1:numConditions
    which=find(c.conditionPerCycle==i);
    %this is prob not needed, but it garauntees temporal order as a secondary sort
    try
        [junk order]=sort(c.cycleOnset(which)); ... requires
            which=which(order);
        nthOccurence(which)=1:length(which);  %nthOccurence of this condition in this list
    catch ex
        warning('oops')
        keyboard
    end
end
displayHeight=nthOccurence(c.spike.cycle)+(c.spike.condition-1)*numInstances;

end