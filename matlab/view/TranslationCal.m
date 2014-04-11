function varargout = TranslationCal(varargin)
% TRANSLATIONCAL MATLAB code for TranslationCal.fig
%      TRANSLATIONCAL, by itself, creates a new TRANSLATIONCAL or raises the existing
%      singleton*.
%
%      H = TRANSLATIONCAL returns the handle to a new TRANSLATIONCAL or the handle to
%      the existing singleton*.
%
%      TRANSLATIONCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSLATIONCAL.M with the given input arguments.
%
%      TRANSLATIONCAL('Property','Value',...) creates a new TRANSLATIONCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TranslationCal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TranslationCal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TranslationCal

% Last Modified by GUIDE v2.5 09-Apr-2014 15:18:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TranslationCal_OpeningFcn, ...
                   'gui_OutputFcn',  @TranslationCal_OutputFcn, ...
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


% --- Executes just before TranslationCal is made visible.
function TranslationCal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TranslationCal (see VARARGIN)

% Choose default command line output for TranslationCal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TranslationCal wait for user response (see UIRESUME)
% uiwait(handles.figure1);
    config = getappdata(0,'config');
    
    %Depending on the angle of forward movement calibration will look differently    
    if mod(config.theta_,45) == 0
       set(handles.editside,'visible','on');
       set(handles.text2,'visible','on');
       set(handles.text1, 'String','Dist moved away from sensor 1 (mm)'); 
       set(handles.text3,'String','Calibration of translational movement, calibrate one direction at a time (one of the distances always has to be zero)');
    end
    
    mode_ = '';
    if ~isempty(varargin)
        mode_ = varargin{1};
        setappdata(0,'mode',mode_);
        calib = Calibrate(handles);
        setappdata(0,'calib',calib);
        set(handles.prevbtn,'Visible','off');
        set(handles.nextbtn,'String','Finish');
    end
    

% --- Outputs from this function are returned to the command line.
function varargout = TranslationCal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in run_btn.
function run_btn_Callback(hObject, eventdata, handles)
% hObject    handle to run_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.run_btn,'String','Running');
    config = getappdata(0,'config');
    calib = getappdata(0,'calib');
    if exist(getpath('pipe','data'),'file')
        delete(getpath('pipe','data'));
    end
            
    arg = ['mkfifo ',getpath('pipe','data')];
    system(arg); %Create named pipe if not existing
            
    arg = ['echo ',config.pwd,' | sudo -S python ',getpath('DAQ.py','py'),' "notrigger" &'];
    system(arg);
                
    data = readData(handles,'','calibration');
    
    if ~isempty(data)
        forward = str2double(get(handles.editfor,'String'));
        side = str2double(get(handles.editside,'String'));
        
        if side ~= 0 || forward ~= 0
            
            direction = 1;
            
            if abs(sum(data{2,1})) > abs(sum(data{1,1}))
                direction = 2;
            end
            
            if forward == 0
                aDist = side;    
                mDist = sum(data{direction,1});
                
                calib = calib.calibrateTranslation(abs(mDist),aDist,'side');
            elseif side == 0
                config.flipAxis(direction);
                
                aDist = forward;
                mDist = sum(data{direction,1});
                                
                calib = calib.calibrateTranslation(abs(mDist),aDist,'forward');
            end   

            setappdata(0,'calib',calib);

            calib = getappdata(0,'calib');

            string_ = [num2str(calib.avgErr*100),'%'];
            set(handles.text7,'String',string_);
            set(handles.text6,'String',calib.numTrials);
            drawnow;
        
        else 
            errordlg('You can only calibrate one direction at a time so one distance always has to be zero');
        end
    end
    
    if calib.numTrials > 2
        set(handles.nextbtn,'Enable','on');
    end
    
    calib
    
    
% --- Executes on button press in stopbtn.
function stopbtn_Callback(hObject, eventdata, handles)
% hObject    handle to stopbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    stopAction(handles);    
    
% --- Executes on button press in prevbtn.
function prevbtn_Callback(hObject, eventdata, handles)
% hObject    handle to prevbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    SetupSettings;
    close 'Setup (5/6)';

% --- Executes on button press in nextbtn.
function nextbtn_Callback(hObject, eventdata, handles)
% hObject    handle to nextbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    calib = getappdata(0,'calib');
    config = getappdata(0,'config');
    mode_ = getappdata(0,'mode');
    
    config.setBeta(mean(calib.betas));
    setappdata(0,'config',config);
    
    if strcmp(mode_,'notsetup')
        save(getpath('config.mat','data'),'config');
    else
        Calibration;
    end
    
    
    
    
    close 'Setup (5/6)';

% --- Executes on button press in cancelbtn.
function cancelbtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mode_ = getappdata(0,'mode');
    
    q = questdlg('Are you sure you want to exit the configuration process? All changes will be lost');
    
    if strcmp(q,'Yes')
        
        if ~strcmp(mode_,'notsetup')
            MainApp;
        end
        
        close 'Setup (5/6)';        
    end


function editfor_Callback(hObject, eventdata, handles)
% hObject    handle to editfor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editfor as text
%        str2double(get(hObject,'String')) returns contents of editfor as a double


% --- Executes during object creation, after setting all properties.
function editfor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editfor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editside_Callback(hObject, eventdata, handles)
% hObject    handle to editside (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editside as text
%        str2double(get(hObject,'String')) returns contents of editside as a double


% --- Executes during object creation, after setting all properties.
function editside_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editside (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clearbtn.
function clearbtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    calib = getappdata(0,'calib');
    
    calib = calib.removeLatest();
    set(handles.text7,'String',calib.avgErr);
    set(handles.text6,'String',calib.numTrials);
    drawnow;
    
    setappdata(0,'calib',calib);   


% --- Executes on button press in clearallbtn.
function clearallbtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearallbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    calib = Calibrate(handles);
    setappdata(0,'calib',calib);
    set(handles.text7,'String','0%');
    set(handles.text6,'String',calib.numTrials);
    set(handles.nextbtn,'Enable','off');
    drawnow;

% --- Executes on key press with focus on run_btn and none of its controls.
function run_btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to run_btn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(eventdata.Key,'return')
        run_btn_Callback(hObject, eventdata, handles)
    end
    
% --- Executes on key press with focus on stopbtn and none of its controls.
function stopbtn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stopbtn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(eventdata.Key,'return')
        stopAction(handles);
    end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in helpbtn.
function helpbtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    helptext = 'With translation calibration you need to first of all be able to move the ball a known distance. It is important that this movement is away from the sensors so that the positive direction can be found. A minimum of three runs need to be done but for higher certainty a higher numer is recommended'
    
    helpWin(helptext);