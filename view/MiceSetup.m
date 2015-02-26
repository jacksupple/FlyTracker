function varargout = MiceSetup(varargin)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MICESETUP MATLAB code for MiceSetup.fig
%      MICESETUP, by itself, creates a new MICESETUP or raises the existing
%      singleton*.
%
%      H = MICESETUP returns the handle to a new MICESETUP or the handle to
%      the existing singleton*.
%
%      MICESETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICESETUP.M with the given input arguments.
%
%      MICESETUP('Property','Value',...) creates a new MICESETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MiceSetup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MiceSetup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MiceSetup

% Last Modified by GUIDE v2.5 02-Apr-2014 11:35:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MiceSetup_OpeningFcn, ...
                   'gui_OutputFcn',  @MiceSetup_OutputFcn, ...
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


% --- Executes just before MiceSetup is made visible.
function MiceSetup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MiceSetup (see VARARGIN)

% Choose default command line output for MiceSetup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MiceSetup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MiceSetup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cancel_btn.
function cancel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    q = questdlg('Are you sure you want to exit the configuration process? All changes will be lost');
    
    if strcmp(q,'Yes')
        MainApp;
        close 'Setup (2/6)';        
    end

% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    MouseID;
    close 'Setup (2/6)';

% --- Executes on button press in cancel_btn.
function prev_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    PwQuery('a');
    close 'Setup (2/6)';
