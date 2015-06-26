function [out newLUT]=extractDetailFields(sm,basicRecords,trialRecords,LUTparams)
newLUT=LUTparams.compiledLUT;
out = [];
% error('not yet');
% nAFCindex = find(strcmp(LUTparams.compiledLUT,'nAFC'));
% if isempty(nAFCindex) || (~isempty(nAFCindex) && ~all([basicRecords.trialManagerClass]==nAFCindex))
%     warning('only works for nAFC trial manager')
%     out=struct;
% else
%     try
%         stimDetails=[trialRecords.stimDetails];
%         [out.correctionTrial newLUT] = extractFieldAndEnsure(stimDetails,{'correctionTrial'},'scalar',newLUT);
%         [out.pctCorrectionTrials newLUT] = extractFieldAndEnsure(stimDetails,{'pctCorrectionTrials'},'scalar',newLUT);
% 
%         ims={stimDetails.imageDetails};
%         [out.leftIm newLUT] = extractFieldAndEnsure(cellfun(@(x)x{1},ims,'UniformOutput',true),{'name'},{'typedVector','char'},newLUT);
%         [out.rightIm newLUT] = extractFieldAndEnsure(cellfun(@(x)x{3},ims,'UniformOutput',true),{'name'},{'typedVector','char'},newLUT);
%         out.suffices=nan*zeros(2,length(trialRecords)); %for some reason these are turning into zeros in the compiled file...  why?
%     catch ex
%         out=handleExtractDetailFieldsException(sm,ex,trialRecords);
%         verifyAllFieldsNCols(out,length(trialRecords));
%         return
%     end
% verifyAllFieldsNCols(out,length(trialRecords));
end % end main function

        