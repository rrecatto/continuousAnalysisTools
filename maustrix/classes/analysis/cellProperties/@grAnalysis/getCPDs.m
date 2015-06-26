function out = getCPDs(s)
PPCs = s.stimInfo.stimulusDetails.spatialFrequencies;
distToMonitor = s.rig.getDistanceToMonitor;
monitorPixs = s.monitor.getPixs;
monitorSize = s.monitor.getDims;
% only for vertical gratings!!!
x = (PPCs/monitorPixs(1))*monitorSize(1);
DPCs = atan(x/distToMonitor);
out = 1./DPCs;
