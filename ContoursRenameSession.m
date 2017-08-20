function ContoursRenameSession
%ContoursRenameSession Fix improperly named files for a day
%   ContoursRenameSession will rename all the files in a day directory
%   (where the raw files have been moved into session directories)
%   to remove an extra 0 in the session number, i.e. disco080202001
%   will be renamed to disco08020201. Files with the right session
%   names will not be changed, and neither will descriptor files.
%
%   Dependencies: nptDir, nptFileParts.

% get list of sessions
sessions = nptDir;
sSize = size(sessions,1);

for i = 1:sSize
    if sessions(i).isdir
		cd(sessions(i).name)
		% get list of files
		dlist = nptDir;
		dSize = size(dlist,1);
		for j = 1:dSize
			[path,name,suffix] = nptFileParts(dlist(j).name);
			% files on control were okay so we don't want to change any files
			% with the right session name. Descriptor files were fine too
			% so we have to skip those too
            if (length(name) > 13) & (isempty(findstr('descriptor',name)))
				newName = [name(1:11) name(13:end) suffix];
				fprintf('Renaming %s to %s\n',dlist(j).name,newName);
				[s,w] = system(sprintf('mv %s %s',dlist(j).name,newName));
            end
		end
		cd ..
    end
end
