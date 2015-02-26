function varargout = MouseID(varargin)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOUSEID MATLAB code for MouseID.fig
%      MOUSEID, by itself, creates a new MOUSEID or raises the existing
%      singleton*.
%
%      H = MOUSEID returns the handle to a new MOUSEID or the handle to
%      the existing singleton*.
%
%      MOUSEID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOUSEID.M with the given input arguments.
%
%      MOUSEID('Property','Value',...) creates a new MOUSEID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MouseID_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MouseID_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MouseID

% Last Modified by GUIDE v2.5 11-Feb-2014 15:23:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MouseID_OpeningFcn, ...
                   'gui_OutputFcn',  @MouseID_OutputFcn, ...
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


% --- Executes just before MouseID is made visible.
function MouseID_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MouseID (see VARARGIN)

% Choose default command line output for MouseID
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MouseID wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MouseID_OutputFcn(hObject, eventdata, handles) 
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
        close 'Setup (3/6)';
        
    end

% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    SetupSettings;
    close 'Setup (3/6)';

% --- Executes on button press in prev_btn.
function prev_btn_Callback(hObject, eventdata, handles)
% hObject    handle to prev_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    MiceSetup;
    close 'Setup (3/6)';

% --- Executes on button press in id_btn. "Identify Mouse"
function id_btn_Callback(hObject, eventdata, handles)
% hObject    handle to id_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    %Display text informing the user that the system is listening for mouse
    %inputs
    set(handles.hidden_txt,'visible','on');
    drawnow;
    config = getappdata(0,'config');
    
    %System call to run the python function mouseID which is the one doing
    %the actual identification 
    arg = ['echo ',config.pwd,' | sudo -S python ',getpath('mouseID.py','py')]
    [~,output] = system(arg);
    
    %Functionality to strip the resulting output from any non-digit characters
    index = isstrprop(output,'digit');
    output(~index) = '';
    %output = output(find(index,1):end);
    
    try
        %If the ouput is of the proper form a succes-message will be shown
        if (str2num(output(1)) > -1)
            title = 'Success! Mouse identified.';
            message = strcat('Mouse ',output(1),' is used as an actual mouse');
            msgbox(message,title);  
            
            set(handles.next_btn,'Enable','on');
            drawnow;
        end
    catch e
        errordlg('Something went wrong, please try again!');
    end
    
    set(handles.hidden_txt,'visible','off');
    drawnow;
        
        
