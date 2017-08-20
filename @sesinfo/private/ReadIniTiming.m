function stim_info = ReadIniTiming(ini_fid,stim_info)

% if ini_fid is -1 that means that we should return an empty structure
if ini_fid~=-1
	% need to check if the first line is version info since the old format
	% has paradigm as the first line instead of version
	% cannot read both fieldname and value since one is str and the other
	% is integer
	fieldname = fscanf(ini_fid,'%[^=]',1);
	
	if strcmp(fieldname,'Section Version')
		% read version number
		version = fscanf(ini_fid,'=%i\n',1);
		switch version
		case 1
			% get all parameters from ini file
			[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',35);
		
			i = 1;
			stim_info.data.iti = stim_array(i); i = i + 1;
			stim_info.data.itimax = stim_array(i); i = i + 1;
			stim_info.data.riti = stim_array(i); i = i + 1;
			stim_info.data.audio = stim_array(i); i = i + 1;
			stim_info.data.fixlimit = stim_array(i); i = i + 1;
			stim_info.data.cuelat = stim_array(i); i = i + 1;
			stim_info.data.cuelatmax = stim_array(i); i = i + 1;
			stim_info.data.rcuelat = stim_array(i); i = i + 1;
			stim_info.data.cuedur = stim_array(i); i = i + 1;
			stim_info.data.cuedurmax = stim_array(i); i = i + 1;
			stim_info.data.rcuedur = stim_array(i); i = i + 1;
			stim_info.data.postcuedur = stim_array(i); i = i + 1;
			stim_info.data.postcuedurmax = stim_array(i); i = i + 1;
			stim_info.data.rpostcuedur = stim_array(i); i = i + 1;
			stim_info.data.stimlat = stim_array(i); i = i + 1;
			stim_info.data.stimlatmax = stim_array(i); i = i + 1;
			stim_info.data.rstimlat = stim_array(i); i = i + 1;
			stim_info.data.stimdur = stim_array(i); i = i + 1;
			stim_info.data.stimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rstimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rpoststimdur = stim_array(i); i = i + 1;
			stim_info.data.matchlat = stim_array(i); i = i + 1;
			stim_info.data.matchlatmax = stim_array(i); i = i + 1;
			stim_info.data.rmatchlat = stim_array(i); i = i + 1;
			stim_info.data.matchlimit = stim_array(i); i = i + 1;
			stim_info.data.reward = stim_array(i); i = i + 1;
			stim_info.data.rewardmax = stim_array(i); i = i + 1;
			stim_info.data.rreward = stim_array(i); i = i + 1;
			stim_info.data.penalty = stim_array(i); i = i + 1;
			stim_info.data.penaltymax = stim_array(i); i = i + 1;
			stim_info.data.rpenalty = stim_array(i); i = i + 1;
			stim_info.data.etfix = stim_array(i); i = i + 1;
			stim_info.data.etstray = stim_array(i); i = i + 1;
		case 2
			% get all parameters from ini file
			[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',38);
		
			i = 1;
			stim_info.data.iti = stim_array(i); i = i + 1;
			stim_info.data.itimax = stim_array(i); i = i + 1;
			stim_info.data.riti = stim_array(i); i = i + 1;
			stim_info.data.audio = stim_array(i); i = i + 1;
			stim_info.data.fixlimit = stim_array(i); i = i + 1;
			stim_info.data.cuelat = stim_array(i); i = i + 1;
			stim_info.data.cuelatmax = stim_array(i); i = i + 1;
			stim_info.data.rcuelat = stim_array(i); i = i + 1;
			stim_info.data.cuedur = stim_array(i); i = i + 1;
			stim_info.data.cuedurmax = stim_array(i); i = i + 1;
			stim_info.data.rcuedur = stim_array(i); i = i + 1;
			stim_info.data.postcuedur = stim_array(i); i = i + 1;
			stim_info.data.postcuedurmax = stim_array(i); i = i + 1;
			stim_info.data.rpostcuedur = stim_array(i); i = i + 1;
			stim_info.data.stimlat = stim_array(i); i = i + 1;
			stim_info.data.stimlatmax = stim_array(i); i = i + 1;
			stim_info.data.rstimlat = stim_array(i); i = i + 1;
			stim_info.data.stimdur = stim_array(i); i = i + 1;
			stim_info.data.stimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rstimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rpoststimdur = stim_array(i); i = i + 1;
			stim_info.data.matchlat = stim_array(i); i = i + 1;
			stim_info.data.matchlatmax = stim_array(i); i = i + 1;
			stim_info.data.rmatchlat = stim_array(i); i = i + 1;
			stim_info.data.matchlimit = stim_array(i); i = i + 1;
			stim_info.data.reward = stim_array(i); i = i + 1;
			stim_info.data.rewardmax = stim_array(i); i = i + 1;
			stim_info.data.rreward = stim_array(i); i = i + 1;
			stim_info.data.penalty = stim_array(i); i = i + 1;
			stim_info.data.penaltymax = stim_array(i); i = i + 1;
			stim_info.data.rpenalty = stim_array(i); i = i + 1;
			stim_info.data.incorpenalty = stim_array(i); i = i + 1;
			stim_info.data.incorpenaltymax = stim_array(i); i = i + 1;
			stim_info.data.rincorpenalty = stim_array(i); i = i + 1;
			stim_info.data.etfix = stim_array(i); i = i + 1;
			stim_info.data.etstray = stim_array(i); i = i + 1;
		end
	elseif strcmp(fieldname,'Paradigm')
		% read paradigm number
		paradigm = fscanf(ini_fid,'=%i\n',1);
		switch paradigm
		case 0 % fixation paradigm
			% get all parameters from ini file
			[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',22);
		
			i = 1;
			stim_info.data.iti = stim_array(i); i = i + 1;
			stim_info.data.itimax = stim_array(i); i = i + 1;
			stim_info.data.riti = stim_array(i); i = i + 1;
			stim_info.data.audio = stim_array(i); i = i + 1;
			stim_info.data.fixlimit = stim_array(i); i = i + 1;
			stim_info.data.cuelat = 0;
			stim_info.data.cuelatmax = 0;
			stim_info.data.rcuelat = 0;
			stim_info.data.cuedur = 0;
			stim_info.data.cuedurmax = 0;
			stim_info.data.rcuedur = 0;
			stim_info.data.postcuedur = 0;
			stim_info.data.postcuedurmax = 0;
			stim_info.data.rpostcuedur = 0;
			stim_info.data.stimlat = stim_array(i); i = i + 1;
			stim_info.data.stimlatmax = stim_array(i); i = i + 1;
			stim_info.data.rstimlat = stim_array(i); i = i + 1;
			stim_info.data.stimdur = stim_array(i); i = i + 1;
			stim_info.data.stimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rstimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rpoststimdur = stim_array(i); i = i + 1;
			stim_info.data.matchlat = 0;
			stim_info.data.matchlatmax = 0;
			stim_info.data.rmatchlat = 0;
			stim_info.data.matchlimit = 0;
			stim_info.data.reward = stim_array(i); i = i + 1;
			stim_info.data.rewardmax = stim_array(i); i = i + 1;
			stim_info.data.rreward = stim_array(i); i = i + 1;
			stim_info.data.penalty = stim_array(i); i = i + 1;
			stim_info.data.penaltymax = stim_array(i); i = i + 1;
			stim_info.data.rpenalty = stim_array(i); i = i + 1;
			stim_info.data.etfix = stim_array(i); i = i + 1;
			stim_info.data.etstray = stim_array(i); i = i + 1;
		case 3 % detection paradigm
			% get all parameters from ini file
			[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',20);
		
			i = 1;
			stim_info.data.iti = stim_array(i); i = i + 1;
			stim_info.data.itimax = stim_array(i); i = i + 1;
			stim_info.data.riti = stim_array(i); i = i + 1;
			stim_info.data.audio = stim_array(i); i = i + 1;
			stim_info.data.fixlimit = stim_array(i); i = i + 1;
			stim_info.data.cuelat = 0;
			stim_info.data.cuelatmax = 0;
			stim_info.data.rcuelat = 0;
			stim_info.data.cuedur = 0;
			stim_info.data.cuedurmax = 0;
			stim_info.data.rcuedur = 0;
			stim_info.data.postcuedur = 0;
			stim_info.data.postcuedurmax = 0;
			stim_info.data.rpostcuedur = 0;
			stim_info.data.stimlat = stim_array(i); i = i + 1;
			stim_info.data.stimlatmax = stim_array(i); i = i + 1;
			stim_info.data.rstimlat = stim_array(i); i = i + 1;
			stim_info.data.stimdur = stim_array(i); i = i + 1;
			stim_info.data.stimdurmax = stim_array(i); i = i + 1;
			stim_info.data.rstimdur = stim_array(i); i = i + 1;
			stim_info.data.poststimdur = 0;
			stim_info.data.poststimdurmax = 0;
			stim_info.data.rpoststimdur = 0;
			stim_info.data.matchlat = 0;
			stim_info.data.matchlatmax = 0;
			stim_info.data.rmatchlat = 0;
			stim_info.data.matchlimit = stim_array(i); i = i + 1;
			stim_info.data.reward = stim_array(i); i = i + 1;
			stim_info.data.rewardmax = stim_array(i); i = i + 1;
			stim_info.data.rreward = stim_array(i); i = i + 1;
			stim_info.data.penalty = stim_array(i); i = i + 1;
			stim_info.data.penaltymax = stim_array(i); i = i + 1;
			stim_info.data.rpenalty = stim_array(i); i = i + 1;
			stim_info.data.etfix = stim_array(i); i = i + 1;
			stim_info.data.etstray = stim_array(i); i = i + 1;
		end
	end
end