function r = plus(p,q,varargin)
%PERFORMANCE/PLUS Overloaded plus function for PERFORMANCE objects
%   R = PLUS(P,Q) combines PERFORMANCE objects P and Q and returns
%   the PERFORMANCE object R. This operation will insert the results
%   of contour, control, catchcontour, and catchcontrol of Q into P,
%   sum the contourresults, controlresults, catchcontourresults, 
%   catchcontrolresults, overallresults, and catchoverallresults 
%   fields, and recompute the contourmean, controlmean, 
%   catchcontourmean, catchcontrolmean, overallmean, 
%   catchoverallmean, contoursd, controlsd, catchcontoursd, 
%   catchcontrolsd, overallsd, and catchoverallsd fields.
%
%   PLUS(P,Q,'ignorediff') prints a warning if the fields of P and Q
%   are not identical but does not prompt for user input.
%
%   Dependencies: @performance/private/ComputeMeanStdev.

% default values for optional arguments
stopondiff = 1;

% look for optional arguments
num_args = nargin - 2;
i = 1;
while(i <= num_args)
	if ischar(varargin{i})
		switch varargin{i}
		case('ignorediff')
			stopondiff = 0;
			% remove argument from varargin
			[varargin,num_args] = removeargs(varargin,i,1);
		otherwise
			% unknown string, just skip over it
			i = i + 1;		
		end
    else
		% not a character, just skip over it
		i = i + 1;
    end
end

% check for empty objects
if (q.sessions == 0)
	r = p;
elseif (p.sessions == 0)
	r = q;
else	
	% use @sesinfo/diff function to compare objects to make sure they are
	% compatible
	if (diff(p.eyestarget,q.eyestarget))
		if stopondiff
			% not all parameters are the same so prompt user to see what to do
			a = input('Objects do not have identical stimulus info. Would you like to continue? (y/n)','s');
			if strcmp(a,'n')
				error('Objects do not match!');
			end
		else
			fprintf('Warning: Objects do not have identical stimulus info!\n');
		end
	end
	
	% add everything to p and then return object as r
	p.session((p.sessions+1):(p.sessions+q.sessions)) = q.session(:);
	p.sessions = p.sessions + q.sessions;
	% update Number field in parent object nptdata
	% p = set(p,'Number',p.sessions);
	% update SessionDirs field in parent object nptdata, which will also update the Number field
	pd = get(p,'SessionDirs');
	qd = get(q,'SessionDirs');
	p = set(p,'SessionDirs',{pd{:} qd{:}});


	
	p.contourresults = p.contourresults + q.contourresults;
	
	if ~isempty(p.controlresults)
		p.controlresults = p.controlresults + q.controlresults;
		p.overallresults = p.overallresults + q.overallresults;
	end
	
	if ~isempty(p.catchcontourresults)
		p.catchcontourresults = p.catchcontourresults + q.catchcontourresults;
		
		if ~isempty(p.catchcontrolresults)
			p.catchcontrolresults = p.catchcontrolresults + q.catchcontrolresults;
			p.catchoverallresults = p.catchoverallresults + q.catchoverallresults;
		end
	end
	
	r = ComputeMeanStdev(p);
end