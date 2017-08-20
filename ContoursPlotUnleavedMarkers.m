function ContoursPlotUnleavedMarkers(markers,target,argcatch)
%ContoursPlotUnleavedMarkers	Plot markers according to salience conditions
%	ContoursPlotUnleavedMarkers(UNLEAVED_MARKERS,TARGET,CATCH) where
%	TARGET is either 'contour' for contour target or 'control' for 
%	control target and CATCH is either 'catch' to include catch 
%	trials and 'nocatch' to exclude catch trials.

if strcmp(argcatch,'catch')
	plotcatch = 1;
   catchreps = reps/2;
elseif strcmp(argcatch,'nocatch')
	plotcatch = 0;
end

% clear the current figure
clf

hold on
% plot contour conditions
saliencesteps = size(markers.contour,2);
reps = size(markers.contour(1).repetition,2);

y = 0.5;

if strcmp(target,'contour')
	for si=1:saliencesteps
		for ri=1:reps
			for spi=1:markers.contour(si).repetition(ri).num_of_markers
				marker = markers.contour(si).repetition(ri).markers(spi,1);
				mtime = markers.contour(si).repetition(ri).markers(spi,2);
				switch(marker)
					% case 3,
						% time of fixation off i.e. go signal
						% plot(mtime,y,'r^');
					case 983040,
						% out of ROI
						plot(mtime,y,'co');
					case 983041,
						% in ROI
						plot(mtime,y,'md');
					case 983042,
						% fixation established
						plot(mtime,y,'yv');
					case 983043,
						% lost fixation
						plot(mtime,y,'ks');
					case 983044,
						% timed out
						plot(mtime,y,'g*');
			    end
			end
			y = y + 1;
		end
   end
   
  	if plotcatch==1
		for ri=1:catchreps
			for spi=1:markers.catchcontour.repetition(ri).num_of_markers
				marker = markers.catchcontour.repetition(ri).markers(spi,1);
				mtime = markers.catchcontour.repetition(ri).markers(spi,2);
				switch(marker)
					% case 3,
						% time of fixation off i.e. go signal
						% plot(mtime,y,'r^');
					case 983040,
						% out of ROI
						plot(mtime,y,'co');
					case 983041,
						% in ROI
						plot(mtime,y,'md');
					case 983042,
						% fixation established
						plot(mtime,y,'yv');
					case 983043,
						% lost fixation
						plot(mtime,y,'ks');
					case 983044,
						% timed out
						plot(mtime,y,'g*');
			    end
			end
         y = y + 1;
      end
   end

elseif strcmp(target,'control')
	for si=1:saliencesteps
		for ri=1:reps
			for spi=1:markers.control(si).repetition(ri).num_of_markers
				marker = markers.control(si).repetition(ri).markers(spi,1);
				mtime = markers.control(si).repetition(ri).markers(spi,2);
				switch(marker)
					% case 3,
						% time of fixation off i.e. go signal
						% plot(mtime,y,'r^');
					case 983040,
						% out of ROI
						plot(mtime,y,'co');
					case 983041,
						% in ROI
						plot(mtime,y,'md');
					case 983042,
						% fixation established
						plot(mtime,y,'yv');
					case 983043,
						% lost fixation
						plot(mtime,y,'ks');
					case 983044,
						% timed out
						plot(mtime,y,'g*');
			    end
			end
			y = y + 1;
		end
	end
   
   if plotcatch==1
		for ri=1:catchreps
			for spi=1:markers.catchcontrol.repetition(ri).num_of_markers
				marker = markers.catchcontrol.repetition(ri).markers(spi,1);
				mtime = markers.catchcontrol.repetition(ri).markers(spi,2);
				switch(marker)
					% case 3,
						% time of fixation off i.e. go signal
						% plot(mtime,y,'r^');
					case 983040,
						% out of ROI
						plot(mtime,y,'co');
					case 983041,
						% in ROI
						plot(mtime,y,'md');
					case 983042,
						% fixation established
						plot(mtime,y,'yv');
					case 983043,
						% lost fixation
						plot(mtime,y,'ks');
					case 983044,
						% timed out
						plot(mtime,y,'g*');
			    end
			end
         y = y + 1;
      end
   end
end
	
hold off