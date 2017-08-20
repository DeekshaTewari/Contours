function result = unleave(markers,sesinfo)
%MARKERS/UNLEAVE Rearrange markers into salience values
%	R = UNLEAVE(MARKERS,SES_INFO)

for i=1:sesinfo.stim_steps
	for j=1:sesinfo.stim_sets
		for k=1:sesinfo.repeats
			result.contour(i).stimulus(j).repetition(k) = ...
				markers(sesinfo.sequence.contour(i).stimulus(j).repetition(k));
		end
	end
end

% check to make sure we are not processing psychophysical stimuli which 
% do not have control trials
if ~isempty(sesinfo.sequence.control)
    for i=1:sesinfo.stim_steps
        for j=1:sesinfo.stim_sets
            for k=1:sesinfo.repeats
                result.control(i).stimulus(j).repetition(k) = ...
                    markers(sesinfo.sequence.control(i).stimulus(j).repetition(k));
            end
        end
    end
else
    result.control = [];
end
    
if sesinfo.catch_trials==1
	catchsets = sesinfo.stim_sets/2;
	for j=1:catchsets
		for k=1:sesinfo.repeats
			result.catchcontour.stimulus(j).repetition(k) = ...
				markers(sesinfo.sequence.catchcontour.stimulus(j).repetition(k));
		end
	end
	
    % check to make sure we are not processing psychophysical stimuli which 
    % do not have control trials
    if ~isempty(sesinfo.sequence.catchcontrol)
        for j=1:catchsets
            for k=1:sesinfo.repeats
                result.catchcontrol.stimulus(j).repetition(k) = ...
                    markers(sesinfo.sequence.catchcontrol.stimulus(j).repetition(k));
            end
        end
    else
        result.catchcontrol = [];
    end
else
	result.catchcontour = [];
	result.catchcontrol = [];
end
