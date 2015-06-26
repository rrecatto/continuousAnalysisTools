x = 1:1920;
y = 1:1280;

xPPC = 256;

phaseX = x/xPPC*2*pi;

c = 1;
im = 127.5+127.5*c*cos(repmat(phaseX,length(y),1));
% im = 127.5+127.5*c*ones(size(cos(repmat(phaseX,length(y),1))));
imagesc(im,[0 255]);
colormap gray
set(gca,'XTick',[],'YTick',[]);