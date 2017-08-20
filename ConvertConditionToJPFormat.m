function ConvertConditionToJPFormat(filename,startchan,endchan,seq,target,condition)
%ConvertConditionToJPFormat		Convert stimulus condition to JP's format
%	ConvertConditionToJPFormat(FILENAME,START_CHAN,END_CHAN,SEQ,
%	TARGET,CONDITION)
%		e.g. ConvertConditionToJPFormat('annie060801s03contour1.bin',
%				3,4,seq,'contour',1)
%		or ConvertConditionToJPFormat('annie060801s03catch.bin',3,4,
%				seq,'catch',0)

% get max duration
[duration,min_duration,trials,waves,rawfile,samplingrate] = nptReadSorterHdr(['sort' filesep '0001.hdr']);

% open binary file 
fid = fopen(filename,'w','ieee-le');

if strcmp(target,'contour')
	offset = (condition-1)*seq.stimsets;
elseif strcmp(target,'control')
	offset = (seq.stim_steps+condition-1) * seq.stimsets;
elseif strcmp(target,'catch')
	offset = 2 * seq.stim_steps * seq.stimsets;
end

% get session name
dirlist = nptDir('*.0001');
[path,filename,ext] = nptFileParts(dirlist(1).name);
% trialname = ext(2:length(ext));

% pad data if necessary 
maxpoints = ceil(duration * samplingrate);

channels = endchan - startchan + 1;

for i = 1:seq.stimsets
	trialname = [filename '.' num2str(seq.sequence(offset+i),'%04i')];
	fprintf('Reading %s...\n',trialname);
	[data,numchannels,samplingrate,scanorder,points] = nptReadStreamerFile(trialname);
	
	padpoints = maxpoints-points;
	if padpoints~=0
		% pzeros = zeros(1,padpoints);
		pdata = transpose([data(startchan:endchan,:) zeros(channels,padpoints)]);
	else
		pdata = transpose(data(startchan:endchan,:));
	end
	
	fwrite(fid,pdata,'int16');
end

fclose(fid);
