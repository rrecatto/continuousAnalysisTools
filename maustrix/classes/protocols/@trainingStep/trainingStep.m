function t=trainingStep(varargin)
% TRAININGSTEP  class constructor.
% t = trainingStep(trialManager,stimManager,criterion,scheduler,svnRevision,svnCheckMode)

t.svnRevURL = [];
t.svnRevNum = [];
t.svnCheckMode = 'session'; % default means we only check for an svn update once per session

switch nargin
    case 0
        % if no input arguments, create a default object
        t.trialManager = trialManager();
        t.stimManager = stimManager();
        t.criterion = criterion();
        t.scheduler = scheduler();
        t.stepName = '';

        t.previousSchedulerState=0;
        t.trialNum=0;
        t.sessionRecords =[];
        %sessionStarts=sessionRecords(:,1);
        %sessionStops=sessionRecords(:,2);
        %trialsCompleted=sessionRecords(:,3);  % so far this session

        t = class(t,'trainingStep');
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'trainingStep'))
            t = varargin{1};
        else
            error('Input argument is not a trainingStep object')
        end
    case {6,7}
        % create object using specified values
        if isa(varargin{1},'trialManager') && isa(varargin{2},'stimManager') && isa(varargin{3},'criterion') && isa(varargin{4},'scheduler')
            t.trialManager = varargin{1};
            t.stimManager = varargin{2};
            t.criterion = varargin{3};
            t.scheduler = varargin{4};
            
            if ischar(varargin{6}) && (strcmp(varargin{6},'session') || strcmp(varargin{6},'trial') || strcmp(varargin{6},'none'))
                t.svnCheckMode = varargin{6};
            else
                error('svnCheckMode must be ''session'' or ''trial'' or ''none''');
            end
            
            if ~strcmp(t.svnCheckMode,'none')
                try
                    [t.svnRevURL t.svnRevNum]=checkTargetRevision(varargin{5});
                catch ex
                    warning('svn isn''t working due to no network access -- this needs to be fixed, but for now we just bail')
                    % ex
                    t.svnRevURL='';
                    t.svnRevNum=0;
                end
            end
            
            if nargin>=7
                if ischar(varargin{7})
                    t.stepName=varargin{7};
                else
                    error('name must be a character string')
                end
            else
                t.stepName='';
            end
         
            t.previousSchedulerState=0;
            t.trialNum=0;
            t.sessionRecords =[];
            %sessionStarts=sessionRecords(:,1);
            %sessionStops=sessionRecords(:,2);
            %trialsCompleted=sessionRecords(:,3);  % so far this session

            if stimMgrOKForTrialMgr(t.stimManager,t.trialManager)
                t = class(t,'trainingStep');
            else
                class(t.stimManager)
                class(t.trialManager)
                error('stimManager doesn''t know about this kind of trialManager')
            end

        else
            isa(varargin{1},'trialManager')
            isa(varargin{2},'stimManager')
            isa(varargin{3},'criterion')
            isa(varargin{4},'scheduler')
            error('must pass in a trialManager, stimManager, criterion, scheduler')
        end
    otherwise
        error('Wrong number of input arguments')
end