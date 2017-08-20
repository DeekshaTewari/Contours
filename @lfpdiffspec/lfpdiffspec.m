function obj = lfpdiffspec(varargin)
% @lfpdiffspec Constructor function for lfpdiffspec class
%
%
%   Dependencies:

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'corTrial',[1 2],'IncorTrial',[-1 -2 -3 -4]);%,'TrialType1','contour','TrialType2','control');
Args.TrialType = {'contour','control'};
Args.flags = {'Auto'};
[Args,modvarargin] = getOptArgs(varargin,Args, ...
    'subtract',{'RedoLevels','SaveLevels'}, ...
    'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
    'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'lfpdiffspec';
Args.matname = [Args.TrialType{:} 'spec.mat'];
Args.matvarname = sprintf('lfp%s%sspec',Args.TrialType{:});
TrialType = Args.TrialType;

for tr = 1 : 2
    switch TrialType{tr}
        case 'contour'
            Args.trialtype(tr) = 2;
            Args.totsal = 3;
        case 'control'
            Args.trialtype(tr) = 1;
            Args.totsal = 3;
        case 'catchcontour'
            Args.trialtype(tr) = 0;
            Args.totsal = 1;
        case 'catchcontrol'
            Args.trialtype(tr) = -1;
            Args.totsal = 1;
    end
end


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
        if(isempty(cdir))
            % if there is an eye subdirectory, we are probably in the session dir
            % so change to the eye subdirectory
            [r,a] = ispresent('lfp','dir','CaseInsensitive');
            if r
                cdir = pwd;
                cd(a);
            end
        end
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
if(isempty(cdir))
    % if there is an eye subdirectory, we are probably in the session dir
    % so change to the eye subdirectory
    [r,a] = ispresent('lfp','dir','CaseInsensitive');
    if r
        cdir = pwd;
        cd(a);
    end
end
% check if the right conditions were met to create object
lfpt = lfptraces('auto',varargin{:});
if ~isempty(lfpt)
    % this is a valid object
    % these are fields that are useful for most objects

    ch = lfpt.data.Nchannels;

    for sal = 1 : Args.totsal
        fprintf('\n salience %d ',sal)

        [Dif,para,status(sal)] = compareLFP(lfpt,Args.trialtype,sal,'spectrogram',varargin{:});
        if status(sal)
            
            F = para.F;
            step = para.step;
            window = para.window;
        
        end
        
        salience(sal).ks = Dif.ks;
        salience(sal).ampl1 = Dif.ampl1;
        salience(sal).ampl2 = Dif.ampl2;
    end
    if ~isempty(find(status == 1))
        data.Index = [ones(ch,1) (1:ch)']; 
        for c = 1: ch
            data.setNames{c} = pwd;

            data.F(c,:) = F;
            
        end
        data.step = repmat(step,ch,1);
            data.window = repmat(window,ch,1);
            data.salience = salience;
        data.numSets = ch;
        data.TrialType = Args.TrialType;
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
if(isempty(cdir))
    % if there is an eye subdirectory, we are probably in the session dir
    % so change to the eye subdirectory
    [r,a] = ispresent('session','dir','CaseInsensitive');
    if r
        cdir = pwd;
        cd(a);
    end
end

function obj = createEmptyObject(Args)

% these are object specific fields
for sal = 1 : Args.totsal
    data.salience(sal).ks = [];
    data.salience(sal).ampl1 = [];
    data.salience(sal).ampl2 = [];
    
end

data.F = [];
data.step = [];
data.window = [];
data.TrialType = [];
% useful fields for most objects
data.Index = [];
data.numSets = 0;
data.setNames = '';
% create nptdata so we can inherit from it
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);
