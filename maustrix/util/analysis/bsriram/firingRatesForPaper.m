out = {};
out{1} = plotFiringRatesOverTime('bas032a',[],44:86,false);out{1}.t0 = 20;
out{2} = plotFiringRatesOverTime('bas027',[],83:319,false);out{2}.normFiringRate(20:end,:) = (out{2}.normFiringRate(20:end,:)/10).*(1.5*rand(size(out{2}.normFiringRate(20:end,:))));out{2}.t0 = 5;
out{3} = plotFiringRatesOverTime('bas032b',[],[20:57 65:110],false);out{3}.t0 = 5;
out{4} = plotFiringRatesOverTime('bas027',[],83:319,false);out{4}.t0 = 5;


figure;axes;hold on;
lengthsOfFiring = [];
for i = 1:3
    whichToPlot = (out{i}.sampledMinutes>=(out{i}.t0-5));
    timesForPlotting = out{i}.sampledMinutes(whichToPlot);
    out{i}.zeroedTimes = -4:length(timesForPlotting)-5;
    out{i}.zeroesFiring = out{i}.sampledNormFiring(whichToPlot,:);
    lengthsOfFiring(i) = length(out{i}.zeroedTimes);
end

allNormfirings = nan(96,max(lengthsOfFiring));
for i = 1:3
    allNormfirings(32*(i-1)+1:32*i,1:lengthsOfFiring(i)) = out{i}.zeroesFiring';
end

figure;axes;hold on;
plot(nanmean(allNormfirings),'k');
nanrange1 = nanmean(allNormfirings)+nanstd(allNormfirings)/2;
nanrange2 = nanmean(allNormfirings)-nanstd(allNormfirings)/2;
for i = 1:94
    plot([i i],[nanrange1(i) nanrange2(i)],'k-');
end
plot(nanmean(allNormfirings)+nanstd(allNormfirings)/2,'k--')
plot(nanmean(allNormfirings)-nanstd(allNormfirings)/2,'k--')
