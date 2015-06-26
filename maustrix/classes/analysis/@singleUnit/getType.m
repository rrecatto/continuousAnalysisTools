function type=getType(s,stimMgr,stimDetails)
%get the type
type=commonNameForStim(stimMgr,stimDetails);

if 0 %TODO: method to pull form the physiology events as an alternative source
    if isfield(toShow(i).eventParams,'stepName')
        type=toShow(i).eventParams.stepName;
    else
        %old records don't have stepName listed
        %and instead display by stim manager class or uses
        %method stim.commonNameForStim
        analysisParamFileName='x.m'
        dataPath = '\\132.239.158.169\datanetOutput';
        [out details] = createAnalysisScript('231',dataPath,true,analysisParamFileName,false);
        
        error('find which')
        %which=find(details.trialRange(:,1)>=min(trials) && details.trialRange(:,2)<=max(trials))
        if 1
            ind=1;
        else
            error('must be in a single analysis streak')
        end
        
        type=details.type(ind)
    end
end

end