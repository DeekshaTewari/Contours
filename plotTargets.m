function plotTargets
%plotTarget Creates polar plot of target locations
%   plotTargets looks in the local directory for a '*_stimuli.bin'
%   file and plots the targets from the file. If more than one file
%   matches the pattern, the first file is used.

% get stimuli.bin file
a = nptDir('*_stimuli.bin');
if ~isempty(a)
	% show warning if more than 1 found
	if (length(a)>1)
		fprintf('Warning: More than 1 stimulus file found! Using the first one...\n');
	end
	t = ContoursReadTargetLocations(a(1).name);
	% get sesinfo object
	s = sesinfo('auto');
	% get fixation location
	xf = s.fixx;
	yf = s.fixy;
	o = ones(size(t,1),1);
	x = [t(:,1) t(:,3) o] * [0.5; 0.5; -xf];
	y = [t(:,2) t(:,4) o] * [0.5; 0.5; -yf];
	% y = 0 in DirectX is at the top of the screen so take -y to 
	% make it correspond to cartesian coordinates
	theta = atan2(-y,x);
	polar(theta,ones(size(theta)),'d')
else
	error('No stimuli file found');
end
