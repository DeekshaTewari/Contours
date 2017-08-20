function robj = ProcessSession(obj,varargin)
%EYESTARGET/ProcessSession	Process session data.
%   ProcessSession(OBJ) checks the eye subdirectory for data to process.
%   It does the following:
%      a) Checks for the presence of skip.txt and skipeyestarget.txt, 
%   and if either are present, returns an empty eyestarget object.
%      b) Checks the eye subdirectory for the presence of a file named
%   eyestarget.mat. 
%      c) If it is present, it loads the file and returns the saved
%   eyetarget object.
%      d) If it is not present, it creates a sesinfo object, changes
%   directory to the eye subdirectory and uses it to create an 
%   eyestarget object. The object is saved as eyestarget.mat in the
%   eye subdirectory.
%      e) ProcessSession(OBJ,'redo') will execute d) even if the file 
%   eyestarget.mat is present in the eye subdirectory.
%
%	Dependencies: removeargs, nptDir, ispresent, sesinfo. 

redo = 0;

if (~checkMarkers(obj,redo,'session'))
	% check to see if there is an eye directory
	[r,a] = ispresent('eye','dir','CaseInsensitive');
	if r
		cd(a)
		% create object
		robj = eyestarget('auto',varargin{:});
		cd ..
	else
    	% no eye dir, so just return empty object
    	robj = eyestarget;
    end
    
    % create processed marker if necessary
    createProcessedMarker(obj,'session');
else
	% skip this session so return empty object
	robj = eyestarget;
end % if marker file exists
