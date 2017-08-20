function stim_info = ContoursReadIniFile(filename)
%ContoursReadIniFile	Reads INI file for contour experiments.
%	STIM_INFO = ContoursReadIniFile(FILENAME) parses the ini 
%	file FILENAME and stores information about the
%	session in a structure.
%
%	Dependencies: None.

% if argument is zero, we want to create an empty structure

if isempty(filename)
	stim_info.data.sessionname = '';
	stim_info.data.presenterversion = '';
	stim_info.data.width = 0;
	stim_info.data.height = 0;
	
	% pass -1 as ini_fid in order to get an empty structure
	% in place of the Gabor and Timing sections
	ini_fid = -1;
	stim_info = ReadIniGabor(ini_fid,stim_info);
	stim_info = ReadIniTiming(ini_fid,stim_info);	
	stim_info = ReadIniSequence(ini_fid,stim_info);
else
	[path,session,ext] = nptFileParts(filename);

	stim_info.data.sessionname = session;
	
	% open ini file
	ini_fid = fopen(filename,'rt','ieee-le');
	
	% skip [SESSION INFO]
	fgetl(ini_fid);
	% read presenter version if it is there
	fieldname = fscanf(ini_fid,'%[^=]',1);
	if strcmp(fieldname,'Presenter Version')
		% read version number
		stim_info.data.presenterversion = fscanf(ini_fid,'=%s\n',1);

		% skip Date so we will be at the same point in the ini file if the 
		% fieldname was not PresenterVersion
		fgetl(ini_fid);
	else
		stim_info.data.presenterversion = '';
		fscanf(ini_fid,'=%*s\n',1);
	end
		
	% skip Time	
	fgetl(ini_fid);
	
	% get screen dimensions
	[screen,count] = fscanf(ini_fid,'%*[^=]=%i\n',2);
	stim_info.data.width = screen(1);
	stim_info.data.height = screen(2);
	
	% skip [RECEPTIVE FIELDS INFO]
	% and skip to the end of the title of the next section
	fscanf(ini_fid,'%*[^]]%s\n',2);
	
	% use ReadIniGabor to read Gabor section
	stim_info = ReadIniGabor(ini_fid,stim_info);

	% skip [TIMING INFO]
	fgetl(ini_fid);
	% use ReadIniTiming to read Timing section
	stim_info = ReadIniTiming(ini_fid,stim_info);
		
	% skip [STIMULUS SEQUENCE]
	fgetl(ini_fid);
	% call ReadIniSequence to read Sequence section
	stim_info = ReadIniSequence(ini_fid,stim_info);

	fclose(ini_fid);
end