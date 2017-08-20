function obj = plot(obj,varargin)
%@contourspsth/plot Plot function for contourspsth class
%   OBJ = plot(OBJ) plots the mean and standard deviation of the PSTH
%   for trials of different stimulus conditions.
%
%   OBJ = plot(OBJ,'Bins',BINS,'UseEyeJitterLimits',EJ) specifies the
%   bins to use and whether eye jitter limits should be used. If not
%   specified, or if the specified parameters match those in OBJ, the 
%   data in OBJ is plotted. Otherwise, the data is recalculated before
%   being plotted.

Args = struct('ShowSTD',0,'Bins',[],'UseEyeJitterLimits',[], ...
	'SessionPath',['..' filesep '..'],'Recalc',0,'EyesTarget',0, ...
    'XLim',[-100 200]);
Args = getOptArgs(varargin,Args,'flags',{'ShowSTD','Recalc','EyesTarget'});

% set default value
recalc = 0;

% check if the parameters are the same as the saved object
if( (~isempty(Args.Bins)) && (~isequal(obj.data.bins,Args.Bins)) )
	recalc = 1;
else
    % set Args.Bins in case we need to recalculate based on options below
    Args.Bins = obj.data.bins;
end
if( ~isempty(Args.UseEyeJitterLimits) ...
	 && (obj.data.useEyeJitterCenter~=Args.UseEyeJitterLimits) )
	recalc = 1;
else
    % we will use option specified in object by default
    Args.UseEyeJitterLimits = obj.data.useEyeJitterCenter;
end

if(Args.Recalc)
	recalc = 1;
end

if(Args.EyesTarget)
	% instantiate ispikes object
	isp = ispikes('auto');
	% get current directory
	cwd = pwd;
	% move up 2 directories and then into the eye directory
	cd(['..' filesep '..'])
	% instantiate the eyestarget
	et = eyestarget('auto');
	plotSalienceSpikes(et,'iSpikes',{isp},varargin{:});
    % xlim([0 200])
	% go back to original directory
	cd(cwd);
elseif(recalc)
	% get data and ignore error check since the fact that there exists
	% an object probably means that there should not be a problem
	% getting the data
	data = getContoursPSTH(Args,varargin{:});
	[datarow,datacols] = size(data.mean);
	if(Args.ShowSTD)
		errorbar(repmat(data.bins(1:(end-1))',1,datacols),data.mean, ...
			data.std);
	else
		plot(repmat(data.bins(1:(end-1))',1,datacols),data.mean,'.-')
	end
    xlim(Args.XLim)
	% legend(data.lstring);
	xlabel('Time from stimulus onset (ms)')
	ylabel('Firing rate (Hz)')
else
	[datarows,datacols] = size(obj.data.mean);
	if(Args.ShowSTD)
		errorbar(repmat(obj.data.bins(1:(end-1))',1,datacols),obj.data.mean, ...
			obj.data.std);
	else
		plot(repmat(obj.data.bins(1:(end-1))',1,datacols),obj.data.mean,'.-')
	end
    xlim(Args.XLim)
	% legend(obj.data.lstring);
	xlabel('Time from stimulus onset (ms)')
	ylabel('Firing rate (Hz)')
end
title(obj.data.setnames{1})
