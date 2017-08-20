function tm = timing(varargin)
%TIMING Constructor function for TIMING object
%   T = TIMING(EYESTARGET) instantiates a TIMING object using a 
%   EYESTARGET object. 
%
%   T =  TIMING('auto') attempts to instantiate a TIMING object 
%   by first attempting to create an EYESTARGET object.
%
%   Optional arguments that are also passed to parent classes are:
%      redolevels  followed by number argument specifying levels.This 
%                  creates a TIMING object if levels is greater than
%                  0 even if there is a timing.mat file present. 
%                  Levels is subtracted by 1 and passed on to all parent 
%                  objects.
%
%      redo        essentially the same as ('redolevels',1).
%
%      savelevels  followed by number argument specifying levels. This 
%                  saves the TIMING object in the file timing.mat
%                  with variable name 'tm' if levels is greater than
%                  0. Levels is subtracted by 1 and passed on to all 
%                  parent objects.
%
%      save        essentially the same as ('savelevels',1).
%
%   The object contains the following fields:
%      T.sessions
%      T.sessionname{}
%      T.data.contour().indexes()
%      T.data.contour().timing()
%      T.data.catchcontour().indexes()
%      T.data.catchcontour().timing()
%      T.data.control().indexes()
%      T.data.control().timing()
%      T.data.catchcontrol().indexes()
%      T.data.catchcontrol().timing()
%      T.data.median.contour()
%      T.data.median.catchcontour()
%      T.data.median.control()
%      T.data.median.catchcontrol()
%      T.data.quartiles.contour()
%      T.data.quartiles.catchcontour()
%      T.data.quartiles.control()
%      T.data.quartiles.catchcontrol()
%      T.data.median.overall.contour()
%      T.data.median.overall.catchcontour()
%      T.data.median.overall.control()
%      T.data.median.overall.catchcontrol()
%      T.data.quartiles.overall.contour()
%      T.data.quartiles.overall.catchcontour()
%      T.data.quartiles.overall.control()
%      T.data.quartiles.overall.catchcontrol()
%	where i is the salience level, timing contains the reaction times
%   for successful trials, contourmedian contains the median reaction
%   times for each salience level, and contourquartiles contains the
%   25th and 75th percentile value for the reaction times. Similar 
%   values are computed for the control, catchcontour, and catchcontrol
%   trials.
%
%   Inherited from: @eyestarget.
%
%	Dependencies: @timing/private/EyesTargetToTiming.

if nargin==0
	% create empty object
	e = eyestarget;
	e = set(e,'Number',1);
	e = set(e,'HoldAxis',0);
	tm = CreateEmptyTiming(e);
elseif ((nargin==1) & (isa(varargin{1},'timing')))
	tm = varargin{1};
else
	% default values for optional arguments
	auto = 0;
	redo = 0;
	saveobj = 0;

	% look for optional arguments
	num_args = nargin;
	i = 1;
	while(i <= num_args)
		if ischar(varargin{i})
			switch varargin{i}
			case('auto')
				auto = 1;
				% remove argument from varargin
				[varargin,num_args] = removeargs(varargin,i,1);
			case('redo')
				redo = 1;
				% remove this argument since it only applies to this class
				[varargin,num_args] = removeargs(varargin,i,1);
			case('save')
				saveobj = 1;
				% remove this argument since it only applies to this class
				[varargin,num_args] = removeargs(varargin,i,1);
			case('redolevels')
				% read the levels argument
				levels = varargin{i+1};
				if (levels==1)
					redo = 1;
					% remove arguments since this is the final level
					[varargin,num_args] = removeargs(varargin,i,2);
				elseif (levels>0)
					redo = 1;
					varargin{i+1} = levels - 1;
					i = i + 2;
				else
					% shouldn't have this but just in case
					% remove arguments
					[varargin,num_args] = removeargs(varargin,i,2);
				end
			case('savelevels')
				% read the levels argument
				levels = varargin{i+1};
				if (levels==1)
					saveobj = 1;
					% remove arguments since this is the final level
					[varargin,num_args] = removeargs(varargin,i,2);
				elseif (levels>0)
					saveobj = 1;
					varargin{i+1} = levels - 1;
					i = i + 2;
				else
					% shouldn't have this but just in case
					% remove arguments
					[varargin,num_args] = removeargs(varargin,i,2);
				end
			otherwise
				i = i + 1;
			end
		else
			i = i + 1;
		end
	end
	
	if auto
		% check for presence of saved object
		if (ispresent('timing.mat','file','CaseInsensitive') & (redo==0))
			fprintf('Loading saved timing object...\n');
			l = load('timing.mat');
			tm = l.tm;
		else
			% no saved object so we will try to create one
			% try to create eyestarget object
			e = eyestarget('auto',varargin{:});
			% check if eyestarget is empty
			if (isempty(e))
				tm = CreateEmptyTiming(e);
			else	
				d = EyesTargetToTiming(e);
				e = set(e,'Number',1);
				e = set(e,'HoldAxis',0);
				tm = class(d,'timing',e);
				if saveobj
					fprintf('Saving timing object...\n');
					save timing tm
				end
			end
		end
	elseif ((num_args == 1) & (isa(varargin{1},'eyestarget')))
		e = varargin{1};
		d = EyesTargetToTiming(e);
		e = set(e,'Number',1);
		e = set(e,'HoldAxis',0);
		tm = class(d,'timing',e);
		if saveobj
			fprintf('Saving timing object...\n');
			save timing tm
		end
	else
		error('Wrong argument type')
	end
end

%---------------------------------------
function tm = CreateEmptyTiming(e)

d.sessions = 0;
d.sessionname = {};
d.data = [];
e = set(e,'HoldAxis',0);
tm = class(d,'timing',e);
