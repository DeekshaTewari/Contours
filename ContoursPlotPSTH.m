function ContoursPlotPSTH(psth,cluster,target,argcatch)
%ContoursPlotPSTH	Plot PSTH according to salience 
%conditions
%	ContoursPlotPSTH(PSTH,cluster,target,catch) where
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
      % get max data value
      dmax = max(psth.contour(si).cluster(cluster).psth);
		% find max axis value so we can plot everything on the same scale
		if dmax>maxaxis
			maxaxis = dmax;
		end			
	end

	if plotcatch==1
		subplot(numplots,1,1),bar(psth.timebins,psth.catchcontour.cluster(cluster).psth)
      % get max data value
      dmax = max(psth.catchcontour.cluster(cluster).psth);
		% find max axis value so we can plot everything on the same scale
		if dmax>maxaxis
			maxaxis = dmax;
		end			
	end	
elseif strcmp(target,'control')
	% plot control conditions
	for si=1:saliencesteps
		subplot(numplots,1,numplots-si+1),bar(psth.timebins,psth.control(si).cluster(cluster).psth)			
      % get max data value
      dmax = max(psth.control(si).cluster(cluster).psth);
		% find max axis value so we can plot everything on the same scale
		if dmax>maxaxis
         maxaxis = dmax;
      end
	end

	if plotcatch==1
		subplot(numplots,1,1),bar(psth.timebins,psth.catchcontrol.cluster(cluster).psth)
      % get max data value
      dmax = max(psth.catchcontrol.cluster(cluster).psth);
		% find max axis value so we can plot everything on the same scale
		if dmax>maxaxis
         maxaxis = dmax;
		end			
	end	
end

if plotcatch==2
   subplot(numplots,1,1),bar(psth.timebins,psth.allcatch.cluster(cluster).psth)
   % get max data value
   dmax = max(psth.allcatch.cluster(cluster).psth);
   % find max axis value so we can plot everything on the same scale
   if dmax>maxaxis
      maxaxis = dmax;
   end			
end	

axi = axis;
% set axis to 10% more than the maxaxis
maxaxis = 1.1 * maxaxis;
% make sure all plots have the same scale
for i=1:numplots
   subplot(numplots,1,i),axis([axi(1) axi(2) axi(3) maxaxis])
end
