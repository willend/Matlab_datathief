function datathief(mode)
% GUI for picking data from graphics

if nargin==0
  datathief('init');
else
  switch mode
   case 'init'
    buildgui;
   case 'load'
    loadimg;
   case 'defineaxis'
    defineaxis;
   case 'getdata'
    getdata;
   case 'cleardata'
    cleardata;
   case 'savedata'
    savedata;
   otherwise
   
    
    display(['Mode ' mode ' is undefined'])
  end
end


function buildgui()
h=findobj('type','figure','tag','DataThief');

if not(isempty(h))
  display('Only one DataThief per Matlab please')
  return
else
  fig=figure('tag','DataThief','position',[20 700 110 200], ...
	     'menubar','none');
  uicontrol('style','pushbutton','string','Load data','position',[15 180 100 20],'callback','datathief(''load'')')
  uicontrol('style','pushbutton','string','Define axis','position',[15 160 100 20],'callback','datathief(''defineaxis'')')
  uicontrol('style','popupmenu','string',{'Linear','Log-X','Log-Y','Log-Log'},'position',[10 140 110 20],'tag','AxType')
  uicontrol('style','popupmenu','string',{'MarkSiz: 6','MarkSiz: 7','MarkSiz: 8','MarkSiz: 9','MarkSiz: 10','MarkSiz: 11','MarkSiz: 12'},...
	    'position',[10 120 110 20],'tag','MarkerSize','value',4)
  uicontrol('style','text','string','Color',...
	    'position',[15 100 55 20])
  uicontrol('style','popupmenu','string',{'r','g','b','c','k','m','y'},...
	    'position',[65 100 55 20],'tag','Pointcolor')
  uicontrol('style','pushbutton','string','Get data','position',[15 80 100 20],'callback','datathief(''getdata'')')
  uicontrol('style','pushbutton','string','Clear data','position',[15 60 100 20],'callback','datathief(''cleardata'')')
  uicontrol('style','pushbutton','string','Save coords','position',[15 20 100 20],'callback','datathief(''savedata'')')
end

function loadimg()
h=findobj('tag','ImgData');
if not(isempty(h))
  display('Data reloading');
  figure(h)
else
  h=figure('tag','ImgData');
end
formats=imformats();
[filename, pathname] = uigetfile({'*.jpg;*.gif;*.png;*.tiff;*.bmp', 'Images (*.jpg, *.gif, *.png, *.tiff;*.bmp)'; ...
        '*.*',                   'All Files (*.*)'}, ...
        'Pick an image');
image = fullfile(pathname,filename);
if not(isempty(image))
  img=imread(image);
  delete(get(h,'children'));
  figure(h);imagesc(img);
  axis off
  ud.image = image;
  ud.img = img;
  ud.imax=gca;
  set(ud.imax,'position',[0 0 1 1])
  ud.axcoords=[];
  ud.figax=[];
  set(h,'userdata',ud)
end

function defineaxis()
h=findobj('tag','ImgData');
if isempty(h) || isempty(get(h,'userdata'))
  display('No data loaded - please load data first')
  return
end
delete(findobj('tag','axismarker'));
figure(h)
ud=get(h,'userdata');
axes(ud.imax);
set(gca,'color','none');
hold on;
display('Click to define axis')
pos=ginput(2);
plot(pos(1,1),pos(1,2),'ro','tag','axismarker','markersize',5+get(findobj('tag','MarkerSize'),'value'));
plot(pos(2,1),pos(2,2),'mo','tag','axismarker','markersize',5+get(findobj('tag','MarkerSize'),'value'));
x0=input('Input Xmin: ');
x1=input('Input Xmax: ');
y0=input('Input Ymin: ');
y1=input('Input Ymax: ');
width=get(ud.imax,'xlim');width=width(2)-width(1);
height=get(ud.imax,'ylim');height=height(2)-height(1);
posi=[min(pos(:,1))/width 1-max(pos(:,2))/height (max(pos(:,1))-min(pos(:,1)))/width (max(pos(:,2))-min(pos(:,2)))/height];
graphax=axes('position',posi);
set(graphax,'tag','GraphAx','color','none')
Scale=get(findobj('tag','AxType'),'value');
set(graphax,'xlim',[x0 x1],'ylim',[y0 y1],'tag','GraphAx');
switch Scale
 case 1
  set(graphax,'xscale','linear','yscale','linear','tag','GraphAx');
 case 2
  set(graphax,'xscale','log','yscale','linear','tag','GraphAx');
 case 3
  set(graphax,'xscale','linear','yscale','log','tag','GraphAx');
 case 4
  set(graphax,'xscale','log','yscale','log','tag','GraphAx');
end

set(graphax,'xtick',[],'ytick',[],'YTickMode','manual','XTickMode','manual','tag','GraphAx');

ud.graphax=graphax;
ud.x=[];
ud.y=[];

set(h,'userdata',ud);

function getdata()
axes(findobj('tag','GraphAx'))
ud=get(gcf,'userdata');
Color=get(findobj('tag','Pointcolor'),'string');
Color=Color{get(findobj('tag','Pointcolor'),'value')};
[x y button]=ginput(1);
if (button == 1)
  ud.x=[ud.x;x];
  ud.y=[ud.y;y];
  [ud.x idx] = sort(ud.x);
  ud.y=ud.y(idx);
  hold on
  plot(x,y,[Color 'o'],'MarkerSize',5+get(findobj('tag','MarkerSize'),'value'),'tag','coords')
  set(gcf,'userdata',ud);
  datathief('getdata');
else
  hold on
  plot(ud.x,ud.y, [Color 'x-'],'MarkerSize',5+get(findobj('tag','MarkerSize'),'value'),'tag','coords')
end

function cleardata()
delete(findobj('tag','coords'))
axes(findobj('tag','GraphAx'))
ud=get(gcf,'userdata');
ud.x=[];
ud.y=[];
set(gcf,'userdata',ud)

function savedata()
axes(findobj('tag','GraphAx'))
ud=get(gcf,'userdata');
[filename, pathname] = uiputfile('*.dat', 'Save coordinates');
datafile=fullfile(pathname,filename);
A=[ud.x ud.y];
save(datafile,'A','-ascii');


% Img=imread('test.jpg');
% image(Img);
% ax0=gca;
% set(ax0,'position',[0 0 1 1])
% ginput(2)