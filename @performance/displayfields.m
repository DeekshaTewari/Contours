function displayfields(w)
%PERFORMANCE/DISPLAYFIELDS Displays fields of an PERFORMANCE object
%
%   Dependencies: None.

displayfields(w.eyestarget);
fprintf('\t\tsessions\n');
fprintf('\t\tsession().sessionname\n');
fprintf('\t\tsession().contour().result\n');
fprintf('\t\tsession().control().result\n');
fprintf('\t\tsession().catchcontour().result\n');
fprintf('\t\tsession().catchcontrol().result\n');
fprintf('\t\tsession().contourresults\n');
fprintf('\t\tsession().contourmean\n');
fprintf('\t\tsession().contoursd\n');
fprintf('\t\tsession().controlresults\n');
fprintf('\t\tsession().controlmean\n');
fprintf('\t\tsession().controlsd\n');
fprintf('\t\tsession().catchcontourresults\n');
fprintf('\t\tsession().catchcontourmean\n');
fprintf('\t\tsession().catchcontoursd\n');
fprintf('\t\tsession().catchcontrolresults\n');
fprintf('\t\tsession().catchcontrolmean\n');
fprintf('\t\tsession().catchcontrolsd\n');
fprintf('\t\tsession().overallresults\n');
fprintf('\t\tsession().overallmean\n');
fprintf('\t\tsession().overallsd\n');
fprintf('\t\tsession().catchoverallresults\n');
fprintf('\t\tsession().catchoverallmean\n');
fprintf('\t\tsession().catchoverallsd\n');
fprintf('\t\tcontourresults\n');
fprintf('\t\tcontourmean\n');
fprintf('\t\tcontoursd\n');
fprintf('\t\tcontrolresults\n');
fprintf('\t\tcontrolmean\n');
fprintf('\t\tcontrolsd\n');
fprintf('\t\tcatchcontourresults\n');
fprintf('\t\tcatchcontourmean\n');
fprintf('\t\tcatchcontoursd\n');
fprintf('\t\tcatchcontrolresults\n');
fprintf('\t\tcatchcontrolmean\n');
fprintf('\t\tcatchcontrolsd\n');
fprintf('\t\toverallresults\n');
fprintf('\t\toverallmean\n');
fprintf('\t\toverallsd\n');
fprintf('\t\tcatchoverallresults\n');
fprintf('\t\tcatchoverallmean\n');
fprintf('\t\tcatchoverallsd\n');
