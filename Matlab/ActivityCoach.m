function varargout = ActivityCoach(varargin)
% ACTIVITYCOACH MATLAB code for ActivityCoach.fig
%      ACTIVITYCOACH, by itself, creates a new ACTIVITYCOACH or raises the existing
%      singleton*.
%
%      H = ACTIVITYCOACH returns the handle to a new ACTIVITYCOACH or the handle to
%      the existing singleton*.
%
%      ACTIVITYCOACH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTIVITYCOACH.M with the given input arguments.
%
%      ACTIVITYCOACH('Property','Value',...) creates a new ACTIVITYCOACH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ActivityCoach_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ActivityCoach_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ActivityCoach

% Last Modified by GUIDE v2.5 18-Apr-2012 13:45:33
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ActivityCoach_OpeningFcn, ...
                   'gui_OutputFcn',  @ActivityCoach_OutputFcn, ...
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


% --- Executes just before ActivityCoach is made visible.
function ActivityCoach_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ActivityCoach (see VARARGIN)

% Choose default command line output for ActivityCoach
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ActivityCoach wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ActivityCoach_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

process_data(handles.parameter.name, handles.parameter.gpx, handles.parameter.repare, handles.parameter.max_accu, handles.parameter.t_gap, handles.parameter.arff);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialize_gui(gcbf, handles, true);




function t_gap_Callback(hObject, eventdata, handles)
% hObject    handle to t_gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_gap as text
%        str2double(get(hObject,'String')) returns contents of t_gap as a double
ht_gap = str2double(get(hObject,'String'));
if isnan(ht_gap)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.parameter.t_gap = ht_gap;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function t_gap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_accu_Callback(hObject, eventdata, handles)
% hObject    handle to max_accu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_accu as text
%        str2double(get(hObject,'String')) returns contents of max_accu as a double
hmax_accu = str2double(get(hObject,'String'));
if isnan(hmax_accu)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new max_accu value
handles.parameter.max_accu = hmax_accu;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function max_accu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_accu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in repare.
function repare_Callback(hObject, eventdata, handles)
% hObject    handle to repare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of repare
hrepare = get(hObject,'Value');
handles.parameter.repare = hrepare;
guidata(hObject,handles)


% --- Executes on button press in gpx.
function gpx_Callback(hObject, eventdata, handles)
% hObject    handle to gpx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gpx
hgpx = get(hObject,'Value');
handles.parameter.gpx = hgpx;
guidata(hObject,handles)


% --- Executes on selection change in name.
function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns name contents as cell array
%        contents{get(hObject,'Value')} returns selected item from name
contents = cellstr(get(hObject,'String'));
hname = contents{get(hObject,'Value')};
handles.parameter.name = hname;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over start_button.
function start_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the parameter field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'parameter') && ~isreset
    return;
end

handles.parameter.max_accu = 60;
handles.parameter.t_gap = 5;
handles.parameter.repare = 0;
handles.parameter.gpx = 0;
handles.parameter.arff = 1;


set(handles.max_accu, 'String', handles.parameter.max_accu);
set(handles.t_gap,  'String', handles.parameter.t_gap);
set(handles.name, 'Value', 1); handles.parameter.name = 'Johanna';
set(handles.repare, 'Value', handles.parameter.repare);
set(handles.gpx, 'Value', handles.parameter.gpx);
set(handles.arff, 'Value', handles.parameter.arff);

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in arff.
function arff_Callback(hObject, eventdata, handles)
% hObject    handle to arff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of arff
harff = get(hObject,'Value');
handles.parameter.arff = harff;
guidata(hObject,handles)
