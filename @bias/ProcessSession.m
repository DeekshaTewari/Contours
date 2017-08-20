function [robj,pdata] = ProcessSession(obj,varargin)
%BIAS/ProcessSession	Process session data.
%   ROBJ = ProcessSession(OBJ) checks the local directory for data to 
%   process and returns the processed object in ROBJ.
%   It does the following:
%      a) Checks for the presence of skip.txt and skipbias.txt, 
%   and if either are present, returns an empty bias object.
%      d) ProcessSession(OBJ,'redo') will create a new performance
%   object even if the file performance.mat is present.
%
%	Dependencies: removeargs, nptDir, ispresent, sesinfo. 

redo = 0;
pdata = [];

if (~checkMarkers(obj,redo,'session'))
	robj = bias('auto',varargin{:});

	% create processed marker if necessary
	createProcessedMarker(obj,'session');
else
	% skip this session so return empty object
	robj = bias;
end % if marker file exists
