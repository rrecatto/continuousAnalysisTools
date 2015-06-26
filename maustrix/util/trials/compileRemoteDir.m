function compileRemoteDir(RemoteDirBase,boxes,mice,recompile)
except = {}
% 225 - 42603 - 42696 - box 1
% 216 - 51394 - 51707 - box 2
% 213 - 46098 - 46321 - box 3

if ~exist('boxes','var') || isempty(boxes)
    boxes = {'Box1','Box2','Box3','Box4','Box5','Box6','PV-V1-hM3D','PV-TRN-hM3D','SCLesion','ORSweeps','VarDur','Motion','Reversal2'};
elseif ~iscell(boxes)
    error('either dont give boxes or give it as a sequence of cellstrs');
end

if ~exist('mice','var') || isempty(mice)
    mice = 'all';
elseif ~iscell(mice)
    error('either dont give mice or give it as a sequence of cellstrs');
end

if ~exist('recompile','var') || isempty(recompile)
    recompile = false;
elseif ~isogical(recompile)
    error('recompile should be a logical');
end

if ~exist('RemoteDirBase','var') || isempty(RemoteDirBase)
    RemoteDirBase = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\';
end
completedMice = {};
for i = 1:length(boxes)
    boxes{i}
    currBoxDir = fullfile(RemoteDirBase,boxes{i});
    miceInBox = dir(fullfile(currBoxDir,'Permanent'));
    miceInBox = miceInBox([miceInBox.isdir]);
    miceInBox = miceInBox(~ismember({miceInBox.name},{'.','..','.DS_Store','.AppleDouble','999'}));
    miceInBox = miceInBox(~ismember({miceInBox.name},except));
    miceInBox = {miceInBox.name};
    if ischar(mice) && strcmp(mice,'all')
        miceToCompile = miceInBox;
    else
        miceToCompile = intersect(mice,miceInBox);
    end
    compileDetailedRecords([],miceToCompile,recompile,fullfile(currBoxDir,'Permanent'),fullfile(currBoxDir,'Compiled'));
    completedMice = union(completedMice,miceToCompile);
end

if iscell(mice) && ~isempty(setdiff(mice,completedMice))
    which = setdiff(mice,completedMice);
    fprintf('Some mice have not been compiled::');
    disp(which);
    keyboard
end

end