function plotSpatioTemporalContext(s,axHan,params)
sm = whiteNoise;
[mean std] = getMeanLuminanceAndStd(sm,s.stimInfo);
white = whiteVal(sm);
eyeToMonitorMm=250;
contextSize=2;
pixelPad=0.1; %fractional pad 0-->0.5

contextInd = findPixel(s,'maxDeviation');
%stimRect=[500 1000 800 1200]; %need to get this stuff!
if isfield(s.stimInfo,'stimulusDetails')
    stimRect=[0 0 s.stimInfo.stimulusDetails.width s.stimInfo.stimulusDetails.height]; %need to get this! now forcing full screen
    stimRectFraction=stimRect./[s.stimInfo.stimulusDetails.width s.stimInfo.stimulusDetails.height s.stimInfo.stimulusDetails.width s.stimInfo.stimulusDetails.height];
else
    stimRect=[0 0 s.stimInfo.width s.stimInfo.height]; %need to get this! now forcing full screen
    stimRectFraction=stimRect./[s.stimInfo.width s.stimInfo.height s.stimInfo.width s.stimInfo.height];
end
[vRes hRes]=getAngularResolutionFromGeometry(size(s.STA,2),size(s.STA,1),eyeToMonitorMm,stimRectFraction);
contextResY=vRes(contextInd(1),contextInd(2));
contextResX=hRes(contextInd(1),contextInd(2));

im = squeeze(s.STA(:,:,contextInd(3)));
im = im-mean*white; %remove the background
%             contextCenX = contextInd(2)*(1/size(im,2))+1/(2*size(im,2));
%             contextCenY = contextInd(1)*(1/size(im,1))+1/(2*size(im,1));
contextOffset=-contextSize:1:contextSize;
%             contextXs = contextCenX+(contextOffset*(1/size(im,2)));
%             contextYs = contextCenY+(contextOffset*(1/size(im,1)));
n=length(contextOffset); % 2*c+1
contextIm=ones(n,n)*mean;
selection=nan(n,n);
rng = minmax(im(:)');
maxAmp=max(abs(rng))*2; %normalize to whatever lobe is larger: positive or negative
hold off; plot(0,0,'.')
hold on
for i=1:n
    yInd=contextInd(1)+contextOffset(i);
    for j=1:n
        xInd=contextInd(2)+contextOffset(j);
        if xInd>0 && xInd<=size(im,2) && yInd>0 && yInd<=size(im,1)
            %make the image
            selection(i,j)=sub2ind(size(s.STA),yInd,xInd,contextInd(3));
            contextIm(i,j)=s.STA(selection(i,j));
            %get temporal signal
            [stixSig stixCI stixtInd]=getTemporalSignal(sm,s.STA,s.STV,s.numSpikes,selection(i,j));
            yVals{i,j}=((1-pixelPad*2)*(stixSig(:)-(mean*white))/maxAmp)  +  n-i+1; % pad, normalize, and then postion in grid
            xVals{i,j}=linspace(j-.5+pixelPad,j+.5-pixelPad,length(stixSig(:)));
            
        end
    end
end

% plot the image
%             [meshContextX meshContextY] = meshgrid(contextXs,contextYs);
imagesc(flipud(contextIm))
multFact = 1/(max(abs(im(:)))/(white/2));

colormap(blueToRed(0,minmax(im(:)')*multFact,true));

%plot the temporal signal
for i=1:n
    for j=1:n
        if ~isnan(selection(i,j))
            plot(xVals{i,j},yVals{i,j},'y')
        end
    end
end

% we only take the degrees of the selected pixel.
%neighbors may differ by a few % depending how big they are,
%geometery, etc.


axis([.5 n+.5 .5 n+.5])
set(gca,'xTick',[]); set(gca,'yTick',[])
xlabel(sprintf('%2.1f deg/pix',contextResX));
ylabel(sprintf('%2.1f deg/pix',contextResY));

end
