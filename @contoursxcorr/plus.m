function r = plus(p,q,varargin)

if(q.data.numSets==0)
	r = p;
elseif(p.data.numSets==0)
	r = q;
else
	p.data.numSets = p.data.numSets + q.data.numSets;
	p.data.setNames = {p.data.setNames{:} q.data.setNames{:}};
	% p.data.dlist = [p.data.dlist; q.data.dlist];
	% p.data.setIndex = [p.data.setIndex; (p.data.setIndex(end) ...
	% 	+ q.data.setIndex(2:end))];
    % add nptdata objects as well
    p.nptdata = plus(p.nptdata,q.nptdata);
    r = p;
end
