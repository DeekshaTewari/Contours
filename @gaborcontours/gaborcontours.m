function obj = gaborcontours(varargin)
%@gaborcontours/gaborcontours Constructor function for GABORCONTOURS class
%   OBJ = gaborcontours('auto') attempts to instantiate an object of 
%   the GABORCONTOURS class.

% default value for optional arguments
Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'GaborPixels',15);
[Args,varargin2] = getOptArgs(varargin,Args,'flags',{'Auto'}, ...
			'subtract',{'RedoLevels','SaveLevels'}, ...
			'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
			'remove',{'GaborPixels'});

if(nargin==0)
	% create empty object
	obj = createEmptyObject;
elseif( (nargin==1) & isa(varargin{1},'gaborcontours') )
	obj = vararing{1};
else
	% create object using arguments
	if(Args.Auto)
		% change to the proper directory
        [pdir,cdir] = getDataDirs('session','relative','CDNow');
		% check for saved object
		if(ispresent('gaborcontours.mat','file','CaseInsensitive') & (Args.RedoLevels==0))
			fprintf('Loading saved gaborcontours object...\n');
			l = load('gaborcontours.mat');
			obj = l.gc;
		else
			% no saved object so we will try to create one
			% look for _stimuli.bin file
			ifile = nptDir('*_stimuli.bin','CaseInsensitive');
			obj = createObject(ifile,Args,varargin2);
		end
        % change back to previous directory if necessary
        if(~isempty(cdir))
            cd(cdir)
        end
	else
		switch(nargin)
		case 1
			v1 = varargin{1};
			if(ischar(v1))
				% if is character, try using it as the INI file
				ifile = nptDir(v1,'CaseInsensitive');
				obj = createObject(ifile,Args,varargin2);
			else
				error('Argument should be name of _stimuli.bin file!')
			end
		otherwise
			error('Wrong number of input arguments!')
		end
	end
end

function obj = createObject(ifile,Args,varargin2)

% get size of ifile
sifile = size(ifile,1);
if(sifile>1)
	fprintf('Warning: More than 1 _stimuli.bin file found. Using first one found...\n');
end
if(sifile>0)
	data.stimulifile = ifile(1).name;
	% read the first stimulus - target is xstart; ystart; xend; yend and elts is (x,y,ori)
	[elts,target] = ReadContourStimuli(ifile(1).name,0);
	eltx = elts(:,1);
	elty = elts(:,2);
	% find x values that are smaller than xstart of target
	xsmall = eltx < target(1);
	% find y values that are smaller than ystart of target
	ysmall = elty < target(2);
	% find x values that are larger than xend of target
	xlarge = eltx > target(3);
	% find y values that are larger than yend of target
	ylarge = elty > target(4);
	% take the OR operator on all to find elts outside target
	outside = xsmall | ysmall | xlarge | ylarge;
	% find first elt in outside
	oi = find(outside);
    if(isempty(oi))
        data.ncontourselts = size(elts,1);
    else
		% this means that number of elements on the contour is oi(1)-1
		data.ncontourelts = oi(1)-1;
    end
	% save target location
	data.target = target;
	% get number of stimuli from sesinfo object
	s = sesinfo('auto',varargin2{:});
	data.nStimuli = s.nTotalStimuli;
	% get number of contour stimuli so we can get control target location
	[elts,data.target(1:4,2)] = ReadContourStimuli(ifile(1).name,s.nContourStimuli);
	% get size of gabors from sesinfo object which is in percentage
	data.gabsize = s.data.gabsize / 100 * Args.GaborPixels;
	% inherit from mapfields object so we can draw fields in plot function
	mf = mapfields('auto',varargin2{:});
	% set number of stimuli in nptdata of mapfields instead of numRFs
	mf = set(mf,'Number',data.nStimuli);	
	d.data = data;
	obj = class(d,'gaborcontours',mf);
	if(Args.SaveLevels)
		fprintf('Saving gaborcontours object...\n');
		gc = obj;
		save gaborcontours gc
	end
else
	% create empty object
	obj = createEmptyObject;
end

function obj = createEmptyObject

data.stimulifile = '';
data.ncontourelts = 0;
data.target = [];
data.nStimuli = 0;
% create empty mapfields object
mf = mapfields;
d.data = data;
obj = class(d,'gaborcontours',mf);
