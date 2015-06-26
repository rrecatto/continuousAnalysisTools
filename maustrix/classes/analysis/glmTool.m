classdef glmTool
    % tool to estimate the conditional intensity function of spikes,
    % given some variables. also a brief tutorial about how to use OOP in
    % matlab for your science data the demo use spikes from anth. rat LGN,
    % while viewing a full-field CRT flicking at 100Hz.
    %
    % to begin, define the default object, and run the method "tutorial":
    %
    %       g=glmTool; g.tutorial;
    %
    % or work through sandbox.m
    %
    % code: (c) 2010 Philip Meier, The MIT license (g.displayLicence)
    % data: by Philip Meier & Balaji Sriram in Reinagel lab @ UCSD
    %       permission to use and diseminate for educational purposes only
    %       this data is unpublished. please contact pmeier@ucsd.edu for
    %       permission involving a published use or regarding citations
    %       source: datanetOutput\231\analysis\475-485\485-20100604T200707\
    % thanks: Uri Eden, Emery Brown for useful ppt & GLM tutorial that was
    %       presented at summer course on Neuroinformatics @ Woods hole;
    %       also thx2 Emily Mankin for collaborating to present at UCSD CN
    % source and bug reports: code.google.com/p/glmtool/
    %
    % version 0.1   wrote zeta for CN class at UCSD  -pmm.2010.10.18
   
    
    properties % every variable related to this object
        
        %the defaults may be specified
        featureType='linear';                                 % linear, quadratic, kitchenSink
        useFeatures={'photoDiode'}                            % the name(s) of the base features to use in dataSource .mat
        temporalFeatureSampling=NaN;                          % how many historical time steps included (NaN is no history)
        dataPath='/Users/pmeier/Documents/code/matlab/GLM/';  % where data file is
        dataSource='Neuron1_raw.mat';                         % this file must have the vector 'spikes' [nx1] and some features [nx1]
        name='undefined';                                     % if none provided, will be asigned a unique date
        testTimeRangeSec =[0 Inf];                            % default to all the data
        trainTimeRangeSec=[0 Inf];                            % default to all the data
        
        %dynamic ones can be calculated as you go
        numSamps
        testIndices
        trainIndices
        
        % it's okay to leave some properties empty to fill later
        data  % things loaded worth keeping
        cache % things calculated worth keeping
        
    end 
    
    methods %start here (entrance)
        
        %this method is the same as the stand alone mfile
        function tutorial(g) %basic demo
            %this is a normal latlab tutorial (commented code)
            
            close all
            warning('this code is intended to be run line by line for explanatory purposes, please click on the upper link and follow instructions')
            keyboard
            %% HOW TO USE THIS TUTORIAL:
            %
            %    1. evaluate each cell (option-Enter)
            %or
            %    1. evaluate each section by highlighting it and
            %       use F9 on windows machines, or shift-F7 on mac
            %or
            %    2. highlight, then right click "Evaluate Selection"
            
            
            %% choose or update parameters
            g.useFeatures={'photoDiode'};
            g.temporalFeatureSampling={[-30:-1]}; %samples before the spike
            g.trainTimeRangeSec=[0 200];          %part of data used for training
            g.testTimeRangeSec=[200 Inf];         %part of data used for testing
            
            %% run it
            
            % initialize. this will load the data and other such things
            g=g.init; %the method returns the modified object
            % notice no arguments are needed for the method, because its
            % ALL in the structure of the object
            % the object "knows how to analyze itself"
            
            % create features(F)
            [g fTrain]=g.createPredictors(g.trainTimeRangeSec,false);  % build model on 1st 200sec
            [g fTest] =g.createPredictors(g.testTimeRangeSec,true);    % test  model on the rest
            % feature matrix is size [numSamps numFeatures]
            size(fTrain)
            
            % fit the generalized linear model (GLM)
            %'p' is for the predicted probability, its a 'conditional intensity function'
            % in other words, with what probability will the neuron spike
            % in the context defined by the features
            g=g.estimateSpikeProb(fTrain,fTest); % predict spikes with GLM
            
            % plot the STA
            %the beta co-efficents of luminance are an optimal a linear projection
            figure; g.plotBetas;
            %notice the shape compared to the STA for the cell
            g.plotSTA; legend({'GLM','zero','STA'})
            %the STA uses all the spikes in the data and was calculated on
            %RGB values (0-255)
            
            % save. cuz its nice to have a record
            g.fig2Im('mySTA');
            
            %% 3 different models
            % THIS CODE IS REDUNDANT, to demonstrate a point
            % Q: how might it be made better? 
            % A: how about finishing your own g.compareGLMs({g1,g2,g3}))
            
            %copy and name models
            g1=g; g1.name='photo';
            g2=g; g2.name='spike';
            g3=g; g3.name='both';
            
            %set model features
            g1.useFeatures={'photoDiode'}; 
            g2.useFeatures={'spikes'};
            g3.useFeatures={'photoDiode','spikes'};
            g3.temporalFeatureSampling={[-30:-1],[-30:-1]};
            
            %estimate the GLM
            g1=g1.estimateSpikeProb;
            g2=g2.estimateSpikeProb;
            g3=g3.estimateSpikeProb;
            
            %plot the betas
            figure;
            subplot(3,1,1); g1.plotBetas; title('compare models')
            subplot(3,1,2); g2.plotBetas;
            subplot(3,1,3); g3.plotBetas;
            g.fig2Im('compareSTAs');
            
            %evaluate quality
            figure; g1=g1.timeRescale;
            figure; g2=g2.timeRescale;
            figure; g3=g3.timeRescale;

        end
        
    end
    
    methods %the constructor (menu)
        %constructor (menu)
        function g=glmTool(useFeatures,historyLength,name)
            % this is the object constructor. it has two optional arguments:
            % useFeatures - defaults to 'photoDiode'
            %    yoyenter your custom feature
            % historyLength - defaults to NaN (no history)
            %    a good number is 30 samples = 30 frames --> 300msec
            if exist('useFeatures','var') && ~isempty(useFeatures)
                %this an example of an optional argument will override the default property
                g.useFeatures=useFeatures;
            end
            
            if exist('historyLength','var') && ~isempty(historyLength) && ~isnan(historyLength)
                %temporalFeatureSampling=historyLength;
                temporalFeatureSampling={[-30:-1]}
            end
            
            if exist('name','var')
                g=g.assignName(name);
            else
                g=g.assignName([]); % will get date if it's empty
            end
            

            
            % %THIS GETS CALLED WHENEVER YOU CONSTRUCT AN OBJECT
            % %COMMENT IT OUT IF YOU EVER USE THIS OBJECT
            % %
            % g=g.init(); % initialize things
            % g.development()

        end
    end
    
    methods %setters (cook)
        
        function g=set.name(g,input) % simple example
            if ischar(input)
                g.name=input;
            else
                error('must be a character string')
            end
        end
        function g=set.testTimeRangeSec(g,timeRangeSeconds)
            if isnumeric(timeRangeSeconds) && length(timeRangeSeconds)==2
                g.testTimeRangeSec=timeRangeSeconds;
            else
                error('timeRangeSeconds must be a vector length 2')
            end
        end
        function g=set.trainTimeRangeSec(g,timeRangeSeconds)
            if isnumeric(timeRangeSeconds) && length(timeRangeSeconds)==2
                g.trainTimeRangeSec=timeRangeSeconds;
            else
                error('timeRangeSeconds must be a vector length 2')
            end
        end
        function g=set.useFeatures(g,input)% more complex
            %checks to make sure that 'useFeatures' is one of 3 values
            
            % this "set" is called anytime the value gets changed
            % it enforces that the proprety is the right kind of value
            % it is not "required" but its good pracitce to set all values
            % this way error checking happens as you go
            % ultimately, it's  easier for anyone (or you) to use the code
            % its most important to write setters for every input in the
            % constructor
            
            
            if g.isCellOfStrings(input)
                % any string is okay... but this will error if you dont
                % specify the right variable... really you should check as
                % commented out below.
                g.useFeatures=input;
                %                 acceptableList={'photoDiode','spikes','generatorSignal'};
                %                 if all(ismember(input,acceptableList))
                %                     %okay, carry on
                %                     g.useFeatures=input;
                %                 else
                %                     acceptableList
                %                     request=input(~ismember(input,acceptableList))
                %                     error('requested features that are not acceptable!')
                %                 end
                
            else
                error('must be a cell of strings')
            end
            %g=g.checkDataFormatAndSetFeatureFields(input?); not needed
            
        end
        function g=set.temporalFeatureSampling(g,input) % really complex
            %the setter for how features with temporal history sampled
            %checks that the field ends up being a cell of vectors.  allows for
            %two ways to get there: either a single whole number is provided,
            %and the cells are constructed.  or a cell is accepted and error
            %checked.
            
            switch class(input)
                case {'double','uint8'}
                    %simple mode assumes the last N samples before the
                    %spike are of interest
                    if mod(input,1)==0
                        g.temporalFeatureSampling={-input:-1};
                    else
                        error('must be a single whole number')
                    end
                case 'cell'
                    %complex mode check that a vector exists in each cell
                    %and that the cell is the right size
                    if length(input)==length(g.useFeatures) && g.isCellOfVectorOfWholeNumberOrNaN(input)
                        g.temporalFeatureSampling=input;
                    else
                        lengthOfTemporalFeatureCell =length(input)
                        numFeatures=length(g.useFeatures)
                        error('length of cell must be the same as the number of features amd each entry must be a vector of sample offsets or NaN')
                    end
                otherwise
                    error('setting temporalFeatureSampling requires a single whole number of samples, or a cell of vectors of specific samples for each used feature')
            end
        end
        function g=addData(g,dataName,dataValues)
      
            %             [size(dataValues');
            %             size(g.data.spikes)]
            %             warning('ere')
            %             keyboard
     
            g.data.(dataName)=dataValues';
            g=g.checkDataFormatAndSetFeatureFields();
            %g.data.features{end+1}=dataName;
        end
    end
    
    methods %getters (waitor)
        
        function numSamps=get.numSamps(g)
            % the number of samples in the data set is CALCULATED from the
            % data.  note: this is like a field that is never set by you.
            % every time you call the field it recalculates the value
            
            if ismember('spikes',fields(g.data))
                numSamps=length(g.data.spikes);
            else
                %if spikes not loaded yet return NaN
                numSamps=NaN;
            end
        end
        function trainIndices=get.trainIndices(g)
            trainIndices=g.calcIndicesFromTimeRange(g.trainTimeRangeSec);
        end
        function testIndices=get.testIndices(g)
            testIndices=g.calcIndicesFromTimeRange(g.testTimeRangeSec);
        end
        
    end
    
    methods %main course (meat & potatos)
        
        function g=init(g)
            %put raw data into a structure
            
            % set the object's data path to the mfile's location
            [here junk]=fileparts(mfilename('fullpath'));
            g.dataPath=here;
            
            g=g.loadData('path2mat',g.dataSource); %use the path to the .mat file
            %g=g.loadData('rlab'); %only works in reinagel lab
            %g=g.loadData('path2mat','Neuron1_raw_msRes.mat'); %uh oh:memory!
            
        end
        function g=assignName(g,name)
            if exist('name','var') && ~isempty(name)
                g.name=name;
            else
                g.name=['g' datestr(now,30)];
            end
        end
        function g=loadData(g,source,param)
            switch source
                case 'toy'
                    n=100;
                    d.spikes=rand(1,n)<.2;
                    d.x=randn(1,n);
                    d.y=randn(1,n);
                    d.photoDiode=randn(1,n);
                    g.data=d;
                case 'path2mat'
                    %this works for any data with the appropriate format
                    %(see checkDataFormat)
                    path=g.dataPath;
                    if exist('param','var')
                        file=param;
                    else
                        file=g.dataPath;
                    end
                    if exist(path,'dir')
                        if exist(path,'file')
                            g.data=load(fullfile(path,file));
                        else
                            error('couldn''t find file: %s',file)
                        end
                    else
                        
                        error('not a valid data path: %s',path)
                    end
                case 'rlab'

                    %map the inputs so this function works
                    correctedFrameIndices=param.frames.correctedFrameIndices;
                    correctedFrameTimes=param.frames.correctedFrameTimes;
                    spikeTimestamps=param.spikes.spikeTimestamps;

                    % this data is binned at 10ms b/c the frame rate is 100Hz
                    numFrames=size(correctedFrameIndices,1);
                    
                    % did this first cuz its easy:
                    spikesPerFrame=zeros(numFrames,1);
                    
                    %but really we want 1 msec resolution:
                    spikes=zeros(numFrames,1); %  spikes=zeros(numFrames*10,1);
                    
                    for i=1:numFrames
                        %how many spikes on this frame?
                        which=find(spikeTimestamps>=correctedFrameTimes(i,1)...
                            &spikeTimestamps<=correctedFrameTimes(i,2));
                        spikesPerFrame(i)=length(which);
                        
                        %how long after the frame start did the spike occur?
                        for j=1:spikesPerFrame(i)
                            %    delay=spikeTimestamps(which(j))-correctedFrameTimes(i,1);
                            %    delaySinceFrame(which(j))=ceil(delay*1000);
                            %    % spike ind = samples to frame start + samples after frame start
                            %    spikes(which*10+ceil(delay*1000))=1;
                        end
                        
                        % a little more realistic than resampling smooth
                        %fakePulse(1+(i-1)*10)=photoDiode(i);
                    end
                    photoDiode=param.frames.photoDiode;
                    %photoDiode=resample(photoDiode,10,1);  % NOTE: this smoothing is unlike a real CRT
                    
                    spikes=spikesPerFrame; %avoids memory problems.
                    
                    %%visual test: flat hist confirms spike not entrained to the CRT pulse
                    %figure; hist(delaySinceFrame)
                    
                    info=param.info;  % any extra facts
                    info.stimUpdateHz=param.stimInfo.refreshRate;% stim param: a fact of the stimulus monitor
                    info.samplingHz=100;  % analysis param: temporal resolution for spikes and features
                    g.data.info=info;     % extra info that is not vectors over time

                    %store the data
                    g.data.spikes=spikes;
                    g.data.photoDiode=photoDiode;

                    %save a copy for use
                    savePath=fullfile(g.dataPath, g.dataSource)
                    save(savePath,'spikes','photoDiode','info')
                    
                case 'rlabOLD'
                    %error('these files are only on philip's laptop or his computer in reinagel lab')
                    load('spikeRecords.mat')
                    load('physAnalysis_485-20100604T200707')
                    %how to get or make this data:
                    %   source: datanetOutput\231\analysis\475-485\485-20100604T200707\
                    %   make:  spikeSortFiddler in RatrixTrunk@svnRev.2954
                    %   subjectID = '231';
                    %   path='\\132.239.158.179\datanetOutput'  %on the G drive remote
                    %   channels={1};
                    %   thrV=[-0.15 Inf];
                    %   cellBoundary={'trialRange',[475 485]}; %ffgwn [475 495]
                    %   analysisManagerByChunk(subjectID, path, cellBoundary, channels)
                    
                    % this data is binned at 10ms b/c the frame rate is 100Hz
                    numFrames=size(correctedFrameIndices,1);
                    
                    % did this first cuz its easy:
                    spikesPerFrame=zeros(numFrames,1);
                    
                    %but really we want 1 msec resolution:
                    spikes=zeros(numFrames,1); %  spikes=zeros(numFrames*10,1);
                    
                    
                    %%not used; alternative to photodiode:
                    %fakePulse=zeros(numFrames*10,1)
                    
                    %n%ot required to get data; just a test:
                    %delaySinceFrame=nan(length(spikeTimestamps),1);
                    
                    
                    for i=1:numFrames
                        %how many spikes on this frame?
                        which=find(spikeTimestamps>=correctedFrameTimes(i,1)...
                            &spikeTimestamps<=correctedFrameTimes(i,2));
                        spikesPerFrame(i)=length(which);
                        
                        %how long after the frame start did the spike occur?
                        for j=1:spikesPerFrame(i)
                            %    delay=spikeTimestamps(which(j))-correctedFrameTimes(i,1);
                            %    delaySinceFrame(which(j))=ceil(delay*1000);
                            %    % spike ind = samples to frame start + samples after frame start
                            %    spikes(which*10+ceil(delay*1000))=1;
                        end
                        
                        % a little more realistic than resampling smooth
                        %fakePulse(1+(i-1)*10)=photoDiode(i);
                    end
                    %photoDiode=resample(photoDiode,10,1);  % NOTE: this smoothing is unlike a real CRT
                    
                    spikes=spikesPerFrame; %avoids memory problems.
                    
                    %%visual test: flat hist confirms spike not entrained to the CRT pulse
                    %figure; hist(delaySinceFrame)
                    
                    %save some useful facts
                    info.STA=cumulativedata.cumulativeSTA(:);
                    info.stimUpdateHz=100;% stim param: a fact of the stimulus monitor
                    info.samplingHz=100;  % analysis param: temporal resolution for spikes and features
                    g.data.info=info;     % extra info that is not vectors over time
                    
                    %store the data
                    g.data.spikes=spikes;
                    g.data.photoDiode=photoDiode;
                    %generatorSignal=conv(g.data.photodiode, info.STA,'same'); % primarily for debugging
                    
                    %save a copy for use
                    savePath=fullfile('/Users/pmeier/Documents/code/matlab/GLM', 'Neuron1_raw.mat')
                    save(savePath,'spikes','photoDiode','info') %fakePulse, generatorSignal
                case 'myData'
                    %write your own accessor fuction here
                    error('not code written yet')
                otherwise
                    error(sprintf('bad source: %s',source))
            end
            g=g.checkDataFormatAndSetFeatureFields();
        end
        function [g F]=createPredictors(g,timeRangeSeconds,beginWithConstants)
            %creates a bunch of predictive features F from the useFeatures,
            %using featureType= linear or quadratic
            if ~exist('timeRangeSeconds','var') || isempty(timeRangeSeconds)
                timeRangeSeconds=g.trainIndices;
            end
            
            if ~exist('beginWithConstants','var')
                beginWithConstants=false;
            end
            
            numBaseFeatures=length(g.useFeatures);
            
            inds=g.trainIndices(1):g.trainIndices(2);
            numSampsUsed=length(inds);
            
            if beginWithConstants
                F=ones(numSampsUsed,1);
            else
                F=[];
            end
            
            switch g.featureType
                case {'linear'}
                    for i=1:numBaseFeatures
                        if isnan(g.temporalFeatureSampling{i})
                            %for no temporal history, use the time locked value
                            F=[F g.data.(g.useFeatures{i})(inds)];
                        else
                            %use a bunch of features at all the proceding time steps
                            f=g.data.(g.useFeatures{i})(inds); % feature
                            numHistoryPoints=length(g.temporalFeatureSampling{i});
                            fHistory=nan(numSampsUsed,numHistoryPoints);
                            for j=1:numHistoryPoints
                                shift=g.temporalFeatureSampling{i}(j);
                                fHistory(1-shift:numSampsUsed,j)=f(1:numSampsUsed+shift);
                            end
                            F=[F fHistory];
                            g.cache.dimsPerFeature(i)=numHistoryPoints;
                        end
                    end
                case {'quadratic'}
                    if any(~isnan([g.temporalFeatureSampling{1} g.temporalFeatureSampling{2}]))
                        error('temporal features are not currently compatible with quadratic')
                    end
                    switch numBaseFeatures
                        case 1
                            x=g.data.(g.useFeatures{1})(inds);
                            F=[F x x.^2];
                            g.cache.dimsPerFeature=2;
                        case 2
                            x=g.data.(g.useFeatures{1})(inds);
                            y=g.data.(g.useFeatures{2})(inds);
                            F=[F x x.^2 y y.^2 x.*y];
                            
                            %the first 2 are x, next 2 are y;
                            %but xy is included with y, call y 3 dims
                            g.cache.dimsPerFeature=[2 3];
                            
                        otherwise
                            error('generic code for quadratic is not written... support exists for only 1 or 2 base features')
                    end
                case 'kitchenSink'
                    error('code not written yet')
                otherwise
                    g.featureType
                    error('unknown feature type')
            end
            g.cache.lastCalculatedFeatures=F;
        end
        function g=estimateSpikeProb(g,fTrain,fTest)
            %predict spikes with GLM
            % estimates the spike probabilty given model you train on
            % features.  supports the abilty to have a test and training
            % set, but for simplicity defaults to using all the data for
            % both.  note, the default is not a good policy for a publication.
            
            if ~exist('fTrain','var') || isempty(fTrain)
                %exclude the constant for training
                [g fTrain]=g.createPredictors([],false);
            end
            
            if ~exist('fTest','var') || isempty(fTest)
                %get the features, including a constant
                [g fTest]=g.createPredictors([],true);
            end
            
            %matlab does the heavy lifting in one line...
            [beta,dev,stats] =glmfit(fTrain,g.data.spikes(g.trainIndices(1):g.trainIndices(2)),'poisson');
            %type "help glmfit" into the command line
            %click on the link "doc glmfit"
            %matlab's documentation is very useful when you learn a new function
            disp(sprintf('model %s was fit',g.name))
            
            %this is the MOST IMPORTANT SECTION to understand:
            %you can think of E as the 'energy'
            E=fTest*beta; %linear sum of all features(fTest) & coefficients(beta) for all time
            prediction=exp(E);  %a probability, (2.71)^energy
            
            % convince yourself the following is true when length(b)==3
            %
            %    test=all(exp(F*b) == exp(b(1) + F(:,2)*b(2) + F(:,3)*b(3)))
            %             %short         %mean  %1st feature  %2nd feature
            %
            % szF=size(F)
            % szB=size(b)
            %
            % what does this mean?
            
            % save the model and the fit in the cache
            g.cache.prediction=prediction;
            
            f=g.useFeatures;
            counter=1; %skip the DC component of beta
            for i=1:length(f)
                n=g.cache.dimsPerFeature(i);
                g.cache.model.beta.(f{i})=beta(1+counter:counter+n);
                counter=counter+n;
            end
            g.cache.model.dev=dev;
            g.cache.model.stats=stats;
            
        end
        function g=testSignificance(model,data)
            error('code not written')
        end
        function g=timeRescale(g)
            
            %get data organized
            %if ~isThere, predict it, else, cache:
            CIF=g.cache.prediction; % conditional intensity function
            inds=g.testIndices(1):g.testIndices(2); % indices for test data
            spikes=g.data.spikes(inds); %match spikes to test data (= CIF)
            numSp=sum(spikes>0); % number of spike events (>1 still spike = 1)

            %init variables
            n=range(inds); % num samps in test data
            dt = 1;        % amount of time to move forward
            L = 0;         % cumulative lambda since spike
            counter=0;     % spike event counter
           
            %integrate over every dt of the test data
            for i=1:n
                %L is integral of the CIF since the last spike
                L = L + CIF(i)*dt;
                if spikes(i)
                    counter = counter + 1; 
                    ks(counter) = 1-exp(-L);
                    L = 0; %reset 
                end;
            end;
            ks=sort(ks);
            
            %UNFINSHED ATTEMPT TO VECTORIZE
            %spikeTimes=find(g.data.spikes); % binned at g.data.info.samplingHz
            %ISI=[spikeTimes(1); diff(spikeTimes(inds))]; %inter spike interval
            %error('needs work here')
            %staircase=
            %cumCIF=cumsum(CIF(inds))-staircase; 
            %L=cumCIF(spikeTimes);
            %ks=sort(1-exp(-L)); % rank ordered ks-values
            
            ramp=linspace(0,1,101); %c uniform increase
            plot(([1:numSp]-.5)/numSp, ks, 'b')
            hold on;
            plot(ramp,ramp,'g')
            plot(ramp, ramp+1.36/sqrt(numSp),'r')
            plot(ramp, ramp-1.36/sqrt(numSp),'r');
            axis( [0 1 0 1] );
            xlabel('Uniform CDF');
            ylabel('Empirical CDF of Rescaled ISIs');
            title(sprintf('%s: Q-Q plot w/ 95%% KS CI',g.name));
            
            g.cache.ks.numSp=numSp;
            bigRamp=([1:numSp]-0.5)/numSp;
            cdfdiff=abs(ks - bigRamp);
            [g.cache.ks.stat whichInd] = max(cdfdiff);
            plot(bigRamp,abs(cdfdiff),'c')
            plot([bigRamp(whichInd) bigRamp(whichInd)],[ks(whichInd) bigRamp(whichInd)],'k')
            text(.2,.8,sprintf('ks_{stat}= %2.2f',g.cache.ks.stat));
            g.makePretty;
            axis square
        end
        
    end
    
    methods %helpers (side dishes)
        function compareGLMs(g,batch)
            if ~iscell(batch)|| ~cellfun(@(x) isa('glmTool',x),batch)
                error('must be a cell of glmTools')
            end
            
            numModels=length(batch);
            for i=1:numModels
                fprintf('(%d of %d) - %s',i,numModels,getName(batch{i}))
                disp('NO WRITTEN CODE YET')
            end
        end
        function plotPrediction(g)
            
            tRange=12000:13000;
            peak=max(g.data.generatorSignal)
            zoomedSpikes=g.data.spikes(tRange);
            subplot(2,1,1);
            hold off; plot(g.data.generatorSignal(tRange),'k')
            hold on;  plot(find(zoomedSpikes>0),peak,'r.')
            g.makePretty(gca,[0 500 1000],[],[0 5 10]); axis([0 1000 ylim])
            
            subplot(2,1,2);
            hold off; plot(g.cache.prediction(tRange),'k')
            hold on;  plot(find(zoomedSpikes>0),0.2+0.1*zoomedSpikes(zoomedSpikes>0),'r.')
            g.makePretty(gca,[0 500 1000],[.2:.2:.8],[0 5 10]); axis([0 1000 .2 .8])
            xlabel('seconds'); ylabel('p(spike)')
            
        end
        function plotBetas(g,types)
            if ~exist('types','var') || isempty(types)
                types=fields(g.cache.model.beta);
            end
            numTypes=length(types);
            colors=jet(numTypes);
            for i=1:numTypes
                b=g.cache.model.beta.(types{i});
                n=length(b);
                
                b=b/max(abs(b));
                plot(b,'color',colors(i,:));
                
                %plot a horizontal line
                hold on; plot([1 n],[0 0],'k')
                
                %clean up and label
                ylabel(types{i})
                yl=ylim;
                xLabel={[num2str(n*10) 'ms before'],'time of spike'};
                %g.makePretty(gca,[1 n],[yl(1) 0 yl(2)]/2,xLabel,{'-','0','+'});
            end
        end
        function plotSTA(g)
            %the STA is basically the linear predictor, which are the betas
            
            
            %can you calculate the STA the traditional way and compare them?
            %   STA_traditional=g.calculateSTA(g.data.spikes,g.data.photoDiode,etc)
            %   this method is not written... that's your job
            
            %get organized
            STA=g.data.info.STA; %or STA_traditional
            STA=STA-mean(STA);
            STA=STA/max(abs(STA));
            n=length(STA);
            
            %plot the STA
            plot([1:n]-1,STA,'r');
            
            %plot a horizontal line
            hold on; plot([1 n-8],[0 0],'k')
            
            %clean up and label
            ylabel('photodiode')
            yl=ylim;
            xLabel={[num2str((n-8)*10) 'ms before'],'time of spike'};
            g.makePretty(gca,[1 n],[yl(1) 0 yl(2)]/2,xLabel,{'-','0','+'});
            
        end
        function makePretty(g,handle,xs,ys,xLabel,yLabel)
            %set defaults for uncluttered axis
            if ~exist('handle','var') || isempty(handle)
                handle=gca;
            end
            if ~exist('xs','var') || isempty(xs)
                xs=[];
            end
            if ~exist('ys','var') || isempty(ys)
                ys=[];
            end
            
            axis(gca);
            set(gca,'fontsize',16)
            
            %the ticks
            set(gca,'xtick',xs)
            set(gca,'ytick',ys)
            if exist('xLabel','var') && ~ isempty(xLabel)
                set(gca,'xTickLabel',xLabel)
            end
            if exist('yLabel','var') && ~isempty(yLabel)
                set(gca,'yTickLabel',yLabel)
            end
            
        end
        function logical=isCellOfStrings(g,input)
            logical=iscell(input) && all(cellfun(@(x) ischar(x),input));
        end
        function logical=isCellOfVectorOfWholeNumberOrNaN(g,input)
            %check every cell to see if its full of whole numbers
            isWhole=cellfun(@(x) all(mod(x,1)==0),input); % a vector
            
            %check every cell to see if its full of NaNs
            isaNaN=cellfun(@(x) all(isnan(x)) && lenth(x)==1,input); % a vector
            
            %confirm each cell is a vector that is either NaN or whole#
            logical=all(cellfun(@isvector,input)) && all(isaNaN | isWhole); % single logical
        end
        function inds=calcIndicesFromTimeRange(g,timeRangeSec)
            % calc the indices in the vector specifying the time range
            % requires the data to have specified the samplingHz in 'info'
            
            if ~isempty(timeRangeSec) %&&
                if timeRangeSec(1)==0 && isinf(timeRangeSec(2))
                    %all the data
                    numSampsUsed=g.numSamps;
                    ss=1;
                    ee=numSampsUsed;
                else
                    %if ~g.isThere('g.data.info.samplingHz')
                    %    error('must have loaded data with ''info.samplingHz'' if accesing indices')
                    %end
                    
                    numSampsUsed=diff(timeRangeSec)*g.data.info.samplingHz;
                    ss=max(1,timeRangeSec(1)*g.data.info.samplingHz);
                    ee=min(ss+numSampsUsed-1,g.numSamps);
                end
            end
            inds=[ss ee];
        end
        function g=checkDataFormatAndSetFeatureFields(g)
            % will complain if something is wrong
            disp('checking data fields...');
            
            f=fields(g.data);  % a list of the field in data
            % will correspnd to the variables loaded form the .mat
            %confirm spikes vactor is there
            if ismember('spikes',f) && isvector(g.data.spikes)
                %good, because this glmTool is made to work on spikes, and
                %requires it to be there
            else
                g.data
                error('must have ''spikes'' as a vector')
            end
            
            %an optional structure might be there, and is ignored
            if any(ismember(f,{'info','features'}))
                %remove 'info'; from the future list of features (f)
                f(ismember(f,{'info','features'}))=[];
            end
            
            %check that the rest are all vectors the same length (numSamps) as 'spikes'
            for i=1:length(f)
                if isvector(g.data.(f{i})) && length(g.data.(f{i}))==g.numSamps;
                    %okay its good, do nothing
                else
                    error(sprintf('feature ''%s'' is not a vector of the right length',f{i}))
                end
            end
            
            %store the names of the features, and return the updated object(g)
            g.data.features=f;
            
            %confirm that the requested useFeatures are available
            if ~all(ismember(g.useFeatures,g.data.features))
                requested=g.useFeatures
                found=g.data.features
                error('expected to find requested useFeatures that are missing')
            end
        end
        function development(g)
            %this code got commented and moved to "tutorial"
            g.tutorial();
        end
        function displayLicence(g)
            disp(sprintf(['Permission is hereby granted, free of charge, to any person obtaining a copy'...
                '\nof this software and associated documentation files (the "Software"), to deal'...
                '\nin the Software without restriction, including without limitation the rights'...
                '\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell'...
                '\ncopies of the Software, and to permit persons to whom the Software is'...
                '\nfurnished to do so, subject to the following conditions:'...
                '\n'...
                '\nThe above copyright notice and this permission notice shall be included in'...
                '\nall copies or substantial portions of the Software.'...
                '\n'...
                '\nTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR'...
                '\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,'...
                '\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE'...
                '\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER'...
                '\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,'...
                '\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN'...
                '\nTHE SOFTWARE.']))
        end 
        
    end
    
    methods %fun (desert)
        
        function fig2Im(g,name,whichFigs,type)
            %saves an image of a figure in the folder: g.dataPath/output
            %
            % g.fig2Im('theName')
            % g.fig2Im('theName',figureID,'nice')
            
            if ~exist('whichFigs','var') || isempty(whichFigs)
                whichFigs=gcf; % the current figure
            end
            
            if ~exist('type','var') || isempty(type)
                type='normal';
            end
            
            %make the directory if its not there
            theDir=fullfile(g.dataPath,'output');
            if ~exist(theDir,'dir')
                mkdir(theDir);
            end
            
            for i=1:length(whichFigs)
                figure(whichFigs(i))
                switch type
                    case 'normal'
                        %good for fast viewing / saving / small
                        filetype='png'; %{'png','jpg','bmp','fig'}
                        loc=fullfile(g.dataPath,'output',[name '_' datestr(now,30)]);
                        saveas(whichFigs(i),loc,filetype);
                    case 'nice'
                        %better for papers / very big
                        filetype='-dtiffn'; %{'-dpsc','-depsc2','-dtiffn','-dbmp'}
                        loc=fullfile(g.dataPath,'output',[name '_' datestr(now,30)]);
                        renderMode={'-painters'}; % must be one or many of these: {'-painters','-zbuffer','-opengl'}
                        resolution=600; %maybe use 1200 for a final paper submission
                        print(sprintf('-r%d',resolution),renderMode, filetype, loc);
                    otherwise
                        type
                        error('bad type')
                end
                disp(sprintf('image written: %s',loc))
            end
            
        end
        function inspectFeatures(g)
            %make a bunch of histograms of the available features
            
            %organize
            f=g.data.features
            n=length(f);
            
            %choose a size for subplots
            %goal: fit the # of features well (square-ish)
            w=ceil(sqrt(n));
            h=ceil(n/w);
            
            %loop thru all features
            for i=1:n
                subplot(h,w,i);
                hist(g.data.(f{i}));
                xlabel(f{i})
            end
            
        end
        function fancyTutorial(g)
            %this is a fancier command line tutorial...
            %just run it and follow instructions
            error('code not written')
        end
        function explainSignificance(g)
            %time rescaling, quantile quantile plots--> ks tests
            error('code not written')
        end
        
    end
    
    methods %toDo
        %-explain what's up with the refractory period
        %-try different length histories
        %-refractor "3 different models" in tutorial into g.compareGLMs()
        %-calculate the STA (g.plotSTA) instead of loading it in from info
        %-fix historyLength as integer class
        %-g.makePrettier
    end
end
