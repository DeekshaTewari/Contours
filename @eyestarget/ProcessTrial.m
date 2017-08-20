function [obj,res] = ProcessTrial(obj,n,varargin)
%EYESTARGET/ProcessTrial Process trial data
%   ProcessTrial(OBJ,TRIAL) performs computations specific to EYESTARGET.
%
%	Dependencies: None.

% target = obj.targets(obj.sesinfo.isequence(n)+1,:);
target = obj.targets(n,:);
% get the eye data
[data,points] = get(obj.eyes,'DataPixels',n);

% get the stimulus onset in index number. et.onsets corresponds to datapoint
% at 30 kHz so should correspond to et.onsets(n)/30 at 1 kHz. 
% e.g. say Presenter trigger occurred at data point 15159. At 30 kHz
% that is (15159-1)/30 = 505.27 ms since data point 1 is 0 ms. Since we
% are working at 1 ms resolution, and since data point 1 is 0 ms, 505 ms
% corresponds to index 506
% onsetTime = round((obj.onsets(n)-1)/30);
onsetTime = round(obj.onsetsMS(n));
onsetIndex = onsetTime + 1;

% get match limit
ml = obj.sesinfo.matchlimit;

if(nargin>2)
	SacData = varargin{1};
	% only keep saccades with start indices after stimulus onset
	onsetSaccades = find(SacData.start>onsetIndex);
	% subtract onset index from saccade indices to more easily calculate
	% reaction times
    % take the transpose so that different saccades are in different
    % columns
	SaccadeData = [SacData.start(onsetSaccades)'; ...
		SacData.finish(onsetSaccades)'] - onsetIndex;
else
	SaccadeData = nan;
end

% pass the relevant data to function to compute result and timing
[result,markers,rt] = ContoursTrialResultTiming(data(:,onsetIndex:points),...
						target,ml-obj.sesinfo.etfix,ml,SaccadeData);

% get the result according to the markers for this trial
if (isempty(obj.tmarkers))
	% if there was no marker file for this session
	% return -1 and skip updating mresults field
	mres = -1;
else
	mres = obj.tmarkers(n).response;
	obj.mresults(n,1) = mres;
end

% store returned values in object
% store results in column to make it easier to read
obj.results(n,1) = result;
obj.rt(n,1) = rt;
obj.markers{n} = markers;

res = {result,mres,rt,markers};
