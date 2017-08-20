function display(w)
%SESINFO/DISPLAY Command window display of a SESINFO object
%
%   Dependencies: None.

fprintf('\n%s =\n',inputname(1));
fprintf('\t%s object for session %s with fields:\n',class(w),w.data.sessionname);
displayfields(w)
