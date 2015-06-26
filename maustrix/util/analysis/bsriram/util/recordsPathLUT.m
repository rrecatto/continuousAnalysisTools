function out = recordsPathLUT(in,direction)
if ~exist('direction','var')||isempty(direction)
    direction='Lx2Win';
end
if ~exist('in','var')||isempty(in)
    error('need an in')
end
LinuxPaths = {'/media/LaCie/physiologyData/bsPaper1','/media/LaCie/physiologyData','/home/balaji/Documents/work/datanetOutput','/media/LaCie/physiologyData/dbs','/home/balaji/datanetOutput','/home/balaji/datanetOutput'};
WindowsPaths = {'\\132.239.158.158\bsPaper1','\\132.239.158.158\physdata','\\132.239.158.164\datanetOutput','\\132.239.158.158\physdata\dbs','\\132.239.158.169\datanetOutput','\\132.239.158.169\datanetOutput\'};

switch direction
    case 'Lx2Win' % input is a linux directory, output should be a win directory
        index = strcmp(in,LinuxPaths);
        out = WindowsPaths{index};
    case 'Win2Lx'
        index = strcmp(in,WindowsPaths);
        out = LinuxPaths{index};
    otherwise
        error('unknown direction');
end
end