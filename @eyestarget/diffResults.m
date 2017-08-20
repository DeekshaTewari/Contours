function diffResults(obj)
%EYESTARGET/diffResults Returns trials with differences in result using 
%      markers vesus eyes
%   diffResults(OBJ) returns the trial numbers of trials with different
%   results when analyzed using the marker files versus using the eye
%   files.

% get length of results and mresults
rl = length(obj.results);
mrl = length(obj.mresults);

if (rl==mrl)
	d = find(obj.results~=obj.mresults);
	fprintf('Trials with different results:\n');
	fprintf('%d\n',d);
else
	fprintf('Size mismatch in results returned from markers (%d) and eyes (%d)!\n',mrl,rl);
end
