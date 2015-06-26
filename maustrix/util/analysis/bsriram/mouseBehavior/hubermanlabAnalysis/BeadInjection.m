function BeadInjection
'orctrXsfSweep'
plotBefore = true;
if plotBefore
    %% 26  performance by day
    clc;
    
    % plotting the training for a Opt for this mouse
    filters = 1:735739;
    
%     fighan = figure;
%     set(fighan, 'DefaultTextFontSize', 12); % [pt]
%     set(fighan, 'DefaultAxesFontSize', 12); % [pt]
%     set(fighan, 'DefaultAxesFontName', 'Times New Roman');
%     set(fighan, 'DefaultTextFontName', 'Times New Roman');
%     
    
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.figHan = figure;
    plotDetails.requestedPlot = 'contrastTuning';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;% true, false
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false; % true, false
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    analysisFor.analyzeCtrSensitivity = true;
    
    compiledFilesDir = '\\ghosh-16-159-221.ucsd.edu\ghosh\Behavior\RocheProject\Compiled';
        
    outBefore{1} = analyzeMouse('213',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outBefore{2} = analyzeMouse('216',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outBefore{3} = analyzeMouse('220',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outBefore{4} = analyzeMouse('221',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outBefore{5} = analyzeMouse('225',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outBefore{6} = analyzeMouse('226',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
end

%% plot examples
plotExamples = false;
if plotExamples
    figure;hold on;
    plot(out.ctrSensitivityData.fits(2).data.c,out.ctrSensitivityData.fits(2).data.pHat,'kd');
    plot(out.ctrSensitivityData.fits(2).fittedModel.c,out.ctrSensitivityData.fits(2).fittedModel.pModel,'k--')
    
    
    plot(out.ctrSensitivityData.fits(4).data.c,out.ctrSensitivityData.fits(4).data.pHat,'kd','markerFaceColor','k');
    plot(out.ctrSensitivityData.fits(4).fittedModel.c,out.ctrSensitivityData.fits(4).fittedModel.pModel,'k')
    
    set(gca,'ylim',[0.4 1],'xlim',[-0.05 1.05]);
    set(gca,'xtick',[0 0.5 1],'ytick',[0.5 0.75 1])
    
    
    figure;
    plot(log10(out.ctrSensitivityData.sfForSens),out.ctrSensitivityData.sensForSens,'b');
    set(gca,'xlim',log10([0.01 1.5]));
    set(gca,'xtick',log10([0.01:0.01:0.1 0.2:0.1:1]));
    set(gca,'xticklabel',{'','','0.03','','','','','','','0.1','','','','','','','','','1'});
    
    
end
%% plotAfter
plotAfter = true;
if plotAfter
    %% 26  performance by day
    clc;
    
    % plotting the training for a Opt for this mouse
    filtersAfter = 735739:today;
    
%     fighan = figure;
%     set(fighan, 'DefaultTextFontSize', 12); % [pt]
%     set(fighan, 'DefaultAxesFontSize', 12); % [pt]
%     set(fighan, 'DefaultAxesFontName', 'Times New Roman');
%     set(fighan, 'DefaultTextFontName', 'Times New Roman');
%     
    
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.figHan = figure;
    plotDetails.requestedPlot = 'contrastTuning';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;% true, false
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false; % true, false
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    analysisFor.analyzeCtrSensitivity = true;
    
    compiledFilesDir = '\\ghosh-16-159-221.ucsd.edu\ghosh\Behavior\RocheProject\Compiled';
        
    outAfter{1} = analyzeMouse('213',filtersAfter,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outAfter{2} = analyzeMouse('216',filtersAfter,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outAfter{3} = analyzeMouse('220',filtersAfter,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outAfter{4} = analyzeMouse('221',filtersAfter,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outAfter{5} = analyzeMouse('225',filtersAfter,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    outAfter{6} = analyzeMouse('226',filtersAfter,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
end

%% performance change
figure; hold on
rats = [];
subplot(3,1,2:3); hold on
for i = [1 3 4 5 6]

    sf = outBefore{i}.ctrSensitivityData.sfForSens;
    sensBefore = outBefore{i}.ctrSensitivityData.sensForSens;
    sensAfter = outAfter{i}.ctrSensitivityData.sensForSens;
    if i==3
        sensAfter(4)=10;
    end
    rat = sensAfter./sensBefore;
    plot(log10(sf),log10(rat),'k');
    rats = [rats;rat];
    set(gca,'xlim',log10([0.01 1.5]));
    set(gca,'xtick',log10([0.01:0.01:0.1 0.2:0.1:1]));
    set(gca,'xticklabel',{'','','0.03','','','','','','','0.1','','','','','','','','','1'});
end
set(gca,'ylim',[-1 1])
m_rats = mean(log10(rats));
sem_rats = std(log10(rats))/sqrt(5);
plot(log10(sf),m_rats,'k','linewidth',3);
plot(log10(sf),m_rats+sem_rats,'k--');
plot(log10(sf),m_rats-sem_rats,'k--');

plot(log10(sf),log10(unaffected),'r');
plot(log10([sf(1) sf(end)]),[0 0],'k--')
set(gca,'ytick',[-1 -0.5 0 0.5 1])

subplot(3,1,1); hold on
sens = [];
for i = [1 2 3 4 5 6]

    sf = outBefore{i}.ctrSensitivityData.sfForSens;
    sensBefore = outBefore{i}.ctrSensitivityData.sensForSens;
    
    plot(log10(sf),sensBefore,'k');
    sens = [sens;sensBefore];
    set(gca,'xlim',log10([0.01 1.5]));
    set(gca,'xtick',log10([0.01:0.01:0.1 0.2:0.1:1]));
    set(gca,'xticklabel',{'','','0.03','','','','','','','0.1','','','','','','','','','1'});
end
plot(log10(sf),geomean(sens),'k','linewidth',3)
plot(log10([sf(1) sf(end)]),[1 1],'k--')


%% pre and post sensitivity
figure;subplot(3,1,1:2);hold on;
plot(log10(outBefore{1}.ctrSensitivityData.sfForSens),outBefore{1}.ctrSensitivityData.sensForSens,'b')
plot(log10(outAfter{1}.ctrSensitivityData.sfForSens),outAfter{1}.ctrSensitivityData.sensForSens,'r')
set(gca,'xlim',log10([0.01 1.5]));
set(gca,'xtick',log10([0.01:0.01:0.1 0.2:0.1:1]));
set(gca,'xticklabel',{'','','0.03','','','','','','','0.1','','','','','','','','','1'});

subplot(3,1,3);hold on;
plot(log10(outBefore{1}.ctrSensitivityData.sfForSens),log10(outAfter{1}.ctrSensitivityData.sensForSens./outBefore{1}.ctrSensitivityData.sensForSens),'k')
set(gca,'xlim',log10([0.01 1.5]));
set(gca,'xtick',log10([0.01:0.01:0.1 0.2:0.1:1]));
set(gca,'xticklabel',{'','','0.03','','','','','','','0.1','','','','','','','','','1'});
set(gca,'ylim',[-0.4 0.4]);
%% Bead pressures
pre = {[15,9.7],[12.7,9.3],[14,8],[15.8,11.2],[17.7,8.7]};
postL = {[18.33,16,12.5],[15.7,15.8,16.7],[18.7,13,18.5],[17.7,11.3,20.7],[19.2,11.2,9.7]};
meanPost = cellfun(@mean,postL);
meanPre  = cellfun(@mean,pre);

figure;axes; hold on
for i = 1:5
    plot([0.35,0.65],[meanPre(i),meanPost(i)],'kd');
    plot([0.35,0.65],[meanPre(i),meanPost(i)],'k');
end
mPre = mean(meanPre);
semPre = std(meanPre)/sqrt(5);
mPost = mean(meanPost);
semPost = std(meanPost)/sqrt(5);

plot(0.15,mPre,'kd');plot([0.15 0.15],[mPre-semPre, mPre+semPre],'k');
plot(0.85,mPost,'kd');plot([0.85 0.85],[mPost-semPost, mPost+semPost],'k');
set(gca,'ylim',[10 20])
set(gca,'xtick',[0.2 0.8],'xticklabel',{'pre','post'}); 
end