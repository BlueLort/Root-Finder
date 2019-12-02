



function varargout = rootFinder(varargin)
% ROOTFINDER MATLAB code for rootFinder.fig
%      ROOTFINDER, by itself, creates a new ROOTFINDER or raises the existing
%      singleton*.
%
%      H = ROOTFINDER returns the handle to a new ROOTFINDER or the handle to
%      the existing singleton*.
%
%      ROOTFINDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROOTFINDER.M with the given input arguments.
%
%      ROOTFINDER('Property','Value',...) creates a new ROOTFINDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rootFinder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rootFinder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rootFinder

% Last Modified by GUIDE v2.5 27-Nov-2019 23:47:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rootFinder_OpeningFcn, ...
                   'gui_OutputFcn',  @rootFinder_OutputFcn, ...
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


% --- Executes just before rootFinder is made visible.
function rootFinder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rootFinder (see VARARGIN)

% Choose default command line output for rootFinder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global lastXr;
global firstTime;
lastXr=0;
firstTime=true;






% UIWAIT makes rootFinder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rootFinder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%initial error checking for find root button
function [error] = findRootErrorChecker(handles)
error=false;
set(handles.sMessage,'string','');
if(strcmp(get(handles.tEquation,'string'),''))
     set(handles.sMessage,'string','You need to enter an equation like: 3*x^4+6.1*x^3-2*x^2+3*x+2');
     error=true;
     return;
end
if(strcmp(get(handles.tStart,'string'),''))
     set(handles.sMessage,'string','Start field is empty');
     error=true;
     return;
end
if(strcmp(get(handles.tEnd,'string'),''))
     set(handles.sMessage,'string','End field is empty');
     error=true;
     return;
end
if(strcmp(get(handles.tEpsilon,'string'),''))
     set(handles.sMessage,'string','Epsilon field is empty');
     error=true;
     return;
end
if(strcmp(get(handles.tNIterations,'string'),''))
     set(handles.sMessage,'string','nIterations field is empty');
     error=true;
     return;
end
if(str2num(get(handles.tEnd,'string'))-str2num(get(handles.tStart,'string'))<0)
     set(handles.sMessage,'string','Invalid Range Order Start > End');
     error=true;
     return;
end



     
% --- Executes on button press in bFindRoot.
function bFindRoot_Callback(hObject, eventdata, handles)
% hObject    handle to bFindRoot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%f=inline(get(handles.tEquation,'string'));%f(x)
D_ROOT=' Root = ';
D_NITERATIONS=' Number of iterations = ';
D_EPSILON=' Epsilon[Precision] = ';
D_EXECUTIONTIME=' Execution Time = ';
D_MAXITERATIONS=' Max Iterations = ';
D_ERROR=' Theoritical Bound of error = ';
if(~findRootErrorChecker(handles))
 f=get(handles.tEquation,'string');
method=get(handles.pMethod,'value');
start=str2num(get(handles.tStart,'string'));
endVal=str2num(get(handles.tEnd,'string'));
epsilon=str2num(get(handles.tEpsilon,'string'));
maxIterations=str2num(get(handles.tNIterations,'string'));
gx=get(handles.tGx,'string');
if(method==4 & strcmp(gx,''))
    set(handles.sMessage,'string','g(x) is empty');
    return;
end
if(method==4)
     %divergence check
        dgx=diff(sym(gx),1);
        dgx=inline(dgx,'x');
        if(dgx(start) <1 || dgx(end) < 1)
            set(handles.sMessage,'string','g(x) is going to diverge..');
        end
    
end
try
tic
if( method == 2)
    
      %[xl,xu,fxl,fxu,Xr,fxr,Ep,Iterations]
      [xl,xu,fxl,fxu,Xr,fxr,Ep,Iterations]=bisectionMethod(f,start,endVal,epsilon,maxIterations);
      figg = handles.Table;
        d = randn(Iterations,8);
        t = uitable(figg);
        for i=1:1:Iterations

          d(i,:) = [i xl(i) xu(i) fxl(i) fxu(i) Xr(i) fxr(i) Ep(i)];
        end
        set(t,'Data',d); 
        set(t,'ColumnName',{'i';'xl(i)';'xu(i)';'fxl(i)';'fxu(i)';'Xr(i)';'fxr(i)';'Ep(i)';})
        

      Xr = Xr(end);
      Ep = Ep(end);
      
    elseif(method == 3)
      [xl,xu,fxl,fxu,Xr,fxr,Ep,Iterations]=falsePosition(f,start,endVal,epsilon,maxIterations);
        figg = handles.Table;
        d = randn(Iterations,8);
        t = uitable(figg);
        for i=1:1:Iterations

          d(i,:) = [i xl(i) xu(i) fxl(i) fxu(i) Xr(i) fxr(i) Ep(i)];
        end
        set(t,'Data',d); 
        set(t,'ColumnName',{'i';'xl(i)';'xu(i)';'fxl(i)';'fxu(i)';'Xr(i)';'fxr(i)';'Ep(i)';})

      Xr = Xr(end);
      Ep = Ep(end);
      
    elseif(method == 4)
      [Xr,fxr,Ep,Iterations]=fixedPointMethod(f,gx,start,endVal,epsilon,maxIterations);

       figg = handles.Table;
        d = randn(Iterations,4);
        t = uitable(figg);
        for i=1:1:Iterations

          d(i,:) = [i Xr(i) fxr(i) Ep(i)];
        end
        set(t,'Data',d); 
        set(t,'ColumnName',{'i';'xi(i)';'fxi(i)';'Ep(i)';})

      Xr = Xr(end);
      Ep = Ep(end);
    elseif(method == 5)
     [Xr,fxi,Ep,Iterations]=newtonRaphson(f,start,epsilon,maxIterations);
     
     
     figg = handles.Table;
        d = randn(Iterations,4);
        t = uitable(figg);
        for i=1:1:Iterations

          d(i,:) = [i Xr(i) fxi(i) Ep(i)];
        end
        set(t,'Data',d); 
        set(t,'ColumnName',{'i';'xi(i)';'fxi(i)';'Ep(i)';})

      Xr = Xr(end);
      Ep = Ep(end);
    elseif(method == 6)
      [Xr,fxi,Ep,Iterations]=secant(f,start,endVal,epsilon,maxIterations);

           figg = handles.Table;
        d = randn(Iterations,4);
        t = uitable(figg);
        for i=1:1:Iterations

          d(i,:) = [i Xr(i) fxi(i) Ep(i)];
        end
        set(t,'Data',d); 
        set(t,'ColumnName',{'i';'xi(i)';'fxi(i)';'Ep(i)';})

      
      Xr = Xr(end);
      Ep = Ep(end);
else
         set(handles.sMessage,'string','Select a method to find the root');
         return;
end
theobound='diverges';
F= inline(f,'x');
if(F(Xr) == 0)
 theobound = 'converges';
end
if(Ep<=epsilon)
 theobound = 'converges';
end
time = toc;

set(handles.sRoot,'string',strcat(D_ROOT,num2str(Xr)));
set(handles.sNIterations,'string',strcat(D_NITERATIONS,num2str(Iterations)));
set(handles.sEpsilon,'string',strcat(D_EPSILON,num2str(Ep)));

set(handles.sExeTime,'string',strcat(D_EXECUTIONTIME,num2str(toc)));

set(handles.sMaxIterations,'string',strcat(D_MAXITERATIONS,num2str(maxIterations)));
set(handles.sError,'string',strcat(D_ERROR,theobound));
set(handles.pResults,'visible','on');
catch
warning('Please check your inputs');
end

end









function tEquation_Callback(hObject, eventdata, handles)
% hObject    handle to tEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tEquation as text
%        str2double(get(hObject,'String')) returns contents of tEquation as a double


% --- Executes during object creation, after setting all properties.
function tEquation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tGx_Callback(hObject, eventdata, handles)
% hObject    handle to tGx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tGx as text
%        str2double(get(hObject,'String')) returns contents of tGx as a double


% --- Executes during object creation, after setting all properties.
function tGx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tGx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pMethod.
function pMethod_Callback(hObject, eventdata, handles)
% hObject    handle to pMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pMethod
if(get(hObject,'value')==4)
    set(handles.pFixedPoint,'visible','on');
else
    set(handles.pFixedPoint,'visible','off');
end
% --- Executes during object creation, after setting all properties.
function pMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in bStep.
function bStep_Callback(hObject, eventdata, handles)
% hObject    handle to bStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global firstTime;
global lastXr;
global Xr;
global Xu;
global Xl
global iteration;

if(~findRootErrorChecker(handles))
if(firstTime)
    Xl=str2num(get(handles.tStart,'string'));
    Xu=str2num(get(handles.tEnd,'string'));
   
    firstTime=false;
    iteration=1;
end
 Xr=(Xu+Xl)/2;
iteration=iteration+1;
f=get(handles.tEquation,'string');
fx=inline(f);
if fx(Xl)*fx(Xu)>0
    set(handles.sStepData,'string','No Root in the given range');
    return
end
start=str2num(get(handles.tStart,'string'));
endVal=str2num(get(handles.tEnd,'string'));
axes(handles.Axes)
%plot(randn(2,3));%,[Xl Xu]);%,'k');
fplot(sym(f),[Xl Xu],'k')
%fplot(fx);%,[Xl Xu]);%,'k');
grid minor;
hold on;
zoom on;
plot(Xl,fx(Xl),'bo');
plot(Xr,fx(Xr),'r*');
plot(Xu,fx(Xu),'bo');
hold off;
 if(fx(Xl)*fx(Xr) < 0)
         Xu=Xr;
     else
         Xl=Xr;
     end
eps=((Xr-lastXr)/Xr)*100;
axes(handles.Axes);
set(handles.sStepData,'string',strcat('Xr=',num2str(Xr),',','Eps=',num2str(eps),',','Step=',num2str(iteration-1)));
lastXr=Xr;
end


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lastXr;
global firstTime;
lastXr=0;
firstTime=true;
set(handles.sStepData,'string','');
zoom reset;
cla;



function tStart_Callback(hObject, eventdata, handles)
% hObject    handle to tStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tStart as text
%        str2double(get(hObject,'String')) returns contents of tStart as a double


% --- Executes during object creation, after setting all properties.
function tStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tEnd_Callback(hObject, eventdata, handles)
% hObject    handle to tEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tEnd as text
%        str2double(get(hObject,'String')) returns contents of tEnd as a double


% --- Executes during object creation, after setting all properties.
function tEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tNIterations_Callback(hObject, eventdata, handles)
% hObject    handle to tNIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tNIterations as text
%        str2double(get(hObject,'String')) returns contents of tNIterations as a double


% --- Executes during object creation, after setting all properties.
function tNIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tNIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tEpsilon_Callback(hObject, eventdata, handles)
% hObject    handle to tEpsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tEpsilon as text
%        str2double(get(hObject,'String')) returns contents of tEpsilon as a double


% --- Executes during object creation, after setting all properties.
function tEpsilon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tEpsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.txt');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
set(handles.tEquation,'string',read(fullfile(path,file)));


% --- Executes on button press in checkbox.
function checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox
if get(handles.checkbox,'value')==0
        set(handles.Steppanel,'visible','on');
    set(handles.Tables,'visible','off');

else
     set(handles.Steppanel,'visible','off');
    set(handles.Tables,'visible','on');

end
