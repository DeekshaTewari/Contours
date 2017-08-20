function psth = ContoursNeuCalPSTH(spikes,binsize)
%ContoursNeuCalPSTH	Calculate PSTHs for a session
%	PSTH = ContoursNeuCalPSTH(SPIKES,BINSIZE)

saliencesteps = size(spikes.contour,2);
reps = size(spikes.contour(1).repetition,2);
clusters=size(spikes.contour(1).repetition(1).cluster,2);
timebins = 0:binsize:spikes.duration*1000;
% save timebins in data structure so we can plot data more easily
psth.timebins = timebins;

for si=1:saliencesteps
	for cl=1:clusters
		psth.contour(si).cluster(cl).spikes = [];
		for ri=1:reps
			psth.contour(si).cluster(cl).spikes = [psth.contour(si).cluster(cl).spikes spikes.contour(si).repetition(ri).cluster(cl).spikes];
		end
		% psth.contour(si).cluster(cl).spikes = sort(psth.contour(si).cluster(cl).spikes);
		psth.contour(si).cluster(cl).psth = hist(psth.contour(si).cluster(cl).spikes,timebins);
	end
end

for si=1:saliencesteps
	for cl=1:clusters
		psth.control(si).cluster(cl).spikes = [];
		for ri=1:reps
			psth.control(si).cluster(cl).spikes = [psth.control(si).cluster(cl).spikes spikes.control(si).repetition(ri).cluster(cl).spikes];
		end
		% psth.control(si).cluster(cl).spikes = sort(psth.control(si).cluster(cl).spikes);
		psth.control(si).cluster(cl).psth = hist(psth.control(si).cluster(cl).spikes,timebins);
	end
end

if isfield(spikes,'catchcontour')
	catchreps = reps/2;
	for cl=1:clusters
		psth.catchcontour.cluster(cl).spikes = [];
		for ri=1:catchreps
			psth.catchcontour.cluster(cl).spikes = [psth.catchcontour.cluster(cl).spikes spikes.catchcontour.repetition(ri).cluster(cl).spikes];
		end
		% psth.catchcontour.cluster(cl).spikes = sort(psth.catchcontour.cluster(cl).spikes);
		psth.catchcontour.cluster(cl).psth = hist(psth.catchcontour.cluster(cl).spikes,timebins);
	end	
	
	for cl=1:clusters
		psth.catchcontrol.cluster(cl).spikes = [];
		for ri=1:catchreps
			psth.catchcontrol.cluster(cl).spikes = [psth.catchcontrol.cluster(cl).spikes spikes.catchcontrol.repetition(ri).cluster(cl).spikes];
		end
		% psth.catchcontrol.cluster(cl).spikes = sort(psth.catchcontrol.cluster(cl).spikes);
		psth.catchcontrol.cluster(cl).psth = hist(psth.catchcontrol.cluster(cl).spikes,timebins);
   end	
   
   for cl=1:clusters
      psth.allcatch.cluster(cl).psth = hist([psth.catchcontour.cluster(cl).spikes psth.catchcontrol.cluster(cl).spikes],timebins);
   end
end
