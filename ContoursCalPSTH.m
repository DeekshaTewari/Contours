function psth = ContoursCalPSTH(spikes,binsize)
%ContoursCalPSTH	Calculate PSTHs for a session
%	PSTH = ContoursCalPSTH(SPIKES,BINSIZE)

saliencesteps = size(spikes.contour,2);
clusters=size(spikes.contour(1).repetition(1).cluster,2);
timebins = 0:binsize:spikes.duration*1000;
% save timebins in data structure so we can plot data more easily
psth.timebins = timebins;

for si=1:saliencesteps
   reps = size(spikes.contour(si).repetition,2);
   for cl=1:clusters
		psth.contour(si).cluster(cl).spikes = [];
      for ri=1:reps
			psth.contour(si).cluster(cl).spikes = [psth.contour(si).cluster(cl).spikes spikes.contour(si).repetition(ri).cluster(cl).spikes];
		end
		% psth.contour(si).cluster(cl).spikes = sort(psth.contour(si).cluster(cl).spikes);
		psth.contour(si).cluster(cl).psth = hist(psth.contour(si).cluster(cl).spikes,timebins)/reps;
	end
end

for si=1:saliencesteps
   reps = size(spikes.control(si).repetition,2);
	for cl=1:clusters
		psth.control(si).cluster(cl).spikes = [];
		for ri=1:reps
			psth.control(si).cluster(cl).spikes = [psth.control(si).cluster(cl).spikes spikes.control(si).repetition(ri).cluster(cl).spikes];
		end
		% psth.control(si).cluster(cl).spikes = sort(psth.control(si).cluster(cl).spikes);
		psth.control(si).cluster(cl).psth = hist(psth.control(si).cluster(cl).spikes,timebins)/reps;
	end
end

if isfield(spikes,'catchcontour')
   reps = size(spikes.catchcontour.repetition,2);
	for cl=1:clusters
		psth.catchcontour.cluster(cl).spikes = [];
		for ri=1:reps
			psth.catchcontour.cluster(cl).spikes = [psth.catchcontour.cluster(cl).spikes spikes.catchcontour.repetition(ri).cluster(cl).spikes];
		end
		% psth.catchcontour.cluster(cl).spikes = sort(psth.catchcontour.cluster(cl).spikes);
		psth.catchcontour.cluster(cl).psth = hist(psth.catchcontour.cluster(cl).spikes,timebins)/reps;
	end	
   
   catchreps = reps;
   
   reps = size(spikes.catchcontrol.repetition,2);
	for cl=1:clusters
		psth.catchcontrol.cluster(cl).spikes = [];
		for ri=1:reps
			psth.catchcontrol.cluster(cl).spikes = [psth.catchcontrol.cluster(cl).spikes spikes.catchcontrol.repetition(ri).cluster(cl).spikes];
		end
		% psth.catchcontrol.cluster(cl).spikes = sort(psth.catchcontrol.cluster(cl).spikes);
		psth.catchcontrol.cluster(cl).psth = hist(psth.catchcontrol.cluster(cl).spikes,timebins)/reps;
   end	
   
   % catchreps = catchreps + reps;
   % for cl=1:clusters
   %    psth.allcatch.cluster(cl).psth = hist([psth.catchcontour.cluster(cl).spikes psth.catchcontrol.cluster(cl).spikes],timebins)/catchreps;
   % end
   
	if isfield(spikes,'allcatch')
		reps = size(spikes.allcatch.repetition,2);
		for cl=1:clusters
			psth.allcatch.cluster(cl).spikes = [];
			for ri = 1:reps
				psth.allcatch.cluster(cl).spikes = [psth.allcatch.cluster(cl).spikes spikes.allcatch.repetition(ri).cluster(cl).spikes];
			end
			psth.allcatch.cluster(cl).psth = hist(psth.allcatch.cluster(cl).spikes,timebins)/reps;
		end
	end   
end
