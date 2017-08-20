function avgsignals = ContoursAverageSignals(signals,min_duration)
%ContoursAverageSignals	Average signals according to salience values
%	AVERAGE_SIGNALS = ContoursAverageSignals(SIGNALS) takes SIGNALS 
%	and computes the average signal for each salience condition. 

saliencesteps = size(signals.contour,2);
minpoints = floor(min_duration*signals.sampling_rate);

avgsignals.timeseries = signals.timeseries;
avgsignals.sampling_rate = signals.sampling_rate;

for si=1:saliencesteps
	avgsignals.contour(si).repetition.data = [];
	reps = size(signals.contour(si).repetition,2);
	for ri=1:reps
		avgsignals.contour(si).repetition.data = [avgsignals.contour(si).repetition.data; signals.contour(si).repetition(ri).data(1:minpoints)];
	end
	avgsignals.contour(si).repetition.data = mean(avgsignals.contour(si).repetition.data);
end

for si=1:saliencesteps
	avgsignals.control(si).repetition.data = [];
	reps = size(signals.control(si).repetition,2);
	for ri=1:reps
		avgsignals.control(si).repetition.data = [avgsignals.control(si).repetition.data; signals.control(si).repetition(ri).data(1:minpoints)];
	end
	avgsignals.control(si).repetition.data = mean(avgsignals.control(si).repetition.data);
end

if isfield(signals,'catchcontour')
   avgsignals.catchcontour.repetition.data = [];
   reps = size(signals.catchcontour.repetition,2);
   for ri=1:reps
      avgsignals.catchcontour.repetition.data = [avgsignals.catchcontour.repetition.data; signals.catchcontour.repetition(ri).data(1:minpoints)];
   end
   avgsignals.catchcontour.repetition.data = mean(avgsignals.catchcontour.repetition.data);
   
   avgsignals.catchcontrol.repetition.data = [];
   reps = size(signals.catchcontrol.repetition,2);
   for ri=1:reps
      avgsignals.catchcontrol.repetition.data = [avgsignals.catchcontrol.repetition.data; signals.catchcontrol.repetition(ri).data(1:minpoints)];
   end
   avgsignals.catchcontrol.repetition.data = mean(avgsignals.catchcontrol.repetition.data);
   
   if isfield(signals,'allcatch')
      avgsignals.allcatch.repetition.data = [];
      reps = size(signals.allcatch.repetition,2);
      for ri=1:reps
         avgsignals.allcatch.repetition.data = [avgsignals.allcatch.repetition.data; signals.allcatch.repetition(ri).data(1:minpoints)];
      end
      avgsignals.allcatch.repetition.data = mean(avgsignals.allcatch.repetition.data);
   end
end