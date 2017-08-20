function seq = ContoursGetResultSequence(markers,sequence)
%ContoursGetResultSequence	Sorts trial sequence into salience conditions and 
%result of the trial.
%	RESULT_SEQ = ContoursGetResultSequence(MARKERS,SEQUENCE) converts the stimulus
%	trial sequence (SEQUENCE returned from ContoursUnleaveSequence) 
%	into the stimlus conditions used in the experiment. 
%	RESULT_SEQ has the following format:
%		SEQ.contour(i).repetition(j)
%		SEQ.control(i).repetition(j)
%		SEQ.catchcontour.repetition(j)
%		SEQ.catchcontrol.repetition(j)
%
%	Dependencies: None.

saliencesteps = size(markers.contour,2);
reps = size(markers.contour(1).repetition,2);
catchreps = reps / 2;

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.contour(si).repetition(ri).response==1
         seq.correct.contour(si).repetition(rcorrect) = sequence.contour(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         seq.incorrect.contour(si).repetition(rincorrect) = sequence.contour(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

for si=1:saliencesteps
   rcorrect = 1;
   rincorrect = 1;
   for ri=1:reps
      if markers.control(si).repetition(ri).response==1
         seq.correct.control(si).repetition(rcorrect) = sequence.control(si).repetition(ri);
         rcorrect = rcorrect + 1;
      else
         seq.incorrect.control(si).repetition(rincorrect) = sequence.control(si).repetition(ri);
         rincorrect = rincorrect + 1;
      end
   end
end

allcatchindex = 1;

rcorrect = 1;
rincorrect = 1;
for ri=1:catchreps
   if markers.catchcontour.repetition(ri).response==1
      seq.correct.catchcontour.repetition(rcorrect) = sequence.catchcontour.repetition(ri);
      rcorrect = rcorrect + 1;
   else
      seq.incorrect.catchcontour.repetition(rincorrect) = sequence.catchcontour.repetition(ri);
      rincorrect = rincorrect + 1;
   end
   seq.correct.allcatch.repetition(allcatchindex) = sequence.catchcontour.repetition(ri);
   allcatchindex = allcatchindex + 1;
end

rcorrect = 1;
rincorrect = 1;
for ri=1:catchreps
   if markers.catchcontrol.repetition(ri).response==1
      seq.correct.catchcontrol.repetition(rcorrect) = sequence.catchcontrol.repetition(ri);
      rcorrect = rcorrect + 1;
   else
      seq.incorrect.catchcontrol.repetition(rincorrect) = sequence.catchcontrol.repetition(ri);
      rincorrect = rincorrect + 1;
   end
   seq.correct.allcatch.repetition(allcatchindex) = sequence.catchcontrol.repetition(ri);
   allcatchindex = allcatchindex + 1;
end

seq.incorrect.allcatch = seq.correct.allcatch;
