function b = EyesTargetToBias(obj)
%BIAS/EyesTargetToBias Creates BIAS object from EYESTARGET object

if isempty(obj)
	b.sessions = 0;
	b.sessionname = {};
	b.results = [];
	b.rt = [];
	b.theta = [];
	b.indexes = [];
	b.sesindexes = [];
else
	% store values in fields
	b.sessions = 1;
	b.sessionname{1} = obj.sessionname;
	b.results = obj.results;
	b.rt = obj.rt;

	% get targets from eyestarget obj
	t = obj.targets;
	% get fixation coordinates from eyestarget obj
	xf = obj.fixx;
	yf = obj.fixy;
	
	% target coordinates are: left, top, right, bottom so separate out
	% x and y values
	o = ones(size(t,1),1);
	x = [t(:,1) t(:,3) o] * [0.5; 0.5; -xf];
	y = [t(:,2) t(:,4) o] * [0.5; 0.5; -yf];
	
	% since y = 0 is at the top of the screen, use -y to retrieve the 
	% angle of saccade as seen in the experiment
	b.theta = atan2(-y,x);
	
	b.indexes = [];
	for i = 1:obj.stim_steps
		if obj.stim_steps.control
			% use concatenate in case we are processing an incomplete
			% session
			b.indexes = concat(b.indexes,obj.sequence.contour(i), ...
				obj.sequence.control(i),'DiscardEmptyA','Columnwise');
		else
			b.indexes = concat(b.indexes,obj.sequence.contour(i), ...
				'DiscardEmptyA','Columnwise');
		end
	end
	
	if obj.stim_steps.catchcontour
		if obj.stim_steps.catchcontrol
			b.indexes = concat(b.indexes, ...
				concat(obj.sequence.catchcontour, ...
					obj.sequence.catchcontrol), ...
				'DiscardEmptyA','Columnwise');
		else
			b.indexes = concat(b.indexes,obj.sequence.catchcontour, ...
				'DiscardEmptyA','Columnwise');
		end
	end
	
	b.sesindexes = [1 obj.stim_sets];
end
