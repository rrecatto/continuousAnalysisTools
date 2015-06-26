function db = onlyAnesthDB(db,mode)
if ~exist('mode','var')||isempty(mode)
    mode = 'createDB';
end
%% Create analyses for paper1
dbName = 'awakeAnesthPaper';
dbSavePath = 'F:\physiologyData';
db.savePath = dbSavePath;
switch mode
    case 'createDB'
        %% new mon
        ID=0; % neuronID
%% 231        
        ID = ID+1; % neuronID
        subj='231'; thrV=[-Inf 0.1 2]; included=1;channels = 1; mon = 'ViewSonicPF790-VCDTS21611';anesth =2.0;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        %thrV=[-0.05 Inf 2]; was okay;  [-0.15 Inf 2]; was not okay
        db=db.addSingleUnit(subj,ID,channels,mon,'first cell tested',{...
            [66],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'TRF - great!';...
            [15:24],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'strf';...
            [26:37],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'spat.freq';...
            [46 47 48 50 51 58 62 63]  ,sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'ffgwn';...
})

        ID=ID+1;
        subj='231'; thrV=[-Inf 0.5 2]; included=1;channels = 1; anesth =2; %thrV=[-0.05 Inf 2]; lots of seperable noise
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'tested at -0.05; -0.2 is great SNR cuttoff w/ no noise',{...
            [96],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'trf';...
})
        
        ID=ID+1;
        subj='231'; thrV=[-Inf 0.5 2]; included=1;channels = 1; anesth =2; %thrV=[-0.05 Inf 2]; lots of seperable noise
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'tested at -0.05; -0.2 is great SNR cuttoff w/ no noise',{...
            [149],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'spat. freq.';...
            [152:154],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'ffgwn';...
            [158],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'trf! - may be good but skipped';...
})

        ID=ID+1;
        subj='231'; thrV=[-Inf 0.1 2]; included=1;channels = 1;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        %thrV=[-Inf 0.05 2]; gets lots of noise, 0.1 only 1 noisesamp and all spikes
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [269 270],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'trf';...
})

     
        ID=ID+1;
        subj='231'; thrV=[-0.05 Inf 2]; included=1;channels = 1;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'this is MUA, removed 463',{...
            [499:502],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,1.5,'ffgwn- iso high';...
})
        
        ID = ID+1;
        subj='231'; thrV=[-0.2 Inf 2]; included=1;channels = 1; q=4; anesth= 1.0;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'sorting handled by thresh',{...
            [615:628],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'ffgwn- anesth moved from 1.5 to 1.0 on trial 624';...
            [629:634],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'tf';...
%             [635 636 638:642],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'6x8bin';...
%             [646    ],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fff- anesth';...
%             [651:666],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc- anesth,  cell was more excitable on trial 663';...
%             [671:678],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'nat gratings';...
%             [681:682],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'trf';...
%             [736:737],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'sparse confirm location';...
%             [748:752],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'f contrast, cicular hack - 1 rep b/c memory';...
%             [764:768],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc - iso at 1%';...
%             [780:792],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc - still no whisking, but stable and light';...
%             [793:797],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc - poking the rat, and trying to get him to wake'
})
        
        %JULY 3rd, 2010
        ID = ID+1;
        subj='231'; thrV=[-Inf 0.2 2]; included=1; channels = 1; q=4; anesth= 1.25;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        %thrV=[-Inf 0.25 2] was sparse.. did it miss some?
        db=db.addSingleUnit(subj,ID,channels,mon,'spatial sta broken... not worth rescuing',{...
            [806:830],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'gwn';...
%             [831:832],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'NAT GRATING';...
%             [834:836],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc';...
            [853]    ,sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'sf  - WORTH ANALYZING'
});
        
        ID = ID+1;
        subj='231'; thrV=[-0.15 Inf 2]; included=1;channels = 1; q=3; anesth= 1.25;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [878:887],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'gwn';...
%             [889:906],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc - frames drop in begining, fewer drops later  (897 has noise)';...
%             [909:913],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'NAT GRATING';...
%             [915 937],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'bin 6x8; nothing obvious spatial first run';...
%             [941], sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'sf'
})
        
        ID = ID+1;
        subj='231'; thrV=[-Inf .2 2]; included=1;channels = 1;  q=2; anesth= 1.25;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [956:960],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'gwn';...
            [965],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'sf, some drops';...
%             [967],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'or, some drops';...
%             [969:983],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'bin 6x8, some drops';...
%             [995:1009],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc, background firing rate modulation - java mem. NEED TO TURN OFF SOME PLOTS TO SEE IT';...
%             [1011:1012],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'nat gratings';...
%             [1022:1027],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'bin6x8 - eyes prob stable';...
%             [1053:1063],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'bin12x16'
})
%         db.data{db.numNeurons}=db.data{db.numNeurons}.addComment('drifting on trials: 1056,1062 (prob others too, but def those)');
%         db.data{db.numNeurons}=db.data{db.numNeurons}.addComment('SNR decreases after trial 1074 making it challenging to detect and sort spikes');
        % [1028:1046], q,included,thrV,anesth,'bin6x8 - eye moves, drifts';... %this gets bound to the good eyes... removing it
        
        
        ID = ID+1;
        subj='231'; thrV=[-0.08 Inf 2]; included=1;channels = 1;  anesth= 1.0;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'at 1270 goes on iso. but cell keeps changing size and would be tricky to sort, so not going to do it',{...
            [1163:1173],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'gwn';...
%             [1197:1209],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'fffc, random seed set to 1, 6 reps ... confirmed visually that the OFF high contrast spiked most... didn''t trust the contrast at the time of recording, prob b/c the analysis was broken'
})

        ID = ID+1;
        subj='231'; thrV=[-0.3 Inf 2]; included=1;channels = 1;  anesth= 1.0;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [1326],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'trf';...
})

        ID = ID+1;
        subj='231'; thrV=[-0.3 Inf 2]; included=1;channels = 1;  anesth= 1.0;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [1382],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV,anesth,'trf';...
})

%% 249
        ID = ID+1;
        subj = '249'; thrV=[-0.1 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [147 148],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
})
        
        ID = ID+1;
        subj = '249'; thrV=[-0.1 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [154 155],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf'})
        

        ID = ID+1;
        subj = '249'; thrV=[-0.1 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,' not pursuing some more cells on this rat, with horix & vert noise bars, slow gratings at 423 plus',{...
            [187],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'sf gratings';...
%             [188:190],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'or gratings';...
            [196:217],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'wn';...
})
        %    [160:185],NaN,included,thrV, anesth,'varaious bars mixed';...


        
%% 257

        ID = ID+1;
        subj = '257'; thrV=[-inf 0.1 1]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [55:57],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
            [58:68 70:78],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn';...
})

        ID = ID+1;
        subj = '257'; thrV=[-inf 0.1 1]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [151:156],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn';...
})

        ID = ID+1;
        subj = '257'; thrV=[-inf 0.1 1]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [388:398 424:436],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn';...
})



%% 261


        ID = ID+1;
        subj = '261'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [118:121],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn'})
        %%[117],NaN,included,thrV, anesth,'grating'})  % 2 features vary
        
        ID = ID+1;
        subj = '261'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [244 252 271:272],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn'})
        
        
        ID = ID+1;
        subj = '261'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [288:293],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn';...
            [294],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'sf';...
%             [324:332],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'bin grid, 3x4';...
%             [341:346 351:359],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'bin grid, 6x8'
});
 
%% 354


        ID = ID+1;
        subj = '354'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [20:26],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});



        ID = ID+1;
        subj = '354'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [53:60],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});

%% 357


        ID = ID+1;
        subj = '357'; thrV=[-0.05 Inf 0.4]; included=1;channels = 2; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [9:20],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});



        ID = ID+1;
        subj = '357'; thrV=[-0.05 Inf 0.4;]; included=1;channels = 3; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [9:20],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});



        ID = ID+1;
        subj = '357'; thrV=[-0.05 Inf 0.4;]; included=1;channels = 6; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [9:20],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});



        ID = ID+1;
        subj = '357'; thrV=[-0.04 Inf 0.4;]; included=1;channels = 9; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [9:20],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});



        ID = ID+1;
        subj = '357'; thrV=[-0.05 Inf 0.4;]; included=1;channels = 14; anesth=1.5;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [9:20],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'trf';...
});


%% 262  
        
        ID = ID+1;
        subj = '262'; thrV=[-0.2 Inf 2]; included=1;channels = 1; anesth=1.0;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [34:41],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn - has temporal STA';...
%             [120:123],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'spatial binary'
})
       


%%
        ID = ID+1;
        subj = '230'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.25;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [137:140],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'whiteNoise';...
%             [142 ],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'flanker FF contrast'
})
        
        
        ID = ID+1;
        subj = '230'; thrV=[-0.2 Inf 2]; included=1;channels = 1; anesth=1.25;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'some shifts in state for this cell',{...
            [144:155],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'ffgwn';...
%             [157:162 200:208],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'flanker FF contrast, no stationary state (.05 Hz osillation in state).. merged with 200-208'
})

        ID = ID+1;
        subj = '230'; thrV=[-0.05 inf 1]; included=1;channels = 1; anesth=1.25;
        sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
        rigState = NaN; ampState = NaN;
        db=db.addSingleUnit(subj,ID,channels,mon,'',{...
            [164:167],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'sf';...
})
        %[],3,included,thrV, anesth,'fffc,  the bursting in the background is not stim entrained and the LFP gets crazier'})
        %tr 228 too much chatter, too poor of a sort.  cant drive with gratings,cantmoving on. statefullness has been well documented'
        
%         ID=21;
%         subj = '230'; thrV=[-0.05 Inf 2]; included=1;channels = 1; anesth=1.25;
%         sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
%         rigState = NaN; ampState = NaN;
%         db=db.addSingleUnit(subj,ID,channels,'',{...
%             [260:272],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'fffc, ppc=180';...
%             [274:289],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'fffc, ppc=32, distance = 24cm ... uh oh, 276+ may need to be rescued'})
%         % [229:236],NaN,included,thrV, anesth,'ffgwn? maybe?';...
%         
%         ID=22;
%         subj = '230'; thrV=[-0.2 Inf 2]; included=1;channels = 1; anesth=1.25;
%         sortQuality = NaN; eyeQuality = NaN; analysisQuality = NaN;
%         rigState = NaN; ampState = NaN;
%         db=db.addSingleUnit(subj,ID,channels,'some shifts in state for this cell',{...
%             [165 166 167 169],sortQuality,eyeQuality,analysisQuality,rigState,ampState,included,thrV, anesth,'%gratings, down state'})

    case 'latest'
        db = db.load('basOnlyAnesth_20130219T113838');
end

end
