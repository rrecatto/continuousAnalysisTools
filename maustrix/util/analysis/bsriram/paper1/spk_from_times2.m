function spk = spk_from_times(spktime,deltat,Npts);
% spk = spk_from_times(spiketimes,deltat,Nframes);
%
% inputs
%	spiketimes 	=	times of spikes, in units of msec
%	deltat		=	size of time bin desired, in msec (default 1)
%	Nframes		=	number of time bins desired, deltat*Nframes = length of spk in msec
%						default last spike is last frame
% outputs
%	spk			=	binned spike train in sparse array of dimensions Nframes*1 
%						where spk(i) is the number of spikes in the time interval
%						(i-1)*deltat to i*deltat
%
% Notes:
% 	it is probably important that deltat be an integer multiple of the
%	the sampling interval of the spike times but there is no test for this
%  (tested using sampling 0.1msec and deltat of 5 msec)
%
%  if some spike times are later than Nframes*deltat, they are not used
%
% 	from the time of the last spike up to Nframes*deltat, spk is defined and is 0,
%	indicating that spikes would have been detected, had they occurred

if (nargin<2),
   deltat=1;
   fprintf('deltat = 1\n')
end

if nargin<3,
   Npts=ceil(max(spktime)/deltat);
   fprintf('Nframes = %d\n', Npts);
elseif ~(Npts==floor(Npts)),
   Npts=ceil(Npts);
   fprintf('Nframes = %d\n',Npts);
end

if (max(spktime) > Npts*deltat),
   %fprintf('spike times from %.1f to %.1f discarded\n',Npts*deltat,max(spktime));
   spktime=spktime(find(spktime<=Npts*deltat));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the indexes for an array sampled at deltat msec resolution
% for the bin corresponding to the time of each spike
tmpspk=ceil(spktime/deltat); 

% the indices of the sparse array are the bins that have spikes
% the contents of the sparse array are the number of spikes in the bin
b=unique(tmpspk(find(tmpspk)));  % exclude 0 these spikes belong to a previous bin
c=[]; % this prevents ref to uninit. var. c if no spikes found
for x=1:length(b), c(x) = length(find(tmpspk==b(x))); end 
%spk=sparse(zeros(Npts,1)); spk(b)=c;
spk=sparse(Npts,1); 
spk(b)=c; 