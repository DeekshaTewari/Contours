function plot(markers,target,argcatch)
%MARKERS/PLOT Plot markers according to salience conditions
%	PLOT(MARKERS,TARGET,CATCH) where TARGET is either 'contour' 
%   for contour target or 'control' for control target and CATCH 
%   is either 'catch' to include catch trials, 'nocatch' to 
%   exclude catch trials and 'allcatch' to plot the markers for 
%   all catch trials.

if strcmp(argcatch,'catch')
	plotcatch = 1;
elseif strcmp(argcatch,'nocatch')
	plotcatch = 0;
elseif strcmp(argcatch,'allcatch')
	% if there are no control trials, then allcatch doesn't make sense so we 
	% change it to catch. Useful when looking at psychophysical data.
	if ~isempty(markers.control)
		plotcatch = 2;
	else
		plotcatch = 1;
	end
end

% need to clear the current figure since we turn hold on right from the start
clf

hold on

y = 0.5;

if strcmp(target,'contour')
	% get contour conditions
	saliencesteps = size(markers.contour,2);
	for si=1:saliencesteps
		% get number of stimuli
		numstimuli = size(markers.contour(1).stimulus,2);
		for st=1:numstimuli
			reps = size(markers.contour(si).stimulus(st).repetition,2);
			for ri=1:reps
				for spi=1:markers.contour(si).stimulus(st).repetition(ri).num_of_markers
					marker = markers.contour(si).stimulus(st).repetition(ri).markers(spi,1);
					mtime = markers.contour(si).stimulus(st).repetition(ri).markers(spi,2);
					switch(marker)
						% case 3,
							% time of fixation off i.e. go signal
							% plot(mtime,y,'r^');
						case 983040,
							% out of ROI
							ch = plot(mtime,y,'co');
						case 983041,
							% in ROI
							mh = plot(mtime,y,'md');
						case 983042,
							% fixation established
							yh = plot(mtime,y,'yv');
						case 983043,
							% lost fixation
							kh = plot(mtime,y,'ks');
						case 983044,
							% timed out
							gh = plot(mtime,y,'g*');
					end % switch
				end % for spi
				y = y + 1;
			end % for ri
		end
	end % for si
   
	if plotcatch==1
		catchstimuli = size(markers.catchcontour.stimulus,2);
		for st=1:catchstimuli
			catchreps = size(markers.catchcontour.stimulus(st).repetition,2);
			for ri=1:catchreps
				for spi=1:markers.catchcontour.stimulus(st).repetition(ri).num_of_markers
					marker = markers.catchcontour.stimulus(st).repetition(ri).markers(spi,1);
					mtime = markers.catchcontour.stimulus(st).repetition(ri).markers(spi,2);
					switch(marker)
						% case 3,
							% time of fixation off i.e. go signal
							% plot(mtime,y,'r^');
						case 983040,
							% out of ROI
							ch = plot(mtime,y,'co');
						case 983041,
							% in ROI
							mh = plot(mtime,y,'md');
						case 983042,
							% fixation established
							yh = plot(mtime,y,'yv');
						case 983043,
							% lost fixation
							kh = plot(mtime,y,'ks');
						case 983044,
							% timed out
							gh = plot(mtime,y,'g*');
					end % switch
				end % for spi
				y = y + 1;
			end % for ri
		end
	end % if plotcatch

elseif strcmp(target,'control')
	% plot control conditions
	saliencesteps = size(markers.control,2);
	for si=1:saliencesteps
		numstimuli = size(markers.control(si).stimulus,2);
		for st=1:numstimuli
			reps = size(markers.control(si).stimulus(st).repetition,2);
			for ri=1:reps
				for spi=1:markers.control(si).stimulus(st).repetition(ri).num_of_markers
					marker = markers.control(si).stimulus(st).repetition(ri).markers(spi,1);
					mtime = markers.control(si).stimulus(st).repetition(ri).markers(spi,2);
					switch(marker)
						% case 3,
							% time of fixation off i.e. go signal
							% plot(mtime,y,'r^');
						case 983040,
							% out of ROI
							ch = plot(mtime,y,'co');
						case 983041,
							% in ROI
							mh = plot(mtime,y,'md');
						case 983042,
							% fixation established
							yh = plot(mtime,y,'yv');
						case 983043,
							% lost fixation
							kh = plot(mtime,y,'ks');
						case 983044,
							% timed out
							gh = plot(mtime,y,'g*');
					end % switch
				end % for spi
				y = y + 1;
			end % for ri
		end
	end % for si
   
	if plotcatch==1
		catchstimuli = size(markers.catchcontrol.stimulus,2);
		for st=1:catchstimuli
			catchreps = size(markers.catchcontrol.stimulus(st).repetition,2);
			for ri=1:catchreps
				for spi=1:markers.catchcontrol.stimulus(st).repetition(ri).num_of_markers
					marker = markers.catchcontrol.stimulus(st).repetition(ri).markers(spi,1);
					mtime = markers.catchcontrol.stimulus(st).repetition(ri).markers(spi,2);
					switch(marker)
						% case 3,
							% time of fixation off i.e. go signal
							% plot(mtime,y,'r^');
						case 983040,
							% out of ROI
							ch = plot(mtime,y,'co');
						case 983041,
							% in ROI
							mh = plot(mtime,y,'md');
						case 983042,
							% fixation established
							yh = plot(mtime,y,'yv');
						case 983043,
							% lost fixation
							kh = plot(mtime,y,'ks');
						case 983044,
							% timed out
							gh = plot(mtime,y,'g*');
					end % switch
				end % for spi
				y = y + 1;
			end % for ri
		end
	end % if plotcatch
end % if strcmp(target...

if plotcatch==2
	catchstimuli = size(markers.catchcontour.stimulus,2);
	for st=1:catchstimuli
		catchreps = size(markers.catchcontour.stimulus(st).repetition,2);
		for ri=1:catchreps
			for spi=1:markers.catchcontour.stimulus(st).repetition(ri).num_of_markers
				marker = markers.catchcontour.stimulus(st).repetition(ri).markers(spi,1);
				mtime = markers.catchcontour.stimulus(st).repetition(ri).markers(spi,2);
				switch(marker)
					% case 3,
						% time of fixation off i.e. go signal
						% plot(mtime,y,'r^');
					case 983040,
						% out of ROI
						ch = plot(mtime,y,'co');
					case 983041,
						% in ROI
						mh = plot(mtime,y,'md');
					case 983042,
						% fixation established
						yh = plot(mtime,y,'yv');
					case 983043,
						% lost fixation
						kh = plot(mtime,y,'ks');
					case 983044,
						% timed out
						gh = plot(mtime,y,'g*');
				end % switch
			end % for spi
			y = y + 1;
		end % for ri
	end
	
	catchstimuli = size(markers.catchcontrol.stimulus,2);
	for st=1:catchstimuli
		catchreps = size(markers.catchcontrol.stimulus(st).repetition,2);
		for ri=1:catchreps
			for spi=1:markers.catchcontrol.stimulus(st).repetition(ri).num_of_markers
				marker = markers.catchcontrol.stimulus(st).repetition(ri).markers(spi,1);
				mtime = markers.catchcontrol.stimulus(st).repetition(ri).markers(spi,2);
				switch(marker)
					% case 3,
						% time of fixation off i.e. go signal
						% plot(mtime,y,'r^');
					case 983040,
						% out of ROI
						ch = plot(mtime,y,'co');
					case 983041,
						% in ROI
						mh = plot(mtime,y,'md');
					case 983042,
						% fixation established
						yh = plot(mtime,y,'yv');
					case 983043,
						% lost fixation
						kh = plot(mtime,y,'ks');
					case 983044,
						% timed out
						gh = plot(mtime,y,'g*');
				end % switch
			end % for spi
			y = y + 1;
		end % for ri
	end
end % if plotcatch==2

% draw lines between salience conditions
ax = axis;
hstep = reps*numstimuli/2;
ttick = [];
tlabels = {};
for si=1:saliencesteps
	y = si*numstimuli*reps;
	line([ax(1) ax(2)],[y y]);
	ttick = [ttick y-hstep];
	tlabels = {tlabels{:} num2str(si)};
end

% if there are catch trials, we need to figure out where to draw the line
% and put the tickmark
if plotcatch~=0
	% if allcatch
	if plotcatch==2
		% need to actually check for allcatch since catchreps could be set
		% to that
		hstep = catchstimuli*catchreps;
		yy = y + hstep*2;
	else
		% if plotcatch==1, catchreps is number of catch trials so divide
		% by 2 to get hcreps
		step = catchstimuli*catchreps;
		hstep = step/2;
		yy = y + step;
	end
	line([ax(1) ax(2)],[yy yy]);
	ttick = [ttick y+hstep];
	tlabels = {tlabels{:} argcatch};
end
		
% turn y ticks off
set(gca,'YTick',ttick,'YTickLabel',tlabels);
legend([mh,yh,ch,gh],'entry','reward','lost fix','timed out')

hold off
