function res = isempty(s)
%SESINFO/ISEMPTY True for empty SESINFO objects
%   ISEMPTY(S) returns 1 if S is an empty SESINFO object
%   and 0 otherwise.
%
%   Dependencies: None.

if (isempty(s.data.sessionname))
	res = 1;
else
	res = 0;
end
