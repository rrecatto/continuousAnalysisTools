function db=addSingleUnit(db,varargin)
% usecases:
% db.addsingleUnit(subject,ID,channels,comment,params,paramNames,overwrite)
% OR
% db.addSingleUnit(singleUnit)
% example: db=db.addSingleUnit('231',ID,channels,aneth,'nice',{[46:50],quality,included,thrV,'ffgwn'})
% fancier example:
%
%             ID=1; % neuronID
%             subj='231'; thrV=[-0.05 Inf 2]; included=1;
%             db=db.addSingleUnit(subj,ID,channels,'first cell tested',{...
%                 [4]      ,NaN,included,thrV,'TRF - great!';...
%                 [46:50]  ,NaN,included,thrV,'ffgwn';...
%                 [93:110] ,NaN,included,thrV,'6x8 bin DUPPED';...
%                 [103:124],NaN,included,thrV,'fff contr drive it weakly. (step 40)'...
%                 })

switch nargin
    case 2
        % only input singleUnit otherwise error
        if isempty(varargin{1}) || ~isa(varargin{1},'singleUnit')
            error('you need to send in a single Unit if you want to add something!!!!');
        end
        % how many sUs are already in the db?
        numNeurons = 0;
        disp('adding singleUnit now:')
        warning('no checking if the singleUnit already exists')
        pause(2);
        ID = db.numNeurons;
        
        db.data{ID+1} = varargin{1};
        db.neuronID(index)=ID;
    case {7,8,9}
        subject = varargin{1};
        ID = varargin{2};
        channels = varargin{3};
        mon = varargin{4};
        comment = varargin{5};
        params = varargin{6};
        % input on the old format
        if length(varargin)>=7 && ~isempty(varargin{7}) % paramsNames is specified
            paramNames = varargin{7};
        else % param names wasnt sent in or param names was empty
            paramNames={'trials','sortQuality','eyeQuality','analysisQuality',...
                'rigState','ampState','included','thrV','anesth','comment'};
        end
        
        if length(varargin)>=8 && ~isempty(varargin{8}) % overwrite is specified
            overwrite = varargin{8};
        else % overwrite wasnt sent in or overwrite was empty
            overwrite=false;
        end
                
        %setup
        if ~overwrite
            %garuantee a new neuron
            test=find(ismember(db.neuronID,ID));
            if length(test)~=0
                ID
                db.neuronID
                error('expect no previous entries')
            end
            index=length(db.neuronID)+1;
        else
            %check that its there already
            index=find(ismember(db.neuronID,ID));
            if length(index)~=1
                ID
                db.neuronID
                error('expect exactly 1 entry')
            end
        end
        disp(sprintf('adding singleUnit # %d',ID));
        
        numAnalysis=size(params,1);
        numParams=size(params,2);
        
        %build empty container with no trials:
        db.data{index} = singleUnit(subject,[]);
        db.data{index} = addChannels(db.data{index},channels);
        db.data{index} = addMonitor(db.data{index},mon);
        % if islinux change the datapaths (for balaji only)
        if IsLinux
            %db.data{index} = changeDataPath(db.data{index},'~/Documents/datanetOutput');
        else
            %external on balaji's machine
            db.data{index} = changeDataPath(db.data{index},'\\132.239.158.169\datanetOutput');
        end
        %sync the ID
        db.neuronID(index)=ID;
        
        for i=1:numAnalysis
            x=[]; %flush from last entry
            for j=1:numParams
                %dynamically build the arguments in
                x.(paramNames{j})=params{i,j};
            end
            %add the analysis to the singleUnit
            db.data{index}=db.data{index}.addAnalysis(x.trials,x.thrV,x.sortQuality,x.eyeQuality,x.analysisQuality,...
                x.rigState,x.ampState,x.included,x.anesth,x.comment,mon);
        end
end
end
