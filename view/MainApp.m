function varargout = MainApp(varargin)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAINAPP MATLAB code for MainApp.fig
%      MAINAPP, by itself, creates a new MAINAPP or raises the existing
%      singleton*.
%
%      H = MAINAPP returns the handle to a new MAINAPP or the handle to
%      the existing singleton*.
%
%      MAINAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINAPP.M with the given input arguments.
%
%      MAINAPP('Property','Value',...) creates a new MAINAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainApp

% Last Modified by GUIDE v2.5 05-Mar-2014 10:26:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainApp_OpeningFcn, ...
                   'gui_OutputFcn',  @MainApp_OutputFcn, ...
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


% --- Executes just before MainApp is made visible.
function MainApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainApp (see VARARGIN)

% Choose default command line output for MainApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clear all;
    PwQuery('a');
    close Welcome;

% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clear all;
    
    %Try loading the config-file, if not successfull an error message is
    %displayed
    try
        getpath('config.mat','data');
        load(getpath('config.mat','data'))
        
        configFileFound = validateConfigObject(config);
    catch e
        configFileFound = false;
    end
    
    %If a config file was found exit and start main window
    if configFileFound
        setappdata(0,'config',config);
        MainWindow;
        close 'Welcome';
    else
        errordlg('Couldnt load the configuration file, its either missing or broken. Try running the configuration process again.');
    end


% --- Executes on button press in notnow_btn.
function notnow_btn_Callback(hObject, eventdata, handles)
% hObject    handle to notnow_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    q = questdlg('Without selecting a configuration option you will not be able to run an experiment. Do you still want to continue?');
    config = Configuration();
    config.setRunnable(false);
    setappdata(0,'config',config)
    
    if strcmp('Yes',q)
        MainWindow;
        close 'Welcome';
    end
    
    
