function obj = lfpdiffep(varargin)
% @evokedpotential Constructor function for lfptraces class
%
%
%   Dependencies:

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'nlimit',6,'PerfLimit',80);
Args.flags = {'Auto'};
[Args,modvarargin] = getOptArgs(varargin,Args, ...
    'subtract',{'RedoLevels','SaveLevels'}, ...
    'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
    'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'lfpdiff';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'lfpdiff';

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
[pdir,cdir] = getDataDirs('lfp','relative','CDNow');%dirLevel('eye','relative','CDNow');
% check if the right conditions were met to create object
lfpt = lfptraces('auto',varargin{:});
if ~isempty(lfpt)
    % this is a valid object
    % these are fields that are useful for most objects

    ch = lfpt.data.Nchannels
    lfpctourep = lfpcontourep('auto',varargin{:});
    lfpctrolep = lfpcontrolep('auto',varargin{:});
    lfpctourspec = lfpcontourspec('auto',varargin{:});
    lfpctrolspec = lfpcontrolspec('auto',varargin{:});

    [difference,status] = compareLFPobj(lfpt,lfpctourep,lfpctrolep,varargin{:});
    

    if status == 1

        data = difference;

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
        
        obj = createEmptyObject(Args);
    end
else
    fprintf('The lfpt object is empty \n');
    obj = createEmptyObject(Args);
end
[pdir,cdir] = getDataDirs('session','relative','CDNow');


function obj = createEmptyObject(Args)

% these are object specific fields
for sal = 1 : 3
    data.salience(sal).StimCR = [];
    data.salience(sal).SacCR = [];
    

end
data.beforeSac= [];
data.beforeStim= [];
% data.F = [];
% data.step = [];
% data.window = [];

% useful fields for most objects
data.Index = [];
data.numSets = 0;
data.setNames = '';
% create nptdata so we can inherit from it
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);
