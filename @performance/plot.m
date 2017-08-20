function p = plot(p,varargin)
%PERFORMANCE/PLOT Plots data from PERFORMANCE object
%   P = PLOT(P,N) plots the data in the PERFORMANCE object P from session
%   N, using the stim_p values inherited from the sesinfo object. If 
%   catch trials are present they will be added to the plot so that 
%   they are seprated from the last stim_p value, as well as from 
%   each other. If there are catch trials for multiple stimulus 
%   conditions. 
%   The following data are plotted: 
%      contourmean and contoursd (in blue), 
%      controlmean and controlsd (in red), 
%      overallmean and overallsd (in green). 
%   If catch trials are present, 
%      catchcontourmean and catchcontoursd (in blue), 
%      catchcontrolmean and catchcontrolsd (in red), 
%      catchoverallmean and catchoverallsd (in green) are also plotted.
%
%   PLOT(P,N,'overall') plots overall data in addition to data from
%   session N.
%
%   PLOT(P,N,'overallonly') plots overall data only without session
%   data. N can be any number in this case.
%
%   PLOT(P,N,'plots',PVEC) specifies which stimulus conditions are
%   plotted. PVEC is a 3 element vector of 0 and 1 represeting the 
%   following: [plotcontour plotcontrol plotcombined] where
%      plotcontour: Plots data at the target location.
%      plotcontrol: Plots data at the control location.
%      plotcombined: Plots data averaged across both locations.
%   e.g. PLOT(P,N,'plots',[1 1 0]) plots data at the target and control
%   locations but not the combined data.
%
%   PLOT(P,N,'catchstep',NUM) separates the data for the catch trials
%   by NUM steps. The default value is 5 steps.
%
%   PLOT(P,N,'overallonly','sessionmeans') plots the means of each
%   session along with the overall mean for each salience condition.
%
%   Dependencies: None.

Args = struct('Overall',0,'OverallOnly',0,'Plots',[1 1 1],'CatchStep',5, ...
	'SessionMeans',0,'flags',{{'Overall','OverallOnly','SessionMeans'}});
Args = getOptArgs(varargin,Args);

if(isempty(Args.NumericArguments))
	n = 1;
else
	n = Args.NumericArguments{1};
end

% default values for optional arguments
session = 1; % plot session data
overall = 0; % don't plot overall data from multiple sessions

if(Args.Overall)
	overall = 1;
end
if(Args.OverallOnly)
	session = 0;
	overall = 1;
end

% check if there are 3 values in Args.Plots
if (length(Args.Plots) ~= 3)
	fprintf('Warning: Plots argument has to contain 3 numbers\n');
	fprintf('Using default values\n');
	plotcontour = 1; % plot contour data
	plotcontrol = 1; % plot control data
	plotcombined = 1; % plot combined data 
else
	plotcontour = Args.Plots(1);
	plotcontrol = Args.Plots(2);
	plotcombined = Args.Plots(3);
end
cstep = Args.CatchStep;
sessionmeans = Args.SessionMeans;

stim_p = p.eyestarget.stim_p;
cla
hold on
% initialize legend handles and legend string
lhandles = [];
lstring = {};
cx = 0;

% check if there are any control data
if(isempty(p.session(1).controlmean))
	% skip plotcontrol and plotcombined regardless of what they are set to
	plotcontrol = 0;
	plotcombined = 0;
end

if session
	if plotcontour
		% save handles for use with legend
		sa = errorbar(stim_p,p.session(n).contourmean,p.session(n).contoursd,'bo-');
		cx = stim_p(end);
        % use sa(end) since we need the second handle if we are using
        % Matlab 6.5 and the first (and only) handle if we are using Matlab
        % 7.
		lhandles = [lhandles sa(end)];
		lstring = {lstring{:}, 'contour'};
		
		% plot catch data if there are catch trials
		if(~isempty(p.session(n).catchcontourmean))
			cx = cx+cstep;
			errorbar(cx,p.session(n).catchcontourmean,p.session(n).catchcontoursd,'bo-');
		end			
	end
	
	if plotcontrol
		sb = errorbar(stim_p,p.session(n).controlmean,p.session(n).controlsd,'r^-');
		% if plotcontour==0 initialize cx, otherwise leave cx so the
		% catch data for the different conditions will be plotted with a
		% little offset from each other
		if(cx==0)
			cx = stim_p(end);
		end
        % use sa(end) since we need the second handle if we are using
        % Matlab 6.5 and the first (and only) handle if we are using Matlab
        % 7.
		lhandles = [lhandles sb(end)];
		lstring = {lstring{:}, 'control'};
		
		% plot catch data if there are catch trials
		if(~isempty(p.session(n).catchcontrolmean))
			cx = cx+cstep;
			errorbar(cx,p.session(n).catchcontrolmean,p.session(n).catchcontrolsd,'r^-');
		end
	end

	if plotcombined
		sc = errorbar(stim_p,p.session(n).overallmean,p.session(n).overallsd,'gx-');
		if(cx==0)
			cx = stim_p(end);
		end
        % use sa(end) since we need the second handle if we are using
        % Matlab 6.5 and the first (and only) handle if we are using Matlab
        % 7.
		lhandles = [lhandles sc(end)];
		lstring = {lstring{:}, 'combined'};
	
		% plot catch data if there are catch trials
		if(~isempty(p.session(n).catchoverallmean))
			cx = cx+cstep;
			errorbar(cx,p.session(n).catchoverallmean,p.session(n).catchoverallsd,'gx-');
		end
	end
end
	
if overall
	% create cool colormap scaled by number of sessions
	cmap = cool(p.sessions);
	if plotcontour
		if sessionmeans
			for i = 1:p.sessions
				plot(stim_p,p.session(i).contourmean,'Color',cmap(i,:))
			end
		end
		
		% save handles for use with legend
		sa = errorbar(stim_p,p.contourmean,p.contoursd,'ko-');
		cx = stim_p(end);
        % use sa(end) since we need the second handle if we are using
        % Matlab 6.5 and the first (and only) handle if we are using Matlab
        % 7.
		lhandles = [lhandles sa(end)];
		lstring = {lstring{:}, 'overall contour'};

		if (~isempty(p.catchcontourmean))
			cx = cx+cstep;
			if sessionmeans
				for i = 1:p.sessions
					plot(cx,p.session(i).catchcontourmean,'Color',cmap(i,:),'Marker','o')
				end
			end
			errorbar(cx,p.catchcontourmean,p.catchcontoursd,'ko-');
		end
	end
	
	if plotcontrol
		if sessionmeans
			for i = 1:p.sessions
				plot(stim_p,p.session(i).controlmean,'m.')
			end
		end
		
		sb = errorbar(stim_p,p.controlmean,p.controlsd,'m^-');
		if(cx==0)
			cx = stim_p(end);
		end
        % use sa(end) since we need the second handle if we are using
        % Matlab 6.5 and the first (and only) handle if we are using Matlab
        % 7.
		lhandles = [lhandles sb(end)];
		lstring = {lstring{:}, 'overall control'};

		% plot catch data if there are catch trials
		if(~isempty(p.session(n).catchcontrolmean))
			cx = cx + cstep;
			if sessionmeans
				for i = 1:p.sessions
					plot(cx,p.session(i).catchcontrolmean,'m.')
				end
			end
			errorbar(cx,p.catchcontrolmean,p.catchcontrolsd,'m^-');
		end	
	end
	
	if plotcombined
		if sessionmeans
			for i = 1:p.sessions
				plot(stim_p,p.session(i).overallmean,'y.')
			end
		end
		
		sc = errorbar(stim_p,p.overallmean,p.overallsd,'yx-');
        % use sa(end) since we need the second handle if we are using
        % Matlab 6.5 and the first (and only) handle if we are using Matlab
        % 7.
		lhandles = [lhandles sc(end)];
		lstring = {lstring{:}, 'overall combined'};
		
		% plot catch data if there are catch trials
		if(~isempty(p.session(n).catchoverallmean))
			cx = cx + cstep;
			if sessionmeans
				for i = 1:p.sessions
					plot(cx,p.session(i).overallmean,'y.')
				end
			end
			errorbar(cx,p.catchoverallmean,p.catchoverallsd,'yx-');
		end		
	end
end

legend(lhandles,lstring,'Location','northeast')
axi = axis;
axis([stim_p(1)-cstep cx+cstep -0.05 1.05])
set(gca,'XTick',stim_p);
xlabel('Ori Jitter (degrees)')
ylabel('Performance')
title(p.session(n).sessionname)
	
hold off
