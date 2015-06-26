function model = getPreferredModel(in,params)
numModels = length(in.fitParams);
quals = nan(1,numModels);
for i = 1:numModels
    quals(i) = in.fitValues{i}.chosenRF.quality;
end
[bestQual ind] = max(quals);
switch params.mode
    case 'supraBetterThanRestBy'
        if ~isempty(strfind(in.fitParams{ind}.searchAlgorithm,'suprabalanced'))
            % make a decision bsed on the next best quality
            whichInds = 1:numModels;
            whichInds = whichInds(whichInds~=ind);
%             whichOtherModels = in.fitValues(whichInds);
            qualsOther = quals(whichInds);
            [nextBestQual indOther] = max(qualsOther);
            if (bestQual-nextBestQual)<params.betterBy
                % change the ind to the appropriate ind
                ind = whichInds(indOther);
            end
        end
end
model = in.fitParams{ind};
model.chosenRF = in.fitValues{ind}.chosenRF;
end