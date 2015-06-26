%% loads
temp = load('/home/balaji/Documents/datanetOutput/375/LFPRecords/LFPRecord_1776-20110126T110409.mat');
LFPRecord = temp.LFPRecord.trode_1;

%% massage
f = [0:1:80];
[spec F T] = spectrogram(LFPRecord.data,100,[],f,500);
%% plotting
figure;
subplot(2,1,1);
plot(linspace(LFPRecord.dataTimes(1),LFPRecord.dataTimes(2),length(LFPRecord.data)),LFPRecord.data);
axis tight%
subplot(2,1,2);
% imagesc(LFPRecord.dataTimes(1)+T,flipud(F),abs(spec));
% imagesc(LFPRecord.dataTimes(1)+T,F,abs(spec));
imagesc(LFPRecord.dataTimes(1)+T,flipud(F),abs(spec));
set(gca,'YTickLabel',flipud(get(gca,'YTickLabel')));