function r = plotEyeJitter(et,varargin)
%@eyestarget/plotEyeJitter Plots variance in fixational eye position
%   OBJ = plotEyeJitter(OBJ) plots the mean and standard deviation
%   of the eye position for all trials. By default, data from a 100 ms 
%   window starting from the stimulus onset is used. The following
%   optional input arguments are also valid:
%      'Duration' - followed by number specifying window 
%                   duration in milliseconds (default: 100).
%                   The presence of this option also implies
%                   'EyeJitter'.
%      'EyeJitterRaw' - flag indicating that the raw eye signals
%                       should be plotted as well.
%      'EyeJitterThreshold' - followed by number specifying threshold
%                             of standard deviation. Trials with std
%                             above the threshold will be plotted in
%                             red (default: 0.4).
%      'ResponseWeighted' - flag indicating that the response from
%                           the ISPIKES object at group0001/cluster01s
%                           is to be used to indicate eye positions
%                           at which significant response was elicited.
%
%      'iSpikesPath' - followed by character array indicating the path
%                      to the ISPIKES object to be used (default:
%                      group0001/cluster01s).
%
%   OBJ = plotEyeJitter(OBJ,'ResponseWeighted')

Args = struct('Duration',100,'EyeJitterRaw',0, ...
			'EyeJitterThreshold',0.4,'ResponseWeighted',0, ...
			'iSpikesPath',['group0001' filesep 'cluster01s']);
Args = getOptArgs(varargin,Args,'flags',{'EyeJitterRaw','ResponseWeighted'});

% set color transitions
colorseq = 'brgmcyk';

% instantiate eyejitter object
ej = eyejitter('auto',varargin{:});

if(Args.ResponseWeighted)
	% load an ispikes object
	cwd = pwd;
	cd(Args.iSpikesPath)
	load ispikes
    cd(cwd);
	% get stimulus onsets
	onsets = round(et.onsetsMS);
	% get offsets
	offsets = onsets + Args.Duration;
	% get spike counts for all trials
	sc = getSpikeCounts(isp,'DataStart',onsets,'DataEnd',offsets);
	% depending on whether we used tuning stimuli, we can either use 
	% just the contour trials and the first set of control trials or
	% we can use all trials
	if(et.sesinfo.data.includetuning)
		% create plot with first row consisting of data from contour
		% trials, and the second row consisting of data from the first
		% set of control trials and a plot illustrating the spike
		% counts for the different salience conditions
		
		% get number of salience conditions
		nSalience = length(et.sesinfo.data.stim_p);
		% number of cols is either the number of salience conditions
		% or 2 whichever is bigger
		plotcols = max([2 nSalience]);
		% get the plot number for the spike count plot
		scplotnum = nSalience + 2;
		% set the hold for the spike count plot
		subplot(2,plotcols,scplotnum)
		hold on
		scindex = 0;
		for i = 1:nSalience
			subplot(2,plotcols,i)
			% get trial indices for this salience condition
			tind = et.sesinfo.sequence.contour(i);
			% get length of tind
			ltind = length(tind);
			% plot data for selected trials
			plot(ej,'Trials',tind,'Responses',sc(tind),varargin{:});
			% plot spike count
			subplot(2,plotcols,scplotnum)
			plot(scindex + (1:ltind),sc(tind),[colorseq(i) '.'])
			% increment scindex in order to keep spike counts separate
			scindex = scindex + ltind;
		end
		% plot data for first set of control trials
		subplot(2,plotcols,nSalience+1)
		% get trial indices for this salience condition
		tind = et.sesinfo.sequence.control(1);
		% get length of tind
		ltind = length(tind);
		% plot data for selected trials
		plot(ej,'Trials',tind,'Responses',sc(tind),varargin{:});
		% plot spike counts for this condition
		subplot(2,plotcols,scplotnum)
		plot(scindex + (1:ltind),sc(tind),[colorseq(i+1) '.'])
	end
    % return empty r
    r = [];
else
	% get number of salience conditions
	nsc = length(et.sesinfo.stim_p);
	% get contour trials as well as the control trials with the highest
	% salience, i.e. all trials where the stimulus in the RF is optimal
	ctrials = [];
	for i = 1:nsc
		ctrials = [ctrials; et.sesinfo.sequence.contour(i)];
	end
	ctrials = [ctrials; et.sesinfo.sequence.control(1)];
	plot(ej,'Trials',ctrials,varargin{:});
	r.trials = ctrials;
	r.dm = ej.data.mean(ctrials);
	r.dstd = ej.data.stdev(ctrials);
end