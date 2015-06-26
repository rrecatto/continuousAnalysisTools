classdef neuronDB
    %organize neural data into a database and process it
    
    properties
        dbName
        
        %vectors of length N
        data      % singleUnits
        neuronID
        mode='viewAnalysisOnly'
        
        savePath='\\132.239.158.169\datanetOutput'
        results
        cache
        history
    end
    properties % calc'd
        numNeurons
        numAnalyses
    end
    methods
        function db=neuronDB(which)
            
            if ~exist('which','var')
                which=db.dbName;
            elseif iscell(which)
                mode = which{2};
                which = which{1};
                db.dbName = which;
            else
                db.dbName=which;
            end
            
            switch which
                case 'pmmNeurons'
                    db.savePath='C:\Documents and Settings\rlab\Desktop\neuralDBs'
                    db=db.load('pmmNeurons_20110218T191538') %  22 semi-flushed, all good
                    %db=db.addMorePmmNeurons(0);
                case 'cosyne2011'
                    db = db.load('merge_20110219T224107');
                    %                     error('not yet')
                case 'active'
                    error('none yet')
                case 'bsNeurons'
                    db = db.initBS({mode});
                case 'bsPaper1'
                    db = makeDBForPaper1(db,mode);
                case 'bsPaper2'
                    db = makeDBForPaper2(db,mode);
                    
                    
                otherwise
                    which
                    error('unknown db')
            end
        end
        function db=main(db)
            
            db.displayAnalysis
            %db.plotGrid('isi')
            
            %             db.mode='onlyInspectInteractive';  %{'overwriteAll','onlyAnalyze','viewAnalysisOnly','onlyDetect','onlySort','onlyDetectAndSort','onlyInspect','onlyInspectInteractive'}
            %             db=db.process([5]) %
            %             db=db.process([2]) % whats wrong with #2?
            %
            %             keyboard
            db.mode='onlyDetectAndSort';  %{'overwriteAll','onlyAnalyze','viewAnalysisOnly','onlyDetect','onlySort','onlyDetectAndSort','onlyInspect','onlyInspectInteractive'}
            db=db.process([2 5])
            
            %db.mode='onlyDetect';  %{'overwriteAll','onlyAnalyze','viewAnalysisOnly','onlyDetect','onlySort','onlyDetectAndSort','onlyInspect','onlyInspectInteractive'}
            %db=db.process('all');    %('lastAnalysis','lastNeuron','all')  or uint8([5 7])
            
            eval('help neuronDB.toDoList')
        end
        function toDoList(db)
            %toDO here:
            % - test flanker plotting on first cell
            % -analyze all
            % -glm: gwn,gs,spikes,lfpPower
            %   -1 samp per frame (commit)
            %   -5 samp per frame?()
            %
            % -db.logfile2DB(ratIDs)  %automate whats manual
            % -db.guessReasonableInclusion()
            % -db.plotByType(Inf,'ffgwn')
            %
            %toDo in analysis
            % -analysis.plot
            % -[structure]=analysis.getProperties({'STA','STA-SNR'})
            % -[vector]=analysis.getProperty('STA'})
        end
        
        %% heavy lifting
        
        function db = mergeDBs(db1,db2,name)
            if ~exist('db2','var')||~isa(db2,'neuronDB')
                error('need two neuronDBs')
            end
            if ~exist('name','var')||isempty(name)
                neuron = 'mergedDB';
            end
            db = db1;
            numNeuronsInDB1 = max(db.neuronID);
            for i = 1:length(db2.data)
                db.data{end+1} = db2.data{i};
                db.neuronID(end+1) = db2.neuronID(i)+numNeuronsInDB1;
            end
            db.savePath = db1.savePath;
            db.dbName = name;
            
        end
        %% getters & setters
        function out=get.numNeurons(db)
            out=length(db.neuronID);
        end
        function out=get.numAnalyses(db)
            x=getFlatFacts(db,{'included'});
            out=length(x.included);
        end
        function db=set.dbName(db,in)
            if ~ischar(in)
                error('must be a char')
            else
                db.dbName=in;
            end
        end
        function db=set.mode(db,in)
            if isempty(in)
                in='viewAnalysisOnly';
            end
            acceptable={'overwriteAll','onlyAnalyze','viewAnalysisOnly','onlyDetect','onlySort','onlyDetectAndSort','onlyInspect','onlyInspectInteractive'};
            if ~ismember(in,acceptable)
                error('must be one of: overwriteAll, onlyAnalyze, viewAnalysisOnly, onlyDetect, onlySort, onlyDetectAndSort, onlyInspect, onlyInspectInteractive')
            else
                db.mode=in;
            end
        end
        
        %% utils
        function db=registerAction(db,action,params)
            if ~exist('params','var')
                params=[];
            end
            if isempty(db.history)
                %generalInit;
                db.history.action={};
                db.history.date=[];
                db.history.params={};
            end
            db.history.action{end+1}=action;
            db.history.date{end+1}=now;
            db.history.params{end+1}=params;
            %db.save;
        end
        function db = flushHistory(db)
            db.history = [];
        end
        function save(db,name)
            if ~exist('name','var')||isempty(name)
                name = sprintf('%s_%s',db.dbName,datestr(now,30));
            else
                % name = name;
            end
            
            if IsLinux
                loc=fullfile(recordsPathLUT(db.savePath,'Win2Lx'),name)
                save(loc,'db');
            else
                saved=0;
                count=0
                while ~saved
                    count=count+1;
                    try
                        
                        loc=fullfile(db.savePath,name)
                        save('-v7.3',loc,'db');
                        saved=1;
                    catch
                        warning('failed a save! trying again')
                        pause(1)
                    end
                    if count>5
                        error('failed to save!')
                    end
                end
            end
        end
        function db=changeSavePath(db,in)
            if ischar(in)
                db.savePath = in;
            end
        end
        function db=load(db,fileName)
            if IsLinux
                recordPath = recordsPathLUT(db.savePath,'Win2Lx');
                d = dir(recordPath);
                d = d(~ismember({d.name},{'.','..'}));
                if isempty(d)
                    % mount the recordpath
                    success = ensureRecordPathIsMounted(recordPath);
                    if ~success
                        error('unable to mount the recordPath');
                    end
                end
                load(fullfile(recordPath,fileName));
            else
                load(fullfile(db.savePath,fileName));
            end
        end
        function db=addUniqueStepNamesToScratchPad(db,IDs)
            if ~exist('IDs','var')
                IDs=1:db.numNeurons;
            end
            for i=IDs
                fprintf('.\n%d - ',i)
                db.data{i}=db.data{i}.addUniqueStepNamesToScratchPad;
            end
        end
        
        
        %% not currently used code
        function db=includeAll(db)
            error('old code')
            db.included(:)=true;
        end
        function out=getSingleUnitProperties(db,properties)
            properties={'TF','SF'};
            
            neuronIDs=unique(db.neuronID);
            numNeurons=length(neuronIDs);
            numProperties=length(properties);
            for i=1:numNeurons
                for j=1:numProperties
                    switch properties{j}
                        case 'special'
                            error('not written')
                            %out.(properties{j})(i)=calculateSpecial()
                        otherwise
                            %generic
                            out.(properties{j})(i)=db.data{i}.getProperty(properties{j})
                    end
                end
            end
        end
        function displayAnalysis(db)
            x=getFlatFacts(db,{'analysisType','quality','included'});
            [aInd nID subAInd]=selectIndexTool(db,'all');
            for i=1:db.numAnalyses
                fprintf('\t%d\t%d\t%d\t%s\n',nID(i),x.included(i), x.quality(i),x.analysisType{i});
            end
        end
        function oldPseudoCode(db)
            %             db=db.logfile2DB('231')
            %             db=db.guessReasonableInclusion('priotitizeTRF')
            %             special=[78 96];
            %             db.included(special)=true;
            %             db.detect
            %             db.save
            %
            %             which=ismember(db.dataType,'trf')
            %             for i=find(which)
            %
            %             end
            %
            %             which=(db.quality>4 && d.neuronID==5 && db.hasEye)
            %             isiFacts(which)
        end
        
        %% dispalys
        function tabulate(db)
            fprintf('\n');
            fprintf('neuronID\tsubjectID\ttrials\n');
            fprintf('=====================================================\n');
            for i = 1:db.numNeurons
                fprintf('%d\t\t\t%s\t\t\t',i,db.data{i}.subject)
                tr = db.data{i}.getAllTrials;
                for j = 1:length(tr)
                    fprintf('%d ',tr(j));
                end
                fprintf('\n')
            end
        end
    end
end
