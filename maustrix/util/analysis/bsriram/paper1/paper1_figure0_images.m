L1 = imread('C:\Documents and Settings\Owner\My Documents\Dropbox\L1.jpg');
figure;imshow(L1);

L1 = double(L1);
L2 = sqrt((L1(:,:,1).^2+L1(:,:,2).^2+L1(:,:,3).^2)/3);

figure;imagesc(L2);colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight

L2 = L2-127.5;
xLC = size(L2,2);
yLC = size(L2,1);
%%
clc
rC = 10; rS = 20;
fCenter = fspecial('gaussian',[100 100],rC);
fSurround = fspecial('gaussian',[100 100],rS);
k = logspace(log10(0.1),log10(10),9);

%% center only
figure;
LC = imfilter(L2,fCenter,'replicate');
LC_max = max(LC(:));
LC_min = min(LC(:));
LC(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = LC_max;
image(LC); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight

LCON = LC;
% center + surround
figure;
LCS = imfilter(L2,fCenter-fSurround,'replicate');
LCS_max = max(LCS(:));
LCS_min = min(LCS(:));
LCSON = LCS;
LCS(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = 255;
LCS(30:40,xLC-(2*rS+rS):xLC-(2*rS-rS)) = 100;

image(LCS); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight
%% -center only
figure;
LC = imfilter(L2,-fCenter,'replicate');
LC_max = max(LC(:));
LC_min = min(LC(:));
LC(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = LC_max;
image(LC); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight
LCOFF = LC;
% -(center + surround)
figure;
LCS = imfilter(L2,-fCenter+fSurround,'replicate');
LCS_max = max(LCS(:));
LCS_min = min(LCS(:));
LCSOFF = LCS;
LCS(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = 255;
LCS(30:40,xLC-(2*rS+rS):xLC-(2*rS-rS)) = 100;

image(LCS); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight

%% is this a scaling effect only? or something profounder?
figure;image(LCON);colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight
figure;imagesc(LCON);colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight
%% color map it!
LCTot(:,:,1) = LCON;
LCTot(:,:,3) = LCOFF;
LCTot(LCTot<0) = 0;
LCTot = LCTot/max(LCTot(:));
figure;imshow(LCTot);

LCSTot(:,:,1) = LCSON;
LCSTot(:,:,3) = LCSOFF;
% %shift
% LCSTot = LCSTot+(255-max(LCSTot(:)));

LCSTot(LCSTot<0) = 0;
LCSTot = LCSTot/max(LCSTot(:));
figure;imshow(LCSTot);
%%
for i = 1:length(k)
%     subplot(3,3,i);
figure
    L3 = imfilter(L2,fCenter-k(i)*fSurround,'replicate');
%     imagesc(L3-min(L3(:))/(max(L3(:))-min(L3(:))));
    imagesc(L3)
    colormap gray; 
    set(gca,'XTick',[],'YTick',[]);
    title(['\eta = ' sprintf('%2.2f',k(i))]);
%     minmax(L3-min(L3(:))/(max(L3(:))-min(L3(:))))
end

%% surround strength
figure;
LCS = imfilter(L2,fCenter-(0.5*fSurround),'replicate');
LCS_max = max(LCS(:));
LCS_min = min(LCS(:));
LCSON = LCS;
LCS(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = 255;
LCS(30:40,xLC-(2*rS+rS):xLC-(2*rS-rS)) = 100;

image(LCS); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight

figure;
LCS = imfilter(L2,fCenter-fSurround,'replicate');
LCS_max = max(LCS(:));
LCS_min = min(LCS(:));
LCSON = LCS;
LCS(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = 255;
LCS(30:40,xLC-(2*rS+rS):xLC-(2*rS-rS)) = 100;

image(LCS); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight

figure;
LCS = imfilter(L2,fCenter-(2*fSurround),'replicate');
LCS_max = max(LCS(:));
LCS_min = min(LCS(:));
LCSON = LCS;
LCS(14:24,xLC-(2*rS+rC):xLC-(2*rS-rC)) = 255;
LCS(30:40,xLC-(2*rS+rS):xLC-(2*rS-rS)) = 100;

image(LCS); colormap gray;
set(gca,'XTick',[],'YTick',[]);
axis equal; axis tight