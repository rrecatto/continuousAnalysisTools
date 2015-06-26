function sm=stopPlayer(sm)

try
        PsychPortAudio('Stop', sm.player,2,0);
catch
    % usage seems fine but maybe the problem is that sm.player does not exist?
    sm.player
end
sm.playing=[];
sm.looping=false;