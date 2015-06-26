function plotAndSaveDailyReport(compiledFileDir,dailyAnalysisPath,subjectID)

apath=compiledFileDir;

d=dir(fullfile(apath,'*.compiledTrialRecords.*.mat')); %is this legit?
subStrs={};
for i=1:length(d)
    tmp=textscan(d(i).name,'%[^.].compiledTrialRecords.%d-%d.mat'); %lame that textscan doesn't take cell arrays in, nor works when each line separated by \n, also couldn't find sscanf solution
    subStrs{end+1}=tmp{1}{1};
end

if length(subStrs)<=0
    apath
    d.name
    error('no compiled records found in that directory')
end

fs=[];

sel.type='all';
subID={subjectID};
sel.filter='all';
sel.filterVal = [];
sel.filterParam = [];
sel.titles={['subject ' subjectID]};
sel.subjects{1,1,1}=subjectID;
        
        
fs=analysisPlotter(sel,apath,true);

saveLoc = fullfile(dailyAnalysisPath,subjectID);
if ~isdir(saveLoc)
    mkdir(saveLoc);
end
filename = sprintf('%s_%s.pdf',subjectID,datestr(now,'dd-mmm-yyyy'));
print(fs,'-dpdf',fullfile(saveLoc,filename));
close(fs);

