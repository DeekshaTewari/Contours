function ContoursNeuPlotPSTH(psth,cluster,target,argcatch)
%ContoursNeuPlotPSTH	Plot PSTH according to salience 
%conditions
%	ContoursNeuPlotPSTH(PSTH,cluster,target,catch) where
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
clf

saliencesteps = size(psth.contour,2);

if plotcatch>0
	numplots = saliencesteps + 1;
else
	numplots = saliencesteps;
end

maxaxis = 0;

if strcmp(target,'contour')
	% plot contour conditions
	for si=1:saliencesteps
		subplot(numplots,1,numplots-si+1),bar(psth.timebins,psth.contour(si).cluster(cluster).psth)
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end

	if plotcatch==1
		subplot(numplots,1,1),bar(psth.timebins,psth.catchcontour.cluster(cluster).psth)
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
		subplot(numplots,1,numplots-si+1),bar(psth.timebins,psth.control(si).cluster(cluster).psth)			
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end

	if plotcatch==1
		subplot(numplots,1,1),bar(psth.timebins,psth.catchcontrol.cluster(cluster).psth)
		% get axis values
		axi = axis;
		% find max axis value so we can plot everything on the same scale
		if axi(4)>maxaxis
			maxaxis = axi(4);
		end			
	end	
end

if plotcatch==2
   subplot(numplots,1,1),bar(psth.timebins,psth.allcatch.cluster(cluster).psth)
   % get axis values
   axi = axis;
   % find max axis value so we can plot everything on the same scale
   if axi(4)>maxaxis
      maxaxis = axi(4);
   end			
end	

% make sure all plots have the same scale
for i=1:numplots
   subplot(numplots,1,i),axis([axi(1) axi(2) axi(3) maxaxis])
end
