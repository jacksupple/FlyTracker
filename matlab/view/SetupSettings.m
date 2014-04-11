function varargout = SetupSettings(varargin)
% SETUPSETTINGS MATLAB code for SetupSettings.fig
%      SETUPSETTINGS, by itself, creates a new SETUPSETTINGS or raises the existing
%      singleton*.
%
%      H = SETUPSETTINGS returns the handle to a new SETUPSETTINGS or the handle to
%      the existing singleton*.
%
%      SETUPSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETUPSETTINGS.M with the given input arguments.
%
%      SETUPSETTINGS('Property','Value',...) creates a new SETUPSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SetupSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SetupSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SetupSettings

% Last Modified by GUIDE v2.5 02-Apr-2014 11:38:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SetupSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @SetupSettings_OutputFcn, ...
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


% --- Executes just before SetupSettings is made visible.
function SetupSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SetupSettings (see VARARGIN)

% Choose default command line output for SetupSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SetupSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);

    image_ = imread(getpath('setup.png','img'));    
    image(image_,'Parent',handles.axes1);
    axis off;
    mode = '';
    
    if length(varargin) > 0
        if strcmp(varargin{1,1},'notsetup')
            mode = 'notsetup';
            set(handles.nextbtn,'String', 'OK');
            set(handles.prevbtn,'visible','off');
        end
    end
    
    setappdata(0,'mode',mode);

% --- Outputs from this function are returned to the command line.
function varargout = SetupSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function redit_Callback(hObject, eventdata, handles)
% hObject    handle to redit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of redit as text
%        str2double(get(hObject,'String')) returns contents of redit as a double


% --- Executes during object creation, after setting all properties.
function redit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angleedit_Callback(hObject, eventdata, handles)
% hObject    handle to angleedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angleedit as text
%        str2double(get(hObject,'String')) returns contents of angleedit as a double


% --- Executes during object creation, after setting all properties.
function angleedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prevbtn.
function prevbtn_Callback(hObject, eventdata, handles)
% hObject    handle to prevbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    MouseID;
    close 'Setup (4/6)';


% --- Executes on button press in nextbtn.
function nextbtn_Callback(hObject, eventdata, handles)
% hObject    handle to nextbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mode = getappdata(0,'mode');
    r = get(handles.redit,'String');
    ang = get(handles.angleedit,'String');
    config = getappdata(0,'config');
    
    if isstrprop(r,'digit') & isstrprop(r,'digit') & ~strcmp(r,'0')
        config.setRadius(str2double(r));
        config.setAngle(str2double(ang));
        setappdata(0,'config',config);

        if strcmp(mode,'notsetup')
            MainWindow;
        else
            calib = Calibrate(config);
            setappdata(0,'calib',calib);

            TranslationCal;
        end
        close 'Setup (4/6)';
    else
        errordlg('Radius and angle must be real numbers');
    end

% --- Executes on button press in cancelbtn.
function cancelbtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    q = questdlg('Are you sure you want to exit the configuration process? All changes will be lost');
    
    if strcmp(q,'Yes')
        MainApp;
        close 'Setup (4/6)';        
    end
