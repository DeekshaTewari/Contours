function tuning = ContoursCalOriTuning(spikes,tstart,tend,sesinfo)
%ContoursCalOriTuning	Calculate orientation tuning for a session
%	TUNING = ContoursCalOriTuning(SPIKES,TSTART,TEND,SESINFO)

% make sure that this session has tuning stimuli
if sesinfo.includetuning~=1
	fprintf('Error: No tuning stimuli in this session.\n');
	return
end

totalcontrolstimuli = sesinfo.stim_steps*sesinfo.stimsets;
tuningsets = totalcontrolstimuli/sesinfo.numtuningdir;
% tuningincr = sesinfo.tuningstepsize;
tuningstartoffset = -(sesinfo.numtuningdir-1)/2*sesinfo.tuningstepsize;

clusters = size(spikes.control(1).repetition(1).cluster,2);

oldtuningstimnum = 0;
for si=1:sesinfo.stim_steps
	reps = size(spikes.control(si).repetition,2);
	for ri=1:reps
		index = (si-1)*sesinfo.stimsets + ri;
		tuningstimnum = ceil(index / tuningsets);
		if tuningstimnum>oldtuningstimnum
			oldtuningstimnum = tuningstimnum;
			for cl=1:clusters
				tuning.cluster(cl).rate(tuningstimnum) = 0;
			end
		end
		for cl=1:clusters
			for spi=1:spikes.control(si).repetition(ri).cluster(cl).spikecount
				spiketime = spikes.control(si).repetition(ri).cluster(cl).spikes(spi);
				if spiketime>=tstart & spiketime<=tend
					tuning.cluster(cl).rate(tuningstimnum) = tuning.cluster(cl).rate(tuningstimnum) + 1;
				elseif spiketime>tend
					break;
				end
			end
		end
	end
end
   
timewindow = tend-tstart+1;
stimorientations = tuningstartoffset + (0:1:sesinfo.numtuningdir-1) * sesinfo.tuningstepsize;
for cl=1:clusters
	tuning.cluster(cl).rate = [stimorientations' transpose(tuning.cluster(cl).rate/timewindow*1000)];
end

