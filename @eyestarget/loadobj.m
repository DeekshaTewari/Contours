function b = loadobj(a)
%@eyestarget/loadobj Modifies object during load

cwd = '';

if isa(a,'eyestarget')
	b = a;
else
	% a is an old version so convert to new structure
	% copy the fields of the structure in order
	c.targets = a.targets;
	c.tmarkers = a.tmarkers;
	c.onsets = a.onsets;
	% try to find sampling rate
	% first look to see if timing.mat is in the present directory
	% since that is usually stored with the raw streamer files
    d = nptDir('*timing.mat','CaseInsensitive');
    if(isempty(d))
		% check parent directory
        cwd = pwd;
        cd ..
	end
	% check if there is a .0001 file present
    d = nptDir('*.0001','CaseInsensitive');
    if(~isempty(d))
		[data,nc,sr] = nptReadStreamerFile(d(1).name);
	else
		fprintf('Warning: Could not find *.0001 file!\n');
		fprintf('Warning: Using 30000 as sampling rate.\n');
		sr = 30000;
	end
    if(~isempty(cwd))
        cd(cwd)
    end
	srms = sr/1000;
	c.onsetsMS = (a.onsets-1)/srms;
	% copy the rest of the fields in order
	c.results = a.results;
	c.mresults = a.mresults;
	c.rt = a.rt;
	c.markers = a.markers;
	b = class(c,'eyestarget',a.sesinfo,a.eyes);
end
