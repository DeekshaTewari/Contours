function rmarkers = ContoursGetResultMarkers(markers)
%ContoursGetResultMarkers	Sort markers according to salience 
%conditions and result of the trial
%   RESULT_MARKERS = ContoursGetResultMarkers(MARKERS) 
%      e.g. ContoursGetResultMarkers(annie042401s08g01markers)

saliencesteps = size(markers.contour,2);
reps = size(markers.contour(1).repetition,2);
catchreps = reps / 2;

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.contour(si).repetition(ri).response==1
         rmarkers.correct.contour(si).repetition(rcorrect) = markers.contour(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rmarkers.incorrect.contour(si).repetition(rincorrect) = markers.contour(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.control(si).repetition(ri).response==1
         rmarkers.correct.control(si).repetition(rcorrect) = markers.control(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rmarkers.incorrect.control(si).repetition(rincorrect) = markers.control(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

if isfield(markers,'catchcontour')
   allcatchindex = 1;
   
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:catchreps
      if markers.catchcontour.repetition(ri).response==1
         rmarkers.correct.catchcontour.repetition(rcorrect) = markers.catchcontour.repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rmarkers.incorrect.catchcontour.repetition(rincorrect) = markers.catchcontour.repetition(ri);
         rincorrect = rincorrect + 1;
      end
      rmarkers.correct.allcatch.repetition(allcatchindex) = markers.catchcontour.repetition(ri);
      allcatchindex = allcatchindex + 1;
   end
   
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:catchreps
      if markers.catchcontrol.repetition(ri).response==1
         rmarkers.correct.catchcontrol.repetition(rcorrect) = markers.catchcontrol.repetition(ri);
         rcorrect = rcorrect + 1;
      else
         rmarkers.incorrect.catchcontrol.repetition(rincorrect) = markers.catchcontrol.repetition(ri);
         rincorrect = rincorrect + 1;
      end
      rmarkers.correct.allcatch.repetition(allcatchindex) = markers.catchcontrol.repetition(ri);
      allcatchindex = allcatchindex + 1;
   end
   
   rmarkers.incorrect.allcatch = rmarkers.correct.allcatch;
end