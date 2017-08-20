function ContoursPlotResultSpikes(markers,result,spikes,cluster,target,argcatch)
%ContoursPlotResultSpikes	Plot spike trains according to salience 
%conditions and result of the trial
%   ContoursPlotResultSpikes(MARKERS,RESULT,SPIKES,CLUSTER,TARGET,
%   CATCH) creates rasterplots of the response grouped according to 
%   salience values and the RESULT ('correct' or 'incorrect') of 
%   the trial found in MARKERS. TARGET is either 'contour' for the 
%   contour target, or 'control' for the control target. CATCH is 
%   either 'catch', which means to plot the responses to the catch 
%   trials, or 'nocatch' which means not to plot the responses to 
%   the catch trials.
%      e.g. ContoursPlotResultSpikes(annie042401s08g01umarkers,
%      'correct',annie042401s08g01us,1,'contour','catch') plots 
%      the spikes in cluster number 1 for the trials where the 
%      target was at the contour location and the response of
%      the animal was correct. The response to the catch trials 
%      are also plottted.

% check to see if we need to plot catch trials
if strcmp(argcatch,'catch')
	plotcatch = 1;
elseif strcmp(argcatch,'nocatch')
	plotcatch = 0;
elseif strcmp(argcatch,'allcatch')
   plotcatch = 2;
else
   fprintf('Unknown CATCH argument\n');
   return
end

% check to see if we want to plot correct trials or incorrect trials
if strcmp(result,'correct')
   plotresult = 1;
elseif strcmp(result,'incorrect')
   plotresult = 0;
end

% clear the current figure
clf

saliencesteps = size(spikes.contour,2);
reps = size(spikes.contour(1).repetition,2);
catchreps = reps / 2;

y = 0;
salienceboundary = [];

if strcmp(target,'contour')
	% plot contour conditions
	for si=1:saliencesteps
		for ri=1:reps
         if markers.contour(si).repetition(ri).response==plotresult
            yend = y + 0.75;
            for spi=1:spikes.contour(si).repetition(ri).cluster(cluster).spikecount
               spiketime = spikes.contour(si).repetition(ri).cluster(cluster).spikes(spi);
               line([spiketime spiketime],[y yend])
            end
            y = y + 1;
         end
		end
		salienceboundary = [salienceboundary y];
	end
	
	if plotcatch==1
      for ri=1:catchreps
         if markers.catchcontour.repetition(ri).response==plotresult
            yend = y + 0.75;
            for spi=1:spikes.catchcontour.repetition(ri).cluster(cluster).spikecount
               spiketime = spikes.catchcontour.repetition(ri).cluster(cluster).spikes(spi);
               line([spiketime spiketime],[y yend])
            end
            y = y + 1;
         end
      end
      salienceboundary = [salienceboundary y];
	end	
elseif strcmp(target,'control')
	% plot control conditions
	for si=1:saliencesteps
		for ri=1:reps
         if markers.control(si).repetition(ri).response==plotresult
            yend = y + 0.75;
            for spi=1:spikes.control(si).repetition(ri).cluster(cluster).spikecount
               spiketime = spikes.control(si).repetition(ri).cluster(cluster).spikes(spi);
               line([spiketime spiketime],[y yend])
            end
            y = y + 1;
         end         
		end
		salienceboundary = [salienceboundary y];
	end
	
	if plotcatch==1
		for ri=1:catchreps
         if markers.catchcontrol.repetition(ri).response==plotresult
            yend = y + 0.75;
            for spi=1:spikes.catchcontrol.repetition(ri).cluster(cluster).spikecount
               spiketime = spikes.catchcontrol.repetition(ri).cluster(cluster).spikes(spi);
               line([spiketime spiketime],[y yend])
            end
            y = y + 1;
         end
		end
		salienceboundary = [salienceboundary y];
	end	
end
	
if plotcatch==2
   for ri=1:catchreps
      if markers.catchcontour.repetition(ri).response==plotresult
         yend = y + 0.75;
         for spi=1:spikes.catchcontour.repetition(ri).cluster(cluster).spikecount
            spiketime = spikes.catchcontour.repetition(ri).cluster(cluster).spikes(spi);
            line([spiketime spiketime],[y yend])
         end
         y = y + 1;
      end
   end
   for ri=1:catchreps
      if markers.catchcontrol.repetition(ri).response==plotresult
         yend = y + 0.75;
         for spi=1:spikes.catchcontrol.repetition(ri).cluster(cluster).spikecount
            spiketime = spikes.catchcontrol.repetition(ri).cluster(cluster).spikes(spi);
            line([spiketime spiketime],[y yend])
         end
         y = y + 1;
      end
   end
end	

% get axis values so we can draw the lines separating conditions
axi = axis;
bsteps = size(salienceboundary,2);

for si=1:bsteps
   line([axi(1) axi(2)],[salienceboundary(si) salienceboundary(si)])
end
