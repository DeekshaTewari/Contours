function [data,err] = getContoursPSTH(Args,varargin)

err = 0;

% we should be in the cluster directory so look for ispikes object 
isp = ispikes('auto',varargin{:});
% save current directory
cwd = pwd;
% change to session directory
cd(Args.SessionPath)
% look for eyestarget object
et = eyestarget('auto',varargin{:});
if(Args.UseEyeJitterLimits)
	ej = eyejitter('auto',varargin{:});
	if(isempty(isp) | isempty(et) | isempty(ej))
		% required objects not found so return error
        data = [];
		err = 1;
        cd(cwd)
		return
	end
else
	if(isempty(isp) | isempty(et))
		% required objects not found so return error
        data = [];
		err = 1;
        cd(cwd)
		return
	end
end

% get salience conditions
stim_p = et.stim_p;
% get number of salience conditions
nsc = length(stim_p);

% save parameters used to generate object
data.bins = Args.Bins;
data.useEyeJitterCenter = Args.UseEyeJitterLimits;
% save object info
data.sets = 1;
data.setnames{1} = [strrep(isp.data.sessionname,'_highpass','') 'g' isp.data.groupname 'c' isp.data.cellname];

% get total number of lines to plot
% datacols = (nsc * 2) + (et.data.catchtrials * 2);
% add 1 for the 0 jitter control trials, and another 1 if there are
% catch trials
datacols = nsc + 1 + et.data.catchtrials;
% get number of bins
datarows = length(Args.Bins) - 1;
% initialize vector to keep track of how many trials there are in
% each condition
indlengths = zeros(1,datacols);
% initialize legend string
lstring = {};
for i = 1:nsc
	ind{i} = et.sequence.contour(i);
	indlengths(i) = length(ind{i});
	lstring = {lstring{:} ['Contour ' num2str(stim_p(i))]};
end
i2 = nsc + 1;
ind{i2} = et.sequence.control(1);
indlengths(i2) = length(ind{i2});
lstring = {lstring{:} ['Control ' num2str(stim_p(1))]};
if(et.data.catchtrials)
	catch1 = nsc + 2;
	ind{catch1} = et.sequence.catchcontour;
	indlengths(catch1) = length(ind{catch1});
	lstring = {lstring{:} 'Contour Catch'};
end
if(Args.UseEyeJitterLimits)
	% get trials included in the eyejitter tolerance calculation
	[i,excludedTrials] = getTrialsInFields(ej,varargin{:},'FieldMark',1,'ReturnTrialsOut');
else
	excludedTrials = [];
end
% preallocate memory for data
sumx = zeros(datarows,datacols);
sumx2 = sumx;
% loop over salience conditions
for i = 1:datacols
	% loop over trials in each salience condition
	for j = 1:indlengths(i)
		% get trial number
		tn = ind{i}(j);
		% check if the eye position in this trial is okay
		if(isempty(intersect(excludedTrials,tn)))
			% get stimulus onset
			onset = et.onsetsMS(tn);
			% set up hist bins aligned to stimulus onset
			bins = Args.Bins + onset;
			% get spike times
			sp = isp.data.trial(tn).cluster(1).spikes;
			% compute psth
			n = histcie(sp,bins,'DropLast');
			% update running sum
			sumx(:,i) = sumx(:,i) + n;
			sumx2(:,i) = sumx2(:,i) + n.^2;
		else
			indlengths(i) = indlengths(i) - 1;
		end
	end
	lstring{i} = [lstring{i} ' (n=' num2str(indlengths(i)) ')'];
end
nmat = repmat(indlengths,datarows,1);
m = sumx ./ nmat;
stdevtmp = sumx2 - ((sumx.^2) ./ nmat);
stdev = (stdevtmp ./ (nmat-1)) .^0.5;
% get conversion factor from counts/bin to counts/sec
convertFactor = 1000/(Args.Bins(2)-Args.Bins(1));
data.mean = m*convertFactor;
data.std = stdev*convertFactor;
data.lstring = lstring;

% return to previous directory since all calculations that need to be in
% the session directory should be done at this point
cd(cwd)
