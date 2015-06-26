function name = getType(sm,stim)


swept = stim.stimulusDetails.sm.dynamicSweep.sweptParameters;
maskSz=stim.stimulusDetails.stdGaussMask;

if isinf(maskSz)
    name='ff';
else
    name='';
end

if any(strcmp(swept,'targetOrientations'))...
        && any(strcmp(swept,'flankerOrientations'))...
        && any(strcmp(swept,'flankerPosAngle'))...
        && any(strcmp(swept,'phase'))...
        && size(swept,2)==4;
            name = [name 'fColin'];
elseif any(strcmp(swept,'targetOrientations'))...
        && any(strcmp(swept,'phase'))...
        && size(swept,2)==2;
     name = [name 'fOri'];
elseif any(strcmp(swept,'targetContrast'))...
        && any(strcmp(swept,'phase'))...
        && size(swept,2)==2;
    name = [name 'fc'];
elseif any(strcmp(swept,'phase'))...
        && size(swept,2)==1;
    name = [name 'fPhase'];
else 
    name = [name 'undefinedFlanker'];
end

end