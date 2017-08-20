function t = EyesTargetToTiming(et)
%TIMING/EyesTargetToTiming Create TIMING structure from EYESTARGET object
%	T = EyesTargetToTiming(EYESTARGET) takes an EYESTARGET object and 
%   creates the data structure for a TIMING object.
%
%	Dependencies: None.

t.sessions = 1;
t.sessionname{1} = et.sessionname;

% check size of m to see if there is an incomplete session
% mrsize = size(et.results,1);
% ntrials = et.trials;
% if(ntrials>mrsize)
	% pad results with nan's
% 	et.rt = [et.rt; repmat(nan,ntrials-mrsize,1)];
% end

% no need to initialize t.contour since every session should at least
% have this condition
for sal = 1:et.stim_steps.contour
	% get all reaction times
	a = et.rt.contour(sal);
	% -1 in rt indicates there was no reaction time so find entries greater 
	% than -1
	rttrials = a > -1;
	% b = find(a > -1);
    if (isempty(a(rttrials)))
    	% no reaction times for this condition so set the correct trials
    	% to be empty
        t.data.contour(sal).timing = [];
        % set the indexes
        t.data.contour(sal).indexes = [1 0];
        t.data.median.contour(sal,1) = 0;
        t.data.quartiles.contour(sal,1,:) = [0 0];
        t.data.median.overall.contour(sal,1) = 0;
        t.data.quartiles.overall.contour(sal,:) = [0 0];
        % no reactions for this condition so set the incorrect trials to
        % be empty
        t.data.incorrect.contour(sal).timing = [];
        % set the indexes
        t.data.incorrect.contour(sal).indexes = [1 0];
        t.data.incorrect.median.contour(sal,1) = 0;
        t.data.incorrect.quartiles.contour(sal,1,:) = [0 0];
        t.data.incorrect.median.overall.contour(sal,1) = 0;
        t.data.incorrect.quartiles.overall.contour(sal,:) = [0 0];
    else
    	% get the results
    	results = et.results.contour(sal);
    	% find the correct trials
    	correctTrials = results > 0;
    	% find the incorrect trials
    	incorrectTrials = ~correctTrials;
		% add rt from correct trials
		c = a(rttrials & correctTrials);
        if(~isempty(c))
			m = median(c);
			p25 = m - prctile(c,25);
			p75 = prctile(c,75) - m;
        else
            m = 0;
            p25 = 0;
            p75 = 0;
        end
		t.data.contour(sal).timing = c;
		% set the indexes
		t.data.contour(sal).indexes = [1 length(c)];
        t.data.median.contour(sal,1) = m;
        t.data.quartiles.contour(sal,1,:) = [p25 p75];
        t.data.median.overall.contour(sal,1) = m;
        t.data.quartiles.overall.contour(sal,:) = [p25 p75];
		% add rt from incorrect trials
		c = a(rttrials & incorrectTrials);
        if(~isempty(c))
			m = median(c);
			p25 = m - prctile(c,25);
			p75 = prctile(c,75) - m;
        else
            m = 0;
            p25 = 0;
            p75 = 0;
        end
		t.data.incorrect.contour(sal).timing = c;
		% set the indexes
		t.data.incorrect.contour(sal).indexes = [1 length(c)];
        t.data.incorrect.median.contour(sal,1) = m;
        t.data.incorrect.quartiles.contour(sal,1,:) = [p25 p75];
        t.data.incorrect.median.overall.contour(sal,1) = m;
        t.data.incorrect.quartiles.overall.contour(sal,:) = [p25 p75];
    end
end

% get control steps
ctrlsteps = et.stim_steps.control;
if (ctrlsteps>0)
	for sal = 1:ctrlsteps
		% get all reaction times
		a = et.rt.control(sal);
		% -1 in rt indicates there was no reaction time so find entries 
		% greater than -1
		rttrials = a > -1;
		% b = find(a > -1);
		if (isempty(a(rttrials)))
			t.data.control(sal).timing = [];
			% set the indexes
			t.data.control(sal).indexes = [1 0];
			t.data.median.control(sal,1) = 0;
			t.data.quartiles.control(sal,1,:) = [0 0];
			t.data.median.overall.control(sal,1) = 0;
			t.data.quartiles.overall.control(sal,:) = [0 0];
			t.data.incorrect.control(sal).timing = [];
			% set the indexes
			t.data.incorrect.control(sal).indexes = [1 0];
			t.data.incorrect.median.control(sal,1) = 0;
			t.data.incorrect.quartiles.control(sal,1,:) = [0 0];
			t.data.incorrect.median.overall.control(sal,1) = 0;
			t.data.incorrect.quartiles.overall.control(sal,:) = [0 0];
		else
			% get the results
			results = et.results.control(sal);
			% find the correct trials
			correctTrials = results > 0;
			% find the incorrect trials
			incorrectTrials = ~correctTrials;
			% add rt from correct trials
			c = a(rttrials & correctTrials);
			if(~isempty(c))
				m = median(c);
				p25 = m - prctile(c,25);
				p75 = prctile(c,75) - m;
			else
				m = 0;
				p25 = 0;
				p75 = 0;
			end
			t.data.control(sal).timing = c;
			% set the indexes
			t.data.control(sal).indexes = [1 length(c)];
			t.data.median.control(sal,1) = m;
			t.data.quartiles.control(sal,1,:) = [p25 p75];
			t.data.median.overall.control(sal,1) = m;
			t.data.quartiles.overall.control(sal,:) = [p25 p75];
			% add rt from incorrect trials
			c = a(rttrials & incorrectTrials);
			if(~isempty(c))
				m = median(c);
				p25 = m - prctile(c,25);
				p75 = prctile(c,75) - m;
			else
				m = 0;
				p25 = 0;
				p75 = 0;
			end
			t.data.incorrect.control(sal).timing = c;
			% set the indexes
			t.data.incorrect.control(sal).indexes = [1 length(c)];
			t.data.incorrect.median.control(sal,1) = m;
			t.data.incorrect.quartiles.control(sal,1,:) = [p25 p75];
			t.data.incorrect.median.overall.control(sal,1) = m;
			t.data.incorrect.quartiles.overall.control(sal,:) = [p25 p75];
		end
	end
else
	% initialize t.control in case there are no control trials to make sure
	% object structure remains the same
	t.data.control = [];
	t.data.controlmedian = [];
	t.data.controlquartiles = [];
	t.data.incorrect.control = [];
	t.data.incorrect.controlmedian = [];
	t.data.incorrect.controlquartiles = [];
end

if et.stim_steps.catchcontour > 0
	% get all reaction times
	a = et.rt.catchcontour;
	% -1 in rt indicates there was no reaction time so find entries 
	% greater than -1
	rttrials = a > -1;
	% b = find(a > -1);
	if (isempty(a(rttrials)))
        t.data.catchcontour.timing = [];
		% set the indexes
		t.data.catchcontour.indexes = [1 0];
        t.data.median.catchcontour = 0;
        t.data.quartiles.catchcontour(1,1,:) = [0 0];
        t.data.median.overall.catchcontour = 0;
        t.data.quartiles.overall.catchcontour = [0 0];
        t.data.incorrect.catchcontour.timing = [];
		% set the indexes
		t.data.incorrect.catchcontour.indexes = [1 0];
        t.data.incorrect.median.catchcontour = 0;
        t.data.incorrect.quartiles.catchcontour(1,1,:) = [0 0];
        t.data.incorrect.median.overall.catchcontour = 0;
        t.data.incorrect.quartiles.overall.catchcontour = [0 0];
    else
		% get the results
		results = et.results.catchcontour;
		% find the correct trials
		correctTrials = results > 0;
		% find the incorrect trials
		incorrectTrials = ~correctTrials;
		% add rt from correct trials
		c = a(rttrials & correctTrials);
		if(~isempty(c))
			m = median(c);
			p25 = m - prctile(c,25);
			p75 = prctile(c,75) - m;
		else
			m = 0;
			p25 = 0;
			p75 = 0;
		end
		t.data.catchcontour.timing = c;
		% set the indexes
		t.data.catchcontour.indexes = [1 length(c)];
        t.data.median.catchcontour = m;
        t.data.quartiles.catchcontour(1,1,:) = [p25 p75];
        t.data.median.overall.catchcontour = m;
        t.data.quartiles.overall.catchcontour = [p25 p75];
		% add rt from correct trials
		c = a(rttrials & incorrectTrials);
		if(~isempty(c))
			m = median(c);
			p25 = m - prctile(c,25);
			p75 = prctile(c,75) - m;
		else
			m = 0;
			p25 = 0;
			p75 = 0;
		end
		t.data.incorrect.catchcontour.timing = c;
		% set the indexes
		t.data.incorrect.catchcontour.indexes = [1 length(c)];
        t.data.incorrect.median.catchcontour = m;
        t.data.incorrect.quartiles.catchcontour(1,1,:) = [p25 p75];
        t.data.incorrect.median.overall.catchcontour = m;
        t.data.incorrect.quartiles.overall.catchcontour = [p25 p75];
    end
else
	% intialize t.data.catchcontour to make sure object structure does not change
	t.data.catchcontour = [];
	t.data.median.catchcontour = [];
	t.data.quartiles.catchcontour = [];
	t.data.incorrect.catchcontour = [];
	t.data.incorrect.median.catchcontour = [];
	t.data.incorrect.quartiles.catchcontour = [];
end

if et.stim_steps.catchcontrol > 0
	% get all reaction times
	a = et.rt.catchcontrol;
	% -1 in rt indicates there was no reaction time so find entries 
	% greater than -1
	rttrials = a > -1;
	% b = find(a > -1);
	if (isempty(a(rttrials)))
        t.data.catchcontrol.timing = [];
		% set the indexes
		t.data.catchcontrol.indexes = [1 0];
        t.data.median.catchcontrol = 0;
        t.data.quartiles.catchcontrol(1,1,:) = [0 0];
        t.data.median.overall.catchcontrol = 0;
        t.data.quartiles.overall.catchcontrol = [0 0];
        t.data.incorrect.catchcontrol.timing = [];
		% set the indexes
		t.data.incorrect.catchcontrol.indexes = [1 0];
        t.data.incorrect.median.catchcontrol = 0;
        t.data.incorrect.quartiles.catchcontrol(1,1,:) = [0 0];
        t.data.incorrect.median.overall.catchcontrol = 0;
        t.data.incorrect.quartiles.overall.catchcontrol = [0 0];
    else
		% get the results
		results = et.results.catchcontrol;
		% find the correct trials
		correctTrials = results > 0;
		% find the incorrect trials
		incorrectTrials = ~correctTrials;
		% add rt from correct trials
		c = a(rttrials & correctTrials);
		if(~isempty(c))
			m = median(c);
			p25 = m - prctile(c,25);
			p75 = prctile(c,75) - m;
		else
			m = 0;
			p25 = 0;
			p75 = 0;
		end
		t.data.catchcontrol.timing = c;
		% set the indexes
		t.data.catchcontrol.indexes = [1 length(c)];
        t.data.median.catchcontrol = m;
        t.data.quartiles.catchcontrol(1,1,:) = [p25 p75];
        t.data.median.overall.catchcontrol = m;
        t.data.quartiles.overall.catchcontrol = [p25 p75];
		% add rt from incorrect trials
		c = a(rttrials & incorrectTrials);
		if(~isempty(c))
			m = median(c);
			p25 = m - prctile(c,25);
			p75 = prctile(c,75) - m;
		else
			m = 0;
			p25 = 0;
			p75 = 0;
		end
		t.data.incorrect.catchcontrol.timing = c;
		% set the indexes
		t.data.incorrect.catchcontrol.indexes = [1 length(c)];
        t.data.incorrect.median.catchcontrol = m;
        t.data.incorrect.quartiles.catchcontrol(1,1,:) = [p25 p75];
        t.data.incorrect.median.overall.catchcontrol = m;
        t.data.incorrect.quartiles.overall.catchcontrol = [p25 p75];
    end
else
	% intialize t.data.catchcontrol to make sure object structure does not change
	t.data.catchcontrol = [];
	t.data.median.catchcontrol = [];
	t.data.quartiles.catchcontrol = [];
	t.data.incorrect.catchcontrol = [];
	t.data.incorrect.median.catchcontrol = [];
	t.data.incorrect.quartiles.catchcontrol = [];
end
