function db=addMorePmmNeurons(db,lastUsedID)

%set it
ID=lastUsedID;

%now start adding


% ID=ID+1;
% subj = '164'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=NaN;
% db=db.addSingleUnit(subj,ID,channels,'',{...
%     [591:648],NaN,included,thrV, anesth,'spatial bin';...
%     [654:680],NaN,included,thrV, anesth,'bipartiteLoc=0.9';...
%     [692:730],NaN,included,thrV, anesth,'bin'});
%       
% ID=ID+1;
% subj = '131dev'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=NaN;
% db=db.addSingleUnit(subj,ID,channels,'',{...
%     [132:139],NaN,included,thrV, anesth,'unknown'});
% 
% ID=ID+1;
% subj = '131dev'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=NaN;
% db=db.addSingleUnit(subj,ID,channels,'',{...
%     [184],NaN,included,thrV, anesth,'TRF';...
%         [264:320],NaN,included,thrV, anesth,'off screen?';...
%         [363:378],NaN,included,thrV, anesth,'spatial sta';...
%         [382:393],NaN,included,thrV, anesth,'small sta'});
% 
% ID=ID+1;
% subj = '131dev4'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=NaN;
% db=db.addSingleUnit(subj,ID,channels,'',{...
%     [40:181],NaN,included,thrV, anesth,'many stims, iso off at trial 70'})

ID=ID+1;
subj = '261'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [40],NaN,included,thrV, anesth,'sf'})
db.data{db.numNeurons}=db.data{db.numNeurons}.addComment('cell range [39 to 77]');


% ID=ID+1;
% subj = '261'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
% db=db.addSingleUnit(subj,ID,channels,'',{...
%     [181 186 187:188 197:200],NaN,included,thrV, anesth,'ffgwn';...  % not visual?
%     [205],NaN,included,thrV, anesth,'gratings'})


ID=ID+1;
subj = '249'; thrV=[-0.1 Inf .4]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [42 43:50 60:70],NaN,included,thrV, anesth,'ffgwn';...
    [78 95],NaN,included,thrV, anesth,'gratings'})
        
ID=ID+1;
subj = '249'; thrV=[-0.05 Inf .3]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [523:554],NaN,included,thrV, anesth,'ffgwn'})


ID=ID+1;
subj = '249'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,' not pursuing some more cells on this rat, with horix & vert noise bars, slow gratings at 423 plus',{...
    [187:190],NaN,included,thrV, anesth,'gratings';...
    [192:225],NaN,included,thrV, anesth,'wn'})
%    [160:185],NaN,included,thrV, anesth,'varaious bars mixed';...

ID=ID+1;
subj = '250'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [178:190],NaN,included,thrV, anesth,'sf?';...
    [211:215],NaN,included,thrV, anesth,'sf?';...
    [420:428 432:465],NaN,included,thrV, anesth,'ffgwn'})

ID=ID+1;
subj = '250'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [478],NaN,included,thrV, anesth,'flanker, 256 ppc well centered, with good annulus precending it; useThisMonitorsUncorrectedGamma;  p.rangeOfMonitorLinearized=[0.0 1]';...
    [496],NaN,included,thrV, anesth,'flanker, 64 ppc, 3lambda well, gaussian';...
    [502],NaN,included,thrV, anesth,'confirm annulus blocks';...
    [507],NaN,included,thrV, anesth,'target flanker contrast'})


% ID=ID+1;
% subj = '138'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=0;
% db=db.addSingleUnit(subj,ID,channels,'no cell just eyes',{...
%     [8:19],NaN,included,thrV, anesth,'ffwgn while rat awak and no duc messing'})

ID=ID+1;
subj = '138'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=2.0;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [25:29],NaN,included,thrV, anesth,'ffwgn';...
    [37:47],NaN,included,thrV, anesth,'sf,very broad drives it ... but this shows up as checker, so where is it?'})

ID=ID+1;
subj = '138'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [138:143],NaN,included,thrV, anesth,'ffgwn';...
    [185],NaN,included,thrV, anesth,'flankers... does not drive very well'})

%not doing rat 252's v1, trials 9-155, not sure about 162-194
% ID=ID+1;
% subj = '252'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=NaN;
% db=db.addSingleUnit(subj,ID,channels,'V1?',{...
%     [162 169],NaN,included,thrV, anesth,'ffgwn  ... has STA';...
%     [171],NaN,included,thrV, anesth,'sf gratings square';...
%     [187],NaN,included,thrV, anesth,'% sf gratings sine; nolens'})
% 
% ID=ID+1;
% subj = '252'; thrV=[-0.05 Inf 2]; included=1; channels = 1; anesth=NaN;
% db=db.addSingleUnit(subj,ID,channels,'v1?',{...
%     [191:194],NaN,included,thrV, anesth,'sf gratings sine; nolens ; '})

ID=ID+1;
subj = '252'; thrV=[-0.1 Inf 2]; included=0; channels = 1; anesth=0.75;
db=db.addSingleUnit(subj,ID,channels,'LGN. i think there are 2 spikes.  tricky sort',{...
    [222],NaN,included,thrV, anesth,'flContrasts- HAS THE LENS - longer mean screen gap [200 220]';...
    [199:209],NaN,included,thrV, anesth,'sf gratings sine; nolens ; '})
%maybe 478 is sf? its a grating

ID=ID+1;
subj = '253'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'lens 40D',{...
    [72 75],NaN,included,thrV, anesth,'ffgwn';...
    [85 95],NaN,included,thrV, anesth,'6 X 8 spatial binary';...
    [102 103],NaN,included,thrV, anesth,'flankersMatter fast';...
    [106],NaN,included,thrV, anesth,'flankersMatter slow <? 128ppc';...
    [90 92 94 95 97:101],NaN,included,thrV, anesth,'flankerMattersOnePhase slow  180 ppc';...
    [156],NaN,included,thrV, anesth,'flankerMatters... all colin WORTH ANALYZING ...why do i find a whitenoise Stim?  157?'})
% SUMMARY OF THIS CELL:  RF is dirrectly in front of rat... but seems
%     monocular, decent SNR 2.5 with very few other spikes.  localized with
% 40D, above the rat about 50 deg elev, flashed target onset drives it,
% though only 1-2 spikes per flash.  flanker are just a little bit off
% the screen.  flanks are well away from the boundary determined by
% annuli,  grating drives it well, and totally turns off for a region
% located about in the middle of the screen.  gathered "matters" and
% "contrast" for flanker, using the slow method including 2 sec delays
%     between flashes.  eye is definitely open the whole time, and remains
%     eye tracked with little noise jitter,  all settings and distance are
%     confirmed correct , pix per cyc is 180, and phase is pi/2 such that
%     one broad white square stripe is in the centre of the gaussian mask,
%     and two dark lobes beside it.  monitor is not linearized


ID=ID+1;
subj = '230'; thrV=[-0.05 Inf 2]; included=1;channels = 4;anesth=1.5;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [16],NaN,included,thrV, anesth,'gratings';...
    [17:33],NaN,included,thrV, anesth,'whiteNoise';...
    [],NaN,included,thrV, anesth,''})


ID=ID+1;
subj = '357'; thrV=[-0.07 Inf 2]; included=1;channels = 9; anesth=1.25;
db=db.addSingleUnit(subj,ID,channels,'16 chans here...lead 3 and 11 also might be reasonable',{...
    [23:32],NaN,included,thrV, anesth,'ffgwn';...
    [48:43 51:65],NaN,included,thrV, anesth,'bin6x8';...
    [],NaN,included,thrV, anesth,''})

ID=ID+1;
subj = '357'; thrV=[-0.05 Inf 2]; included=1;channels = 10; anesth=1.25;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [171:181],NaN,included,thrV, anesth,'ffgwn  % 2 clusters,  should be visual... but no sta?';...
    [199:205],NaN,included,thrV, anesth,'bin6x8'})

ID=ID+1;
subj = '357'; thrV=[-0.1 Inf 2]; included=1;channels = 2; anesth=1.25;
db=db.addSingleUnit(subj,ID,channels,'',{...
    [226:230],NaN,included,thrV, anesth,'ffgwn';...
    [236:238],NaN,included,thrV, anesth,'bin6x8'})

%subjectID = '356'; channels={[10]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc - probably 2 cells lumped into 1 anay   


%subjectID = '303';cellBoundary={'trialRange',[1 27 ]}  ignored... what trial breaks?
%subjectID = '305'; channels={1}; cellBoundary={'trialRange',[100]};% ???
