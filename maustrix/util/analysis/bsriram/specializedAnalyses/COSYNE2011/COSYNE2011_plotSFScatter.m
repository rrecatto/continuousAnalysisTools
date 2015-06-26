function COSYNE2011_plotSFScatter
% check bads
badnids = [18 8 4];
subainds = [1 5 3];
figure;
params.color = 'r';
for i = 1:length(nid);
    ax = subplot(2,3,i);
    db.data{nid(i)}.analyses{subainds(i)}.plotSpikes(ax,params);
end

%% 
params.excludeNIDs = [18 8 4];
db.plotAwakeVsAnesth({'sfGratings',{'f1'},[512 2048],'emptyIfNoValue'},params)
end