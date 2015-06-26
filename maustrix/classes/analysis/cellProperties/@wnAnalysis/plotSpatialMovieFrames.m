function plotSpatialMovieFrames(s,figHan,params)

sm = whiteNoise;
mean = getMeanLuminanceAndStd(sm,s.stimInfo);
white = whiteVal(sm);
frameTimes = linspace(-s.timeWindow(1),s.timeWindow(2),size(s.STA,3));
if isempty(params)
    params.spatialSmoothingON = false;
end
figure(figHan);
set(figHan,'Position',[1607 101 1094 935]);
axHan = subplot(5,5,[1:20]);hold on;
tCourse = getTemporal(s,s.relevantIndex);
type = classify(s,'ONOFFMaxDev');type = type{1};
pos = findPixel(s,'maxDeviation');
switch type
    case 'ON'
        toi = min(find(tCourse==max(tCourse)));
    case 'OFF'
        toi = min(find(tCourse==min(tCourse)));
end
im=double(squeeze(s.STA(:,:,toi)));

rng = minmax(s.STA(:));
% here comes the normalization part. AND IT WAS ANNOYING!
warning('may not be well thought out for some analyses. use with caution');
% first remove the mean
im = im-mean*white; % some are + and some are -
multFact = 1/(max(abs(im(:)))/(white/2));
im=im*multFact;

%             im = (im-min(im(:)))*255/diff(rng); %everything is in the [0 255] range
if isfield(s.stimInfo,'stimulusDetails')
    nX = s.stimInfo.stimulusDetails.spatialDim(1);
    nY = s.stimInfo.stimulusDetails.spatialDim(2);
else
    nX = s.stimInfo.spatialDim(1);
    nY = s.stimInfo.spatialDim(2);
end
cenX = linspace(1/nX,1-1/nX,nX);
cenY = linspace(1/nY,1-1/nY,nY);
[meshX meshY] = meshgrid(cenX,cenY);

imagesc(meshX(:),meshY(:),im);
% keyboard
rngImTOI = minmax(im);
% keyboard
% colormap(blueToRed(0,rngImTOI,false));
colormap(gray)
caxis([-127.5 127.5])
% [RFCenX,RFCenY,RFRadX,RFRadY] = s.getRFCentreAndSize;
% angle = 0;
% ellipse(RFRadX,RFRadY,angle,RFCenX,RFCenY,'g');
% plot(RFCenX,RFCenY,'g+');
set(axHan,'XTick',0,'YTick',1,'XTickLabel','[0,0]','YTickLabel','[1,1]')
titTxt = sprintf('t = %2.1f ms',frameTimes(toi));
% title(titTxt,'fontname','Fontin Sans','FontSize',30);
axis off
if params.sfFitCS
    whichFit = (params.sfFit.nID==params.nID);  
    whichFit = min(find(whichFit));
    if ~isempty(whichFit)
        currSFFit = params.sfFit.fit(whichFit).chosenRF;
        deg2NormUnits = 1/rad2deg(2*atan((params.monitorWidth/2)/params.distToMonitor));
        ellipse(currSFFit.RC*deg2NormUnits,currSFFit.RC*deg2NormUnits,angle,RFCenX,RFCenY,'r');
        ellipse(currSFFit.RS*deg2NormUnits,currSFFit.RS*deg2NormUnits,angle,RFCenX,RFCenY,'b');
    end
end
axis([0 1 0 1])
% now plot the other tois
toiRel = -2:2;
for i = 1:length(toiRel)
    if (toi+toiRel(i) >0)&& (toi+toiRel(i)<size(s.STA,3))
        im=double(squeeze(s.STA(:,:,toi+toiRel(i))));
        im = im-mean*white;
        im = im*multFact;
        subplot(5,5,20+i);hold on;
        imagesc(meshX(:),meshY(:),im);
%         colormap(blueToRed(0,minmax(im),true));
        colormap(gray);
        caxis([-127.5 127.5])

        set(gca,'XTick',[],'YTick',[]);
        titTxt = sprintf('%2.1f',frameTimes(toi+toiRel(i)));
%         title(titTxt,'fontname','Fontin Sans','FontSize',30);
        axis off
    end
%     keyboard
end
pause(1);
end
