%% center-Only RF. optimal FS
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'centerOnly_optimalSF.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS ='optimalSF';%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.KC = 1;
rf.KS = 1/16;

mode = '1D-DOG-MCLikeModel';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;
% rText = {sprintf('rc=%2.2f',rf.RC),sprintf('rs=%2.2f',rf.RS)};
% text(1,1,rText,'horizontalalignment','right','verticalalignment','top','units','normalized');

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a center-only RF. optimal FS');

% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end
    

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;

% testing if circle plots work

stimGratR = stimInt; %stimGratR(whichRc) = 1;
stimGratG = stimInt;
stimGratB = stimInt; %stimGratB(whichRs) = 1;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'kd','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('fs=%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Only RF FS=0.1
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'centerOnly_LargeTypical.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.1;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 0;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;
% rText = {sprintf('rc=%2.2f',rf.RC),sprintf('rs=%2.2f',rf.RS)};
% text(1,1,rText,'horizontalalignment','right','verticalalignment','top','units','normalized');

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a center-only RF. FS = 0.1');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');
% axis square;

% set(ax1,'FontSize',9);

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k.','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Only RF FS=0.2
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'centerOnly_SmallTypical.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.2;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 0;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;
% rText = {sprintf('rc=%2.2f',rf.RC),sprintf('rs=%2.2f',rf.RS)};
% text(1,1,rText,'horizontalalignment','right','verticalalignment','top','units','normalized');

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a center-only RF. FS = 0.1');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k.','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% Now change the surround strength
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'SAndS_optimalSF_variableETA.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS ='optimalSF';%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 0;
rf.A = 1;
etas = [0.2 0.4 0.6 0.8 1];
mode = '1D-DOG';

%setup figure and axes
f = figure;
ax = axes;
% ax1 = axes('position',[0.8 0.2 0.1 0.1]);
ax2 = axes('position',[0.8 0.8 0.1 0.1]);

for etaCurr = etas
    rf.ETA = etaCurr;
    clear out
    out = radGratings(rf,stim,mode);
    col = ((1-etaCurr)/1.1)*[1 1 1];
    axes(ax); hold on;
    plot(stim.maskRs,out.f1,'color',col,'linewidth',3);
    
    rStim = 1/(2*out.chosenFs);
    [junk whichRStim] = min(abs(stim.maskRs-rStim));
    whichFStim = out.f1(whichRStim);
    plot([whichRStim whichRStim],[whichFStim-0.1 whichFStim+0.1],'linewidth',3,'color',col);
    
    % interesting points
    which = (out.f1==max(out.f1));
    rInt = stim.maskRs(find(which,1));
    plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
    set(ax,'FontSize',12);
    
    
    % plot the SF tuning
    axes(ax2);hold on;
    plot(log(out.SFTuning.FS),out.SFTuning.F1,'color',col);
    plot(log(out.SFTuning.chosenFS),out.SFTuning.chosenF1,'*','color',col,'markerSize',5);
    
%     text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
    
end
axes(ax);
ylims = get(ax,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);
title('Size tuning depends on Surround Strength');

axes(ax2)
ylims = get(ax2,'ylim');
plot(log([1/out.rf.RC 1/out.rf.RC]),[ylims(1) ylims(2)],'r','linewidth',2);
plot(log([1/out.rf.RS 1/out.rf.RS]),[ylims(1) ylims(2)],'b','linewidth',2);
xLabs = {};
xLabs{1} = sprintf('%2.3f',min(out.SFTuning.FS));
xLabs{2} = sprintf('%2.1f',max(out.SFTuning.FS));
set(ax2,'ytick',[],'xtick',log(minmax(out.SFTuning.FS)),'xticklabels',xLabs); 
title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% Now change the surround strength
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'SAndS_optimalSF_variableETA_StrongEta.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS ='optimalSF';%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 0;
rf.A = 1;
etas = [1.1 1.3 1.5 1.7 1.9];
mode = '1D-DOG';

%setup figure and axes
f = figure;
ax = axes;
% ax1 = axes('position',[0.8 0.2 0.1 0.1]);
ax2 = axes('position',[0.8 0.8 0.1 0.1]);

for etaCurr = etas
    rf.ETA = etaCurr;
    clear out
    out = radGratings(rf,stim,mode);
    col = [1 1 1]-(etaCurr-1)*[1 1 1];
    axes(ax); hold on;
    plot(stim.maskRs,out.f1,'color',col,'linewidth',3);
    
    rStim = 1/(2*out.chosenFs);
    [junk whichRStim] = min(abs(stim.maskRs-rStim));
    whichFStim = out.f1(whichRStim);
    plot([whichRStim whichRStim],[whichFStim-0.1 whichFStim+0.1],'linewidth',3,'color',col);
    
    % interesting points
    which = (out.f1==max(out.f1));
    rInt = stim.maskRs(find(which,1));
    plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
    set(ax,'FontSize',12);
    
    
    % plot the SF tuning
    axes(ax2);hold on;
    plot(log(out.SFTuning.FS),out.SFTuning.F1,'color',col);
    plot(log(out.SFTuning.chosenFS),out.SFTuning.chosenF1,'*','color',col,'markerSize',5);
    
%     text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
    
end
axes(ax);
ylims = get(ax,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);
title('Size tuning depends on Surround Strength.ETA > 1');

axes(ax2)
ylims = get(ax2,'ylim');
plot(log([1/out.rf.RC 1/out.rf.RC]),[ylims(1) ylims(2)],'r','linewidth',2);
plot(log([1/out.rf.RS 1/out.rf.RS]),[ylims(1) ylims(2)],'b','linewidth',2);
xLabs = {};
xLabs{1} = sprintf('%2.3f',min(out.SFTuning.FS));
xLabs{2} = sprintf('%2.1f',max(out.SFTuning.FS));
set(ax2,'ytick',[],'xtick',log(minmax(out.SFTuning.FS)),'xticklabels',xLabs); 
title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Surround RF FS=optimal
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_Optimal.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS ='optimalSF';%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a center-only RF. Optimal FS.');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k*','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Surround RF FS=0.1
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_LargeTypical.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.1;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for balanced RF. FS = 0.1');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k*','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Surround RF FS=0.2
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_SmallTypical.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.2;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for balanced RF. FS = 0.2');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k*','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Surround supra balanced RF FS=0.05
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_SupraBalanced_Optimal.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.05;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1.8;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for supra-balanced RF. FS = 0.05');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k*','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Surround supra balanced RF FS=0.1
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_SupraBalanced_LargeTypical.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.1;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1.8;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for supra-balanced RF. FS = 0.1');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k*','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% center-Surround supra balanced RF FS=0.2
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_SupraBalanced_LargeTypical.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS =0.2;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1.8;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for supra-balanced RF. FS = 0.2');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end

% plot the stim
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<rInt*rInt);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('*');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k*','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% Now change to Change Contrast
saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'SAndS_optimalSF_ChangeContrast.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS ='optimalSF';%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1;
rf.A = 1;
cS = [0.2 0.4 0.6 0.8 1];
mode = '1D-DOG';

%setup figure and axes
f = figure;
ax = axes;
ax2 = axes('position',[0.8 0.8 0.1 0.1]);

for cCurr = cS
    stim.c = cCurr;
    clear out
    out = radGratings(rf,stim,mode);
    col = ((1-cCurr)/1.1)*[1 1 1];
    axes(ax); hold on;
    plot(stim.maskRs,out.f1,'color',col,'linewidth',3);
    
    rStim = 1/(2*out.chosenFs);
    [junk whichRStim] = min(abs(stim.maskRs-rStim));
    whichFStim = out.f1(whichRStim);
    plot([whichRStim whichRStim],[whichFStim-0.1 whichFStim+0.1],'linewidth',3,'color',col);
    
    % interesting points
    which = (out.f1==max(out.f1));
    rInt = stim.maskRs(find(which,1));
    plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
    set(ax,'FontSize',12);
    
    
    % plot the SF tuning
    axes(ax2);hold on;
    plot(log(out.SFTuning.FS),out.SFTuning.F1,'color',col);
    plot(log(out.SFTuning.chosenFS),out.SFTuning.chosenF1,'*','color',col,'markerSize',5);
    
%     text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
    
end
axes(ax);
ylims = get(ax,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);
title('Contrast scales responses');

axes(ax2)
ylims = get(ax2,'ylim');
plot(log([1/out.rf.RC 1/out.rf.RC]),[ylims(1) ylims(2)],'r','linewidth',2);
plot(log([1/out.rf.RS 1/out.rf.RS]),[ylims(1) ylims(2)],'b','linewidth',2);
xLabs = {};
xLabs{1} = sprintf('%2.3f',min(out.SFTuning.FS));
xLabs{2} = sprintf('%2.1f',max(out.SFTuning.FS));
set(ax2,'ytick',[],'xtick',log(minmax(out.SFTuning.FS)),'xticklabels',xLabs); 
title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% C-S balanced but showing multiple images. optimal FS

saveLoc = '/home/balaji/Dropbox/paper2012/figures/balancedNoSupp';
filename = 'CAndS_Optimal_multImage2.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS ='optimalSF';%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.KC = 1;
rf.KS = 1/16;
mode = '1D-DOG-MCLikeModel';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a center-only RF. Optimal FS.');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end
rRel = 35;
% plot the stim ; r = 5 deg
ax1 = axes('position',[0.2 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<5*5);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
e=ellipse(2*rf.RC,2*rf.RC,0,0,0,'r');set(e,'linewidth',2);
e=ellipse(2*rf.RS,2*rf.RS,0,0,0,'b');set(e,'linewidth',2);
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=5');

% plot the stim ; r = 15 deg
ax1 = axes('position',[0.35 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<15*15);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
e=ellipse(2*rf.RC,2*rf.RC,0,0,0,'r');set(e,'linewidth',2);
e=ellipse(2*rf.RS,2*rf.RS,0,0,0,'b');set(e,'linewidth',2);
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=15');

% plot the stim ; r = 25 deg
ax1 = axes('position',[0.5 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<25*25);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
e=ellipse(2*rf.RC,2*rf.RC,0,0,0,'r');set(e,'linewidth',2);
e=ellipse(2*rf.RS,2*rf.RS,0,0,0,'b');set(e,'linewidth',2);
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=25');

% plot the stim ; r = 35 deg
ax1 = axes('position',[0.65 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<35*35);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
e=ellipse(2*rf.RC,2*rf.RC,0,0,0,'r');set(e,'linewidth',2);
e=ellipse(2*rf.RS,2*rf.RS,0,0,0,'b');set(e,'linewidth',2);
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=35');

% plot the stim ; r = 45 deg
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<45*45);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
e=ellipse(2*rf.RC,2*rf.RC,0,0,0,'r');set(e,'linewidth',2);
e=ellipse(2*rf.RS,2*rf.RS,0,0,0,'b');set(e,'linewidth',2);
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=45');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k.','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% C-S balanced but showing multiple images. FS = 0.1

saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_LargeTypical_multImage.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS = 0.1;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a Balanced RF. FS = 0.1');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end
rRel = 35;
% plot the stim ; r = 5 deg
ax1 = axes('position',[0.2 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<5*5);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=5');

% plot the stim ; r = 15 deg
ax1 = axes('position',[0.35 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<15*15);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=15');

% plot the stim ; r = 25 deg
ax1 = axes('position',[0.5 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<25*25);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=25');

% plot the stim ; r = 35 deg
ax1 = axes('position',[0.65 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<35*35);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=35');

% plot the stim ; r = 45 deg
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<45*45);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=45');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k.','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);

%% C-S balanced but showing multiple images. FS = 0.2

saveLoc = '/home/balaji/Dropbox/paper2012/figures';
filename = 'CAndS_SmallTypical_multImage.svg';
stim.m = 0.5;
stim.c = 1;
stim.FS = 0.2;%'twiceOptimalSF','optimalSF'
stim.maskRs = linspace(0,50,200);

rf = [];
rf.RC = 3;
rf.RS = 12;
rf.thetaMin = -60;
rf.thetaMax = 60;
rf.dTheta = 0.1;
rf.ETA = 1;
rf.A = 1;

mode = '1D-DOG';

out = radGratings(rf,stim,mode);

f = figure;
% set(f,'position',[50 1 1551 1121]);
ax = axes;
plot(stim.maskRs,out.f1,'linewidth',3);
hold on;

ylims = get(gca,'ylim');
plot([rf.RC rf.RC],ylims,'r--','linewidth',2);text(rf.RC,1.01*ylims(2),'rc','horizontalalignment','right','verticalalignment','top','rotation',90);
plot([rf.RS rf.RS],ylims,'b--','linewidth',2);text(rf.RS,1.01*ylims(2),'rs','horizontalalignment','right','verticalalignment','top','rotation',90);

plot([1/(2*out.chosenFs) 1/(2*out.chosenFs)],ylims,'k--','linewidth',3);text(1/(2*out.chosenFs),1.01*ylims(2),'halfWidth','horizontalalignment','right','verticalalignment','top','rotation',90);

% interesting points
which = (out.f1==max(out.f1));
rInt = stim.maskRs(find(which,1));
plot(rInt,out.f1(find(which,1)),'k*','markersize',10);
set(ax,'FontSize',12);
title('Size tuning for a Balanced RF. FS = 0.2 cpd');
% relevant image size
if rInt>rf.RS 
    rRel = rInt;
elseif rInt>rf.RC
    rRel = rf.RS;
else    
    rRel = 2*rf.RC;
end
rRel = 35;
% plot the stim ; r = 5 deg
ax1 = axes('position',[0.2 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<5*5);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=5');

% plot the stim ; r = 15 deg
ax1 = axes('position',[0.35 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<15*15);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=15');

% plot the stim ; r = 25 deg
ax1 = axes('position',[0.5 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<25*25);
stimInt(~stimMask) = 0.5;
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=25');

% plot the stim ; r = 35 deg
ax1 = axes('position',[0.65 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<35*35);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=35');

% plot the stim ; r = 45 deg
ax1 = axes('position',[0.8 0.2 0.1 0.1]);
x = -rRel:0.05:rRel;
y = x;
[X Y] = meshgrid(y,x);
clear stimInt whichRc whichRs stimGratR stimGratG stimGratB stimGrat
stimInt = stim.m+stim.m*stim.c*cos(2*pi*out.chosenFs*X);
stimMask = (X.*X+Y.*Y<45*45);
stimInt(~stimMask) = 0.5;
whichRc = (X.*X+Y.*Y<(rf.RC+.1)^2) & (X.*X+Y.*Y>(rf.RC-.1)^2);
whichRs = (X.*X+Y.*Y<(rf.RS+.1)^2) & (X.*X+Y.*Y>(rf.RS-.1)^2);
stimGratR = stimInt; 
stimGratG = stimInt;
stimGratB = stimInt;
stimGrat(:,:,1) = stimGratR;stimGrat(end,end,1) = 1;stimGrat(end-1,end,1) = 0;
stimGrat(:,:,2) = stimGratG;stimGrat(end,end,2) = 1;stimGrat(end-1,end,2) = 0;
stimGrat(:,:,3) = stimGratB;stimGrat(end,end,3) = 1;stimGrat(end-1,end,3) = 0;
image(x,y,stimGrat);hold on;
ellipse(rf.RC,rf.RC,0,0,0,'r');
ellipse(rf.RS,rf.RS,0,0,0,'b');
% ellipse(rInt,rInt,0,0,0,'k');
set(ax1,'xlim',minmax(x),'ylim',minmax(y));
set(ax1,'xtick',[],'ytick',[]);
title('r=45');

% plot the SF tuning
ax2 = axes('position',[0.8 0.8 0.1 0.1]);
semilogx(out.SFTuning.FS,out.SFTuning.F1,'k');hold on;
semilogx(out.SFTuning.chosenFS,out.SFTuning.chosenF1,'k.','markerSize',5);
ylims = get(ax2,'ylim');
semilogx([1/out.rf.RC 1/out.rf.RC],[ylims(1) ylims(2)],'r','linewidth',2);
text(out.SFTuning.chosenFS,out.SFTuning.chosenF1,sprintf('%2.2f',out.SFTuning.chosenFS),'horizontalalignment','left','verticalalignment','middle')
set(ax2,'ytick',[],'xtick',[0.01 0.1 1]); title('SF Tuning');
axis tight
set(ax2,'FontSize',11);

plot2svg(fullfile(saveLoc,filename),f);