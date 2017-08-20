function obj = plot(obj,varargin)
%   @lfptraces/plot
% needs to implement specific selection of sessions
%   Dpendencies:
%
%

Args = struct('salience',[1 2 3],'SacAlign',0,'nlimit',6,'nHist',0,'onlyCRvsIR',0,'bins',20,'binsEdges',[]);
Args.flags = {'SacAlign','nHist','onlyCRvsIR'};
[Args,varargin2] = getOptArgs(varargin,Args,'remove',{'SacAlign','NHist','onlyCRvsIR'});

[numevents,dataindices,Mark] = get(obj,'Number',varargin2{:});


if (~isempty(Args.NumericArguments))
    n = Args.NumericArguments{1};
    ind  = find(dataindices(:,2) == n);
    limit = dataindices(ind,2);
else
    n = numevents;
    limit = dataindices(:,1);
end


resp = {'CR';'IR'};
if length(limit) == 1 & ~Args.nHist
    if Args.SacAlign
        ali = 'Sac';
        xevent = obj.data.beforeSac(limit);
    else
        ali = 'Stim';
        xevent = obj.data.beforeStim(limit);
    end

    lab = {'-','--'};
    limlow = [];
    limhigh = [];
    count = 1;
    for r = 1 : 2
        clear d dim m nused
        par = sprintf('%s%s',ali,resp{r});

        for s = 1 : length(Args.salience)
            nused(s) = eval(sprintf('obj.data.salience(Args.salience(s)).n%s(n)',resp{r}));
            dim(s,:) = eval(sprintf('obj.data.salience(Args.salience(s)).%s(n,:)',par));;
            m(s,:) = eval(sprintf('obj.data.salience(s).RT%s(n,:)',resp{r}));
        end
        nanlimt = find((sum(~isnan(dim),1)) == 0);
        nanlim = nanlimt(1)-1;
        if Args.onlyCRvsIR
            if sum(nused) >= Args.nlimit
                d = nanmean(dim(:,1:nanlim),1);
                me{r} = nanmean(m,1);
            else
                d = nan(1,nanlim);
                me{r} = nan(1,2);
            end
        else
            for s = 1 : length(Args.salience)
                if nused(s) >= Args.nlimit
                    d(s,:) = dim(s,1:nanlim);
                    
                    leg{count} = sprintf('%s sal. %d; RT = %3.1f +/- %3.1f',resp{r},s,m(s,1),m(s,2));

                else

                    d(s,:) = nan(1,nanlim);
                    leg{count} = '';
                end
                count = count + 1;
            end
        end

        x = [0 : size(d,2) - 1];

        plot(x,d,lab{r});

        hold on

        limlow = [limlow min(d,[],2)];

        limhigh = [limhigh max(d,[],2)];


    end

    range = [min(limlow) : max(limhigh)];
    plot(repmat(xevent,1,length(range)),range,'r')

    if exist('leg')
        legend(leg{:})
    end
    if Args.onlyCRvsIR
        for r = 1: 2
        lege{r} = sprintf('%s; RT = %3.1f +/- %3.1f',resp{r},me{r}(1),me{r}(2));
        end
        legend(lege{:})
    end
    hold off
    xlabel('Time [ms]')
    ylabel('Voltage [uV]')


    fprintf('%s \n',obj.data.setNames{dataindices(ind,2)});

elseif Args.nHist
    alln = [];
    leg = {'-'; '--'};
    for r = 1 : 2

        for s = 1 : length(Args.salience)
            nused = eval(sprintf('obj.data.salience(Args.salience(s)).n%s',resp{r}));
            alln = [alln; nused];

        end

        if (isempty(Args.binsEdges))
            [H,N] = hist(alln,Args.bins);
        else
            [H,N] = hist(alln,Args.binsEdges);
            H = H';
            N = N';
        end

        if (isempty(Args.binsEdges))
            plot(N',H',leg{r})
        else
            plot(Args.binsEdges,H',leg{r})
        end

        legend('Correct responses','Incorrect responses')
        xlabel('Number of traces averaged')
        ylabel('#')

        hold on

    end
    hold off

end


