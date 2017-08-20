function r = plus(p,q,varargin)

% get name of class
classname = mfilename('class');

% check if first input is the right kind of object
if(~isa(p,classname))
	% check if second input is the right kind of object
	if(~isa(q,classname))
		% both inputs are not the right kind of object so create empty
		% object and return it
		r = feval(classname);
	else
		% second input is the right kind of object so return that
		r = q;
	end
else
	if(~isa(q,classname))
		% p is the right kind of object but q is not so just return p
		r = p;
    elseif(isempty(p))
        % p is right object but is empty so return q, which should be
        % right object
        r = q;
    elseif(isempty(q))
        % p are q are both right objects but q is empty while p is not
        % so return p
        r = p;
	else
		% both p and q are the right kind of objects so add them 
		% together
		% assign p to r so that we can be sure we are returning the right
		% object
		r = p;
		r.data.LFP = [p.data.LFP; q.data.LFP];
		r.data.RT = [p.data.RT; q.data.RT];
		r.data.results = [p.data.results; q.data.results];
		r.data.TrialType = [p.data.TrialType; q.data.TrialType];
		r.data.OriJitter = [p.data.OriJitter; q.data.OriJitter]; 
		r.data.salience = [p.data.salience; q.data.salience];
		r.data.SamplingRate = [p.data.SamplingRate; q.data.SamplingRate];
        r.data.TargetOnset = [p.data.TargetOnset; q.data.TargetOnset];
        r.data.Nchannels = [p.data.Nchannels; q.data.Nchannels];
%         r.data.Type = [p.data.Type; q.data.Type];
        
		q.data.Index(:,1) = q.data.Index(:,1) + p.data.Index(end,1);
        q.data.Index(:,2) = q.data.Index(:,2) + p.data.Index(end,2);
        q.data.Index(:,4) = q.data.Index(:,4) + p.data.Index(end,4);
		r.data.Index = [p.data.Index; q.data.Index];
		% useful fields for most objects
		r.data.numSets = p.data.numSets + q.data.numSets;
		r.data.setNames = {p.data.setNames{:} q.data.setNames{:}};
		
		% add nptdata objects as well
		r.nptdata = plus(p.nptdata,q.nptdata);
	end
end
