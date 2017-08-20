function rspikes = ContoursGetResultSpikes(markers,spikes)
%ContoursGetResultSpikes	Sort spike trains according to salience 
%conditions and result of the trial
%   RESULT_SPIKES = ContoursGetResultSpikes(MARKERS,SPIKES) 
%      e.g. ContoursGetResultSpikes(annie042401s08g01markers,
%      annie042401s08g01us)

saliencesteps = size(spikes.contour,2);
reps = size(spikes.contour(1).repetition,2);
catchreps = reps / 2;

% copy the duration over to the correct and incorrect data structures
rspikes.correct.duration = spikes.duration;
rspikes.incorrect.duration = spikes.duration;

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.contour(si).repetition(ri).response==1
         rspikes.correct.contour(si).repetition(rcorrect) = spikes.contour(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rspikes.incorrect.contour(si).repetition(rincorrect) = spikes.contour(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.control(si).repetition(ri).response==1
         rspikes.correct.control(si).repetition(rcorrect) = spikes.control(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rspikes.incorrect.control(si).repetition(rincorrect) = spikes.control(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

if isfield(spikes,'catchcontour')
   allcatchindex = 1;
   
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:catchreps
      if markers.catchcontour.repetition(ri).response==1
         rspikes.correct.catchcontour.repetition(rcorrect) = spikes.catchcontour.repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rspikes.incorrect.catchcontour.repetition(rincorrect) = spikes.catchcontour.repetition(ri);
         rincorrect = rincorrect + 1;
      end
      rspikes.correct.allcatch.repetition(allcatchindex) = spikes.catchcontour.repetition(ri);
      allcatchindex = allcatchindex + 1;
   end
   
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:catchreps
      if markers.catchcontrol.repetition(ri).response==1
         rspikes.correct.catchcontrol.repetition(rcorrect) = spikes.catchcontrol.repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rspikes.incorrect.catchcontrol.repetition(rincorrect) = spikes.catchcontrol.repetition(ri);
         rincorrect = rincorrect + 1;
      end
      rspikes.correct.allcatch.repetition(allcatchindex) = spikes.catchcontrol.repetition(ri);
      allcatchindex = allcatchindex + 1;
   end
   
   rspikes.incorrect.allcatch = rspikes.correct.allcatch;
end