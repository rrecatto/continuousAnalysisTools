function physiologyServer()
% Setup the basic variables
global ai;
global datablock;
global DAQFOLDER;
global STIMIP;
global DATAIP;
global EVENTSFOLDER;
global MACHINETYPE;
global SCRATCHFOLDER;

MACHINETYPE = getenv('MACHINETYPE');
DATAIP = getenv('DATAIP');
STIMIP = getenv('STIMIP');
DAQFOLDER = getenv('DAQFOLDER');
EVENTSFOLDER = getenv('EVENTSFOLDER');
SCRATCHFOLDER = getenv('SCRATCHFOLDER');
% =========================================================================
data=[];
ai=[];
datablock = [];
numDataBlocksCollected = 30;
% =========================================================================
%% size of the GUI - parameters
oneRowHeight=25;
margin=10;
fieldWidth=100;
nWidth = 14;
nHeight = 27;
fWidth=2*margin+nWidth*fieldWidth;
fHeight=margin+nHeight*oneRowHeight+margin;

%% analog input options

ai_parameters=[];
ai_parameters.numChans=32;  % 3 or 16 or 2 or 32
ai_parameters.sampRate=30000;
% ========================================================================================
% lists of values for settings
ampGainStrs = {'','1','2','5','10','20','50','100','200','1000'}; defaultGainIndex = 2;
ampLPStrs = {'','0.1','1','10','100','300','500'}; defaultLPIndex = 2;
ampHPStrs = {'','500','1000','5000','10000','20000'};defaultHPIndex = 6;
ampNotchStrs = {'','Out','In'}; defaultNotchIndex = 2;
ampModeStrs = {'','Rec','Imp','Stim'}; defaultModeIndex = 2;

subjSpeciesStrs={'',...
    'virtual',...
    'mouse',...
    'rat',...
    'human'};
    defaultSpeciesIndex = 2;
subjStrainStrs={'',... % none
    'N/A',... % virtual
    'wildtype','C57BL/6J','C57BL/6NJ',... % mouse
    'none',... % human
    }; 
    defaultStrainIndex = 4;
subjSexStrs = {'',...
    'male',...
    'female'};
    defaultSexIndex = 1;
geneBkgdStrs = {'none',...
    'PV-cre',...
    'SOM-cre',...
    'VGAT-cre',...
    'PV-ChR2XSOM-cre'};
    defaultGeneBkgdIndex = 1;
viralModStrs = {'none',...
    'flex-hM4D',...
    'flex-hM3D',...
    'flex-ChR',...
    'flex-Arch',...index = 
    };
    defaultViralModIndex = 1;
subjIDStrs={'',... % none
    'vdemo',... % virtual
    'mdemo',... % mouse
    'rdemo',... % rat
    'hdemo',... % human
    'bas056a',...
    'bas056b',...
    'bas057',...
    'bas060',...
    'bas061',...
    'bas062',...
    }; 
    defaultSubjIndex = 6;


protocolStrs={'ctxCharPtcl','ctxCharPtcl_LED','setProtocolCalibrateMonitor','mousePhysAndBehavior_11052014'};
experimenterStrs={'','bsriram','acmartin'}; defaultExperimenterIndex = 2;

electrodeMakeStrs={'Neuronexus','Glass','Quartz','FHC'};defaultTrodeMakeIndex = 1;
electrodeModelStrs={'','A1x32-Poly2-5mm-50s-177','A1x32-Poly3-5mm-25s-177','A1x32-Poly3-6mm-50-177','A1x32-5mm-25-177','Quartz-1um','A4X8-5mm-50-200-412-A32'};defaultTrodeModelIndex = 1;

lotNumStrs={'','4952'};defaultLotIndex = 1;
IDNumStrs={'','1','2','3','4','5','6','7','8','9','10','11','12'};defaultIDIndex = 1;
impedanceStrs={'','.5','1','2','5','10'};
monitorStrs = {'',...
    'Samsung2233RZ',...
    'ViewSonicV3D245'};
monitorMaxRes = {[nan nan],...
    [1680,1050],...
    [1920 1080]};
monitorAllowedRes={{[nan nan]},...
    {[1680 1050],[1440 900],[1280 800]},...
    {[1920 1080],[1360 768],[1280 720],[1067 600]}};
monitorAllowedResStrings={{'N/A'},...
    {'1680x1050','1440x900','1280x800'},...
    {'1920x1080','1360x768','1280X720','1067x600'}};


numChannels = {'1','2','4','16','32'};

defaultMonitorIndex = find(strcmp(monitorStrs,''));

running=false;
recording=false;
keepLooping=false;
runningLoop=false;
recordingT='start recording';
runningT='start trials';
cellT='start cell';
cellActive=false;
externalRequest=[];

neuralFilename=[];
neuralFilenameRaw = [];
stimFilename=[];
data=[];

eventTypeStrs={'comment','Prelim','top of fluid','top of brain','ctx cell','hipp cell',...
    'deadzone','theta chatter','visual hash','visual cell','electrode bend','clapping','subj obs',...
    'anesth check','muscimol','lidocaine','CNO','Summary','singleUnit'};


visualHashStrs={'weak','strong'};
snrStrs={[]};
for i=1:0.5:7
    snrStrs{end+1}=num2str(i);
end
vcTypeStrs={[],'on','off','unsure'};
vcEyeStrs={[],'ipsi','contra','both'};
vcBurstyStrs={[],'yes','no'};
vcRFAzimuthStrs={[]};
for i=-90:5:180
    vcRFAzimuthStrs{end+1}=num2str(i);
end
vcRFElevationStrs={[]};
for i=-90:5:180
    vcRFElevationStrs{end+1}=num2str(i);
end

arousalStrs={[],'awake','asleep','anesth'};
eyesStrs={[],'open','closed','squinty','stable','saccades','poor signal'};
faceStrs={[],'whisking','no whisking','grinding','licking','squeaking'};

isofluraneStrs={[],'0.0','0.25','0.5','0.75','1.0','1.25','1.5','2.0','2.5','3.0','4.0','5.0','oxy'};
withdrawalStrs={[],'none','sluggish','quick'};
breathPerMinStrs={[],'24-','30','36','42','48','54','60','66','72','78+'};
breathTypeStrs={[],'normal','arrhythmic','wheezing','hooting'};

muscimolConcStrsGPL = {[],'0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0'};
muscimolVolStrsUL = {[],'1','2','5','10','15','20'};

lidocaineConcStrsGPL = {[],'0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0'};
lidocaineVolStrsUL = {[],'1','2','5','10','15','20'};

CNOConcStrsGPL = {[],'0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0'};
CNOVolStrsUL = {[],'1','2','5','10','15','20'};

displayModeStrs={'condensed','stims','full'};


% indices for event types
defaultIndex=1;
visualHashIndex=find(strcmp(eventTypeStrs,'visual hash'));
cellIndices=find(ismember(eventTypeStrs,{'ctx cell','hipp cell','visual cell'}));
visualCellIndex=find(strcmp(eventTypeStrs,'visual cell'));
ratObsIndex=find(strcmp(eventTypeStrs,'subj obs'));
anesthCheckIndex=find(strcmp(eventTypeStrs,'anesth check'));
displayModeIndex=find(strcmp(displayModeStrs,'condensed'));
muscimolIndex=find(strcmp(eventTypeStrs,'muscimol'));
lidocaineIndex=find(strcmp(eventTypeStrs,'lidocaine'));
CNOIndex=find(strcmp(eventTypeStrs,'CNO'));
singleUnitIndex=find(strcmp(eventTypeStrs,'singleUnit')); 

% get the orientation images
imagesFile = fullfile(getRatrixPath,'util','other','axisOrientation.mat');
temp = stochasticLoad(imagesFile,{'UpLeft','UpRight','DownLeft','DownRight'});
UpLeft = temp.UpLeft;
UpRight = temp.UpRight;
DownLeft = temp.DownLeft;
DownRight = temp.DownRight;
% ========================================================================================
events_data=[];
labels=[];
eventNum=1;
eventsToSendIndex=1;
savePath=fullfile(EVENTSFOLDER,subjIDStrs{defaultIndex},datestr(now,'mm.dd.yyyy'));
historyDates={};
historyDateIndex=[];
% ========================================================================================
%% the GUI
f = figure('Visible','off',...
    'MenuBar','none',...
    'Name','physiology GUI',...
    'NumberTitle','off',...
    'Resize','off',...
    'Units','pixels',...
    'Position',[50 50 fWidth fHeight],...
    'CloseRequestFcn',@cleanup,....
    'CreateFcn',@initialize);
    function initialize(source,eventdata)
        disp('Initializing Recording setup');
        ai = startINTAN();
        ai_parameters.boardConfig = ai.get_configuration_parameters();
        datablock = rhd2000.datablock.DataBlock(ai);
    end
    function cleanup(source,eventdata)
        if running
            errordlg('must stop running before closing','error','modal')
        else
            FlushEvents('mouseUp','mouseDown','keyDown','autoKey','update');
            ListenChar(0) %'called listenchar(0) -- why doesn''t keyboard work?'
            ShowCursor(0)
            clear ai datablock;
            closereq;
            return;
        end
    end % end cleanup function
    function updateDisplay(source,eventdata)
        doDisplayUpdate(displayModeStrs{get(displayModeSelector,'Value')});
    end
    function doDisplayUpdate(mode)
        dispStrs = createDisplayStrs(events_data,labels,mode);
        
        set(recentEventsDisplay,'String',dispStrs);
    end % end function

    function updateUI()
        % updates the physiologyServer UI control panel (not the recent events display)
        if recording
            recordingT='stop recording';
        else
            recordingT='start recording';
        end
        if running
            runningT='stop trials';
        else
            runningT='start trials';
        end
        set(toggleRecordingButton,'String',recordingT);
        set(toggleTrialsButton,'String',runningT);
        set(toggleCellButton,'String',cellT);
        
        % previous, next, and today buttons
        if historyDateIndex>1
            set(previousDayButton,'Enable','on');
        else
            set(previousDayButton,'Enable','off');
        end
        if historyDateIndex==length(historyDates)
            set(nextDayButton,'Enable','off');
            set(todayButton,'Enable','off');
        else
            set(nextDayButton,'Enable','on');
            set(todayButton,'Enable','on');
        end
        
        drawnow;
    end 

    function turnOffAllLabelsAndMenus()
        set(visualHashLabel,'Visible','off');
        set(snrLabel,'Visible','off');
        set(vcTypeLabel,'Visible','off');
        set(vcEyeLabel,'Visible','off');
        set(vcBurstyLabel,'Visible','off');
        set(vcRFAzimuthLabel,'Visible','off');
        set(vcRFElevationLabel,'Visible','off');
        set(arousalLabel,'Visible','off');
        set(eyesLabel,'Visible','off');
        set(faceLabel,'Visible','off');
        set(isofluraneLabel,'Visible','off');
        set(withdrawalLabel,'Visible','off');
        set(breathPerMinLabel,'Visible','off');
        set(breathTypeLabel,'Visible','off');
        set(visualHashMenu,'Visible','off','Enable','off');
        set(snrMenu,'Visible','off','Enable','off');
        set(vcTypeMenu,'Visible','off','Enable','off');
        set(vcEyeMenu,'Visible','off','Enable','off');
        set(vcBurstyMenu,'Visible','off','Enable','off');
        set(vcRFAzimuthMenu,'Visible','off','Enable','off');
        set(vcRFElevationMenu,'Visible','off','Enable','off');
        set(arousalMenu,'Visible','off','Enable','off');
        set(eyesMenu,'Visible','off','Enable','off');
        set(faceMenu,'Visible','off','Enable','off');
        set(isofluraneMenu,'Visible','off','Enable','off');
        set(withdrawalMenu,'Visible','off','Enable','off');
        set(breathPerMinMenu,'Visible','off','Enable','off');
        set(breathTypeMenu,'Visible','off','Enable','off');
        set(muscimolConcLabel,'Visible','off');
        set(muscimolVolLabel,'Visible','off');
        set(muscimolConcMenu,'Visible','off');
        set(muscimolVolMenu,'Visible','off');
        set(lidocaineConcLabel,'Visible','off');
        set(lidocaineVolLabel,'Visible','off');
        set(lidocaineConcMenu,'Visible','off');
        set(lidocaineVolMenu,'Visible','off');
        set(CNOConcLabel,'Visible','off');
        set(CNOVolLabel,'Visible','off');
        set(CNOConcMenu,'Visible','off');
        set(CNOVolMenu,'Visible','off');
        set(singleUnitStartTrialLabel,'Visible','off');
        set(singleUnitStopTrialLabel,'Visible','off');
        set(singleUnitThrVLabel,'Visible','off');
        set(singleUnitStartTrialMenu,'Visible','off');
        set(singleUnitStopTrialMenu,'Visible','off');
        set(singleUnitThrVMenu,'Visible','off');

    end

% =========================================================================
% the grand header!
GrandHeader = uicontrol(f,'Style','text','String','Physiology & Behavior Server','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center', 'FontSize',15,'Position',[0 fHeight-oneRowHeight 3.25*fieldWidth oneRowHeight]);
% ========================================================================================
% ========================================================================================
% ========================================================================================
% ========================================================================================
% ========================================================================================
%% These fields remain visible at all times
% experimenter
experimenterLabel = uicontrol(f,'Style','text','String','Experimenter','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin fHeight-2*oneRowHeight-margin fieldWidth oneRowHeight]);
experimenterField = uicontrol(f,'Style','popupmenu','String',experimenterStrs,'Visible','on','Units','pixels','Value',defaultExperimenterIndex,'Enable','on','Position',[margin+fieldWidth fHeight-2*oneRowHeight-margin 1.1*fieldWidth oneRowHeight],'BackgroundColor','w');

% date selector for which day's event to show and write to
dateLabel = uicontrol(f,'Style','text','String','Event date','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin fHeight-3*oneRowHeight-margin fieldWidth oneRowHeight]);

dateField = uicontrol(f,'Style','text','String',datestr(now,'mm.dd.yyyy'),'Visible','on','Units','pixels','HorizontalAlignment','center','Position',[(1.4)*fieldWidth-1.5*margin fHeight-3*oneRowHeight-margin fieldWidth*0.6 oneRowHeight*0.8]);
nextDayButton = uicontrol(f,'Style','pushbutton','String','>','Visible','on','Units','pixels','Enable','off','FontWeight','bold','HorizontalAlignment','center','CallBack',@nextDay,'Position',[2*fieldWidth-1.5*margin fHeight-3*oneRowHeight-margin 1.5*margin oneRowHeight]);
previousDayButton = uicontrol(f,'Style','pushbutton','String','<','Visible','on','Units','pixels','Enable','on','FontWeight','bold','HorizontalAlignment','center','CallBack',@previousDay,'Position',[(1.4)*fieldWidth-3*margin fHeight-3*oneRowHeight-margin 1.5*margin oneRowHeight]);    
todayButton = uicontrol(f,'Style','pushbutton','String','>>','Visible','on','Units','pixels','Enable','off','FontWeight','bold','HorizontalAlignment','center','CallBack',@goToToday,'Position',[2*fieldWidth+0*margin fHeight-3*oneRowHeight-margin 2*margin oneRowHeight]);
    function nextDay(source,eventdata)
        historyDateIndex=historyDateIndex+1;
        set(dateField,'String',historyDates{historyDateIndex});
        updateUI();
        reloadEventsAndSurgeryFields([],[],false);
    end
    function previousDay(source,eventdata)
        historyDateIndex=historyDateIndex-1;
        set(dateField,'String',historyDates{historyDateIndex});
        updateUI();
        reloadEventsAndSurgeryFields([],[],false);
    end
    function goToToday(source,eventdata)
        historyDateIndex=length(historyDates);
        set(dateField,'String',historyDates{historyDateIndex});
        updateUI();
        reloadEventsAndSurgeryFields([],[],false);
    end

% current anchor label
currentPosAPlabel = uicontrol(f,'Style','text','String','AP(mm)','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[1*margin+1*fieldWidth fHeight-8*oneRowHeight-margin 0.75*fieldWidth oneRowHeight]);
currentPosMLlabel = uicontrol(f,'Style','text','String','ML(mm)','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[1*margin+1.75*fieldWidth fHeight-8*oneRowHeight-margin 0.75*fieldWidth oneRowHeight]);
currentPosZlabel = uicontrol(f,'Style','text','String','Z(mm)','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[1*margin+2.5*fieldWidth fHeight-8*oneRowHeight-margin 0.75*fieldWidth oneRowHeight]);
currentAnchorLabel = uicontrol(f,'Style','text','String','Current Anchor','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+0*fieldWidth fHeight-9*oneRowHeight-margin fieldWidth oneRowHeight]);
% current anchor text field
currentAnchorAPField = uicontrol(f,'Style','edit','String','nan','Visible','on','Units','pixels','Enable','off','Position',[1*margin+1*fieldWidth fHeight-9*oneRowHeight-margin 0.75*fieldWidth oneRowHeight]);
currentAnchorMLField = uicontrol(f,'Style','edit','String','nan','Visible','on','Units','pixels','Enable','off','Position',[1*margin+1.75*fieldWidth fHeight-9*oneRowHeight-margin 0.75*fieldWidth oneRowHeight]);
currentAnchorZField = uicontrol(f,'Style','edit','String','nan','Visible','on','Units','pixels','Enable','off','Position',[1*margin+2.5*fieldWidth fHeight-9*oneRowHeight-margin 0.75*fieldWidth oneRowHeight]);

% checkbox to enable current anchor field input
enableCurrentAnchorField = uicontrol(f,'Style','checkbox','String','','Enable','on','Visible','on','Value',0,'Units','pixels','Position',[1.25*margin+3.25*fieldWidth fHeight-9*oneRowHeight-margin 2*margin oneRowHeight],'CallBack',@enableCurrentAnchorEntry);
    function enableCurrentAnchorEntry(source,eventdata)
        if get(enableCurrentAnchorField,'Value')==1
            set(currentAnchorAPField,'Enable','on');
            set(currentAnchorMLField,'Enable','on');
            set(currentAnchorZField,'Enable','on');
        else
            set(currentAnchorAPField,'Enable','off');
            set(currentAnchorMLField,'Enable','off');
            set(currentAnchorZField,'Enable','off');
            
            % find theoretical LGN
            APOrientation = 2*double(~get(APOrientationMenu,'Value'))-1;
            MLOrientation = 2*double(~get(MLOrientationMenu,'Value'))-1;
            surgeryAPOrientation = 2*double(~get(surgeryAPOrientationMenu,'Value'))-1;
            surgeryMLOrientation = 2*double(~get(surgeryMLOrientationMenu,'Value'))-1;
            surgeryB = [str2double(get(surgeryBregmaAPField,'String')) str2double(get(surgeryBregmaMLField,'String')) str2double(get(surgeryBregmaZField,'String'))];
            surgeryA = [str2double(get(surgeryAnchorAPField,'String')) str2double(get(surgeryAnchorMLField,'String')) str2double(get(surgeryAnchorZField,'String'))];
            currA = [str2double(get(currentAnchorAPField,'String')) str2double(get(currentAnchorMLField,'String')) str2double(get(currentAnchorZField,'String'))];
            
            translation=surgeryB-surgeryA;  % vector surg.anchor -> surg.bregma
            translation(:,1)=surgeryAPOrientation'.*translation(:,1);
            translation(:,2)=surgeryMLOrientation'.*translation(:,2);
            translation(:,3)=-translation(:,3);
                        
            LGNCentre = [-4.5 -3.5 -4.5];
            current_offset=translation - LGNCentre;
            
            current_offset(:,1) = current_offset(:,1)/APOrientation; % flip AP
            current_offset(:,2) = current_offset(:,2)/MLOrientation; % flipML
            current_offset(:,3) = -current_offset(:,3); % flipML
            % calculate current position
            LGNraw = current_offset+currA; % vector anch -> curr
            
            set(theoreticalLGNCenterAPField,'String',num2str(LGNraw(1)));
            set(theoreticalLGNCenterMLField,'String',num2str(LGNraw(2)));
            set(theoreticalLGNCenterZField,'String',num2str(LGNraw(3)));
        end
        
    end % end enableCurrentAnchorEntry function

% calculated theoretical center of LGN display
theoreticalLGNCenterLabel = uicontrol(f,'Style','text','String','theor. LGN center','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+0*fieldWidth fHeight-10*oneRowHeight-margin fieldWidth oneRowHeight]);
theoreticalLGNCenterAPField = uicontrol(f,'Style','edit','String','NaN','Visible','on','Units','pixels','Enable','off','Position',[1*margin+1*fieldWidth fHeight-10*oneRowHeight-margin 0.75*fieldWidth oneRowHeight],'HorizontalAlignment','center');
theoreticalLGNCenterMLField = uicontrol(f,'Style','edit','String','NaN','Visible','on','Units','pixels','Enable','off','Position',[1*margin+1.75*fieldWidth fHeight-10*oneRowHeight-margin 0.75*fieldWidth oneRowHeight],'HorizontalAlignment','center');
theoreticalLGNCenterZField = uicontrol(f,'Style','edit','String','NaN','Visible','on','Units','pixels','Enable','off','Position',[1*margin+2.5*fieldWidth fHeight-10*oneRowHeight-margin 0.75*fieldWidth oneRowHeight],'HorizontalAlignment','center');

% ========================================================================================
% calculated current - what is 'current' anyways?
currentLabel = uicontrol(f,'Style','text','String','Current','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+0*fieldWidth fHeight-11*oneRowHeight-margin fieldWidth oneRowHeight]);
currentAPField = uicontrol(f,'Style','edit','String','NaN','Visible','on','Units','pixels','Enable','off','Position',[1*margin+1*fieldWidth fHeight-11*oneRowHeight-margin 0.75*fieldWidth oneRowHeight],'HorizontalAlignment','center');
currentMLField = uicontrol(f,'Style','edit','String','NaN','Visible','on','Units','pixels','Enable','off','Position',[1*margin+1.75*fieldWidth fHeight-11*oneRowHeight-margin 0.75*fieldWidth oneRowHeight],'HorizontalAlignment','center');
currentZField = uicontrol(f,'Style','edit','String','NaN','Visible','on','Units','pixels','Enable','off','Position',[1*margin+2.5*fieldWidth fHeight-11*oneRowHeight-margin 0.75*fieldWidth oneRowHeight],'HorizontalAlignment','center');


% start eyeLink?
eyeLinkStartButton = uicontrol(f,'Style','checkbox','String','eyeLink','Enable','on','Visible','off','Value',0,'Units','pixels','Position',[margin+8.2*fieldWidth fHeight-17*oneRowHeight-margin fieldWidth*0.7 oneRowHeight]);
% delete db?
recreateDBCheckbox = uicontrol(f,'Style','checkbox','String','delete db','Enable','on','Visible','on','Value',1,'Units','pixels','Position',[margin+8.2*fieldWidth fHeight-18*oneRowHeight-margin fieldWidth*0.7 oneRowHeight]);

% ========================================================================================
% current event parameters - labels
eventTypeLabel = uicontrol(f,'Style','text','String','event type','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+0*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
muscimolConcLabel = uicontrol(f,'Style','text','String','musc. conc.(g/l)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
muscimolVolLabel = uicontrol(f,'Style','text','String','musc. vol(uL)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
lidocaineConcLabel = uicontrol(f,'Style','text','String','lido. conc.(g/l)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
lidocaineVolLabel = uicontrol(f,'Style','text','String','lido. vol(uL)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
CNOConcLabel = uicontrol(f,'Style','text','String','CNO conc.(g/l)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
CNOVolLabel = uicontrol(f,'Style','text','String','CNO vol(uL)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
visualHashLabel = uicontrol(f,'Style','text','String','visual hash','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
snrLabel = uicontrol(f,'Style','text','String','SNR','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
vcTypeLabel = uicontrol(f,'Style','text','String','vc type','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
vcEyeLabel = uicontrol(f,'Style','text','String','vc eye','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+3*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
vcBurstyLabel = uicontrol(f,'Style','text','String','vc bursty','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+4*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
vcRFAzimuthLabel = uicontrol(f,'Style','text','String','vc RF azimuth','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+5*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
vcRFElevationLabel = uicontrol(f,'Style','text','String','vc RF elevation (+ is up/right)','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+6*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
arousalLabel = uicontrol(f,'Style','text','String','arousal','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
eyesLabel = uicontrol(f,'Style','text','String','eyes','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
faceLabel = uicontrol(f,'Style','text','String','face','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+3*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
isofluraneLabel = uicontrol(f,'Style','text','String','isoflurane','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
withdrawalLabel = uicontrol(f,'Style','text','String','withdrawal','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
breathPerMinLabel = uicontrol(f,'Style','text','String','breath/min','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+3*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
breathTypeLabel = uicontrol(f,'Style','text','String','breath type','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+4*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
singleUnitStartTrialLabel = uicontrol(f,'Style','text','String','start trial','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+1*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
singleUnitStopTrialLabel = uicontrol(f,'Style','text','String','stop trial','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+2*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);
singleUnitThrVLabel = uicontrol(f,'Style','text','String','thrV','Visible','off','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+3*fieldWidth fHeight-13*oneRowHeight-margin fieldWidth oneRowHeight]);

% ========================================================================================
% current event parameters - dropdown menus
eventTypeMenu = uicontrol(f,'Style','popupmenu','String',eventTypeStrs,'Visible','on','Units','pixels','Enable','on','Value',defaultIndex,'Callback',@eventTypeC,'Position',[margin+0*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
    function eventTypeC(source,eventdata)
        turnOffAllLabelsAndMenus();
        if get(eventTypeMenu,'Value')==visualHashIndex
            set(visualHashLabel,'Visible','on');
            set(visualHashMenu,'Visible','on','Enable','on');
        elseif get(eventTypeMenu,'Value')==ratObsIndex
            set(arousalLabel,'Visible','on');
            set(eyesLabel,'Visible','on');
            set(faceLabel,'Visible','on');
            set(arousalMenu,'Visible','on','Enable','on');
            set(eyesMenu,'Visible','on','Enable','on');
            set(faceMenu,'Visible','on','Enable','on');
        elseif get(eventTypeMenu,'Value')==anesthCheckIndex
            set(isofluraneLabel,'Visible','on');
            set(withdrawalLabel,'Visible','on');
            set(breathPerMinLabel,'Visible','on');
            set(breathTypeLabel,'Visible','on');
            set(isofluraneMenu,'Visible','on','Enable','on');
            set(withdrawalMenu,'Visible','on','Enable','on');
            set(breathPerMinMenu,'Visible','on','Enable','on');
            set(breathTypeMenu,'Visible','on','Enable','on');
        elseif any(cellIndices==get(eventTypeMenu,'Value'))
            set(snrLabel,'Visible','on');
            set(snrMenu,'Visible','on','Enable','on');
            if get(eventTypeMenu,'Value')==visualCellIndex
                set(vcTypeLabel,'Visible','on');
                set(vcEyeLabel,'Visible','on');
                set(vcBurstyLabel,'Visible','on');
                set(vcRFAzimuthLabel,'Visible','on');
                set(vcRFElevationLabel,'Visible','on');
                set(vcTypeMenu,'Visible','on','Enable','on');
                set(vcEyeMenu,'Visible','on','Enable','on');
                set(vcBurstyMenu,'Visible','on','Enable','on');
                set(vcRFAzimuthMenu,'Visible','on','Enable','on');
                set(vcRFElevationMenu,'Visible','on','Enable','on');
            end
        elseif  get(eventTypeMenu,'Value')==muscimolIndex
            set(muscimolConcLabel,'Visible','on');
            set(muscimolVolLabel,'Visible','on');
            set(muscimolConcMenu,'Visible','on','Enable','on');
            set(muscimolVolMenu,'Visible','on','Enable','on');
        elseif  get(eventTypeMenu,'Value')==lidocaineIndex
            set(lidocaineConcLabel,'Visible','on');
            set(lidocaineVolLabel,'Visible','on');
            set(lidocaineConcMenu,'Visible','on','Enable','on');
            set(lidocaineVolMenu,'Visible','on','Enable','on');
        elseif  get(eventTypeMenu,'Value')==CNOIndex
            set(CNOConcLabel,'Visible','on');
            set(CNOVolLabel,'Visible','on');
            set(CNOConcMenu,'Visible','on','Enable','on');
            set(CNOVolMenu,'Visible','on','Enable','on');
        elseif get(eventTypeMenu,'Value')==singleUnitIndex
            set(singleUnitStartTrialLabel,'Visible','on');
            set(singleUnitStopTrialLabel,'Visible','on');
            set(singleUnitThrVLabel,'Visible','on');
            set(singleUnitStartTrialMenu,'Visible','on');
            set(singleUnitStopTrialMenu,'Visible','on');
            set(singleUnitThrVMenu,'Visible','on');
        else
            % do nothing - already all off
        end
    end % end function

visualHashMenu = uicontrol(f,'Style','popupmenu','String',visualHashStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

snrMenu = uicontrol(f,'Style','popupmenu','String',snrStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
vcTypeMenu = uicontrol(f,'Style','popupmenu','String',vcTypeStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
vcEyeMenu = uicontrol(f,'Style','popupmenu','String',vcEyeStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+3*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
vcBurstyMenu = uicontrol(f,'Style','popupmenu','String',vcBurstyStrs,'Visible','off','Units','pixels','Position',[margin+4*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
vcRFAzimuthMenu = uicontrol(f,'Style','popupmenu','String',vcRFAzimuthStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+5*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
vcRFElevationMenu = uicontrol(f,'Style','popupmenu','String',vcRFElevationStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+6*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

arousalMenu = uicontrol(f,'Style','popupmenu','String',arousalStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
eyesMenu = uicontrol(f,'Style','popupmenu','String',eyesStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
faceMenu = uicontrol(f,'Style','popupmenu','String',faceStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+3*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

isofluraneMenu = uicontrol(f,'Style','popupmenu','String',isofluraneStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
withdrawalMenu = uicontrol(f,'Style','popupmenu','String',withdrawalStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
breathPerMinMenu = uicontrol(f,'Style','popupmenu','String',breathPerMinStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+3*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
breathTypeMenu = uicontrol(f,'Style','popupmenu','String',breathTypeStrs,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+4*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

muscimolConcMenu = uicontrol(f,'Style','popupmenu','String',muscimolConcStrsGPL,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
muscimolVolMenu = uicontrol(f,'Style','popupmenu','String',muscimolVolStrsUL,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

lidocaineConcMenu = uicontrol(f,'Style','popupmenu','String',lidocaineConcStrsGPL,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
lidocaineVolMenu = uicontrol(f,'Style','popupmenu','String',lidocaineVolStrsUL,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

CNOConcMenu = uicontrol(f,'Style','popupmenu','String',CNOConcStrsGPL,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
CNOVolMenu = uicontrol(f,'Style','popupmenu','String',CNOVolStrsUL,'Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);

singleUnitStartTrialMenu = uicontrol(f,'Style','edit','Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+1*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
singleUnitStopTrialMenu = uicontrol(f,'Style','edit','Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+2*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);
singleUnitThrVMenu = uicontrol(f,'Style','edit','Visible','off','Units','pixels','Enable','off','Value',defaultIndex,'Position',[margin+3*fieldWidth fHeight-14*oneRowHeight-margin fieldWidth oneRowHeight]);


% ========================================================================================
% ========================================================================================
% ========================================================================================
% ========================================================================================
% ========================================================================================
%% The following will be visible only when asked for

    function clearAllDetailsPanels(source,eventdata)
        % rigAmpMonDetails
        set(rigPanel,'Visible','off');
        set(ampPanel,'Visible','off');
        set(monitorPanel,'Visible','off');
        set(surgeryPanel,'Visible','off');
        set(stereotaxPanel,'Visible','off');
        set(stereotaxSurgPanel,'Visible','off');
        set(subjectPanel,'Visible','off');
        set(electrodePanel,'Visible','off');
        set(protocolPanel,'Visible','off');
        set(otherRecordingDetailsPanel,'Visible','off');
    end
    function selectPanelToDisplay(source,eventdata)
        switch get(eventdata.NewValue,'String')
            case 'Rig/Amp/Monitor'
                displayRigAmpMonPanels
            case 'Surgery/Stereotax'
                displaySurgeryAndAxisPanels
            case 'Subj/Trode/Ptcl'
                displaySubjectTrodePanels
        end
    end
% mainPanel = uipanel('Units','pixels','Position',[margin+(5)*fieldWidth margin+(nHeight-11)*oneRowHeight 4*fieldWidth+margin 11*oneRowHeight],'title','Details');
rigAmpMonPanel = uipanel('Units','pixels','Position',[margin+(5)*fieldWidth margin+(nHeight-11)*oneRowHeight 4*fieldWidth+margin 11*oneRowHeight],'title','Rig, Amplifier and Monitor details');
stereotaxSurgeryPanel = uipanel('Units','pixels','Position',[margin+(9.5)*fieldWidth margin+(nHeight-11)*oneRowHeight 4*fieldWidth+margin 11*oneRowHeight],'title','Surgery and Stereotaxy details');
subjectElectrodeProtocolPanel = uipanel('Units','pixels','Position',[margin+(9.5)*fieldWidth margin+(nHeight-26.4)*oneRowHeight 4*fieldWidth+margin 15*oneRowHeight],'title','Subject, Protocol and Electrode details');

% detailsSelector = uibuttongroup('Units','pixels','Visible','on','Position',[margin+(3.5)*fieldWidth margin+(nHeight-11)*oneRowHeight 1.4*fieldWidth 5*oneRowHeight],'SelectionChangeFcn',@selectPanelToDisplay,'title','Choose Detail:');
%% rigAmpMonDetails
% rigAmpMonDetails = uicontrol('Style','radiobutton','String','Rig/Amp/Monitor','Units','pixels','Position',[0.07*fieldWidth 0.25*oneRowHeight 1.3*fieldWidth oneRowHeight],'Visible','on','parent',detailsSelector);
%     function displayRigAmpMonPanels(source,eventdata)
%         clearAllDetailsPanels
%         set(rigPanel,'Visible','on');
%         set(ampPanel,'Visible','on');
%         set(monitorPanel,'Visible','on');
%     end
rigPanel = uipanel('Parent',rigAmpMonPanel,'Units','normalized','Position',[0.01 0.71 0.98 0.28],'title','Rig Details','Visible','on');
ampPanel = uipanel('Parent',rigAmpMonPanel,'Units','normalized','Position',[0.01 0.42 0.98 0.28],'title','Amp Details','Visible','on');
monitorPanel = uipanel('Parent',rigAmpMonPanel,'Units','normalized','Position',[0.01 0.05 0.98 0.36],'title','Monitor Details','Visible','on');
% rigState details
DistHeader = uicontrol(rigPanel,'Style','text','String','Distance','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.05 0.7 0.3 0.28]);
HeightHeader = uicontrol(rigPanel,'Style','text','String','Height','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.35 0.7 0.3 0.28]);
AngleHeader = uicontrol(rigPanel,'Style','text','String','Angle','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.65 0.7 0.3 0.28]);
rigDistField = uicontrol(rigPanel,'Style','edit','String','15','Units','normalized','Visible','on','Enable','off','Position',[0.05 0.33 0.3 0.35]);
rigHeightField = uicontrol(rigPanel,'Style','edit','String','20.3','Units','normalized','Visible','on','Enable','off','Position',[0.35 0.33 0.3 0.35]);
rigAngleField = uicontrol(rigPanel,'Style','edit','String','45','Units','normalized','Visible','on','Enable','off','Position',[0.65 0.33 0.3 0.35]);
% checkbox to enable rig field input
enableRigStateFields = uicontrol(rigPanel,'Style','checkbox','String','unlock','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.85 0.03 0.13 0.25],'CallBack',@enableRigStateEntry);
    function enableRigStateEntry(source,eventdata)
        if get(enableRigStateFields,'Value')==1
            set(rigDistField,'Enable','on');
            set(rigHeightField,'Enable','on');
            set(rigAngleField,'Enable','on');
        else
            set(rigDistField,'Enable','off');
            set(rigHeightField,'Enable','off');
            set(rigAngleField,'Enable','off');
        end
    end % end enableRigStateEntry function

% ampStateDetails
ampGainHeader = uicontrol(ampPanel,'Style','text','String','Gain','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.05 0.7 0.15 0.28]);
ampLPHeader = uicontrol(ampPanel,'Style','text','String','LCO','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.2 0.7 0.15 0.28]);
ampHPHeader = uicontrol(ampPanel,'Style','text','String','HCO','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.35 0.7 0.15 0.28]);
ampNotchHeader = uicontrol(ampPanel,'Style','text','String','Notch','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.5 0.7 0.15 0.28]);
ampModeHeader = uicontrol(ampPanel,'Style','text','String','Mode','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.65 0.7 0.15 0.28]);
ampCapCompHeader = uicontrol(ampPanel,'Style','text','String','Cap','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.8 0.7 0.15 0.28]);

ampGainField = uicontrol(ampPanel,'Style','popupmenu','String',ampGainStrs,'Units','normalized','Visible','on','Value',defaultGainIndex,'Enable','off','Position',[0.05 0.33 0.15 0.28],'BackgroundColor','w');
ampLPField = uicontrol(ampPanel,'Style','popupmenu','String',ampLPStrs,'Units','normalized','Visible','on','Value',defaultLPIndex,'Enable','off','Position',[0.2 0.33 0.15 0.28],'BackgroundColor','w');
ampHPField = uicontrol(ampPanel,'Style','popupmenu','String',ampHPStrs,'Units','normalized','Visible','on','Value',defaultHPIndex,'Enable','off','Position',[0.35 0.33 0.15 0.28],'BackgroundColor','w');
ampNotchField = uicontrol(ampPanel,'Style','popupmenu','String',ampNotchStrs,'Units','normalized','Visible','on','Value',defaultNotchIndex,'Enable','off','Position',[0.5 0.33 0.15 0.28],'BackgroundColor','w');
ampModeField = uicontrol(ampPanel,'Style','popupmenu','String',ampModeStrs,'Units','normalized','Visible','on','Value',defaultModeIndex,'Enable','off','Position',[0.65 0.33 0.15 0.28],'BackgroundColor','w');
ampCapCompField = uicontrol(ampPanel,'Style','edit','String','0','Units','normalized','Visible','on','Enable','off','Position',[0.8 0.33 0.15 0.28],'BackgroundColor','w');

% checkbox to enable amp field input
enableAmpStateFields = uicontrol(ampPanel,'Style','checkbox','String','unlock','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.85 0.03 0.13 0.25], 'CallBack',@enableAmpStateEntry);
    function enableAmpStateEntry(source,eventdata)
        if get(enableAmpStateFields,'Value')==1
            set(ampGainField,'Enable','on');
            set(ampLPField,'Enable','on');
            set(ampHPField,'Enable','on');
            set(ampNotchField,'Enable','on');
            set(ampModeField,'Enable','on');
            set(ampCapCompField,'Enable','on');
        else
            set(ampGainField,'Enable','off');
            set(ampLPField,'Enable','off');
            set(ampHPField,'Enable','off');
            set(ampNotchField,'Enable','off');
            set(ampModeField,'Enable','off');
            set(ampCapCompField,'Enable','off');
        end
    end % end enableAmpStateEntry function

% draw the monitor field
monitorStateLabel = uicontrol(monitorPanel,'Style','text','String','Monitor','Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.05 0.75 0.15 0.22]);
monitorWidthLabel = uicontrol(monitorPanel,'Style','text','String','w(cm):','Visible','off','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.25 0.75 0.15 0.23]);
monitorHeightLabel = uicontrol(monitorPanel,'Style','text','String','h(cm):','Visible','off','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.25 0.52 0.15 0.23]);
monitorWidthAngLabel = uicontrol(monitorPanel,'Style','text','String','w(deg):','Visible','off','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.25 0.29 0.15 0.23]);
monitorHeightAngLabel = uicontrol(monitorPanel,'Style','text','String','h(deg):','Visible','off','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.25 0.06 0.15 0.23]);

monitorStateField = uicontrol(monitorPanel,'Style','popupmenu','String',monitorStrs,'Units','normalized','Visible','on','Value',defaultMonitorIndex,'Enable','on','Position',[0.01 0.52 0.23 0.26],'BackgroundColor','w','Callback',@calculateMonitorDetails);

monitorWidthField = uicontrol(monitorPanel,'Style','text','String','NaN','Units','normalized','Visible','on','Position',[0.40 0.75 0.1 0.23],'BackgroundColor','w');
monitorHeightField = uicontrol(monitorPanel,'Style','text','String','NaN','Units','normalized','Visible','on','Position',[0.40 0.52 0.1 0.23],'BackgroundColor','w');
monitorWidthAngField = uicontrol(monitorPanel,'Style','text','String','NaN','Units','normalized','Visible','on','Position',[0.40 0.29 0.1 0.23],'BackgroundColor','w');
monitorHeightAngField = uicontrol(monitorPanel,'Style','text','String','NaN','Units','normalized','Visible','on','Position',[0.40 0.06 0.1 0.23],'BackgroundColor','w');

monitorMaxResolutionLabel = uicontrol(monitorPanel,'Style','text','String','Max Res.','Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.02 0.24 0.23 0.22]);
monitorMaxResolutionLabelx = uicontrol(monitorPanel,'Style','text','String','NaN','Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.01 0.02 0.12 0.22]);
monitorMaxResolutionLabely = uicontrol(monitorPanel,'Style','text','String','NaN','Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.14 0.02 0.12 0.22]);

monitorAvailableResolutionsLabel = uicontrol(monitorPanel,'Style','text','String','Avail. Res.','Units','normalized','Visible','on','Position',[0.55 0.75 0.25 0.23],'BackgroundColor','w');
monitorAvailableResolutionsField = uicontrol(monitorPanel,'Style','popupmenu','String',monitorAllowedRes{1}{1},'Units','normalized','Visible','on','Value',1,'Position',[0.55 0.52 0.25 0.23],'BackgroundColor','w');

    function calculateMonitorDetails(source,eventdata)
        switch monitorStrs{get(monitorStateField,'value')}
            case '' 
                monWidthStr = sprintf('%2.1f',NaN);
                monHeightStr = sprintf('%2.1f',NaN);
                monWidthAngleStr = sprintf('%2.1f',NaN);
                monHeightAngleStr = sprintf('%2.1f',NaN);
            case 'Samsung2233RZ'
                monWidth = 51.68;% cm
                monHeight = 42.13;% cm
                monWidthStr = sprintf('%2.1f',monWidth);
                monHeightStr = sprintf('%2.1f',monHeight);
                dist2mon = str2num(get(rigDistField,'String'));
                monWidthAng = rad2deg(2*atan(monWidth/(2*dist2mon)));
                monHeightAng = rad2deg(2*atan(monHeight/(2*dist2mon)));
                monWidthAngleStr = sprintf('%2.1f',monWidthAng);
                monHeightAngleStr = sprintf('%2.1f',monHeightAng);
            case 'ViewSonicV3D245'
                monWidth = 56.642; %cm
                monHeight = 36.83; %cm 
                monWidthStr = sprintf('%2.1f',monWidth);
                monHeightStr = sprintf('%2.1f',monHeight);
                dist2mon = str2num(get(rigDistField,'String'));
                monWidthAng = rad2deg(2*atan(monWidth/(2*dist2mon)));
                monHeightAng = rad2deg(2*atan(monHeight/(2*dist2mon)));
                monWidthAngleStr = sprintf('%2.1f',monWidthAng);
                monHeightAngleStr = sprintf('%2.1f',monHeightAng);
        end
        whichMon = get(monitorStateField,'value');
        monitorMaxResx = monitorMaxRes{whichMon}(1);
        monitorMaxResy = monitorMaxRes{whichMon}(2);
        maxResx = sprintf('x:%d',monitorMaxResx);
        maxResy = sprintf('y:%d',monitorMaxResy);
        currAllowedRes = monitorAllowedRes{whichMon};
        currAllowedResStrings = monitorAllowedResStrings{whichMon};
        
        monitorWidthField = uicontrol(monitorPanel,'Style','text','String',monWidthStr,'Units','normalized','Visible','on','Position',[0.40 0.75 0.1 0.23],'BackgroundColor','w');
        monitorHeightField = uicontrol(monitorPanel,'Style','text','String',monHeightStr,'Units','normalized','Visible','on','Position',[0.40 0.52 0.1 0.23],'BackgroundColor','w');
        monitorWidthAngField = uicontrol(monitorPanel,'Style','text','String',monWidthAngleStr,'Units','normalized','Visible','on','Position',[0.40 0.29 0.1 0.23],'BackgroundColor','w');
        monitorHeightAngField = uicontrol(monitorPanel,'Style','text','String',monHeightAngleStr,'Units','normalized','Visible','on','Position',[0.40 0.06 0.1 0.23],'BackgroundColor','w');
        
        monitorMaxResolutionLabel = uicontrol(monitorPanel,'Style','text','String','Max Res.','Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.02 0.24 0.23 0.22]);
        monitorMaxResolutionLabelx = uicontrol(monitorPanel,'Style','text','String',maxResx,'Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.01 0.02 0.12 0.22]);
        monitorMaxResolutionLabely = uicontrol(monitorPanel,'Style','text','String',maxResy,'Visible','on','Units','normalized','Visible','on','FontWeight','bold','HorizontalAlignment','center','Position',[0.14 0.02 0.12 0.22]);

        monitorAvailableResolutionsLabel = uicontrol(monitorPanel,'Style','text','String','Avail. Res.','Units','normalized','Visible','on','Position',[0.55 0.75 0.25 0.23],'BackgroundColor','w');
        monitorAvailableResolutionsField = uicontrol(monitorPanel,'Style','popupmenu','String',currAllowedResStrings,'Units','normalized','Visible','on','Value',1,'Position',[0.55 0.52 0.25 0.23],'BackgroundColor','w');
    end % end calculateMonitorDetails function

%% surgeryAxisDetails
% surgeryAxisDetails = uicontrol('Style','radiobutton','String','Surgery/Stereotax','Units','pixels','Position',[0.07*fieldWidth 1.25*oneRowHeight 1.3*fieldWidth oneRowHeight],'Visible','on','parent',detailsSelector);
%     function displaySurgeryAndAxisPanels(source,eventdata)
%         clearAllDetailsPanels
%         set(surgeryPanel,'Visible','on');
%         set(stereotaxSurgPanel,'Visible','on');
%         set(stereotaxPanel,'Visible','on');
%     end
surgeryPanel = uipanel('Parent',stereotaxSurgeryPanel,'Units','normalized','Position',[0.01 0.51 0.98 0.48],'title','Surgery Details','Visible','on');
stereotaxSurgPanel = uipanel('Parent',stereotaxSurgeryPanel,'Units','normalized','Position',[0.01 0.01 0.48 0.48],'title','Surg Stereotax','Visible','on');
stereotaxPanel = uipanel('Parent',stereotaxSurgeryPanel,'Units','normalized','Position',[0.51 0.01 0.48 0.48],'title','Stereotax','Visible','on');

% draw text labels for surgery anchor
APHeader = uicontrol('Parent',surgeryPanel,'Style','text','String','AP','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.26 0.75 0.24 0.24]);
MLHeader = uicontrol('Parent',surgeryPanel,'Style','text','String','ML','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.50 0.75 0.24 0.24]);
ZHeader = uicontrol('Parent',surgeryPanel,'Style','text','String','Z','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.74 0.75 0.24 0.24]);
surgeryAnchorLabel = uicontrol('Parent',surgeryPanel,'Style','text','String','Surgery Anchor','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.02 0.43 0.24 0.28]);
surgeryBregmaLabel = uicontrol('Parent',surgeryPanel,'Style','text','String','Surgery Bregma','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.02 0.15 0.24 0.28]);

% surgery anchor and bregma text fields
surgeryAnchorAPField = uicontrol('Parent',surgeryPanel,'Style','edit','String','nan','Visible','on','Units','normalized','Enable','off','Position',[0.26 0.51 0.24 0.28]);
surgeryAnchorMLField = uicontrol('Parent',surgeryPanel,'Style','edit','String','nan','Visible','on','Units','normalized','Enable','off','Position',[0.50 0.51 0.24 0.28]);
surgeryAnchorZField = uicontrol('Parent',surgeryPanel,'Style','edit','String','nan','Visible','on','Units','normalized','Enable','off','Position',[0.74 0.51 0.24 0.28]);
surgeryBregmaAPField = uicontrol('Parent',surgeryPanel,'Style','edit','String','nan','Visible','on','Units','normalized','Enable','off','Position',[0.26 0.23 0.24 0.28]);
surgeryBregmaMLField = uicontrol('Parent',surgeryPanel,'Style','edit','String','nan','Visible','on','Units','normalized','Enable','off','Position',[0.50 0.23 0.24 0.28]);
surgeryBregmaZField = uicontrol('Parent',surgeryPanel,'Style','edit','String','nan','Visible','on','Units','normalized','Enable','off','Position',[0.74 0.23 0.24 0.28]);

% checkbox to enable surgery field input
enableSurgeryFields = uicontrol('Parent',surgeryPanel,'Style','checkbox','String','unlock','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.75 0.01 0.24 0.13],'CallBack',@enableSurgeryEntry);
    function enableSurgeryEntry(source,eventdata)
        if get(enableSurgeryFields,'Value')==1
            set(surgeryAnchorAPField,'Enable','on');
            set(surgeryAnchorMLField,'Enable','on');
            set(surgeryAnchorZField,'Enable','on');
            set(surgeryBregmaAPField,'Enable','on');
            set(surgeryBregmaMLField,'Enable','on');
            set(surgeryBregmaZField,'Enable','on');
        else
            set(surgeryAnchorAPField,'Enable','off');
            set(surgeryAnchorMLField,'Enable','off');
            set(surgeryAnchorZField,'Enable','off');
            set(surgeryBregmaAPField,'Enable','off');
            set(surgeryBregmaMLField,'Enable','off');
            set(surgeryBregmaZField,'Enable','off');
        end
    end % end enableSurgeryEntry function

% orientation of axes
APOrientationMenu = uicontrol(stereotaxPanel,'Style','radiobutton','String','AP','Enable','on','Visible','on','BackgroundColor','default','Value',0,'Units','normalized','Position',[0.63 0.83 0.3 0.15],'CallBack',@flipAxisOrientation); % 0 means down, 1 means up
MLOrientationMenu = uicontrol(stereotaxPanel,'Style','radiobutton','String','ML','Enable','on','Visible','on','BackgroundColor','default','Value',0,'Units','normalized','Position',[0.63 0.65 0.3 0.15],'CallBack',@flipAxisOrientation); % 0 means to left 1 means to right
orientationAxis = axes('Parent',stereotaxPanel,'Units','normalized','Position',[0.01 0.01 0.6 0.98],'Color','none','Visible','on','XTick',[],'YTick',[]);
axes(orientationAxis);
imHan = imshow(DownLeft);
    function flipAxisOrientation(source,eventdata)
        currOrientation = [get(APOrientationMenu,'Value') get(MLOrientationMenu,'Value')];
        axes(orientationAxis);
        if currOrientation == [0 0]
            imshow(DownLeft);
        elseif currOrientation == [0 1]
            imshow(DownRight);
        elseif currOrientation == [1 0]
            imshow(UpLeft);
        elseif currOrientation == [1 1]
            imshow(UpRight);
        end
    end

% stereotax information for surgery
surgeryAPOrientationMenu = uicontrol(stereotaxSurgPanel,'Style','radiobutton','String','AP','Enable','on','Visible','on','BackgroundColor','default','Value',0,'Units','normalized','Position',[0.63 0.83 0.3 0.15],'CallBack',@surgeryAxisOrientation); % 0 means down, 1 means up
surgeryMLOrientationMenu = uicontrol(stereotaxSurgPanel,'Style','radiobutton','String','ML','Enable','on','Visible','on','BackgroundColor','default','Value',0,'Units','normalized','Position',[0.63 0.65 0.3 0.15],'CallBack',@surgeryAxisOrientation); % 0 means to left 1 means to right
surgOrientationAxis = axes('Parent',stereotaxSurgPanel,'Units','normalized','Position',[0.01 0.01 0.45 0.98],'Color','none','Visible','on','XTick',[],'YTick',[]);
surgeryDescriptionTextAxis = axes('Parent',stereotaxSurgPanel,'Position',[0.46 0.05,0.52 0.5],'color','none','XTick',[],'YTick',[],'Box','on');
text(0.5,0.5,{'change orientation','of axes','only for surgery'},'FontSize',8,'VerticalAlignment','middle','HorizontalAlignment','center');
axes(surgOrientationAxis);
imHan = imshow(DownLeft);
% set(imHan,'AlphaDataMapping','scaled','AlphaData',DownLeft);
    function surgeryAxisOrientation(source,eventdata)
        currOrientation = [get(surgeryAPOrientationMenu,'Value') get(surgeryMLOrientationMenu,'Value')];
        axes(surgOrientationAxis);
        if currOrientation == [0 0]
            imshow(DownLeft);
        elseif currOrientation == [0 1]
            imshow(DownRight);
        elseif currOrientation == [1 0]
            imshow(UpLeft);
        elseif currOrientation == [1 1]
            imshow(UpRight);
        end
    end

%% subjTrodeDetails
% subjTrodeDetails = uicontrol('Style','radiobutton','String','Subj/Trode/Ptcl','Units','pixels','Position',[0.07*fieldWidth 2.25*oneRowHeight 1.3*fieldWidth oneRowHeight],'Visible','on','parent',detailsSelector);
%     function displaySubjectTrodePanels(source,eventdata)
%         clearAllDetailsPanels
%         set(subjectPanel,'Visible','on');
%         set(electrodePanel,'Visible','on');
%         set(protocolPanel,'Visible','on');
%     end
subjectPanel = uipanel('Parent',subjectElectrodeProtocolPanel,'Units','normalized','Position',[0.01 0.6 0.98 0.39],'title','Subject Details','Visible','on');
electrodePanel = uipanel('Parent',subjectElectrodeProtocolPanel,'Units','normalized','Position',[0.01 0.20 0.49 0.39],'title','Electrode Details','Visible','on');
protocolPanel = uipanel('Parent',subjectElectrodeProtocolPanel,'Units','normalized','Position',[0.51 0.20 0.48 0.39],'title','Protocol Details','Visible','on');
otherRecordingDetailsPanel = uipanel('Parent',subjectElectrodeProtocolPanel,'Units','normalized','Position',[0.01 0.01 0.98 0.18],'title','Digital Channel Details','Visible','on');

% Subject Panel
speciesIDLabel = uicontrol(subjectPanel,'Style','text','String','Species','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.76 0.2 0.2]);
strainIDLabel = uicontrol(subjectPanel,'Style','text','String','Strain','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.51 0.2 0.2]);
sexIDLabel = uicontrol(subjectPanel,'Style','text','String','Sex','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.26 0.2 0.2]);
geneBkgdLabel = uicontrol(subjectPanel,'Style','text','String','Genetic Bkgd.','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.01 0.2 0.2]);

subjSpeciesField = uicontrol(subjectPanel,'Style','popupmenu','String',subjSpeciesStrs,'Visible','on','Units','normalized','Value',defaultSpeciesIndex,'Enable','on','Position',[0.2 0.76 0.24 0.24]);
subjStrainField = uicontrol(subjectPanel,'Style','popupmenu','String',subjStrainStrs,'Visible','on','Units','normalized','Value',defaultStrainIndex,'Enable','on','Position',[0.2 0.51 0.24 0.24]);
subjSexField = uicontrol(subjectPanel,'Style','popupmenu','String',subjSexStrs,'Visible','on','Units','normalized','Value',defaultSexIndex,'Enable','on','Position',[0.2 0.26 0.24 0.24]);
subjGeneBkgdField = uicontrol(subjectPanel,'Style','popupmenu','String',geneBkgdStrs,'Visible','on','Units','normalized','Value',defaultGeneBkgdIndex,'Enable','on','Position',[0.2 0.01 0.24 0.24]);

viralModLabel = uicontrol(subjectPanel,'Style','text','String','Viral Mod.','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.51 0.76 0.2 0.2]);
subjIDLabel = uicontrol(subjectPanel,'Style','text','String','Subject ID','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.51 0.51 0.2 0.2]);

geneticModificationField = uicontrol(subjectPanel,'Style','popupmenu','String',viralModStrs,'Visible','on','Units','normalized','Value',defaultViralModIndex,'Enable','on','Position',[0.71 0.76 0.24 0.24]);
subjIDField = uicontrol(subjectPanel,'Style','popupmenu','String',subjIDStrs,'Visible','on','Units','normalized','Value',defaultSubjIndex,'Enable','on','Position',[0.71 0.51 0.24 0.24],'Callback',@reloadEventsAndSurgeryFields);
    function reloadEventsAndSurgeryFields(source,eventdata,reloadHistory)
        if ~exist('reloadHistory','var')
            reloadHistory=true;
        end
        % reload physiology event log
        savePath=fullfile(EVENTSFOLDER,subjIDStrs{get(subjIDField,'Value')});
        if reloadHistory
            d=dir(savePath);
            historyDates={};
            historyDateIndex=[];
            for dd=1:length(d)
                match=regexp(d(dd).name,'\d{2}\.\d{2}\.\d{4}','match');
                if ~isempty(match)
                    historyDates{end+1}=d(dd).name;
                end
            end
            historyDateIndex=find(strcmp(datestr(now,'mm.dd.yyyy'),historyDates));
            if isempty(historyDateIndex)
                historyDates{end+1}=datestr(now,'mm.dd.yyyy');
                historyDateIndex=length(historyDates);
            end
            set(dateField,'String',historyDates{historyDateIndex});
        end
        savePath=fullfile(savePath,get(dateField,'String'));
        d=dir(fullfile(savePath,'*.mat')); % look for existing files
        % should only have one element in d
        if length(d)==1
            events_data=load(fullfile(savePath,d(1).name));
            if isfield(events_data,'labels')
                labels=events_data.labels;
            else
                labels=nan*ones(1,length(events_data.events_data));
            end
            events_data=events_data.events_data;
            cellStartInds=find(strcmp({events_data.eventType},'cell start'));
            cellStopInds=find(strcmp({events_data.eventType},'cell stop'));
            if length(cellStopInds)==length(cellStartInds)
                cellT='start cell';
                cellActive=false;
            else
                cellT='stop cell';
                cellActive=true;
            end
        else
            events_data=[];
        end
        eventNum=length(events_data)+1;
        eventsToSendIndex=eventNum;
        updateDisplay();

        [rigState ampState surgBregma surgAnchor currAnchor currPositn penetParams monitorDetails subjectDetails isNewDay] = ...
            getDataFromEventLog(fullfile(EVENTSFOLDER,subjIDStrs{get(subjIDField,'Value')},''),[],subjIDStrs{get(subjIDField,'Value')});
            % look for anchor data in the events_log
            set(surgeryAnchorAPField,'String',num2str(surgAnchor(1)));
            set(surgeryAnchorMLField,'String',num2str(surgAnchor(2)));
            set(surgeryAnchorZField,'String',num2str(surgAnchor(3)));
            set(surgeryBregmaAPField,'String',num2str(surgBregma(1)));
            set(surgeryBregmaMLField,'String',num2str(surgBregma(2)));
            set(surgeryBregmaZField,'String',num2str(surgBregma(3)));
        if isNewDay
            set(enableCurrentAnchorField,'Value',1);enableCurrentAnchorEntry();
            set(currentAnchorAPField,'String',num2str(currAnchor(1)),'BackgroundColor','r');
            set(currentAnchorMLField,'String',num2str(currAnchor(2)),'BackgroundColor','r');
            set(currentAnchorZField,'String',num2str(currAnchor(3)),'BackgroundColor','r');
            set(enableRigStateFields,'Value',1);enableRigStateEntry();
            set(rigDistField,'String',num2str(rigState(1)),'BackgroundColor','r');
            set(rigHeightField,'String',num2str(rigState(2)),'BackgroundColor','r');
            set(rigAngleField,'String',num2str(rigState(3)),'BackgroundColor','r');
            set(enableAmpStateFields,'Value',1);enableAmpStateEntry();
            set(ampGainField, 'Value',find(strcmp(ampState{1},ampGainStrs)),'BackgroundColor','r');
            set(ampLPField, 'Value',find(strcmp(ampState{2},ampLPStrs)),'BackgroundColor','r');
            set(ampHPField, 'Value',find(strcmp(ampState{3},ampHPStrs)),'BackgroundColor','r');
            set(ampNotchField, 'Value',find(strcmp(ampState{4},ampNotchStrs)),'BackgroundColor','r');
            set(ampModeField, 'Value',find(strcmp(ampState{5},ampModeStrs)),'BackgroundColor','r');
            set(ampCapCompField, 'Value',ampState{6},'BackgroundColor','r');
            set(monitorStateField,'Value',find(strcmp(monitorStrs,monitorDetails{1})),'BackgroundColor','r');
            set(subjSpeciesField,'Value',find(strcmp(subjSpeciesStrs,subjectDetails{2})),'BackgroundColor','r');
            set(subjStrainField,'Value',find(strcmp(subjStrainStrs,subjectDetails{3})),'BackgroundColor','r');
            set(subjSexField,'Value',find(strcmp(subjSexStrs,subjectDetails{4})),'BackgroundColor','r');
            set(subjGeneBkgdField,'Value',find(strcmp(geneBkgdStrs,subjectDetails{5})),'BackgroundColor','r');
            set(geneticModificationField,'Value',find(strcmp(viralModStrs,subjectDetails{6})),'BackgroundColor','r');
        else
            set(currentAnchorAPField,'String',num2str(currAnchor(1)),'BackgroundColor','w');
            set(currentAnchorMLField,'String',num2str(currAnchor(2)),'BackgroundColor','w');
            set(currentAnchorZField,'String',num2str(currAnchor(3)),'BackgroundColor','w');
            set(rigDistField,'String',num2str(rigState(1)),'BackgroundColor','w');
            set(rigHeightField,'String',num2str(rigState(2)),'BackgroundColor','w');
            set(rigAngleField,'String',num2str(rigState(3)),'BackgroundColor','w');
            set(ampGainField, 'Value',find(strcmp(ampState{1},ampGainStrs)),'BackgroundColor','w');
            set(ampLPField, 'Value',find(strcmp(ampState{2},ampLPStrs)),'BackgroundColor','w');
            set(ampHPField, 'Value',find(strcmp(ampState{3},ampHPStrs)),'BackgroundColor','w');
            set(ampNotchField, 'Value',find(strcmp(ampState{4},ampNotchStrs)),'BackgroundColor','w');
            set(ampModeField, 'Value',find(strcmp(ampState{5},ampModeStrs)),'BackgroundColor','w');
            set(ampCapCompField, 'Value',ampState{6},'BackgroundColor','w');
            set(monitorStateField,'Value',find(strcmp(monitorStrs,monitorDetails{1})),'BackgroundColor','w');
            set(subjIDField,'Value',find(strcmp(subjIDStrs,subjectDetails{1})),'BackgroundColor','w');
            set(subjSpeciesField,'Value',find(strcmp(subjSpeciesStrs,subjectDetails{2})),'BackgroundColor','w');
            set(subjStrainField,'Value',find(strcmp(subjStrainStrs,subjectDetails{3})),'BackgroundColor','w');
            set(subjSexField,'Value',find(strcmp(subjSexStrs,subjectDetails{4})),'BackgroundColor','w');
            set(subjGeneBkgdField,'Value',find(strcmp(geneBkgdStrs,subjectDetails{5})),'BackgroundColor','w');
            set(geneticModificationField,'Value',find(strcmp(viralModStrs,subjectDetails{6})),'BackgroundColor','w');
        end
        set(offsetAPField,'String',num2str(currPositn(1)));
        set(offsetMLField,'String',num2str(currPositn(2)));
        set(offsetZField,'String',num2str(currPositn(3)));
        if ~isempty(penetParams)
            if ~isempty(penetParams.experimenter)
                set(experimenterField,'Value',find(strcmp(penetParams.experimenter,experimenterStrs)),'BackgroundColor','w');
            else
                set(experimenterField,'String',experimenterStrs,'Value',defaultIndex,'BackgroundColor','r');
            end
            
            if ~isempty(penetParams.electrodeMake)
                set(electrodeMakeField,'Value',find(strcmp(penetParams.electrodeMake,electrodeMakeStrs)),'BackgroundColor','w');
            else
                set(electrodeMakeField,'String',electrodeMakeStrs,'Value',defaultIndex,'BackgroundColor','r');
            end
            
            if ~isempty(penetParams.electrodeModel)
                set(electrodeModelField,'Value',find(strcmp(penetParams.electrodeModel,electrodeModelStrs)),'BackgroundColor','w');
            else
                set(electrodeModelField,'String',electrodeModelStrs,'Value',defaultIndex,'BackgroundColor','r');
            end
            
            if ~isempty(penetParams.lotNum)
                set(lotNumField,'Value',find(strcmp(penetParams.lotNum,lotNumStrs)),'BackgroundColor','w');
            else
                set(lotNumField,'String',lotNumStrs,'Value',defaultIndex,'BackgroundColor','r');
            end
            
            if ~isempty(penetParams.IDNum)
                set(IDNumField,'Value',find(strcmp(penetParams.IDNum,IDNumStrs)),'BackgroundColor','w');
            else
                set(IDNumField,'String',IDNumStrs,'Value',defaultIndex,'BackgroundColor','r');
            end
        end
    end

% Trode panel
electrodeMakeLabel = uicontrol(electrodePanel,'Style','text','String','Make','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.76 0.25 0.2]);
electrodeModelLabel = uicontrol(electrodePanel,'Style','text','String','Model','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.51 0.25 0.2]);
lotNumLabel = uicontrol(electrodePanel,'Style','text','String','Lot #','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.26 0.25 0.2]);
IDNumLabel = uicontrol(electrodePanel,'Style','text','String','ID #','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.01 0.25 0.2]);

electrodeMakeField = uicontrol(electrodePanel,'Style','popupmenu','String',electrodeMakeStrs,'Visible','on','Units','normalized','Value',defaultTrodeMakeIndex,'Enable','on','Position',[0.25 0.76 0.48 0.24],'Callback',@EnableOrDiableRecordingMode);
electrodeModelField = uicontrol(electrodePanel,'Style','popupmenu','String',electrodeModelStrs,'Visible','on','Units','normalized','Value',defaultTrodeModelIndex,'Enable','on','Position',[0.25 0.51 0.48 0.24]);
lotNumField = uicontrol(electrodePanel,'Style','popupmenu','String',lotNumStrs,'Visible','on','Units','normalized','Value',defaultLotIndex,'Enable','on','Position',[0.25 0.26 0.48 0.24]);
IDNumField = uicontrol(electrodePanel,'Style','popupmenu','String',IDNumStrs,'Visible','on','Units','normalized','Value',defaultIDIndex,'Enable','on','Position',[0.25 0.01 0.48 0.24]);

recordingModePanel = uibuttongroup('Parent',electrodePanel,'Units','normalized','Position',[0.74 0.01 0.25 0.98],'title','Mode','Visible','on','SelectionChangeFcn',@changeAIParams);
recordingModeChoice1 = uicontrol('Parent',recordingModePanel,'style','radiobutton','String','0','Units','normalized','Position',[0.01 0.01 0.98 0.23],'Enable','off');
recordingModeChoice2 = uicontrol('Parent',recordingModePanel,'style','radiobutton','String','1','Units','normalized','Position',[0.01 0.26 0.98 0.23],'Enable','off');
recordingModeChoice3 = uicontrol('Parent',recordingModePanel,'style','radiobutton','String','16','Units','normalized','Position',[0.01 0.51 0.98 0.23],'Enable','off');
recordingModeChoice4 = uicontrol('Parent',recordingModePanel,'style','radiobutton','String','32','Units','normalized','Position',[0.01 0.76 0.98 0.23],'Enable','off');
set(recordingModePanel,'SelectedObject',recordingModeChoice1);
    function changeAIParams(source,eventdata)
        recordFrom(str2num(get(eventdata.NewValue,'string')));
    end
    function recordFrom(numChannels)
        fprintf('recording from %d channels now\n',numChannels);
        ai_parameters.numChans=numChannels;  % 3 or 16 or 2 or 32
    end

    function EnableOrDiableRecordingMode(source,eventdata)
        switch electrodeMakeStrs{get(electrodeMakeField,'Value')}
            case 'Neuronexus'
                set(recordingModeChoice1,'Enable','on');
                %set(recordingModeChoice2,'Enable','on');
                %set(recordingModeChoice3,'Enable','on');
                set(recordingModeChoice4,'Enable','on');
                set(recordingModePanel,'SelectedObject',recordingModeChoice1);
            otherwise
                set(recordingModeChoice1,'Enable','off');
                %set(recordingModeChoice2,'Enable','off');
                %set(recordingModeChoice3,'Enable','off');
                set(recordingModeChoice4,'Enable','off');
                recordFrom(2);
        end
    end
% Protocol Panel
protocolLabel = uicontrol(protocolPanel,'Style','text','String','Protocol','Visible','on','Units','normalized','FontWeight','bold','HorizontalAlignment','center','Position',[0.0 0.76 0.4 0.2]);
protocolField = uicontrol(protocolPanel,'Style','popupmenu','String',protocolStrs,'Visible','on','Units','normalized','Value',defaultIndex,'Enable','on','Position',[0.4 0.76 0.48 0.24],'CallBack',@populateTrainingStepNames);



stepInProtocolField = uicontrol(protocolPanel,'Style','listbox','Visible','on','Units','normalized','Value',defaultIndex,'Enable','on','Position',[0.01 0.01 0.98 0.74]);
    function populateTrainingStepNames(source,eventdata)
        % will make a temporary ratrix
        rxTemp = getOrMakeDefaultRatrix(true,false);
        
        % createSubject
        subj = subject;
        rxTemp = addSubject(rxTemp,subj,'bas');
        
        % get Protocol name
        ptclName = protocolStrs{get(protocolField,'Value')}; 
        subjIDs = {''};
        ptclFunc = str2func(ptclName);
        rxTemp = ptclFunc(rxTemp,subjIDs);
        tsNames = getTrainingStepNamesForSubject(rxTemp,'');
        set(stepInProtocolField,'String',tsNames);
    end

% otherRecordingDetailsPanel
frameBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','Frames','Enable','on','Visible','on','Value',1,'Units','normalized','Position',[0.01 0.67 0.23 0.32]);
indexBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','Index','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.01 0.34 0.23 0.32]);
stimBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','Stim','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.01 0.01 0.23 0.32]);

portLBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','Left','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.25 0.67 0.23 0.32]);
portCBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','Center','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.25 0.34 0.23 0.32]);
portRBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','Right','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.25 0.01 0.23 0.32]);
rewLBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','RewL ','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.49 0.67 0.23 0.32]);
rewCBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','RewC','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.49 0.34 0.23 0.32]);
rewRBox = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','RewR','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.49 0.01 0.23 0.32]);

LED1Box = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','LED1','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.73 0.51 0.23 0.48]);
LED2Box = uicontrol(otherRecordingDetailsPanel,'Style','checkbox','String','LED2','Enable','on','Visible','on','Value',0,'Units','normalized','Position',[0.73 0.01 0.23 0.48]);

%%

% ========================================================================================
% offset event label, fields, and "submit" button
offsetEventLabel = uicontrol(f,'Style','text','String','Offset','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','Position',[margin+0*fieldWidth fHeight-15*oneRowHeight-2*margin fieldWidth oneRowHeight]);
offsetAPField = uicontrol(f,'Style','edit','Units','pixels','String','nan','Enable','on','Position',[1*margin+1*fieldWidth fHeight-15*oneRowHeight-2*margin 0.75*fieldWidth oneRowHeight]);
offsetMLField = uicontrol(f,'Style','edit','Units','pixels','String','nan','Enable','on','Position',[1*margin+1.75*fieldWidth fHeight-15*oneRowHeight-2*margin 0.75*fieldWidth oneRowHeight]);
offsetZField = uicontrol(f,'Style','edit','Units','pixels','String','nan','Enable','on','Position',[1*margin+2.5*fieldWidth fHeight-15*oneRowHeight-2*margin 0.75*fieldWidth oneRowHeight]);
currentComment = uicontrol(f,'Style','edit','Units','pixels','String','','Enable','on','Position',[1*margin+3.25*fieldWidth fHeight-15*oneRowHeight-2*margin fieldWidth*4.75 oneRowHeight]);

offsetEventSubmit = uicontrol(f,'Style','pushbutton','String','enter','Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','CallBack',@logEvent,'Position',[2*margin+8*fieldWidth fHeight-15*oneRowHeight-2*margin fieldWidth oneRowHeight]);
    function logEvent(source,eventdata)
        if isfield(events_data,'position')
            lastEventWithCoords=find(cellfun(@isempty,{events_data.position})==0,1,'last');
        else
            lastEventWithCoords=[];
        end
        
        % make a new entry in events
        events_data(end+1).time=now;
        labels(end+1)=nan;
        events_data(end).eventNumber=eventNum;
        events_data(end).rigState=[str2double(get(rigDistField,'String')) str2double(get(rigHeightField,'String')) str2double(get(rigAngleField,'String'))];
        events_data(end).ampState = {ampGainStrs{get(ampGainField,'Value')},ampLPStrs{get(ampLPField,'Value')},ampHPStrs{get(ampHPField,'Value')},...
            ampNotchStrs{get(ampNotchField,'Value')},ampModeStrs{get(ampModeField,'Value')},str2double(get(ampCapCompField,'String'))};
        events_data(end).surgeryAnchor=[str2double(get(surgeryAnchorAPField,'String')) str2double(get(surgeryAnchorMLField,'String')) str2double(get(surgeryAnchorZField,'String'))];
        events_data(end).surgeryBregma=[str2double(get(surgeryBregmaAPField,'String')) str2double(get(surgeryBregmaMLField,'String')) str2double(get(surgeryBregmaZField,'String'))];
        events_data(end).currentAnchor=[str2double(get(currentAnchorAPField,'String')) str2double(get(currentAnchorMLField,'String')) str2double(get(currentAnchorZField,'String'))];
        events_data(end).position=[str2double(get(offsetAPField,'String')) str2double(get(offsetMLField,'String')) str2double(get(offsetZField,'String'))];
        events_data(end).APOrientation = get(APOrientationMenu,'Value');
        events_data(end).MLOrientation = get(MLOrientationMenu,'Value');
        events_data(end).surgAPOrientation = get(surgeryAPOrientationMenu,'Value');
        events_data(end).surgMLOrientation = get(surgeryMLOrientationMenu,'Value');
        events_data(end).eventType=eventTypeStrs{get(eventTypeMenu,'Value')};
        whichMon = get(monitorStateField,'value');
        currAllowedResStrings = monitorAllowedResStrings{whichMon};
        events_data(end).monitorDetails={monitorStrs{whichMon}};
%         [monitorMaxRes{whichMon}(1) monitorMaxRes{whichMon}(2)],...
%             [str2double(get(monitorWidthField,'String')),str2double(get(monitorHeightField,'String')),str2double(get(monitorWidthAngField,'String')),str2double(get(monitorHeightAngField,'String'))],...
%             currAllowedResStrings{get(monitorAvailableResolutionsField,'Value')}
        whichSubj = get(subjIDField,'Value');
        whichSpecies = get(subjSpeciesField,'Value');
        whichStrain = get(subjStrainField,'Value');
        whichSex = get(subjSexField,'Value');
        whichGeneBkgd = get(subjGeneBkgdField,'Value');
        whichModification = get(geneticModificationField,'Value');
        events_data(end).subjectDetails = {subjIDStrs{whichSubj},...
            subjSpeciesStrs{whichSpecies},...
            subjStrainStrs{whichStrain},...
            subjSexStrs{whichSex},...
            geneBkgdStrs{whichGeneBkgd},...
            viralModStrs{whichModification}};
        eventParams=[];
        switch events_data(end).eventType
            case 'visual hash'
                eventParams.hashStrength=visualHashStrs{get(visualHashMenu,'Value')};
            case {'ctx cell','hipp cell','visual cell'}
                eventParams.SNR=str2double(snrStrs{get(snrMenu,'Value')});
                if strcmp(events_data(end).eventType,'visual cell')
                    eventParams.vcType=vcTypeStrs{get(vcTypeMenu,'Value')};
                    eventParams.vcEye=vcEyeStrs{get(vcEyeMenu,'Value')};
                    eventParams.vcBursty=vcBurstyStrs{get(vcBurstyMenu,'Value')};
                    eventParams.vcRFAzimuth=str2double(vcRFAzimuthStrs{get(vcRFAzimuthMenu,'Value')});
                    eventParams.vcRFElevation=str2double(vcRFElevationStrs{get(vcRFElevationMenu,'Value')});
                end
            case 'subj obs'
                eventParams.arousal=arousalStrs{get(arousalMenu,'Value')};
                eventParams.eyes=eyesStrs{get(eyesMenu,'Value')};
                eventParams.face=faceStrs{get(faceMenu,'Value')};
            case 'anesth check'
                eventParams.isoflurane=isofluraneStrs{get(isofluraneMenu,'Value')};
                eventParams.withdrawal=withdrawalStrs{get(withdrawalMenu,'Value')};
                eventParams.breathPerMin=breathPerMinStrs{get(breathPerMinMenu,'Value')};
                eventParams.breathType=breathTypeStrs{get(breathTypeMenu,'Value')};
            case 'muscimol'
                eventParams.concentration = muscimolConcStrsGPL{get(muscimolConcMenu,'Value')};
                eventParams.volume = muscimolVolStrsUL{get(muscimolVolMenu,'Value')};
            case 'lidocaine'
                eventParams.concentration = lidocaineConcStrsGPL{get(lidocaineConcMenu,'Value')};
                eventParams.volume = lidocaineVolStrsUL{get(lidocaineVolMenu,'Value')};
            case 'singleUnit'
                eventParams.startTrial = num2str(get(singleUnitStartTrialMenu,'String'));
                eventParams.stopTrial = num2str(get(singleUnitStopTrialMenu,'String'));
                eventParams.thrV = num2str(get(singleUnitThrVMenu,'String'));
            otherwise
                % nothing
        end
        events_data(end).eventParams=eventParams;
        events_data(end).comment=get(currentComment,'String');
        
        % We want to have a visual way to identify situations where certain
        % things change like:
        %
        % rigState or ampState changes
%         if length(events_data)~=1 % if it is not the first event for the day
%             if ~all(events_data(end-1).rigState==events_data(end).rigState);
%                 events_data(end).comment = sprintf('%s%s','\bf{rigState Changed.}',events_data(end).comment);
%             end
%             if ~all(strcmp(events_data(end-1).ampState(1:5),events_data(end).ampState(1:5)));
%                 events_data(end).comment = sprintf('%s%s','\bf{ampState Changed.}',events_data(end).comment);
%             end
%         end
        
        % update pNum if necessary (if AP or ML differ from last)
        if ~isempty(lastEventWithCoords)
            if (length(events_data)>=2 && any(events_data(lastEventWithCoords).position(1:2)~=events_data(end).position(1:2)) && all(~isnan(events_data(end).position(1:2))) ) ...
                    || length(events_data)==1
                % record events_data.penetrationParams here (subjID, experimenters,
                %   electrode make, model, lot#, ID#, impedance, reference mark xyz, target xy)
                
                params=[];
                params.subjID=subjIDStrs{get(subjIDField,'Value')};
                params.experimenter=experimenterStrs{get(experimenterField,'Value')};
                params.electrodeMake=electrodeMakeStrs{get(electrodeMakeField,'Value')};
                params.electrodeModel=electrodeModelStrs{get(electrodeModelField,'Value')};
                params.lotNum=lotNumStrs{get(lotNumField,'Value')};
                params.IDNum=IDNumStrs{get(IDNumField,'Value')};
                events_data(end).penetrationParams=params;
                
                if length(events_data)==1
                    events_data(end).penetrationNum=1;
                else
                    events_data(end).penetrationNum=events_data(lastEventWithCoords).penetrationNum+1;
                end
            else
                events_data(end).penetrationNum=events_data(lastEventWithCoords).penetrationNum;
                events_data(end).penetrationParams=[];
            end
        else
            events_data(end).penetrationNum=1;
            events_data(end).penetrationParams=[];
        end
        
        % save event log
        deleteFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum-1);
        saveFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum);
        if ~isdir(savePath)
            mkdir(savePath);
        end
        
        save(fullfile(savePath,saveFilename),'events_data','labels');
        if eventNum~=1
            delete(fullfile(savePath,deleteFilename));
        end
        
        eventNum=eventNum+1;
        updateDisplay();
        % flush the comments buffer
        set(currentComment,'String','');
        % reset eventType to comment
        set(eventTypeMenu,'Value',defaultIndex);
        eventTypeC([],[]);
        
        % reset all colors to normal
        set(rigDistField,'BackgroundColor','w');
        set(rigHeightField,'BackgroundColor','w');
        set(rigAngleField,'BackgroundColor','w');
        
        set(protocolField,'BackgroundColor','w');
        set(experimenterField,'BackgroundColor','w');
        set(electrodeMakeField,'BackgroundColor','w');
        set(electrodeModelField,'BackgroundColor','w');
        set(lotNumField,'BackgroundColor','w');
        set(IDNumField,'BackgroundColor','w');
               
        set(currentAnchorAPField,'BackgroundColor','w');
        set(currentAnchorMLField,'BackgroundColor','w');
        set(currentAnchorZField,'BackgroundColor','w');
        set(enableCurrentAnchorField,'Value',0);enableCurrentAnchorEntry();
        
        set(ampGainField,'BackgroundColor','w');
        set(ampLPField,'BackgroundColor','w');
        set(ampHPField,'BackgroundColor','w');
        set(ampNotchField,'BackgroundColor','w');
        set(ampModeField,'BackgroundColor','w');
        set(ampCapCompField,'BackgroundColor','w');
        set(enableAmpStateFields,'Value',0);enableAmpStateEntry();
        
        set(monitorStateField,'BackgroundColor','w');
        set(subjSpeciesField,'BackgroundColor','w');
        set(subjStrainField,'BackgroundColor','w');
        set(subjSexField,'BackgroundColor','w');
        set(subjGeneBkgdField,'BackgroundColor','w');
        set(geneticModificationField,'BackgroundColor','w');
        
    end % end logEvent function

% ========================================================================================
% quick plot - improved
levelToTOF = uicontrol(f,'Style','checkbox','String','level to TOF','Enable','on','Visible','on','Value',0,'Units','pixels','Position',[2*margin+8*fieldWidth fHeight-24.5*oneRowHeight-margin fieldWidth+margin*3 oneRowHeight]);

quickPlotButton = uicontrol(f,'Style','pushbutton','String','quick plot','Visible','on','Units','pixels','FontWeight','normal','HorizontalAlignment','center','CallBack',@quickPlot,'Position',[2*margin+8*fieldWidth fHeight-23*oneRowHeight-2*margin fieldWidth oneRowHeight]);
    function quickPlot(source,eventdata)
        
        %p=vertcat(events_data.position);
        %plot3(p(:,1),p(:,2),p(:,3),'k.')
        
        % there are some empty eventType records. i am working around them
        if ~isempty(cellfun(@isempty,{events_data.eventType}))
            warning('empty evetTypes in event_data. will remove same for quickPlot');
        end
        events_dataNoEmpty = events_data(find(~cellfun(@isempty,{events_data.eventType})));
        
%         REMOVE COMMENTS AFTER DE-BUGGING EMPTY EVENT_DATA TYPES
%         ALL=true(1,length(events_data));
%         TOB=ismember({events_data.eventType},{'top of brain'});
%         VIS=ismember({events_data.eventType},{'visual cell','visual hash'});
%         CELL=ismember({events_data.eventType},{'ctx cell','hipp cell','visual cell'});
%         BEND=ismember({events_data.eventType},{'electrode bend'});
%         %get the last defined position in the list 
%         CURRENT= false(1,length(events_data))  % this is the start of the logicals
%         candidates=find( ~cellfun('isempty',{events_data.position})  )
%         % next:  find the cands that are not nan ... problem:  all apear to
%         % be nan?  not true
%         CURRENT(max())=true;
%         % cellfun(@(x) any(isnan(x)),{events_data.position}) &  % that is
%         % not a nan .. prob is need to add back in
%         
%         g=figure;
%         levelToTopOfBrain=false;
%         plotInBregmaCoordinates(events_data,ALL,'.k',[1 1 1 1],levelToTopOfBrain);
%         hold on;
%         plotInBregmaCoordinates(events_data,TOB,'ok',[],levelToTopOfBrain);
%         plotInBregmaCoordinates(events_data,VIS,'c.',[],levelToTopOfBrain);
%         plotInBregmaCoordinates(events_data,CELL,'b*',[],levelToTopOfBrain);
%         plotInBregmaCoordinates(events_data,CELL & VIS,'r*',[],levelToTopOfBrain);
%         plotInBregmaCoordinates(events_data,BEND,'xr',[],levelToTopOfBrain);
%         plotInBregmaCoordinates(events_data,CURRENT,'og',[],levelToTopOfBrain);
%         
%         xlabel('posterior');
%         ylabel('lateral');
%         zlabel('depth');
%         grid on;
%         set(gca,'View',[240 60])
%         set(gca,'YDir','reverse');  %why?  thats just the way it is in plot3

        ALL=true(1,length(events_dataNoEmpty));
        TOB=ismember({events_dataNoEmpty.eventType},{'top of brain'});
        VIS=ismember({events_dataNoEmpty.eventType},{'visual cell','visual hash'});
        CELL=ismember({events_dataNoEmpty.eventType},{'ctx cell','hipp cell','visual cell'});
        BEND=ismember({events_dataNoEmpty.eventType},{'electrode bend'});
        %get the last defined position in the list
        CURRENT= false(1,length(events_dataNoEmpty));  % this is the start of the logicals
        candidates=find( ~cellfun('isempty',{events_dataNoEmpty.position})  );
        % next:  find the cands that are not nan ... problem:  all apear to
        % be nan?  not true
        %CURRENT(max())=true;
        % cellfun(@(x) any(isnan(x)),{events_data.position}) &  % that is
        % not a nan .. prob is need to add back in
        g=figure('Position',[50 700 800 400]);
        for subPlotID=1:2
            subplot(1,2,subPlotID)
            levelToTopOfBrain=get(levelToTOF,'Value');
            plotInBregmaCoordinates(events_dataNoEmpty,ALL,'.k',[1 0 1 1],levelToTopOfBrain);
            hold on;
            plotInBregmaCoordinates(events_dataNoEmpty,TOB,'ok',[],levelToTopOfBrain);
            plotInBregmaCoordinates(events_dataNoEmpty,VIS,'c.',[],levelToTopOfBrain);
            plotInBregmaCoordinates(events_dataNoEmpty,CELL,'b*',[],levelToTopOfBrain);
            plotInBregmaCoordinates(events_dataNoEmpty,CELL & VIS,'r*',[],levelToTopOfBrain);
            plotInBregmaCoordinates(events_dataNoEmpty,BEND,'xr',[],levelToTopOfBrain);
            %plotInBregmaCoordinates(events_dataNoEmpty,CURRENT,'og',[],levelToTopOfBrain);
            
            xlabel('posterior');
            ylabel('lateral');
            zlabel('depth');
            grid on;
            switch subPlotID 
                case 1
                    set(gca,'View',[-180 0])
                case 2
                   set(gca,'View',[-180 90])
                case 3
                    set(gca,'View',[240 60])
            end
            set(gca,'YDir','reverse');  %why?  thats just the way it is in plot3
            set(gca,'ZLim',[-10 0]);
        end
    end


% ========================================================================================
%% start/stop cell
toggleCellButton = uicontrol(f,'Style','togglebutton','String',cellT,'Visible','on','Units','pixels','FontWeight','bold','HorizontalAlignment','center','CallBack',@toggleCell,'Position',[2*margin+8*fieldWidth fHeight-19*oneRowHeight-2*margin fieldWidth oneRowHeight]);
    function toggleCell(source,eventdata)
        if get(toggleCellButton,'Value')==1            
            externalRequest='cell start';
            % now create the "currentUnit" object and load it with some
            % empty analyses
            subID = subjIDStrs{get(subjIDField,'Value')};
            currentUnit = singleUnit(subID,[]);
            storepath=fullfile(DAQFOLDER,subjIDStrs{get(subjIDField,'Value')});
            if ~isdir(fullfile(storepath,'analysis','singleUnits'))
                mkdir(fullfile(storepath,'analysis','singleUnits'));
            end
            currentUnitName = sprintf('currentUnit%s.mat',datestr(now,30));
            
            save(fullfile(storepath,'analysis','singleUnits',currentUnitName),'currentUnit');
        else
            externalRequest='cell stop';
            % find the latest currentUnit object and make object nonCurrent
            currentUnitsPath = fullfile(DAQFOLDER,subjIDStrs{get(subjIDField,'Value')},'analysis','singleUnits')
            d = dir(currentUnitsPath);
            d = d(~ismember({d.name},{'.','..'}));
            [junk order] = sort([d.datenum]);
            d = d(order);
            temp = load(fullfile(currentUnitsPath,d(end).name));
            currentUnit = temp.currentUnit;
            currentUnit=makeUnitNonCurrent(currentUnit);
            save(fullfile(currentUnitsPath,d(end).name),'currentUnit');
        end
        % get time from client machine (if it exists)
        if ~running
            events_data(end+1).time=now;
            labels(end+1)=nan;
            events_data(end).eventType=externalRequest;
            events_data(end).eventNumber=eventNum;
            % save events
            % save event log
            deleteFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum-1);
            saveFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum);
            if ~isdir(savePath)
                mkdir(savePath);
            end
            save(fullfile(savePath,saveFilename),'events_data','labels');
            if eventNum~=1
                delete(fullfile(savePath,deleteFilename));
            end
            eventNum=eventNum+1;
            externalRequest=[];
        else
            % we just need to pass externalRequest to the run loop
        end
        fprintf('finished getting time from client\n')
        if get(toggleCellButton,'Value') % start the cell
            cellActive=true;
            cellT='stop cell';
        else
            cellActive=false;
            cellT='start cell';
        end
        updateDisplay();
        updateUI();
    end
% ========================================================================================
%% start/stop recording
toggleRecordingButton = uicontrol(f,'Style','togglebutton','String',recordingT,'Visible','on','Units','pixels',...
    'FontWeight','bold','HorizontalAlignment','center','CallBack',@toggleRecording, ...
    'Position',[2*margin+8*fieldWidth fHeight-20*oneRowHeight-2*margin fieldWidth oneRowHeight]);
    function toggleRecording(source,eventdata)
        if get(toggleRecordingButton,'Value') % start recording
            recording=true;
            keepLooping=false;
            if ~running
                q=questdlg('Also start trials?','start recording','Yes','No','Cancel','Yes');
                switch q
                    case {'Yes','No'}
                        if strcmp(q,'Yes')
                            running=true;
                            set(toggleTrialsButton,'Value',1);
                        end
                    case 'Cancel'
                        recording=false;
                        keepLooping=true;
                        set(toggleRecordingButton,'Value',0);
                        return;
                    otherwise
                        error('bad response from question dialog');
                end
            end
            updateUI();
            % if not currently looping, then start the loop
            if ~runningLoop
                run();
            end
        else
            if running
                q=questdlg('Also stop running trials?','stop recording','Yes','No','Cancel','Yes');
                switch q
                    case {'Yes','No'}
                        if strcmp(q,'Yes')
                            running=false;
                            set(toggleTrialsButton,'Value',0);
                        end
                        recording=false;
                        keepLooping=false;
                    case 'Cancel';
                        % do nothing;
                        set(toggleRecordingButton,'Value',1);
                    otherwise
                        error('bad response from question dialog');
                end
            else
                recording=false;
                keepLooping=false;
            end
        end
        updateUI();
    end % end function

% ========================================================================================
%% start/stop trials
toggleTrialsButton = uicontrol(f,'Style','togglebutton','String',runningT,'Visible','on','Units','pixels',...
    'FontWeight','bold','HorizontalAlignment','center','CallBack',@toggleTrials, ...
    'Position',[2*margin+8*fieldWidth fHeight-21*oneRowHeight-2*margin fieldWidth oneRowHeight]);
    function toggleTrials(source,eventdata)
        if get(toggleTrialsButton,'Value') % start running
            running=true;
            keepLooping=false;
            if ~recording
                q=questdlg('Also start recording?','start trials','Yes','No','Cancel','Yes');
                switch q
                    case {'Yes','No'}
                        if strcmp(q,'Yes')
                            recording=true;
                            set(toggleRecordingButton,'Value',1);
                        end
                    case 'Cancel'
                        running=false;
                        keepLooping=true;
                        set(toggleTrialsButton,'Value',0);
                        return
                    otherwise
                        error('bad response from question dialog');
                end
            end
            updateUI();
            if ~runningLoop % if not currently looping, then start the loop
                run();
            end
        else
            if recording
                q=questdlg('Also stop recording?','stop trials','Yes','No','Cancel','Yes');
                switch q
                    case {'Yes','No'}
                        if strcmp(q,'Yes')
                            recording=false;
                            set(toggleRecordingButton,'Value',0);
                        end
                        running=false;
                        keepLooping=false;
                    case 'Cancel';
                        % do nothing;
                        set(toggleTrialsButton,'Value',1);
                    otherwise
                        error('bad response from question dialog');
                end
            else
                running=false;
                keepLooping=false;
            end
        end
        updateUI();
    end % end function

    function run
        runningLoop=true;
        keepLooping=true;
        storepath=fullfile(DAQFOLDER,subjIDStrs{get(subjIDField,'Value')});
        %storepath=fullfile('\\132.239.158.169\datanet_storage',subjIDStrs{get(subjIDField,'Value')});
        % check that neuralRecords,eyeRecord,stimRecords folders exist
        if ~isdir(fullfile(storepath,'neuralRecords'))
            fullfile(storepath,'neuralRecords')
            mkdir(fullfile(storepath,'neuralRecords'));
        end
        if ~isdir(fullfile(storepath,'neuralRecordsRaw'))
            fullfile(storepath,'neuralRecordsRaw')
            mkdir(fullfile(storepath,'neuralRecordsRaw'));
        end
        if ~isdir(fullfile(storepath,'eyeRecords'))
            mkdir(fullfile(storepath,'eyeRecords'));
        end
        if ~isdir(fullfile(storepath,'stimRecords'))
            mkdir(fullfile(storepath,'stimRecords'));
        end
        client_hostname=STIMIP;
        neuralFilename=[];
        stimFilename=[];
        chunkCount=1;
        chunkClock=[];
        startTime=0;
        % ==============================================
        % SET UP TRIALS
        if running
            pnet('closeall')
            data = datanet('data', DATAIP,client_hostname,storepath,ai_parameters); % how do we get client_hostname,storepath, and ai_parameters?
            [dataCmdCon, dataAckCon]= connectToClient(data,client_hostname);
            if isempty(dataCmdCon) || isempty(dataAckCon)
                % this should error, because we pressed 'start trials' and then failed to connect to a client
                error('failed to connect to client');
            else
                data=setCmdCon(data,dataCmdCon);
                data=setAckCon(data,dataAckCon);
                rigParams = struct;
                subjectDetails = struct;
                subjectDetails.species = subjSpeciesStrs{get(subjSpeciesField,'Value')};
                subjectDetails.strain = subjStrainStrs{get(subjStrainField,'Value')};
                subjectDetails.sex = subjSexStrs{get(subjSexField,'Value')};
                subjectDetails.geneticBackground = geneBkgdStrs{get(subjGeneBkgdField,'Value')};
                subjectDetails.geneticModification = viralModStrs{get(geneticModificationField,'Value')};
                subjectDetails.removeDB = get(recreateDBCheckbox,'Value');
                
                protocolDetails.protocolName = protocolStrs{get(protocolField,'Value')};
                protocolDetails.trainingStepNum = get(stepInProtocolField,'Value');
                
                rigParams.distance = str2double(get(rigDistField,'String'));
                rigParams.height = str2double(get(rigHeightField,'String'));
                rigParams.angle = str2double(get(rigAngleField,'String'));
                
                whichMon = get(monitorStateField,'value');
                currAllowedRes = monitorAllowedRes{whichMon};
                chosenResolution = currAllowedRes{get(monitorAvailableResolutionsField,'Value')};
                junk = strfind(chosenResolution,'x');
                rigParams.maxWidth = chosenResolution(1);
                rigParams.maxHeight = chosenResolution(2);
                gotAck=startClientTrials(data,lower(subjIDStrs{get(subjIDField,'Value')}),protocolDetails,get(eyeLinkStartButton,'Value'),rigParams,subjectDetails);
                fprintf('started client trials\n');
                if ~gotAck
                    error('wtf how did we call startClientTrials and then not get an ack back?');
                else
                    gotAck
                end
            end
        end
        % ==============================================
        % SET UP INTAN
        if recording
            % how to set up neuralFilename
            dirStr=fullfile(storepath,'neuralRecordsRaw');
            goodTrials=[];
            d=dir(dirStr);
            for j=1:length(d)
                [matches tokens] = regexpi(d(j).name, 'neuralRecords_(\d+)-(.*)\.rhd', 'match', 'tokens');
                if length(matches) ~= 1
                    %         warning('not a neuralRecord file name');
                else
                    goodTrials(end+1)=str2double(tokens{1}{1});
                end
            end
            lastTrial=max(goodTrials);
            if isempty(lastTrial)
                lastTrial=1;
            end
            neuralFilenameRaw=fullfile(storepath,'neuralRecordsRaw',sprintf('neuralRecords_pretrial%d-%s',lastTrial,datestr(now,30)));
            neuralFilename=fullfile(storepath,'neuralRecords',sprintf('neuralRecords_pretrial%d-%s.mat',lastTrial,datestr(now,30)));
            
            disp('setting up ai_parameters');
            ai_parameters.digitalChans = {};
            if get(frameBox,'Value')
                ai_parameters.digitalChans{end+1} = 'Frames';
            end
            if get(indexBox,'Value')
                ai_parameters.digitalChans{end+1} = 'Index';
            end
            if get(stimBox,'Value')
                ai_parameters.digitalChans{end+1} = 'Stim';
            end
            if get(portLBox,'Value')
                ai_parameters.digitalChans{end+1} = 'Left';
            end
            if get(portCBox,'Value')
                ai_parameters.digitalChans{end+1} = 'Center';
            end
            if get(portRBox,'Value')
                ai_parameters.digitalChans{end+1} = 'Right';
            end
            if get(rewLBox,'Value')
                ai_parameters.digitalChans{end+1} = 'RewL';
            end
            if get(rewCBox,'Value')
                ai_parameters.digitalChans{end+1} = 'RewC';
            end
            if get(rewRBox,'Value')
                ai_parameters.digitalChans{end+1} = 'RewR';
            end
            if get(LED1Box,'Value')
                ai_parameters.digitalChans{end+1} = 'LED1';
            end
            if get(LED2Box,'Value')
                ai_parameters.digitalChans{end+1} = 'LED2';
            end
            
            ai = updateRecordingConfiguration(ai,ai_parameters);    
            
            filename = sprintf('%s_%d.rhd',neuralFilenameRaw,chunkCount);
            fprintf('Opening pretrial file %s for recording...\n',filename);
            ai.SaveFile.open(rhd2000.savefile.Format.intan, filename);
            disp('running session');
            ai.run_continuously();

            numChunks = [];
            if ~running
                samplingRate=ai_parameters.sampRate;
                save(neuralFilename,'samplingRate'); %create the pretrial neuralRecords file!
                save(neuralFilename,'numChunks','-append');
            end
            chunkClock=GetSecs(); % The first chunk will be a little large but only by a little bit
            startTime=chunkClock;
        end
        quit=false;
        while ~quit && keepLooping
            try
%                 allowTimeupChunkAdvancementCheck=true;
                params=[];
                params.ai=ai;
                params.neuralFilename=neuralFilename;
                params.neuralFilenameRaw = neuralFilenameRaw;
                params.datablock = datablock;
                params.stimFilename=stimFilename;
                params.samplingRate=ai_parameters.sampRate;
                params.ai_parameters=ai_parameters;
                params.chunkCount=chunkCount;
                params.startTime=startTime;
                params.recording = recording;
                if recording
                    electrodeDetails.electrodeMake=electrodeMakeStrs{get(electrodeMakeField,'Value')};
                    electrodeDetails.electrodeModel=electrodeModelStrs{get(electrodeModelField,'Value')};
                    electrodeDetails.lotNum=lotNumStrs{get(lotNumField,'Value')};
                    electrodeDetails.IDNum=IDNumStrs{get(IDNumField,'Value')};
                    params.electrodeDetails = electrodeDetails;
                end
                % ==============================================
                % handle all TRIALS stuff
                if running && ~isempty(dataCmdCon) && ~isempty(dataAckCon)
                    [quit, retval, status, requestDone]=doServerIteration(data,params,externalRequest);
                    if requestDone % we have to do this instead of just updating the value of externalRequest, becuase of some weird matlab scope issue
                        externalRequest=[];
                    end
                    if ~isempty(retval) % we have events_data to save
                        % retval should be a struct with fields 'time' and 'type' (and possibly others to add...)
                        for j=1:length(retval)
                            if isfield(retval(j),'errorMethod') && ~isempty(retval(j).errorMethod)
                                % this is not a phys event, but rather a
                                % 'restart' or 'quit' from client
                                
                                % 6/9/09 - should we delete the neuralRecord at
                                % neuralFilename b/c it was error trial?
                                % also corresponding stimRecord/eyeRecord?
                                delete(neuralFilename);
                                delete(stimFilename);
                                % XXX find all the neural filename raws and delete them 
                                quit=true;
                                disp('quitting due to client disconnect');
                                method=retval(j).errorMethod;
                                if ischar(method)
                                    if strcmp(method,'Restart')
                                        % do nothing
                                    elseif strcmp(method, 'Quit')
                                        running=false;
                                        recording=false;
                                        set(toggleTrialsButton,'Value',0);
                                        set(toggleRecordingButton,'Value',0);
                                        if params.recording
                                            ai.stop();
                                            ai.SaveFile.close()
                                        end
                                    else
                                        error('if not restart or quit, then what is the client method?');
                                    end
                                else
                                    error('ERROR_RECOVERY_METHOD must be a string');
                                end
                                updateUI();
                                updateDisplay();
                            else
                                events_data(end+1).time=retval(j).time;
                                labels(end+1)=nan;
                                events_data(end).eventType=retval(j).type;
                                events_data(end).eventNumber=eventNum;
                                
                                switch retval(j).type
                                    case 'trial start'
                                        neuralFilename = retval(j).neuralFilename;
                                        neuralFilenameRaw = retval(j).neuralFilenameRaw;
                                        
                                        % save some basic details in this location
                                        numChunks = [];
                                        if ~running
                                            samplingRate=ai_parameters.sampRate;
                                            save(neuralFilename,'samplingRate'); %create the pretrial neuralRecords file!
                                            save(neuralFilename,'numChunks','-append');
                                        end
                                        
                                        
                                        stimFilename=retval(j).stimFilename;
                                        % reset chunkCount and chunkClock?
                                        chunkCount=1;
                                        chunkClock=GetSecs();
                                        startTime=chunkClock;

                                        events_data(end).eventParams.trialNumber=retval(j).trialNumber;
                                        events_data(end).eventParams.stimManagerClass=retval(j).stimManagerClass;
                                        events_data(end).eventParams.stepName=retval(j).stepName;
                                        events_data(end).eventParams.stepNumber=retval(j).stepNumber;
                                        
                                        % update change in status of ai and datablock
                                        ai = retval(j).ai;
                                        datablock = retval(j).datablock;
                                    case 'trial end'
                                        ai = retval(j).ai;
                                        datablock = retval(j).datablock;
                                        %this will prevent a short empty chunk the length of the save duration from
                                        %overwriting the last chunk. this bug 1st noticed and fixed when we saved longer
                                        %trials with 16 channels. -pmm 5/31/2010
                                end
                                
                                % should save events to phys log here?
                                % save event log
                                deleteFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum-1);
                                saveFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum);
                                if ~isdir(savePath)
                                    mkdir(savePath);
                                end
                                save(fullfile(savePath,saveFilename),'events_data','labels');
                                if eventNum~=1
                                    delete(fullfile(savePath,deleteFilename));
                                end
                                eventNum=eventNum+1;
                            end
                        end
                    end
                    drawnow;
                else
                    pause(0.1);
                    drawnow;
                end
                % ==============================================
                % handle all INTAN stuff
                if recording
                    continueSave = true;
                    FIFOWaringTriggered = false;
                    while continueSave
                        % not going to enable chunking
                        for blockNum = 1:numDataBlocksCollected
                            %                     while ai.FIFOPercentageFull>5 %  make sure the FIFO does not over run!!
                            datablock.read_next(ai);
                            if datablock.HasData
                                datablock.save();
                            end
                        end
                        if ai.FIFOPercentageFull>10 && ~FIFOWaringTriggered
                            fprintf('WARNING: FIFO is %2.2f %% full\n',ai.FIFOPercentageFull)
                            FIFOWaringTriggered = true;
                            numDataBlocksCollected= 100;
                        else
                            FIFOWaringTriggered = false;
                            continueSave = false;
                            numDataBlocksCollected = 30;
                        end
                    end
                end
                updateDisplay();
                pause(0.1);
            catch ex
                ai.stop();
                ai.SaveFile.close();
                ai.flush();
                rethrow(ex)
            end
        end
        % ==============================================
        % after a quit, handle all TRIALS stuff
        if ~isempty(data) && ~quit && status && ~keepLooping %not a client disconnect (so a normal stop by setting keepLooping to false)
            disp('initiating quit');
            [gotAck, retval]=stopClientTrials(data,subjIDStrs{get(subjIDField,'Value')},params);
            if ~isempty(retval) % save last trial's TRIAL_END event (the call to stopClientTrials saved its neuralRecord)
                for j=1:length(retval)
                    events_data(end+1).time=retval(j).time;
                    labels(end+1)=nan;
                    events_data(end).eventType=retval(j).type;
                    events_data(end).eventNumber=eventNum;
                    % save event log
                    deleteFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum-1);
                    saveFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum);
                    if ~isdir(savePath)
                        mkdir(savePath);
                    end
                    save(fullfile(savePath,saveFilename),'events_data','labels');
                    if eventNum~=1
                        delete(fullfile(savePath,deleteFilename));
                    end
                    eventNum=eventNum+1;
                end
            end
        end
        
        if params.recording % if we are running trials, then stopClientTrials handles saving of last chunk, DONT REPEAT
            disp('finishing up data collection');
            continueSave = true;
            FIFOWaringTriggered = false;
            while continueSave
                % not going to enable chunking
                for blockNum = 1:numDataBlocksCollected
                    datablock.read_next(ai);
                    if datablock.HasData
                        datablock.save();
                    end
                end
                if ai.FIFOPercentageFull>10 && ~FIFOWaringTriggered
                    fprintf('WARNING: FIFO is %2.2f %% full\n',ai.FIFOPercentageFull)
                    FIFOWaringTriggered = true;
                    numDataBlocksCollected= 100;
                else
                    FIFOWaringTriggered = false;
                    continueSave = false;
                    numDataBlocksCollected = 30;
                end
            end
            ai.stop();
            disp('closing');
            ai.SaveFile.close();
            ai.flush();
        end
        
        % reset some flags for next instance of run
        pnet('closeall');
        data=[];
        % disp('clearing recording classes');
        % clear ai; clear datablock; ai=[]; datablock = [];
        runningLoop=false;
        if running || recording % if we only turned off one of recording/running, then restart the run loop
            updateDisplay();
            run();
        end
    end


% ========================================================================================
% display box
recentEventsDisplay = uicontrol(f,'Style','edit','String','recent events','Visible','on','Units','pixels',...
    'FontWeight','normal','HorizontalAlignment','left','Max',999,'Min',0,'Value',[],'Enable','on', ...
    'Position',[margin+1*fieldWidth fHeight-24*oneRowHeight-1*margin fieldWidth*7-margin oneRowHeight*8]);

displayModeLabel = uicontrol(f,'Style','text','String','Display Mode','Visible','on','Units','pixels',...
    'HorizontalAlignment','center','Position',...
    [margin fHeight-25*oneRowHeight-2*margin fieldWidth*1-margin oneRowHeight]);
displayModeSelector = uicontrol(f,'Style','popup',...
    'String',displayModeStrs,'Enable','on','Visible','on',...
    'Value',displayModeIndex,'Units','pixels','Position',...
    [margin+fieldWidth fHeight-25*oneRowHeight-2*margin fieldWidth*1-margin oneRowHeight],...
    'Callback',@updateDisplay);

% ========================================================================================
% labels
openLabelingWindowButton = uicontrol(f,'Style','pushbutton','String','add labels','Visible','on','Units','pixels',...
    'Position',[margin+0*fieldWidth fHeight-24*oneRowHeight-1*margin fieldWidth*1-margin oneRowHeight],...
    'Value',0,'Callback',@openLabelingWindow);
    function openLabelingWindow(source,eventdata)
        labels=grouper(events_data,labels);
        % need to save labels to file now? - could use safesave here!
        saveFilename=sprintf('physiologyEvents_%d-%d.mat',1,eventNum-1);
        save(fullfile(savePath,saveFilename),'events_data','labels');
    end

% ========================================================================================
%% turn on the GUI
reloadEventsAndSurgeryFields([],[]);
set(f,'Visible','on');
%set(f,'WindowStyle','docked')
% set(detailsSelector,'SelectedObject',[]);
end

% ========================================================================================
% HELPER FUNCTIONS
function [quit, retval, status, requestDone]=doServerIteration(data,params,externalRequest)
% should also work in standalone phys logging mode (just do nothing...)
requestDone=false;
% check pnet('status') here if ratrix throws error, go back to
% connectToClient
status=pnet(getCmdCon(data),'status')>0 && pnet(getAckCon(data),'status')>0;

quit=false;
retval=[];
if ~isempty(getCmdCon(data)) && ~isempty(getAckCon(data))
    [data, quit, retval] = handleCommands(data,params);
end
if ~isempty(externalRequest)
    retval(end+1).time=getTimeFromClient(data);
    retval(end).type=externalRequest;
    requestDone=true;
end
% fprintf('did a server iteration\n')
pause(0.3);
end


%=========================================================================
function [session] = startINTAN()
disp('Starting recording setup...');
% Instantiate the rhd2000 driver.  Using the RHD2000 Matlab Toolbox
% almost always starts this way.
driver = rhd2000.Driver();

% Connect to a board.  This uses the default board; if you have more than
% one, see the two_boards example.
session = driver.create_board();
session.SamplingRate = rhd2000.SamplingRate.rate30000;
% enable digital signals
for i = 1:16
    session.SaveFile.SignalGroups{6}.Channels{i}.Enabled = true;
end
disp('Setup complete');
% need to find a way to set the exact phys channels and dgital channel but
% that comes later
end

function ai = updateRecordingConfiguration(ai,parameters)
DIGIN_Associations = {1,'Trial';...
    2,'Frames';...
    3,'Stim';...
    4,'Phase';...
    5,'Index';...
    6,'RewL';...
    7,'RewR';...
    8,'RewC';...
    9,'Left';...
    10,'Right';...
    11,'Center';...
    12,'LED1';...
    13,'LED2';...
    };

% set all channels to disable
for signal_group = 1:7
    channels = ai.SaveFile.SignalGroups{signal_group}.Channels;
    if ~isempty(channels)
        for channel = 1:length(channels)
            channels{channel}.Enabled = false;
        end
    end
end

% now set only the ones you want to enable
% set the ai_numChannels /enable/diable
analogSignalGroup = 1;
if parameters.numChannels == 0
   for i = 1:32
       ai.SaveFile.SignalGroups{analogSignalGroup}.Channels{i}.Enabled = false;
   end
else
    for i = 1:32
        ai.SaveFile.SignalGroups{analogSignalGroup}.Channels{i}.Enabled = true;
        channelname = sprintf('phys%d',i);
        ai.SaveFile.SignalGroups{1}.Channels{i}.Name = channelname;
    end
end

% set digital input channels
digitalInSignalGroup = 6;
for i = 1:size(DIGIN_Associations,1)
    if ismember(DIGIN_Associations{i,2},parameters.digitalChannels)
        ai.SaveFile.SignalGroups{digitalInSignalGroup}.Channels{i}.Enabled = true;
        ai.SaveFile.SignalGroups{digitalInSignalGroup}.Channels{i}.Name = DIGIN_Associations{i,2};
    else
        ai.SaveFile.SignalGroups{digitalInSignalGroup}.Channels{i}.Enabled = false;
    end
end

% set configuration for other stuff
%  from set_dafault_parameters
config = ai.get_configuration_parameters();

config.Chip.Power.AmplifierVRef = true;
config.Chip.Power.ADCComparator = true;
config.Chip.Power.VddSense = true;
config.Chip.Power.Auxin1 = true;
config.Chip.Power.Auxin2 = true;
config.Chip.Power.Auxin3 = true;
config.Chip.Power.Amplifiers=ones(64,1); % always 64, even for 16- and 32-channel chips


config.Chip.Bandwidth.DesiredUpper = 20000;
config.Chip.Bandwidth.DesiredLower = 0.1;
config.Chip.Bandwidth.DesiredDsp = 1.0;
config.Chip.Bandwidth.DspEnabled = true;

end
%=========================================================================
function processDataEvent(src, event)
fprintf('%d.',src.ChunkNum);
numDataAvail = length(event.TimeStamps);
src.NeuralData(:,src.NumDataPointsWritten+1:src.NumDataPointsWritten+numDataAvail) = event.Data';
src.NumDataPointsWritten = src.NumDataPointsWritten + numDataAvail;

if isnan(src.NeuralDataTimes(1))
    src.NeuralDataTimes(1) = event.TimeStamps(1);
end
src.NeuralDataTimes(2) = event.TimeStamps(end);
end

%=========================================================================
function ai = stopNidaq(ai)
stop(ai);
delete(ai);
% clear ai;
ai=[];
end

%=========================================================================
function success=stochasticDelete(filename)
if ~exist('filename','var')||~ischar(filename)
    error('stochasticDelete requires a filename which has to be a character datapath')
end

success=false;
timedout = false;
numTries = 10;

currTry = 1;
while ~success && ~timedout
    try
        if exist(filename,'file')
            delete(filename);
            success = true;
        else
            success = true;
        end
    catch
        pause(abs(randn));
        dispStr=sprintf('failed to delete %s - trying again',filename);
        disp(dispStr)
        currTry = currTry +1;
    end
    if currTry > numTries
        timedout = true;
    end
end

success = success & ~timedout;
end % end function
