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
        for sal = 1 : 3
            r.data.salience(sal).StimCR = [p.data.salience(sal).StimCR; q.data.salience(sal).StimCR];
            r.data.salience(sal).StimIR = [p.data.salience(sal).StimIR; q.data.salience(sal).StimIR];
            r.data.salience(sal).SacCR = [p.data.salience(sal).SacCR; q.data.salience(sal).SacCR];
            r.data.salience(sal).SacIR = [p.data.salience(sal).SacIR; q.data.salience(sal).SacIR];
            r.data.salience(sal).nCR = [p.data.salience(sal).nCR; q.data.salience(sal).nCR];
            r.data.salience(sal).nIR = [p.data.salience(sal).nIR; q.data.salience(sal).nIR];
            r.data.salience(sal).RTIR = [p.data.salience(sal).RTIR; q.data.salience(sal).RTIR];
            r.data.salience(sal).RTCR = [p.data.salience(sal).RTCR; q.data.salience(sal).RTCR];
        end
        %       r .data.F = [p.data.F; q.data.F];
        % 		r.data.step = [p.data.step; q.data.step];
        % 		r.data.window = [p.data.window; q.data.window];
        r.data.beforeSac = [p.data.beforeSac; q.data.beforeSac];
        r.data.beforeStim = [p.data.beforeStim; q.data.beforeStim];
        r.data.F = [p.data.F; q.data.F];
        r.data.step = [p.data.step; q.data.step];
        r.data.window = [p.data.window; q.data.window];

        q.data.Index(:,1) = q.data.Index(:,1) + p.data.Index(end,1);
        q.data.Index(:,2) = q.data.Index(:,2) + p.data.Index(end,2);

        r.data.Index = [p.data.Index; q.data.Index];
        % useful fields for most objects
        r.data.numSets = p.data.numSets + q.data.numSets;
        r.data.setNames = {p.data.setNames{:} q.data.setNames{:}};

        % add nptdata objects as well
        r.nptdata = plus(p.nptdata,q.nptdata);
    end
end
