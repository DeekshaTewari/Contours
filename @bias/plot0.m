function obj = plot(obj,n,varargin)
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
%   PLOT(OBJ,N,'bins',BINS) uses BINS to compute the angular 
%   distributions.
%
%   PLOT(OBJ,N,'overall') plots overall data in addition to data from
%   session N.
%
%   PLOT(OBJ,N,'overallonly') plots overall data only without session
%   data. N can be any number in this case.
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
%   PLOT(...,'flat') uses a normal plot instead of a polar plot to 
%   display the data.
%
%   PLOT(...,'overallLS',OLS) uses LineSpec specified by OLS to
%   plot overall stats. The default is '--rx'.
%
%   PLOT(...,'sessionLS',SLS) uses LineSpec specified by SLS to
%   plot session stats. The default is '--co'.
%
%   Dependencies: None.

% default values for optional arguments
session = 1; % plot session data
overall = 0; % don't plot overall data from multiple sessions
bins = -pi:pi/6:pi;
% get center of bins by shifting by half a bin
binsc = bins + pi/12;
% get number of bin limits for use when computing rt means
nbl = 13;
% stimulus condition
allsalience = 1;
saliencelevel = 0;
catchdata = 0;
rt = 0;
plotname = 'Performance';
salname = '';
nopolar = 0;
% default line specs
sls = '--bx';
ols = '--ro';
cls = 'c.';
ils = 'm.';
% default value for incorrect reaction time
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

% initialize variables
lhandles = [];
lstring = {};

% look for optional arguments
num_args = nargin - 2;
i = 1;
while(i <= num_args)
	if ischar(varargin{i})
		switch varargin{i}
		case('overall')
			overall = 1;
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,1);
		case('overallonly')
			overall = 1;
			session = 0;
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,1);
		case('bins')
			bins = varargin{i+1};
			% get center of bins by shifting by half a bin
			binsc = bins + ( bins(2)-bins(1) )/2;
			% get number of bin limits for use when computing rt means
			nbl = length(bins);
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,2);
		case('salience')
			level = varargin{i+1};
			% check if level is character
			if ischar(level)
				if strcmp(level,'catch')
					allsalience = 0;
					catchdata = 1;
					salname = 'Catch Trials';
				else
					error('Unknown salience parameter');
				end
			elseif (isnumeric(level))
				allsalience = 0;
				saliencelevel = level;
				if (level>obj.eyestarget.stim_steps)
					error('Salience level exceeds levels present in data');
				end
				salname = ['Salience Level ' num2str(saliencelevel)];
			else
				error('Unknown salience parameter');
			end
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,2);
		case('rt')
			rt = 1;
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,1);
			plotname = 'Reaction Times';
		case('flat')
			nopolar = 1;
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,1);
		case('overallLS')
			ols = varargin{i+1};
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,2);
		case('sessionLS')
			sls = varargin{i+1};
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,2);
		otherwise
			% unknown string, just skip over it
			i = i + 1;		
		end
    else
		% not a character, just skip over it
		i = i + 1;
    end
end

% get number of columns, (i.e. number of salience conditions if not interpolated contours)
cn = size(obj.indexes,2);

% check if this is a session with interpolated contours
if(obj.eyestarget.stim_steps.control)
	intcontours = 1;
else
	intcontours = 0;
end

% figure out which columns to pull out if plotting specific salience levels
if(saliencelevel)
	% if not interpolated contours, we can just use saliencelevel as is
	if(intcontours)
		% interpolated contours so pull out salience level for both 
		% target and control locations
		slevel = (saliencelevel-1)*2+1;
		saliencelevel = [slevel slevel+1];
	end
end

if session
	% get rows in indexes that correspond to this session
	si = obj.sesindexes(n,:);
	if allsalience
		% if there are catch trials, grab all but the last column
		if obj.eyestarget.stim_steps.catchcontour
			% grab indexes and reshape into column vector
			ind = reshape(obj.indexes(si(1):si(2),1:(cn-1)),[],1);
		else
			ind = reshape(obj.indexes(si(1):si(2),:),[],1);
		end
	else
		if catchdata
			ind = obj.indexes(si(1):si(2),cn);
		else
			ind = obj.indexes(si(1):si(2),saliencelevel);
		end
	end
	
	% get results for selected trials
	res = obj.results(ind);
	% get indexes into overall theta and rt arrays for correct trials
	cind = ind(find(res));
	% get correct angles
	ctheta = obj.theta(cind);
	% get incorrect angles
	itheta = obj.theta(ind(find(res==0)));

	if rt
		% get reaction times for correct trials
		crt = obj.rt(cind);
		% plot incorrect trials with reaction times of 301 since there 
		% are no reaction times associated with incorrect trials
		if nopolar
			plot(itheta/pi*180,ones(size(itheta))*incrt,ils)
			hold on
			plot(ctheta/pi*180,crt,cls)
		else		
			if isempty(itheta)
				% if itheta is empty plot a dot so that the axis will be set properly
				polar(0,incrt,'k.')
			else
				polar(itheta,ones(size(itheta))*incrt,ils)
			end
			hold on
			% plot reaction times for correct trials
			polar(ctheta,crt,cls)
		end
	else
		if nopolar
			plot(ctheta/pi*180,ones(size(ctheta))*corpf,cls)
			hold on
			plot(itheta/pi*180,ones(size(itheta))*incpf,ils)
		else
			% plot with blue dot to indicate correct trial
			polar(ctheta,ones(size(ctheta))*corp,cls)
			hold on
			% plot with red dot to indicate incorrect trial
			polar(itheta,ones(size(itheta))*incp,ils)
		end
	end

	% plot the angular means for the session
	% get the histogram of the correct trials
	[na,ba] = histc(ctheta,bins);
	% make sure na is a column vector
	na = vecc(na);
	% histc returns any values that are equal to the last value of bins
	% in the last bin in na so if the last bin is non-zero, combine it
	% with the second last bin
	% get last value in na
	nae = na(end);
	% get second to last index
	nai = length(na) - 1;
	if (nae>0)
		na(nai) = na(nai) + nae;
		% change the bin number for those values to the second last bin
		ba(find(ba==nbl)) = nbl - 1;
	end
	% remove the last value
	na = na(1:nai);
	if rt
		nnc = nbl - 1;
		nc = zeros(nnc,1);
		for b = 1:nnc
			nc(b,1) = mean(crt(find(ba==b)));
		end
	else
		% get the histogram of both the correct and incorrect trials
		nb = histc([ctheta; itheta],bins);
		nbe = nb(end);
		% get second to last index
		nbi = length(nb) - 1;
		if (nbe>0)
			nb(nbi) = nb(nbi) + nbe;
		end
		% remove the last value
		nb = nb(1:nbi);
		% divide correct by total to get means
		nc = na ./ nb;
	end
	
	if nopolar
		lhandles = plot(binsc(1:(end-1))/pi*180,nc',sls);
	else
		% add first value to the end to close the contour plot
		b = [binsc(1:(end-1)) binsc(1)];
		c = [nc; nc(1)];
		% plot the means
		lhandles = polar(b,c',sls);
	end
	lstring = {'session'};
	
end

% add overall data
if overall
	if allsalience
		% if there are catch trials, grab all but the last column
		if obj.eyestarget.stim_steps.catchcontour
			% grab indexes and reshape into column vector
			ind = reshape(obj.indexes(:,1:(cn-1)),[],1);
		else
			ind = reshape(obj.indexes,[],1);
		end
	else
		if catchdata
			ind = obj.indexes(:,cn);
		else
			ind = obj.indexes(:,saliencelevel);
		end
	end
	
	% get results for selected trials
	res = obj.results(ind);
	% get indexes into overall theta and rt arrays for all correct trials
	cind = ind(find(res));
	% get correct angles
	ctheta = obj.theta(cind);
	% get incorrect angles
	itheta = obj.theta(ind(find(res==0)));
	% plot reaction times for all correct trials
	% need this outside the if ~session loop in case that condition is not met
	crt = obj.rt(cind);

	% if overallonly, plot raw data for all sessions
	if (~session)
		if rt
			if nopolar
				plot(itheta/pi*180,ones(size(itheta))*incrt,ils)
				hold on
				plot(ctheta/pi*180,crt,cls)
			else
				% plot incorrect trials with reaction times of 301 since there 
				% are no reaction times associated with incorrect trials
				if isempty(itheta)
					% if itheta is empty plot a dot so that the axis will be set properly
					polar(0,incrt,'k.')
				else
					polar(itheta,ones(size(itheta))*incrt,ils)
				end
				hold on
				% plot reaction times for all correct trials
				polar(ctheta,crt,cls)
			end
		else
			if nopolar
				plot(ctheta/pi*180,ones(size(ctheta))*corpf,cls)
				hold on
				plot(itheta/pi*180,ones(size(itheta))*incpf,ils)
			else
				% plot the angles for correct trials
				polar(ctheta,ones(size(ctheta))*corp,cls)
				hold on
				% plot the angles for incorrect trials
				polar(itheta,ones(size(itheta))*incp,ils)
			end
		end
	end

	% plot the angular means for all sessions
	% get the histogram of the correct trials
	[na,ba] = histc(ctheta,bins);
	% make sure na is a column vector
	na = vecc(na);
	% histc returns any values that are equal to the last value of bins
	% in the last bin in na so if the last bin is non-zero, combine it
	% with the second last bin
	% get last value in na
	nae = na(end);
	% get second to last index
	nai = length(na) - 1;
	if (nae>0)
		na(nai) = na(nai) + nae;
		% change the bin number for those values to the second last bin
		ba(find(ba==nbl)) = nbl - 1;
	end
	% remove the last value
	na = na(1:nai);
	if rt
		nnc = nbl - 1;
		nc = zeros(nnc,1);
		for b = 1:nnc
			nc(b,1) = mean(crt(find(ba==b)));
		end
	else
		% get the histogram of both the correct and incorrect trials
		nb = histc([ctheta; itheta],bins);
		nbe = nb(end);
		% get second to last index
		nbi = length(nb) - 1;
		if (nbe>0)
			nb(nbi) = nb(nbi) + nbe;
		end
		% remove the last value
		nb = nb(1:nbi);
		% divide correct by total to get means
		nc = na ./ nb;
	end

	if nopolar
		h2 = plot(binsc(1:(end-1))/pi*180,nc',ols);
	else
		% add first value to the end to close the contour plot
		b = [binsc(1:(end-1)) binsc(1)];
		c = [nc; nc(1)];
		% plot the means
		h2 = polar(b,c',ols);
	end
	lhandles = [lhandles h2];
	lstring = {lstring{:},'overall'};
end	

% label contour and control locations if this is a session with 
% interpolated contours
if nopolar
	legend(lhandles,lstring,0)
	% get current axis limits
	ax1 = axis;
	if rt
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
	if(nopolar)
		ty = ax(3) - 0.05*ax(4);
		text(contourang/pi*180,ty,'Contour');
		text(controlang/pi*180,ty,'Control');
	else
		text(ax(4)*cos(contourang),ax(4)*sin(contourang),'Contour');
		text(ax(4)*cos(controlang),ax(4)*sin(controlang),'Control');
	end
end
		
title([obj.sessionname{n} ' ' plotname ' ' salname])
hold off
