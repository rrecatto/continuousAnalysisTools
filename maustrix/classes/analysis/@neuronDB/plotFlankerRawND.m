function plotFlankerRawND(db)
%specifically plots the flanker samples
nID=10;
aID=2;
offset=0.4;
timeRangeSec=[9.075 9.3];

figure;
plotRawSamples(db,nID,aID,offset,timeRangeSec)

xs=[0 50 100 150 200]
sampPerMs=40000/1000;
set(gca,'xtick',xs*sampPerMs,'xtickLabel',xs)
set(gca,'ytickLabel',[])
settings.turnOffTics=true;
cleanUpFigure([],settings)
end
