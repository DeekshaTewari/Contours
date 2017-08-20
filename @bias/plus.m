function r = plus(p,q,varargin)
%BIAS/PLUS Overloaded plus function for BIAS objects
%   R = PLUS(P,Q) combines BIAS objects P and Q and returns
%   the BIAS object R. This operation will append the theta, cor, 
%   inc, indexes and sessionname fields in Q to P and add the 
%   sessions field in Q to P. If one of the objects is empty, 
%   the other object will be returned.
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
	
	% add the theta, results and rt fields together
	r.theta = [p.theta; q.theta];
	r.results = [r.results; q.results];
	r.rt = [p.rt; q.rt];
	
	% get length of p.theta
	psize = length(p.theta);
	r.indexes = [p.indexes; (q.indexes+psize)];
	% get size of p.sesindexes
	ps = size(p.sesindexes,1);
	r.sesindexes = [p.sesindexes; q.sesindexes+p.sesindexes(ps,2)];
end