function COSYNE2011_createSFStim
%% sfGratings
f = figure;
ax = axes;
[X Y] = meshgrid(1:1920,1:1200);
GratSize = 64;
z = cos(mod(X,GratSize)/GratSize*2*pi);
imagesc(z)
delta = diff(minmax(z(:)))/256;

xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;


set(ax,'XTick',[],'YTick',1200,'YTickLabel',sprintf('%2.0f%c',GratSize*degPerPix,char(176)));
colormap([[0:delta:1]' [0:delta:1]' [0:delta:1]']);
settings.fontSize=25;
cleanUpFigure(f,settings)
end