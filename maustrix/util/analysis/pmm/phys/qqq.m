


db=neuronDB('pmmNeurons');
db=db.updateAnalyses() 
db.plotFlankerArray()
return

%%
ID=[21];
db=db.addUniqueStepNamesToScratchPad(ID);
db.mode='onlyDetectAndSort';
db=db.process([13])
db.mode='onlyAnalyze';
db=db.process([12 14:21]);
db=db.updateAnalyses(ID);
db=db.flushAnalysisData()
db.save

return
%% sorted:  5-21
db.mode='onlyInspectInteractive'; db=db.process(1) 

%% do this
db.mode='onlyAnalyze'; db=db.process(6);
%%
db=neuronDB('pmmNeurons');
db=db.updateAnalyses();
%db=db.doNotIncludeAnalysis();
%db=db.updateAnalyses;
%db=db.flushAnalysisData; 
db.plotFlankerRawND

db.displayAnalysis
db.plotByAnalysis('gaussianFullField')
db.plotByAnalysis('fffc')
db.plotByAnalysis('sfGratings')

%%
return
%%


%%
db.plotModeOfGLM()

%%
db.mode='onlyAnalyze';
db=db.process(20);

%%
db.mode='onlyDetectAndSort';
db=db.process(7)

%%
%%
db.mode='overwriteAll';
db=db.process(1)


%% inspect some
%db.plot({'isi'},[10]) %OLD
db.plotGrid('isi')
%% some plot calls

db.plotByAnalysis('tfGrating')
db.plotByAnalysis('tfGrating')
db.plotByAnalysis([1])
%% overwrite db entry

ID=7; % neuronID
subj='231'; thrV=[-Inf 0.25 2]; included=1.25;channels = 1; q=4; anesth= 1.25;
db=db.addSingleUnit(subj,ID,channels,'spatial sta broken... not worth rescuing',{...
    [806:830], q,included,thrV,anesth,'gwn';...
    [831:832], q,included,thrV,anesth,'NAT GRATING';...
    [834:836], q,included,thrV,anesth,'fffc';...
    [853]    , q,included,thrV,anesth,'sf  - WORTH ANALYZING'},[],true)

db.save;


                        
                        %%
                        
                          ID=9;
            subj='231'; thrV=[-Inf .2 2]; included=1;channels = 1;  q=2; anesth= 1.25;
            db=db.addSingleUnit(subj,ID,channels,'',{...
                [956:960], q,included,thrV,anesth,'gwn';...
                [965], q,included,thrV,anesth,'sf, some drops';...
                [967], q,included,thrV,anesth,'or, some drops';...
                [969:983], q,included,thrV,anesth,'bin 6x8, some drops';...
                [995:1009], q,included,thrV,anesth,'fffc, background firing rate modulation - java mem. NEED TO TURN OFF SOME PLOTS TO SEE IT';...
                [1011:1012], q,included,thrV,anesth,'nat gratings';...
                [1022:1027], q,included,thrV,anesth,'bin6x8 - eyes prob stable';...
                [1053:1063], q,included,thrV,anesth,'bin12x16'},[],true)
            
 db.save;
            db.data{db.numNeurons}=db.data{db.numNeurons}.addComment('drifting on trials: 1056,1062 (prob others too, but def those)');
            db.data{db.numNeurons}=db.data{db.numNeurons}.addComment('SNR decreases after trial 1074 making it challenging to detect and sort spikes');
