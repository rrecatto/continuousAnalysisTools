function varargout = SutterPosition(varargin)
%SUTTERPOSITION Allows basic operation of a Sutter MP-285 micropositioner
%
%M.A. Hopcroft
% 
% MH Oct 2012
% v1.0
%
% See also: SUTTERMP285



% Last Modified by GUIDE v2.5 10-Feb-2015 21:31:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SutterPosition_OpeningFcn, ...
                   'gui_OutputFcn',  @SutterPosition_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%#ok<*DEFNU>
%#ok<*ST2NM>
%#ok<*INUSL>
%#ok<*INUSD>

% --- Executes just before SutterPosition is made visible.
function SutterPosition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SutterPosition (see VARARGIN)

% Choose default command line output for SutterPosition
handles.output = hObject;

handles.SutterOffset = [13701, -14892, -14136.2]';

% Update handles structure
guidata(hObject, handles);

fprintf(1,'\nSutterPosition v1.0\n\n');

% UIWAIT makes SutterPosition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SutterPosition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% initialize default values
handles.sutter=[];
handles.sutterPos=[];

% disable move button until a connection is made
set(handles.button_Move,'Enable','off');

% set CloseRequestFcn
set(handles.figure1,'CloseRequestFcn',{@CloseFunction,handles});



%% Connect button
% --- Executes on button press in button_Connect.
function button_Connect_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to button_Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The Sutter uses a RS-232 serial port connection
% So the Mac must be using a USB-to-Serial converter

% get list of possible usb-to-serial devices
% use try/catch so that if there are none, then show an error
try
    if ismac
        ct=ls('/dev/tty.usb*');
    elseif isunix
        ct=ls('/dev/ttyUSB*');
    else
        fprintf('using the Com provided to connect to the sutter mp-285\n');
    end
catch lsEX %#ok<NASGU>
    fprintf(1,'SutterPostion: No USB-to-Serial Converters found!\n');
    msgbox('No USB-to-Serial Converters found!','No Serial Device','error');
    return
end

% user selects the correct USB device
% usbDev=textscan(handles.COMPort,'%s'); usbDev=usbDev{1};
% [selectDev,ok] = listdlg('ListString',usbDev,'SelectionMode','single','PromptString','Select a USB Device','Name','USBserial','ListSize',[200 100]);
% if ok==0
%     fprintf(1,'SutterPostion: No USB device selected\n');
%     return
% end
% selectDev
try
    % create connection to Sutter
    sutter = sutterMP285(handles.COMPort);
catch stEX
    fprintf(1,'SutterPostion: Unable to connect to Sutter. Please try again.\n  "%s"\n',stEX.message);
    delete(instrfind);
    return
end

% verify sutter connection
try
    [stepMult, currentVelocity, vScaleFactor]=getStatus(sutter);
    statusStr=sprintf('Sutter Status:\n Step Multiplier: %g\n Velocity: %g\n Scale Factor: %g\n',...
        stepMult,currentVelocity,vScaleFactor);
%     fprintf(1,'SutterPostion: %s\n',statusStr);
%     msgbox(statusStr,'Sutter Connected','help');

    updatePanel(sutter);

catch stEX %#ok<NASGU>
    fprintf(1,'SutterPostion: Sutter did not return status correctly. Try reset.\n');
    msgbox('Sutter did not return status correctly. Try reset.','No Status','error');
    return
end

% get current position
xyz_um=getPosition(sutter) - handles.SutterOffset;
% initialize the gui display
set(handles.posX_text,'String',num2str(xyz_um(1),'%g'));
set(handles.posX_text,'Value',xyz_um(1));
set(handles.posY_text,'String',num2str(xyz_um(2),'%g'));
set(handles.posY_text,'Value',xyz_um(2));
set(handles.posZ_text,'String',num2str(xyz_um(3),'%g'));
set(handles.posZ_text,'Value',xyz_um(3));

% save the new connection
handles.sutter=sutter;

% set CloseRequestFcn with sutter connection
set(handles.figure1,'CloseRequestFcn',{@CloseFunction,handles});

% Update handles structure
guidata(hObject, handles);

% update the plot and gui
updatePlots(xyz_um,handles);
set(handles.button_Connect,'String','Connected!');
set(handles.button_Move,'Enable','on');

fprintf(1,'SutterPostion: Sutter MP-285 ready.\n');




function posX_text_Callback(hObject, eventdata, handles)
% hObject    handle to posX_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posX_text as text
%        str2double(get(hObject,'String')) returns contents of posX_text as a double

pos=str2num(get(hObject,'String'));
set(hObject,'Value',pos);

set(hObject,'FontWeight','normal');
set(handles.button_Move,'FontWeight','bold');



function posY_text_Callback(hObject, eventdata, handles)
% hObject    handle to posY_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posY_text as text
%        str2double(get(hObject,'String')) returns contents of posY_text as a double

pos=str2num(get(hObject,'String'));
set(hObject,'Value',pos);

set(hObject,'FontWeight','normal');
set(handles.button_Move,'FontWeight','bold');



function posZ_text_Callback(hObject, eventdata, handles)
% hObject    handle to posZ_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posZ_text as text
%        str2double(get(hObject,'String')) returns contents of posZ_text as a double

pos=str2num(get(hObject,'String'));
set(hObject,'Value',pos);

set(hObject,'FontWeight','normal');
set(handles.button_Move,'FontWeight','bold');



%% Move button
% --- Executes on button press in button_Move.
function button_Move_Callback(hObject, eventdata, handles)
% hObject    handle to button_Move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newPos(1) = get(handles.posX_text,'Value');
newPos(2) = get(handles.posY_text,'Value');
newPos(3) = get(handles.posZ_text,'Value');

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);


%% update plot
function updatePlots(xyz,handles)
% displays the Sutter positioner location on the plot

hold(handles.XYAxis,'off');
% show tip position
plot(handles.XYAxis,xyz(1),-xyz(2),'og','LineWidth',6);
xlim(handles.XYAxis,[-15000 15000]);
ylim(handles.XYAxis,[-15000 15000]);
hold(handles.XYAxis,'on');
grid(handles.XYAxis,'on');

set(handles.XYAxis, 'xtick',[-15000 0 15000], 'xticklabel',{'-15','0','15'}, 'ytick',[-15000 0 15000], 'yticklabel',{'-15','0','15'})

hold(handles.ZAxis,'off');
plot(handles.ZAxis,[0.05 0.98],[-xyz(3) -xyz(3)],'g','LineWidth',2);
ylim(handles.ZAxis,[-15000 15000]);
hold(handles.ZAxis,'on');
grid(handles.ZAxis,'on');
set(handles.ZAxis, 'xtick',[], 'ytick',[-15000 0 15000], 'yticklabel',{'15','0','-15'})


function updateTexts(newPos,handles)
% called only when usign the back/front/lef/right etc buttons
set(handles.posX_text,'String',num2str(newPos(1),'%g'));
set(handles.posY_text,'String',num2str(newPos(2),'%g'));
set(handles.posZ_text,'String',num2str(newPos(3),'%g'));



%% Close Function
function CloseFunction(hObject, eventdata, handles)
% is called when window is closed

% close connection to Sutter
try
    if ~isempty(handles.sutter)
        fclose(handles.sutter);
        delete(handles.sutter);
    end
catch clEX
    fprintf(1,'Error closing connection to Sutter:\n  "%s"\n',clEX.message);
end

fprintf(1,'SutterPostion: Application quit.\n');
s=instrfind;
if ~isempty(s)
    fprintf(1,'  NOTE: there are %d usb/serial connections still active.\n',length(s));
end

% close the figure window
delete(handles.figure1)


% --- Executes during object creation, after setting all properties.
function posX_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posX_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function posY_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posY_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function posZ_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posZ_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comEdit_Callback(hObject, eventdata, handles)
% hObject    handle to comEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.COMPort = get(hObject,'string');
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of comEdit as text
%        str2double(get(hObject,'String')) returns contents of comEdit as a double


% --- Executes during object creation, after setting all properties.
function comEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.COMPort = 'COM2';
guidata(hObject,handles);


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newPos(1) = get(handles.posX_text,'Value');
set(handles.posX_text,'Value',newPos(1));
newPos(2) = get(handles.posY_text,'Value')-handles.stepSize;
set(handles.posY_text,'Value',newPos(2));
newPos(3) = get(handles.posZ_text,'Value');
set(handles.posZ_text,'Value',newPos(3));

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);
updateTexts(newPos,handles);
guidata(hObject,handles);


% --- Executes on button press in front.
function front_Callback(hObject, eventdata, handles)
% hObject    handle to front (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newPos(1) = get(handles.posX_text,'Value');
set(handles.posX_text,'Value',newPos(1));
newPos(2) = get(handles.posY_text,'Value')+handles.stepSize;
set(handles.posY_text,'Value',newPos(2));
newPos(3) = get(handles.posZ_text,'Value');
set(handles.posZ_text,'Value',newPos(3));

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);
updateTexts(newPos,handles);
guidata(hObject,handles);


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newPos(1) = get(handles.posX_text,'Value')+handles.stepSize;
set(handles.posX_text,'Value',newPos(1));
newPos(2) = get(handles.posY_text,'Value');
set(handles.posY_text,'Value',newPos(2));
newPos(3) = get(handles.posZ_text,'Value');
set(handles.posZ_text,'Value',newPos(3));

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);
updateTexts(newPos,handles);
guidata(hObject,handles);


% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newPos(1) = get(handles.posX_text,'Value')-handles.stepSize;
set(handles.posX_text,'Value',newPos(1));
newPos(2) = get(handles.posY_text,'Value');
set(handles.posY_text,'Value',newPos(2));
newPos(3) = get(handles.posZ_text,'Value');
set(handles.posZ_text,'Value',newPos(3));

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);
updateTexts(newPos,handles);
guidata(hObject,handles);


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newPos(1) = get(handles.posX_text,'Value');
set(handles.posX_text,'Value',newPos(1));
newPos(2) = get(handles.posY_text,'Value');
set(handles.posY_text,'Value',newPos(2));
newPos(3) = get(handles.posZ_text,'Value')-handles.stepSize;
set(handles.posZ_text,'Value',newPos(3));

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);
updateTexts(newPos,handles);
guidata(hObject,handles);


% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newPos(1) = get(handles.posX_text,'Value');
set(handles.posX_text,'Value',newPos(1));
newPos(2) = get(handles.posY_text,'Value');
set(handles.posY_text,'Value',newPos(2));
newPos(3) = get(handles.posZ_text,'Value')+handles.stepSize;
set(handles.posZ_text,'Value',newPos(3));

moveTime=moveTo(handles.sutter,newPos+handles.SutterOffset');
fprintf(1,'SutterPostion: Move to [%g %g %g] completed in %g seconds.\n',...
    newPos(1),newPos(2),newPos(3),moveTime);

set(hObject,'FontWeight','normal');

updatePlots(newPos,handles);
updatePanel(handles.sutter);
updateTexts(newPos,handles);
guidata(hObject,handles);



function stepSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to stepSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of stepSizeEdit as a double
handles.stepSize = str2num(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function stepSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.stepSize = 1000;
guidata(hObject,handles);
