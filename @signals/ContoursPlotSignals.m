function ContoursPlotSignals(signals,target,argcatch)
%ContoursPlotSignals	Plot signals according to salience conditions
%	ContoursPlotSignals(SIGNALS,TARGET,CATCH) where
%	TARGET is either 'contour' for the contour target, or 'control'
%	for the control target. CATCH is either	'catch', which means to 
%	plot the response to the catch trials, or 'nocatch' which means 
%	not to plot the response to the catch trials.

if strcmp(argcatch,'catch')
	plotcatch = 1;
elseif strcmp(argcatch,'nocatch')
   plotcatch = 0;
elseif strcmp(argcatch,'allcatch')
   plotcatch = 2;
end

% clear the current figure
% clf

saliencesteps = size(signals.contour,2);

if plotcatch>0
	numplots = saliencesteps + 1;
else
	numplots = saliencesteps;
end

axisvalues = [];

if strcmp(target,'contour')
	% plot contour conditions
	for si=1:saliencesteps
		subplot(numplots,1,numplots-si+1), hold on
		reps = size(signals.contour(si).repetition,2);
		for ri=1:reps
			points = size(signals.contour(si).repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.contour(si).repetition(ri).data,'-')
		end
		% get axis values
		axisvalues = [axisvalues; axis];
	end
	
	if plotcatch==1
		subplot(numplots,1,1), hold on
		catchreps = size(signals.catchcontour.repetition,2);
		for ri=1:catchreps
			points = size(signals.catchcontour.repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.catchcontour.repetition(ri).data,'-')
		end
		% get axis values
		axisvalues = [axisvalues; axis];
	end	
elseif strcmp(target,'control')
	% plot control conditions
	for si=1:saliencesteps
		subplot(numplots,1,numplots-si+1), hold on
		reps = size(signals.control(si).repetition,2);
		for ri=1:reps
			points = size(signals.control(si).repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.control(si).repetition(ri).data,'-')
		end
		% get axis values
		axisvalues = [axisvalues; axis];
	end
	
	if plotcatch==1
		subplot(numplots,1,1), hold on
		catchreps = size(signals.catchcontrol.repetition,2);
		for ri=1:catchreps
			points = size(signals.catchcontrol.repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.catchcontrol.repetition(ri).data,'-')
		end
		% get axis values
		axisvalues = [axisvalues; axis];
	end	
end
	
if plotcatch==2
	if isfield(signals,'allcatch')
		subplot(numplots,1,1), hold on
		catchreps = size(signals.allcatch.repetition,2);
		for ri=1:catchreps
			points = size(signals.allcatch.repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.allcatch.repetition(ri).data,'-')
		end
	else
		subplot(numplots,1,1), hold on
		catchreps = size(signals.catchcontour.repetition,2);
		for ri=1:catchreps
			points = size(signals.catchcontour.repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.catchcontour.repetition(ri).data,'-')
		end
	   
		subplot(numplots,1,1), hold on
		catchreps = size(signals.catchcontrol.repetition,2);
		for ri=1:catchreps
			points = size(signals.catchcontrol.repetition(ri).data,2);
			plot(signals.timeseries(1:points),signals.catchcontrol.repetition(ri).data,'-')
		end
	end
	% get axis values
	axisvalues = [axisvalues; axis];
end	

maxavalues = max(axisvalues);
minavalues = min(axisvalues);
% make sure all plots have the same scale
for i=1:numplots
	subplot(numplots,1,i),axis([minavalues(1) maxavalues(2) minavalues(3) maxavalues(4)])
end
