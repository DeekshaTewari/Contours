function b = loadobj(a)
%@sesinfo/loadobj Modifies object during load

if isa(a,'sesinfo')
	b = a;
else
	% a is an old version so convert to new structure
	c = updateDataStructure(a);
	b = class(c,'sesinfo');
end
