function stim_info = ReadIniSequence(ini_fid,stim_info)

% if ini_fid is -1 that means that we should return an empty structure
if ini_fid~=-1
	% check if this is an incomplete session
	% get number of data files
	rawfiles = nptDir('*.0*','CaseInsensitive');
	nrfiles = size(rawfiles,1);
	% check if emptylastfile.txt exists
	if(~isempty(nptDir('emptylasttrial.txt','CaseInsensitive')))
		nrfiles = nrfiles - 1;
	end

    % need to check if the first line is version info since the old format
	% did not include version as the first line
	fieldname = fscanf(ini_fid,'%[^=]',1);
	
	if strcmp(fieldname,'Section Version')
		% get version info
		version = fscanf(ini_fid,'=%i\n',1);
		% read in stimulus sequence
		[stim_seq,count] = fscanf(ini_fid,'%*[^=]=%i\n');
        % index into stim_seq in case this is an incomplete session
        stim_seq = stim_seq(1:nrfiles);
		[stim_order,seq] = sort(stim_seq);
		stim_info.data.ulsequence = seq;
 		% put interleaved sequence back in isequence
		stim_info.data.isequence = stim_seq;
        % change stimsets and numstim to the appropriate values
        % ostimsets = stim_info.data.stimsets;
        % onumstim = stim_info.data.numstim;
        % nstimsets = floor(nrfiles/onumstim*ostimsets);
        % stim_info.data.numstim = nstimsets/ostimsets*onumstim;
        % stim_info.data.stimsets = nstimsets;
		
		% if contour type is interpolated
		if stim_info.data.contourtype==2
			switch version
			case 1
				% this function will fill in stim_info.data.sequence
				stim_info = unleave1(stim_info,nrfiles);
			end		
		else
			% this function will fill in stim_info.data.sequence
			stim_info = unleavePsych(stim_info,nrfiles);
		end
	else
		% read in first stimulus number
		s1 = fscanf(ini_fid,'=%i\n',1);
		% read in stimulus sequence
		[stim_seq,count] = fscanf(ini_fid,'%*[^=]=%i\n');
		stim_seq = [s1; stim_seq];
        % index into stim_seq in case this is an incomplete session
        stim_seq = stim_seq(1:nrfiles);
		[stim_order,seq] = sort(stim_seq);
		stim_info.data.ulsequence = seq;
		% put interleaved sequence back in isequence
		stim_info.data.isequence = stim_seq;
		
		% if contour type is interpolated
		if stim_info.data.contourtype==2
			% set up structure used by other functions
			% this function will fill in stim_info.data.sequence
			stim_info = unleave(stim_info,nrfiles);
		else
			% this function will fill in stim_info.data.sequence
			stim_info = unleavePsych(stim_info,nrfiles);
		end
	end
end