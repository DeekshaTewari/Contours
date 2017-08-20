function target = GetTargetLocation(filename,stimulus_index)
% stimulus_index is 0 based

fid = fopen(filename,'r','ieee-le');

% buffer(1) corresponds to index of stimulus
% buffer(2) is the number of gabors in each stimulus
buffer = fread(fid,2,'int32');

while buffer(1)~=stimulus_index,
	% skip to the start of the next stimulus, which is  4 int32's + number of gabors * 12 bytes
	% (2 int32's and 1 float32)
	fseek(fid,16+buffer(2)*12,'cof');
	buffer = fread(fid,2,'int32');
end

% start reading from here for coordinates of target window
target = fread(fid,4,'int32');

fclose(fid);