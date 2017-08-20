function p = EyesTargetToPerformance(m)
%PERFORMANCE/EyesTargetToPerformance Create PERFORMANCE structure from EYESTARGET object
%	P = EyesTargetToPerformance(EYESTARGET) takes an EYESTARGET object and 
%   creates the data structure for a PERFORMANCE object.
%
%	Dependencies: @performance/private/ComputeMeanStdev.

p.sessions = 1;
p.daysessions = [];
p.session(1).sessionname = m.sessionname;

% check size of m to see if there is an incomplete session
% mrsize = size(m.results,1);
% ntrials = m.trials;
% if(ntrials>mrsize)
	% pad results with nan's
% 	m.results = [m.results; repmat(nan,ntrials-mrsize,1)];
% end

p.session(1).contourresults = [];
for sal = 1:m.stim_steps.contour
	p.session(1).contour(sal).result = m.results.contour(sal);
	p.session(1).contourresults = [p.session(1).contourresults; length(find(p.session(1).contour(sal).result>0)) ...
		sum(~isnan(p.session(1).contour(sal).result))];
end
p.contourresults = p.session(1).contourresults;
	
p.session(1).controlresults = [];
for sal = 1:m.stim_steps.control
	p.session(1).control(sal).result = m.results.control(sal);
	p.session(1).controlresults = [p.session(1).controlresults; length(find(p.session(1).control(sal).result>0)) ...
		sum(~isnan(p.session(1).control(sal).result))];
end
p.controlresults = p.session(1).controlresults;

if m.stim_steps.control > 0
	p.session(1).overallresults = p.session(1).contourresults + p.session(1).controlresults;
else
	p.session(1).overallresults = [];
end
p.overallresults = p.session(1).overallresults;

if m.stim_steps.catchcontour > 0
	p.session(1).catchcontour.result = m.results.catchcontour;
	p.session(1).catchcontourresults = [length(find(p.session(1).catchcontour.result>0)) ...
		sum(~isnan(p.session(1).catchcontour.result))];
else
	p.session(1).catchcontour.result = [];
	p.session(1).catchcontourresults = [];
end
p.catchcontourresults = p.session(1).catchcontourresults;

if m.stim_steps.catchcontrol > 0
	p.session(1).catchcontrol.result = m.results.catchcontrol;
	p.session(1).catchcontrolresults = [length(find(p.session(1).catchcontrol.result>0)) ...
		sum(~isnan(p.session(1).catchcontrol.result))];
	p.session(1).catchoverallresults = p.session(1).catchcontourresults + p.session(1).catchcontrolresults;
else
	p.session(1).catchcontrol.result = [];
	p.session(1).catchcontrolresults = [];
	p.session(1).catchoverallresults = [];
end
p.catchcontrolresults = p.session(1).catchcontrolresults;
p.catchoverallresults = p.session(1).catchoverallresults;

p = ComputeMeanStdev(p);
