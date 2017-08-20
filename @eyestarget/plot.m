function [et,r] = plot(et,varargin)
%EYESTARGET/PLOT Plots eye traces together with target location
%   OBJ = PLOT(OBJ,N) calls @eyes/plot to plot the raw data from the 
%   trial specified by N. This function adds information about target 
%   location, reaction times, and discrepancies between the result of 
%   the trial using the marker file and the result using the corrected 
%   eye position signals. The eye files are assumed to be in the 
%   current directory. 
%
%   OBJ = PLOT(OBJ,N,'XY') calls @eyes/plot to plot the data 
%   in 2D. This function adds a plot of the target location in
%   2D. The following optional input arguments are also valid:
%      'FixZoom' - followed by [xwindow ywindow] array so that the
%                  axis limits are set to [fixx-xwindow fixx+xwindow 
%                  fixy-ywindow fixy+ywindow].
%
%   OBJ = PLOT(OBJ,'EyeJitter') calls eyejitter/plotEyeJitter.
%
%   OBJ = PLOT(OBJ,'iSpikes',{ISP1,ISP2}) creates a raster plot with
%   the spike trains arranged according to salience conditions. The
%   'iSpikes' argument must be followed by a cell array containing at
%   least 1 ispike object. Only the first cluster will be plotted in
%   each ispike object (they are meant to be a single cell or single
%   multi-unit response). The following optional input arguments are
%   also valid:
%      'control' - flag indicating that only trials at the control
%                  location are plotted (the trials at the contour
%                  location are plotted by default).
%      'correct' - flag indicating that only correct trials are
%                  plotted (all correct and incorrect trials are
%                  plotted by default).
%      'incorrect' - flag indicating that only incorrect trials
%                    are plotted.
%
%   Dependencies: nptReadDataFile.
%
%   obj = plot(obj,n,'XY','FixZoom',[]);
%   obj = plot(obj,'ispikes',{},'control',['correct','incorrect']);
%   obj = plot(obj,'EyeJitter','EyeJitterDuration',100,'EyeJitterRaw',...
%            'EyeJitterThreshold',0.4);

Args = struct('XY',0,'SalienceSpikes',0,'FixZoom',[],'EyeJitter',0);
Args = getOptArgs(varargin,Args, ...
	'flags',{'XY','EyeJitter','SalienceSpikes'}, ...
	'remove',{'EyeJitter','SalienceSpikes'});

% initialize return structure
r = [];

% check what type of plot is to be created
if(Args.SalienceSpikes)
	plotSalienceSpikes(et,varargin{:});
elseif(Args.EyeJitter)
	r = plotEyeJitter(et,varargin{:});
else
	% default plot is to plot trial by trial
	% get the target location for this trial
	n = Args.NumericArguments{1};
	% if not specified use n = 1
	if(isempty(n))
		n = 1;
	end
	% target = et.targets(et.sesinfo.isequence(n)+1,:);
	target = et.targets(n,:);
	
	% get the eye data
	[data,points] = get(et.eyes,'DataPixels',n);
	
	% get the stimulus onset time
	onsetTime = round(et.onsetsMS(n));
	result = et.results(n);
	markers = et.markers{n};
	rt = et.rt(n);
	
	fprintf('Result: %i RT: %i\n',result,rt);
	markers
	
	if(isempty(Args.FixZoom))
		plot(et.eyes,n,'AxisZoom',[0 et.sesinfo.width 0 et.sesinfo.height],...
                varargin{:});
	else
		% get fixation
		fixx = et.sesinfo.fixx;
		fixy = et.sesinfo.fixy;
		plot(et.eyes,n,varargin{:},'AxisZoom',[fixx-Args.FixZoom(1) ...
			fixx+Args.FixZoom(1) fixy-Args.FixZoom(2) fixy+Args.FixZoom(2)]);
	end
	hold on
	
	if(Args.XY)
        % get the coordinates of both targets
        bothtargets = unique(et.targets,'rows');
        % get the other target by doing setdiff between target and bothtargets
        target2 = setdiff(bothtargets,target,'rows');
        
		% draw box around correct target
		line([target(1) target(3)],[target(2) target(2)],'Color','r')
		line([target(1) target(3)],[target(4) target(4)],'Color','r')
		line([target(1) target(1)],[target(2) target(4)],'Color','r')
		line([target(3) target(3)],[target(2) target(4)],'Color','r')
		% draw box around other target
		line([target2(1) target2(3)],[target2(2) target2(2)],'Color','k')
		line([target2(1) target2(3)],[target2(4) target2(4)],'Color','k')
		line([target2(1) target2(1)],[target2(2) target2(4)],'Color','k')
		line([target2(3) target2(3)],[target2(2) target2(4)],'Color','k')
	else
		clist = get(gca,'ColorOrder');
		
		ax1 = axis;
		xa = [ax1(1) ax1(2)];
		line(xa,[target(2) target(2)],'Color',clist(1,:))
		line(xa,[target(4) target(4)],'Color',clist(1,:))
		line(xa,[target(1) target(1)],'Color',clist(2,:))
		line(xa,[target(3) target(3)],'Color',clist(2,:))
		
		% fix the axis in case one of the target lines is off the graph
		tmin = min(target);
		tmax = max(target);
		
		if ax1(3)>tmin
			ax1(3) = tmin;
		end
		
		if ax1(4)<tmax
			ax1(4) = tmax;
		end
		
		axis([xa ax1(3) ax1(4)])
	
		% mark stimulus onset on plot. 
		line([onsetTime onsetTime],[ax1(3) ax1(4)],'Color',clist(3,:))
	
		% plot rt
		if rt>0
			rtime = onsetTime + rt - 1;
			line([rtime rtime],[ax1(3) ax1(4)],'Color',clist(4,:));
		end
	end
		
	% check if there were markers from the marker file
	if isempty(et.tmarkers)
		title([et.sesinfo.sessionname 'eye.' sprintf('%04i',n) ' RT: ' sprintf('%d',rt) ' Result: ' sprintf('%d',result)]);
	else
		% get the result according to the markers for this trial
		mres = et.tmarkers(n).response;
		
		if mres==1
			title([et.sesinfo.sessionname 'eye.' sprintf('%04i',n) ' RT: ' sprintf('%d',rt) ' Result: ' sprintf('%d',result) ' (corrrect)']);
		else
			title([et.sesinfo.sessionname 'eye.' sprintf('%04i',n) ' RT: ' sprintf('%d',rt) ' Result: ' sprintf('%d',result) ' (incorrrect)']);
		end
	end
	
	hold off
end
