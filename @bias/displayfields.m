function displayfields(w)
%BIAS/DISPLAYFIELDS Displays fields of an TIMING object
%
%   Dependencies: None.

displayfields(w.eyestarget);
fprintf('\t\tsessions\n');
fprintf('\t\tsession().sessionname\n');
fprintf('\t\tsession().theta.contour()\n');
fprintf('\t\tsession().theta.catchcontour()\n');
fprintf('\t\tsession().results.contour()\n');
fprintf('\t\tsession().results.catchcontour()\n');
fprintf('\t\tsession().rt.contour()\n');
fprintf('\t\tsession().rt.catchcontour()\n');
fprintf('\t\ttheta.contour()\n');
fprintf('\t\ttheta.catchcontour()\n');
fprintf('\t\tresults.contour()\n');
fprintf('\t\tresults.catchcontour()\n');
fprintf('\t\trt.contour()\n');
fprintf('\t\trt.catchcontour()\n');
