function plotSpatialModulation(s,axHan,params)
sm = whiteNoise;
mean = getMeanLuminanceAndStd(sm,s.stimInfo);
white = whiteVal(sm);

if ~exist('params','var')||isempty(params)
    params.spatialSmoothingON = false;
end
axes(axHan);
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
if params.spatialSmoothingON
    filt=... a mini gaussian like fspecial('gaussian')
        [0.0113  0.0838  0.0113;
        0.0838  0.6193  0.0838;
        0.0113  0.0838  0.0113];
    im=imfilter(im,filt,'replicate','same');
end
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

temp = false;
if temp
%     keyboard
%     figure; axes;
    for i = 1:size(im,2);
        for j = 1:size(im,1)
            currIm = im(size(im,1)-j+1,i);
            if currIm>0 %red
                col = (abs(currIm)/127.5)*[1 0 0];
            else
                col = (abs(currIm)/127.5)*[0 0 1];
            end
            rectangle('Position',[i,j,1,1],'FaceColor',col);%,'EdgeColor','none')
        end
    end
%     axis square;
    axis([1 size(im,2) 1 size(im,1)]);
    set(gca,'xtick',[],'ytick',[]);
else
    imagesc(meshX(:),meshY(:),im);
    
    
    colormap(blueToRed(0,minmax(im(:)'),true));
    
    % hold on; plot(cenX(pos(2)),cenY(pos(1)),'y+');
    xlabel(sprintf('cumulative (%d --> %d)',min(s.trials),max(s.trials)));
    % now start plotting the envelope
    
    [RFCenX,RFCenY,RFRadX,RFRadY] = s.getRFCentreAndSize;
    angle = 0;
    ellipse(RFRadX,RFRadY,angle,RFCenX,RFCenY,'g');
    
    % for the LCD only...need to find a better way to specify this detail here.
    % xConvFactor = atan(52/30)*180/pi; % for the LCD monitor
    xConvFactor = atan(405/300)*180/pi; % for the CRT monitor y = 308;
    
    
    text(RFCenX,RFCenY,sprintf('%2.2f',RFRadX*xConvFactor),'Color',[1 1 1])
    % plot(RFCenX,RFCenY,'g+');
    set(axHan,'XTick',0,'YTick',1,'XTickLabel','[0,0]','YTickLabel','[1,1]')
end
end
