function [r,varargout] = get(obj,varargin)
%   lfptraces/get Get function for lfptraces objects
%       
%
%   Object level is session object  
%
%   
%   Dependencies: getTrials 
%  
Args = struct('Number',0,'ObjectLevel',0,'SessionBySession',0,'TrialType',[],'response',1,'salience',1,'channel',1,'Threshold',[],'Parameter',[],'Condition','>');
Args.flags = {'Number','SessionBySession','ObjectLevel'};
Args = getOptArgs(varargin,Args);

varargout{1} = {''};
varargout{2} = 0;

SetIndex = obj.data.Index; 


if Args.Number
    
    if Args.SessionBySession 
        % return total number of events
        r = length(obj.data.setNames);
        % find the transition point between sessions
        sdiff = diff(SetIndex(:,1));
        stransition = [0; vecc(find(sdiff))];
        stransition = [stransition; length(SetIndex)];
        rind = [];
        cvalue = 0;
        for idx = 1:r
            value = vecc(SetIndex((stransition(idx)+1):stransition(idx+1),3));
            cvalue = vecc(SetIndex((stransition(idx)+1):stransition(idx+1),4));
            % grab the indices corresponding to session idx
            rind = [rind; [repmat(idx,length(value),1) value cvalue]];
        end
        if ~isempty(Args.TrialType)
            
         ind = getTrials(obj,Args.TrialType,Args.response,Args.salience,Args.channel);
        combined = intersect(ind,rind(:,3));
        rind = rind(combined,:);
        end
    else % case where all the data are given in block
         rind = SetIndex(:,[1 3 4]);
        
    end
    
    if ~isempty(Args.Threshold) % needs to be done the idea is that one can use the threshold in addition to the following selection of data.
        measure = eval(Args.Parameter);
        [rawindices,colindices] = eval(sprintf('find(measure %s %d)',Args.Condition,Args.Threshold));
        rindtemp = SetIndex(rawindices,[1 3 4]);
        rindlast = [];
        for i = 1 : size(rind,1)
            I = find(rindtemp(:,3) == rind(i,3));
            if ~isempty(I)
                rindlast = [rindlast; rind(i,:)];
            end
        end
        
    else 
        ind = getTrials(obj,Args.TrialType,Args.response,Args.salience,Args.channel);
        combined = intersect(ind,rind(:,3));
        rind = rind(combined,:);
        rindlast = rind;
        
    end
    rt = unique(rind(:,2);
    cumt = 1;
    for t = 1 : length(rt)
       ct = rt(t);
       I = find(rind(:,2) == ct);
       rind(I,2) = cumt;
       cumt = cumt + 1;
    end
    
    
    if Args.SessionBySession 
        r = length(unique(rind(:,1)));
    else
        r = length(rindlast);
    
    end
    varargout(1) = {rindlast};
    
elseif(Args.ObjectLevel)
    r = 'Session';
else
    r = get(obj.nptdata,varargin{:});
    
end

