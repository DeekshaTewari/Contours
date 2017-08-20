function r = plus(p,q)
%EYESTARGET/PLUS Overloaded plus function for EYESTARGET objects
%   R = PLUS(P,Q) returns the non-empty EYESTARGET object if the
%   other object is empty. If neither or both are empty, then it 
%   returns the first input argument.
%
%   Dependencies: None.

pres = isempty(p.targets);
qres = isempty(q.targets);

% return q only if p is empty and q is not
if (pres & (~qres))
	r = q;
% otherwise return p
else
	r = p;
end
