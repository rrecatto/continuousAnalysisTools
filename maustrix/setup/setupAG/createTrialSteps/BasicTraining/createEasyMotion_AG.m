function ts = createEasyMotion_AG(percentCorrectionTrials, trialManager, performanceCrit, sch, svnRev, svnCheckMode);
% module that creates an easy motion step 85% motion task
% question: WHAT does coherentdots do with percentCorrectionTrials? isn't
% that determined by the trial manager not the stim manager?

screen_width=100;
screen_height=100;
num_dots=100;
movie_duration=2; % question: does movie end or replay after 2sec?
screen_zoom=[6 6];
maxWidth=1024;
maxHeight=768;
% easy/optimal params
coherence=.95; 
speed=0.5; 
contrast=1; 
dot_size=3; 

% stim manager
dotStimulus=coherentDots(screen_width,screen_height,num_dots,...  
    coherence,speed,contrast,dot_size,...  
    movie_duration,screen_zoom,maxWidth,maxHeight,percentCorrectionTrials); 
% training step
ts = trainingStep(trialManager, dotStimulus,performanceCrit, sch, svnRev, svnCheckMode);  

%NOTES FOR ALBERTO example for range of coherence
% think about grad criterion
%  coherence=[.7 .95]; 