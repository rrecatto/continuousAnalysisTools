function varargout = interactiveInspectGUI(varargin)
% INTERACTIVEINSPECTGUI M-file for interactiveInspectGUI.fig
%      INTERACTIVEINSPECTGUI, by itself, creates a new INTERACTIVEINSPECTGUI or raises the existing
%      singleton*.
%
%      H = INTERACTIVEINSPECTGUI returns the handle to a new INTERACTIVEINSPECTGUI or the handle to
%      the existing singleton*.
%
%      INTERACTIVEINSPECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVEINSPECTGUI.M with the given input arguments.
%
%      INTERACTIVEINSPECTGUI('Property','Value',...) creates a new INTERACTIVEINSPECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interactiveInspectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interactiveInspectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interactiveInspectGUI

% Last Modified by GUIDE v2.5 02-Aug-2010 17:52:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @interactiveInspectGUI_OpeningFcn, ...
    'gui_OutputFcn',  @interactiveInspectGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1}) && isempty(strfind(varargin{1},'datanetOutput'))
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT

%% GUI startup
% --- Executes just before interactiveInspectGUI is made visible.
function interactiveInspectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interactiveInspectGUI (see VARARGIN)

% Choose default command line output for interactiveInspectGUI
disp('will now store data necessary to run GUI');
switch nargin
    case 7
        handles.analysisPath = varargin{1};
        handles.plottingInfo = varargin{2};
        handles.trodes = varargin{3};
        handles.originalSpikeRecord = varargin{4};
        handles.currentSpikeRecord = varargin{4}; % no changes have taken place
        % lets get the other stuff we need!
        handles.analysisBoundaryFile = fullfile(handles.analysisPath,'analysisBoundary.mat');
        temp = stochasticLoad(handles.analysisBoundaryFile,{'spikeDetectionParams','spikeSortingParams','trodes'},5);
        if isfield(temp,'spikeDetectionParams')
            handles.spikeDetectionParams = temp.spikeDetectionParams;
            handles.originalSpikeDetectionParams = temp.spikeDetectionParams;
        else
            error('interactiveInspectGUI:unableToReachAnalysisFolder','spikeDetectionParams is not available');
        end
        if isfield(temp,'spikeSortingParams')
            handles.spikeSortingParams = temp.spikeSortingParams;
            handles.originalSpikeSortingParams = temp.spikeSortingParams;
        else
            error('interactiveInspectGUI:unableToReachAnalysisFolder','spikeSortingParams is not available');
        end
        % trodes is special!
        if ~isfield(handles,'trodes')||isempty(handles.trodes)
            if isfield(temp,'trodes')&&~isempty(temp.trodes)
                handles.trodes = temp.trodes;
            else
                error('trodes is empty everywhere!!');
            end
        end
        handles.originalTrodes = temp.trodes;
        handles.currTrode = createTrodeName(handles.trodes{1});
    case 4
        handles.analysisPath = varargin{1};
        handles.plottingInfo.samplingRate = 40000;
        spikeRecordFile = fullfile(handles.analysisPath,'spikeRecord.mat');
        analysisBoundaryFile = fullfile(handles.analysisPath,'analysisBoundary.mat');
        temp = stochasticLoad(spikeRecordFile,{'spikeRecord'},5);
        if isfield(temp,'spikeRecord')
            handles.originalSpikeRecord = temp.spikeRecord;
            handles.currentSpikeRecord = temp.spikeRecord;
        else
            error('here');
        end
        
        temp = stochasticLoad(analysisBoundaryFile,{'spikeDetectionParams','spikeSortingParams','trodes'},5);
        if isfield(temp,'spikeDetectionParams')&&isfield(temp,'spikeSortingParams')&&isfield(temp,'trodes')
            handles.spikeDetectionParams = temp.spikeDetectionParams;
            handles.originalSpikeDetectionParams = temp.spikeDetectionParams;
            handles.spikeSortingParams = temp.spikeSortingParams;
            handles.originalSpikeSortingParams = temp.spikeSortingParams;
            handles.trodes = temp.trodes;
            handles.originalTrodes = temp.trodes;
            handles.currTrode = createTrodeName(handles.trodes{1});
        else
            error('here');
        end
    case 3
        warning('interactiveInspectGUI:testingModeOnly','only use this mode for testing');
        error('interactiveInspectGUI:testingModeRemoved','interactiveInspect does not use testing mode anymore');
        %         currPath = fileparts(mfilename('fullpath'));
        %         analysisPath = fullfile(currPath,'sampleData');
        %         handle.analysisPath = analysisPath;
        %         spikeRecordFile = fullfile(analysisPath,'spikeRecord.mat');
        %         analysisBoundaryFile = fullfile(analysisPath,'analysisBoundary.mat');
        %         temp = stochasticLoad(spikeRecordFile,{'spikeRecord'},5);
        %         if isfield(temp,'spikeRecord')
        %             handles.originalSpikeRecord = temp.spikeRecord;
        %             handles.currentSpikeRecord = temp.spikeRecord;
        %         else
        %             error('here');
        %         end
        %
        %         temp = stochasticLoad(analysisBoundaryFile,{'spikeDetectionParams','spikeSortingParams','trodes'},5);
        %         if isfield(temp,'spikeDetectionParams')&&isfield(temp,'spikeSortingParams')&&isfield(temp,'trodes')
        %             handles.spikeDetectionParams = temp.spikeDetectionParams;
        %             handles.originalSpikeDetectionParams = temp.spikeDetectionParams;
        %             handles.spikeSortingParams = temp.spikeSortingParams;
        %             handles.originalSpikeSortingParams = temp.spikeSortingParams;
        %             handles.trodes = temp.trodes;
        %             handles.originalTrodes = temp.trodes;
        %             handles.currTrode = createTrodeName(handles.trodes{1});
        %         else
        %             error('here');
        %         end
        %         handles.plottingInfo.samplingRate = 40000;
    otherwise
        error('why do you call this GUI in this weird way???');
end
% some special functions for the ISI plot
set(handles.hist10MSAxis,'ButtonDownFcn',{@hist10MSAxis_ButtonDownFcn, handles});

% Update handles structure
guidata(hObject, handles);

%initialize the trodesMenu
trodesMenu_Initialize(hObject, eventdata, handles);

% fill up the clusters panel
clusterListPanel_Initialize(hObject, eventdata, handles);

% now update the axes
updateAllAxes(hObject, eventdata, handles);

% UIWAIT makes interactiveInspectGUI wait for user response (see UIRESUME)
% uiwait(handles.inspectGUIFig);
end

%% GUI close
% --- Outputs from this function are returned to the command line.
function varargout = interactiveInspectGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = hObject;
% Get default command line output from handles structure
% varargout{1} = handles.spikeSortingParams;
% varargout{2} = handles.currentSpikeRecord;
end

%% GUI Exit
function interactiveInspectGUI_ExitFcn(hObject, eventdata, handles)
% keyboard
delete(handles.inspectGUIFig);
end

%% Axes create funcs. nothing will be done. because handles is empty
% featureAxis
% --- Executes during object creation, after setting all properties.
function featureAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featureAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
text(1,1,'choose trode','HorizontalAlignment','right','VerticalAlignment','Top');
% Hint: place code in OpeningFcn to populate featureAxis
end
% waveAxis
% --- Executes during object creation, after setting all properties.
function waveAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
text(1,1,'choose trode','HorizontalAlignment','right','VerticalAlignment','Top');
% Hint: place code in OpeningFcn to populate waveAxis
end
% waveMeansAxis
% --- Executes during object creation, after setting all properties.
function waveMeansAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveMeansAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
text(1,1,'choose trode','HorizontalAlignment','right','VerticalAlignment','Top');
% Hint: place code in OpeningFcn to populate waveMeansAxis
end
% hist10MSAxis
% --- Executes during object creation, after setting all properties.
function hist10MSAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hist10MSAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
text(1,1,'choose trode','HorizontalAlignment','right','VerticalAlignment','Top');
end
% hist10000MSAxis
% --- Executes during object creation, after setting all properties.
function hist10000MSAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hist10000MSAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
text(1,1,'choose trode','HorizontalAlignment','right','VerticalAlignment','Top');
end
% trodesMenu
% --- Executes during object creation, after setting all properties.
function trodesMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trodesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% firingRateAxis
% --- Executes during object creation, after setting all properties.
function firingRateAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firingRateAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
text(1,1,'choose trode','HorizontalAlignment','right','VerticalAlignment','Top');
% Hint: place code in OpeningFcn to populate firingRateAxis
end
% --- Executes during object creation, after setting all properties.
%detectionMethodMenu
function detectionMethodMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detectionMethodMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
%sortingMethodMenu
% --- Executes during object creation, after setting all properties.
function sortingMethodMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sortingMethodMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes during object creation, after setting all properties.
%barChartWhole
function barChartWhole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to barChartWhole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate barChartWhole
end
%barChartPart
% --- Executes during object creation, after setting all properties.
function barChartPart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to barChartPart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate barChartPart
end
% --- Executes during object creation, after setting all properties.

%% Deals with how the axes are updated
% updateAllAxes
function updateAllAxes(hObject, eventdata, handles)
featureAxis_UpdateFcn(hObject, eventdata, handles);
waveAxis_UpdateFcn(hObject, eventdata, handles);
waveMeansAxis_UpdateFcn(hObject, eventdata, handles);
linkaxes([handles.waveAxis handles.waveMeansAxis],'xy')
hist10MSAxis_UpdateFcn(hObject, eventdata, handles);
hist10000MSAxis_UpdateFcn(hObject, eventdata, handles);
firingRateAxis_UpdateFcn(hObject, eventdata, handles);
barChartWhole_UpdateFcn(hObject, eventdata, handles);
barChartPart_UpdateFcn(hObject, eventdata, handles);
end
% featureAxis
function featureAxis_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);

% go to the axis
axes(handles.featureAxis);cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end

% get the feature values
[features nDim] = useFeatures(spikeWaveforms,spikeModel.featureList,spikeModel.featureDetails);



% choose color scheme
colors=getClusterColorValues(handles,rankedClusters);
% colors(1,:) = [1 0 0]; % red

clusterVisibilityValues = getClusterVisibilityValues(handles, rankedClusters);


% loop through clusters and plot features
for i=1:length(rankedClusters)
    thisCluster=find(assignedClusters==rankedClusters(i));
    if ~isempty(thisCluster)&&clusterVisibilityValues(i)
        if i==1
            markerType = '*';
        else
            markerType = '.';
        end
        plot3(features(thisCluster,1),features(thisCluster,2),features(thisCluster,3),markerType,'color',colors(i,:));
        axis([min(features(:,1)) max(features(:,1)) min(features(:,2)) max(features(:,2)) min(features(:,3)) max(features(:,3))]);
        colorStr = sprintf('\\color[rgb]{%f %f %f}',colors(i,1),colors(i,2),colors(i,3));
        text(max(features(:,1)),max(features(:,2))-0.1*max(features(:,2))*(i-1),0,sprintf('%s%d:%d spikes',colorStr,rankedClusters(i),length(thisCluster)),'HorizontalAlignment','right','VerticalAlignment','top');
    end
    
end
end
% waveAxis
function waveAxis_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);


% select the axis
axes(handles.waveAxis); cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end


% choose color scheme
colors=getClusterColorValues(handles,rankedClusters);
% colors(1,:) = [1 0 0]; % red

clusterVisibilityValues = getClusterVisibilityValues(handles, rankedClusters);



% now plot
for i=1:length(rankedClusters)
    thisCluster=find(assignedClusters==rankedClusters(i));
    if ~isempty(thisCluster) && clusterVisibilityValues(i)
        plot(spikeWaveforms(thisCluster,:)','color',colors(i,:));
    end
end

title('waveforms');
set(gca,'XTick',[]);
axis([1 size(spikeWaveforms,2)  1.1*minmax(spikeWaveforms(:)') ])
end
% waveMeansAxis
function waveMeansAxis_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);


% select the axis
axes(handles.waveMeansAxis); cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end


% choose color scheme
colors=getClusterColorValues(handles,rankedClusters);
% colors(1,:) = [1 0 0]; % red

clusterVisibilityValues = getClusterVisibilityValues(handles, rankedClusters);


for i=1:length(rankedClusters)
    thisCluster=find(assignedClusters==rankedClusters(i));
    if ~isempty(thisCluster)&& clusterVisibilityValues(i)
        meanWave = mean(spikeWaveforms(thisCluster,:),1);
        stdWave = std(spikeWaveforms(thisCluster,:),1);
        plot(meanWave','color',colors(i,:),'LineWidth',2);
        lengthOfWaveform = size(spikeWaveforms,2);
        fillWave = fill([1:lengthOfWaveform fliplr(1:lengthOfWaveform)]',[meanWave+stdWave fliplr(meanWave-stdWave)]',colors(i,:));set(fillWave,'edgeAlpha',0,'faceAlpha',.2);
    end
end
set(gca,'XTick',[1 25 61],'XTickLabel',{sprintf('%2.2f',-24000/handles.plottingInfo.samplingRate),'0',sprintf('%2.2f',36000/handles.plottingInfo.samplingRate)});xlabel('ms');
end
% hist10MSAxis
function hist10MSAxis_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);

% select the axis
axes(handles.hist10MSAxis); cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end

% set the colors
colors=getClusterColorValues(handles,rankedClusters);
% colors(1,:) = [1 0 0]; %red

clusterVisibilityValues = getClusterVisibilityValues(handles, rankedClusters);


%inter-spike interval distribution
trialNums = unique(trialNumForSpikes);
existISILess10MS = false;
maxEdgePart = 0;
maxProbPart = 0;
% for other spikes
for i = 1:length(rankedClusters)
    if clusterVisibilityValues(i)
        thisCluster = (assignedClusters==rankedClusters(i));
        ISIThisCluster = [];
        for currTrialNum = 1:length(trialNums)
            whichThisTrialThisCluster = (trialNumForSpikes==trialNums(currTrialNum))&thisCluster;
            spikeTimeStampsThisTrialThisCluster = spikeTimestamps(whichThisTrialThisCluster);
            ISIThisCluster = [ISIThisCluster; diff(spikeTimeStampsThisTrialThisCluster*1000)];
        end
        
        % part
        edges = linspace(0,10,100);
        count=histc(ISIThisCluster,edges);
        if sum(count)>0
            existISILess10MS = true;
            prob=count/sum(count);
            ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],colors(i,:));
            set(ISIfill,'edgeAlpha',0,'faceAlpha',.5);
            maxEdgePart = max(maxEdgePart,max(edges));
            maxProbPart = max(maxProbPart,max(prob));
        end
    end
end
if existISILess10MS
    axis([0 maxEdgePart 0 maxProbPart]);
    text(maxEdgePart/2,maxProbPart,'ISI<10ms','HorizontalAlignment','center','VerticalAlignment','Top')
    lockout=1000*39/handles.plottingInfo.samplingRate;  %why is there a algorithm-imposed minimum ISI?  i think it is line 65  detectSpikes
    lockout=edges(max(find(edges<=lockout)));
    plot([lockout lockout],get(gca,'YLim'),'k') %
    plot([2 2], get(gca,'YLim'),'k--')
else
    axis([0 10 0 1]);
    text(10,1,'no ISI < 10 ms','HorizontalAlignment','right','VerticalAlignment','Top');
end
end
% hist10000MSAxis
function hist10000MSAxis_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);

% select the axis
axes(handles.hist10000MSAxis); cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end



% set the colors
colors=getClusterColorValues(handles,rankedClusters);
% colors(1,:) = [1 0 0]; %red

clusterVisibilityValues = getClusterVisibilityValues(handles, rankedClusters);


%inter-spike interval distribution
trialNums = unique(trialNumForSpikes);
existISILess10000MS = false;
maxEdgeTot = 0;
maxProbTot = 0;
% for other spikes
for i = 1:length(rankedClusters)
    if clusterVisibilityValues(i)
        thisCluster = (assignedClusters==rankedClusters(i));
        ISIThisCluster = [];
        for currTrialNum = 1:length(trialNums)
            whichThisTrialThisCluster = (trialNumForSpikes==trialNums(currTrialNum))&thisCluster;
            spikeTimeStampsThisTrialThisCluster = spikeTimestamps(whichThisTrialThisCluster);
            ISIThisCluster = [ISIThisCluster; diff(spikeTimeStampsThisTrialThisCluster*1000)];
        end
        
        % total
        edges = linspace(0,10000,100);
        count=histc(ISIThisCluster,edges);
        if sum(count)>0
            existISILess10000MS = true;
            prob=count/sum(count);
            ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],colors(i,:));
            set(ISIfill,'edgeAlpha',0,'faceAlpha',.5);
            maxEdgeTot = max(maxEdgeTot,max(edges));
            maxProbTot = max(maxProbTot,max(prob));
        end
    end
end

if existISILess10000MS
    axis([0 maxEdgeTot 0 maxProbTot]);
    text(maxEdgeTot/2,maxProbTot,'ISI<10s','HorizontalAlignment','center','VerticalAlignment','Top')
else
    axis([0 10000 0 1]);
    text(10000,1,'no ISI < 10 s','HorizontalAlignment','right','VerticalAlignment','Top');
end
end
% firingRateAxis
function firingRateAxis_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);
trialNumsForChunks = handles.currentSpikeRecord.trialNum;
chunkDurationForChunks = handles.currentSpikeRecord.chunkDuration;
trialStartTimeForChunks = handles.currentSpikeRecord.trialStartTime;

% select the axis
axes(handles.firingRateAxis); cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end

% set the colors
colors=getClusterColorValues(handles,rankedClusters);
% colors(1,:) = [1 0 0]; %red

clusterVisibilityValues = getClusterVisibilityValues(handles, rankedClusters);


minimumTimeToEstimateFiringRate = min(sum(handles.currentSpikeRecord.chunkDuration)/3,3);% seconds

secondsPerDay = 86400;
trialNums = unique(trialNumsForChunks);

groupingOfTrials = {};
currentRunningDuration = 0;
theseTrialsInStreak = [];

% create the grouping of trials
for i = 1:length(trialNums)
    currentTrialNum = trialNums(i);
    netDurationAtCurrentTrial = sum(chunkDurationForChunks(trialNumsForChunks==currentTrialNum));
    if (currentRunningDuration+netDurationAtCurrentTrial)>minimumTimeToEstimateFiringRate
        theseTrialsInStreak(end+1) = currentTrialNum;
        startTimeForStreak=unique(trialStartTimeForChunks(trialNumsForChunks==min(theseTrialsInStreak)));
        if length(startTimeForStreak)~=1
            error('what!')
        end
        groupingOfTrials{end+1} = {startTimeForStreak, currentRunningDuration+netDurationAtCurrentTrial, theseTrialsInStreak};
        currentRunningDuration = 0;
        theseTrialsInStreak = [];
    else
        currentRunningDuration = currentRunningDuration+netDurationAtCurrentTrial;
        theseTrialsInStreak(end+1) = currentTrialNum;
    end
end
groupingOfTrials{end+1} = {startTimeForStreak, currentRunningDuration+netDurationAtCurrentTrial, theseTrialsInStreak};

% create the spikeCountMatrix
spikeCountMatrix = nan(length(groupingOfTrials),length(rankedClusters));
trialStartAndDuration = nan(length(groupingOfTrials),2);
for groupNum = 1:length(groupingOfTrials)
    whichTrials = groupingOfTrials{groupNum}{3};
    for clustNum = 1:length(rankedClusters)
        spikeCountMatrix(groupNum,clustNum) = length(find(ismember(trialNumForSpikes,whichTrials)&(assignedClusters==rankedClusters(clustNum))));
    end
    trialStartAndDuration(groupNum,:) = [groupingOfTrials{groupNum}{1} groupingOfTrials{groupNum}{2}];
end
firingRateMatrix = spikeCountMatrix./repmat(trialStartAndDuration(:,2),1,length(rankedClusters));
for clustNum = 1:length(rankedClusters)
    if clusterVisibilityValues(clustNum)
        % plot((trialStartAndDuration(:,1)-min(trialStartAndDuration(:,1)))*secondsPerDay,firingRateMatrix(:,clustNum),'LineWidth',2,'color',colors(clustNum,:));
        plot((trialStartAndDuration(:,1)-min(trialStartAndDuration(:,1)))*secondsPerDay,firingRateMatrix(:,clustNum),'.','color',colors(clustNum,:));
    end
end
try
    xlims = minmax(makerow((trialStartAndDuration(:,1)-min(trialStartAndDuration(:,1)))*secondsPerDay));
    if xlims(2) == xlims(1)
        xlims(2) = xlims(1)+1;
    end
    axis([xlims -0.1*max(firingRateMatrix(:)) 1.1*max(firingRateMatrix(:))]);
catch ex
    keyboard
    warning('something wrong with the axis call. im just going to deal with it arbitrarily. but it needs thought and work');
    axis
end
end
% populating the trodesMenu popup menu
function trodesMenu_Initialize(hObject, eventdata, handles)
trodesAvail = {};
for i = 1:length(handles.trodes)
    trodesAvail{i} = createTrodeName(handles.trodes{i});
end
currTrodeNum = find(strcmp(handles.currTrode,trodesAvail));
set(handles.trodesMenu,'String',trodesAvail);
set(handles.trodesMenu,'Value',currTrodeNum);
end
% initialize the clusterPanel
function clusterListPanel_Initialize(hObject, eventdata, handles)
whichTrode = handles.currTrode;
try
    rankedClustersCell = handles.currentSpikeRecord.(whichTrode).rankedClusters;
catch ex
    if strfind(ex.message,'Reference to non-existent field ''rankedClusters''')
        ex2 = MException('InteractiveInspectGUI:noRankedClusters','Did you sort those cells?');
        ex = addCause(ex,ex2);
        throw(ex);
    else
        throw(ex);
    end
end
% sometimes rankedClusters is a Cell array. Just
if iscell(rankedClustersCell) %(happens when we call after sorting on every chunk)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end
positionOfCheckBoxes = arrangeInSpace(length(rankedClusters),'rowThenColumn');
if isfield(handles,'clusterListHandles')
    for i = 1:length(handles.clusterListHandles)
        delete(handles.clusterListHandles(i));
    end
end
handles.clusterListHandles = [];
colorPermOrder = randperm(length(rankedClusters));
colors = spikesColorMap(length(rankedClusters));
colors = colors(colorPermOrder,:);
handles.cMap = colors;
guidata(hObject,handles);
% colors(1,:) = [1,0,0];
for i = 1:length(rankedClusters)
    handles.clusterListHandles(i) = uicontrol('Parent',handles.clusterListPanel,'Style','checkbox',...
        'String',sprintf('%d',rankedClusters(i)),'Value',1,'Units','normalized',...
        'Position',[([0 -0.15]+positionOfCheckBoxes(i,:)) 0.12 0.15],'ForegroundColor',colors(i,:),'CallBack',{@updateAllAxes,handles});
end

% update the guidata
guidata(hObject,handles);
end
% barChartWhole
function barChartWhole_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);

% select the axis
axes(handles.barChartWhole); cla; hold on;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end

% set the colors
colors=getClusterColorValues(handles,rankedClusters);

% get cluster visibility
clusterVisibilityValues = getClusterVisibilityValues(handles,rankedClusters);

spikeCounts = nan(length(rankedClusters),1);
clusterNames = {};
for i = 1:length(rankedClusters)
    spikeCounts(i) = length(find(assignedClusters==rankedClusters(i)));
    clusterNames{i} = sprintf('%d',rankedClusters(i));
end
% normalize by the % of spikes
spikeCounts = 100*spikeCounts/sum(spikeCounts);

barWhole = bar(spikeCounts);

% now change colors according to colormap
for i = 1:length(rankedClusters)
    if ~clusterVisibilityValues(i)
        colors(i,:) = [0.5 0.5 0.5];
    end
end
set(get(barWhole,'Children'),'FaceVertexCData',colors);
end
% barChartPart
function barChartPart_UpdateFcn(hObject, eventdata, handles)
[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);

% select the axis
axes(handles.barChartPart); cla; hold on;
% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end

% set the colors
colors=getClusterColorValues(handles,rankedClusters);

% get cluster visibility
clusterVisibilityValues = getClusterVisibilityValues(handles,rankedClusters);

spikeCounts = [];
clusterNames = {};
for i = 1:length(rankedClusters)
    spikeCounts(i) = length(find(assignedClusters==rankedClusters(i)));
    clusterNames{i} = sprintf('%d',rankedClusters(i));
end

%now include only those that actually are visible
whichClusters = find(~clusterVisibilityValues);
spikeCounts(whichClusters) = [];

% normalize by the % of spikes
spikeCounts = 100*spikeCounts/sum(spikeCounts);


colors(whichClusters,:) = [];
if ~isempty(spikeCounts)
    barPart = bar(spikeCounts);
    set(get(barPart,'Children'),'FaceVertexCData',colors);
end

end

%% Callbacks are set here
% --- Executes on selection change in trodesMenu.
function trodesMenu_Callback(hObject, eventdata, handles)
% hObject    handle to trodesMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newTrodeNum = get(handles.trodesMenu,'Value');
handles.currTrode = createTrodeName(handles.trodes{newTrodeNum});

% update handles to reflect current knowledge
guidata(hObject, handles);

% initialize the clusterList panel
clusterListPanel_Initialize(hObject, eventdata, handles)

% now update the axes
updateAllAxes(hObject, eventdata, handles);
% Hints: contents = get(hObject,'String') returns trodesMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trodesMenu
end
% --- Executes on button press in sortSpikesButton.
function sortSpikesButton_Callback(hObject, eventdata, handles)
% hObject    handle to sortSpikesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the spikes data
whichTrode = handles.currTrode;
spikes = handles.currentSpikeRecord.(whichTrode).spikes;
spikeTimestamps = handles.currentSpikeRecord.(whichTrode).spikeTimestamps;
spikeWaveforms = handles.currentSpikeRecord.(whichTrode).spikeWaveforms;
spikeSortingParams = handles.spikeSortingParams.(whichTrode);
rankedClustersCell = handles.currentSpikeRecord.(whichTrode).rankedClusters;
assignedClusters = handles.currentSpikeRecord.(whichTrode).assignedClusters;

% sometimes rankedClusters is a Cell array. Just
if iscell(rankedClustersCell) %(happens when we call after sorting on every chunk)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end

%which clusters To analyze?
clusterVisibilityValues = [];
clusterSelectionStrings = get(get(handles.clusterListPanel,'Children'),'String');
clusterVisibilityValuesUnordered = get(get(handles.clusterListPanel,'Children'),'Value');
for i = 1:length(rankedClusters)
%     if length(rankedClusters)~=1
        index = find(strcmp(clusterSelectionStrings,sprintf('%d',rankedClusters(i))));
        clusterVisibilityValues(i) = clusterVisibilityValuesUnordered{index};
%     else
%         clusterVisibilityValues = clusterVisibilityValuesUnordered;
%     end
end


clustersToSort = rankedClusters(find(clusterVisibilityValues));
theseSpikes = ismember(assignedClusters,clustersToSort);
spikesToSort = spikes(theseSpikes);
spikeWaveformsToSort = spikeWaveforms(theseSpikes,:);
spikeTimeStampsToSort = spikeTimestamps(theseSpikes);

% now remove those clusters
rankedClusters(find(clusterVisibilityValues)) = [];

if ~isempty(rankedClusters)
    maxClusterNumber = max(rankedClusters);
else
    maxClusterNumber = 0;
end

% actual call to sort
[newAssignedClusters newRankedClusters]= sortSpikesDetected(spikesToSort, spikeWaveformsToSort,spikeTimeStampsToSort,spikeSortingParams);
spikeDetails = postProcessSpikeClusters(newAssignedClusters,newRankedClusters,spikeSortingParams,spikeWaveformsToSort);

handles.currentSpikeRecord.(whichTrode).assignedClusters(theseSpikes) = newAssignedClusters+maxClusterNumber;
handles.currentSpikeRecord.(whichTrode).rankedClusters = [rankedClusters(:); newRankedClusters(:)+maxClusterNumber];
handles.currentSpikeRecord.(whichTrode).processedClusters(theseSpikes) = spikeDetails.processedClusters;
guidata(hObject, handles);
clusterListPanel_Initialize(hObject, eventdata, handles);
updateAllAxes(hObject, eventdata, handles);
end
% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~~isequal(handles.currentSpikeRecord,handles.originalSpikeRecord)||...
        ~isequal(handles.spikeSortingParams,handles.originalSpikeSortingParams)||...
        ~isequal(handles.spikeSortingParams,handles.originalSpikeDetectionParams)||...
        ~isequal(handles.trodes,handles.originalTrodes)
    question = {'All changes made to currentspikeRecord will be ','saved in originalSpikerecord. Continue?'};
    option1 = 'Yes';
    option2 = 'No';
    saveChoice = questdlg(question,option1,option2);
    switch saveChoice
        case 'Yes'
            handles.originalSpikeRecord = handles.currentSpikeRecord;
            handles.originalSpikeRecord = handles.currentSpikeRecord;
            handles.originalTrodes = handles.trodes;
            handles.originalSpikeDetectionParams = handles.spikeDetectionParams;
            handles.originalSpikeSortingParams = handles.spikeSortingParams;
            guidata(hObject,handles);
        case 'No'
            % do nothing
    end
end
end
% --- Executes on button press in saveAndExitButton.
function saveAndExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveAndExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% changes to spikeRecord
if ~isequal(handles.currentSpikeRecord,handles.originalSpikeRecord)||...
        ~isequal(handles.spikeSortingParams,handles.originalSpikeSortingParams)||...
        ~isequal(handles.spikeSortingParams,handles.originalSpikeDetectionParams)||...
        ~isequal(handles.trodes,handles.originalTrodes)
    question = {'Changes have been made to currentSpikeRecord/spikeSortingParams','spikeSortingParams/trodes. Save changes?'};
    option1 = 'Yes';
    option2 = 'No';
    saveChoice = questdlg(question,option1,option2);
    switch saveChoice
        case 'Yes'
            handles.originalSpikeRecord = handles.currentSpikeRecord;
            handles.originalTrodes = handles.trodes;
            handles.originalSpikeDetectionParams = handles.spikeDetectionParams;
            handles.originalSpikeSortingParams = handles.spikeSortingParams;
            guidata(hObject,handles);
        case 'No'
            % do nothing
    end
end
question = {'Write and exit?'};
option1 = 'Yes';
option2 = 'No';
saveChoice = questdlg(question,option1,option2);
switch saveChoice
    case 'Yes'
        spikeRecordFile = fullfile(handles.analysisPath,'spikeRecord.mat');
        analysisBoundaryFile = fullfile(handles.analysisPath,'analysisBoundary.mat');
        spikeRecord = handles.originalSpikeRecord;
        trodes = handles.originalTrodes;
        spikeDetectionParams = handles.originalSpikeDetectionParams;
        spikeSortingParams = handles.originalSpikeSortingParams;
        save(spikeRecordFile,'spikeRecord','-append');
        save(analysisBoundaryFile,'trodes','spikeDetectionParams','spikeSortingParams','-append');
    case 'No'
        return
end
interactiveInspectGUI_ExitFcn(hObject, eventdata, handles);
end
% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
question = 'Exit?';
option1 = 'Yes';
option2 = 'No';
saveChoice = questdlg(question,option1,option2);
switch saveChoice
    case 'Yes'
        % do nothing
    case 'No'
        return;
end
interactiveInspectGUI_ExitFcn(hObject, eventdata, handles);
end
% --- Executes on slider movement.
function thresholdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end
% --- Executes on button press in restoreButton.
function restoreButton_Callback(hObject, eventdata, handles)
% hObject    handle to restoreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
question = 'Restore original data?';
option1 = 'Yes';
option2 = 'No';
saveChoice = questdlg(question,option1,option2);
switch saveChoice
    case 'Yes'
        handles.currentSpikeRecord = handles.originalSpikeRecord;
        handles.trodes = handles.originalTrodes;
        handles.spikeDetectionParams = handles.originalSpikeDetectionParams;
        handles.spikeSortingParams = handles.originalSpikeSortingParams;
    case 'No'
        return;
end
% reset values
handles.currTrode = createTrodeName(handles.trodes{1});
guidata(hObject,handles);
%initialize the trodesMenu
trodesMenu_Initialize(hObject, eventdata, handles);

% fill up the clusters panel
clusterListPanel_Initialize(hObject, eventdata, handles);

% now update the axes
updateAllAxes(hObject, eventdata, handles);

end
% --- Executes on button press in mergePushButton.
function mergePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to mergePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
whichTrode = handles.currTrode;
spikes =  handles.currentSpikeRecord.(whichTrode).spikes;
spikeWaveforms =  handles.currentSpikeRecord.(whichTrode).spikeWaveforms;
assignedClusters =  handles.currentSpikeRecord.(whichTrode).assignedClusters;
spikeTimestamps = handles.currentSpikeRecord.(whichTrode).spikeTimestamps;
trialNumForSpikes = handles.currentSpikeRecord.(whichTrode).trialNumForDetectedSpikes;
rankedClustersCell = handles.currentSpikeRecord.(whichTrode).rankedClusters;
processedClusters = handles.currentSpikeRecord.(whichTrode).processedClusters;
spikeModel = handles.currentSpikeRecord.(whichTrode).spikeModel;

% sometimes rankedClusters is a Cell array. Just
if iscell(rankedClustersCell) %(happens when we call after sorting on every chunk)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end

clusterVisibilityValues = [];
clusterSelectionStrings = get(get(handles.clusterListPanel,'Children'),'String');
clusterVisibilityValuesUnordered = get(get(handles.clusterListPanel,'Children'),'Value');
for i = 1:length(rankedClusters)
    index = find(strcmp(clusterSelectionStrings,sprintf('%d',rankedClusters(i))));
    clusterVisibilityValues(i) = clusterVisibilityValuesUnordered{index};
end

if all(~clusterVisibilityValues)
    noClusterError = errordlg('no clusters selected for merging','no cluster error');
    return;
end

whichClusters = find(clusterVisibilityValues);
mergedClusterNumber = min(rankedClusters(whichClusters));
assignedClusters(ismember(assignedClusters,rankedClusters(whichClusters))) = mergedClusterNumber;
rankedClusters(ismember(rankedClusters,rankedClusters(whichClusters))&(rankedClusters~=mergedClusterNumber)) = [];
handles.currentSpikeRecord.(whichTrode).rankedClusters = rankedClusters;
handles.currentSpikeRecord.(whichTrode).assignedClusters = assignedClusters;

guidata(hObject,handles);
% fill up the clusters panel
clusterListPanel_Initialize(hObject, eventdata, handles);

% now update the axes
updateAllAxes(hObject, eventdata, handles);
end
% --- Executes on button press in splitPushButton.
function splitPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to splitPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles);

% check if there is only one cluster visible. else warn.
clusterVisibilityValues = getClusterVisibilityValues(handles,rankedClusters);
if length(find(clusterVisibilityValues))~=1
    h = warndlg('Exactly one cluster should be visible'); uiwait(h);
    return
end
whichCluster = rankedClusters(find(clusterVisibilityValues));

viewPosition = get(handles.featureAxis,'CameraPosition');
viewAngle = get(handles.featureAxis,'CameraViewAngle');
viewPosition = viewPosition/norm(viewPosition);
% get the feature values
[featuresAll nDim] = useFeatures(spikeWaveforms,spikeModel.featureList,spikeModel.featureDetails);

% filter original record to get only relevant spikes
whichSpikes = ismember(assignedClusters,whichCluster);
featuresAll = featuresAll(whichSpikes,:);
whichAssignedClusters = assignedClusters(whichSpikes);

% we are using only features (1,2,and 3)
featureNumbers = [1 2 3];
featuresUsed = featuresAll(:,featureNumbers);
% now project features onto the viewAngle vector
featuresProjectedBeforeRotation = featuresUsed*null(viewPosition);

% now rotate according to the camera view Angle????
featuresProjected(:,1) = featuresProjectedBeforeRotation(:,1)*cos(viewAngle)-featuresProjectedBeforeRotation(:,2)*sin(viewAngle);
featuresProjected(:,2) = featuresProjectedBeforeRotation(:,2)*cos(viewAngle)+featuresProjectedBeforeRotation(:,1)*sin(viewAngle);

clusterColorValues = getClusterColorValues(handles,rankedClusters);
colors = clusterColorValues(find(clusterVisibilityValues),:);
splitFigure = figure('Name','Place an ellipse to split the cluster');
featAxis = axes;
plot(featuresProjected(:,1),featuresProjected(:,2),'.','color',colors);hold on;
% create an imellipse object
regionOfInterest = imellipse(featAxis); wait(regionOfInterest);
posn = getPosition(regionOfInterest);
delete(regionOfInterest);
delete(splitFigure); % everything necessary is done!
a = posn(3)/2; b = posn(4)/2; cenX = posn(1)+a; cenY = posn(2)+b;

% move coordinates to center of ellipse
featShifted = [featuresProjected(:,1)-cenX featuresProjected(:,2)-cenY];
[theta rho] = cart2pol(featShifted(:,1),featShifted(:,2));
whichIn = (rho<(a*b)./sqrt(((b^2*cos(theta).^2)+(a^2*sin(theta).^2))));

if 0 % for verification only
    figure; polar(theta,rho,'.');
    thetaPrime = 0:0.01:2*pi
    rhoPrime = (a*b)./sqrt(((b^2*cos(thetaPrime).^2)+(a^2*sin(thetaPrime).^2)));
    hold on;
    polar(thetaPrime,rhoPrime)
    polar(theta(whichIn),rho(whichIn),'r.');
end

% deal with the original records.
newClusterNum = max(rankedClusters)+1;
rankedClusters(end+1) = newClusterNum;
% now the assignedClusters. Ones not in the selected region get the new number
whichAssignedClusters(~whichIn) = newClusterNum;
assignedClusters(whichSpikes)=whichAssignedClusters;

% update the currentSpikeRecord
handles.currentSpikeRecord.(whichTrode).rankedClusters = rankedClusters;
handles.currentSpikeRecord.(whichTrode).assignedClusters = assignedClusters;

% update the records
guidata(hObject,handles);

% update cluster list panel
clusterListPanel_Initialize(hObject, eventdata, handles);

% update Axes
updateAllAxes(hObject, eventdata, handles);

end
% --- Executes on mouse press over axes background.
function hist10MSAxis_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to hist10MSAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
whichTrode = handles.currTrode;
spikes =  handles.currentSpikeRecord.(whichTrode).spikes;
spikeWaveforms =  handles.currentSpikeRecord.(whichTrode).spikeWaveforms;
assignedClusters =  handles.currentSpikeRecord.(whichTrode).assignedClusters;
spikeTimestamps = handles.currentSpikeRecord.(whichTrode).spikeTimestamps;
trialNumForSpikes = handles.currentSpikeRecord.(whichTrode).trialNumForDetectedSpikes;
rankedClustersCell = handles.currentSpikeRecord.(whichTrode).rankedClusters;
processedClusters = handles.currentSpikeRecord.(whichTrode).processedClusters;
spikeModel = handles.currentSpikeRecord.(whichTrode).spikeModel;

% now check if worth plotting
if isempty(spikes)
    text(0.5,0.5,sprintf('no spikes in %s',whichTrode),'HorizontalAlignment','center','VerticalAlignment','middle');
    return
end

% sometimes rankedClusters is a Cell array. Just
if iscell(rankedClustersCell) %(happens when we call after sorting on every chunk)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end


% select the axis
axes(handles.hist10MSAxis); cla; hold on;

% set the colors
colors = [0 0 0]; %blk

clusterVisibilityValues = [];
clusterSelectionStrings = get(get(handles.clusterListPanel,'Children'),'String');
clusterVisibilityValuesUnordered = get(get(handles.clusterListPanel,'Children'),'Value');
for i = 1:length(rankedClusters)
%     if length(rankedClusters)~=1
        index = find(strcmp(clusterSelectionStrings,sprintf('%d',rankedClusters(i))));
        clusterVisibilityValues(i) = clusterVisibilityValuesUnordered{index};
%     else
%         clusterVisibilityValues = clusterVisibilityValuesUnordered;
%     end
end


%inter-spike interval distribution
trialNums = unique(trialNumForSpikes);
existISILess10MS = false;
maxEdgePart = 0;
maxProbPart = 0;
% for other spikes
whichClusters = find(clusterVisibilityValues);
whichSpikes = ismember(assignedClusters,rankedClusters(whichClusters));
whichSpikeTimeStamps = spikeTimestamps(whichSpikes);
whichTrialNumForSpikes = trialNumForSpikes(whichSpikes);
trialNums = unique(whichTrialNumForSpikes);
ISIMergedCluster = [];
for currTrialNum = 1:length(trialNums)
    whichThisTrialMergedCluster = (whichTrialNumForSpikes==trialNums(currTrialNum));
    spikeTimeStampsThisTrialMergedCluster = whichSpikeTimeStamps(whichThisTrialMergedCluster);
    ISIMergedCluster = [ISIMergedCluster; diff(spikeTimeStampsThisTrialMergedCluster*1000)];
end
% part
edges = linspace(0,10,100);
count=histc(ISIMergedCluster,edges);
if sum(count)>0
    existISILess10MS = true;
    prob=count/sum(count);
    ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],colors);
    set(ISIfill,'edgeAlpha',0,'faceAlpha',.5);
    maxEdgePart = max(maxEdgePart,max(edges));
    maxProbPart = max(maxProbPart,max(prob));
end
if existISILess10MS
    axis([0 maxEdgePart 0 maxProbPart]);
    text(maxEdgePart/2,maxProbPart,'ISI<10ms','HorizontalAlignment','center','VerticalAlignment','Top')
    lockout=1000*39/handles.plottingInfo.samplingRate;  %why is there a algorithm-imposed minimum ISI?  i think it is line 65  detectSpikes
    lockout=edges(max(find(edges<=lockout)));
    plot([lockout lockout],get(gca,'YLim'),'k') %
    plot([2 2], get(gca,'YLim'),'k--')
else
    axis([0 10 0 1]);
    text(10,1,'no ISI < 10 ms','HorizontalAlignment','right','VerticalAlignment','Top');
end
% uiwait(handles.inspectGUIFig);
h = warndlg('Press OK to continue'); uiwait(h);
hist10MSAxis_UpdateFcn(hObject, eventdata, handles);
end
% --- Executes on button press in processedClusterButton.
function processedClusterButton_Callback(hObject, eventdata, handles)
% hObject    handle to processedClusterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
whichTrode = handles.currTrode;
rankedClustersCell = handles.currentSpikeRecord.(whichTrode).rankedClusters;
assignedClusters =  handles.currentSpikeRecord.(whichTrode).assignedClusters;


% sometimes rankedClusters is a Cell array. Just
if iscell(rankedClustersCell) %(happens when we call after sorting on every chunk)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end

clusterVisibilityValues = [];
clusterSelectionStrings = get(get(handles.clusterListPanel,'Children'),'String');
clusterVisibilityValuesUnordered = get(get(handles.clusterListPanel,'Children'),'Value');
if iscell(clusterVisibilityValuesUnordered)
    for i = 1:length(rankedClusters)
        index = find(strcmp(clusterSelectionStrings,sprintf('%d',rankedClusters(i))));
        clusterVisibilityValues(i) = clusterVisibilityValuesUnordered{index};
    end
else
    clusterVisibilityValues = clusterVisibilityValuesUnordered;
end

if all(~clusterVisibilityValues)
    noClusterError = errordlg('no clusters selected for merging','no cluster error');
    return;
end

whichClusters = find(clusterVisibilityValues);
processedClusters =  ismember(assignedClusters,rankedClusters(whichClusters));

handles.currentSpikeRecord.(whichTrode).processedClusters=processedClusters;
guidata(hObject,handles);
end

%% HELPER FUNCTIONS
function x = makerow(x)
%y = makerow(x)

x = squeeze(x);
if(size(x,2) == 1)
    x = x';
end
end
function position = arrangeInSpace(n,order,border)
if ~exist('border','var') || isempty(border)
    border = 0.02;
end

if ~exist('order','var')||isempty(order)
    order = 'rowThenColumn';
end

availableSpace = [1-2*border 1-2*border];
arrangement = [5,ceil(n/5)];

% create the numbering
numbering = nan(arrangement(1),arrangement(2));
position = nan(n,2);
switch order
    case 'rowThenColumn'
        for col=1:arrangement(2)
            numbering(:,col) = (col-1)*arrangement(1)+(1:arrangement(1));
        end
    case 'columnThenRow'
        for row=1:arrangement(1)
            numbering(row,:) = (row-1)*arrangement(2)+(1:arrangement(2));
        end
    otherwise
        error('unknown order');
end

eachRowSize = availableSpace(1)/arrangement(1);
eachColSize = availableSpace(2)/arrangement(2);

for i = 1:n
    [yPos,xPos] = find(numbering==i);
    position(i,:) = [((xPos-1)*eachColSize) 1-((yPos-1)*eachRowSize)];
end
end
function [whichTrode spikes spikeWaveforms assignedClusters spikeTimestamps ...
    trialNumForSpikes rankedClusters processedClusters spikeModel] = ...
    getSpikeData(handles)
whichTrode = handles.currTrode;
spikes =  handles.currentSpikeRecord.(whichTrode).spikes;
spikeWaveforms =  handles.currentSpikeRecord.(whichTrode).spikeWaveforms;
assignedClusters =  handles.currentSpikeRecord.(whichTrode).assignedClusters;
spikeTimestamps = handles.currentSpikeRecord.(whichTrode).spikeTimestamps;
trialNumForSpikes = handles.currentSpikeRecord.(whichTrode).trialNumForDetectedSpikes;
rankedClustersCell = handles.currentSpikeRecord.(whichTrode).rankedClusters;
processedClusters = handles.currentSpikeRecord.(whichTrode).processedClusters;
spikeModel = handles.currentSpikeRecord.(whichTrode).spikeModel;

% sometimes rankedClusters is a Cell array. Just
if iscell(rankedClustersCell) %(happens when we call after sorting on every chunk)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end
end
function clusterVisibilityValues = getClusterVisibilityValues(handles,rankedClusters)
clusterVisibilityValues = [];
clusterSelectionStrings = get(get(handles.clusterListPanel,'Children'),'String');
clusterVisibilityValuesUnordered = get(get(handles.clusterListPanel,'Children'),'Value');
for i = 1:length(rankedClusters)
    %if length(rankedClusters)~=1
        index = find(strcmp(clusterSelectionStrings,sprintf('%d',rankedClusters(i))));
        clusterVisibilityValues(i) = clusterVisibilityValuesUnordered{index};
%     else
%         keyboard
%         clusterVisibilityValues = clusterVisibilityValuesUnordered;
%     end
end
end
function clusterColorValues = getClusterColorValues(handles,rankedClusters)
clusterColorValues = nan(length(rankedClusters),3);
clusterSelectionStrings = get(get(handles.clusterListPanel,'Children'),'String');
clusterColorValuesUnordered = get(get(handles.clusterListPanel,'Children'),'ForeGroundColor');
for i = 1:length(rankedClusters)
%     if length(rankedClusters)~=1
        index = find(strcmp(clusterSelectionStrings,sprintf('%d',rankedClusters(i))));
        clusterColorValues(i,:) = clusterColorValuesUnordered{index};
%     else
%         clusterColorValues = clusterColorValuesUnordered;
%     end
end
end
