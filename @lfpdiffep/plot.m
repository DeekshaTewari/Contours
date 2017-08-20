function obj = plot(obj,varargin)
%   @lfptraces/plot
% needs to implement specific selection of sessions
%   Dpendencies:
%
%

Args = struct('salience',[1 2 3],'SacAlign',0);
Args.flags = {'SacAlign'};
[Args,varargin2] = getOptArgs(varargin,Args,'remove',{'SacAlign'});

[numevents,dataindices,Mark] = get(obj,'Number',varargin2{:});


if (~isempty(Args.NumericArguments))
    n = Args.NumericArguments{1};
    ind  = find(dataindices(:,2) == n);
    limit = dataindices(ind,2);
else
    n = numevents;
    limit = dataindices(:,1);
end



if length(limit) == 1
    if Args.SacAlign
        ali = 'Sac';
        xevent = obj.data.beforeSac(limit);
    else
        ali = 'Stim';
        xevent = obj.data.beforeStim(limit);
    end


    limlow = [];
    limhigh = [];
    count = 1;


    clear d dim m nused


    for s = 1 : length(Args.salience)

        dim(s,:) = eval(sprintf('obj.data.salience(Args.salience(s)).diff%s(limit,:)',ali));

    end
    nanlimt = find((sum(~isnan(dim),1)) == 0);
    nanlim = nanlimt(1)-1;

    for s = 1 : length(Args.salience)

        d(s,:) = dim(s,1:nanlim);

        leg{count} = sprintf('sal. %d',s);

        count = count + 1;
    end


    x = [0 : size(d,2) - 1];

    plot(x,d);

    hold on

    limlow = [limlow min(d,[],2)];

    limhigh = [limhigh max(d,[],2)];




    range = [min(limlow) : max(limhigh)];
    plot(repmat(xevent,1,length(range)),range,'r--')

    if exist('leg')
        legend(leg{:})
    end
   
    hold off
    xlabel('Time [ms]')
    ylabel('Voltage [uV]')


    fprintf('%s \n',obj.data.setNames{dataindices(ind,2)});



end


