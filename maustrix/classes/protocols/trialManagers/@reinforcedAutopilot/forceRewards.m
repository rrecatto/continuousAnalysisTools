function rewardValves = forceRewards(tm,rewardValves)
%forceRewards only sets if the valves are set to [0 0 0]

if ~any(rewardValves)
    rewardValves = [0 1 0];
end

