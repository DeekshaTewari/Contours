function pf = performance(varargin)
%PERFORMANCE Constructor function for PERFORMANCE object
%   P = PERFORMANCE(EYESTARGET) instantiates a PERFORMANCE object using a 
%   EYESTARGET object. 
%
%   P = PERFORMANCE('auto') attempts to instantiate a PERFORMANCE
%   object by first attempting to create an EYESTARGET object.
%
%   Optional arguments that are also passed to parent classes are:
%      redolevels  followed by number argument specifying levels.This 
%                  creates a PERFORMANCE object if levels is greater than
%                  0 even if there is a performance.mat file present. 
%                  Levels is subtracted by 1 and passed on to all parent 
%                  objects.
%
%      redo        essentially the same as ('redolevels',1).
%
%      savelevels  followed by number argument specifying levels. This 
%                  saves the PERFORMANCE object in the file performance.mat
%                  with variable name 'pf' if levels is greater than
%                  0. Levels is subtracted by 1 and passed on to all 
%                  parent objects.
%
%      save        essentially the same as ('savelevels',1).
%
%   The object contains the following fields:
%      P.sessions
%      P.daysessions
%      P.session().sessionname
%      P.session().contour(i).result
%      P.session().control(i).result
%      P.session().catchcontour(i).result
%      P.session().catchcontrol(i).result
%      P.contourresults
%      P.controlresults
%      P.overallresults
%      P.catchcontourresults
%      P.catchcontrolresults
%      P.catchoverallresults
%      P.contourmean
%      P.contoursd
%      P.controlmean
%      P.controlsd
%      P.overallmean
%      P.overallsd
%      P.catchcontourmean
%      P.catchcontoursd
%      P.catchcontrolmean
%      P.catchcontrolsd
%      P.catchoverallmean
%      P.catchoverallsd
%	where i is the salience level, 'result' is an array containing 1 
%   or 0 (indicating whether the response was correct or incorrect) for
%   each repetition of the salience condition; 'contourresults' is a two
%   column array with the total number of correct trials in the first
%   column and the total number of trials in the second. Each row in the
%   array represents a salience condition with the first row being the
%   highest salience and so on down; 'contourmean' and 'contoursd' are
%   the mean and standard error for each salience condition, calculated
%   using the Bernouilli process. The other entries contain similar 
%   calculations for the control, catchcontour and the catchcontrol 
%   trials.
%
%   Inherited from: @eyestarget.
%
%	Dependencies: eyestarget, removeargs.

if nargin==0
	% create empty object
	e = eyestarget;
	e = set(e,'Number',1);
	e = set(e,'HoldAxis',1);
	pf = CreateEmptyPerformance(e);
elseif ((nargin==1) & (isa(varargin{1},'performance')))
	pf = varargin{1};
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
		% change to the proper directory
        [pdir,cdir] = getDataDirs('session','relative','CDNow');
		% check for presence of saved object
		if (ispresent('performance.mat','file','CaseInsensitive') & (redo==0))
			fprintf('Loading saved performance object...\n');
			l = load('performance.mat');
			pf = l.pf;
		else
			% no saved object so we will try to create one
			% try to create eyestarget object
			e = eyestarget('auto',varargin{:});
			% check if eyestarget is empty
			if (isempty(e))
				pf = CreateEmptyPerformance(e);
			else	
				d = EyesTargetToPerformance(e);
				e = set(e,'Number',1);
				e = set(e,'HoldAxis',1);
				pf = class(d,'performance',e);
				if saveobj
					fprintf('Saving performance object...\n');
					save performance pf
				end
			end
		end
        % change back to previous directory if necessary
        if(~isempty(cdir))
            cd(cdir)
        end
	elseif ((num_args == 1) & (isa(varargin{1},'eyestarget')))
		e = varargin{1};
		d = EyesTargetToPerformance(e);
		e = set(e,'Number',1);
		e = set(e,'HoldAxis',1);
		pf = class(d,'performance',e);
		if saveobj
			fprintf('Saving performance object...\n');
			save performance pf
		end
	else
		error('Wrong argument type')
	end
end

%---------------------------------------
function pf = CreateEmptyPerformance(e)

d.sessions = 0;
d.daysessions = [];
d.session = [];
d.contourresults = [];
d.controlresults = [];
d.overallresults = [];
d.catchcontourresults = [];
d.catchcontrolresults = [];
d.catchoverallresults = [];
d.contourmean = [];
d.contoursd = [];
d.controlmean = [];
d.controlsd = [];
d.overallmean = [];
d.overallsd = [];
d.catchcontourmean = [];
d.catchcontoursd = [];
d.catchcontrolmean = [];
d.catchcontrolsd = [];
d.catchoverallmean = [];
d.catchoverallsd = [];
pf = class(d,'performance',e);
