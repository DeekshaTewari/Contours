function r = plus(p,q,varargin)

% get name of class
classname = mfilename('class');
if ~isempty(p)
    switch p.data.TrialType{1}
        case 'contour'
            totsal = 3;
        case'control'
            totsal = 3;
        case 'catchcontour' 
            
        case 'catchcontrol'
            totsal = 1;
    end
else 
    totsal = 1;
end
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
         for sal = 1 : totsal
            r.data.salience(sal).ks = [p.data.salience(sal).ks; q.data.salience(sal).ks];

            r.data.salience(sal).ampl1 = [p.data.salience(sal).ampl1; q.data.salience(sal).ampl1];
            r.data.salience(sal).ampl2 = [p.data.salience(sal).ampl2; q.data.salience(sal).ampl2];

            %             r.data.salience(sal).contour = [p.data.salience(sal).contour; q.data.salience(sal).contour];
            %             r.data.salience(sal).control = [p.data.salience(sal).control; q.data.salience(sal).control];
        end
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
