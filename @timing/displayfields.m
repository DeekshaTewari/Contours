function displayfields(w)
%TIMING/DISPLAYFIELDS Displays fields of an TIMING object
%
%   Dependencies: None.

displayfields(w.eyestarget);
fprintf('\t\tsessions\n');
fprintf('\t\tsession().sessionname\n');
fprintf('\t\tsession().timing.contour()\n');
fprintf('\t\tsession().timing.control()\n');
fprintf('\t\tsession().timing.catchcontour()\n');
fprintf('\t\tsession().timing.catchcontrol()\n');
fprintf('\t\tsession().median.contour()\n');
fprintf('\t\tsession().median.control()\n');
fprintf('\t\tsession().median.catchcontour\n');
fprintf('\t\tsession().median.catchcontrol\n');
fprintf('\t\tsession().quartiles.contour()\n');
fprintf('\t\tsession().quartiles.control()\n');
fprintf('\t\tsession().quartiles.catchcontour\n');
fprintf('\t\tsession().quartiles.catchcontrol\n');
fprintf('\t\ttiming.contour()\n');
fprintf('\t\ttiming.control()\n');
fprintf('\t\ttiming.catchcontour()\n');
fprintf('\t\ttiming.catchcontrol()\n');
fprintf('\t\tmedian.contour()\n');
fprintf('\t\tmedian.control()\n');
fprintf('\t\tmedian.catchcontour\n');
fprintf('\t\tmedian.catchcontrol\n');
fprintf('\t\tquartiles.contour()\n');
fprintf('\t\tquartiles.control()\n');
fprintf('\t\tquartiles.catchcontour\n');
fprintf('\t\tquartiles.catchcontrol\n');
