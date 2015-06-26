function testsound
clear mex
clear psychportaudio

p=MaxPriority('getsecs');
Priority(p);
InitializePsychSound(1);
try
    x=PsychPortAudio('open',[],[],4,[],[],4096); %reqclass 4 doesn't work with asio4all + enhanced dll
catch ex
    disp(['CAUGHT ERROR: ' getReport(ex,'extended')])
    x=PsychPortAudio('open',[],[],2,[],[],4096);
end
s=PsychPortAudio('getstatus',x);
s.SampleRate
PsychPortAudio('fillbuffer',x,rand(2,400000)-.5);
GetSecs;

PsychPortAudio('RunMode', x, 1);

PsychPortAudio('start',x);
PsychPortAudio('stop',x);

val=true;
for i=1:10
    val=~val;
    y=GetSecs;
    PsychPortAudio('fillbuffer',x,val*rand(2,round(2*44100*i/10))-.5);
    t=GetSecs-y;
    if val
        fprintf('yes:')
    else
        fprintf('no:')
    end
    fprintf('\t%g\n',t)
end
y=GetSecs;
PsychPortAudio('start',x);
PsychPortAudio('stop',x,2,0);
t=GetSecs-y;
fprintf('%g\n',t)
pause
for i=1:10
    waitForStop(x);
    y=GetSecs;
    PsychPortAudio('start',x);
    s=GetSecs-y;
    pause(.5);
    y=GetSecs;
    PsychPortAudio('stop',x,2,0);
    t=GetSecs-y;
    fprintf('%g\t%g\n',s,t)
end

pause
for i=1:10
    waitForStop(x);
    y=GetSecs;
    PsychPortAudio('start',x);
    s=GetSecs-y;
    pause(.5);
    y=GetSecs;
    PsychPortAudio('stop',x,0,0);
    t=GetSecs-y;
    fprintf('%g\t%g\n',s,t)
end

PsychPortAudio('close')

x=audioplayer(rand(400000,2)-.5,44100);
play(x);
stop(x);
for i=1:10
    y=GetSecs;
    play(x);
    s=GetSecs-y;
    pause(.5);
    y=GetSecs;
    stop(x);
    t=GetSecs-y;
    fprintf('%g\t%g\n',s,t)
end
priority(0);