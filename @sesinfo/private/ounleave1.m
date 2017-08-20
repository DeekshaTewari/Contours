function sesinfo = unleave1(sesinfo,nfiles)
%SESINFO/UNLEAVE1 Rearrange trial numbers into salience values
%	S = UNLEAVE1(S) takes a SESINFO object S and unleaves the trial
%   sequence into salience values. This function unleaves version 1 
%   of the interleaved sequence.
%
%   Dependencies: None.

index = 1;

for i=1:sesinfo.data.stimsteps
	for j=1:sesinfo.data.stimsets
		for k=1:sesinfo.data.repeats
			sesinfo.data.sequence.contour(i).stimulus(j).repetition(k) ...
				= sesinfo.data.ulsequence(index);
			index = index + 1;
		end
	end
end

for i=1:sesinfo.data.stimsteps
	for j=1:sesinfo.data.stimsets
		for k=1:sesinfo.data.repeats
			sesinfo.data.sequence.control(i).stimulus(j).repetition(k) ...
				= sesinfo.data.ulsequence(index);
			index = index + 1;
		end
	end
end

if sesinfo.data.catchtrials==1
	catchsets = sesinfo.data.stimsets/2;
	for j=1:catchsets
		for k=1:sesinfo.data.repeats
			sesinfo.data.sequence.catchcontour.stimulus(j).repetition(k) ...
				= sesinfo.data.ulsequence(index);
			index = index + 1;
		end
	end
	
	for j=1:catchsets
		for k=1:sesinfo.data.repeats
			sesinfo.data.sequence.catchcontrol.stimulus(j).repetition(k) ...
				= sesinfo.data.ulsequence(index);
			index = index + 1;
		end
	end
else
	sesinfo.data.sequence.catchcontour = [];
	sesinfo.data.sequence.catchcontrol = [];
end

if sesinfo.data.includetuning
	% in version 1, the 0 degree jitter for the control trials are used as
	% a control so the tuning trials start after those control trials, including
	% catch trials
	% first grab the stimuli number where the tuning trials begin
	index = sesinfo.data.stimsets * sesinfo.data.repeats ...
        * (sesinfo.data.stimsteps+1) + 1;
	% so calculate the number of reps for the tuning stimuli
	if sesinfo.data.catchtrials
		tuningreps = sesinfo.data.stimsets * sesinfo.data.stimsteps ...
			/ sesinfo.data.numtuningdir;
	else
		tuningreps = sesinfo.data.stimsets * (sesinfo.data.stimsteps-1) ...
			/ sesinfo.data.numtuningdir;
	end

	for i=1:sesinfo.data.numtuningdir
		for j=1:tuningreps
			for k=1:sesinfo.data.repeats
				sesinfo.data.sequence.tuning(i).stimulus(j).repetition(k) ...
					= sesinfo.data.ulsequence(index);
				index = index + 1;
			end
		end
	end
else
	sesinfo.data.sequence.tuning = [];
end
