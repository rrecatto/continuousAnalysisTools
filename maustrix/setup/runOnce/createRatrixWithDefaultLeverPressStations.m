function r=createRatrixWithDefaultLeverPressStations(machines,dataPath,rewardMethod,startEyelinkIfAvail)

if ~exist('startEyelinkIfAvail','var')||isempty(startEyelinkIfAvail)
    startEyelinkIfAvail = false;
end

serverDataPath = fullfile(dataPath, 'ServerData');
r=ratrix(serverDataPath,1);

screenNum=[];
pportaddr=[];

for i=1:length(machines)
    id=machines{i}{1};
    path=fullfile(dataPath, 'Stations',sprintf('station%s',id));
    mac=machines{i}{2};
    physicalLocation=int8(machines{i}{3});
    stations{i}=makeDefaultLeverPressStation(id,path,mac,physicalLocation,screenNum,rewardMethod,pportaddr,'',startEyelinkIfAvail); % soundON is not set here

    boxes(i)=box(int8(i),fullfile(dataPath,'Boxes' , sprintf('box%d',i)));
    r=addBox(r,boxes(i));
    r=addStationToBoxID(r,stations{i},getID(boxes(i)));
end