function colorMap=spikesColorMap(numberOfColorsRequested)
% a usefull colormap for visualizing spikes

colorsInPalette =...
[...
    0 0 0;...
    0 0.6 0.6;...
    0 0.6 1;...
    0.2 0.2 1;...
    0.6 0 0.6;...
    0.8 0 0.4;...
    1 0.2 0.2;...
    1 0.6 0;...
    0.6 0.6 0;...
    0.2 1 0;...
    ];
if ~exist('numberOfColorsRequested','var')||isempty(numberOfColorsRequested)
    numberOfColorsRequested = 60;
end
numberOfBins = size(colorsInPalette,1);
% the last point is always the last color
locations = linspace(0,1,numberOfBins);
colorMap=customColorMap(locations, colorsInPalette,numberOfColorsRequested);
end


function map=customColorMap(locations, colors,numPts)
%normalized locations in color map 0 is dark and 1 is white if greyscale

%error check
numColors=size(colors,1);
numLocations=length(locations);
if numLocations~=numColors
    numColors
    numLocations
    error('numColors must be the same as the numLocations')
end
if ~all(diff(locations)>0)
    locations
    error('locations must be increasing in order')
    % could sort to solve
end

%set ends to the most extreme value
if locations(1)~=0
    locations=[0 locations];
    colors=[colors(1,:); colors];
end
if locations(end)~=1
    locations=[locations 1];
    colors=[colors; colors(end,:)];
end
    
map=[];
locationInds=round(1+(locations*(numPts)));
numColors=size(colors,1);
for i=1:numColors-1
    n=diff(locationInds(i:i+1));
    thisSection=linearColorFade(colors(i,:),colors(i+1,:),n);
    map=[map; thisSection];
    if 0 %view construction process
        colormap(map)
        drawnow
        keyboard
    end
end
end

function fade=linearColorFade(colorA,colorB,numPts)

r=linspace(colorA(1),colorB(1),numPts);
g=linspace(colorA(2),colorB(2),numPts);
b=linspace(colorA(3),colorB(3),numPts);


fade=[r; g; b]';
end