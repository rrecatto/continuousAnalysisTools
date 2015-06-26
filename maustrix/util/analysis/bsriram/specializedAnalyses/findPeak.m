%% keep balanced
if ~exist('out','var')
    out = rfModel;
end

legendStr = {};
for i = 1:10
    if i==1  || i==10
        legendStr{end+1} = sprintf('%2.2f',out.se(i));
    else
        legendStr{end+1} = '';
    end    
end

figure; subplot(2,1,1); hold on
for i = 1:10
    y = squeeze(out.f1(i,1,:));
    plot(out.fs,y/max(y),'color',(i/15)*[1 1 1],'LineWidth',2);
end
legend(legendStr);
title('si = 3deg, se changes. eta = 2.5','FontSize',20);
xlabel('fs(cpd)','FontSize',20);
ylabel('f1(arbitrary units)','FontSize',20);
set(gca,'FontSize',20)

fPeak = nan(1,length(out.se));

for i = 1:10
    [junk loc] = max(squeeze(out.f1(i,:)));
    fPeak(i) = out.fs(loc);
subplot(2,1,2); hold on;t.fs(loc);
end

subplot(2,1,2); hold on;
maxVal = max([max(2*out.se) max(1./(2*fPeak))]);
plot(2*out.se,1./(2*fPeak),'ro'); axis square; plot([0 maxVal], [0 maxVal],'k','LineWidth',2)
xlabel('2*se','FontSize',20);
ylabel('1/(2*fs)','FontSize',20);
set(gca,'FontSize',20)

%% change balance
if ~exist('out','var')
    out = rfModel;
end

legendStr = {};
for i = 1:length(out.eta)
    if i==1  || i==4 || i==7
        legendStr{end+1} = sprintf('%2.2f',out.eta(i));
    else
        legendStr{end+1} = '';
    end    
end

figure; subplot(2,1,1); hold on
for i = 1:length(out.eta)
    y = squeeze(out.f1(1,1,i,:));
    which = out.fs<1;
    plot(out.fs(which),y(which),'color',(i/12)*[1 1 1],'LineWidth',2);
end
legend(legendStr);
title('si = 3deg, eta changes. ','FontSize',20);
xlabel('fs(cpd)','FontSize',20);
ylabel('f1(arbitrary units)','FontSize',20);
set(gca,'FontSize',20)

fPeak = nan(1,length(out.se));

for i = 1:length(out.eta)
    [junk loc] = max(squeeze(out.f1(1,1,i,:)));
    fPeak(i) = out.fs(loc);
end

subplot(2,1,2); hold on;
maxVal = max([max(2*out.se) max(1./(2*fPeak))]);
plot(out.eta,1./(2*fPeak),'ro'); axis square; plot([0 maxVal], [0 maxVal],'k','LineWidth',2)
xlabel('2*se','FontSize',20);
ylabel('1/(2*fs)','FontSize',20);
set(gca,'FontSize',20)