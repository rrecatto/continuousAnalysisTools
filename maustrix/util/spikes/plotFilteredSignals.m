function plotFilteredSignals(data, han)
if ~exist('han','var')||isempty(han)
    han = axes; 
end
N=round(min(data.samplingRate/200,floor(size(data.chunk1.neuralData,2)/3))); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
[b,a]=fir1(N,2*[300 10000]/data.samplingRate);
filteredSignal=filtfilt(b,a,data.chunk1.neuralData');
filteredSignal = filteredSignal/50;
% figure;
n = 10;
m = 3;
axes(han)
hold off;
for i = 1:size(data.chunk1.neuralData,2)
    plot(filteredSignal(i,:)+n*i);hold on;
    currSTD = std(filteredSignal(i,:));
    plot([1,size(filteredSignal,2)],[n*i+m*currSTD n*i+m*currSTD],'r--');
    plot([1,size(filteredSignal,2)],[n*i-m*currSTD n*i-m*currSTD],'r--');
    
    %plot(data.neuralRecords(i,:)+n*i,'k')
end

% figure;
% for i = 2:size(data.chunk1.neuralData,2)
%     plot(data.chunk1.neuralData(:,i)+n*i);hold on;
% end