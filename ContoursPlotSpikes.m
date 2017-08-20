function ContoursPlotSpikes(spikes,cluster,target,argcatch)
%ContoursPlotSpikes	Plot spike trains according to salience conditions
%	ContoursPlotSpikes(SPIKES,CLUSTER,TARGET,CATCH) creates 
%	rasterplots of the response grouped according to salience values.
%	TARGET is either 'contour' for the contour target, or 'control'
%	for the control target. CATCH is either 'allcatch', which means to 
%	plot the responses to all the catch trials, 'catch' which means to 
%	plot the catch trials according to locations or 'nocatch' which 
%	means not to plot the responses to the catch trials.
%		e.g. ContoursPlotUnleavedSpikes(annie042401s08g01us,1,'contour',
%					'catch') plots the spikes in cluster number 1 for the 
%					trials where the target was at the contour location.
%					The response to the catch trials are also plottted.

if strcmp(argcatch,'catch')
	plotcatch = 1;
elseif strcmp(argcatch,'nocatch')
   plotcatch = 0;
elseif strcmp(argcatch,'allcatch')
   plotcatch = 2;
end

saliencesteps = size(spikes.contour,2);
y = 0;
salienceboundary = [];

if strcmp(target,'contour')
	% plot contour conditions
	for si=1:saliencesteps
		reps = size(spikes.contour(si).repetition,2);
		for ri=1:reps
			yend = y + 0.75;
			for spi=1:spikes.contour(si).repetition(ri).cluster(cluster).spikecount
				spiketime = spikes.contour(si).repetition(ri).cluster(cluster).spikes(spi);
				line([spiketime spiketime],[y yend])
			end
			y = y + 1;
		end
		salienceboundary = [salienceboundary y];
	end
	
   if plotcatch==1
      catchreps = size(spikes.catchcontour.repetition,2);
		for ri=1:catchreps
			yend = y + 0.75;
			for spi=1:spikes.catchcontour.repetition(ri).cluster(cluster).spikecount
				spiketime = spikes.catchcontour.repetition(ri).cluster(cluster).spikes(spi);
				line([spiketime spiketime],[y yend])
			end
			y = y + 1;
		end
		salienceboundary = [salienceboundary y];
	end	
elseif strcmp(target,'control')
	% plot control conditions
	for si=1:saliencesteps
		reps = size(spikes.control(si).repetition,2);
		for ri=1:reps
			yend = y + 0.75;
			for spi=1:spikes.control(si).repetition(ri).cluster(cluster).spikecount
				spiketime = spikes.control(si).repetition(ri).cluster(cluster).spikes(spi);
				line([spiketime spiketime],[y yend])
			end
			y = y + 1;
		end
		salienceboundary = [salienceboundary y];
	end
	
	if plotcatch==1
      catchreps = size(spikes.catchcontrol.repetition,2);
		for ri=1:catchreps
			yend = y + 0.75;
			for spi=1:spikes.catchcontrol.repetition(ri).cluster(cluster).spikecount
				spiketime = spikes.catchcontrol.repetition(ri).cluster(cluster).spikes(spi);
				line([spiketime spiketime],[y yend])
			end
			y = y + 1;
		end
		salienceboundary = [salienceboundary y];
	end	
end

if plotcatch==2
	if isfield(spikes,'allcatch')
		catchreps = size(spikes.allcatch.repetition,2);
		for ri=1:catchreps
			yend = y + 0.75;
			for spi=1:spikes.allcatch.repetition(ri).cluster(cluster).spikecount
				spiketime = spikes.allcatch.repetition(ri).cluster(cluster).spikes(spi);
				line([spiketime spiketime],[y yend])
			end
			y = y + 1;
		end
		salienceboundary = [salienceboundary y];		
	else
	   catchreps = size(spikes.catchcontour.repetition,2);
	   for ri=1:catchreps
		  yend = y + 0.75;
		  for spi=1:spikes.catchcontour.repetition(ri).cluster(cluster).spikecount
			 spiketime = spikes.catchcontour.repetition(ri).cluster(cluster).spikes(spi);
			 line([spiketime spiketime],[y yend])
		  end
		  y = y + 1;
	   end
	   
	   catchreps = size(spikes.catchcontrol.repetition,2);
	   for ri=1:catchreps
		  yend = y + 0.75;
		  for spi=1:spikes.catchcontrol.repetition(ri).cluster(cluster).spikecount
			 spiketime = spikes.catchcontrol.repetition(ri).cluster(cluster).spikes(spi);
			 line([spiketime spiketime],[y yend])
		  end
		  y = y + 1;
	   end
	   salienceboundary = [salienceboundary y];
	end
end	

% get axis values so we can draw the lines separating conditions
axi = axis;
bsteps = size(salienceboundary,2);

for si=1:bsteps
   line([axi(1) axi(2)],[salienceboundary(si) salienceboundary(si)])
end
