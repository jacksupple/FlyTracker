function varargout = host(varargin)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOST MATLAB code for host.fig
%      HOST, by itself, creates a new HOST or raises the existing
%      singleton*.
%
%      H = HOST returns the handle to a new HOST or the handle to
%      the existing singleton*.
%
%      HOST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOST.M with the given input arguments.
%
%      HOST('Property','Value',...) creates a new HOST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before host_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to host_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help host

% Last Modified by GUIDE v2.5 23-Apr-2014 10:18:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @host_OpeningFcn, ...
                   'gui_OutputFcn',  @host_OutputFcn, ...
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


% --- Executes just before host is made visible.
function host_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to host (see VARARGIN)

% Choose default command line output for host
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes host wait for user response (see UIRESUME)
% uiwait(handles.figure1);

config = getappdata(0,'config')

set(handles.edit1,'String',config.port);
set(handles.text1,'String',getIPAddress);

%Code to retrieve host name
mark = 'name = ';
arg = ['nslookup ',getIPAddress];
[~,out] = system(arg);
index = strfind(out,mark);
host = out(index+length(mark):end);

set(handles.text5,'String',host);

% --- Outputs from this function are returned to the command line.
function varargout = host_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ok_btn.
function ok_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ok_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    config = getappdata(0,'config');
    
    input = get(handles.edit1,'String');
    
    if isstrprop(input,'digit')         
        if (str2num(input) > 1024) && (str2num(input) < 65534)
            config.setPort(input);
            setappdata(0,'config',config);
        
            close 'Network Settings';
        else
            errordlg('Not a valid port number, you must enter an integer between 1024 and 65000');
        end
    else
        errordlg('Not a valid port number, you must enter an integer between 1024 and 65000');
    end
    
% --- Executes on button press in cancel_btn.
function cancel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close 'Network Settings';