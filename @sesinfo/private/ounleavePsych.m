function sesinfo = unleavePsych(sesinfo)
%SESINFO/unleavePsych Rearrange trial numbers into salience values
%	S = unleavePsych(S) takes a SESINFO object S and unleaves the trial
%   sequence into salience values used in closed and open contour types.
%
%   Dependencies: None.

index = 1;

for i=1:sesinfo.data.stimsteps
	for j=1:sesinfo.data.stimsets
		for k=1:sesinfo.data.repeats
			sesinfo.data.sequence.contour(i).stimulus(j).repetition(k) = sesinfo.data.ulsequence(index);
         index = index + 1;
      end
	end
end

sesinfo.data.sequence.control = [];

if sesinfo.data.catchtrials==1
	for j=1:sesinfo.data.stimsets
		for k=1:sesinfo.data.repeats
			sesinfo.data.sequence.catchcontour.stimulus(j).repetition(k) = sesinfo.data.ulsequence(index);
         index = index + 1;
      end
	end
else
	sesinfo.data.sequence.catchcontour = [];
end

sesinfo.data.sequence.catchcontrol = [];

sesinfo.data.sequence.tuning = [];
