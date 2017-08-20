function stime = ContoursExtractSpikeTimes(spikes,cluster,tstart)
%ContoursExtractSpikeTimes		Extract response latency
%	SPIKE_TIMES = ContoursExtractSpikeTimes(SPIKES,CLUSTER,T_START)

saliencesteps = size(spikes.contour,2);
stime = [];

for si=1:saliencesteps
	reps = size(spikes.contour(si).repetition,2);
	for ri=1:reps
		for spi=1:spikes.contour(si).repetition(ri).cluster(cluster).spikecount
			spiketime = spikes.contour(si).repetition(ri).cluster(cluster).spikes(spi);
			if spiketime>tstart
				stime = [stime; spiketime];
				break;
			end
		end
	end
end

if isfield(spikes,'allcatch')
	reps = size(spikes.allcatch.repetition,2);
	for ri=1:reps
		for spi=1:spikes.allcatch.repetition(ri).cluster(cluster).spikecount
			spiketime = spikes.allcatch.repetition(ri).cluster(cluster).spikes(spi);
			if spiketime>tstart
				stime = [stime; spiketime];
				break;
			end
		end
	end
end
