function waitForStop(x)

    startTime=GetSecs;
    numLoops=0;
    s=PsychPortAudio('getstatus',x);

    while s.Active
        numLoops = numLoops+1;
        %s
        % warning('when trying to start a sound, had to wait for psychportaudio to stop from previous sound -- check how recent last call to stop was')
        s=PsychPortAudio('getstatus',x);
    end
    time=GetSecs-startTime;
    if numLoops>1 || time>.0005
        fprintf('**************waited for %g secs %g loops for ppa to stop so could start again\n',time,numLoops)
    end
