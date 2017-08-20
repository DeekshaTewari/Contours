function obj = contourstuning(varargin)
%@contourstuning Constructor function for contourstuning class
%   OBJ = contourstuning('auto') attempts to create a contourstuning object 
%   by ...

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'OnsetWindow',200);
Args.flags = {'Auto'};
[Args,modvarargin] = getOptArgs(varargin,Args, ...
	'subtract',{'RedoLevels','SaveLevels'}, ...
	'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
	'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'contourstuning';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'ct';

numArgin = nargin;
if(numArgin==0)
	% create empty object
	obj = createEmptyObject(Args);
elseif( (numArgin==1) & isa(varargin{1},Args.classname))
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
			obj = createObject(Args,modvarargin{:});
		end
	end
end

function obj = createObject(Args,varargin)

% instantiate ispikes object
isp = ispikes('auto');
% instantiate eyestarget object
et = eyestarget('auto',varargin{:});

if( ~isempty(isp) & ~isempty(et) )
	% this is a valid object
	% these are fields that are useful for most objects
	data.numSets = 1;
	data.setNames{1} = pwd;
	
	% get tuning trials from sesinfo object in eyestarget object
	[optimal,tuning,ori] = getTuningTrials(et);
    
	if(~isempty(tuning))
        % replace 0's in tuning and optimal with nan's so missing trials from
        % incomplete sessions are not confused with trials with no spikes
        tuning(tuning==0) = nan;
        optimal(optimal==0) = nan;

        % get spike counts starting from stimulus onset
		sc = getSpikeCounts(isp,'DataStart',et.onsetsMS, ...
			'DataEnd',et.onsetsMS+Args.OnsetWindow);
		% calculate the mean and standard deviations of the spike counts
		% get the spike counts for the optimal stimuli
		osc = nanindex(sc,optimal);
		% get the spike counts for the tuning stimuli
		tsc = nanindex(sc,tuning);
		% figure out where to insert the values for the optimal orientation
		ntuning = size(tsc,2);
		halfntuning = ntuning/2;
		leftcols = 1:halfntuning;
		rightcols = (halfntuning+1):ntuning;
		sc1 = concatenate(tsc(:,leftcols),osc,'Columnwise');
		data.responses = concatenate(sc1,tsc(:,rightcols),'Columnwise');
		data.ori = vecc(ori);
		data.setIndex = [0; ntuning+1];

    else % if(~isempty(tuning))
        % no tuning stimuli so create empty matrices
        % do this so we can actually tell that there were no tuning stimuli
        % rather than having no plots show up
		data.responses = [];
        data.ori = [];
        data.setIndex = [];
    end
    % create nptdata so we can inherit from it
	n = nptdata(data.numSets,0,pwd);
	d.data = data;
	obj = class(d,Args.classname,n);
	if(Args.SaveLevels)
		fprintf('Saving %s object...\n',Args.classname);
		eval([Args.matvarname ' = obj;']);
		% save object
		eval(['save ' Args.matname ' ' Args.matvarname]);
	end
else
	% create empty object
	obj = createEmptyObject(Args);
end


function obj = createEmptyObject(Args)

% useful fields for most objects
data.numSets = 0;
data.setNames = '';

% these are object specific fields
data.responses = [];
data.ori = [];
data.setIndex = [];

% create nptdata so we can inherit from it
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);
