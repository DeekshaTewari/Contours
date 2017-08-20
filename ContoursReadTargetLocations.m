function targets = ContoursReadTargetLocations(filename)
%ContoursReadTargetLocations Reads target locations from binary stimulus file
%   TARGETS = ContoursReadTargetLocations(FILENAME) returns the 
%   target locations for all stimuli contained in FILENAME. TARGETS 
%   is a matrix with the following entries for each stimulus contained
%   in a row:
%      TARGET(n,1) - left coordinate
%      TARGET(n,2) - top coordinate
%      TARGET(n,3) - right coordinate
%      TARGET(n,4) - bottom coordinate
%
%   Dependencies: None.

fid = fopen(filename,'r','ieee-le');
ts = [];

% buffer(1) corresponds to index of stimulus
% buffer(2) is the number of gabors in each stimulus
buffer = fread(fid,2,'int32');
while ~isempty(buffer)
	% start reading from here for coordinates of target window
	% coordinates are in the order: left, top, right, bottom
	ts = [ts fread(fid,4,'int32')];
	% skip to the start of the next stimulus, which is  4 int32's + number of gabors * 12 bytes
	% (2 int32's and 1 float32)
	fseek(fid,buffer(2)*12,'cof');
	buffer = fread(fid,2,'int32');
end

fclose(fid);

% transpose the matrix so that target coordinates are stored in rows
targets = transpose(ts);
