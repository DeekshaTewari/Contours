function p = ComputeMeanStdev(p)
%PERFORMANCE/ComputeMeanStdev Computes statistics for PERFORMANCE object
%   P = ComputeMeanStdev(P) takes a PERFORMANCE object with just the
%   contour, control, catchcontour, and catchcontrol fields filled out
%   and computes and fills out the following fields: contourresults,
%   contourmean, contoursd, controlresults, controlmean, controlsd,
%   overallresults, overallmean, overallsd, catchcontourresults,
%   catchcontourmean, catchcontoursd, catchcontrolresults, 
%   catchcontrolmean, catchcontrolsd, catchoverallresults,
%   catchoverallmean, and catchoverallsd. 
%
%   Dependencies: CalStdev.

if (p.sessions == 1)
	% this function called when creating new performance object, so copy
	% stats for session 1 to those for the whole object
	p.session(1).contourmean = p.session(1).contourresults(:,1) ./ p.session(1).contourresults(:,2);
	p.session(1).contoursd = CalStdev(p.session(1).contourresults);
	p.contourmean = p.session(1).contourmean;
	p.contoursd = p.session(1).contoursd;
	
	if ~isempty(p.session(1).controlresults)
		p.session(1).controlmean = p.session(1).controlresults(:,1) ./ p.session(1).controlresults(:,2);
		p.session(1).controlsd = CalStdev(p.session(1).controlresults);
		
		p.session(1).overallmean = p.session(1).overallresults(:,1) ./ p.session(1).overallresults(:,2);
		p.session(1).overallsd = CalStdev(p.session(1).overallresults);
	else
		p.session(1).controlmean = [];
		p.session(1).controlsd = [];
		
		p.session(1).overallmean = [];
		p.session(1).overallsd = [];
	end
	p.controlmean = p.session(1).controlmean;
	p.controlsd = p.session(1).controlsd;
	p.overallmean = p.session(1).overallmean;
	p.overallsd = p.session(1).overallsd;
	
	if ~isempty(p.session(1).catchcontourresults)
		p.session(1).catchcontourmean = p.session(1).catchcontourresults(:,1) ./ p.session(1).catchcontourresults(:,2);
		p.session(1).catchcontoursd = CalStdev(p.session(1).catchcontourresults);
	else
		p.session(1).catchcontourmean = [];
		p.session(1).catchcontoursd = [];
	end
	p.catchcontourmean = p.session(1).catchcontourmean;
	p.catchcontoursd = p.session(1).catchcontoursd;
	
	if ~isempty(p.session(1).catchcontrolresults)
		p.session(1).catchcontrolmean = p.session(1).catchcontrolresults(:,1) ./ p.session(1).catchcontrolresults(:,2);
		p.session(1).catchcontrolsd = CalStdev(p.session(1).catchcontrolresults);
	
		p.session(1).catchoverallmean = p.session(1).catchoverallresults(:,1) ./ p.session(1).catchoverallresults(:,2);
		p.session(1).catchoverallsd = CalStdev(p.session(1).catchoverallresults);
	else
		p.session(1).catchcontrolmean = [];
		p.session(1).catchcontrolsd = [];
	
		p.session(1).catchoverallmean = [];
		p.session(1).catchoverallsd = [];
	end
	p.catchcontrolmean = p.session(1).catchcontrolmean;
	p.catchcontrolsd = p.session(1).catchcontrolsd;
	p.catchoverallmean = p.session(1).catchoverallmean;
	p.catchoverallsd = p.session(1).catchoverallsd;
else
	% this function called when combining two performance objects, so 
	% compute stats only on the whole object since the stats for the 
	% individual sessions should have already been computed
	p.contourmean = p.contourresults(:,1) ./ p.contourresults(:,2);	
	p.contoursd = CalStdev(p.contourresults);
	
	if ~isempty(p.controlresults)
		p.controlmean = p.controlresults(:,1) ./ p.controlresults(:,2);
		p.controlsd = CalStdev(p.controlresults);
		
		p.overallmean = p.overallresults(:,1) ./ p.overallresults(:,2);
		p.overallsd = CalStdev(p.overallresults);
	else
		p.controlmean = [];
		p.controlsd = [];
		p.overallmean = [];
		p.overallsd = [];
	end
	
	if ~isempty(p.catchcontourresults)
		p.catchcontourmean = p.catchcontourresults(:,1) ./ p.catchcontourresults(:,2);
		p.catchcontoursd = CalStdev(p.catchcontourresults);
	else
		p.catchcontourmean = [];
		p.catchcontoursd = [];
	end
	
	if ~isempty(p.catchcontrolresults)
		p.catchcontrolmean = p.catchcontrolresults(:,1) ./ p.catchcontrolresults(:,2);
		p.catchcontrolsd = CalStdev(p.catchcontrolresults);
		
		p.catchoverallmean = p.catchoverallresults(:,1) ./ p.catchoverallresults(:,2);
		p.catchoverallsd = CalStdev(p.catchoverallresults);
	else
		p.catchcontrolmean = [];
		p.catchcontrolsd = [];
		
		p.catchoverallmean = [];
		p.catchoverallsd = [];
	end
end
