%% used to demo the rad grating stimulus.

rf.RC = 3;
rf.RS = 12;
rf.RE = 16;
rf.KC = 1;
rf.KS = 1/16;
rf.KE = 2;
rf.C50 = 0.7;

rf.thetaMin = -50;
rf.thetaMax = 50;
rf.dTheta = 0.05;

stim.maskRs = logspace(log10(.1),log10(50),100);
stim.m = 0.5;
stim.c = 1;
stim.FS = 'optimalSF';

out1 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c1 = 1-stim.c*[1 1 1];

stim.c = 0.75;
out2 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c2 = 1-stim.c*[1 1 1];

stim.c = 0.5;
out3 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c3 = 1-stim.c*[1 1 1];

stim.c = 0.25;
out4 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c4 = 1-stim.c*[1 1 1];

figure; ax = axes; hold on;
plot(stim.maskRs,out1.f1,'color',c1,'linewidth',3);text(stim.maskRs(end),out1.f1(end),'c=1','horizontalalignment','right','verticalalignment','bottom');
plot(stim.maskRs,out1.f1Lin,'color',c1,'linestyle','--','linewidth',2)
plot(stim.maskRs,out2.f1,'color',c2,'linewidth',3);text(stim.maskRs(end),out2.f1(end),'c=0.75','horizontalalignment','right','verticalalignment','bottom');
plot(stim.maskRs,out2.f1Lin,'color',c2,'linestyle','--','linewidth',2)
plot(stim.maskRs,out3.f1,'color',c3,'linewidth',3);text(stim.maskRs(end),out3.f1(end),'c=0.5','horizontalalignment','right','verticalalignment','bottom');
plot(stim.maskRs,out3.f1Lin,'color',c3,'linestyle','--','linewidth',2)
plot(stim.maskRs,out4.f1,'color',c4,'linewidth',3);text(stim.maskRs(end),out4.f1(end),'c=0.25','horizontalalignment','right','verticalalignment','bottom');
plot(stim.maskRs,out4.f1Lin,'color',c4,'linestyle','--','linewidth',2)
ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'color','r','linestyle','--','linewidth',2);
plot([rf.RS rf.RS],ylims,'color','b','linestyle','--','linewidth',2);
plot([rf.RE rf.RE],ylims,'color',[0 0 0.75],'linestyle','--','linewidth',2);
stimR = 1/(2*out1.SFTuning.chosenFS);
plot([stimR stimR],ylims,'color','k','linestyle','--','linewidth',2);
set(gca,'fontSize',20);
title('Size Tuning vs contrast. Low Suppression');



% plot the SF
axSF  = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out1.SFTuning.FS,out1.SFTuning.F1,'color',[0.25 0.25 0.25]);
hold on;
plot(out1.SFTuning.chosenFS,out1.SFTuning.chosenF1,'rd','markersize',5,'markerfacecolor','r')
axis tight;
xtickslims = minmax(out1.SFTuning.FS);
xticks = logspace(log10(xtickslims(1)),log10(xtickslims(2)),3);
for i = 1:length(xticks);
    xticklabs{i}= sprintf('%2.2f',xticks(i));
end
set(axSF,'ylim',[0 max(out1.SFTuning.F1)*1.1],'ytick',[],'xtick',xticks,'xticklabels',xticklabs);
title('SF Tuning');
saveLoc= '/home/balaji/Dropbox/';
filename = 'extraClassicalLowSupp-contrast.svg';
plot2svg(fullfile(saveLoc,filename),gcf);

figure; axes;hold on;
plot(stim.maskRs,((out1.f1Lin-out1.f1)./out1.f1Lin),'color',c1,'linewidth',3);
plot(stim.maskRs,((out2.f1Lin-out2.f1)./out2.f1Lin),'color',c2,'linewidth',3);
plot(stim.maskRs,((out3.f1Lin-out3.f1)./out3.f1Lin),'color',c3,'linewidth',3);
plot(stim.maskRs,((out4.f1Lin-out4.f1)./out4.f1Lin),'color',c4,'linewidth',3);
title('Suppression fraction');
set(gca,'fontSize',20);
filename = 'extraClassicalLowSuppFraction-contrast.svg';
plot2svg(fullfile(saveLoc,filename),gcf);





%% A Sum vs contrast. hisg Supp

rf.RC = 3;
rf.RS = 12;
rf.RE = 16;
rf.KC = 1;
rf.KS = 1/16;
rf.KE = 30;
rf.C50 = 0.1;

rf.thetaMin = -50;
rf.thetaMax = 50;
rf.dTheta = 0.01;

stim.maskRs = logspace(log10(.1),log10(50),100);
stim.m = 0.5;
stim.c = 1;
stim.FS = 'optimalSF';

out1 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c1 = 1-stim.c*[1 1 1];

stim.c = 0.75;
out2 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c2 = 1-stim.c*[1 1 1];

stim.c = 0.5;
out3 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c3 = 1-stim.c*[1 1 1];

stim.c = 0.25;
out4 = radGratings(rf,stim,'1D-DOG-MCLikeModel');
c4 = 1-stim.c*[1 1 1];

figure; ax = axes; hold on;
plot(log10(stim.maskRs),out1.f1,'color',c1,'linewidth',3);text(log10(stim.maskRs(end)),out1.f1(end),'c=1','horizontalalignment','right','verticalalignment','bottom');
plot(log10(stim.maskRs),out1.f1Lin,'color',c1,'linestyle','--','linewidth',2)
plot(log10(stim.maskRs),out2.f1,'color',c2,'linewidth',3);text(log10(stim.maskRs(end)),out2.f1(end),'c=0.75','horizontalalignment','right','verticalalignment','bottom');
plot(log10(stim.maskRs),out2.f1Lin,'color',c2,'linestyle','--','linewidth',2)
plot(log10(stim.maskRs),out3.f1,'color',c3,'linewidth',3);text(log10(stim.maskRs(end)),out3.f1(end),'c=0.5','horizontalalignment','right','verticalalignment','bottom');
plot(log10(stim.maskRs),out3.f1Lin,'color',c3,'linestyle','--','linewidth',2)
plot(log10(stim.maskRs),out4.f1,'color',c4,'linewidth',3);text(log10(stim.maskRs(end)),out4.f1(end),'c=0.25','horizontalalignment','right','verticalalignment','bottom');
plot(log10(stim.maskRs),out4.f1Lin,'color',c4,'linestyle','--','linewidth',2)
ylims = get(gca,'ylim');
plot([log10(rf.RC) log10(rf.RC)],ylims,'color','r','linestyle','--','linewidth',2);
plot([log10(rf.RS) log10(rf.RS)],ylims,'color','b','linestyle','--','linewidth',2);
plot([log10(rf.RE) log10(rf.RE)],ylims,'color',[0 0 0.75],'linestyle','--','linewidth',2);
stimR = 1/(2*out1.SFTuning.chosenFS);
plot([log10(stimR) log10(stimR)],ylims,'color','k','linestyle','--','linewidth',2);
xticks = log10([0.1 0.3 1 3 10 30 100]);
xtickLabs = {'0.1','0.3','1','3','10','30','100'};

set(gca,'font name','Fontin Sans','fontSize',20,'xtick',xticks,'xticklabel',xticklabs);
xlabel('Aperture Radius');
ylabel('Response(a.u.)');
title('Size Tuning vs contrast. High Suppression');



% plot the SF
axSF  = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out1.SFTuning.FS,out1.SFTuning.F1,'color',[0.25 0.25 0.25]);
hold on;
plot(out1.SFTuning.chosenFS,out1.SFTuning.chosenF1,'rd','markersize',5,'markerfacecolor','r')
axis tight;
xtickslims = minmax(out1.SFTuning.FS);
xticks = logspace(log10(xtickslims(1)),log10(xtickslims(2)),3);
for i = 1:length(xticks);
    xticklabs{i}= sprintf('%2.2f',xticks(i));
end
set(axSF,'ylim',[0 max(out1.SFTuning.F1)*1.1],'ytick',[],'xtick',xticks,'xticklabels',xticklabs);
title('SF Tuning');
saveLoc= '/home/balaji/Dropbox/';
filename = 'extraClassicalHighSupp-contrast.svg';
plot2svg(fullfile(saveLoc,filename),gcf);

figure; axes;hold on;
plot(stim.maskRs,((out1.f1Lin-out1.f1)./out1.f1Lin),'color',c1,'linewidth',3);
plot(stim.maskRs,((out2.f1Lin-out2.f1)./out2.f1Lin),'color',c2,'linewidth',3);
plot(stim.maskRs,((out3.f1Lin-out3.f1)./out3.f1Lin),'color',c3,'linewidth',3);
plot(stim.maskRs,((out4.f1Lin-out4.f1)./out4.f1Lin),'color',c4,'linewidth',3);
title('Suppression fraction');
set(gca,'fontSize',20);
filename = 'extraClassicalHighSuppFraction-contrast.svg';
% plot2svg(fullfile(saveLoc,filename),gcf);

%% Classical Balanced

rf.RC = 3;
rf.RS = 12;
rf.RE = 16;
rf.KC = 1;
rf.KS = 1/16;
rf.KE = 0;
rf.C50 = 0.7;

rf.thetaMin = -50;
rf.thetaMax = 50;
rf.dTheta = 0.05;

stim.maskRs = logspace(log10(.1),log10(50),100);
stim.m = 0.5;
stim.c = 1;
Fss = logspace(log10(0.05),log10(0.2),30);
cols = jet(30);
figure; ax = axes; hold on;

for j = 1:length(Fss)
    stim.FS = Fss(j);
    c = cols(j,:);
    out = radGratings(rf,stim,'1D-DOG-MCLikeModel');
    plot(stim.maskRs,out.f1,'color',c,'linewidth',3);
end

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'color','r','linestyle','--','linewidth',2);
plot([rf.RS rf.RS],ylims,'color','b','linestyle','--','linewidth',2);
set(gca,'fontSize',20);
title('Size Tuning vs contrast. Contrast scales response');



% plot the SF
axSF  = axes('position',[0.7 0.7 0.2 0.2]);
plot(log10(out.SFTuning.FS),out.SFTuning.F1,'color',[0.25 0.25 0.25]);
hold on;
for j = 1:length(Fss)
    currFs = Fss(j);
    relF1 = interp1(log10(out.SFTuning.FS),out.SFTuning.F1,log10(currFs));
    plot(log10(currFs),relF1,'marker','d','markersize',5,'markeredgecolor',cols(j,:),'markerfacecolor',cols(j,:));
% plot(log10(currFs),relF1,'r.');
end
xticks1 = 0.001:0.001:0.01;xticks1(end) = [];xticklabs1 = {'0.001','','','','','','','',''};
xticks2 = 0.01:0.01:0.1;xticks2(end) = [];xticklabs2 = {'0.01','','','','','','','',''};
xticks3 = 0.1:0.1:1;xticklabs3 = {'0.1','','','','','','','','','1'};
xticks = [xticks1 xticks2 xticks3];
xticklabs = [xticklabs1 xticklabs2 xticklabs3];
set(axSF,'ylim',[0 max(out.SFTuning.F1)*1.1],'xlim',log10([0.001 1]),'ytick',[],'xtick',log10(xticks),'xticklabel',xticklabs);
title('SF Tuning');
saveLoc= '/home/balaji/Dropbox/';
filename = 'Classical-SFs.svg';
plot2svg(fullfile(saveLoc,filename),gcf);