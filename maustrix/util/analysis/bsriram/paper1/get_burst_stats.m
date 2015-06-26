function [burstfract,burstsize,cv,avg_isi,cv_isi] = get_burst_stats(spktimes, preisi, inisi)

% [burstfract,burstsize,cv,avg_isi,cv_isi] = get_burst_stats(spktimes, preisi, inisi)
% inputs
%	spktimes = times of spikes in msec (if >1 in bin, time must be listed twice)
%  preisi = the minimum isi before a burst, in msec (default 100)
%	inisi  = the maximum isi within a burst, in msec
% returns:
%  burstfract = the fraction of all spikes participating in such bursts
%  burstsize  = the average number of spikes per burst 
%	cv			  = std(number of spikes)/mean(number of spikes)
%  avg_isi = mean length of first interval
%  cv_isi	  = cv of first isi length
% notes:
%	 derived from get_burst_ind on 1/20/98
%   the time resolution of spike time binning  is not a parameter, 
%   times must be in *units* of msec but can be at any resolution

isi=spktimes(2:length(spktimes)) - spktimes(1:length(spktimes)-1); % isi in msec
Nisi=length(isi);

ind1 =find(isi(1:Nisi-1)>=preisi); % all isi's long enough to precede burst
% of those, all that are followed by an isi<inisi are by definition burst events
ind2 = ind1( find(isi(ind1+1)<inisi)) ; % refers to isi index
burstevind=ind2+1; % the index of the first spike in the burst
bursts= length(ind2);
ind3 = find(isi>inisi); % all isi's too big to be within a burst
burstspkind=[]; % spike time indices
burstspikes=[];
for j=1:bursts,% go through each burst
   i=ind2(j);  % get index of first isi in burst
   nextbig=min( ind3(find(ind3>i)) );% get ind of next big isi after that
   if isempty(nextbig), nextbig=length(isi)+1; end %if not found go to end
   burstspikes(j) = (nextbig - i);   % number of spikes in this burst
   first_isi(j) = isi(i+1);
   burstspkind=[burstspkind; (i+1:nextbig)']; 
   % spikes in this burst are from the one after the last big isi to the one before the next
end

if bursts, 
   burstsize=mean(burstspikes); 
   cv = std(burstspikes)/mean(burstspikes);
   burstfract= sum(burstspikes)/ (length(isi)+1);
   avg_isi=mean(first_isi);
   cv_isi=std(first_isi)/mean(first_isi);
else 
   burstsize=NaN; 
   cv=NaN;
   burstfract=0;
   avg_isi=NaN;
   cv_isi=NaN;
end

