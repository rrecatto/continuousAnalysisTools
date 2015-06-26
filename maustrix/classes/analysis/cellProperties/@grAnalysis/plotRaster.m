function out = plotRaster(s,params)
if ~exist('params','var')||isempty(params)
    params = struct;
    params.handle = figure;hold on;
    params.degPerPix = getDegPerPix(s);
else
    axes(params.handle); hold on;
    params.degPerPix = getDegPerPix(s);
end
if isempty(s)
    out = NaN;
    return;
end


trialRange = minmax(s.trials);


numRepeats = size(s.stim,1);
numRepeats = numRepeats-1;
numTypes = size(s.stim,2);
vals = 1./(s.stimInfo.stimulusDetails.spatialFrequencies*params.degPerPix);
keyboard

spikeCount = [];
types = [];
repeats = [];
phases = [];

for i = 1:numTypes
    for j = 1:numRepeats
        spikeCountCurr = s.spikeCount{j,i};
        spikeCountCurr = spikeCountCurr(1:180);
        
        phasesCurr = s.stim{j,i};
        phasesCurr = phasesCurr(1:180);
        phases = [phases;phasesCurr];
        
        spikeCount = [spikeCount;spikeCountCurr];
        repeats = [repeats;j*ones(size(spikeCountCurr))];
        types = [types;i*ones(size(spikeCountCurr))];
    end
end
maxSpikesPerFrame = max(spikeCount(:));
for i = 1:numTypes
    %     i
    %     keyboard
    currPhasesForType = [inf -inf];
    for j = 1:numRepeats
        currentPhases = 1:length(phases(repeats==j & types==i));
        %             currentPhases = currentPhases-min(currentPhases);
        currentSpikeCount = spikeCount(repeats==j & types==i);
        yLocation = (i-1)+(j-1)/(numRepeats+1)+0.05;
        heightOfSpike = 0.85*(1/(numRepeats+1));
        averageDistBetPhases = mean(diff(currentPhases));
        spikeWidth = 0.85*averageDistBetPhases/(maxSpikesPerFrame+1);
        for k = 1:length(currentPhases)
            numSpikesCurrentPhase = currentSpikeCount(k);
            if numSpikesCurrentPhase >0
                %                     if numSpikesCurrentPhase >1
                %                         keyboard
                %                     end
                for l = 1:numSpikesCurrentPhase
                    %                         rectangle('Position',[currentPhases(k)-averageDistBetPhases/2+l*averageDistBetPhases/(maxSpikesPerFrame+1),yLocation,spikeWidth,heightOfSpike],'FaceColor','k','LineStyle','none');
                    xPos = currentPhases(k)-averageDistBetPhases/2+l*averageDistBetPhases/(maxSpikesPerFrame+1);
                    yPos = yLocation;
                    plot([xPos xPos],[yLocation,yLocation+heightOfSpike],'LineWidth',1.5,'color','k');
                end
            end
        end
        if ~isempty(currentPhases)
            currPhasesForType = [min(currPhasesForType(1),currentPhases(1)), max(currPhasesForType(2),currentPhases(end))];
        end
    end
    
    plot(currPhasesForType,[i i],'color',0.5*[1 1 1],'LineWidth',2);
    
    %         text(-5,i-0.5,sprintf('%2.3f cpd',vals(i)),'HorizontalAlignment','right','VerticalAlignment','bottom');
end

type = 1; repeat = 1;
currentPhases = unwrap(phases(repeats==repeat & types==type));
plot(currentPhases,cos(currentPhases)+numTypes+1);
axis tight
out = params.handle;
% catch
%     out = NaN;
% end
end