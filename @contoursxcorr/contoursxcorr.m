function obj = contoursxcorr(varargin)
%@contoursxcorr Constructor function for contoursxcorr class
%   OBJ = contoursxcorr('auto') attempts to create a contoursxcorr object by ...

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'ClusterDirs',{''}, ...
	'flags',{'Auto'});
[Args,varargin] = getOptArgs(varargin,Args, ...
	'subtract',{'RedoLevels','SaveLevels'}, ...
	'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'contoursxcorr';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'df';

if(nargin==0)
	% create empty object
	obj = createEmptyObject(Args);
elseif( (nargin==1) & isa(varargin{1},Args.classname))
	obj = varargin{1};
else
	% create object using arguments
	if(Args.Auto)
		% check for saved object
		if(ispresent(Args.matname,'file','CaseInsensitive') ...
			& (Args.RedoLevels==0))
			fprintf('Loading saved %s object...\n',Args.classname);
			l = load(Args.matname);
			obj = eval(['l.' Args.matvarname]);
		else
			% no saved object so we will try to create one
			% pass varargin in case createObject needs to instantiate
			% other objects that take optional input arguments
			obj = createObject(Args,varargin{:});
		end
	end
end

function obj = createObject(Args,varargin)

if(~isempty(Args.ClusterDirs))
	% check that there are only 2 directories
	if(size(Args.ClusterDirs,2)>2)
		fprintf('Warning: %s works only on cell pairs! Using the first two cells...\n', ...
			Args.classname);
	end
	% get current directory
	cwd = pwd;
	% change to first directory
	cd(Args.ClusterDirs{1})
	isp1 = ispikes('auto');
	% return to previous directory in case directory paths are relative
	cd(cwd);
	% change to second directory
	cd(Args.ClusterDirs{2});
	isp2 = ispikes('auto');
	% get session directory
	sessiondir = getDataDirs('session','relative');
	% change to session directory
	cd(sessiondir);
	% instantiate sesinfo object
	sinfo = sesinfo('auto');
	% return to previous directory even if any of the objects are empty
	cd(cwd);
	% check if any of the required objects are empty
	if( isempty(isp1) | isempty(isp2) | isempty(sinfo) )
		% create empty object
		obj = createEmptyObject(Args);
	else
		% this should be a valid object
		data.numSets = 1;
		data.setNames{1} = pwd;
		
		% data.dlist = dlist;
		% set index to keep track of which data goes with which directory
		% data.setIndex = [0; dnum];
		% create nptdata
		n = nptdata(data.numSets,0,pwd);
		d.data = data;
		obj = class(d,Args.classname,n);
		if(Args.SaveLevels)
			fprintf('Saving %s object...\n',Args.classname);
			eval([Args.matvarname ' = obj;']);
			% save object
			eval(['save ' Args.matname ' ' Args.matvarname]);
		end
	end
else
	% create empty object
	obj = createEmptyObject(Args);
end

function obj = createEmptyObject(Args)

data.numSets = 0;
data.setNames = '';
% data.dlist = [];
% data.setIndex = [];
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);
