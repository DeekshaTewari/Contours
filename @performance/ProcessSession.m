function [robj,data] = ProcessSession(obj,varargin)
%PERFORMANCE/ProcessSession	Process session data.
%   ROBJ = ProcessSession(OBJ) checks the local directory for data to 
%   process and returns the processed object in ROBJ.
%   It does the following:
%      a) Checks for the presence of skip.txt and skipperformance.txt, 
%   and if either are present, returns an empty performance object.
%      b) Checks for the presence of a file named performance.mat, and 
%   if present, loads the object and returns it.
%      c) Checks the eye subdirectory for the presence of a file named
%   eyestarget.mat, and if present, loads it and uses it to create the
%   performance object.
%      d) If eyestarget.mat is not present, it creates and saves an 
%   eyestarget object, and also calls the diffResults function to list
%   the trials that have results that are different between the marker
%   file and the eye files. The object is then used to create the
%   performance object.
%      d) ProcessSession(OBJ,'redo') will create a new performance
%   object even if the file performance.mat is present.
%
%	Dependencies: removeargs, nptDir, ispresent, sesinfo. 

redo = 0;
data = [];

if (~checkMarkers(obj,redo,'session'))
	robj = performance('auto',varargin{:});

	% create processed marker if necessary
	createProcessedMarker(obj,'session');
else
	% skip this session so return empty object
	robj = performance;
end % if marker file exists
