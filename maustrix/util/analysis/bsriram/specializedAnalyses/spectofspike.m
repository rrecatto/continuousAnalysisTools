function [spkspect,fbins, DC,h]= spectofspike(R,N,dt,normalization,doplot);
% inputs
%	R	= time binned spike train	(Response) *or stimulus
%	N	= number of time bins lag to use for spectrum
%   dt  = size of the time bin in seconds
%   doplot = if 1 (default) plot result, if 0 suppress plot
% output
%	spkspect = the AMPLITUDE of the fft 
%   fbins = the UPPER boundaries of the frequency bins
%   DC = mean of original spiketrain
%   h = handle to the plot;
% notes
%   computed from the fft of the autocorr
%   derived from pam's code from optimal lin filt calcs
if nargin<4, doplot=true;end

R=full(R);% if spiketrain is sparse, make it full
DC=mean(R);
R=R-DC; %empirically doesn't affect much but the DC bin
autocorr= xcorr(R,R,N-1,normalization); % normalization?
tmp=autocorr(1:N-1);
spkspect = fft(tmp); %
spkspect=abs(spkspect(1:N/2));
nyquist=0.5/dt;
fbins=[2*nyquist/N: 2*nyquist/N: nyquist];
if doplot,% plots in the open figure plot or subplot!
    h=figure;
%     subplot(3,1,1);
%     plot(fbins,spkspect,'k.-');
%     xlabel('frequency (Hz)'), ylabel('Amplitude')
%     title('Spectrum of Spiketrain Computed from Autocorr')
%     peakf=fbins(find(spkspect==max(spkspect)));
%     hold on, plot(peakf*[2:5],0.8*max(spkspect),'rv');
%     legend(sprintf('Peak = %.1f - %.1fHz',peakf-2*nyquist/N,peakf),'Harmonics');
%     subplot(3,1,2);
    tAC = linspace(-(N-1)*dt,(N-1)*dt,length(autocorr));
    plot(tAC,autocorr);
    axis tight
%     subplot(3,1,3);
%     fSpikeTr = abs(fft(R));
%     NfSpTr = length(fSpikeTr)/2;
%     fSpikeTr = fSpikeTr(1:NfSpTr);
% %     keyboard
%     freq = linspace(0,nyquist,NfSpTr+1);
%     freq(1) = []; % remove 0
%     plot(freq,fSpikeTr);
%     plot();    
end
