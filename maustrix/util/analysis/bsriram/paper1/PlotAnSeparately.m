load('C:\Users\ghosh\Documents\MATLAB\bsPaper2_20130222T093653.mat');
dbAw = db;
load('C:\Users\ghosh\Documents\MATLAB\basOnlyAnesth_20130327T103432.mat');
dbAn = db;

f10AnTemp1 = dbAn.getFacts({'tfGrating',{'f1/f0',2}});

f10AwTemp1 = dbAw.getFacts({'tfGrating',{'f1/f0',2}});
f10AwTemp2 = dbAw.getFacts({'tfFullField',{'f1/f0',2}});

f10An = [];
for i = 1:length(f10AnTemp1.results)
    f10An(end+1) = f10AnTemp1.results{i}{1}{2};
end


f10Aw = [];
for i = 1:length(f10AwTemp1.results)
    f10Aw(end+1) = f10AwTemp1.results{i}{1}{2};
end

for i = 1:length(f10AwTemp2.results)
    f10Aw(end+1) = f10AwTemp2.results{i}{1}{2};
end


%% Plot the Sf Peak power and cutoffs


