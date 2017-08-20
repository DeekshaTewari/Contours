function rsignals = ContoursGetResultSignals(markers,signals)
%ContoursGetResultsSgnals	Sort signals according to salience 
%conditions and result of the trial
%   RESULT_SIGNALS = ContoursGetResultSignals(MARKERS,SIGNALS) 
%      e.g. ContoursGetResultSignals(annie042401s08g01markers,
%      annie042401s08g01lfps)

saliencesteps = size(signals.contour,2);
reps = size(signals.contour(1).repetition,2);
catchreps = reps / 2;

% copy the duration over to the correct and incorrect data structures
rsignals.correct.timeseries = signals.timeseries;
rsignals.correct.sampling_rate = signals.sampling_rate;
rsignals.incorrect.timeseries = signals.timeseries;
rsignals.incorrect.sampling_rate = signals.sampling_rate;

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.contour(si).repetition(ri).response==1
         rsignals.correct.contour(si).repetition(rcorrect) = signals.contour(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rsignals.incorrect.contour(si).repetition(rincorrect) = signals.contour(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.control(si).repetition(ri).response==1
         rsignals.correct.control(si).repetition(rcorrect) = signals.control(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rsignals.incorrect.control(si).repetition(rincorrect) = signals.control(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

if isfield(signals,'catchcontour')
   allcatchindex = 1;
   
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:catchreps
      if markers.catchcontour.repetition(ri).response==1
         rsignals.correct.catchcontour.repetition(rcorrect) = signals.catchcontour.repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rsignals.incorrect.catchcontour.repetition(rincorrect) = signals.catchcontour.repetition(ri);
         rincorrect = rincorrect + 1;
      end
      rsignals.correct.allcatch.repetition(allcatchindex) = signals.catchcontour.repetition(ri);
      allcatchindex = allcatchindex + 1;
   end
   
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:catchreps
      if markers.catchcontrol.repetition(ri).response==1
         rsignals.correct.catchcontrol.repetition(rcorrect) = signals.catchcontrol.repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rsignals.incorrect.catchcontrol.repetition(rincorrect) = signals.catchcontrol.repetition(ri);
         rincorrect = rincorrect + 1;
      end
      rsignals.correct.allcatch.repetition(allcatchindex) = signals.catchcontour.repetition(ri);
      allcatchindex = allcatchindex + 1;
   end
   
   rsignals.incorrect.allcatch = rsignals.correct.allcatch;
end