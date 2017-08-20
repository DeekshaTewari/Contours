function stim_info = ContoursReadIniFile(session)
%ContoursReadIniFile	Reads INI file for contour experiments.
%	STIM_INFO = ContoursReadIniFile(SESSIONNAME) parses the ini 
%	file SESSIONNAME.ini and stores information about the
%	session in a structure.
%
%	Dependencies: None.

% open ini file
ini_fid = fopen([session '.INI'],'rt','ieee-le');

% skip [SESSION INFO]
% skip Date
% skip Time
for i = 1:3,
   fgetl(ini_fid);
end

stim_info.session = session;

% get screen dimensions
[screen,count] = fscanf(ini_fid,'%*[^=]=%i\n',2);
stim_info.width = screen(1);
stim_info.height = screen(2);

% skip [RECEPTIVE FIELDS INFO]
% and skip to the end of the title of the next section
fscanf(ini_fid,'%*[^]]%s\n',2);

% skip Version info
fgetl(ini_fid);

% get all parameters from ini file
[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',58);

i = 1;
stim_info.density = stim_array(i); i = i + 1;
stim_info.bgspacing = stim_array(i); i = i + 1;
stim_info.fgspacing = stim_array(i); i = i + 1;
stim_info.angle = stim_array(i); i = i + 1;
stim_info.orijitter = stim_array(i); i = i + 1;
stim_info.figelts = stim_array(i); i = i + 1;
stim_info.stimdim = stim_array(i); i = i + 1;
stim_info.stimincr = stim_array(i); i = i + 1;
stim_info.stimend = stim_array(i); i = i + 1;
stim_info.catchtrials = stim_array(i); i = i + 1;
stim_info.gabsize = stim_array(i); i = i + 1;
stim_info.vel = stim_array(i); i = i + 1;
stim_info.sf = stim_array(i); i = i + 1;
stim_info.ecc = stim_array(i); i = i + 1;
stim_info.contourtype = stim_array(i); i = i + 1;
stim_info.stimmotion = stim_array(i); i = i + 1;
stim_info.figcont = stim_array(i); i = i + 1;
stim_info.fixcont = stim_array(i); i = i + 1;
stim_info.bglum = stim_array(i); i = i + 1;
stim_info.stimsets = stim_array(i); i = i + 1;
stim_info.numstim = stim_array(i); i = i + 1;
stim_info.fixx = stim_array(i); i = i + 1;
stim_info.fixy = stim_array(i); i = i + 1;
stim_info.fixsize = stim_array(i); i = i + 1;
stim_info.fixtype = stim_array(i); i = i + 1;
stim_info.fixwinsize = stim_array(i); i = i + 1;
stim_info.targetwinsize = stim_array(i); i = i + 1;
stim_info.usetargetcenter = stim_array(i); i = i + 1;
stim_info.tcentercontrast = stim_array(i); i = i + 1;
stim_info.showstimwithfix = stim_array(i); i = i + 1;
stim_info.transient = stim_array(i); i = i + 1;
stim_info.maskp = stim_array(i); i = i + 1;
stim_info.includetuning = stim_array(i); i = i + 1;
stim_info.numtuningdir = stim_array(i); i = i + 1;
stim_info.tuningstepsize = stim_array(i); i = i + 1;
stim_info.includedirsac = stim_array(i); i = i + 1;
stim_info.paradigm = stim_array(i); i = i + 1;
stim_info.paradigm = stim_array(i); i = i + 1;
stim_info.iti = stim_array(i); i = i + 1;
stim_info.itimax = stim_array(i); i = i + 1;
stim_info.riti = stim_array(i); i = i + 1;
stim_info.audio = stim_array(i); i = i + 1;
stim_info.fixlimit = stim_array(i); i = i + 1;
stim_info.stimlat = stim_array(i); i = i + 1;
stim_info.stimlatmax = stim_array(i); i = i + 1;
stim_info.rstimlat = stim_array(i); i = i + 1;
stim_info.stimdur = stim_array(i); i = i + 1;
stim_info.stimdurmax = stim_array(i); i = i + 1;
stim_info.rstimdur = stim_array(i); i = i + 1;
stim_info.matchlimit = stim_array(i); i = i + 1;
stim_info.reward = stim_array(i); i = i + 1;
stim_info.rewardmax = stim_array(i); i = i + 1;
stim_info.rreward = stim_array(i); i = i + 1;
stim_info.penalty = stim_array(i); i = i + 1;
stim_info.penaltymax = stim_array(i); i = i + 1;
stim_info.rpenalty = stim_array(i); i = i + 1;
stim_info.etfix = stim_array(i); i = i + 1;
stim_info.etstray = stim_array(i); i = i + 1;

switch stim_info.stimdim
case {0}
   stim_info.stimstart = stim_info.density;
case {1}
   stim_info.stimstart = stim_info.bgspacing;
case {2}
   stim_info.stimstart = stim_info.fgspacing;
case {3}
   stim_info.stimstart = stim_info.angle;
case {4}
   stim_info.stimstart = stim_info.orijitter;
case {5}
   stim_info.stimstart = stim_info.figelts;
otherwise
   disp('unknown stimulus dimension');
   return
end

% figure out number of stimulus steps
if stim_info.catchtrials == 1,
	stim_info.stimsteps = (stim_info.numstim / stim_info.stimsets - 1) / 2;
else
	stim_info.stimsteps = (stim_info.numstim / stim_info.stimsets) / 2;
end

stim_info.stim_p = stim_info.stimstart:stim_info.stimincr:stim_info.stimend;

fscanf(ini_fid,'%*[^]]%s\n',1);

% read in stimulus sequence
[stim_seq,count] = fscanf(ini_fid,'%*[^=]=%i\n');
[stim_order,seq] = sort(stim_seq);

% set up structure used by other functions
stim_info.isequence = seq;

fclose(ini_fid);
