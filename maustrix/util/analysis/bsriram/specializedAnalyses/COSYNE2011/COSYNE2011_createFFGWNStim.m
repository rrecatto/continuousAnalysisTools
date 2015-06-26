function COSYNE2011_createFFGWNStim
%% FFGWN stimulus
% example stim
temp = load('\\132.239.158.158\physdata\389\stimRecords\stimRecords_64-20110128T142442.mat');
seedVals = temp.stimulusDetails.seedValues;
std = 0.2;% temp.stimulusDetails.distribution.std;
meanLuminance = 0.5;%temp.stimulusDetails.distribution.meanLuminance;
black = 0;
white = 255;
%how many frames to look at?
frames= 1:500;
frameLums = nan(size(seedVals));
for i = 1:length(seedVals)
    randn('state',seedVals(i));
    frameLums(i) = randn*std+meanLuminance;
end
frameLums(frameLums<0) = 0;
frameLums(frameLums>1) = 1;
f =figure;
figPosn = [4 194 1274 242];
set(f,'Position',figPosn);
ax1 = axes('Position',[0.21 0.15 0.75 0.8]); hold on;
whichFrames = [10:20:110 500];
whichValue = frameLums(whichFrames);
plot(whichFrames,whichValue*white,'*','MarkerSize',10,'color',0.3*[1 1 1])
for i = 1:length(whichFrames)
    plot([whichFrames(i) whichFrames(i)],[whichValue(i)*white ceil(max(frameLums*white))],'color',0.9*[1 1 1]);
end
plot(frameLums*white,'k');
axis([minmax(frames) floor(min(frameLums*white)) ceil(max(frameLums*white))])
set(ax1,'XTick',[1 max(frames)],'YTick',[]);
xlabel('Frame No.');

ax2 = axes('Position',[0.05 0.15 0.15 0.8]);
[count posns] = hist(frameLums*white,100);
barh(ax2,posns,count,'k');
axis([minmax(count) floor(min(frameLums*white)) ceil(max(frameLums*white))])
set(ax2,'XTick',[],'YTick',[floor(min(frameLums*white)) ceil(max(frameLums*white))])

settings.fontSize=25;
cleanUpFigure(f,settings);
%% drawing the frames
%whichValue = frameLums(whichFrames);
f = figure;hold on;
FigPos = [4 -141 1280 833];
set(f,'Position',FigPos);
for i = 1:length(whichFrames);
    x = repmat(whichFrames(i),1,4);
    y = [0 1 1 0];
    z = [0 0 1 1];
    col = whichValue(i);
fill3(x,y,z,col*[1 1 1]);
end
set(gca,'CameraPosition',[2072.69 -6.65447 3.74419],'CameraTarget',[250 0.5 0.5],...
    'CameraViewAngle',[9.44615]);
axis([1 500 0 1 0 1])
set(gca,'XTick',[1 500],'YTick',[],'ZTick',[]);
settings.fontSize=25;

cleanUpFigure(f,settings);
end