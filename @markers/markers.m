function m = markers(varargin)
%MARKERS Constructor function for MARKERS object
%   M = MARKERS(SESINFO) instantiates a MARKERS object using a SESINFO 
%   object by reading the marker file [SESINFO.session '.mrk']. The 
%   object contains the following fields:
%      M.session
%      M.contour(i).repetition(j).response
%      M.contour(i).repetition(j).num_of_markers
%      M.contour(i).repetition(j).markers()
%      M.control
%      M.catchcontour
%      M.catchcontrol
%	where i is the salience level, j is the repetition, response is 1 
%   or 0 indicating whether the response was correct or incorrect, 
%   num_of_markers is the number of markers in each trial, and markers 
%   contain the actual markers arranged by rows, with the marker id in 
%   column 1 and the marker time in column 2.
%
%	Dependencies: ReadMarkerFile,MarkersToTrials,unleave.

switch nargin
case 0
	d.session = '';
	d.contour = [];
	d.control = [];
	d.catchcontour = [];
	d.catchcontrol = [];
	m = class(d,'markers');
case 1
	if (isa(varargin{1},'markers'))
		m = varargin{1};
	elseif (isa(varargin{1},'sesinfo'))
		s = varargin{1};
		[markers,records] = ReadMarkerFile([s.session '.mrk']);
		tmarkers = ContoursMarkersToTrials(markers);
		d = unleave(tmarkers,s);
		d.session = s.session;
		m = class(d,'markers');
	else
		error('Wrong argument type')
	end
otherwise
	error('Wrong number of input arguments')
end
