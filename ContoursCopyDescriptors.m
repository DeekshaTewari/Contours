function ContoursCopyDescriptors(srcFile,varargin)
%ContoursCopyDescriptors Copy descriptors to directories.
%   ContoursCopyDescriptors(FILENAME) copies FILENAME to directories
%   without a descriptor file.
%      e.g.
%      ContoursCopyDescriptors('071602/01/annie07160201_descriptor.txt')
%
%   ContoursCopyDescriptors(FILENAME,CELL_ARRAY) checks only the
%   directories that are listed in CELL_ARRAY.
%      e.g. ContoursCopyDescriptors('annie07160201_descriptor.txt',{'062102','062202'})
%   will only copy the descriptor file to the directories listed.
%
%   Dependencies: nptDir, nptFileParts.

if nargin > 1
	checklist = 1;
	clist = varargin{1};
else
	checklist = 0;
end

% get list of days
dlist = nptDir;
dsize = size(dlist,1);
for i = 1:dsize
	if dlist(i).isdir
		% the only time we won't go into the directory is if checklist==1
		% and the name is not in clist.
		if ~((checklist == 1) & (max(strcmp(dlist(i).name,clist))==0))
			% cd into day directory
			cd(dlist(i).name);
			slist = nptDir('*.mrk');
			ssize = size(slist,1);
			dslist = nptDir('*descriptor.txt');
			dssize = size(dslist,1);
			if dssize ~= ssize
				for j = 1:ssize
					[path,name,ext] = nptFileParts(slist(j).name);
					targetName = [name '_descriptor.txt'];
					cmdstr = ['cp ../' srcFile ' ' targetName];
					fprintf([cmdstr '\n']);
					[s,w] = system(cmdstr);
				end
			end
			% back to days directory
			cd ..
		end
	end
end
