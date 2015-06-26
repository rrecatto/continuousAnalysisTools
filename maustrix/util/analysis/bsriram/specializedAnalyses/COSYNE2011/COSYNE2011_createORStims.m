function COSYNE2011_createORStims
% %% orGratings
% f = figure;
% ax = axes;
% [X Y] = meshgrid(-500:500,-500:500);
% GratSize = 256;
% or = 45;
% or = deg2rad(or);
% z = cos(mod(X,GratSize)/GratSize*2*pi);
% R = [cos(or) sin(or);-sin(or) cos(or)];
% Xnew = nan(size(X));
% Ynew = nan(size(Y));
% 
% for i = 1:length(X(:))
% newC = floor(R*([X(i) Y(i)]'));
% Xnew(i) = newC(1);
% Ynew(i) = newC(2);
% end
% zNew = nan(400,300);
% for x = 1:400
%     for y = 1:300
%         zNew(x,y) = z(Xnew(X==x&Y==y),Ynew(X==x&Y==y));
%     end
% end
% 
% % zNew = z();
% imagesc(z)
% delta = diff(minmax(z(:)))/256;
% set(ax,'XTick',[],'YTick',764,'YTickLabel',sprintf('%2.0f%c',GratSize*73/1024,char(176)));
% colormap([[0:delta:1]' [0:delta:1]' [0:delta:1]']);
% settings.fontSize=25;
% cleanUpFigure(f,settings);

%%
wDeg = 1;  %size of image (in degrees)
nPix = 20000;  %resolution of image (pixels);

xMesh = linspace(-150,150,2000);
yMesh = linspace(-150,150,2000);
[x,y] = meshgrid(xMesh,yMesh);
x = x(1:end-1,1:end-1);
y = y(1:end-1,1:end-1);
which = (x.*x+y.*y)<150*150;
orientation = -45;  %deg (counter-clockwise from vertical)
sf = 0.012; %spatial frequency (cycles/deg)
contrast = .1;
ramp = cos(orientation*pi/180)*x - sin(orientation*pi/180)*y;

grating = contrast*sin(2*pi*sf*ramp);
grating(end,end) = 1; grating(end-1,end) = -1;
figure(1)
imagesc(grating)%,x,y);
axis equal;
set(gca,'xtick',[],'ytick',[])
colormap gray
end