function fs=analysisPlotter(selection,compiledFileDir,includeKeyboard)


% if ~isdeployed
% addpath('C:\Documents and Settings\rlab\Desktop\phil analysys');
% end

%compileTrialRecords
origCompiledFileDir=compiledFileDir;

fs=[];
if strcmp(selection.type,'all')
    subIDs = getAllSubjects(selection.subjects);
    toContinue = 1;
    if (length(subIDs)>10)
        toContinue = warnAboutTooManyPlots(length(subIDs));
    end
    if toContinue
        toBePlotted = {'performance','trials per day','bias','trial rate'};
        [numRows numCols] = getArrangement(length(toBePlotted));
        for i = 1:length(subIDs)
            % added 10/3/08 - get compiledFileDir from subID, subject-specific
            if isempty(compiledFileDir)
                conn = dbConn();
                compiledFileDir = getCompilePathBySubject(conn, subIDs{i});
                compiledFileDir = compiledFileDir{1};
                if isempty(compiledFileDir) % no compiled directory in oracle!
                    toBePlotted = {'weight'};
                    [numRows numCols] = getArrangement(length(toBePlotted));
                end
                closeConn(conn);
            end
            % 3/23/09 - moved loading compiledRecord here from doAnalysisPlot so we dont repeat the load 4x
            records=getRecords(compiledFileDir,subIDs{i});
            compiledFileDir=origCompiledFileDir;
            
            fs(end+1) = figure('Name', char(subIDs(i)),'NumberTitle','off');
            subPs = [];
            for j = 1:numRows
                for k = 1:numCols
                    subPs(end+1) = subplot(numRows,numCols,(j-1)*numCols+k);
                    hold on
                    doAnalysisPlot(records, subIDs{i}, char(toBePlotted((j-1)*numCols+k)), selection.filter, selection.filterVal, selection.filterParam,includeKeyboard);
                    title(sprintf('%s - %s: %s',char(toBePlotted((j-1)*numCols+k)), char(subIDs(i)), datestr(now,0)));
                end
            end
            linkaxes([subPs(1),subPs(3)], 'x'); % assumes that the toBePlotteds are the same....
        end
    end
    
%     for i = size(selection.subjects,1)
        
else
    for i=1:size(selection.subjects,1)
        fs(end+1)=figure('Name',[selection.titles{i} '    ' selection.type],'NumberTitle','off');

        if length(size(selection.subjects))==3
            numRows=size(selection.subjects,2);
            numCols=size(selection.subjects,3);
        else
            numRows=1;
            numCols=1;
            if prod(size(selection.subjects))>1
                size(selection.subjects)
                selection.subjects
                error('bad selection.subjects')
            end
        end

        for j=1:numRows
            for k=1:numCols
                if ~isempty(selection.subjects{i,j,k})
                    subplot(numRows,numCols,(j-1)*numCols+k)
                    % added 10/3/08 - get compiledFileDir from subID, subject-specific
                    if isempty(compiledFileDir)
                        conn = dbConn();
                        compiledFileDir = getCompilePathBySubject(conn, selection.subjects{i,j,k});
                        compiledFileDir = compiledFileDir{1};
                        if isempty(compiledFileDir) && ~strcmp(selection.type,'weight')
                            error('cannot plot %s without a compiledFileDir!',selection.type);
                        end
                        closeConn(conn);
                    end
                    % 3/23/09 - moved loading compiledRecord here from doAnalysisPlot so we dont repeat the load 4x
                    records=getRecords(compiledFileDir,selection.subjects{i,j,k});
                    compiledFileDir=origCompiledFileDir;
                    hold on
                    doAnalysisPlot(records,selection.subjects{i,j,k},selection.type, selection.filter, selection.filterVal, selection.filterParam,includeKeyboard);
                    title(gca,sprintf('%s - %s: %s',selection.type,selection.subjects{i,j,k},datestr(now,0)))
                end
            end
        end
    end
end
end


function subIDs = getAllSubjects(subVec)
    subIDs = {};
    for i=1:size(subVec,1)
        for j=1:size(subVec,2)
            for k=1:size(subVec,3)
                if ~isempty(subVec{i,j,k})
                    subIDs{end+1} = subVec{i,j,k};
                end
            end
        end
    end
end

function toContinue = warnAboutTooManyPlots(l)
    display(['you want to plot ' int2str(l) ' plots! are you sure you want to do that??']);
    toContinue = input('continue anyway?1/0');
end

function [l b] = getArrangement(i)
    l = ceil(sqrt(i));
    b = l;
end


function records=getRecords(compiledFileDir,subjectID)

compiledFile=fullfile(compiledFileDir,[subjectID '.compiledTrialRecords.*.mat']);
d=dir(compiledFile);
records=[];
for i=1:length(d)
    if ~d(i).isdir
        [rng num er]=sscanf(d(i).name,[subjectID '.compiledTrialRecords.%d-%d.mat'],2);
        if num~=2
            d(i).name
            er
        else
            fprintf('loading file')
            t=GetSecs();
            ctr=load(fullfile(compiledFileDir,d(i).name));
            fprintf('\ttime elapsed: %g\n',GetSecs-t)
            records=ctr.compiledTrialRecords;
        end
    end
end

end % end function

%
% subjectID='159';
% compiledFile=fullfile(compiledFileDir,[subjectID '.compiledTrialRecords.*.mat']);
% d=dir(compiledFile);
% records=[];
% for i=1:length(d)
%     if ~d(i).isdir
%         [rng num er]=sscanf(d(i).name,[subjectID '.compiledTrialRecords.%d-%d.mat'],2);
%         if num~=2
%             d(i).name
%             er
%         else
%             ctr=load(fullfile(compiledFileDir,d(i).name));
%             records=ctr.compiledTrialRecords;
%         end
%     end
% end
%
% if ~isempty(records)
%     processedRecords.info.subject={subjectID};
%     processedRecords.response=zeros(1,length(records));
%     processedRecords.correctionTrial=zeros(1,length(records));
%     processedRecords.date=zeros(1,length(records));
%     processedRecords.correct=zeros(1,length(records));
%     processedRecords.step=zeros(1,length(records));
%
%     for i=1:length(records)
%         processedRecords.step(i)=length(records(i).stimDetails.orientations);
%         resp=find(records(i).response);
%         if length(resp)~=1 || ischar(records(i).response)
%             processedRecords.response(i)=-1;
%         else
%             processedRecords.response(i)=resp(1);
%         end
%         processedRecords.date(i)=datenum(records(i).date);
%         if ismember('correctionTrial',fields(records(i).stimDetails))
%             processedRecords.correctionTrial(i)=records(i).stimDetails.correctionTrial;
%         else
%             processedRecords.correctionTrial(i)=false;
%         end
%     end
%     processedRecords.correct=[records.correct];
%
%     doPlot('plotTrialsPerDay',processedRecords);
%     figure
%     doPlot('percentCorrect',processedRecords);
%     figure
%     doPlot('plotBias',processedRecords);
%     figure
%     doPlot('plotRatePerDay',processedRecords);
% else
%     d.name
%     error('didn''t find any records')
% end
