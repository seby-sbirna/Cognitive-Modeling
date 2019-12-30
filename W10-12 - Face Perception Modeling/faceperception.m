function varargout = faceperception(varargin)
% FACEPERCEPTION MATLAB code for faceperception.fig
%      FACEPERCEPTION, by itself, creates a new FACEPERCEPTION or raises the existing
%      singleton*.
%
%      H = FACEPERCEPTION returns the handle to a new FACEPERCEPTION or the handle to
%      the existing singleton*.
%
%      FACEPERCEPTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACEPERCEPTION.M with the given input arguments.
%
%      FACEPERCEPTION('Property','Value',...) creates a new FACEPERCEPTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before faceperception_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to faceperception_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help faceperception

% Last Modified by GUIDE v2.5 10-Nov-2019 20:51:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @faceperception_OpeningFcn, ...
                   'gui_OutputFcn',  @faceperception_OutputFcn, ...
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


% --- Executes just before faceperception is made visible.
function faceperception_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to faceperception (see VARARGIN)

% Create the data to plot.
handles.output = hObject;

% BEGIN PARAMETERS
% enter the full path to your image database directory
image_folder = 'C:\Users\...';

% enter the file extension of your files
file_pattern = '*.png';

% enter the two options (left will correspond to the 'z' key, right to the
% 'm' key
handles.textLeft.String = 'Not smiling';
handles.textRight.String = 'Smiling';
% END PARAMETERS


handles.logfile = fopen('results.txt', 'a');



handles.files = dir(fullfile(image_folder, file_pattern));

handles.subject_id = input('Enter the subject ID (integer): ');

rng(handles.subject_id);

handles.files = handles.files(randperm(length(handles.files)));


handles.numfiles = length(handles.files);

for i = 1 : length(handles.files)
    handles.X{i} = imread(fullfile(image_folder, handles.files(i).name));   
end

movegui('center')
handles.index = 0;
handles.time = tic;
guidata(hObject, handles);


function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
 % determine the key that was pressed 
 keyPressed = eventdata.Key;
 disp(keyPressed);
 disp([handles.index handles.numfiles]);
 if handles.index == 0
     disp('index 0');
     handles.output = hObject;
     handles.index = handles.index + 1;
     handles.textStart.String = sprintf('%d/%d', handles.index, handles.numfiles);
     imshow(handles.X{handles.index},[]);
     handles.time = tic;
 else
     disp('here');
     if strcmp(keyPressed, 'z') || strcmp(keyPressed, 'm')
         if keyPressed == 'z'
             disp('Left');
             answer = handles.textLeft.String;
         elseif keyPressed == 'm'
             disp('Right');
             answer = handles.textRight.String;
         end
         fprintf(handles.logfile, '%d,%d,%s,%s,%.4f\n', handles.subject_id, handles.index, handles.files(handles.index).name, answer, toc(handles.time));
         handles.output = hObject;
         handles.index = handles.index + 1;
         if handles.index <= handles.numfiles
             imshow('cross.png');
             drawnow;
             java.lang.Thread.sleep(550);
             imshow(handles.X{handles.index},[]);
             handles.textStart.String = sprintf('%d/%d', handles.index, handles.numfiles);
         else
            closereq
            disp('End of the experiment');
            return
         end
         handles.time = tic;
     else
         fprintf('Press "z" for %s or "m" for %s', handles.textLeft.String, handles.textRight.String);
     end
 end
 guidata(hObject, handles);
 
% --- Outputs from this function are returned to the command line.
function varargout = faceperception_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
