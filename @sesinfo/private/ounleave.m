function sesinfo = unleave(sesinfo)
%SESINFO/UNLEAVE Rearrange trial numbers into salience values
%	S = UNLEAVE(S) takes a SESINFO object S and unleaves the trial
%   sequence into salience values.
%
%   Dependencies: None.

index = 1;

for i=1:sesinfo.data.stimsteps
	for j=1:sesinfo.data.stimsets
		sesinfo.data.sequence.contour(i).stimulus(j).repetition(1) = sesinfo.data.ulsequence(index);
		index = index + 1;
	end
end

for i=1:sesinfo.data.stimsteps
	for j=1:sesinfo.data.stimsets
		sesinfo.data.sequence.control(i).stimulus(j).repetition(1) = sesinfo.data.ulsequence(index);
		index = index + 1;
	end
end

if sesinfo.data.catchtrials==1
	catchsets = sesinfo.data.stimsets/2;
	for j=1:catchsets
		sesinfo.data.sequence.catchcontour.stimulus(j).repetition(1) = sesinfo.data.ulsequence(index);
		index = index + 1;
	end
	
	for j=1:catchsets
		sesinfo.data.sequence.catchcontrol.stimulus(j).repetition(1) = sesinfo.data.ulsequence(index);
		index = index + 1;
	end
else
	sesinfo.data.sequence.catchcontour = [];
	sesinfo.data.sequence.catchcontrol = [];
end

if sesinfo.data.includetuning
	% the tuning trials in this version are all in the control trials
	% first grab the stimuli number where the tuning trials begin
	index = sesinfo.data.stimsets * sesinfo.data.stimsteps;
	% so calculate the number of reps for the tuning stimuli
	tuningreps = index / sesinfo.data.numtuningdir;
	for i=1:sesinfo.data.numtuningdir
		for j=1:tuningreps
			sesinfo.data.sequence.tuning(i).stimulus(j).repetition(1) = sesinfo.data.ulsequence(index);
			index = index + 1;
		end
	end
else
	sesinfo.data.sequence.tuning = [];
end
