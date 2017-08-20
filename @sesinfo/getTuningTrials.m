function [optimal,tuning,stepsize] = getTuningTrials(obj)
%@sesinfo/getTuningTrials Return trial numbers for tuning stimuli
%   [OPTIMAL,TUNING,ORI] = getTuningTrials(OBJ) returns the trial 
%   numbers necessary to compute the orientation tuning curves.
%   OPTIMAL contains the trial numbers for the optimal orientation as 
%   defined in the receptive field. TUNING contains the trial numbers 
%   corresponding to each tuning stimuli in columns. The columns are
%   arranged in increasing angle, with the optimal orientation removed
%   from the center of of the matrix. For example, if there were 8
%   tuning directions with a step size of 15 degrees, the columns will
%   be arranged in the following order:
%      [-60 -45 -30 -15 15 30 45 60]
%   ORI returns the relative orientations with 0 being the optimal
%   orientation in the middle of the row vector.

if(obj.data.includetuning)
    % get tuning trials
    tuning = obj.data.sequence.tuning;
    % get trials corresponding to optimal orientation with random
    % orientations in the surround
    optimal = obj.data.sequence.control(:,1);
    
	% return the step size for the tuning stimuli
	halfntune = obj.data.numtuningdir/2;
	stepsize = (-halfntune:halfntune) * obj.data.tuningstepsize;
else
	% no tuning stimuli in this session so return empty vectors
	tuning = [];
	optimal = [];
	stepsize = [];
end
