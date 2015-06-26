function evs_isi(eventfile,spike_ind)
% evs_isi(eventfile)
%
% eventfile = 	the name of file containing event times 
%					in tenths of ms
% spike_ind = optional vector specifying which spikes to use
%					helpful for analyzing huge data files
% OUTPUT:
% (0) reads in the raw event times from the e file
% (1) plots the inter-event interval at fine resolution 
% 		to check for absolute refractory period (R on plot)
% (2) plots the interval distribution on a log scale
% (3) plots spike pair isi distribution (pre vs post)
%
% PURPOSE: preliminary evaluation of cluster cutting
% example: 	list=dir('*.e*');
%				for i=1:length(list),
%					evs_isi(list(i).name;
%				end
% PR 9/98

[evs, info]=getevs(eventfile);
 
if length(evs)<100,
   fprintf('Fewer than 100 events in %s (skipping)\n',eventfile);
   return % don't analyze
end

if nargin<2, % no spike range specified,
   spike_ind=1:length(evs); % default use all
end
evs=evs(spike_ind); % keep only spikes to be used
evs=evs/10; % convert to ms

isi=diff(evs); % get intervals
bins1=0.1:0.1:10.2; hist1=hist(isi,bins1);% fine scale
Refractory=bins1(max(find(cumsum(hist1)==0)));%abs refr per
N=length(evs);

%%%

figure
subplot(2,1,1),
plot(bins1,hist1,'b.-'); 
ymax=1.1*max(hist1(find(bins1<10))); if ymax<=0, ymax=1; end
axis([0 10 0 ymax]);
xlabel('isi (msec)');ylabel('# observed');
set(gca,'Xtick',1:1:10);
tmp=sprintf('R=%.1f ms',Refractory);
text(7,.8*ymax,tmp);
tmp=sprintf('N=%d',N); text(7,.6*ymax,tmp);
tmpstr=pwd; % get the path to infer the experiment date
tmpind=min(find(tmpstr=='9')); tmpstr=tmpstr(tmpind:tmpind+5);
tmpstr=[tmpstr ' ' eventfile '(plotted ' date ')'];
box off, title(tmpstr);
%%

subplot(2,2,3),
bins2=1:max(isi); hist2=hist(isi,bins2); % coarse scale
hist2=hist2/sum(hist2); % convert to probabilities
semilogx(bins2,hist2); 
box off
ymax=1.1*max(hist2); if ymax<=0, ymax=1; end
axis([1 1000 0 ymax])
set(gca,'xtick',[1 10 100 1000])
xlabel('isi (msec)');ylabel('P(isi)');
tmp=sprintf('mean isi=%.1f ms',mean(isi));
text(20,0.7*ymax, tmp);

subplot(2,2,4),
pre=isi(1:N-2); post=isi(2:N-1); 
h=loglog(pre,post,'b.'); set(h,'markersize',4);hold on
set(gca,'xtick',[1 10 100 1000]);
set(gca,'ytick',[1 10 100 1000]);
% draw the SMS burst criterion for reference
preisi=100; inisi=4;
h=loglog([preisi preisi 5000 5000 preisi],[1.1 inisi inisi 1.1 1.1]); 
set(h,'Color',[.8 .8 .8]);    axis([1 5000 1 5000]), 
%h=patch([preisi preisi 5000 5000 preisi],[1.1 inisi inisi 1.1 1.1],[ .9 .9 .9]);
%set(h,'EdgeColor','k'); %'None'),
hold off
axis([1 1000 1 1000])
xlabel('previous isi'); ylabel('next isi');