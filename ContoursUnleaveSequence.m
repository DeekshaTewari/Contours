function seq = ContoursUnleaveSequence(sesinfo)
%ContoursUnleaveSequence	Converts trial sequence into stimulus conditions
%	SEQ = ContoursUnleaveSequence(SESINFO) converts the stimulus
%	trial sequence (SESINFO returned from ContoursReadIniFile) 
%	into the stimlus conditions used in the experiment. 
%	SEQ has the following format:
%		SEQ.contour(i).repetition(j)
%		SEQ.control(i).repetition(j)
%		SEQ.catchcontour.repetition(j)
%		SEQ.catchcontrol.repetition(j)
%
%	Dependencies: None.

seq.session = sesinfo.session;

index = 1;
% get trial numbers for neural target
for i=1:sesinfo.stim_steps
	for j=1:sesinfo.stimsets
		seq.contour(i).repetition(j) = sesinfo.sequence(index);
		index = index + 1;
	end
end

% get trial numbers for control target
for i=1:sesinfo.stim_steps
	for j=1:sesinfo.stimsets
		seq.control(i).repetition(j) = sesinfo.sequence(index);
		index = index + 1;
	end
end

% check to make sure there are catch trials before proceeding
if sesinfo.catchtrials==1
	catchsets = sesinfo.stimsets/2;
	% get trial numbers for catch trials at contour target position
	for j=1:catchsets
		seq.catchcontour.repetition(j) = sesinfo.sequence(index);
		index = index + 1;
	end
	
	% get trial numbers for catch trials at control target position
	for j=1:catchsets
		seq.catchcontrol.repetition(j) = sesinfo.sequence(index);
		index = index + 1;
	end
end
