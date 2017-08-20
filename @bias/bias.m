function obj = bias(varargin)
%BIAS Constructor function for BIAS object
%   OBJ = BIAS(EYESTARGET) instantiates a BIAS object using a 
%   EYESTARGET object. 
%
%   OBJ = BIAS('auto') attempts to instantiate a BIAS
%   object by first attempting to create an EYESTARGET object.
%
%   Optional arguments that are also passed to parent classes are:
%      redolevels  followed by number argument specifying levels.This 
%                  creates a BIAS object if levels is greater than
%                  0 even if there is a bias.mat file present. 
%                  Levels is subtracted by 1 and passed on to all parent 
%                  objects.
%
%      redo        essentially the same as ('redolevels',1).
%
%      savelevels  followed by number argument specifying levels. This 
%                  saves the BIAS object in the file bias.mat
%                  with variable name 'bi' if levels is greater than
%                  0. Levels is subtracted by 1 and passed on to all 
%                  parent objects.
%
%      save        essentially the same as ('savelevels',1).
%
%   The object contains the following fields:
%      OBJ.sessions
%      OBJ.session().sessionname
%      OBJ.session().theta
%      OBJ.session().cor
%      OBJ.session().inc
%      OBJ.session().rt
%      OBJ.theta
%      OBJ.cor
%      OBJ.inc
%      OBJ.rt
%
%   Inherited from: @eyestarget.
%
%	Dependencies: eyestarget, removeargs.

if nargin==0
	% create empty object
	e = eyestarget;
	e = set(e,'Number',0);
	e = set(e,'HoldAxis',1);
	d = EyesTargetToBias(e);
	obj = class(d,'bias',e);
elseif ((nargin==1) & (isa(varargin{1},'bias')))
	obj = varargin{1};
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
		if (ispresent('bias.mat','file','CaseInsensitive') & (redo==0))
			fprintf('Loading saved bias object...\n');
			l = load('bias.mat');
			obj = l.bi;
		else
			% no saved object so we will try to create one
			% try to create eyestarget object
			e = eyestarget('auto',varargin{:});
			d = EyesTargetToBias(e);
			% check if eyestarget is empty
			if (isempty(e))
				e = set(e,'Number',0);
				e = set(e,'HoldAxis',1);
				obj = class(d,'bias',e);
			else	
				e = set(e,'Number',1);
				e = set(e,'HoldAxis',1);
				obj = class(d,'bias',e);
				if saveobj
					fprintf('Saving bias object...\n');
					bi = obj;
					save bias bi
				end
			end
		end
	elseif ((num_args == 1) & (isa(varargin{1},'eyestarget')))
		e = varargin{1};
		d = EyesTargetToBias(e);
		e = set(e,'Number',1);
		e = set(e,'HoldAxis',1);
		obj = class(d,'bias',e);
		if saveobj
			fprintf('Saving bias object...\n');
			bi = obj;
			save bias bi
		end
	else
		error('Wrong argument type')
	end
end
