function compileTrialRecords(server_name,fieldNames,recompile,subjectIDs,source,destination)
%
% example: automatic compiling (servers do this; humans don't unless the can confirm no-collisions possible)
% compileTrialRecords(rackNum)
%
% example: a rare manual rebuilding; making a temporary back-up is suggested before this
% compileTrialRecords(rackNum,fieldNames,recompile=1)
%
% example: to compile a subset of the information for a specific, non-supported analysis
%compileTrialRecords(rackNum,{'totalFrames',{'responseDetails','totalFrames'}; 'numMisses',{'responseDetails','numMisses'}},1,{'229'},getSubDirForRack(rackNum),'C:\Documents and Settings\rlab\Desktop\test')
%compileTrialRecords(rackNum,[],1,{'233'},getSubDirForRack(rackNum),'C:\Documents and Settings\rlab\Desktop\test')

%example: recompile everything to a temp directory without interupting ongoing analysis, etc
%(then rapidly manually transfer files and svn update the servers compileTrialRecords)
%compileTrialRecords(rackNum,[],1,[],getSubDirForRack(rackNum),'C:\Documents and Settings\rlab\Desktop\test')

%compile enhanced files for rack 1
%compileTrialRecords([],fieldNames,false,{'138','139','227','228','231','232','229','230','233','234','237','274','278'},getSubDirForRack(1),getCompiledDirForRack(-1))

% if ~exist('subjectIDs','var') || isempty(subjectIDs)
%     subjectIDs='all';
% end

% =============================
% this field (subjectIDs) needs to be given now b/c this is retreived from ratrix object that we don't have access to here
% if ~exist('subjectIDs','var') || isempty(subjectIDs)
%     subjectIDs='all'; 
% end
% =============================

if (~exist('server_name','var') || isempty(server_name)) && (~exist('subjectIDs','var') || isempty(subjectIDs)) ...
        && (~exist('source','var') || isempty(source))
    error('we need a server_name to know which subjects to compile, or need a list of subjectIDs passed in, or at least a source to look in')
end

% =============================
% REMOVE THIS PART - superceded by subject-specific paths
% if ~exist('source', 'var') || isempty(source)
%     subjectDirectory=getSubDirForServer(server_name); % probably not used - overriden by subject-specific paths
% else
%     subjectDirectory=source;    
% end
% =============================



% compiledRecordsDirectory

if ~exist('recompile','var') || isempty(recompile)
    recompile = false;
end

if ~exist('fieldNames','var') || isempty(fieldNames)
    fieldNames={'trialNumber',{''};...
        'date',{''};...
        'response',{''};...
        'correct',{''};...
        ...%'trialManagerClass',... %removed b/c biggish
        ...%'stimManagerClass',...
        ...%'stimDetails',...
        'step',{''};...
        'correctionTrial',{'stimDetails','correctionTrial'};...  odd one b/c its still in stim details now
        'maxCorrectForceSwitch',{'stimDetails','maxCorrectForceSwitch'};... odd one b/c its still in stim details now
        'responseTime',{''};...
        'actualRewardDuration',{'actualRewardDuration'};...
        'manualVersion',{'protocolVersion','manualVersion'};...
        'autoVersion',{'protocolVersion','autoVersion'};...
        'didStochasticResponse',{'didStochasticResponse'};...
        'containedForcedRewards',{'containedForcedRewards'};...
        'didHumanResponse',{'didHumanResponse'};...
        ...%pmm  fields...
        'correctResponseIsLeft',{'stimDetails','correctResponseIsLeft'};...
        'targetContrast',{'stimDetails','targetContrast'};...
        'targetOrientation',{'stimDetails','targetOrientation'};...
        'flankerContrast',{'stimDetails','flankerContrast'};...
        'flankerOrientation',{''};...
        'deviation',{'stimDetails','deviation'};...
        ...'devPix',{'stimDetails','devPix'};... removed b/c 2D: xpix & yPix, pmm 080603
        'targetPhase',{'stimDetails','targetPhase'};...
        'flankerPhase',{'stimDetails','flankerPhase'};...
        'currentShapedValue',{'stimDetails','currentShapedValue'};...
        'pixPerCycs',{'stimDetails','pixPerCycs'};...
        'redLUT',{'stimDetails','redLUT'};...
        'stdGaussMask',{'stimDetails','stdGaussMask'};...
        'flankerPosAngle',{'stimDetails','flankerPosAngle'};...
        };
        %'numRequestLicks',{''};...
        %'firstILI',{''};...
        
    %'stimDetails'};  can't fit 200,000 trials worth of these, out of MEMORY
    %pmm recommends switching on class, call method to find out which fields to add in
    %temporary solution: add fields only if they exist and are defined for that trial, NaNs elsewhere 080424
    %final resolution: http://132.239.158.177/trac/rlab_hardware/ticket/11
    
    
    %THESE ARE ALL GENERAL FIELDS WHICH COULD BE ADDED B/C ALL RECORDS HAVE THEM
    %     'totalFrames',{'responseDetails','totalFrames'};
    %     'startTime',{'responseDetails','startTime'};
    %     'numMisses',{'responseDetails','numMisses'};
    %    proposedSizeULorMS',
    %proposedMsPenalty
    %numRequestLicks
    %firstILI
    %autoVersion     protocolVersion.autoVersion
else
    %force the addition of required fields
    fieldNames{end+1,1}='trialNumber';
    fieldNames{end,2}={''};
    fieldNames{end+1,1}='date';
    fieldNames{end,2}={''};
end



storageMethod='vector'; %'structArray'

%loading structArray or cell is 100x slower than vector of same size!!!
% n=3;
% d=10000;
% x=rand(n,d);
% tic;save('test.mat','x');toc
% tic;load('test.mat');toc
%
% b=num2cell(x,1);
% all(all(x==[b{:}]))
% tic;save('test.mat','b');toc
% tic;load('test.mat');toc
%
% a=struct('x',b);
% all(all(x==[a.x]))
% tic;save('test.mat','a');toc
% tic;load('test.mat');toc





% 
% d=dir(subjectDirectory); %unreliable if remote (this function doesn't want to rely on oracle, and it is low-impact to miss some subjects)
% d=d([d.isdir] & ~ismember({d.name},{'.','..'}));
% 
% if strcmp(subjectIDs, 'all')
%     %use all of them
%     else
%     %usefull if you want to process one subject, not all of them
%     which=ismember({d.name},subjectIDs)
%     d=d(which)
%     if any(~ismember(subjectIDs,{d.name}))
%         subjectIDs
%         {d.name}
%         error('didn''t recognize all those subject names')
%     end
% end
% 
% for i=1:length(d)
%         [subjectFiles{end+1} ranges{end+1}]=getTrialRecordFiles(fullfile(subjectDirectory,d(i).name)); %unreliable if remote
%         names{end+1}=d(i).name;
% end

% REPLACE WITH SUBJECT-SPECIFIC
% get subjectIDs based on the server_name - ignore this other crap
names={};
subjectFiles={};
ranges={};

if ~exist('subjectIDs','var') || isempty(subjectIDs) % if subjectIDs not given as input, retrieve from oracle or from source
    % get from oracle if server_name is provided
    if exist('server_name','var') && ~isempty(server_name)
        conn = dbConn();
        subjectIDs = getSubjectIDsFromServer(conn, server_name);
        closeConn(conn);
        if isempty(subjectIDs)
            error('could not find any subjects for this server: %s', server_name);
        end
    elseif exist('source','var') && ~isempty(source)
        % get from source directory (no server_name provided)
        d=dir(source);
        subjectIDs={};
        for i=1:length(d)
            if d(i).isdir
                subjectIDs{end+1} = d(i).name;
            end
        end
    else
        error('should not be here - must either have a server_name or a source if no subjectIDs are given');
    end
end

% now for each subject, retrieve the trialRecords
for k=1:length(subjectIDs)

    names{end+1} = subjectIDs{k}; % why this is repeated i dont know
    % if we have standAlonePath, don't overwrite it!
    if ~exist('source','var') || isempty(source)
            conn = dbConn();
        store_path = getPermanentStorePathBySubject(conn, subjectIDs{k});
        store_path = store_path{1}; % b/c this gets returned by the query as a 1x1 cell array holding the char array
            closeConn(conn);
    else
        store_path = fullfile(source, subjectIDs{k});
%         source
    end
    [subjectFiles{end+1} ranges{end+1}] = getTrialRecordFiles(store_path);

end

% ====================================================================================================
% subjectFiles
% size(subjectFiles)
% subjectIDs
% names
% conn=dbConn();
% for i=1:length(subjectFiles)
%     compiledRecordsDirectory=getCompilePathBySubject(conn, names{i})
% end
% closeConn(conn);
% error('stop here');

for i=1:length(subjectFiles)
    % 10/3/08 - subject specific compile paths
    if ~exist('destination', 'var') || isempty(destination)
        conn=dbConn();
        compiledRecordsDirectory=getCompilePathBySubject(conn, names{i});
        compiledRecordsDirectory = compiledRecordsDirectory{1};
        closeConn(conn);
    else
        compiledRecordsDirectory=destination;    
    end

    d=dir(fullfile(compiledRecordsDirectory,[names{i} '.compiledTrialRecords.*.mat'])); %unreliable if remote
    compiledFile=[];
    compiledRange=zeros(2,1);
    for k=1:length(d)
        done=false;
        if ~d(k).isdir
            [rng num er]=sscanf(d(k).name,[names{i} '.compiledTrialRecords.%d-%d.mat'],2);
            if num~=2
                d(k).name
                er
                error('couldnt parse')
            else
                %d(k).name
                if ~done
                    compiledFile=fullfile(compiledRecordsDirectory,d(k).name);
                    if ~recompile
                        compiledRange=rng;
                        done=true;
                    end
                else
                    d.name
                    error('found multiple compiledTrialRecord files')
                end
            end
        else
            d(k).name
            error('bad dir name')
        end
    end

    compiledTrialRecords=[];
    needToAdd=false;
    for j=1:length(subjectFiles{i})
        %         ranges{i}(:,j)
        %         needToAdd
        if ranges{i}(1,j)==compiledRange(2,end)+1
            if ~needToAdd && ~isempty(compiledFile)
                %load them
                % 12/9/08 - compile keeps producing corrupt files - for now, just skip corrupt files and email fan
                % should be fixed by going to new architecture on trunk
                goodLoad = false;
                numTries = 1;
                while ~goodLoad && numTries<=5
                    try
                        compiledTrialRecords=loadCompiledTrialRecords(compiledFile,compiledRange,{fieldNames{:,1}});
                        goodLoad = true;
                    catch ex 
                        disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
                        
                        dispStr=sprintf('failed to load compiledTrialRecord for subject %s',names{i});
                        disp(dispStr);
                        dispStr=sprintf('Retry #%d...',numTries);
                        disp(dispStr);
                        numTries=numTries+1;
                        goodLoad = false;
                    end
                end
                % if after 5 retries, still unsuccessful, email fan and skip to next subject
                if ~goodLoad
                    dispStr=sprintf('could not load compiledTrialRecord for subject %s after %d tries...skipping',names{i},numTries);
                    disp(dispStr);
                    setpref('Internet','SMTP_Server','smtp.ucsd.edu')
                    setpref('Internet','E_mail','ratrix@ucsd.edu')
                    emailStr=sprintf('RATRIX: Corrupt compiledRecords subject %s', names{i});
                    % in older version of PTB, the ptb sendmail function
                    % supercedes the matlab i/o sendmail function, which is
                    % why we need to cd to correct path
                    % the PTB function sucks - hardcoded!
                    oldDir=pwd;
                    cd([matlabroot filesep 'toolbox' filesep 'matlab' filesep 'iofun' filesep ]);
                    sendmail('fanli.ucsd@gmail.com',emailStr,'See title');
                    cd(oldDir);
                    continue;
                end

            end
            needToAdd=true;
            compiledRange(:,end+1)=ranges{i}(:,j);
            tr=load(subjectFiles{i}{j});
            newTrialRecs=tr.trialRecords;
            if ~all([newTrialRecs.trialNumber]==ranges{i}(1,j):ranges{i}(2,j))
                subjectFiles{i}{j}
                ranges{i}(:,j)
                error('found trial record file with incorrect trial numbers')
            else
                fprintf('doing subject: %s, range: %d-%d, fields: {',names{i},ranges{i}(1,j),ranges{i}(2,j))



                %factor out trial range check
                theseTrials=int32([1:length(newTrialRecs)]);
                shouldBe=ranges{i}(1,j)+theseTrials-1 <= ranges{i}(2,j);
                if ~all(shouldBe)
                    shouldBe
                    ranges{i}(1,j)
                    ranges{i}(2,j)
                    error('should never happen that the range is larger than start plus length')
                end


                for m=1:size(fieldNames,1)
                    switch storageMethod
                        case 'structArray'
                            [compiledTrialRecords(ranges{i}(1,j):ranges{i}(2,j)).(fieldNames{m,1})]=newTrialRecs.(fieldNames{m,1});
                        case 'vector'

                            switch fieldNames{m,1}
                                case {'trialNumber','correct'}
                                    compiledTrialRecords.(fieldNames{m,1})(ranges{i}(1,j):ranges{i}(2,j))=[newTrialRecs.(fieldNames{m,1})];
                                case 'date'
                                    compiledTrialRecords.date(ranges{i}(1,j):ranges{i}(2,j))=datenum(reshape([newTrialRecs.date],6,length(newTrialRecs))');

                                case 'response'
                                    compiledTrialRecords.response(ranges{i}(1,j):ranges{i}(2,j))=-1;
                                    for tr=1:length(newTrialRecs)
                                        resp=find(newTrialRecs(tr).response);
                                        if  length(resp)==1 && ~ischar(newTrialRecs(tr).response)
                                            compiledTrialRecords.response(ranges{i}(1,j)+tr-1)=resp;
                                        end
                                    end

                                case 'step'
                                    compiledTrialRecords.step(ranges{i}(1,j):ranges{i}(2,j))=[newTrialRecs.trainingStepNum];

                                case 'correctionTrial'
                                    compiledTrialRecords.correctionTrial(ranges{i}(1,j):ranges{i}(2,j))=false;
                                    for tr=1:length(newTrialRecs)
                                        if ismember('correctionTrial',fields(newTrialRecs(tr).stimDetails))
                                            compiledTrialRecords.correctionTrial(ranges{i}(1,j)+tr-1)=newTrialRecs(tr).stimDetails.correctionTrial;
                                        end
                                    end

                                case 'responseTime'
                                    compiledTrialRecords.responseTime(ranges{i}(1,j):ranges{i}(2,j))=-1;
                                    %only choose the end value of the lick times
                                    for tr=1:length(newTrialRecs)
                                        if ismember('responseDetails',fields(newTrialRecs(tr))) && ismember('times',fields(newTrialRecs(tr).responseDetails)) && ~isempty(newTrialRecs(tr).responseDetails.times) && isa(newTrialRecs(tr).responseDetails.times,'cell')% if the field exists and isn't empty and (overkill check) is also a cell
                                            compiledTrialRecords.responseTime(ranges{i}(1,j)+tr-1)=newTrialRecs(tr).responseDetails.times{end};
                                        end
                                    end

                                case 'flankerOrientation'
                                    compiledTrialRecords.flankerOrientation(ranges{i}(1,j):ranges{i}(2,j))=nan;
                                    %some old managers had more than one orientation
                                    for tr=1:length(newTrialRecs)
                                        if ismember('stimDetails',fields(newTrialRecs(tr))) && ismember('flankerOrientation',fields(newTrialRecs(tr).stimDetails)) && ~isempty(newTrialRecs(tr).stimDetails.flankerOrientation)% if the field exists
                                            compiledTrialRecords.flankerOrientation(ranges{i}(1,j)+tr-1)=newTrialRecs(tr).stimDetails.flankerOrientation(1);
                                        end
                                    end

                                case 'flankerPosAngle'
                                    compiledTrialRecords.flankerPosAngle(ranges{i}(1,j):ranges{i}(2,j))=nan;
                                    %use the first flankerPosAngle
                                    for tr=1:length(newTrialRecs)
                                        if ismember('stimDetails',fields(newTrialRecs(tr))) && ismember('flankerPosAngles',fields(newTrialRecs(tr).stimDetails)) && ~isempty(newTrialRecs(tr).stimDetails.flankerPosAngles)% if the field exists
                                            compiledTrialRecords.flankerPosAngle(ranges{i}(1,j)+tr-1)=newTrialRecs(tr).stimDetails.flankerPosAngles(1);
                                        end
                                    end
                                case 'numRequestLicks'
                                    compiledTrialRecords.numRequestLicks(ranges{i}(1,j):ranges{i}(2,j))=nan;
                                    %use size of the number of tries
                                    for tr=1:length(newTrialRecs)
                                        if ismember('responseDetails',fields(newTrialRecs(tr))) && ismember('tries',fields(newTrialRecs(tr).responseDetails)) && ~isempty(newTrialRecs(tr).responseDetails.tries)% if the field exists
                                            compiledTrialRecords.numRequestLicks(ranges{i}(1,j)+tr-1)=size(newTrialRecs(tr).responseDetails.tries,2)-1;
                                        end
                                    end
                               case 'firstILI'
                                   compiledTrialRecords.firstILI(ranges{i}(1,j):ranges{i}(2,j))=nan;
                                   %use the difference between the first two lick times if both there
                                   for tr=1:length(newTrialRecs)
                                       if ismember('responseDetails',fields(newTrialRecs(tr))) && ismember('times',fields(newTrialRecs(tr).responseDetails)) && ~isempty(newTrialRecs(tr).responseDetails.times) && size(newTrialRecs(tr).responseDetails.times,2)-1>=2;% if the field exists
                                           compiledTrialRecords.numRequestLicks(ranges{i}(1,j)+tr-1)=diff(cell2mat(newTrialRecs(tr).responseDetails.times(1:2)));
                                       end
                                   end
                                case 'devPix' %devPix has and X and Y now
                                    error('not used')
                                case 'redLUT'
                                    compiledTrialRecords.redLUT(ranges{i}(1,j):ranges{i}(2,j))=nan;
                                    %only a single val from the LUT
                                    for tr=1:length(newTrialRecs)
                                        if ismember('stimDetails',fields(newTrialRecs(tr))) && ismember('LUT',fields(newTrialRecs(tr).stimDetails)) && ~isempty(newTrialRecs(tr).stimDetails.LUT)% if the field exists
                                                compiledTrialRecords.redLUT(ranges{i}(1,j)+tr-1)=newTrialRecs(tr).stimDetails.LUT(end,1);
                                        end
                                    end

                                case {'maxCorrectForceSwitch','actualRewardDuration', 'manualVersion','autoVersion','didStochasticResponse','containedForcedRewards', 'didHumanResponse',...
                                        'totalFrames', 'startTime', 'numMisses',...
                                        'correctResponseIsLeft', 'targetContrast','targetOrientation', 'flankerContrast',...
                                        'deviation','targetPhase','flankerPhase','currentShapedValue','pixPerCycs','stdGaussMask','xPosNoisePix'}

                                    for tr=1:length(newTrialRecs)
                                        compiledTrialRecords.(fieldNames{m,1})(ranges{i}(1,j)+tr-1)=isThereAndNotEmpty(newTrialRecs(tr),fieldNames{m,2});
                                    end

                                otherwise

                                    error(sprintf('no converter for field: %s',fieldNames{m,1}))
                            end

                        otherwise
                            storageMethod
                            error('unrecognized storage method')
                    end
                    fprintf('%s ',fieldNames{m,1})
                end
                fprintf('}\n');
            end
            for m=1:length(newTrialRecs)
                if length(newTrialRecs(m).subjectsInBox)~=1
                    error('expected one subject')
                end
                if ~ismember(names{i},newTrialRecs(m).subjectsInBox)
                    %enable backcompatible checks too
                    subchar=char(newTrialRecs(m).subjectsInBox);
                    isDigit = isstrprop(subchar, 'digit');
                    if length(isDigit)==7 && sum(isDigit)==3
                        thisSubject={subchar(isDigit)}; %all rats named 'rat_###' will be switched to '###'
                    else
                        thisSubject=newTrialRecs(m).subjectsInBox;
                        class(newTrialRecs(m).subjectsInBox)
                    end
                    if ~ismember(names{i},thisSubject)
                        thisSubject
                        names{i}
                        error('bad subject')
                    end
                end
            end
        elseif needToAdd || any(ranges{i}(:,j)>compiledRange(2,end))
            compiledFile
            ranges{i}
            subjectFiles{i}
            compiledRange
            ranges{i}(:,j)
            error('trial record files appear to not be consecutive')
        end
    end

    if ~isempty(compiledTrialRecords) && needToAdd
        if ~isempty(compiledFile)
            delete(compiledFile);
        end

        if any([compiledTrialRecords.trialNumber]~= 1:length([compiledTrialRecords.trialNumber]))
            length(compiledTrialRecords)
            compiledTrialRecords
            error('didn''t wind up with correct trial numbers')
        end

        dts=[compiledTrialRecords.date];
        if any(diff(dts)<0)
            warning('dates aren''t monotonic increasing for subject %s',names{i});
            %             figure
            %             plot(dts)
            %             hold on
            %             prob=find(diff(dts)<0);
            %             plot(prob,dts(prob),'rx')
            %             text(prob+.05*length(dts),dts(prob),datestr(dts(prob)))
            %             title(sprintf('dates aren''t monotonic increasing for subject %s',names{i}))
        end

        %         for m=2:length(compiledTrialRecords)
        %             if datenum(compiledTrialRecords(m).date)<=datenum(compiledTrialRecords(m-1).date)
        %                 m
        %
        %                 compiledTrialRecords(m-1).date
        %                 compiledTrialRecords(m-1).trialNumber
        %
        %                 compiledTrialRecords(m).date
        %                 compiledTrialRecords(m).trialNumber
        %
        %                 dofig=true
        %                 if dofig
        %                     blargh=zeros(1,length(compiledTrialRecords));
        %                     for blar=1:length(compiledTrialRecords)
        %                         blargh(blar)=datenum(compiledTrialRecords(blar).date);
        %                     end
        %
        %                     figure
        %                     plot(blargh)
        %                 end
        %                 warning('dates aren''t monotonic increasing')
        %             end
        %         end

        lo=min([compiledTrialRecords.trialNumber]);
        hi=max([compiledTrialRecords.trialNumber]);
        save(fullfile(compiledRecordsDirectory,[names{i} '.compiledTrialRecords.' num2str(lo) '-' num2str(hi) '.mat']),'compiledTrialRecords');
        fprintf('done with %s\n\n',names{i})
    else
        fprintf('nothing to do for %s\n\n',names{i})
    end
end
    







function [value]=isThereAndNotEmpty(trial,fieldPath)
%only works for doubles or things that cast into doubles
%gets the value from the trial at the field path; if empty or not there returns NaN
%  compiledTrialRecords.(fieldNames{m
%  ,1})(ranges{i}(1,j)+tr-1)=isThereAndNotEmpty(newTrialRecs(tr),fieldNames{m,2});


part=trial;
for i=1:length(fieldPath)
    if ismember(fieldPath(i),fields(part))
        part=part.(fieldPath{i});
    else
        value=NaN;
        return
    end
end

if ~isempty(part)
    value=double(part); %
else
    value=NaN; %emptys don't fit in vectors
end

if ~all(size(value)==1)
    trial
    fieldPath
    value
    error('method only made for single values')
end



