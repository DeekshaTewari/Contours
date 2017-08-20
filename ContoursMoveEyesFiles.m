function ContoursMoveEyesFiles
%ContoursMoveEyesFiles Move files out of Eyes directory
%   ContoursMoveEyesFiles moves files session by session out of the
%   Eyes directory. This is sometimes necessary if the number of 
%   files in the Eyes directory exceeds the limitations of the mv 
%   command.
%
%   Dependencies: None.

% get list of sessions
session = nptDir;
sesSize = size(session,1);
cwd = pwd;
[path,day] = nptFileParts(cwd);
for i=1:sesSize
	if session(i).isdir
		% make sure it is not the Eyes directory
		if ~strcmp(session(i).name,'Eyes')
            fprintf('Moving %s\n',session(i).name);
			[s,w] = system(sprintf('mv Eyes/*%s%s.* %s',day,session(i).name,session(i).name));
		end
	end
end
