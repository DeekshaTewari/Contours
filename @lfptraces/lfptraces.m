function obj = lfptraces(varargin)
% @lfptraces Constructor function for lfptraces class
% The lfptraces object contains all the lfp traces and additional 
% information about the trial. The fields are :
%
% - LFP: lfp traces in single precision
% - Index: column wise (session/trial #/cummulative trial #/ traces #)
% - RT: reaction time
% - result: response type coded as follow
%               0 - no saccades
%               1 - single saccade to target window within MATCH_TIME
%                 (default is 300 ms)
%               2 - multiple saccades all within target window with first
%                 saccade within MATCH_TIME
%               -1 - single saccade to any other location other than target window
%               -2 - single saccade to target window but not within MATCH_TIME
%               -3 - multiple saccades all within target window but first saccade
%                  was not within MATCH_TIME
%               -4 - multiple saccades with at least one saccade to a location
%                  outside the target window
% - TrialType: type of trial coded as follow
%               -1 - catchcontrol
%                0 - catchcontour
%                1 - control
%                2 - contour
% - OriJitter: angle of the jitter 
% - salience: coded from 1 (most salient) to 3 (less salient)
% - Sampling rate: have3 a guess
% - TargetOnste: precise onset of the target in ms.
% - Nchannels: numer of neuronal channel recorded.
% - 
%
%   Dependencies: nptReadStreamerFile, ProcessSessionLFP

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0);
Args.flags = {'Auto'};
[Args,modvarargin] = getOptArgs(varargin,Args, ...
	'subtract',{'RedoLevels','SaveLevels'}, ...
	'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
	'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'lfptraces';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'lfpt';

numArgin = nargin;
if(numArgin==0)
	% create empty object
	obj = createEmptyObject(Args);
elseif( (numArgin==1) & isa(varargin{1},Args.classname))
	obj = varargin{1};
else
	% create object using arguments
    if(Args.Auto)
        % change to the proper directory
        [pdir,cdir] = getDataDirs('lfp','relative','CDNow');%dirLevel('eye','relative','CDNow');
        % check for saved object
        if(isempty(cdir))
            % if there is an eye subdirectory, we are probably in the session dir
            % so change to the eye subdirectory
            [r,a] = ispresent('lfp','dir','CaseInsensitive');
            if r
                cdir = pwd;
                cd(a);
            end
        end
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
        % change back to previous directory if necessary
        if(~isempty(cdir))
            cd(cdir)
        end
	end
end

function obj = createObject(Args,varargin)
 [pdir,cdir] = getDataDirs('session','relative','CDNow');%dirLevel('eye','relative','CDNow');
% check if the right conditions were met to create object
if (ispresent('bias.mat','file','CaseInsensitive'))
    load bias.mat
    trial1 = nptDir('*.0001');
    if ~isempty(trial1)
    [DATA,NUM_CHANNELS,SR,SCAN_ORDER,POINTS] = nptReadStreamerFile(trial1(1).name);
    
    else
        SR = 30000; 
    end
    
    if ispresent('lfp','dir','CaseInsensitive')
        [pdir,cdir] = getDataDirs('lfp','relative','CDNow');
         if(isempty(cdir))
            % if there is an eye subdirectory, we are probably in the session dir
            % so change to the eye subdirectory
            [r,a] = ispresent('lfp','dir','CaseInsensitive');
            if r
                cdir = pwd;
                cd(a);
            end
        end
        if ~isempty(bi)
            % this is a valid object
            % these are fields that are useful for most objects
            [data,events] = ProcessSessionLFP(bi,SR,varargin{:});
            data.numSets = events; % nbr of trial
            data.setNames{1} = pwd;

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
            fprintf('The bias object is empty');
        end
        [pdir,cdir] = getDataDirs('session','relative','CDNow');
         if(isempty(cdir))
            % if there is an eye subdirectory, we are probably in the session dir
            % so change to the eye subdirectory
            [r,a] = ispresent('session','dir','CaseInsensitive');
            if r
                cdir = pwd;
                cd(a);
            end
        end
        obj = createEmptyObject(Args);
    else
        % create empty object
        fprintf('The lfp directory does not exist \n');
        obj = createEmptyObject(Args);
    end
else

    fprintf('The bias object is not present \n');
    obj = createEmptyObject(Args);
end

function obj = createEmptyObject(Args)

% these are object specific fields
data.LFP = [];
data.RT = [];
data.results = [];
data.TrialType = [];
data.OriJitter = [];
data.salience = [];
data.SamplingRate = [];
data.TargetOnset = [];

% useful fields for most objects
data.Index = [];
data.numSets = 0;
data.setNames = '';
% create nptdata so we can inherit from it
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);
