function s = sesinfo(varargin)
%SESINFO Constructor function for SESINFO object
%	S = SESINFO(SESSIONNAME) instantiates a SESINFO object by reading
%   SESSIONNAME.INI, which is assumed to be in the current directory. 
%
%   S = SESINFO('auto') tries to instantiate the object by using the
%   session name from INI files present in the current directory.
%
%   S = SESINFO creates an empty sesinfo object.
%
%   Optional arguments are:
%      redolevels  followed by number argument specifying levels.This 
%                  creates a SESINFO object if levels is greater than
%                  0 even if there is an sesinfo.mat file present. 
%
%      redo        essentially the same as ('redolevels',1).
%
%      savelevels  followed by number argument specifying levels. This 
%                  saves the SESINFO object in the file sesinfo.mat
%                  with variable name 's' if levels is greater than
%                  0. 
%
%      save        essentially the same as ('savelevels',1).
%
%   The object contains the following fields:
%      S.sessionname
%      S.stim_p
%      S.stim_steps
%      S.stim_sets
%      S.catch_trials
%      S.fixx
%      S.fixy
%      S.isequence() - contains the 0-indexed stimulus number presented
%                      on each trial.
%      S.ulsequence() - contains the 1-indexed trial number in which
%                       each stimulus was used. The order is stimulus0
%                       (repeated for however many repeats), stimulus1,
%                       etc.
%      S.sequence() - contains the ulsequence broken up into the
%                     following fields for easy access:
%                        .contour().stimulus().repetition
%                        .control().stimulus().repetition
%                        .catchcontour().stimulus().repetition
%                        .catchcontrol().stimulus().repetition
%
%   Dependencies: removeargs, ispresent.

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0);
Args.flags = {'Auto'};
[Args,modvarargin] = getOptArgs(varargin,Args, ...
	'subtract',{'RedoLevels','SaveLevels'}, ...
	'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
	'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'sesinfo';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 's';

numArgin = nargin;
if(numArgin==0)
	% pass 0 to ReadIniFile so it will just create an empty object
	d = ReadIniFile('');
	s = class(d,'sesinfo');
elseif ((nargin==1) & (isa(varargin{1},Args.classname)))
	s = varargin{1};
else
	% create object using arguments
	if(Args.Auto)
		% change to the proper directory
        [pdir,cdir] = getDataDirs('session','relative','CDNow');
		% check for saved object
		if(~isempty(nptDir(Args.matname,'CaseInsensitive')) ...
			& (Args.RedoLevels==0))
			fprintf('Loading saved sesinfo object...\n');
			l = load('sesinfo.mat');
			s = l.s;
		else % if check for saved object
			% get list of ini files
			dfiles = nptDir('*.ini','CaseInsensitive');
            if(isempty(dfiles))
				% pass 0 to ReadIniFile so it will just create an empty object
				d = ReadIniFile('');
				s = class(d,'sesinfo');
            else % if(isempty(dfiles))
                cmdstr = sprintf('grep -ls Contour %s ',dfiles(:).name);
                % try to create object using files in the current directory
                % get platform
                platform = computer;			
                if strcmp(platform,'PCWIN')
                    % make sure grep is installed on the PC
                    [s,fname] = dos(cmdstr);
                else % if strcmp(platform,'PCWIN')
                    [s,fname] = system(cmdstr);
                end % if strcmp(platform,'PCWIN')
                if ~isempty(fname)
                    % last char needs to be removed otherwise the string won't
                    % be recognized by Windows machines or Matlab 7
                    fl = length(fname);
                    % ascii value 10 is the newline character
                    if(double(fname(fl))==10)
                        fname = fname(1:(fl-1));
                    end
                    d = ReadIniFile(fname);
                    % check if this is an incomplete session
                    % get number of data files
                    % rawfiles = nptDir('*.0*','CaseInsensitive');
                    % nrfiles = size(rawfiles,1);
                    % check if emptylastfile.txt exists
                    % if(~isempty(nptDir('emptylastfile.txt','CaseInsensitive')))
                    % 	nrfiles = nrfiles - 1;
                    % end
                    % adjust sequence accordingly
                    s = class(d,'sesinfo');
                    if(Args.SaveLevels)
                        fprintf('Saving sesinfo object...\n');
                        save sesinfo s
                    end
                else % if ~isempty(fname)
                    % pass 0 to ReadIniFile so it will just create an empty object
                    d = ReadIniFile('');
                    s = class(d,'sesinfo');
                end % if ~isempty(fname)
            end % if(isempty(dfiles))
		end % if check for saved object
        % change back to previous directory if necessary
        if(~isempty(cdir))
            cd(cdir)
        end
	else % if(Args.Auto)
		% check to see if we were given just the session name
		[r,a] = ispresent([varargin{1} '.ini'],'file','CaseInsensitive');
		if r
			d = ReadIniFile(a);
			s = class(d,'sesinfo');
			if(Args.SaveLevels)
				fprintf('Saving sesinfo object...\n');
				save sesinfo s
			end
		% check to see if we were given the full file name
		elseif ispresent(varargin{1},'file','CaseInsensitive')
			d = ReadIniFile(varargin{1});
			s = class(d,'sesinfo');
			if(Args.SaveLevels)
				fprintf('Saving sesinfo object...\n');
				save sesinfo s
			end
		else
			error('Wrong argument type')
		end
	end % if(Args.Auto)
end % if(numArgin==0)
