function obj = contourspsth(varargin)
%@contourspsth Constructor function for contourspsth class
%   OBJ = contourspsth('auto')

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0, ...
	'Bins',-100:10:200,'UseEyeJitterLimits',0, ...
	'SessionPath',['..' filesep '..']);
[Args,varargin] = getOptArgs(varargin,Args, ...
	'flags',{'Auto','UseEyeJitterLimits'}, ...
	'subtract',{'RedoLevels','SaveLevels'}, ...
	'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}});

if(nargin==0)
	% create empty object
	obj = createEmptyObject;
elseif( (nargin==1) & isa(varargin{1},'contourspsth'))
	obj = varargin{1};
else
	% create object using arguments
	if(Args.Auto)
		% check for saved object
		if(ispresent('contourspsth.mat','file','CaseInsensitive') ...
			& (Args.RedoLevels==0))
			fprintf('Loading saved contourspsth object...\n');
			l = load('contourspsth.mat');
			obj = l.cp;
		else
			% no saved object so we will try to create one
			obj = createObject(Args,varargin{:});
		end
	end
end

function obj = createObject(Args,varargin)

[data,err] = getContoursPSTH(Args,varargin{:});
if(err)
	% there was a problem so create empty object
	obj = createEmptyObject;
	return
end

% create nptdata
n = nptdata(data.sets,0,pwd);
d.data = data;
obj = class(d,'contourspsth',n);
if(Args.SaveLevels)
	fprintf('Saving contourspsth object...\n');
	cp = obj;
	save contourspsth cp
end

function obj = createEmptyObject

data.sets = 0;
data.setnames = '';
data.mean = [];
data.std = [];
data.lstring = {};
n = nptdata(0,0);
d.data = data;
obj = class(d,'contourspsth',n);
