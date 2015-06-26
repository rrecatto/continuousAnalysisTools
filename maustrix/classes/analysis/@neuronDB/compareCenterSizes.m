function compareCenterSizes(db,params)
if ~exist('params','var')||isempty(params)
    params = [];
    params.includeNIDs = 1:db.numNeurons;
    params.deleteDupIDs = false;
    params.subtractShuffleEstimate = true;
elseif isnumeric(params)
    temp = params;
    clear params
    params.includeNIDs = temp;
    params.deleteDupIDs = false;
    params.subtractShuffleEstimate = true;
end
which = 'sfGratings';
[aIndSF nIDSF subAIndSF]=selectIndexTool(db,which,params);
which = 'binarySpatial';
[aIndWN nIDWN subAIndWN]=selectIndexTool(db,which,params);
nIDs = intersect(unique(nIDSF),unique(nIDWN));
rSF = nan(1,length(nIDs));
rWN = rSF;


% get the whiteNoise Estimate
paramsWN.includeNIDs = nIDs;
paramsWN.deleteDupIDs = false;
rfSizes = getFacts(db,{{'binarySpatial','rfSize'},paramsWN});
xConvFactor = getFacts(db,{{'binarySpatial','anglePerUnitScreen'},paramsWN});
for i = 1:length(nIDs)
    temp = rfSizes.results{i}.*xConvFactor.results{i};
    rWN(i) = temp(1);
end

% get the SF estimate
for i = 1:length(nIDs)
    % get the whiteNoise Estimate
    whichSF = find(ismember(nIDSF,nIDs(i)),1,'first');
    modelSelectionParams.mode = 'supraBetterThanRestBy';
    modelSelectionParams.betterBy = 0.02;
    temp = getPreferredModel(db.data{nIDSF(whichSF)}.analyses{subAIndSF(whichSF)}.model.DOGFit,modelSelectionParams);
    rSF(i) = temp.chosenRF.RC;
end

which = rWN<10;
rWN = rWN(which);
rSF = rSF(which);

which = rSF<10;
rWN = rWN(which);
rSF = rSF(which);

figure;
scatter(rWN,rSF);

xlabel('white noise estimate')
ylabel('DOG-fit estimate');

keyboard
end