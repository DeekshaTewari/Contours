function [r,varargout] = get(obj,varargin)
%   lfpaveragep/get Get function
%
%
%   Object level is session object
%
%
%   Dependencies:
%
Args = struct('Number',0,'salience',1,'ObjectLevel',0,'Threshold',[],'Parameter',[],'Condition','>');
Args.flags = {'Number','SessionBySession','ObjectLevel'};
Args = getOptArgs(varargin,Args);

varargout{1} = {''};
varargout{2} = 0;

SetIndex = obj.data.Index;


if Args.Number

    rind = SetIndex;

    if ~isempty(Args.Threshold) % needs to be done the idea is that one can use the threshold in addition to the following selection of data.
        measure = eval(Args.Parameter);
        [rawindices,colindices] = eval(sprintf('find(measure %s %d)',Args.Condition,Args.Threshold));
        rindtemp = SetIndex(rawindices,:);
        rindlast = [];
        for i = 1 : size(rind,1)
            I = find(rindtemp(:,2) == rind(i,2));
            if ~isempty(I)
                rindlast = [rindlast; rind(i,:)];
            end
        end

    else
        rindlast = rind;
    end
%     rindclean = [];
%      for t = 1 : size(rindlast,1)
%         P = obj.data.salience(Args.salience).diffStim(rindlast(t,2),:,:);
%         nantest = unique(isnan(P));
%         if length(nantest) ~= 1
%             rindclean = [rindclean; rindlast(t,:)];
%         end
%      end
    r = length(rindlast);

    varargout(1) = {rindlast};

elseif(Args.ObjectLevel)
    r = 'Session';
else
    r = get(obj.nptdata,varargin{:});

end


