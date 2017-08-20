function ContoursPlotUnleavedSignals(signals,target,argcatch)
%ContoursPlotUnleavedSignals	Plot signals according to salience 
%conditions
%	ContoursPlotUnleavedSignals(signals,target,catch) where
%	TARGET is either 'contour' for the contour target, or 'control'
%	for the control target. CATCH is either	'catch', which means to 
%	plot the response to the catch trials, or 'nocatch' which means 
%	not to plot the response to the catch trials.

if strcmp(argcatch,'catch')
	plotcatch = 1;
   numplots = saliencesteps + 1;
   catchreps = reps/2;
elseif strcmp(argcatch,'nocatch')
	plotcatch = 0;
	numplots = saliencesteps;
end

% clear the current figure
clf

saliencesteps = size(signals.contour,2);
reps = size(signals.contour(1).repetition,2);

maxaxis = 0;

if strcmp(target,'contour')
	% plot contour conditions
	for si=1:saliencesteps
      subplot(numplots,1,si), hold on
      for ri=1:reps
         points = size(signals.contour(si).repetition(ri).data,2);
         plot(signals.timeseries(1:points),signals.contour(si).repetition(ri).data,':')
      end
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end

	if plotcatch==1
      subplot(numplots,1,numplots), hold on
      for ri=1:catchreps
         points = size(signals.catchcontour.repetition(ri).data,2);
         plot(signals.timeseries(1:points),signals.catchcontour.repetition(ri).data,':')
      end
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end	
elseif strcmp(target,'control')
	% plot control conditions
	for si=1:saliencesteps
      subplot(numplots,1,si), hold on
      for ri=1:reps
         points = size(signals.control(si).repetition(ri).data,2);
         plot(signals.timeseries(1:points),signals.control(si).repetition(ri).data,':')
      end
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end

	if plotcatch==1
      subplot(numplots,1,numplots), hold on
      for ri=1:catchreps
         points = size(signals.catchcontrol.repetition(ri).data,2);
         plot(signals.timeseries(1:points),signals.catchcontrol.repetition(ri).data,':')
      end
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end	
end
	
% make sure all plots have the same scale
for i=1:numplots
   subplot(numplots,1,i),axis([axi(1) axi(2) axi(3) maxaxis])
end
