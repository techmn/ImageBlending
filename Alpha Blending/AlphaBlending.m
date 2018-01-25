function varargout = AlphaBlending(varargin)
% ALPHABLENDING MATLAB code for AlphaBlending.fig
%      ALPHABLENDING, by itself, creates a new ALPHABLENDING or raises the existing
%      singleton*.
%
%      H = ALPHABLENDING returns the handle to a new ALPHABLENDING or the handle to
%      the existing singleton*.
%
%      ALPHABLENDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALPHABLENDING.M with the given input arguments.
%
%      ALPHABLENDING('Property','Value',...) creates a new ALPHABLENDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AlphaBlending_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AlphaBlending_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AlphaBlending

% Last Modified by GUIDE v2.5 25-Jan-2018 23:51:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AlphaBlending_OpeningFcn, ...
                   'gui_OutputFcn',  @AlphaBlending_OutputFcn, ...
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


% --- Executes just before AlphaBlending is made visible.
function AlphaBlending_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AlphaBlending (see VARARGIN)

% Choose default command line output for AlphaBlending
handles.output = hObject;
handles.img1 = zeros(320,240,3);
handles.img2 = zeros(320,240,3);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AlphaBlending wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AlphaBlending_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_first_image.
function browse_first_image_Callback(hObject, eventdata, handles)
% hObject    handle to browse_first_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, path] = uigetfile({'*.jpg';'*.png';'*.bmp';'*.tif'},'Select Image');
if ~isempty(fname)
    handles.img1 = imread(fullfile(path, fname));
end
set(gcf,'CurrentAxes',handles.axes1);
imshow(handles.img1,[]);
title('First Image');
guidata(hObject, handles);


% --- Executes on button press in browse_second_image.
function browse_second_image_Callback(hObject, eventdata, handles)
% hObject    handle to browse_second_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, path] = uigetfile({'*.jpg';'*.png';'*.bmp';'*.tif'},'Select Image');
if ~isempty(fname)
    handles.img2 = imread(fullfile(path, fname));
end
set(gcf,'CurrentAxes',handles.axes2);
imshow(handles.img2,[]);
title('Second Image');
guidata(hObject, handles);


% --- Executes on slider movement.
function alpha_slider_Callback(hObject, eventdata, handles)
% hObject    handle to alpha_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
alpha = handles.alpha_slider.Value;
[r1,c1,z1] = size(handles.img1);
[r2,c2,z2] = size(handles.img2);
r = min(r1,r2);
c = min(c1,c2);

if z1 ~= 3
    tmp = handles.img1;
    handles.img1 = zeros(r1,c1,3);
    handles.img1(:,:,1) = tmp;
    handles.img1(:,:,2) = tmp;
    handles.img1(:,:,3) = tmp;
end
if z2 ~= 3
    tmp = handles.img2;
    handles.img2 = zeros(r2,c2,3);
    handles.img2(:,:,1) = tmp;
    handles.img2(:,:,2) = tmp;
    handles.img2(:,:,3) = tmp;
end

handles.img1 = double(handles.img1(1:r,1:c,:));
handles.img2 = double(handles.img2(1:r,1:c,:));

out_img = alpha*handles.img1 + (1-alpha)*handles.img2;

set(gcf,'CurrentAxes',handles.axes3);
imshow(uint8(out_img),[]);
title('Blended Image');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function alpha_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
