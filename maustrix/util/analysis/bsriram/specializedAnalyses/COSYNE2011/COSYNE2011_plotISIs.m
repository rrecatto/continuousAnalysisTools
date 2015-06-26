function COSYNE2011_plotISIs

%% neuron db
db = neuronDB('cosyne2011');

f = figure;ax=axes;hold on;
[aInd nInd subAInd] = db.selectIndexTool('all');

whichBad = nInd==40&subAInd==1;
aInd = aInd(~whichBad);
nInd = nInd(~whichBad);
subAInd = subAInd(~whichBad);
anesth = nan(size(aInd));
rate = nan(size(aInd));
rateCI = nan(size(aInd));
type = cell(size(aInd));
n=1;
for i = 1:length(aInd)
%     if any(i==[116:119 141:145])
%         continue
%     end
    fprintf('%d/%d\n',i,length(aInd));
    anesth(i) = getAnesthesia(db.data{nInd(i)}.analyses{subAInd(i)});
    if isnan(anesth(i)), anesth(i)=2.0; end % phil's stuff is anesth
%     isi = getProperties(db.data{nInd(i)}.analyses{subAInd(i)},{'ISI'});
%     isi = isi{1};
%     [count posns] = hist(log10(isi),300);
%     count = count/sum(count); % normalize things.
%     y = [makerow(posns),fliplr(makerow(posns))]';
%     x = n*ones(2*length(posns),1);
%     z = [count,zeros(1,length(posns))]';
% %     if i==116
% %         keyboard
% %     end
%     if anesth(i)
%     f = fill3(x,y,z,'r');set(f,'FaceAlpha',0.2,'EdgeAlpha',0.1);
%     else
%         f = fill3(x,y,z,'b');set(f,'FaceAlpha',0.2,'EdgeAlpha',0.1);
%     end
%     drawnow;
    n=n+1;
    type{i} = getType(db.data{nInd(i)}.analyses{subAInd(i)});
end
anesth(isnan(anesth))=2.0; % phil's stuff is anesth
whichAnesth = (anesth>0);
whichAwake = (anesth==0);
%%
n=1;
anesthCol = 'r';
awkCol = 'b';
% flush out the crappy types
crappyType = type;
type = {};
for i = 1:length(crappyType)
    if ischar(crappyType{i})
        type{end+1} = crappyType{i};
    end
end

uniqueType = unique(type);

% awkRateAll = rate(whichAwake);
% anesRateAll = rate(whichAnesth);
% plot(find(whichAwake),awkRateAll,'Marker','.','LineStyle','none','color',awkCol);
% plot(find(whichAnesth),anesRateAll,'Marker','*','LineStyle','none','color',anesthCol);
% set(gca,'XTick',[],'YTick',[0 max(rate)],'YTickLabel',{'',sprintf('%2.1f',max(rate))})
% axis ([0 length(rate) 0 1.1*max(rate)])
for i = 1:length(uniqueType)
    currType = uniqueType{i};
    whichAllAnalyses = find(ismember(type,currType));
    currAInd = aInd(whichAllAnalyses);
    currAnesth = anesth(whichAllAnalyses);
    currNInd = nInd(whichAllAnalyses);
    currSubAInd = subAInd(whichAllAnalyses);
    f = figure; ax = axes;hold on;n=1;
    title(currType);
    axis([0 length(currAInd)+1 -4 2 0 0.025]);
    set(ax,'YTick',[-4 0 2],'ZTick',[]);
    
    for i = 1:length(currAInd)
        if any(i==[500])
            continue
        end
        fprintf('%d/%d ',i,length(currAInd));
        %     anesth(i) = getAnesthesia(db.data{currNInd(i)}.analyses{currSubAInd(i)});
        %     if isnan(anesth(i)), anesth(i)=2.0; end % phil's stuff is anesth
        isi = getProperties(db.data{nInd(i)}.analyses{subAInd(i)},{'ISI'});
        isi = isi{1};
        [count posns] = hist(log10(isi),300);
        count = count/sum(count); % normalize things.
        y = [makerow(posns),fliplr(makerow(posns))]';
        x = n*ones(2*length(posns),1);
        z = [count,zeros(1,length(posns))]';
        %     if i==116
        %         keyboard
        %     end
        if currAnesth(i)
            f = fill3(x,y,z,'r');set(f,'FaceAlpha',0.2,'EdgeAlpha',0.1);
        else
            f = fill3(x,y,z,'b');set(f,'FaceAlpha',0.2,'EdgeAlpha',0.1);
        end
        drawnow;
        n=n+1;
    end
    
end