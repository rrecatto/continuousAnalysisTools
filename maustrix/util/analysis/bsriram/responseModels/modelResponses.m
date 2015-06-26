function out = modelResponses(tTotal,tPre,tStim,contrastModel,trials,fBkgd,fDriven,latency)

c = contrastModel.c;
n = contrastModel.n;
a = contrastModel.a;

latency = latency*((2-c)^0.5);
stim = zeros(1,ceil(tTotal+latency));
stim(ceil(tPre+latency):ceil(tPre+tStim+latency)) = 1;

response = fBkgd+(fDriven-fBkgd)*stim*(c^n/(c^n+a^n));

raster = zeros(trials,ceil(tTotal+latency)); 

for tr = 1:trials
    if rand<0.01
        if rand<0.5
            responseCurr = response +0.1;
        else
            responseCurr = response -0.1;
        end
    else
        responseCurr = response;
    end
    
    for ms = 1:ceil(tTotal+latency)
        raster(tr,ms) = rand<responseCurr(ms);
    end
end

out.raster = raster(:,1:tTotal);
out.stim = stim(latency:end);


end

