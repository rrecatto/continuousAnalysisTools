function COSYNE2011_plotRates
%% get the rates
[aInd nInd subAInd] = db.selectIndexTool('all');

whichBad = nInd==40&subAInd==1;
aInd = aInd(~whichBad);
nInd = nInd(~whichBad);
subAInd = subAInd(~whichBad);
anesth = nan(size(aInd));
rate = nan(size(aInd));
rateCI = nan(size(aInd));
type = cell(size(aInd));
n=1;
for i = 1:length(aInd)
    fprintf('%d/%d ',i,length(aInd));
    anesth(i) = getAnesthesia(db.data{nInd(i)}.analyses{subAInd(i)});
    if isnan(anesth(i)), anesth(i)=2.0; end % phil's stuff is anesth
    
    ratecurr = getProperties(db.data{nInd(i)}.analyses{subAInd(i)},{'firingRate'});
    rate(i) = ratecurr{1};
    type{i} = getType(db.data{nInd(i)}.analyses{subAInd(i)});
end
anesth(isnan(anesth))=2.0; % phil's stuff is anesth
whichAnesth = (anesth>0);
whichAwake = (anesth==0);

if false
%% now plot by type
uniqType = {'sfGratings','binarySpatial','gaussianFullField'};
typeName = {'Drifting gratings','Spatio-temporal noise','Temporal noise'};
f = figure;

numAxes = length(uniqType)+1;
ax=subplot(1,numAxes,1);hold on;
whichAnesth = anesth>0;
outlier = rate>20;
ratesAnesth = rate(whichAnesth&~outlier);
ratesAwake = rate(~whichAnesth&~outlier);

% plot awake
mAwk = mean(ratesAwake);
semAwk = std(ratesAwake)/sqrt(length(ratesAwake));
awkColor = [0.1 0.1 0.8];
f = fill([0.13 0.37 0.37 0.13]',[mAwk+semAwk mAwk+semAwk mAwk-semAwk mAwk-semAwk]',brighten(awkColor,.5));
set(f,'EdgeAlpha',0)
plot(0.25*ones(size(ratesAwake))+0.08*(rand(size(ratesAwake))-0.5),ratesAwake,'b.','MarkerSize',5);
% plot([0.125 0.375],[mAwk+semAwk mAwk+semAwk],'b.')
% plot([0.125 0.375],[mAwk-semAwk mAwk-semAwk],'b.')
%individual plots
plot(0.75*ones(size(ratesAnesth))+0.08*(rand(size(ratesAnesth))-0.5),ratesAnesth,'r.','MarkerSize',5);

maxCurr = max([ratesAwake ratesAnesth]);
axis([0 1 0 20]);
plot(0.25,mean(ratesAwake),'kd','MarkerSize',10,'MarkerFaceColor','k');

mAnes = mean(ratesAnesth);
semAnes = std(ratesAnesth)/sqrt(length(ratesAnesth));
anesCol = [0.8 0.1 0.1];
f = fill([0.63 0.87 0.87 0.63]',[mAnes+semAnes mAnes+semAnes mAnes-semAnes mAnes-semAnes]',brighten(anesCol,0.5));
set(f,'EdgeAlpha',0);
% plot([0.625 0.875],[mAnes+semAnes mAnes+semAnes],'r.')
% plot([0.625 0.875],[mAnes-semAnes mAnes-semAnes],'r.')
plot(0.75,mean(ratesAnesth),'kd','MarkerSize',10,'MarkerFaceColor','k');
set(ax,'XTick',[0.25 0.75],'XTickLabel',{},'YTick',sort([0 mean(ratesAnesth) mean(ratesAwake)]),'YTickLabel',{'','',''});
% text(0,25,sprintf('25'),'HorizontalAlignment',...
%     'Center','VerticalAlignment','Bottom','rotation',90);
text(-0.125,mean(ratesAnesth),['\color{red}' sprintf('%2.1f',mean(ratesAnesth))],'HorizontalAlignment',...
    'Center','VerticalAlignment','Middle','Fontsize',16);
text(-0.125,mean(ratesAwake),['\color{blue}' sprintf('%2.1f',mean(ratesAwake))],'HorizontalAlignment',...
    'Center','VerticalAlignment','Middle','Fontsize',16);

% text(0,25,sprintf('25'),'HorizontalAlignment',...
%     'Left','VerticalAlignment','Top','rotation',90);
set(ax,'FontSize',16)
title('All');
whichInAll = false(size(rate));
for i = 1:length(uniqType)
    ax = subplot(1,numAxes,i+1);hold on;
    currType = uniqType{i};
    whichCurrAnalyses = ismember(type,currType);
    whichCurrAwk = whichCurrAnalyses & ~whichAnesth;
    whichCurrAnesth = whichCurrAnalyses & whichAnesth;
    
    ratesAnesth = rate(whichCurrAnesth);
    ratesAwake = rate(whichCurrAwk);
    
    % plot awake
    mAwk = mean(ratesAwake);
    semAwk = std(ratesAwake)/sqrt(length(ratesAwake));
    awkColor = [0.1 0.1 0.8];
    f = fill([0.13 0.37 0.37 0.13]',[mAwk+semAwk mAwk+semAwk mAwk-semAwk mAwk-semAwk]',brighten(awkColor,.5));
    set(f,'EdgeAlpha',0)
    plot(0.25*ones(size(ratesAwake))+0.08*(rand(size(ratesAwake))-0.5),ratesAwake,'b.','MarkerSize',5);
    % plot([0.125 0.375],[mAwk+semAwk mAwk+semAwk],'b.')
    % plot([0.125 0.375],[mAwk-semAwk mAwk-semAwk],'b.')
    %individual plots
    plot(0.75*ones(size(ratesAnesth))+0.08*(rand(size(ratesAnesth))-0.5),ratesAnesth,'r.','MarkerSize',5);
    
    maxCurr = max([ratesAwake ratesAnesth]);
    axis([0 1 0 20]);
    plot(0.25,mean(ratesAwake),'kd','MarkerSize',10,'MarkerFaceColor','k');
    
    mAnes = mean(ratesAnesth);
    semAnes = std(ratesAnesth)/sqrt(length(ratesAnesth));
    anesCol = [0.8 0.1 0.1];
    f = fill([0.63 0.87 0.87 0.63]',[mAnes+semAnes mAnes+semAnes mAnes-semAnes mAnes-semAnes]',brighten(anesCol,0.5));
    set(f,'EdgeAlpha',0);
    % plot([0.625 0.875],[mAnes+semAnes mAnes+semAnes],'r.')
    % plot([0.625 0.875],[mAnes-semAnes mAnes-semAnes],'r.')
    plot(0.75,mean(ratesAnesth),'kd','MarkerSize',10,'MarkerFaceColor','k');
    set(ax,'XTick',[0.25 0.75],'XTickLabel',{},'YTick',sort([0 mean(ratesAnesth) mean(ratesAwake)]),'YTickLabel',{});
    % text(0,25,sprintf('25'),'HorizontalAlignment',...
    %     'Center','VerticalAlignment','Bottom','rotation',90);
    text(-0.125,mean(ratesAnesth),['\color{red}' sprintf('%2.1f',mean(ratesAnesth))],'HorizontalAlignment',...
        'Center','VerticalAlignment','Middle','Fontsize',16);
    text(-0.125,mean(ratesAwake),['\color{blue}' sprintf('%2.1f',mean(ratesAwake))],'HorizontalAlignment',...
        'Center','VerticalAlignment','Middle','Fontsize',16);
    
    title(typeName{i},'FontSize',16)
    set(ax,'FontSize',16);
    whichInAll = whichInAll & whichCurrAnalyses;
end

% plot awake
% ratesAwake = rate(whichInAll & ~whichAnesth);
% ratesAnesth = rate(whichInAll & whichAnesth);
% ax=subplot(1,numAxes,1);hold on;
% mAwk = mean(ratesAwake);
% semAwk = std(ratesAwake)/sqrt(length(ratesAwake));
% awkColor = [0.1 0.1 0.8];
% f = fill([0.13 0.37 0.37 0.13]',[mAwk+semAwk mAwk+semAwk mAwk-semAwk mAwk-semAwk]',brighten(awkColor,.5));
% set(f,'EdgeAlpha',0)
% plot(0.25*ones(size(ratesAwake))+0.08*(rand(size(ratesAwake))-0.5),ratesAwake,'b.','MarkerSize',5);
% % plot([0.125 0.375],[mAwk+semAwk mAwk+semAwk],'b.')
% % plot([0.125 0.375],[mAwk-semAwk mAwk-semAwk],'b.')
% %individual plots
% plot(0.75*ones(size(ratesAnesth))+0.08*(rand(size(ratesAnesth))-0.5),ratesAnesth,'r.','MarkerSize',5);
% 
% maxCurr = max([ratesAwake ratesAnesth]);
% axis([0 1 0 20]);
% plot(0.25,mean(ratesAwake),'kd','MarkerSize',10,'MarkerFaceColor','k');
% 
% mAnes = mean(ratesAnesth);
% semAnes = std(ratesAnesth)/sqrt(length(ratesAnesth));
% anesCol = [0.8 0.1 0.1];
% f = fill([0.63 0.87 0.87 0.63]',[mAnes+semAnes mAnes+semAnes mAnes-semAnes mAnes-semAnes]',brighten(anesCol,0.5));
% set(f,'EdgeAlpha',0);
% % plot([0.625 0.875],[mAnes+semAnes mAnes+semAnes],'r.')
% % plot([0.625 0.875],[mAnes-semAnes mAnes-semAnes],'r.')
% plot(0.75,mean(ratesAnesth),'kd','MarkerSize',10,'MarkerFaceColor','k');
% set(ax,'XTick',[0.25 0.75],'XTickLabel',{},'YTick',sort([0 mean(ratesAnesth) mean(ratesAwake) 20]),'YTickLabel',{'','','','20 Hz'});
% % text(0,25,sprintf('25'),'HorizontalAlignment',...
% %     'Center','VerticalAlignment','Bottom','rotation',90);
% text(-0.125,mean(ratesAnesth),['\color{red}' sprintf('%2.1f',mean(ratesAnesth))],...
%     'VerticalAlignment','Middle','Fontsize',16);
% text(-0.125,mean(ratesAwake),['\color{blue}' sprintf('%2.1f',mean(ratesAwake))],'HorizontalAlignment',...
%     'Center','VerticalAlignment','Middle','Fontsize',16);
% 
% % text(0,25,sprintf('25'),'HorizontalAlignment',...
% %     'Left','VerticalAlignment','Top','rotation',90);
% set(ax,'FontSize',16)
% title('All');
end
if true
    %% now plot by type
uniqType = {'sfGratings','binarySpatial','gaussianFullField'};
typeName = {'Drifting gratings','Spatio-temporal noise','Temporal noise'};
f = figure;

numAxes = length(uniqType)+1;
ax=subplot(numAxes,1,1);hold on;
whichAnesth = anesth>0;
outlier = rate>20;
ratesAnesth = rate(whichAnesth&~outlier);
ratesAwake = rate(~whichAnesth&~outlier);

% plot awake
mAwk = mean(ratesAwake);
semAwk = std(ratesAwake)/sqrt(length(ratesAwake));
awkColor = [0.1 0.1 0.8];
f = fill([mAwk+semAwk mAwk+semAwk mAwk-semAwk mAwk-semAwk]',[0.13 0.37 0.37 0.13]',brighten(awkColor,.5));
set(f,'EdgeAlpha',0)
plot(ratesAwake,0.25*ones(size(ratesAwake))+0.08*(rand(size(ratesAwake))-0.5),'b.','MarkerSize',5);
% plot([0.125 0.375],[mAwk+semAwk mAwk+semAwk],'b.')
% plot([0.125 0.375],[mAwk-semAwk mAwk-semAwk],'b.')
%individual plots
plot(ratesAnesth,0.75*ones(size(ratesAnesth))+0.08*(rand(size(ratesAnesth))-0.5),'r.','MarkerSize',5);

maxCurr = max([ratesAwake ratesAnesth]);
axis([ 0 20 0 1 ]);
plot(mean(ratesAwake),0.25,'kd','MarkerSize',10,'MarkerFaceColor','k');

mAnes = mean(ratesAnesth);
semAnes = std(ratesAnesth)/sqrt(length(ratesAnesth));
anesCol = [0.8 0.1 0.1];
f = fill([mAnes+semAnes mAnes+semAnes mAnes-semAnes mAnes-semAnes]',[0.63 0.87 0.87 0.63]',brighten(anesCol,0.5));
set(f,'EdgeAlpha',0);
% plot([0.625 0.875],[mAnes+semAnes mAnes+semAnes],'r.')
% plot([0.625 0.875],[mAnes-semAnes mAnes-semAnes],'r.')
plot(mean(ratesAnesth),0.75,'kd','MarkerSize',10,'MarkerFaceColor','k');
set(ax,'YTick',[0.25 0.75],'YTickLabel',{},'XTick',sort([0 mean(ratesAnesth) mean(ratesAwake) 20]),'XTickLabel',{'','','',''});
% text(0,25,sprintf('25'),'HorizontalAlignment',...
%     'Center','VerticalAlignment','Bottom','rotation',90);
text(mean(ratesAnesth), -0.125,['\color{red}' sprintf('%2.1f',mean(ratesAnesth))],'HorizontalAlignment',...
    'Center','VerticalAlignment','Middle','Fontsize',16);
text(mean(ratesAwake),-0.125,['\color{blue}' sprintf('%2.1f',mean(ratesAwake))],'HorizontalAlignment',...
    'Center','VerticalAlignment','Middle','Fontsize',16);

% text(0,25,sprintf('25'),'HorizontalAlignment',...
%     'Left','VerticalAlignment','Top','rotation',90);
set(ax,'FontSize',16)
ylabel('All');
whichInAll = false(size(rate));
for i = 1:length(uniqType)
    ax = subplot(numAxes,1,i+1);hold on;
    currType = uniqType{i};
    whichCurrAnalyses = ismember(type,currType);
    whichCurrAwk = whichCurrAnalyses & ~whichAnesth;
    whichCurrAnesth = whichCurrAnalyses & whichAnesth;
    
    ratesAnesth = rate(whichCurrAnesth);
    ratesAwake = rate(whichCurrAwk);
    
    % plot awake
    mAwk = mean(ratesAwake);
    semAwk = std(ratesAwake)/sqrt(length(ratesAwake));
    awkColor = [0.1 0.1 0.8];
    f = fill([mAwk+semAwk mAwk+semAwk mAwk-semAwk mAwk-semAwk]',[0.13 0.37 0.37 0.13]',brighten(awkColor,.5));
    set(f,'EdgeAlpha',0)
    plot(ratesAwake,0.25*ones(size(ratesAwake))+0.08*(rand(size(ratesAwake))-0.5),'b.','MarkerSize',5);
    % plot([0.125 0.375],[mAwk+semAwk mAwk+semAwk],'b.')
    % plot([0.125 0.375],[mAwk-semAwk mAwk-semAwk],'b.')
    %individual plots
    plot(ratesAnesth,0.75*ones(size(ratesAnesth))+0.08*(rand(size(ratesAnesth))-0.5),'r.','MarkerSize',5);
    
    maxCurr = max([ratesAwake ratesAnesth]);
    axis([0 20 0 1 ]);
    plot(mean(ratesAwake),0.25,'kd','MarkerSize',10,'MarkerFaceColor','k');
    
    mAnes = mean(ratesAnesth);
    semAnes = std(ratesAnesth)/sqrt(length(ratesAnesth));
    anesCol = [0.8 0.1 0.1];
    f = fill([mAnes+semAnes mAnes+semAnes mAnes-semAnes mAnes-semAnes]',[0.63 0.87 0.87 0.63]',brighten(anesCol,0.5));
    set(f,'EdgeAlpha',0);
    % plot([0.625 0.875],[mAnes+semAnes mAnes+semAnes],'r.')
    % plot([0.625 0.875],[mAnes-semAnes mAnes-semAnes],'r.')
    plot(mean(ratesAnesth),0.75,'kd','MarkerSize',10,'MarkerFaceColor','k');
    set(ax,'YTick',[0.25 0.75],'YTickLabel',{},'XTick',sort([0 mean(ratesAnesth) mean(ratesAwake)]),'XTickLabel',{});
    % text(0,25,sprintf('25'),'HorizontalAlignment',...
    %     'Center','VerticalAlignment','Bottom','rotation',90);
    text(mean(ratesAnesth),-0.125,['\color{red}' sprintf('%2.1f',mean(ratesAnesth))],'HorizontalAlignment',...
        'Center','VerticalAlignment','Middle','Fontsize',16);
    text(mean(ratesAwake),-0.125,['\color{blue}' sprintf('%2.1f',mean(ratesAwake))],'HorizontalAlignment',...
        'Center','VerticalAlignment','Middle','Fontsize',16);
    
    ylabel(typeName{i},'FontSize',16)
    set(ax,'FontSize',16);
    whichInAll = whichInAll & whichCurrAnalyses;
end
set(ax,'YTick',[0.25 0.75],'YTickLabel',{},'XTick',sort([0 mean(ratesAnesth) mean(ratesAwake),20]),'XTickLabel',{,'','','','20Hz'});
end
