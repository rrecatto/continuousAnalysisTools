function subjectAnalysis(compiledFileDir)

apath=compiledFileDir;

d=dir(fullfile(apath,'*.compiledTrialRecords.*.mat')); %is this legit?
subStrs={};
for i=1:length(d)
    tmp=textscan(d(i).name,'%[^.].compiledTrialRecords.%d-%d.mat'); %lame that textscan doesn't take cell arrays in, nor works when each line separated by \n, also couldn't find sscanf solution
    subStrs{end+1}=tmp{1}{1};
end

if length(subStrs)<=0
    apath
    d.name
    error('no compiled records found in that directory')
end
subStrs{end+1} = 'all';
fs=[];

typeStrs={'all','performance','trials per day','trial rate','bias','or optimal','or sfSweep','or tfSweep','or ctrSweep','or orSweep'}; %'weight' waiting for resolution of http://132.239.158.177/trac/rlab_hardware/ticket/79
filterTypeIndex=1;
subStrIndex=length(subStrs); % denotes 'all'

oneRowHeight=25;
margin=10;
ddWidth=100;
bWidth=50;

fWidth=4*margin+2*ddWidth+bWidth;
fHeight=margin+oneRowHeight+margin;
f = figure('Visible','off','MenuBar','none','Name','ratrix analysis','NumberTitle','off','Resize','off','Units','pixels','Position',[50 50 fWidth fHeight]);

subM = uicontrol(f,'Style','popupmenu',...
    'String',subStrs,...
    'Enable','on',...
    'Value',subStrIndex,'Units','pixels','Position',[margin margin ddWidth oneRowHeight],'Callback',@subC);
    function subC(source,eventdata)
        subStrIndex=get(subM,'Value');
    end

typeM = uicontrol(f,'Style','popupmenu',...
    'String',typeStrs,...
    'Value',filterTypeIndex,'Units','pixels','Position',[2*margin+ddWidth margin ddWidth oneRowHeight],'Callback',@typeC);
    function typeC(source,eventdata)
        filterTypeIndex=get(typeM,'Value');
    end

plotB=uicontrol(f,'Style','pushbutton','String','plot','Units','pixels','Position',[3*margin+2*ddWidth margin bWidth oneRowHeight],'Callback',@buttonC);
    function buttonC(source,eventdata)
        for i=1:length(fs)
            figure(fs(i))
            close(fs(i));
        end
        sel = calcSelection;
        fs=analysisPlotter(sel,apath,true);
    end

    function sel=calcSelection
        sel.type=typeStrs{filterTypeIndex};
        subID=subStrs{subStrIndex};
        if strcmp(subID,'all')
            [x,y] = getGoodArrangement(subStrIndex-1);
            sel.subjects = cell(1,x,y);
            sel.titles = cell(1,x,y);
            for k = 1:subStrIndex-1
                sel.subjects{k}=subStrs{k};
                sel.titles{k} = ['subject'  subStrs{k}];
            end
        else
            sel.subjects{1,1,1}=subID;
            sel.titles={['subject ' subID]};
        end
        sel.filter='all';
        sel.filterVal = [];
        sel.filterParam = [];
    end

set(f,'Visible','on')
end