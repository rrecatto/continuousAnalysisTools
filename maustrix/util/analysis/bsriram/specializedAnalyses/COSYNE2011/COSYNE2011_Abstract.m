%% COSYNE abstract
recordsPath='\\132.239.158.169\datanetOutput';  %on the G drive remote

% anesth
subjectAnesth = '353';
ffgwnAnesth={'trialRange',[3 5]}; %fgwn
sfAnesth={'trialRange',[25 28]}; %sf
orAnesth={'trialRange',[30 34]}; %or

% awake cell
subjectAwake = '375';
ffgwnAwake={'trialRange',[758 761]};% ffgwn
sfAwake={'trialRange',[763 764]};% sf
orAwake={'trialRange',[777 778]};% orGr512

% sf graph
% location of the anesth analysis
folderName = sprintf('%d-%d',sfAnesth{2}(1),sfAnesth{2}(2));
anesthRec = fullfile(recordsPath,subjectAnesth,'analysis',folderName,'physAnalysis.mat');
temp = load(anesthRec);
anesthSFAnalysis = temp.physAnalysis{1}{1}.trode_1;
[valsAnesth orderAnesth] = sort(anesthSFAnalysis.stimInfo.vals);

% location of the awake analysis
folderName = sprintf('%d-%d',sfAwake{2}(1),sfAwake{2}(2));
awakeRec = fullfile(recordsPath,subjectAwake,'analysis',folderName,'physAnalysis.mat');
temp = load(awakeRec);
awakeSFAnalysis = temp.physAnalysis{1}{1}.trode_1;
[valsAwake orderAwake] = sort(awakeSFAnalysis.stimInfo.vals);

conversion = 73/1024; %(degrees/pix)

% plotting
f = figure;
[ax,h1,h2] = plotyy(conversion*valsAwake,awakeSFAnalysis.pow(orderAwake),conversion*valsAnesth,anesthSFAnalysis.pow(orderAnesth));
legend()
set(h1,'lineWidth',2); set(h2,'lineWidth',2); hold on;
legend({'awake','anesth.'})
axes(ax(1));hold on;
for i = 1:length(valsAwake)
    plot([conversion*valsAwake(i) conversion*valsAwake(i)] ,[awakeSFAnalysis.pow(orderAwake(i))+awakeSFAnalysis.powSEM(orderAwake(i)) awakeSFAnalysis.pow(orderAwake(i))-awakeSFAnalysis.powSEM(orderAwake(i))],'LineWidth',3)
end
axes(ax(2));hold on;
for i = 1:length(valsAnesth)
    plot([conversion*valsAnesth(i) conversion*valsAnesth(i)] ,[anesthSFAnalysis.pow(orderAnesth(i))+anesthSFAnalysis.powSEM(orderAnesth(i)) anesthSFAnalysis.pow(orderAnesth(i))-anesthSFAnalysis.powSEM(orderAnesth(i))],'LineWidth',3)
end
set(get(ax(1),'Ylabel'),'String','f1_{Awake} (imp/s)') ;
set(get(ax(2),'Ylabel'),'String','f1_{Anesth} (imp/s)');

xlabel('1/spatial frequency (deg/cyc)');
title('Spatial Frequency Tuning')
settings.fontSize = 40;
settings.LineWidth = 5;
cleanUpFigure(gcf,settings)
set(h1,'lineWidth',10);
set(h2,'linewidth',10,'lineStyle','--')
