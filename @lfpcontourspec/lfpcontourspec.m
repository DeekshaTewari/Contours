function obj = lfpcontourspec(varargin)
% Constructor function for @lfpcontourspec class
% This class consists in an average spectrogram for the
% contour condition. By default.
%
%   Dependencies: lfptraces, lfpaverage

Args = struct('RedoLevels',0,'SaveLevels',0,'Auto',0,'corTrial',1,'IncorTrial',-1);
Args.flags = {'Auto'};
[Args,modvarargin] = getOptArgs(varargin,Args, ...
    'subtract',{'RedoLevels','SaveLevels'}, ...
    'shortcuts',{'redo',{'RedoLevels',1}; 'save',{'SaveLevels',1}}, ...
    'remove',{'Auto'});

% variable specific to this class. Store in Args so they can be easily
% passed to createObject and createEmptyObject
Args.classname = 'lfpcontourspec';
Args.matname = [Args.classname '.mat'];
Args.matvarname = 'lfpctourspec';

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
% if (ispresent('lfptraces.mat','file','CaseInsensitive'))
%     load lfptraces.mat
lfpt = lfptraces('auto',varargin{:});

if ~isempty(lfpt)
    % this is a valid object
    % these are fields that are useful for most objects
    ch = lfpt.data.Nchannels;
    TrialType = 2; % for the contour
    response = [-1 1];% corresponds to the a wrong and a correct 1 saccadic response
    pasok = 1;
    for sal = 1 : 3
        salience(sal).StimCR = [];
        salience(sal).SacCR = [];
        salience(sal).StimIR = [];
        salience(sal).SacIR = [];
        salience(sal).nCR = [];
        salience(sal).nIR = [];
        salience(sal).RTCR = [];
        salience(sal).RTIR = [];
        fprintf('salience %d ',sal)
        for c = 1 : ch

            for r =  1 : length(response)

                [avStim{r}(1,:,:),n{r},beforeStim(r),meanSTD{r},F,step,window] = LFPaverage(lfpt,TrialType,response(r),sal,c,lfpt.data.TargetOnset,'spectrogram','normalized','before',300,'KSStim',varargin{:});
                saccade = lfpt.data.TargetOnset + lfpt.data.RT;
                [avSac{r}(1,:,:),n{r},beforeSac(r),meanSTD{r},F,step,window] = LFPaverage(lfpt,TrialType,response(r),sal,c,saccade,'spectrogram','normalized','before',400,'KSStim',varargin{:});
            end
            
            salience(sal).StimCR = [salience(sal).StimCR; avStim{2}];
            salience(sal).SacCR = [salience(sal).SacCR; avSac{2}];
            salience(sal).StimIR = [salience(sal).StimIR; avStim{1}];
            salience(sal).SacIR = [salience(sal).SacIR; avSac{1}];
            salience(sal).nCR = [salience(sal).nCR; n{2}];
            salience(sal).nIR = [salience(sal).nIR; n{1}];
            salience(sal).RTCR = [salience(sal).RTCR; meanSTD{2}];
            salience(sal).RTIR = [salience(sal).RTIR; meanSTD{1}];
            data.setNames{c} = pwd;
            if (isempty(beforeSac(~isnan(beforeSac))) | isempty(beforeStim(~isnan(beforeStim)))) & pasok
                data.beforeSac(c,1) = NaN;
                data.beforeStim(c,1) = NaN;
            elseif pasok
                data.beforeSac(c,1) = unique(beforeSac(~isnan(beforeSac)));
                data.beforeStim(c,1) = unique(beforeStim(~isnan(beforeStim)));
                pasok = 1;
            end

            data.F(c,:) = F;
            data.step(c,1) = step;
            data.window(c,1) = window;
        end

    end


    data.salience = salience;
    data.Index = [ones(ch,1) (1:ch)'];
    data.numSets = ch;

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
for sal = 1 : 3
    data.salience(sal).StimCR = [];
    data.salience(sal).SacCR = [];
    data.salience(sal).StimIR = [];
    data.salience(sal).SacCR = [];
    data.salience(sal).nCR = [];
    data.salience(sal).nIR = [];
    data.salience(sal).RTCR = [];
    data.salience(sal).RTIR = [];

end
data.beforeSac= [];
data.beforeStim= [];
data.F = [];
data.step = [];
data.window = [];

% useful fields for most objects
data.Index = [];
data.numSets = 0;
data.setNames = '';
% create nptdata so we can inherit from it
n = nptdata(0,0);
d.data = data;
obj = class(d,Args.classname,n);
