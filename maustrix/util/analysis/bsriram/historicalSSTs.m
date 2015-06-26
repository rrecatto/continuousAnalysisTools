%% 364
% ffgwn before muscimol
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[26 31]}; %% ffgwn
% after muscimol
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[167 185]};% ffgwn
% subjectID = '364'; channels={1}; thrV = [-0.08 Inf 0.4]; cellBoundary={'trialRange',[262 269]};% ffgwn (weird??)
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[227 236]};% ffgwn (some extra spike show up!) 
% subjectID = '364'; channels={1}; thrV = [-0.08 Inf 0.4]; cellBoundary={'trialRange',[167 269],'trialMask',[186:226 237:261]};% ffgwn (weird??)

% % % % subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4];
% % % % cellBoundary={'trialRange',[30]}; %% sometihng weird is happenieng in
% % % % detection. without a lock out multiple spikes are detected
% % % 
% % % % subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[30 31]}; %% ffgwn

%===================================================================================================
% trf before muscimol
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[34 37]}; %% whts this?
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[145]};% trf
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[34 145],'trialMask',[38:144]};% trf
%===================================================================================================
% strf before muscimol
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[101 135]};% changed the monitor location***
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[64 67]}; %% whts this?
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[33 67]}; %% whts this?
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4];cellBoundary={'trialRange',[64 95],'trialMask',[68:82]};
% strf after muscimol
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[187 220],'trialMask',[210]};% binary 6X8***
% subjectID = '364'; channels={1}; thrV = [-0.10 Inf 0.4]; cellBoundary={'trialRange',[270 300]};% bin 12X16 (definitely 2 spikes there) ??? it got something in the end...but noisy
% subjectID = '364'; channels={1}; thrV = [-0.10 Inf 0.4]; cellBoundary={'trialRange',[309 331]};% bin 6X8 normal has repeats....need to add tiny lockout (0.1ms)
% this shows both upward and downward STSTA. i think there are 2 spikes.
% but unable to split them in any substantial way
%===================================================================================================
% spatial frequency before muscimol
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[137 138]};% sf
% spatial frequency after muscimol
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[222 225]};% sf

%==========================================================================
%=========================
% or before muscimol
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[140 141]};% or
% or after muscimol
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[237 240]};% or

% % after muscimol

% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[242 250]};% fffc
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[252 260]};% nat gratings


% % secind dose of muscimol
% subjectID = '364'; channels={1}; thrV = [-0.10 Inf 0.4]; cellBoundary={'trialRange',[309 331]};% bin 6X8 
% subjectID = '364'; channels={1}; thrV = [-0.10 Inf 0.4]; cellBoundary={'trialRange',[341 370],'trialMask',[347 353 359 365]};% bin 6X8 

%===================================================================================================
% % what happens to the spiking rate?
% subjectID = '364'; channels={1}; thrV = [-0.1 Inf 0.35]; cellBoundary={'trialRange',[26 165],'trialMask',[68:81]};

% subjectID = '364'; channels={1}; thrV = [-0.1 Inf 0.35]; cellBoundary={'trialRange',[166 371]};

%%