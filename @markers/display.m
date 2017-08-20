function display(w)
%MARKERS/DISPLAY Command window display of a MARKERS object
%
%   Dependencies: None.

fprintf('\n%s =\n',inputname(1));
fprintf('\tmarkers object with fields:\n');
fprintf('\t\tsession\n');
fprintf('\t\tcontour\n');
fprintf('\t\tcontrol\n');
if ~isempty(w.catchcontour)
	fprintf('\t\tcatchcontour\n');
	fprintf('\t\tcatchcontrol\n');
end
