function ContoursSessionsDiff(sobj,varargin)
%ContoursSessionsDiff Compares sesinfo objects
%   ContoursSessionsDiff(SESINFO) takes a SESINFO object and compares
%   it to sessions found on a CD.
%
%   Dependencies: nptDir.

notCD = 0;

if nargin>1
	switch varargin{1}
	case 'notCD'
		notCD = 1;
	otherwise
		error('Unknown argument');
	end
end

while 1
	% get keyboard input to see what to do next
	key = input('RETURN - Next CD; q - Quit: ','s');
	if strcmp(key,'q')
		break;
	else
		if notCD == 0
			cd Volumes
			% get volume name
			clist = nptDir;
			% cd into volume
			cd(clist(1).name)
		end
        % get days
		dlist = nptDir;
		dsize = size(dlist,1);
		for i = 1:dsize
			% check to see if it is a directory
			if isdir(dlist(i).name)
                % cd into day directory
                fprintf('Checking %s\n',dlist(i).name);
				cd(dlist(i).name)
				% check to see if there is an Eyes directory
				elist = nptDir('Eyes');
				if ~isempty(elist)
					% old data hierarchy, get list of ini files and compare
					i0list = nptDir('*.ini');
					i1list = nptDir('*.INI');
					ilist = [i0list;i1list];
					isize = size(ilist,1);
					for k = 1:isize
						if isEyeCal(ilist(k).name) == 0                        	
							fprintf('\tComparing %s\n',ilist(k).name);
							diff(sobj,sesinfo(ilist(k).name));
						else
							fprintf('\tEyeCal %s\n',ilist(k).name);
						end
					end
				else
					% get sessions
					slist = nptDir;
					ssize = size(slist,1);
					for j = 1:ssize
						if isdir(slist(j).name)
							% cd into session directory
							cd(slist(j).name)
							i0list = nptDir('*.ini');
							i1list = nptDir('*.INI');
							ilist = [i0list;i1list];
							isize = size(ilist,1);
							for k = 1:isize
								if isEyeCal(ilist(k).name) == 0                        	
									fprintf('\tComparing %s\n',ilist(k).name);
									diff(sobj,sesinfo(ilist(k).name));
								elseif isempty(findstr(ilist(k).name,'_rfs'))
									fprintf('\tEyeCal %s\n',ilist(k).name);
								end
							end
							% leave session directory
							cd ..
						end
					end
				end
                % leave day directory
				cd ..
			end
		end
		if notCD == 0
			% leave volume
			cd ..
			% leave /Volumes
			cd ..
			% some weird Matlab bug that does not allow the CD to be ejected
			% unless we do an ls on the parent directory
			[s,w] = system('ls');
		end
	end
end
      	
      