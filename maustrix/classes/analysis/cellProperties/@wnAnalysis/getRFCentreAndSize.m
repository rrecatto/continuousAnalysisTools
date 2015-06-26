function [cenX,cenY,rX,rY]= getRFCentreAndSize(s,params)

if ~exist('params','var')||isempty(params)
    params = struct;
end

sm = whiteNoise;
[mean std] = getMeanLuminanceAndStd(sm,s.stimInfo);
white = whiteVal(sm);

if isfield(params,'inputTOI')
    toi = params.inputTOI;
else
    relInd = s.relevantIndex;
    toi = relInd(3); % toi is global from the original full STA
end


% get image
if isfield(params,'inputSTA')
    im = squeeze(params.inputSTA(:,:,toi));
else
    im = squeeze(s.STA(:,:,toi));
end

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
if abs(min(im(:)-mean*white))>abs(max(im(:)-mean*white)) %then it is an off cell
    ONOFFMult = -1;
else
    ONOFFMult = 1;
end

results = autoGaussianSurfML(meshX,meshY,ONOFFMult*(im-mean*white));% im goes from 0 to 255; im-mean*white goes from -128 to 128
cenX = results.x0;
cenY = results.y0;
rX = 2*results.sigmax;
rY = 2*results.sigmay;
%             [envBW params] = fitGaussianEnvelopeToImage(ONOFFMult*im,2,false,true,true);
end
