function r = plus(p,q,varargin)
%TIMING/PLUS Overloaded plus function for TIMING objects
%   R = PLUS(P,Q) combines TIMING objects P and Q and returns
%   the TIMING object R. This operation will append the data,
%   and sessionname fields in Q to P, and add the sessions
%   field in Q to P. If one of the objects is empty, the other
%   object will be returned.
%
%   PLUS(P,Q,'ignorediff') prints a warning if the fields of P and Q
%   are not identical but does not prompt for user input.
%
%   Dependencies: None.

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

% check for empty object
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
	
	% assign p to r so that we can be sure we are returning the right object
	r = p;
	r.sessions = p.sessions + q.sessions;
	r.sessionname = {p.sessionname{:} q.sessionname{:}};
	% update Number field in parent object nptdata
	r = set(r,'Number',r.sessions);
	
	for sal = 1:p.eyestarget.stim_steps.contour
		% append the times for q to p
		t = [p.data.contour(sal).timing; q.data.contour(sal).timing];
		r.data.contour(sal).timing = t;
		% grab the last index from p
		pval = p.data.contour(sal).indexes(end,2);
		% add pval to q's indexes and then append them to p's indexes
		r.data.contour(sal).indexes = [p.data.contour(sal).indexes; ...
			(q.data.contour(sal).indexes + pval)];
		% merge session medians and quartiles
		r.data.median.contour = [p.data.median.contour q.data.median.contour];
		r.data.quartiles.contour = [p.data.quartiles.contour q.data.quartiles.contour];
		if isempty(t)
			r.data.median.overall.contour(sal,1) = 0;
			r.data.quartiles.overall.contour(sal,:) = [0 0];
		else
			% compute overall medians and quartiles
			m = median(t);
			prc25 = m - prctile(t,25);
			prc75 = prctile(t,75) - m;
			r.data.median.overall.contour(sal,1) = m;
			r.data.quartiles.overall.contour(sal,:) = [prc25 prc75];
		end
	end
	
	for sal = 1:p.eyestarget.stim_steps.control
		% append the times for q to p
		t = [p.data.control(sal).timing; q.data.control(sal).timing];
		r.data.control(sal).timing = t;
		% grab the last index from p
		pval = p.data.control(sal).indexes(end,2);
		% add pval to q's indexes and then append them to p's indexes
		r.data.control(sal).indexes = [p.data.control(sal).indexes; ...
			(q.data.control(sal).indexes + pval)];
		% merge session medians and quartiles
		r.data.median.control = [p.data.median.control q.data.median.control];
		r.data.quartiles.control = [p.data.quartiles.control q.data.quartiles.control];
		if isempty(t)
			r.data.median.overall.control(sal,1) = 0;
			r.data.quartiles.overall.control(sal,:) = [0 0];
		else
			% compute overall medians and quartiles
			m = median(t);
			prc25 = m - prctile(t,25);
			prc75 = prctile(t,75) - m;
			r.data.median.overall.control(sal,1) = m;
			r.data.quartiles.overall.control(sal,:) = [prc25 prc75];
		end
	end
	
	if p.eyestarget.stim_steps.catchcontour > 0
		% append the times for q to p
		t = [p.data.catchcontour.timing; q.data.catchcontour.timing];
		r.data.catchcontour.timing = t;
		% grab the last index from p
		pval = p.data.catchcontour.indexes(end,2);
		% add pval to q's indexes and then append them to p's indexes
		r.data.catchcontour.indexes = [p.data.catchcontour.indexes; ...
			(q.data.catchcontour.indexes + pval)];
		% merge session medians and quartiles
		r.data.median.catchcontour = [p.data.median.catchcontour q.data.median.catchcontour];
		r.data.quartiles.catchcontour = [p.data.quartiles.catchcontour q.data.quartiles.catchcontour];
		if isempty(t)
			r.data.median.overall.catchcontour(sal,1) = 0;
			r.data.quartiles.overall.catchcontour(sal,:) = [0 0];
		else
			% compute overall medians and quartiles
			m = median(t);
			prc25 = m - prctile(t,25);
			prc75 = prctile(t,75) - m;
			r.data.median.overall.catchcontour = m;
			r.data.quartiles.overall.catchcontour = [prc25 prc75];
		end
	end
	
	if p.eyestarget.stim_steps.catchcontrol > 0
		% append the times for q to p
		t = [p.data.catchcontrol.timing; q.data.catchcontrol.timing];
		r.data.catchcontrol.timing = t;
		% grab the last index from p
		pval = p.data.catchcontrol.indexes(end,2);
		% add pval to q's indexes and then append them to p's indexes
		r.data.catchcontrol.indexes = [p.data.catchcontrol.indexes; ...
			(q.data.catchcontrol.indexes + pval)];
		% merge session medians and quartiles
		r.data.median.catchcontrol = [p.data.median.catchcontrol q.data.median.catchcontrol];
		r.data.quartiles.catchcontrol = [p.data.quartiles.catchcontrol q.data.quartiles.catchcontrol];
		if isempty(t)
			r.data.median.overall.catchcontrol(sal,1) = 0;
			r.data.quartiles.overall.catchcontrol(sal,:) = [0 0];
		else
			% compute overall medians and quartiles
			m = median(t);
			prc25 = m - prctile(t,25);
			prc75 = prctile(t,75) - m;
			r.data.median.overall.catchcontrol = m;
			r.data.quartiles.overall.catchcontrol = [prc25 prc75];
		end
	end
end