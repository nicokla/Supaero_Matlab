function varargout = SVMManualTrain(varargin)
% SVMMANUALTRAIN MATLAB code for SVMManualTrain.fig
%      SVMMANUALTRAIN, by itself, creates a new SVMMANUALTRAIN or raises the existing
%      singleton*.
%
%      H = SVMMANUALTRAIN returns the handle to a new SVMMANUALTRAIN or the handle to
%      the existing singleton*.
%
%      SVMMANUALTRAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVMMANUALTRAIN.M with the given input arguments.
%
%      SVMMANUALTRAIN('Property','Value',...) creates a new SVMMANUALTRAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SVMManualTrain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SVMManualTrain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SVMManualTrain

% Last Modified by GUIDE v2.5 01-Mar-2012 11:57:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SVMManualTrain_OpeningFcn, ...
                   'gui_OutputFcn',  @SVMManualTrain_OutputFcn, ...
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


% --- Executes just before SVMManualTrain is made visible.
function SVMManualTrain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SVMManualTrain (see VARARGIN)

% Choose default command line output for SVMManualTrain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SVMManualTrain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SVMManualTrain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% %%%%%%%%%%%%%%%%%%%%%%% Browse button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global inputImage
global filename

% Selection du cube a traiter
 [filename,pathname] = uigetfile({'*.*'}, 'ouvrir', '');                        
 FileName = (sprintf('%s%s', pathname, filename));
 set(handles.edit1,'String', FileName); 
 set(handles.edit2,'String', filename); 
 % show image   
 F1=figure;
 inputImage = imread(FileName);
 imshow(inputImage),title('Input image');

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


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ok Bouton %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename

%% recupere les coordonnees des pixels sains et pathologiques
    % centre des carres 
        % pathologiques
        global cxp1
        global cyp1
        global cxp2
        global cyp2
        global cxp3
        global cyp3

        %sains
        global cxs1
        global cys1
        global cxs2
        global cys2
        global cxs3
        global cys3    
        
    % tailles des carres et sous echantillonnage
    t1=3;
    t2=5;
    t3=7;
    se1=1;
    se2=1;
    se3=1;

    sain=cond_pix_app([cxs1 cys1],[cxs2 cys2],[cxs3 cys3],t1,t2,t3,se1,se2,se3);
    patho=cond_pix_app([cxp1 cyp1],[cxp2 cyp2],[cxp3 cyp3],t1,t2,t3,se1,se2,se3);

%% range ces pixels dans un fichier texte Filename.app
outputfilename=get(handles.edit2,'string')
currentFolder = pwd
nom_fichier=[currentFolder '/' outputfilename '.app'] % changer here the output path
Ecrit_pix_app_fichier(nom_fichier,sain,patho)


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%% BOUTON SAIN 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global cxs1
global cys1

    % parametres de la fenetre de selection
    t=3;
    n=round(t/2)-1;
    nl=2*n+1;
    
    % recupere les coorsonnees du clic operateur
    figure(F1);
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    
    % affichage de la zone selectionnee
    p1=b1-n;
    p2=a1-n;
    offset=nl;
    x = [p1 p1+offset p1+offset p1 p1];
    y = [p2 p2 p2+offset p2+offset p2];
    hold on
    axis manual
    plot(x,y,'b')
    
    % stockage ds clics
    cxs1=[cxs1;a1];
    cys1=[cys1;b1];

%% %%%%%%%%%%%%%%%%%%%%%%%%% BOUTON SAIN 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global cxs2
global cys2

    % parametres de la fenetre de selection
    t=5;
    n=round(t/2)-1;
    nl=2*n+1;
    
    % recupere les coorsonnees du clic operateur
    figure(F1);
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    
    % affichage de la zone selectionnee
    p1=b1-n;
    p2=a1-n;
    offset=nl;
    x = [p1 p1+offset p1+offset p1 p1];
    y = [p2 p2 p2+offset p2+offset p2];
    hold on
    axis manual
    plot(x,y,'b')
    
    % stockage ds clics
    cxs2=[cxs2;a1];
    cys2=[cys2;b1];
    

%% %%%%%%%%%%%%%%%%%%%%%%%%% BOUTON SAIN 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global cxs3
global cys3

    % parametres de la fenetre de selection
    t=7;
    n=round(t/2)-1;
    nl=2*n+1;
    
    % recupere les coorsonnees du clic operateur
    figure(F1);
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    
    % affichage de la zone selectionnee
    p1=b1-n;
    p2=a1-n;
    offset=nl;
    x = [p1 p1+offset p1+offset p1 p1];
    y = [p2 p2 p2+offset p2+offset p2];
    hold on
    axis manual
    plot(x,y,'b')
    
    % stockage ds clics
    cxs3=[cxs3;a1];
    cys3=[cys3;b1];
    

%% %%%%%%%%%%%%%%%%%%%%%%%%% BOUTON PATHO 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global cxp1
global cyp1

    % parametres de la fenetre de selection
    t=3;
    n=round(t/2)-1;
    nl=2*n+1;
    
    % recupere les coorsonnees du clic operateur
    figure(F1);
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    
    % affichage de la zone selectionnee
    p1=b1-n;
    p2=a1-n;
    offset=nl;
    x = [p1 p1+offset p1+offset p1 p1];
    y = [p2 p2 p2+offset p2+offset p2];
    hold on
    axis manual
    plot(x,y,'r')
    
    % stockage ds clics
    cxp1=[cxp1;a1];
    cyp1=[cyp1;b1];

%% %%%%%%%%%%%%%%%%%%%%%%%%% BOUTON PATHO 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global cxp2
global cyp2

    % parametres de la fenetre de selection
    t=5;
    n=round(t/2)-1;
    nl=2*n+1;
    
    % recupere les coorsonnees du clic operateur
    figure(F1);
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    
    % affichage de la zone selectionnee
    p1=b1-n;
    p2=a1-n;
    offset=nl;
    x = [p1 p1+offset p1+offset p1 p1];
    y = [p2 p2 p2+offset p2+offset p2];
    hold on
    axis manual
    plot(x,y,'r')
    
    % stockage ds clics
    cxp2=[cxp2;a1];
    cyp2=[cyp2;b1];
    
%% %%%%%%%%%%%%%%%%%%%%%%%%% BOUTON PATHO 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global F1
global cxp3
global cyp3

    % parametres de la fenetre de selection
    t=7;
    n=round(t/2)-1;
    nl=2*n+1;
    
    % recupere les coorsonnees du clic operateur
    figure(F1);
    [b1,a1] = ginput(1);
    a1=round(a1);
    b1=round(b1);
    
    % affichage de la zone selectionnee
    p1=b1-n;
    p2=a1-n;
    offset=nl;
    x = [p1 p1+offset p1+offset p1 p1];
    y = [p2 p2 p2+offset p2+offset p2];
    hold on
    axis manual
    plot(x,y,'r')
    
    % stockage ds clics
    cxp3=[cxp3;a1];
    cyp3=[cyp3;b1];
