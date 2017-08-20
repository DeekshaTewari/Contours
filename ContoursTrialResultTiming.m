function [result,markers,rt] = ContoursTrialResultTiming(data,target,varargin)
%ContoursTrialResultTiming Compute result and reaction time for each trial 
%   [RESULT,MARKERS,RT] = ContoursTrialResultTiming(DATA,TARGET)
%   returns the result of the trial as well as the markers and reaction 
%   times. RESULT may be:
%       0 - no saccades
%       1 - single saccade to target window within MATCH_TIME (default is
%           300 ms)
%       2 - multiple saccades all within target window with first saccade
%           within MATCH_TIME
%      -1 - single saccade to any other location other than target window
%      -2 - single saccade to target window but not within MATCH_TIME
%      -3 - multiple saccades all within target window but first saccade
%           was not within MATCH_TIME
%      -4 - multiple saccades with at least one saccade to a location
%           outside the target window
%   MARKERS contain the following markers and the corresponding datapoints
%      983040	Out of target
%      983041   In target
%      983042   Fixated
%      983044   Timed out
%   RT is set to the time of the first saccade except when there were no
%   saccades, in which case, it is set to -1.
%
%   [RESULT,MARKERS,RT] = ContoursTrialResultTiming(DATA,TARGET,
%   MATCH_TIME,MATCH_LIMIT), with the optional input arguments 
%   MATCH_TIME and MATCH_LIMIT, allows different values to be used to
%   determine the result of the trial. 
%
%   Dependencies: nptThresholdCrossings.

% marker numbers and their representations
OutTarget = 983040;
InTarget = 983041;
Fixated = 983042;
TimedOut = 983044;

% default values
MatchTime = 301;
MatchLimit = 600;
Matched = 299;
rt = -1;
SaccadeData = nan;

% add 1 to MATCH_TIME so we can just use < instead of <=
if nargin == 3
	MatchTime = varargin{1} + 1;
	Matched = varargin{1} - 1;
elseif nargin == 4
	MatchTime = varargin{1} + 1;
	Matched = varargin{1} - 1;
	MatchLimit = varargin{2};
elseif nargin == 5
	MatchTime = varargin{1} + 1;
	Matched = varargin{1} - 1;
	MatchLimit = varargin{2};
	SaccadeData = varargin{3};
	SaccadeStart = 1;
	SaccadeFinish = 2;
end

v = data(1,:);
h = data(2,:);

wasIn = 0;
markers = [];
mSize = 0;

if(~isnan(SaccadeData))
    % only compute reaction times if there were valid saccades
    % we are going to use the end of the saccade to check if we are in
    % target but we are going to use the start of the saccade as the
    % reaction time so the marker time will be the start of the saccade
    % instead of the end of the saccade. This might be more accurate
    % since the start of the saccade is when the stimulus is no longer
    % stimulating the receptive field. After the target has been 
    % entered, if there are additional saccades that end up outside the 
    % target window, the start time of those saccades will be recorded.
    % Otherwise, saccades that end up staying within the target (e.g.
    % microsaccades) will not be recorded.
    
    ncols = size(SaccadeData,2);
    if(ncols==0)
    	% there were no saccades
    	% by default rt = -1, markers = []
    	result = 0;
    elseif(ncols<2)
    	% there was only one saccade
        findex = 1;
        % get index at the beginning of the saccade
		rt = SaccadeData(SaccadeStart,findex);
		% get index at the end of the saccade
		seIndex = SaccadeData(SaccadeFinish,findex);
		% get h and v positions at end of saccade
		sePosH = h(seIndex);
		sePosV = v(seIndex);
		% is eye position at the end of the saccade inside target
		if( (sePosV>target(2)) & (sePosV<target(4)) ...
		  & (sePosH>target(1)) & (sePosH<target(3)) )
		  	if(rt < MatchTime)
		  		markers = [InTarget rt; Fixated (rt+Matched)];
		  		% correct trial with one saccade
		  		result = 1;
		  	else
				markers = [InTarget rt; TimedOut MatchLimit];
				% late saccade to target
				result = -2;
			end
		else
			% not inside target at end of saccade
			markers = [OutTarget rt; TimedOut MatchLimit];
			% saccade to incorrect target
			result = -1;
		end
	else
		% there was more than one saccade
		% set the rt to the start of the first saccade
		rt = SaccadeData(SaccadeStart,1);
		for findex = 1:ncols
			% get index at the beginning of the saccade
			ssIndex = SaccadeData(SaccadeStart,findex);
			% get index at the end of the saccade
			seIndex = SaccadeData(SaccadeFinish,findex);
			% get h and v positions at end of saccade
			sePosH = h(seIndex);
			sePosV = v(seIndex);
			% is eye position at the end of the saccade inside target
			if( (sePosV>target(2)) & (sePosV<target(4)) ...
			  & (sePosH>target(1)) & (sePosH<target(3)) )
				wasIn = 1;
			else  
				% set wasIn to 0 in case we were in target window before
				wasIn = 0;
			  	break;
			end
		end
		if(wasIn)
			% all saccades were within target so result could be 1 
			% if the start of the first saccade was within Matchtime
			if(rt < MatchTime)
				% all saccades within target and 1st saccade < MatchTime
				result = 2;
			else
				% all saccades within target but 1st saccade > MatchTime
				result = -3;
			end
		else
			% at least one saccade was outside target
			result = -4;
		end
	end
else % if(~isnan(SaccadeData))
	v1 = nptThresholdCrossings(v,target(2));
	v2 = nptThresholdCrossings(v,target(4));
	
	h1 = nptThresholdCrossings(h,target(1));
	h2 = nptThresholdCrossings(h,target(3));


	% get all crossings and identify unique events
	crossings = [v1 v2 h1 h2];
	uc = unique(crossings);

	% check each event to see what it corresponds to
	ucl = length(uc);
	for i = 1:ucl
		xpoint = uc(i);
		% skip if event time was 1
		if xpoint ~= 1
			% check to see if point is within target
			if ((v(xpoint)>target(2)) & (v(xpoint)<target(4)) ...
				& (h(xpoint)>target(1)) & (h(xpoint)<target(3)))
				markers = [markers;InTarget xpoint];
				wasIn = 1;
				mSize = mSize + 1;
			else
				% point is outside target
				if wasIn == 1
					% check for condition that animal already satisfied
					% fixation criteria. If so, break out of for loop
					% since the trial should have ended at that point
					if (xpoint - markers(mSize,2)) >= Matched
						break;
					else
						markers = [markers;OutTarget xpoint];
						mSize = mSize + 1;
						wasIn = 0;
					end
				end
			end % if end of saccade is inside target
		end % if xpoint ~= 1
	end % for i = 1:ucl

	if isempty(markers)
		% if there were no markers, then target window was never entered
		% so return timed out as the only marker
		markers = [TimedOut MatchLimit];
		result = 0;
	elseif markers(mSize,1) == InTarget
		% if the last event was InTarget, we have to check to see if criteria
		% was satisfied
		etime = markers(mSize,2);
		% since there might be trials that are missing data at the end
		% (i.e. trials with missing end triggers), we will just check to
		% make sure that the time of entry was less than MatchTime since
		% if the eye position was in before that time, it should be a 
		% successful trial
		if etime < MatchTime
			markers = [markers;Fixated (etime+Matched)];
			rt = etime;
			result = 1;
		else
			markers = [markers;TimedOut MatchLimit];
			result = 0;
		end
	else % if isempty(markers)
		% last marker was OutTarget, which means that we should add TimedOut
		% as the last marker
		markers = [markers;TimedOut MatchLimit];
		result = 0;
	end % if isempty(markers)
end % if(~isempty(SaccadeData))
