%% balanced raster 1
load('\\132.239.158.169\datanetOutput\408\neuralRecords\neuralRecords_1525-20110808T203248.mat')
spikeDetectionParams.samplingFreq = 40000;
Wn = [300 3000]/(spikeDetectionParams.samplingFreq/2);
spikeDetectionParams.freqLowHi = [300 3000];
N=min(spikeDetectionParams.samplingFreq/200,floor(size(neuralData,1)/3)); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
[b,a]=fir1(N,2*spikeDetectionParams.freqLowHi/spikeDetectionParams.samplingFreq);

stim = load('\\132.239.158.169\datanetOutput\408\stimRecords\stimRecords_1525-20110808T203248.mat')
neuralData = [chunk1.neuralData(:,3);chunk2.neuralData(:,3);chunk3.neuralData(:,3)];
filteredSignal=filtfilt(b,a,neuralData);

%%
details = stim.stimulusDetails;
mode = {details.method,details.seed};
comboMatrix = generateFactorialCombo({details.spatialFrequencies,details.driftfrequencies,details.orientations,...
details.contrasts,details.phases,details.durations,details.radii,details.annuli},[],[],mode);
sFs = comboMatrix(1,:)
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

%%
start = 36000;
stop = 116500;
x1 = subplot(211);plot(filteredSignal(start:stop))
x2 = subplot(212);plot(light(start:stop));
linkaxes([x1,x2],'x')


%% lowpass raster 1
load('\\132.239.158.169\datanetOutput\405\neuralRecords\neuralRecords_379-20110526T111513.mat')
spikeDetectionParams.samplingFreq = 40000;
Wn = [300 3000]/(spikeDetectionParams.samplingFreq/2);
spikeDetectionParams.freqLowHi = [300 3000];


stim = load('\\132.239.158.169\datanetOutput\405\stimRecords\stimRecords_379-20110526T111513.mat')
neuralData = [chunk1.neuralData(:,3);chunk2.neuralData(:,3);chunk3.neuralData(:,3);chunk4.neuralData(:,3);chunk5.neuralData(:,3)];

N=min(spikeDetectionParams.samplingFreq/200,floor(size(neuralData,1)/3)); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
[b,a]=fir1(N,2*spikeDetectionParams.freqLowHi/spikeDetectionParams.samplingFreq);

filteredSignal=filtfilt(b,a,neuralData);
light = [chunk1.neuralData(:,2);chunk2.neuralData(:,2);chunk3.neuralData(:,2);chunk4.neuralData(:,2);chunk5.neuralData(:,2)];
%%
details = stim.stimulusDetails;
mode = {details.method,details.seed};
comboMatrix = generateFactorialCombo({details.spatialFrequencies,details.driftfrequencies,details.orientations,...
details.contrasts,details.phases,details.durations,details.radii,details.annuli},[],[],mode);
sFs = comboMatrix(1,:)
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

start = 36000;
stop = 116500;
x1 = subplot(211);plot(filteredSignal(1:end))
x2 = subplot(212);plot(light(1:end));
linkaxes([x1,x2],'x')

%% balanced raster 2
load('\\132.239.158.169\datanetOutput\375\neuralRecords\neuralRecords_1283-20101221T152647.mat')
neuralData = [chunk1.neuralData(:,3);chunk2.neuralData(:,3);chunk3.neuralData(:,3);chunk4.neuralData(:,3);chunk5.neuralData(:,3)];
light= [chunk1.neuralData(:,2);chunk2.neuralData(:,2);chunk3.neuralData(:,2);chunk4.neuralData(:,2);chunk5.neuralData(:,2)];
spikeDetectionParams.samplingFreq = 40000;
Wn = [300 3000]/(spikeDetectionParams.samplingFreq/2);
spikeDetectionParams.freqLowHi = [300 3000];
N=min(spikeDetectionParams.samplingFreq/200,floor(size(neuralData,1)/3)); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
[b,a]=fir1(N,2*spikeDetectionParams.freqLowHi/spikeDetectionParams.samplingFreq);

stim = load('\\132.239.158.169\datanetOutput\375\stimRecords\stimRecords_1283-20101221T152647.mat')

filteredSignal=filtfilt(b,a,neuralData);

%%
details = stim.stimulusDetails;
mode = {details.method,details.seed};
comboMatrix = generateFactorialCombo({details.spatialFrequencies,details.driftfrequencies,details.orientations,...
details.contrasts,details.phases,details.durations,details.radii,details.annuli},[],[],mode);
sFs = comboMatrix(1,:)
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

start = 36000;
stop = 116500;
x1 = subplot(211);plot(filteredSignal(1:end))
x2 = subplot(212);plot(light(1:end));
linkaxes([x1,x2],'x')


%% balanced raster 3
load('\\132.239.158.169\datanetOutput\375\neuralRecords\neuralRecords_1361-20110103T194710.mat')
neuralData = [chunk1.neuralData(:,3);chunk2.neuralData(:,3);chunk3.neuralData(:,3);chunk4.neuralData(:,3);chunk5.neuralData(:,3)];
light= [chunk1.neuralData(:,2);chunk2.neuralData(:,2);chunk3.neuralData(:,2);chunk4.neuralData(:,2);chunk5.neuralData(:,2)];
spikeDetectionParams.samplingFreq = 40000;
Wn = [300 3000]/(spikeDetectionParams.samplingFreq/2);
spikeDetectionParams.freqLowHi = [300 3000];
N=min(spikeDetectionParams.samplingFreq/200,floor(size(neuralData,1)/3)); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
[b,a]=fir1(N,2*spikeDetectionParams.freqLowHi/spikeDetectionParams.samplingFreq);

stim = load('\\132.239.158.169\datanetOutput\375\stimRecords\stimRecords_1361-20110103T194710.mat')

filteredSignal=filtfilt(b,a,neuralData);

%%
details = stim.stimulusDetails;
mode = {details.method,details.seed};
comboMatrix = generateFactorialCombo({details.spatialFrequencies,details.driftfrequencies,details.orientations,...
details.contrasts,details.phases,details.durations,details.radii,details.annuli},[],[],mode);
sFs = comboMatrix(1,:)
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

start = 36000;
stop = 116500;
x1 = subplot(211);plot(filteredSignal(1:end))
x2 = subplot(212);plot(light(1:end));
linkaxes([x1,x2],'x')


