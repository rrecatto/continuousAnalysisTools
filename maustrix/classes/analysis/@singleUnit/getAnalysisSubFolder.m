function analysisSubFolder=getAnalysisSubFolder(s,trials)
if length(trials)==1
    analysisSubFolder = sprintf('%d',trials);
    
    if 0 %UNTESTED: ~any(ismember(s.subject,{'231','someOthers'}))
        %later than some date, but not sure when
        if diff(minmax(trials))==0
            %change the name to have no dash
            folderName=num2str(min(trials));
        end
    end
else
    analysisSubFolder = sprintf('%d-%d',min(trials),max(trials));
end
end