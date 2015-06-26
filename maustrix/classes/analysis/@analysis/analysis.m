classdef analysis
    properties 
        subject
        trials
        dataPath = '\\132.239.158.169\datanetOutput\';
        sourceFolder
        timeOfCreation = datestr(now);
        comments = {};
    end
    properties (Access= private)
        data = [];
    end

    methods
        %% constructor 
        function s = analysis(subject,trials,varargin)
            switch nargin
                case 2
                    if ischar(subject)
                        s.subject = subject;
                    else
                        error('analysis:wrongInputType','subject should always be char');
                    end
                    
                    if isnumeric(trials)
                        s.trials = trials;
                    else
                        error('analysis:wrongInputType','trials should always be numeric');
                    end
                    s.data = [];
                    s.timeOfCreation = datestr(now);
                    s.comments = {};
                case 3
                    if ischar(subject)
                        s.subject = subject;
                    else
                        error('analysis:wrongInputType','subject should always be char');
                    end
                    
                    if isnumeric(trials)
                        s.trials = trials;
                    else
                        error('analysis:wrongInputType','trials should always be numeric');
                    end
                    
                    if ischar(varargin{1})
                        if IsLinux && IsWinDir(varargin{1})
                            dP = recordsPathLUT(varargin{1},'Win2Lx');                        
                        else
                            dP = varargin{1};
                        end
                        if isdir(dP)
                            s.dataPath = varargin{1};
                            s.data = [];
                        else
                            error('dataPath should be a valid directory');
                        end
                    elseif isstruct(varargin{1})
                        s.data = varargin{1};
                    else
                        error('analysis:wrongInputType','either input a directory as datapath or input some data');
                    end                                       
                    s.timeOfCreation = datestr(now);
                    s.comments = {};
                case 4
                    if ischar(subject)
                        s.subject = subject;
                    else
                        error('analysis:wrongInputType','subject should always be char');
                    end
                    
                    if isnumeric(trials)
                        s.trials = trials;
                    else
                        error('analysis:wrongInputType','trials should always be numeric');
                    end
                    
                    if ischar(varargin{1})&&isdir(varargin{1})
                        s.dataPath = varargin{1};
                    else
                        error('analysis:wrongInputType','dataPath should always be a link to a valid folder');
                    end                                       
                    
                    if isstruct(varargin{2})
                        s.data = varargin{2};
                    else
                        error('analysis:wrongInputType','data is always a structure');
                    end                                       
                    
                    s.timeOfCreation = datestr(now);
                    s.comments = {};
            end
        end
        
        %% addComment
        function s = addComment(s,comment)
            if ~exist('comment','var')||isempty(comment)
                error('cannot add nothing to comment');
            end
            if ~ischar(comment)
                error('the comment has to be a char');
            end
            numComments = length(s.comments);
            s.comments{numComments+1} = {datestr(now),comment};
        end
        
        function s = addAnesthesia(s,anesth)
            if ~exist('anesth','var')||isempty(anesth)
                anesth=NaN;
            end
            if ~isnumeric(anesth) && length(size(anesth))==2 && all(size(anesth)==[1 1])
                error('must be a single number 0 (awake) to anesthesia depth (typically iso %)');
            end

            s.data.anesthesia = anesth;
        end
        function out = getAnesthesia(s)
            if isfield(s.data,'anesthesia')
                out = s.data.anesthesia;
            else
                out = NaN;
            end
        end
        
        function s=set.sourceFolder(s,folder)
            if ischar(folder) || isempty(folder)
                s.sourceFolder=folder;
            else
                error('expected to be a string in format ''XX-YY''')
            end
        end
        
        function out=get.sourceFolder(s)
            if ~isempty(s.sourceFolder)
                out = s.sourceFolder;
            elseif ~isempty(s.trials)
                if length(unique(s.trials))==1
                    out = sprintf('%d',unique(s.trials));
                else
                    out = sprintf('%d-%d',min(s.trials),max(s.trials));
                end
            else
                warning('expected to be a string in format ''XX-YY''')
                out = '';
            end
        end
        %% displaycomments
        function displayComments(s)
            fprintf('\ncomments:\n');
            for i = 1:length(s.comments)
                fprintf('\t%s : %s\n',s.comments{i}{1},s.comments{i}{2});
            end
        end
        
        %% ident
        function tf = ident(a,b)
            tf = strcmp(class(a),class(b)) && strcmp(a.subject,b.subject) && all(unique(a.trials)==unique(b.trials));
        end
        
        %% addAnalysis
        function s = addAnalysis(s,a)
            if ident(s,a)
                % do nothing
            elseif ~strcmp(class(a),class(b)) || ~strcmp(a.subject,b.subject)
                error('can only addAnalyses of identical type and for the same subject');
            else
                s.trialNumbers = unique([s.trials;a.trials]);
            end
        end       
        
        %% updateTrialNumbers
        function s = updateTrialNumbers(s,a)
            if ~strcmp(s.subject,a.subject)
                error('cannot update for different subjects');
            end
            s.trials = unique([s.trials(:);a.trials(:)]);
        end
        function s=addTrialNumbersManually(s,trialNumbers)
             s.trials = unique([s.trials(:);trialNumbers(:)]);
        end
        
        %% getSubject
        function subject = getSubject(s)
            subject = s.subject;
        end        
        
        %% isempty
        function tf = isempty(s)
            tf = isempty(s(1).trials);
        end % isempty
        
        %% getType
        function out = getType(s)
            out='genericAnalysis';
        end % isempty

        %% dataPath
        % changeDataPath
        function s = changeDataPath(s,in)
            if ischar(in)&&isdir(in) 
                s.dataPath = in;
            end
        end
        
        % getDataPath 
        function out = getDataPath(s)
            out = s.dataPath;
        end
        
        function out = getPhysIndexForTrials(s,records)
            out = [];
            done = false;
            i = 1;
            while ~done
                if all(records{i}{2}==unique(minmax(s.trials)))
                    out = i;
                    done = true;
                else
                    i = i+1;
                end
                if i>length(records)
                    error('could not find the trials in the records');
                end
            end
        end
    end
end