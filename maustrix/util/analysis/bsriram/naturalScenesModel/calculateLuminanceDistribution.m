function [lumDist lumDistNorm] = calculateLuminanceDistribution(loc)

if ~exist('loc','var')||isempty(loc)
%     loc = '/home/balaji/Documents/vanHateren';
    loc = '\\132.239.158.169\datanetOutput\vanHateren';
end


%look for the camera settings.txt to get the settings for the data
if ~exist(fullfile(loc,'camSet.csv'),'file')
    error('need a camera settings file. otherwise uninterperttable');
end
camSet = csvread(fullfile(loc,'camSet.csv'));

range = 0:1:65535;
lumDist.range = range;
nTot = zeros(size(range));
nTotNorm = zeros(1,1000);
lumDistNormRng = linspace(0,70,1000);
lumDistNorm.m= nan(1,1000);
lumDistNorm.mNorm= nan(1,1000);
lumDistNorm.sd= nan(1,1000);
d = dir(fullfile(loc,'imk*.imc'));
imNos = 1:length(d);
for i = imNos
    fprintf('%d of %d\n',i,length(d));
    filename = d(i).name;
    [s e t mStr] = regexpi(filename,'[0-9]+');
    if length(mStr)>1
        error('cannot have that many');
    else
        mNum = str2num(mStr{1});
    end    
    
    currFactor = camSet(mNum,5);
    f1=fopen(fullfile(loc,filename),'rb','ieee-be');
    w=1536;h=1024;
    buf=fread(f1,[w,h],'uint16');
    buf = double(buf); % worried about overshooting stuff.
    buf = currFactor*buf;
    fclose(f1);
    nIm = histc(buf(:),range);
    nTot = nTot+nIm';
    
    m = mean(buf(:));
    buf = buf-m;
    minBuf = min(buf(:));
    buf = buf-minBuf; % start at 0
    sd = std(buf(:));
    buf = buf/sd;
    sdNorm = std(buf(:));
    nImNorm = histc(buf(:),lumDistNormRng);
    nTotNorm = nTotNorm+nImNorm';
    lumDistNorm.m(i) = m;
    lumDistNorm.sd(i) = sd;
    lumDistNorm.mNorm(i) = minBuf;
    lumDistNorm.sdNorm(i) = sdNorm;
    
end
lumDist.n = nTot;
lumDistNorm.range = lumDistNormRng;
lumDistNorm.n = nTotNorm;
end
    