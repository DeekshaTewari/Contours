function res = isempty(et)
%EYESTARGET/ISEMPTY True for empty EYESTARGET objects
%   ISEMPTY(ET) returns 1 if ET is an empty EYESTARGET object
%   and 0 otherwise.
%
%   Dependencies: None.

if (isempty(et.targets))
	res = 1;
else
	res = 0;
end
