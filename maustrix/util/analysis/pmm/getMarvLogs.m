function eventLog=getMarvLogs()

eventNum = 0;
eventLog=[];

% lastEvent=eventLog{end}
% details=eventLog{end}.details

%% sample

eventNum = eventNum +1;  %good format
eventLog{eventNum}.date =datenum('Dec.12,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'rat_138'};
eventLog{eventNum}.stationID =2;
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='low body weight for 7 days'; 
eventLog{eventNum}.details.from =[1];
eventLog{eventNum}.details.to =[2];


%% events

eventNum = eventNum +1; %bad format --now good? yes
eventLog{eventNum}.date =datenum('Dec.12,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'rat_141'};
eventLog{eventNum}.stationID =3;
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='low body weight'; 
eventLog{eventNum}.details.from =[3];
eventLog{eventNum}.details.to =[4];


eventNum = eventNum +1; %bad format
eventLog{eventNum}.date =datenum('Dec.14,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_138','rat_139','rat_140','rat_141','rat_142','rat_143','rat_144','rat_145','rat_146','rat_147','rat_148'};
eventLog{eventNum}.stationID ={'2','2','3','3','3','3','3','11','11','11','11','11'};
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='all need to learn more stringent; 141 uniquely found at 4000 msPenalty'; 
eventLog{eventNum}.details.from ='1000';
eventLog{eventNum}.details.to ='10000';

eventNum = eventNum +1;  %bad format
eventLog{eventNum}.date =datenum('Dec.14,2007');%datestr(now,21)
eventLog{eventNum}.eventName ='penaltyIncrease';
eventLog{eventNum}.subject ={'rat_136','rat_137'};
eventLog{eventNum}.stationID ={'4','4'};
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='b/c'; 
eventLog{eventNum}.details.from ='1000';
eventLog{eventNum}.details.to ='4000';

eventNum = eventNum +1; %good format
eventLog{eventNum}.date =datenum('Dec.15,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'rat_132'};
eventLog{eventNum}.stationID =2;
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='dangerously below body weight threshold'; 
eventLog{eventNum}.details.from =[1];
eventLog{eventNum}.details.to =[3];  

eventNum = eventNum +1; %okay
eventLog{eventNum}.date =datenum('Dec.16,2007');%datestr(now,21)
eventLog{eventNum}.eventName ='ratrixDowwn';
eventLog{eventNum}.subject ='rat_128';
eventLog{eventNum}.stationID ='2';
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='ratrix down on 12-15-07, no stations working except middle left #1, according to Aria,corrected error of missing bracket line 90'; 
eventLog{eventNum}.details.from ='subject {i.';
eventLog{eventNum}.details.to ='subject {i.}';


eventNum = eventNum +1; %bad format, see below --pmm
eventLog{eventNum}.date =datenum('Dec.17,2007');%datestr(now,21)
eventLog{eventNum}.eventName ='rewardIncrease';
eventLog{eventNum}.subject ={'rat_132' ,'rat_133','rat_138','rat_139','rat_128'};
eventLog{eventNum}.stationID =2; %E
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='station is weak in water flow reward & rats are all below body weight threshold'; 
eventLog{eventNum}.details.from =[1,1,2,1,1];
eventLog{eventNum}.details.to =[4,4,4,4,4];  
eventLog{eventNum}.eventName ='penaltyDecrease';
eventLog{eventNum}.details.from =[10000,10000,10000,10000,10000];
eventLog{eventNum}.details.to =[4000,4000,4000,4000,4000];


%this is a good sample for multi rat, multi feature
eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Dec.17,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease','penaltyDecrease'};
eventLog{eventNum}.subject ={'rat_134', 'rat_135', 'rat_137'};
eventLog{eventNum}.stationID =4; %F
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='several days below body weight threshold'; 
eventLog{eventNum}.details.from =[1, 1, 1; 10000,10000,10000];
eventLog{eventNum}.details.to   =[5, 5, 4; 4000,  4000, 4000];  

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Dec.17,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease', 'penaltyDecrease'};
eventLog{eventNum}.subject =    {'rat_143'};
eventLog{eventNum}.stationID =3; %A
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='several days below body weight threshold'; 
eventLog{eventNum}.details.from =[3;10000];
eventLog{eventNum}.details.to   =[4; 4000];  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Dec.17,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease', 'penaltyDecrease'};
eventLog{eventNum}.subject =   {'rat_145, rat_148'};
eventLog{eventNum}.stationID =11; %B
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='several days below body weight threshold'; 
eventLog{eventNum}.details.from ='3,10000; 3,10000';
eventLog{eventNum}.details.to   ='4, 4000; 4, 4000';  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Dec.17,2007');%datestr(now,21)
eventLog{eventNum}.eventName ='penaltyDecrease';
eventLog{eventNum}.subject =    'rat_115';
eventLog{eventNum}.stationID =9; %D
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='several days below body weight threshold'; 
eventLog{eventNum}.details.from ='10000';
eventLog{eventNum}.details.to   =' 4000'; 

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Dec.19,2007');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease', 'penaltyDecrease'};
eventLog{eventNum}.subject =     'rat_132, rat_133';
eventLog{eventNum}.stationID =2; %E 
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='additional change since station E appears not to respond to previous changes to increase reward & decrease penalty '; 
eventLog{eventNum}.details.from ='4, 4000; 4, 4000';  
eventLog{eventNum}.details.to   ='6, 2000; 6, 2000';  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Jan.16,2008');%datestr(now,21)
eventLog{eventNum}.eventName ='rewardDecrease';
eventLog{eventNum}.subject =  'rat_138';
eventLog{eventNum}.stationID =2; %E
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='above thresh, only 150 trials/day'; 
eventLog{eventNum}.details.from ='6';  
eventLog{eventNum}.details.to   ='3';  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Jan.16,2008');%datestr(now,21)
eventLog{eventNum}.eventName ='rewardDecrease';
eventLog{eventNum}.subject =  'rat_137';
eventLog{eventNum}.stationID =4; %F
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='above thresh, only 250 trials/day'; 
eventLog{eventNum}.details.from ='4';  
eventLog{eventNum}.details.to   ='3';  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Jan.16,2008');%datestr(now,21)
eventLog{eventNum}.eventName ='rewardDecrease';
eventLog{eventNum}.subject =  'rat_139';
eventLog{eventNum}.stationID =2; %these MUST be numbers!, you can comment letters after (see above)
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='above thresh, only 250 trials/day'; 
eventLog{eventNum}.details.from ='6';  
eventLog{eventNum}.details.to   ='4';  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Jan.17,2008 08:19:22');%datestr(now,21)
eventLog{eventNum}.eventName ='lightChange';
eventLog{eventNum}.subject =  'all in B228';
eventLog{eventNum}.stationID ='all in B228'; %these MUST be numbers!, you can comment letters after (see above)
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='changed (probably by 8am, def by 1pm)when I talked to Mike, maybe more changes, pending protocol...'; 
eventLog{eventNum}.details.from ='flourcent cycling by vivarium staff';  
eventLog{eventNum}.details.to   ='emergency only';  

eventNum = eventNum +1; %bad format --pmm
eventLog{eventNum}.date =datenum('Jan.18,2008 15:19:22');%datestr(now,21)
eventLog{eventNum}.eventName ='cockpitChange';
eventLog{eventNum}.subject =  'all in station 1';  %bad
eventLog{eventNum}.stationID =[1]; %these MUST be numbers!, you can comment letters after (see above)
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='all rats in the station had a strong left bias, also right water tube was found chewed and needed replacing. square hole for right eye created a new tube just like old.'; 
eventLog{eventNum}.details.from ='one tube';  
eventLog{eventNum}.details.to   ='another tube'; 

%marv - could you make sure to use good format, and change the ones with
%bad format? thx -pmm 080116

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Jan.30,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject =    {'rat_137','rat_143','rat_145','rat_148'};
eventLog{eventNum}.stationID =[4 3 11 11]; %A
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='prob wont''t learn with that fast penalty'; 
eventLog{eventNum}.details.from =[4000];
eventLog{eventNum}.details.to   =[10000];  

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Jan.30,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject =    {'rat_132','rat_133'};
eventLog{eventNum}.stationID =[2 2]; %A
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='prob wont''t learn with that fast penalty, stuck at full flankers'; 
eventLog{eventNum}.details.from =[2000];
eventLog{eventNum}.details.to   =[10000];  


eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.02,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'lightingChange'};
eventLog{eventNum}.subject =  {'rat_140','rat_141','rat_142','rat_143','rat_144'};
eventLog{eventNum}.stationID =[3]; %A
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='top station sees more room lights, trashbag while aria builds a better cape'; 
eventLog{eventNum}.details.from ='no cover';
eventLog{eventNum}.details.to   ='trash bag'; 

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.03,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'reinitializeRatrix'};
eventLog{eventNum}.subject =  {};
eventLog{eventNum}.stationID =[1 2 3 4 9 11]; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='added in v1_3 and v1_4 with no horizontal stims, mostly effect rats on stations 1, 2, 4 but re-inited all 6'; 
eventLog{eventNum}.details.from =[];
eventLog{eventNum}.details.to   =[];  

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.08,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'schedulerChange'};
eventLog{eventNum}.subject =  {};
eventLog{eventNum}.stationID =[1 2 3 4 9 11]; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='all rats running 90 minutes sessions'; 
eventLog{eventNum}.details.from ='noTimeOff - about 2 hours for most rats, way more for overnighters';
eventLog{eventNum}.details.to   ='90 minutes';  

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.09,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'lightingChange'};
eventLog{eventNum}.subject =  {'rat_140','rat_141','rat_142','rat_143','rat_144'};
eventLog{eventNum}.stationID =[3]; %A
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='top station sees more room lights, trashbag while aria builds a better cape'; 
eventLog{eventNum}.details.from ='trash bag';
eventLog{eventNum}.details.to   ='test cape'; 


eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.16,2008 11:45:32');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject =  {'rat_141','rat_145','rat_146'};
eventLog{eventNum}.stationID =[3 11 11]; 
eventLog{eventNum}.issuedBy ='hvo';
eventLog{eventNum}.comment ='not gaining fast enough; 600-900 secs/week'; 
eventLog{eventNum}.details.from =[4 4 3];
eventLog{eventNum}.details.to   =[5 5 5];  

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.17,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'lightingChange'};
eventLog{eventNum}.subject =  {'rat_140','rat_141','rat_142','rat_143','rat_144'};
eventLog{eventNum}.stationID =[3]; %A
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='definitely curtain on by feb 18, maybe aria put it as early as feb 15? cape removed from upper left'; 
eventLog{eventNum}.details.from ='test cape';
eventLog{eventNum}.details.to   ='no cover';   %see next entry

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.17,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'lightingChange'};
eventLog{eventNum}.subject =  {};
eventLog{eventNum}.stationID =[]; %
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='definitely curtain on by feb 18, maybe aria put it as early as feb 15? cape removed from upper left'; 
eventLog{eventNum}.details.from ='no cover';
eventLog{eventNum}.details.to   ='curtain'; 


eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.17,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'lightingChange'};
eventLog{eventNum}.subject =  {};
eventLog{eventNum}.stationID =[]; %
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='definitely curtain on by feb 18, maybe aria put it as early as feb 15? cape removed from upper left'; 
eventLog{eventNum}.details.from ='no cover';
eventLog{eventNum}.details.to   ='curtain'; 

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'protocolChange'};
eventLog{eventNum}.subject =  {'rat_138','rat_139','rat_117'};
eventLog{eventNum}.stationID =[]; %
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='some rats to step one of acuity for cosyne, influenced box 4 dim flankers reset to .1'; 
eventLog{eventNum}.details.from =['setShaping'];
eventLog{eventNum}.details.to   =['setAcuity']; 

eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'moveStation',};
eventLog{eventNum}.subject =  {'rat_127'};
eventLog{eventNum}.stationID =[9]; %F
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='extra experience for head fixing, flunked from 8 to 5, moved to middle right station form previous middle left'; 
eventLog{eventNum}.details.from =[1];
eventLog{eventNum}.details.to   =[9]; 


eventNum = eventNum +1; %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'protocolChange'};
eventLog{eventNum}.subject =  {'rat_135'};
eventLog{eventNum}.stationID =[4]; %
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='changed pixPerCyc from 32 to 64 b/c he sucked at VV for 7+ days'; 
eventLog{eventNum}.details.from =['one param'];
eventLog{eventNum}.details.to   =['another']; 

%
eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease','penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_134', 'rat_135', 'rat_137'};
eventLog{eventNum}.stationID =4; %F
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='chronic poor performance in 135, clear cause and effect'; 
eventLog{eventNum}.details.from =[5, 5, 3; 4000,  4000,10000];  
eventLog{eventNum}.details.to   =[2, 2, 2; 10000,10000,10000];


eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease','penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_137', 'rat_138','rat_139'};
eventLog{eventNum}.stationID =[2]; %?  2  ??E 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='138 and 139 are pretty good and going to sweeps, so only penalty to 6000'; 
eventLog{eventNum}.details.from =[2, 3, 4; 2000, 2000,2000];  
eventLog{eventNum}.details.to   =[2, 2, 2; 10000,6000,6000];

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'rat_144'};
eventLog{eventNum}.stationID =[3]; %A
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='overnighter with slow rise, trying to push him'; 
eventLog{eventNum}.details.from =[3];  
eventLog{eventNum}.details.to   =[1]; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_135','rat_136'};
eventLog{eventNum}.stationID =4; %F
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='gets the task, slow shaping contrast, yet not fast enough'; 
eventLog{eventNum}.details.from =[1000, 4000];  
eventLog{eventNum}.details.to   =[10000,8000];

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'rat_129'};
eventLog{eventNum}.stationID =11; %B=11?  B is known
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='good weight,slightly above chance, pushable'; 
eventLog{eventNum}.details.from =[5];  
eventLog{eventNum}.details.to   =[2]; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'rat_130'};
eventLog{eventNum}.stationID =9; %D=9? D is known
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='good weight,slightly above chance, pushable'; 
eventLog{eventNum}.details.from =[3];  
eventLog{eventNum}.details.to   =[1]; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.18,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease','penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_115'};
eventLog{eventNum}.stationID =9; %D
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='stuck at chance, push some, he''s also an overnighter now'; 
eventLog{eventNum}.details.from =[4, 4000];  
eventLog{eventNum}.details.to   =[2,10000];

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.22,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyDecrease'};
eventLog{eventNum}.subject ={'rat_117','rat_138','rat_139'};
eventLog{eventNum}.stationID =[9 2 2]; %D E E
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='going to get contrast sweep as well as pixPerCycs'; 
eventLog{eventNum}.details.from =[10000,6000,6000];  
eventLog{eventNum}.details.to   =[4000,4000,4000];

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.22,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'rat_117','rat_138','rat_139'};
eventLog{eventNum}.stationID =[9 2 2]; %D E E
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='doing acuity; going to start contrast sweep as well as pixPerCycs'; 
eventLog{eventNum}.details.from =[1,1,1];  
eventLog{eventNum}.details.to   =[2,2,2];

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.23,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'rat_129'};
eventLog{eventNum}.stationID =[11]; %B
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='why found on 2?  returned him to 5, no trials done on 2 while he was in box'; 
eventLog{eventNum}.details.from =[2];  
eventLog{eventNum}.details.to   =[5];

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.25,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'rat_116'};
eventLog{eventNum}.stationID =9; %D=9?
eventLog{eventNum}.issuedBy ='hvo';
eventLog{eventNum}.comment ='dehydrated but not sick, vet agrees, increasing water reward'; 
eventLog{eventNum}.details.from =[2];  
eventLog{eventNum}.details.to   =[4]; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.25,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'monitorRefreshRateChange'};
eventLog{eventNum}.subject ={};
eventLog{eventNum}.stationID =[1 2 3 4 9 11]; %all
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='switch up to 100Hz, not recommended option w/ shitty graphics card'; 
eventLog{eventNum}.details.from =[85,85,85,85,85,60];  
eventLog{eventNum}.details.to   =[100,100,100,100,100,100]; 


eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Feb.28,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'sentinelChange'};
eventLog{eventNum}.subject ={};
eventLog{eventNum}.stationID =[]; %all
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='+/- 3 days; male and female sentinels added to male ratrix room'; 
eventLog{eventNum}.details.from ='no sentinel';  
eventLog{eventNum}.details.to   ='male and female sentinel'; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Mar.4,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'waterChange'};
eventLog{eventNum}.subject ={'rat_112', 'rat_126', 'rat_102','rat_106','rat_196'};
eventLog{eventNum}.stationID =[1]; %C
eventLog{eventNum}.issuedBy ='mrz';
eventLog{eventNum}.comment ='replaced lines, center line leaked, left line port was weak'; 
eventLog{eventNum}.details.from ='bad';  
eventLog{eventNum}.details.to   ='good'; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Mar.10,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'waterChange'};
eventLog{eventNum}.subject ={'rat_127', 'rat_116', 'rat_117','rat_130','rat_115'};
eventLog{eventNum}.stationID =[4]; %F
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='many rats biased right, found left spout unglued & retracted; maybe 40% less water; repositioned it'; 
eventLog{eventNum}.details.from ='right biased';  
eventLog{eventNum}.details.to   ='more equal'; 

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Mar.12,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'monitorRefreshRateChange'};
eventLog{eventNum}.subject ={'rat_112', 'rat_126', 'rat_102','rat_106','rat_196','rat_145', 'rat_146', 'rat_147','rat_148','rat_1929'}; 
eventLog{eventNum}.stationID =[4 1]; %B C
eventLog{eventNum}.issuedBy ='a2c';
eventLog{eventNum}.comment ='found 2 stations at 60Hz, put back to 100Hz'; 
eventLog{eventNum}.details.from =[60,60];  
eventLog{eventNum}.details.to   =[100,100]; 


eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Mar.15,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_117','rat_138','rat_139'};
eventLog{eventNum}.stationID =[9 2 2]; %D E E
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='performance suffered over days, psycho is easier (117) or gone now (138-9)'; 
eventLog{eventNum}.details.from =[4000,4000,4000];  
eventLog{eventNum}.details.to   =[10000,6000,6000];

eventLog{eventNum}.date =datenum('Mar.15,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'changedMean'};
eventLog{eventNum}.subject ={'rat_135'};
eventLog{eventNum}.stationID =[4]; %F
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='still bad at task, maybe its easier with a dark background'; 
eventLog{eventNum}.details.from =[0.5];  
eventLog{eventNum}.details.to   =[0.2];

eventLog{eventNum}.date =datenum('Mar.19,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'changedSensor'};
eventLog{eventNum}.subject ={};
eventLog{eventNum}.stationID =[2]; %E
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='switched physical boxes from 1B to 11E, so that soy has windows'; 
eventLog{eventNum}.details.from ='window';  
eventLog{eventNum}.details.to   ='slot';

eventLog{eventNum}.date =datenum('Mar.19,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'changedSensor'};
eventLog{eventNum}.subject ={}; % all new rats here, start with soy
eventLog{eventNum}.stationID =[11]; %B
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='switched physical boxes from 1B to 11E, so that soy has windows'; 
eventLog{eventNum}.details.from ='slot';  
eventLog{eventNum}.details.to   ='window';

eventLog{eventNum}.date =datenum('Mar.19,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'changedRewardType'};
eventLog{eventNum}.subject ={}; % all new rats here, start with soy
eventLog{eventNum}.stationID =[11]; %B % top right
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='controlled with brothers on water on top left'; 
eventLog{eventNum}.details.from ='water';  
eventLog{eventNum}.details.to   ='soy';

eventLog{eventNum}.date =datenum('Apr.9,2008');%datestr(now,21) % happened a few days before this but rats were not running yet
eventLog{eventNum}.eventName ={'lightingChange'};
eventLog{eventNum}.subject ={}; % all new rats here, start with soy
eventLog{eventNum}.stationID ={'1A', '1B', '1C', '1D', '1E', '1F'}; %all
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='day light comes on from 12 to 8, but it might be an hour off from daylight savings'; 
eventLog{eventNum}.details.from ='curtain';  % SamH says the old standard was 'the lights cycle at 7am to 9pm' since the vivarium opened in 1993
eventLog{eventNum}.details.to   ='phaseShifted';

eventLog{eventNum}.date =datenum('Apr.10,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'softwareChange'};
eventLog{eventNum}.subject ={}; % all new rats here, start with soy
eventLog{eventNum}.stationID ={'1A', '1B', '1C', '1D', '1E', '1F'}; %all
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='most debugged merged network code, about 60% of rats run daily'; 
eventLog{eventNum}.details.from ='maleCode';  %svn pmeier branch
eventLog{eventNum}.details.to   ='merge20080324'; %rev ~900-956

eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Apr.17,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject ={'rat_231','rat_238','rat_241','rat_242'};
eventLog{eventNum}.stationID ={'1C' '1F' '1E' '1F'}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='doing hundreds of trials were set to 1000, but it appeared to be 1ms'; 
eventLog{eventNum}.details.from =[1000,1000,1000,1000];  
eventLog{eventNum}.details.to   =[6000,6000,6000,6000];


eventNum = eventNum +1;  %good format --pmm
eventLog{eventNum}.date =datenum('Apr.17,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'flunked'};
eventLog{eventNum}.subject ={'223','226','rat_230','233','234','240'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='marv noted they have a hard time... backing up to '; 
eventLog{eventNum}.details.from =[4,4,4,4,4,4];  %or 5
eventLog{eventNum}.details.to   =[3,3,3,3,3,3];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'102'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='only 75% correct, 250 trials a day, rate 4 times slower in second half of session'; 
eventLog{eventNum}.details.from =[2]; 
eventLog{eventNum}.details.to   =[1];


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'flunked'};
eventLog{eventNum}.subject ={'135'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='at chance, exploiting CTs, 300 trials a day, flunked to higher contrast, but moved from expt. 1 to expt. 2, now all flankers vertical like the target'; 
eventLog{eventNum}.details.from =[13]; 
eventLog{eventNum}.details.to   =[14]; %even that he's moving up in expt. still considered a flunk, because contrast of target increased 



eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'135'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='trying to get him to change strategy, bw stably increased like healthy rat, but consistently at 77% of normalized '; 
eventLog{eventNum}.details.from =[2]; 
eventLog{eventNum}.details.to   =[1.5]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'138'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='slow 10 days recovery from bad 4 day at chance fullFlanker experience, bw increasing and above 85%, currently ~75% correct'; 
eventLog{eventNum}.details.from =[2]; 
eventLog{eventNum}.details.to   =[1]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'139'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='hugging 80-85% correct, juicy rewards, oddly many correction trials (>60%!)'; 
eventLog{eventNum}.details.from =[2]; 
eventLog{eventNum}.details.to   =[1]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'penaltyIncrease'};
eventLog{eventNum}.subject ={'237'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='stuck on step 5, while brothers on 9, large oscillation around 75% correct'; 
eventLog{eventNum}.details.from =[1000]; 
eventLog{eventNum}.details.to   =[6000]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'233'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='very good but too few trials per day, about 200 at 90% correct ... but overnight in 3 sessions'; 
eventLog{eventNum}.details.from =[1]; 
eventLog{eventNum}.details.to   =[.6];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'137'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='stable bw, performance just below 85% correct, very few trials all in the beginning'; 
eventLog{eventNum}.details.from =[2]; 
eventLog{eventNum}.details.to   =[1]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.24,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'117'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='no more acuity; back to basic tilt discrim. why? performance at chance, left bias, dropping bw slowly, increasing ct exploitation, contrast [0 0.125 0.25 0.5 0.75 1], pixperCycs [4 8 16 32 64 128],  '; 
eventLog{eventNum}.details.from =[2]; 
eventLog{eventNum}.details.to   =[6]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.27,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualProtocolChange'};
eventLog{eventNum}.subject ={'229','230','233','234','237','238','227','228','231','232','138','139'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='target gets dimmer on step 10, all these detection rats now have flankers, and the orients will include diagonals (prev just HV flanks, 4 orient targets))'; 
eventLog{eventNum}.details.from ='1_1'; 
eventLog{eventNum}.details.to   ='1_6'; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.27,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'uncomfortableMedicalIntervention'};
eventLog{eventNum}.subject ={'102'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='dime-size abcess popped by catherine, fluff cage, recommends daily irrigation for a week.'; 
eventLog{eventNum}.details.from ='lump'; 
eventLog{eventNum}.details.to   ='openWound'; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.30,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'flunked'};
eventLog{eventNum}.subject ={'137','139'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='full flankers are too hard, esp with a dim target (0.3)'; 
eventLog{eventNum}.details.from =[10]; 
eventLog{eventNum}.details.to   =[9]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.05,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualProtocolChange'};
eventLog{eventNum}.subject ={'144'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='swicthed from +/-45 to +-30; might as well synchronize while he sucks, currently at chance and upside down for many months'; 
eventLog{eventNum}.details.from ='1_1'; 
eventLog{eventNum}.details.to   ='2_0'; %has size shaping

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.05,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualProtocolChange'};
eventLog{eventNum}.subject ={'130'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='added shrinking stim capacity for the next step (8). he''s on 7, oddly his performance plummeted the day BEFORE this change'; 
eventLog{eventNum}.details.from ='1_0'; 
eventLog{eventNum}.details.to   ='2_0'; %has size shaping

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.05,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualProtocolChange'};
eventLog{eventNum}.subject ={'117'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='added shrinking stim capacity for an upcoming step (8). he''s on 6, recouping from acuity sweeps'; 
eventLog{eventNum}.details.from ='1_0'; 
eventLog{eventNum}.details.to   ='2_0'; %has size shaping

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.11,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'wrongRat'};
eventLog{eventNum}.subject ={'234','240'};
eventLog{eventNum}.stationID ={'1B','1F'}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='240 and 234 were switched with each other in the violate heat of 6/11/08, alee mistake'; 
eventLog{eventNum}.details.from =''; 
eventLog{eventNum}.details.to   =''; 



eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Oct.10,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'231','233'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='contrastSweep to try to get threshold effect, force graduation to step 12 v2_3, includes flanksToggleToo, [0.2,0.4,0.6.,0.8,1], 231 was on step 10.7, had. 1.0 rewards whole life; 233 was on step 9.4,  had. 0.6 rewards many months'; 
eventLog{eventNum}.details.from =[10 9]; 
eventLog{eventNum}.details.to   =[12 12]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Oct.10,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'removeCTs'};
eventLog{eventNum}.subject ={'138','139','227','228'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='see if they improve task performance w/o CT exploitation'; 
eventLog{eventNum}.details.from =''; 
eventLog{eventNum}.details.to   =''; 


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Oct.25,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'increasedPenalty'};
eventLog{eventNum}.subject ={'227','228','229','234','237','274'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='see if they improve task performance'; 
eventLog{eventNum}.details.from = [1000 1000 1000 1000 6000 1000]; 
eventLog{eventNum}.details.to   = [10000 10000 10000 10000 10000 10000];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.14,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'flunked'};
eventLog{eventNum}.subject ={'102'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='veryify that he still tries, commonly his eyes are closed, task is easy'; 
eventLog{eventNum}.details.from = [12]; %varyPosition
eventLog{eventNum}.details.to   = [8];  %no flankers, small, full contrast

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.14,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'102'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='bodyweight has been steadily dropping, off charts: too old to know what thresh is'; 
eventLog{eventNum}.details.from = [1]; 
eventLog{eventNum}.details.to   = [2];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.14,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'231','234','274',  '138','139','228','232','233',  '227','229','230','237','229'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='data collection mode, noCTs, noMaxCorrectSide, noToggleTargetOnly, 14= orientSweep, 13=positionSweep, 11=0.4flanks&0.75target'; 
eventLog{eventNum}.details.from = [12 7  10 10 9  9  10 12 9  10 11 10 9 ]; % rat 234 was rapid, step 7==10, all others standard, some came from contrast sweep==2
eventLog{eventNum}.details.to   = [14 14 14 13 13 13 13 13 11 11 11 11 11];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.14,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'removeCTs'};
eventLog{eventNum}.subject ={'137'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment =''; 
eventLog{eventNum}.details.from = [0.5]; 
eventLog{eventNum}.details.to   = [0];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.14,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'137','228'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='bodyweight trending low, sarah''s observation'; 
eventLog{eventNum}.details.from = [1]; 
eventLog{eventNum}.details.to   = [1.5];  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Dec.1,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'304','306'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  % daniel's help
eventLog{eventNum}.comment ='304 stuck on step 3 for 2 days, 100''s of trials. 306 did some trial on step 2 for 4 days and then spent a whole day without triggering'; 
eventLog{eventNum}.details.from = [3 2]; 
eventLog{eventNum}.details.to   = [4 3];  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.29,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'stationBiasStarted'};
eventLog{eventNum}.subject ={'285','225','227','229','231','233'};
eventLog{eventNum}.stationID ={'1A'}; 
eventLog{eventNum}.issuedBy ='pmm';  % daniel's help
eventLog{eventNum}.comment ='left port leaks in the back, rats have bias to right'; 
eventLog{eventNum}.details.from = []; 
eventLog{eventNum}.details.to   = [];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Dec.01,2008');%datestr(now,21)
eventLog{eventNum}.eventName ={'stationBiasFixed'};
eventLog{eventNum}.subject ={'285','225','227','229','231','233'};
eventLog{eventNum}.stationID ={'1A'}; 
eventLog{eventNum}.issuedBy ='pmm';  % daniel's help
eventLog{eventNum}.comment ='clog was fixed, but might come back if needle is loose'; 
eventLog{eventNum}.details.from = []; 
eventLog{eventNum}.details.to   = [];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Dec.10,2008');%datestr(now,21)  % attempted change at 'Dec.02,2008', but failed to impliment it till now
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'274'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah's help
eventLog{eventNum}.comment ='grumpy rat at chance, sarah thinks its dehydration'; 
eventLog{eventNum}.details.from = [1]; 
eventLog{eventNum}.details.to   = [2];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('July.10,2008');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'cockPitChange'};
eventLog{eventNum}.subject ={}; %102, 117, etc...
eventLog{eventNum}.stationID ={'1C'}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah's help
eventLog{eventNum}.comment ='discovered Jan. 16 2009, eyehole may have changed half a year ago'; 
eventLog{eventNum}.details.from = 'hasEyeHole'; 
eventLog{eventNum}.details.to   = 'standard';  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('July.10,2008');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'moveStation'};
eventLog{eventNum}.subject ={}; %102, 117, etc...
eventLog{eventNum}.stationID ={'1C'}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah's help
eventLog{eventNum}.comment ='1C is down, rats moved to 1D, keeping same cockpit'; 
eventLog{eventNum}.details.from = '1C'; 
eventLog{eventNum}.details.to   = '1D';  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('July.28,2008');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'stationBias'};
eventLog{eventNum}.subject ={'230','232'}; %102, 117, etc...
eventLog{eventNum}.stationID ={'1B'}; 
eventLog{eventNum}.issuedBy ='pmm';  % yuli's help
eventLog{eventNum}.comment ='problem started this day and fixed this day; see email from yuli'; 
eventLog{eventNum}.details.from = 'normal'; 
eventLog{eventNum}.details.to   = 'left side unplugged';  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.11,2009');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'startCarrots'};
eventLog{eventNum}.subject ={'304'}; %102, 117, etc...
eventLog{eventNum}.stationID ={'3G'}; 
eventLog{eventNum}.issuedBy ='pmm';  % alee identified
eventLog{eventNum}.comment ='body weight at 85%.  rat learned slow despite no carrots.  now finnaly learning.  should see if learning stops/ slows'; 
eventLog{eventNum}.details.from = 'noCarrots'; 
eventLog{eventNum}.details.to   = 'dailyCarrots';  

%%%

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.17,2009');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'130','230','234'}; %102, 117, etc...
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah identified
eventLog{eventNum}.comment ='long term lowish body weight, '; 
eventLog{eventNum}.details.from = [1 1 1]; 
eventLog{eventNum}.details.to   = [1.5 1.5 1.5];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.17,2009');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'flunked'};
eventLog{eventNum}.subject ={'102'}; 
eventLog{eventNum}.stationID ={'1C'}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='confirm old rat not blind'; 
eventLog{eventNum}.details.from = [8]; 
eventLog{eventNum}.details.to   = [6];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.17,2009');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'275'}; %102, 117, etc...
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah identified
eventLog{eventNum}.comment ='falling to chance'; 
eventLog{eventNum}.details.from = [1 ]; 
eventLog{eventNum}.details.to   = [0.75];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.17,2009');%datestr(now,21)  % attempted change at 'Dec.02,2008', 
eventLog{eventNum}.eventName ={'rewardDecrease'};
eventLog{eventNum}.subject ={'275'}; %102, 117, etc...
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah identified
eventLog{eventNum}.comment ='falling to chance'; 
eventLog{eventNum}.details.from = [1 ]; 
eventLog{eventNum}.details.to   = [0.75];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Mar.09,2009');%datestr(now,21)  %written on 'Mar.09,2009'  will take effect when on trunk only, in a few days 
eventLog{eventNum}.eventName ={'rewardIncrease'};
eventLog{eventNum}.subject ={'139','229','232','234','237'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah identified 139 & 229
eventLog{eventNum}.comment ='all above chance perf, and could use a little BW help.  139 could use much help'; 
eventLog{eventNum}.details.from = [1, 1  , 1  , 1.5, 1  ]; 
eventLog{eventNum}.details.to   = [2, 1.5, 1.5, 2  , 1.5];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Mar.12,2009');%datestr(now,21)  % %written on 'Mar.09,2009'  will take effect when on trunk only, in a few days 
eventLog{eventNum}.eventName ={'removeCTs'};
eventLog{eventNum}.subject ={'275','277','278'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='all exploit CTs, but varying perf:  275 & 277 just lost perf, 278 has been at chance'; 
eventLog{eventNum}.details.from = [0.5]; 
eventLog{eventNum}.details.to   = [0];  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Mar.18,2009');%datestr(now,21)  % %written on 'Mar.18,2009'  will take effect, in a few days on rebuild but may have been off on rck1temp and then back to .25 on tag. 1.0.1 on april 9thd
eventLog{eventNum}.eventName ={'addCTs'};
eventLog{eventNum}.subject ={'275'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='crazy bias when we removed them, exploits them at 50%... try inbetween'; 
eventLog{eventNum}.details.from = [0]; 
eventLog{eventNum}.details.to   = [0.25];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Mar.15,2009');%datestr(now,21)  % %written on 'Mar.19,2009'  started a few days ago
eventLog{eventNum}.eventName ={'badBias'};
eventLog{eventNum}.subject ={'275'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm'; % sarah lets me know
eventLog{eventNum}.comment ='many rats get a bad bias after long inter trials hits them'; 
eventLog{eventNum}.details.from = []; 
eventLog{eventNum}.details.to   = [];  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Mar.27,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'startCarrots'};
eventLog{eventNum}.subject ={'139'}; %102, 117, etc...
eventLog{eventNum}.stationID ={''}; 
eventLog{eventNum}.issuedBy ='pmm';  % sarah identified
eventLog{eventNum}.comment ='dropped BW to ~80%, stabalized with h20 rewards 2-3 wks, now trying to bring back up'; 
eventLog{eventNum}.details.from = 'noCarrots'; 
eventLog{eventNum}.details.to   = 'dailyCarrots';  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Apr.09,2009');%datestr(now,21)  % %written on 'Mar.18,2009'  will take effect, in a few days on rebuild but may have been off on rck1temp and then back to .25 on tag. 1.0.1 on april 9thd
eventLog{eventNum}.eventName ={'addCTs'};
eventLog{eventNum}.subject ={'275,237'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='crazy bias on 237, 275 reimplimenting what it should be.  maybe one day off'; 
eventLog{eventNum}.details.from = [0.25 0]; 
eventLog{eventNum}.details.to   = [0.25 0.25]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Apr.06,2009');%datestr(now,21)  % %written on 'Mar.18,2009'  will take effect, in a few days on rebuild but may have been off on rck1temp and then back to .25 on tag. 1.0.1 on april 9thd
eventLog{eventNum}.dateConfidence =10;  %+/-days
eventLog{eventNum}.eventName ={'codeChange'};
eventLog{eventNum}.subject ={'275,237'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='was on trunk breifly for a week about 2 weeks ago'; 
eventLog{eventNum}.details.from = 'rack1temp'; 
eventLog{eventNum}.details.to   = 'tag1.0.1'; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Apr.06,2009');%datestr(now,21)  % %written on 'Mar.18,2009'  will take effect, in a few days on rebuild but may have been off on rck1temp and then back to .25 on tag. 1.0.1 on april 9thd
eventLog{eventNum}.dateConfidence =10;  %+/-days
eventLog{eventNum}.eventName ={'computerChange'};
eventLog{eventNum}.subject ={'all pmm male'};
eventLog{eventNum}.stationID ={'1D','1E','1F','1H','1I'}; %J is down now, it woulf be beige 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='in order to minimize frame drops for future non-toggle'; 
eventLog{eventNum}.details.from = 'beige'; 
eventLog{eventNum}.details.to   = 'black'; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Apr.16,2009');%datestr(now,21)  % %written on 'Mar.18,2009'  will take effect, in a few days on rebuild but may have been off on rck1temp and then back to .25 on tag. 1.0.1 on april 9thd
eventLog{eventNum}.eventName ={'addCTs'};
eventLog{eventNum}.subject ={'138'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='alternates sides eventually, but has a same side bias... had it for weeks/months, performance is down in the past 2/3 weeks '; 
eventLog{eventNum}.details.from = [0]; 
eventLog{eventNum}.details.to   = [0.25]; 


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.02,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'increaseReward'};
eventLog{eventNum}.subject ={'296', '304', '305', '306'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='hard time with brief stim, BW dropping'; 
eventLog{eventNum}.details.from = [.2]; 
eventLog{eventNum}.details.to   = [.4]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.02,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'flunked'};
eventLog{eventNum}.subject ={'296','306'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='306 hard time with brief stim, can''t see 296 data , both BW dropping'; 
eventLog{eventNum}.details.from = [9.3 9.3]; 
eventLog{eventNum}.details.to   = [9.1 9.1]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.02,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'changeStimDuration'};
eventLog{eventNum}.subject ={'296', '304', '305', '306'}; % all female now.  all male soon...
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='both targetOnOff and flankerOnOff from [1 10] to [1 21], will apply to all future rats'; 
eventLog{eventNum}.details.from = {[1 10]}; 
eventLog{eventNum}.details.to   = {[1 21]};


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.05,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'increaseReward'};
eventLog{eventNum}.subject ={'230','227','229','237','232','233','139','228','234','231','275','277','278','138','130'}; % all male now.
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='hard time with brief stim, BW dropping'; 
eventLog{eventNum}.details.from = [1 1 1 1 1 0.6 1 1.5 1 1 1 1 1 1 1]; 
eventLog{eventNum}.details.to   = [2 2 2 2 2 1.2 2 2   2 2 2 2 2 2 2]; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.05,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'changeStimDuration'};
eventLog{eventNum}.subject ={'230','227','229','237','232','233','139','228','234','231','275','277','278','138','130'}; % all male now.
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='both targetOnOff and flankerOnOff from [1 10] to [1 21], will apply to all future rats'; 
eventLog{eventNum}.details.from = {[1 10]}; 
eventLog{eventNum}.details.to   = {[1 21]};

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.05,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'reduceCTs'};
eventLog{eventNum}.subject ={'275','277','130'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='these guys exploit CTs some, 130 is on a cockpit'; 
eventLog{eventNum}.details.from = [.25  .5  .5]; 
eventLog{eventNum}.details.to   = [.10 .10 .25];


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.11,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'138','139','228','232','233','231','234','278'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='done collecting sweep (13=distance, 11=confirm, 14=or, 12=target contrast), moving to confirm effect 200 msec'; 
eventLog{eventNum}.details.from = [13 13 13 13 13 14 14 11]; %278 was oddly listed at 12 in miniDB,even though all records say he was 11, i want him to be 12 now for testing
eventLog{eventNum}.details.to   = [11 11 11 11 11 12 12 12];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('May.11,2009');%datestr(now,21)  
eventLog{eventNum}.eventName ={'protocolChange'};
eventLog{eventNum}.subject ={'231','234','278'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='starting colinear only; for the target sweep'; 
eventLog{eventNum}.details.from = {'2_3','2_3','2_3'}; 
eventLog{eventNum}.details.to   = {'2_3reduced','2_3reduced','2_3reduced'}; 

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.09,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'protocolChange'};
eventLog{eventNum}.subject ={'138','139', '228', '277',               '227','229', '230', '237', '232', '233','277'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='starting blocking experiments'; 
eventLog{eventNum}.details.from = {'2_3','2_3','2_3','2_3',           '2_3','2_3','2_3','2_3','2_3'}; 
eventLog{eventNum}.details.to   = {'2_6','2_6','2_6special','2_6',     '2_6special','2_6','2_6','2_6','2_6special','2_6'};  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.09,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'138','139', '228','277',       '227', '229', '230', '237', '232', '233'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='starting blocking experiments'; 
eventLog{eventNum}.details.from = [11 13 11 9     9  11 11 11 11 11 ]; 
eventLog{eventNum}.details.to   = [11 11 11 11    12 12 12 12 12 12 ];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.09,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'reduceCTs'};
eventLog{eventNum}.subject ={'138','130','237'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='138 exploits CTs some, might as well lower others to a standard'; 
eventLog{eventNum}.details.from = [.25 .25 .25]; 
eventLog{eventNum}.details.to   = [.10 .10 .10];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.09,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'increaseReward'};
eventLog{eventNum}.subject ={'138'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='138 has low BW, db.mat says his reward is/ has been "1" but miniDB is already set to 2!'; 
eventLog{eventNum}.details.from = [1]; 
eventLog{eventNum}.details.to   = [2];


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.10,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'increasePenalty','increasePenalty','decreasePenalty'};
eventLog{eventNum}.subject ={'138','237','277'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='bug in set minidatabase prevented some penalty and reward from taking place till now; steps were always correct, see ''fixed miniDB bug June2009.txt'''; 
eventLog{eventNum}.details.from = [4000 4000 4000]; 
eventLog{eventNum}.details.to   = [6000 10000 1000];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.10,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'increaseReward'};
eventLog{eventNum}.subject ={'130','138','137','277'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='bug in set minidatabase prevented some penalty and reward from taking place till now; steps were always correct, see ''fixed miniDB bug June2009.txt'''; 
eventLog{eventNum}.details.from = [1 1 1 1]; 
eventLog{eventNum}.details.to   = [2 2 2 2];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.12,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'addCTs'};
eventLog{eventNum}.subject ={'228'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm'; % danielle point out to consider bias on 227, 228, 231 and 138 
eventLog{eventNum}.comment ='138 exploits CTs some, might as well lower others to a standard'; 
eventLog{eventNum}.details.from = [0]; 
eventLog{eventNum}.details.to   = [.10 ];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jun.22,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'231', '234'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='lots of data for target contrast 8 values, starting flanker contrast 8 values'; 
eventLog{eventNum}.details.from = [12 12 ]; 
eventLog{eventNum}.details.to   = [15 15 ];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jul.22,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'231', '234'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='lots of data for flanker contrast 8 values, starting joint sweep 5x5'; 
eventLog{eventNum}.details.from = [15 15 ]; 
eventLog{eventNum}.details.to   = [16 16 ];  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jul.29,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'304','306', '296'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='good enough on 9.3... moving along'; 
eventLog{eventNum}.details.from = [7 9 11]; 
eventLog{eventNum}.details.to   = [8 9 11];  


eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jul.29,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'increaseReward'};
eventLog{eventNum}.subject ={'228'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='just to hold BW, his performance already is bad'; 
eventLog{eventNum}.details.from = [2]; 
eventLog{eventNum}.details.to   = [3];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Jul.29,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'increaseReward'};
eventLog{eventNum}.subject ={'304','305','306', '296'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';
eventLog{eventNum}.comment ='was listed as 0.4 in miniDB but treated as 1.  changing DB to be correct and effective'; 
eventLog{eventNum}.details.from = [1 1 1 1]; 
eventLog{eventNum}.details.to   = [1 1 1 1];


% 234 gets a week off b/c he has a shoulder lump,  ~ aug 14 -->  Aug.22,2009  .. and continuing
% 234 gets another week off for surgery oct 30th --> nov 7th .. returns a litte before nov 30th

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Nov.02,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'231'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='testing to see the influence of a delay of 200 msec, target flanker onset offset are still synced'; 
eventLog{eventNum}.details.from = [16 ]; 
eventLog{eventNum}.details.to   = [17 ];  
%%

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Dec.07,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'228','139'}; 
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='poor performance on 11 blocked, flunked to 6: big thick linearized, so that duc might resolve correct behavior'; 
eventLog{eventNum}.details.from = [11 11 11];
eventLog{eventNum}.details.to   = [6  6 6];

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Dec.07,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'231','234'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='231 leaves delay and enters SOA, 234 is back from surgery, and enters SOA'; 
eventLog{eventNum}.details.from = [17 16]; 
eventLog{eventNum}.details.to   = [18 18];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Dec.07,2009');%datestr(now,21)
eventLog{eventNum}.eventName ={'manualStepChange'};
eventLog{eventNum}.subject ={'227','229','230','232','233'};
eventLog{eventNum}.stationID ={}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='patternRats get delay before SOA'; 
eventLog{eventNum}.details.from = [12 12 12 12 12]; 
eventLog{eventNum}.details.to   = [17 17 17 17 17];  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.01,2010');%datestr(now,21)
eventLog{eventNum}.eventName ={'moveStation'};
eventLog{eventNum}.subject ={'227'};
eventLog{eventNum}.stationID ={'1F'}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='227 moved station from 1D-->1F; remains on the same watter lines in the middle of the male room'; 
eventLog{eventNum}.details.from = {'1D'}; 
eventLog{eventNum}.details.to   = {'1F'};  

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Feb.01,2010');%datestr(now,21)
eventLog{eventNum}.eventName ={'startTrialsAgain'};
eventLog{eventNum}.subject ={'229'};
eventLog{eventNum}.stationID ={'1F'}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='back from free water, was off so duc could use him, but '; 
eventLog{eventNum}.details.from = []; 
eventLog{eventNum}.details.to   = [];  


%2 rats on station 1F have a problem with water

eventNum = eventNum +1;  
eventLog{eventNum}.date =datenum('Mar.06,2010');%datestr(now,21)
eventLog{eventNum}.eventName ={'pctCorretionTrailsIncreased'};
eventLog{eventNum}.subject ={'229'};
eventLog{eventNum}.stationID ={'1F'}; 
eventLog{eventNum}.issuedBy ='pmm';  
eventLog{eventNum}.comment ='back from free water, was off so duc could use him, but '; 
eventLog{eventNum}.details.from = [0]; 
eventLog{eventNum}.details.to   = [0.1];  
