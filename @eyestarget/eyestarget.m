function et = eyestarget(varargin)
%EYESTARGET Constructor function for the EYESTARGET class
%   ET = EYESTARGET(SESINFO,EYES) instantiates an EYESTARGET object
%   using a SESINFO object and an EYES object. It reads the binary
%   stimuli file and the marker file, both assumed to be in the parent 
%   directory. Also loads the timing.mat file to get Presenter trigger
%   onsets. By default, the constructor will process eye data from all
%   trials in a session to compute the result, reaction time, markers
%   for each trial. 
%
%   ET = EYESTARGET(SESINFO) instantiates an EYESTARGET object using
%   the SESINFO object and creates an EYES object from the current
%   directory.
%
%   ET = EYESTARGET(EYES) instantiates an EYESTARGET object using
%   the EYES object and creates an SESINFO object from the parent
%   directory.
%
%   ET = EYESTARGET('auto') first checks if the current directory 
%   contains a subdirectory named EYE. If so, it cd's into that
%   directory and attempts to load a previously saved object from the
%   file eyestarget.mat. If no saved objects are found, it then 
%   attempts to create an EYESTARGET object by checking the parent 
%   directory, for the presence of INI files. If one is found, a 
%   SESINFO object is created and used to create the EYESTARGET object. 
%   If no INI files are found, an empty EYESTARGET object is returned. 
%
%   Other optional arguments unique to this class are:
%      nobatch     returns the EYESTARGET object without processing any
%                  trials. This is useful for quickly viewing trial data.
%
%   Optional arguments that are also passed to parent classes are:
%      redolevels  followed by number argument specifying levels.This 
%                  creates an EYESTARGET object if levels is greater than
%                  0 even if there is an eyestarget.mat file present. 
%                  Levels is subtracted by 1 and passed on to all parent 
%                  objects.
%
%      redo        essentially the same as ('redolevels',1).
%
%      savelevels  followed by number argument specifying levels. This 
%                  saves the EYESTARGET object in the file eyestarget.mat
%                  with variable name 'et' if levels is greater than
%                  0. Levels is subtracted by 1 and passed on to all 
%                  parent objects.
%
%      save        essentially the same as ('savelevels',1).
%
%   Inherited from: @eyes, @sesinfo.
%
%   Dependencies: removeargs, ispresent, ContoursReadTargetLocations,
%   ReadMarkerFile, ContoursMarkersToTrials.

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'NoBatch',0);
Args.flags = {'Auto','NoBatch'};
[Args,varargin2] = getOptArgs(varargin,Args, ...
	'subtract',{'RedoLevels','SaveLevels'}, ...
	'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
	'remove',{'Auto','NoBatch'});

% initialize class structure
t.targets = [];
t.tmarkers = [];
t.onsets = [];
t.onsetsMS = [];
t.results = [];
t.mresults = [];
t.rt = [];
t.markers = {};

if nargin==0
	% create empty object
	et = CreateEmptyEyesTarget(t);
elseif ((nargin==1) & (isa(varargin{1},'eyestarget')))
	et = varargin{1};
else
	% try going to eye directory
	[pdir,cdir] = getDataDirs('eye','relative','CDNow');
	% getDataDirs could fail because we are using the old data hierarchy so we will
	% fall back on the following code to work on old data
	if(isempty(cdir))
		% if there is an eye subdirectory, we are probably in the session dir
		% so change to the eye subdirectory
		[r,a] = ispresent('eye','dir','CaseInsensitive');
		if r
			cdir = pwd;
			cd(a);
		end
	end	
	
	if(Args.Auto)
		% assume we are in eye subdirectory and check for presence of 
		% saved object
		if (ispresent('eyestarget.mat','file','CaseInsensitive') ...
                & (Args.RedoLevels==0))
			fprintf('Loading saved eyestarget object...\n');
			l = load('eyestarget.mat');
			et = l.et;
		% no saved object so we will try to create one
		else
			% keep current directory
			% cwd = pwd;
			% go to parent directory
			% cd ..			
			% create sesinfo
			s = sesinfo('auto',varargin2{:});
			% go back to previous directory
			% cd(cwd)
			% check if sesinfo object is empty
			if (isempty(s))
				et = CreateEmptyEyesTarget(t);
			else
				e = eyes(s.sessionname,1:2,'pixels');
				e.holdaxis = 0;
				t = ReadStimuliMarkersTargets(s,t);
				et = class(t,'eyestarget',s,e);
				if(~Args.NoBatch)
					et = ProcessAllTrials(et,varargin2{:});
				end
				if(Args.SaveLevels)
					fprintf('Saving eyestarget object...\n');
					save eyestarget et
				end
				% check differences between results using markers
				% and results using eye signals
				diffResults(et);
			end
		end
	else
		switch num_args
		case 1
			if (isa(varargin{1},'sesinfo'))
				% create eyes object and inherit from eyes and sesinfo objects
				s = varargin{1};
				e = eyes(s.sessionname,1:2,'pixels');
				e.holdaxis = 0;
				t = ReadStimuliMarkersTargets(s,t);
				et = class(t,'eyestarget',s,e);		
				if(~Args.Batch)
					et = ProcessAllTrials(et,varargin2{:});
				end
				if(Args.SaveLevels)
					fprintf('Saving eyestarget object...\n');
					save eyestarget et
				end
				% check differences between results using markers
				% and results using eye signals
				diffResults(et);
			elseif (isa(varargin{1},'eyes'))
				% create sesinfo object and inherit from both sesinfo and eyes objects
				e = varargin{1};
				e.holdaxis = 0;
				s = sesinfo(e.sessionname,varargin2{:});
				t = ReadStimuliMarkersTargets(s,t);
				et = class(t,'eyestarget',s,e);
				if(~Args.Batch)
					et = ProcessAllTrials(et,varargin2{:});
				end
				if(Args.SaveLevels)
					fprintf('Saving eyestarget object...\n');
					save eyestarget et
				end
				% check differences between results using markers
				% and results using eye signals
				diffResults(et);
			else
				error('Wrong argument types')
			end
		case 2
			if (isa(varargin{1},'sesinfo') & isa(varargin{2},'eyes'))
				s = varargin{1};
				e = varargin{2};
				e.holdaxis = 0;
				t = ReadStimuliMarkersTargets(s,t);
				et = class(t,'eyestarget',s,e);
				if(~Args.Batch)
					et = ProcessAllTrials(et,varargin2{:});
				end
				if(Args.SaveLevels)
					fprintf('Saving eyestarget object...\n');
					save eyestarget et
				end
				% check differences between results using markers
				% and results using eye signals
				diffResults(et);
			elseif (isa(varargin{1},'eyes') & isa(varargin{2},'sesinfo'))
				e = varargin{1};
				e.holdaxis = 0;
				s = varargin{2};
				t = ReadStimuliMarkersTargets(s,t);
				et = class(t,'eyestarget',s,e);
				if(~Args.Batch)
					et = ProcessAllTrials(et,varargin2{:});
				end
				if(Args.SaveLevels)
					fprintf('Saving eyestarget object...\n');
					save eyestarget et
				end
				% check differences between results using markers
				% and results using eye signals
				diffResults(et);
			else
				error('Wrong argument types')
			end
		otherwise
			error('Wrong number of input arguments')
		end
	end
	
	% change back to parent directory if we changed dir, just in case we
	% are in some batch script which is not expecting us to be changing
	% directories
	if(~isempty(cdir))
		cd(cdir)
	end
end

%---------------------------------------
function t = ReadStimuliMarkersTargets(s,t)

targets = ContoursReadTargetLocations(['..' filesep s.sessionname '_stimuli.bin']);
t.targets = targets(s.isequence+1,:);
a = load(['..' filesep s.sessionname 'timing.mat']);
t.onsets = a.presTrigOnsets;
t.onsetsMS = a.presTrigOnsetsMS;
% get name of marker file
mname = ['..' filesep s.sessionname '.mrk'];
[res,rmname] = ispresent(mname,'file','CaseInsensitive');
if(res)
	[markers,records] = ReadMarkerFile(rmname);		
	t.tmarkers = ContoursMarkersToTrials(markers);
% end

%%%%%%%%%%%%%%%to process incomplete sessions
minimum = min([length(t.targets) length(t.tmarkers) length(t.onsets) length(t.onsetsMS)]);
t.targets = t.targets(1:minimum,:);
t.onsets = t.onsets(1:minimum,1);
t.onsetsMS = t.onsetsMS(1:minimum,1);
t.tmarkers = t.tmarkers(1,1:minimum);
end
%---------------------------------------
function et = CreateEmptyEyesTarget(t)

s = sesinfo;
e = eyes;
e.holdaxis = 0;
et = class(t,'eyestarget',s,e);
