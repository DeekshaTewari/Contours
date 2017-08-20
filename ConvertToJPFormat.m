function ConvertToJPFormat(filename,startchan,endchan)

% get max duration
duration = nptReadSorterHdr(['sort' filesep '0001.hdr']);

% open binary file 
fid = fopen(filename,'w','ieee-le');

dirlist = dir('*.0*');
trials = size(dirlist,1);

for i = 1:trials
	% [path,filename,ext] = nptFileParts(dirlist(i).name);
	% trialname = ext(2:length(ext));
	fprintf('Reading %s...\n',dirlist(i).name);
	[data,numchannels,samplingrate,scanorder,points] = nptReadStreamerFile(dirlist(i).name);
	
	% pad data if necessary
	maxpoints = duration * samplingrate;
	padpoints = maxpoints-points;
	if padpoints~=0
		% pzeros = zeros(1,padpoints);
		channels = endchan - startchan + 1;
		pdata = transpose([data(startchan:endchan,:) zeros(channels,padpoints)]);
	else
		pdata = transpose(data(startchan:endchan,:));
	end
	
	fwrite(fid,pdata,'int16');
end

fclose(fid);
