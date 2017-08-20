function obj = plot(obj,varargin)
%BIAS/PLOT Plots data from BIAS object
%   OBJ = PLOT(OBJ,N) plots the angular distribution of data in 
%   the BIAS object OBJ from session N. By default, it uses 12 bins
%   from -PI to PI in steps of PI/6, and plots data for all salience
%   conditions except for catch trials.
%   The following data for a session are plotted: 
%      angles of correct trials (in blue),
%      angles of incorrect trials (in red),
%      standard error of the mean (in dotted red line)
%
%   PLOT(OBJ,N,'overall') plots overall data in addition to data from
%   session N.
%
%   PLOT(OBJ) plots overall data only without session data.
%
%   PLOT(...,BINS) uses BINS to compute the angular 
%   distributions.
%
%   PLOT(...,'salience',SALIENCE) plots data for salience condition
%   specified by SALIENCE, which can be:
%      1 - n: Number specifying the salience of the contour, with 1 
%             being the highest salience.
%      'catch': Plots data for catch trials. 
%
%   PLOT(...,'rt') plots reaction time data instead of performance
%   data. 
%
%   PLOT(...,'NoPolar') uses a normal plot instead of a polar plot to 
%   display the data.
%
%   Dependencies: None.

Args = struct('Overall',0,'Bins',[],'Salience',[], ...
    'PlotRT',0,'PlotName','Performance','NoPolar',0);
Args.flags = {'Overall','PlotRT','NoPolar'};
[Args,varargin] = getOptArgs(varargin,Args, ...
    'shortcuts',{'RT',{'PlotRT','PlotName','Reaction Times'}});

if(isempty(Args.NumericArguments))
    % individual data set not specified so plot only overall data
    Args.Session = 0;
    Args.Overall = 1;
else
    n = Args.NumericArguments{1};
    Args.Session = 1;
end
if(isempty(Args.Bins))
	bins = (-pi:pi/6:pi)';
	% get center of bins for plotting by droping the last value since it 
	% is redundant with the first value and by shifting by half a bin
	binsc = bins(1:(end-1)) + pi/12;
	% get number of bin limits for use when computing rt means
	nbl = 13;
else
	% make sure bins is a column vector
	bins = vecc(Args.Bins);
	% get number of bin limits for use when computing rt means
	nbl = length(bins);
	% get center of bins by shifting by half a bin
	binsc = bins(1:(nbl-1)) + ( bins(2)-bins(1) )/2;
end
level = Args.Salience;
% check if level is empty
if(isempty(level))
    allsalience = 1;
    saliencelevel = 0;
    catchdata = 0;
    salname = '';
elseif(ischar(level))
	if strcmp(level,'catch')
		allsalience = 0;
        saliencelevel = 0;
		catchdata = 1;
		salname = 'Catch Trials';
	else
		error('Unknown salience parameter');
	end
elseif(isnumeric(level))
	allsalience = 0;
	saliencelevel = level;
	if (level>obj.eyestarget.stim_steps)
		error('Salience level exceeds levels present in data');
	end
    catchdata = 0;
	salname = ['Salience Level ' num2str(saliencelevel)];
else
	error('Unknown salience parameter');
end

% get value for incorrect reaction time from sesinfo object stored in 
% eyestarget object
incrt = obj.eyestarget.matchlimit - obj.eyestarget.etfix;
% axis limit for rt flat plots
rtfmax = incrt + 5;
% default value for correct trial when plotting performance data using polar plot
corp = 1.1;
% default value for incorrect trial when plotting performance data using polar plot
incp = 1.2;
% default value for correct trial when plotting performance data with nopolar
corpf = 1.025;
% default value for incorrect trial when plotting performance data with nopolar
incpf = 1.05;
% axis limit for performance data with nopolar
pfmax = 1.1;
% plot color for specific salience level
clevel = 0;

% initialize variables
lhandles = [];
lstring = {};

% check if this is a session with interpolated contours
if(obj.eyestarget.stim_steps.control)
	intcontours = 1;
else
	intcontours = 0;
end

% figure out which columns to pull out if plotting specific salience levels
if(saliencelevel)
    % set up color index for plotting
    clevel = saliencelevel;
	% if not interpolated contours, we can just use saliencelevel as is
	if(intcontours)
		% interpolated contours so pull out salience level for both 
		% target and control locations
		slevel = (saliencelevel-1)*2+1;
		saliencelevel = [slevel slevel+1];
	end
end

% get number of columns, (i.e. number of salience conditions if not interpolated contours)
cn = size(obj.indexes,2);
% get number of salience steps
stim_steps = obj.eyestarget.stim_steps;
% add catch trials if they are present
if(obj.eyestarget.stim_steps.catchcontour)
    stim_steps = stim_steps + 1;
    if(catchdata)
    	clevel = stim_steps;
    end
end
% set up colormaps
cmap = cool(stim_steps);
hmap = hsv(stim_steps);

warning off MATLAB:divideByZero
if Args.Session
	% get rows in indexes that correspond to this session
	si = obj.sesindexes(n,:);
	if allsalience
		% if there are catch trials, grab all but the last column
		if obj.eyestarget.stim_steps.catchcontour
			% grab indexes and reshape into column vector
			ind = obj.indexes(si(1):si(2),1:(cn-1));
		else
			ind = obj.indexes(si(1):si(2),:);
		end
		if(intcontours)
			% combine contour and control trials for each salience step
			ind = reshape(ind,[],obj.eyestarget.stim_steps);
		end
	else
		if catchdata
			ind = obj.indexes(si(1):si(2),cn);
		else
			ind = obj.indexes(si(1):si(2),saliencelevel);
			if(intcontours)
				% combine contour and control trials for 1 salience step
				ind = reshape(ind,[],1);
			end
		end
	end
	ind = ind(~isnan(ind)); % to avoid cases where one of th eindices is NaN
	% get size of ind
	indsize = size(ind);
	% get results for selected trials
	res = obj.results(ind);
	% get indices for correct trials
	rind = find(res);
	% get indices for incorrect trials
	wind = find(res==0);
	% get entries in ind with correct result
	cind = ind(rind);
	% create matrices of NaN
	ctheta = repmat(NaN,indsize);
	itheta = repmat(NaN,indsize);
	% replace appropriate entries in matrices of NaN with actual values
	ctheta(rind) = obj.theta(cind);
	itheta(wind) = obj.theta(ind(wind));
	
	if Args.PlotRT
		% get reaction times for correct trials
		crt = repmat(NaN,indsize);
		crt(rind) = obj.rt(cind);
		% plot incorrect trials with reaction times of 301 since there 
		% are no reaction times associated with incorrect trials
		if Args.NoPolar
			h = plot(rad2deg(itheta),repmat(incrt,indsize),'.');
			setPlotColor(indsize(2),h,cmap,clevel);
			hold on
			h = plot(rad2deg(ctheta),crt,'.');
			setPlotColor(indsize(2),h,cmap,clevel);
		else		
			if isempty(find(~isnan(itheta)))
				% if itheta is empty plot a dot so that the axis will be set properly
				polar(0,incrt,'.');
			else
				h = polar(itheta,repmat(incrt,indsize),'.');
				setPlotColor(indsize(2),h,cmap,clevel);
			end
			hold on
			% plot reaction times for correct trials
			h = polar(ctheta,crt,'.');
			setPlotColor(indsize(2),h,cmap,clevel);
		end
	else
		if Args.NoPolar
			h = plot(rad2deg(ctheta),repmat(corpf,indsize),'.');
			setPlotColor(indsize(2),h,cmap,clevel);
			hold on
			h = plot(rad2deg(itheta),repmat(incpf,indsize),'.');
			setPlotColor(indsize(2),h,cmap,clevel);
		else
			% plot with blue dot to indicate correct trial
			h = polar(ctheta,repmat(corp,indsize),'.');
			setPlotColor(indsize(2),h,cmap,clevel);
			hold on
			% plot with red dot to indicate incorrect trial
			h = polar(itheta,repmat(incp,indsize),'.');
			setPlotColor(indsize(2),h,cmap,clevel);
		end
	end

	% plot the angular means for the session
	% get the histogram of the correct trials
	[na,ba] = histcie(ctheta,bins,'DropLast');
	% make sure na is a column vector
	na = vecc(na);

	if Args.PlotRT
		nnc = nbl - 1;
		nc = zeros(nnc,indsize(2));
        % create matrix of all zeros used to compute mean
        mz = zeros(indsize);
		for b = 1:nnc
            % get indices that match b
            mzi = find(ba==b);
            mz(mzi) = crt(mzi);
            nc(b,:) = sum(mz) ./ sum(mz>0);
            % reset value to 0 for next iteration
            mz(mzi) = 0;
			% nc(b,:) = mean(crt(find(ba==b)));
		end
	else
		% get the histogram of both the correct and incorrect trials
		nb = histcie([ctheta; itheta],bins,'DropLast');
		% make sure nb is a column vector
		nb = vecc(nb);
		% divide correct by total to get means
		nc = na ./ nb;
	end
	
	if Args.NoPolar
		lhandles = plot(rad2deg(binsc),nc,'*-');
		setPlotColor(indsize(2),lhandles,hmap,clevel);
	else
		% add first value to the end to close the contour plot
		b = [binsc; binsc(1)];
		c = [nc; nc(1,:)];
		% plot the means
        % use repmat since the polar function requires the first two
        % arguments to be the exact size
		lhandles = polar(repmat(b,1,indsize(2)),c,'*-');
		setPlotColor(indsize(2),lhandles,hmap,clevel);
	end
	lstring = {'session'};
	
end

% add overall data
if Args.Overall
	if allsalience
		% if there are catch trials, grab all but the last column
		if obj.eyestarget.stim_steps.catchcontour
			% grab indexes and reshape into column vector
			ind = obj.indexes(:,1:(cn-1));
		else
			ind = obj.indexes;
		end
		if(intcontours)
			% combine contour and control trials for each salience step
			ind = reshape(ind,[],obj.eyestarget.stim_steps);
		end
	else
		if catchdata
			ind = obj.indexes(:,cn);
		else
			ind = obj.indexes(:,saliencelevel);
			if(intcontours)
				% combine contour and control trials for 1 salience step
				ind = reshape(ind,[],1);
			end
		end
	end
	ind = ind(~isnan(ind));
	% get size of ind
	indsize = size(ind);
	% get results for selected trials
	res = obj.results(ind);
	% get indices for correct trials
	rind = find(res);
	% get indices for incorrect trials
	wind = find(res==0);
	% get entries in ind with correct result
	cind = ind(rind);
	% create matrices of NaN
	ctheta = repmat(NaN,indsize);
	itheta = repmat(NaN,indsize);
	% replace appropriate entries in matrices of NaN with actual values
	ctheta(rind) = obj.theta(cind);
	itheta(wind) = obj.theta(ind(wind));
	% get reaction times for all correct trials
	% need this outside the if ~session loop in case that condition is not met
	crt = repmat(NaN,indsize);
	crt(rind) = obj.rt(cind);

	% if overallonly, plot raw data for all sessions
	if (~Args.Session)
		if Args.PlotRT
			if Args.NoPolar
				h = plot(rad2deg(itheta),repmat(incrt,indsize),'.');
				setPlotColor(indsize(2),h,cmap,clevel);
				hold on
				h = plot(rad2deg(ctheta),crt,'.');
				setPlotColor(indsize(2),h,cmap,clevel);
			else
				% plot incorrect trials with reaction times of 301 since there 
				% are no reaction times associated with incorrect trials
				if isempty(find(~isnan(itheta)))
					% if itheta is empty plot a dot so that the axis will be set properly
					polar(0,incrt,'kx')
				else
					h = polar(itheta,repmat(incrt,indsize),'x');
					setPlotColor(indsize(2),h,cmap,clevel);
				end
				hold on
				% plot reaction times for all correct trials
				h = polar(ctheta,crt,'.');
				setPlotColor(indsize(2),h,cmap,clevel);
			end
		else
			if Args.NoPolar
				h = plot(rad2deg(ctheta),repmat(corpf,indsize),'.');
				setPlotColor(indsize(2),h,cmap,clevel);
				hold on
				h = plot(rad2deg(itheta),repmat(incpf,indsize),'.');
				setPlotColor(indsize(2),h,cmap,clevel);
			else
				% plot the angles for correct trials
				h = polar(ctheta,repmat(corp,indsize),'.');
				setPlotColor(indsize(2),h,cmap,clevel);
				hold on
				% plot the angles for incorrect trials
				h = polar(itheta,repmat(incp,indsize),'x');
				setPlotColor(indsize(2),h,cmap,clevel);
			end
		end
	end

	% plot the angular means for all sessions
	% get the histogram of the correct trials
	[na,ba] = histcie(ctheta,bins,'DropLast');
	% make sure na is a column vector
	na = vecc(na);

	if Args.PlotRT
		nnc = nbl - 1;
		nc = zeros(nnc,indsize(2));
        % create matrix of all zeros used to compute mean
        mz = zeros(indsize);
		for b = 1:nnc
            % get indices that match b
            mzi = find(ba==b);
            mz(mzi) = crt(mzi);
            nc(b,:) = sum(mz) ./ sum(mz>0);
            % reset value to 0 for next iteration
            mz(mzi) = 0;
			% nc(b,:) = mean(crt(find(ba==b)));
		end
	else
		% get the histogram of both the correct and incorrect trials
		nb = histcie([ctheta; itheta],bins,'DropLast');
		% make sure nb is a column vector
		nb = vecc(nb);
		% divide correct by total to get means
		nc = na ./ nb;
	end

	if Args.NoPolar
		h2 = plot(rad2deg(binsc),nc,'*-');
		setPlotColor(indsize(2),h2,hmap,clevel);
	else
		% add first value to the end to close the contour plot
		b = [binsc; binsc(1)];
		c = [nc; nc(1,:)];
		% plot the means
        % use repmat since the polar function requires the first two
        % arguments to be the exact size
		h2 = polar(repmat(b,1,indsize(2)),c,'*-');
		setPlotColor(indsize(2),h2,hmap,clevel);
	end
	lhandles = [lhandles; h2];
	lstring = {lstring{:},'overall'};
end	

% label contour and control locations if this is a session with 
% interpolated contours
if Args.NoPolar
	legend(lhandles,lstring,0)
	% get current axis limits
	ax1 = axis;
	if Args.PlotRT
		% change y axis to go from 0 to 300
		axis([ax1(1) ax1(2) 0 rtfmax])
		ylabel('Reaction Time')
	else
		% change y axis to go from 0 to 1
		axis([ax1(1) ax1(2) -0.05 pfmax])
		ylabel('Performance')
	end
	% change tick marks to more representative values
	set(gca,'XTick',bins/pi*180);
	% set x and y labels
	xlabel('Angle (degrees)')
else
	legend(lhandles,lstring,-1)
end

% label contour and control locations
if(intcontours)
	contourang = obj.theta(obj.indexes(1,1));
	controlang = obj.theta(obj.indexes(1,2));
	ax = axis;
	if(Args.NoPolar)
		ty = ax(3) - 0.05*ax(4);
		text(rad2deg(contourang),ty,'Contour');
		text(rad2deg(controlang),ty,'Control');
	else
		text(ax(4)*cos(contourang),ax(4)*sin(contourang),'Contour');
		text(ax(4)*cos(controlang),ax(4)*sin(controlang),'Control');
	end
end

if(Args.Session)
    title([obj.sessionname{n} ' ' Args.PlotName ' ' salname])
elseif(length(obj.sessionname)==1)
    title([obj.sessionname{1} ' ' Args.PlotName ' ' salname])
else
    title([Args.PlotName ' ' salname])
end
hold off
warning on MATLAB:divideByZero

function setPlotColor(slevels,h,map,clevel)
if(slevels>1)
	% there are multiple salience levels so loop and set colors
	for i = 1:slevels
		set(h(i),'Color',map(i,:));
	end
else
	% there is only 1 salience level so set the color to match
	% the salience level
	set(h,'Color',map(clevel,:));
end
