function spikes = ContoursCombineSpikes(varargin)
%ContoursCombineSpikes	Combines spikes from multiple sessions
%	SPIKES = ContoursCombineSpikes(SPIKES1,SPIKES2,...)

nresults = nargin;

spikes = varargin{1};

for i=2:nresults
	ri = varargin{i};
	spikes.duration = max([spikes.duration ri.duration]);
	

r1 = varargin{1};
% get number of fields in first structure
s1 = size(fieldnames(r1),1);
% get fields from first structure
result.sessions = r1.session;
result.contourresults = r1.contourresults;
result.controlresults = r1.controlresults;
result.overallresults = r1.overallresults;
% check to see if there are catch trials
if isfield(r1,'catchcontourresults')
	result.catchcontourresults = r1.catchcontourresults;
	result.catchcontrolresults = r1.catchcontrolresults;
	result.catchoverallresults = r1.catchoverallresults;
end

for i=2:nresults
	ri = varargin{i};
	si = size(fieldnames(ri),1);
	if si~=s1
		fprintf('Structures are not the same size!\n');
		return
	else
		result.sessions = [result.sessions ',' ri.session];
		result.contourresults = result.contourresults + ri.contourresults;
		result.controlresults = result.controlresults + ri.controlresults;
		result.overallresults = result.overallresults + ri.overallresults;
		if isfield(ri,'catchcontourresults')
			result.catchcontourresults = result.catchcontourresults + ri.catchcontourresults;
			result.catchcontrolresults = result.catchcontrolresults + ri.catchcontrolresults;
			result.catchoverallresults = result.catchoverallresults + ri.catchoverallresults;
		end
	end
end

oresult = ContoursBehCalMeanStdev(result);