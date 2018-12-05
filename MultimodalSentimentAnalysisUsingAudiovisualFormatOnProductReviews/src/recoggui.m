
function varargout = recoggui(varargin)

% RECOGGUI MATLAB code for recoggui.fig
%      RECOGGUI, by itself, creates a new RECOGGUI or raises the existing
%      singleton*.
%
%      H = RECOGGUI returns the handle to a new RECOGGUI or the handle to
%      the existing singleton*.
%
%      RECOGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGGUI.M with the given input arguments.
%
%      RECOGGUI('Property','Value',...) creates a new RECOGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recoggui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recoggui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recoggui

% Last Modified by GUIDE v2.5 29-Apr-2016 07:40:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recoggui_OpeningFcn, ...
                   'gui_OutputFcn',  @recoggui_OutputFcn, ...
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


% --- Executes just before recoggui is made visible.
function recoggui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recoggui (see VARARGIN)

% Choose default command line output for recoggui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recoggui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recoggui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File_Name Path_Name]=uigetfile({'*.jpg'},'File selector');
axes(handles.axes1);
global trainimage;
trainimage=imread(fullfile(Path_Name,File_Name));
%trainimage=[Path_Name,File_Name];
assignin('base','z1',trainimage);
imshow(trainimage);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File_Name Path_Name]=uigetfile({'*.jpg'},'File selector');
axes(handles.axes2);
global testimage;
testimage=imread(fullfile(Path_Name,File_Name));
%testimage=[Path_Name,File_Name];
assignin('base','z2',testimage);
imshow(testimage);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%run('C:\Users\lenovo1\Desktop\detection\demo.m');
output=demo();
set(handles.edit1,'String',output);
%{
 btncnt=[];
btncnt=btncnt+1;
a=num2str(btncnt);
%set(handles.edit1,'String',output);
if(strcmp(output,'Expression is Angry')==0)
    ang=ang+1;
elseif(strcmp(output,'Expression is sad')==0)
    sad=sad+1;
elseif(strcmp(output,'Expression is smile')==0)
    smi=smi+1;
    disp(smi);
elseif(strcmp(output,'Expression is suprise')==0)
    sup=sup+1;
else
    neu=neu+1;
end
%}



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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
areview='';
[posa nega]=list2();
if(posa>nega)
    areview='Audio Expression is postive';
else if(nega>posa)
    areview='Audio Expression is Negative';
    else
        areview='Audio Expression is Negative';
    end
end
        
set(handles.edit1,'String',areview);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
finalotp=fusion();
set(handles.edit1,'String',finalotp);
