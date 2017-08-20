function b = updateDataStructure(a)
%@sesinfo/updateDataStructure Updates old saved objects
%   B = updateDataStructure(A) is called to convert old saved objects
%   to the current data structure. A will thus be a structure.

% figure out what is missing
if(~isfield(a,'data'))
	b.data = a;
end
