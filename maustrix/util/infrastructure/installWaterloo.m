if ~isempty(which('waterloo.m'))
    fprintf('\nIt looks like Waterloo is already present at:\n%s\n',strrep(which('waterloo.m'),[filesep 'Waterloo_MATLAB_Library' filesep 'waterloo.m'],''));
    fprintf('Delete the old waterloo folder and remove it from your MATLAB path first.\n');
else
    installFolder=fullfile(char(java.lang.System.getProperty('user.home')), 'Documents');
    disp('Downloading zip.....this will take a minute or two');
    f=unzip('http://sourceforge.net/projects/waterloo/files/latest/download', installFolder);
    disp('Files have been copied to:');
    if ~isempty(f)
        fprintf('Installed the following %d files/folders:\n', numel(f));
        for k=1:numel(f)
            disp(f{k});
        end
    end
    if isempty(strfind(f{1}, 'Waterloo_MATLAB_Library'))
        disp('Looks like this is the wrong zip file. Stopping');
    else
        if isdir(fullfile(installFolder,'waterloo','Waterloo_MATLAB_Library'))
            addpath(fullfile(installFolder,'waterloo','Waterloo_MATLAB_Library'));
            fprintf('\n%s has been added to the MATLAB search path.\n', fullfile(installFolder,'waterloo','Waterloo_MATLAB_Library'));
            fprintf('\nIf your MATLAB search path been modified since startup (e.g. by software like Waterloo),\nyou should probably answer ''No'' below and add the path manually in a "clean" instance of MATLAB\n');
            response = input('Save the new path for future use [y/N]: ', 's');
            if (lower(response)=='y')
                savepath();
            end
            fprintf('\nTo use Waterloo, type "waterloo" at the MATLAB prompt');
            fprintf('\nThis is best done AT THE START of each MATLAB session as waterloo call''s MATLAB''s javaaddpath function\nwhich can clear existing work\n');
            fprintf('\nRemember that for future MATLAB startups, you need to add:\n%s\nto the MATLAB path if you did not save it above\n\n', fullfile(installFolder,'waterloo','Waterloo_MATLAB_Library'));
        else
            disp('Installation was not successful');
        end
    end
end