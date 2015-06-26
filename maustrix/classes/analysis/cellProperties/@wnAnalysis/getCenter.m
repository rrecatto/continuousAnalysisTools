function out = getCenter(s,params)
if ~ismember(getType(s),{'binarySpatial','gaussianSpatial'})
    error('need to send in the right kind of analysis');
end
switch params{1}
    case 'mostModulatedPixel'
        whichPos = findPixel(s,'maxDeviation');
        nDim = fliplr(s.stimInfo.spatialDim); % we want rows by columns
        xCentres = repmat((1/(2*nDim(2)):1/nDim(2):(1-1/(2*nDim(2)))),[nDim(1) 1]);
        yCentres = repmat((1/(2*nDim(1)):1/nDim(1):(1-1/(2*nDim(1))))',[1 nDim(2)]);
        out = [xCentres(whichPos(1),whichPos(2)) yCentres(whichPos(1),whichPos(2))];
    case 'gaussianFit'
        whichPos = findPixel(s,'maxDeviation');
        whichTime = find(abs(s.STA(whichPos(1),whichPos(2),:))==max(abs(s.STA(whichPos(1),whichPos(2),:))));
        STAToFit = squeeze(s.STA(:,:,whichTime));
        stdThresh = params{2}{1};
        [STAenvelope STAparams] =fitGaussianEnvelopeToImage(STAToFit,stdThresh,false,false,false);
        out = STAparams(2:3);
end
end
