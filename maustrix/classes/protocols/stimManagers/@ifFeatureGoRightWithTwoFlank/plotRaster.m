   
function plotRaster(sm,c)

[numConditions numCycles numInstances nthOccurence displayHeight]=getNumConditionsEtc(sm,c);

hold on
for i=1:numConditions
    which=c.spike.condition==i;
    plot(c.spike.relTimes(which),-displayHeight(which),'.','color',brighten(c.colors(i,:),-0.2))
end

yTickVal=-fliplr((numInstances/2)+[0:numConditions-1]*numInstances);
set(gca,'YTickLabel',fliplr(c.conditionNames),'YTick',yTickVal);
ylabel([c.swept]);

xlabel('time (msec)');
timeToTarget=c.targetOnOff(1)*c.ifi/2;
xvals=[ -timeToTarget 0  (diff(c.targetOnOff*c.ifi))+[0 timeToTarget]];
set(gca,'XTickLabel',xvals*1000,'XTick',xvals);

n=diff(minmax([0 displayHeight]));
plot(xvals([2 2]),0.5+[-n 0],'k')
plot(xvals([3 3]),0.5+[-n 0],'k')

axis([xvals([1 4]) 0.5+[-n 0]])
set(gca,'TickLength',[0 0])


end