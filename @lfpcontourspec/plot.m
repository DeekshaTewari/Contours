function obj = plot(obj,varargin)
%   @lfptraces/plot
% needs to implement specific selection of sessions
%   Dpendencies:
%
%

Args = struct('salience',1,'CR',1,'SacAlign',0,'nHist',0,'nlimit',6,'Flimit',150,'bins',20,'binsEdges',[],'maxcolorscale',15);
Args.flags = {'SacAlign','nHist'};
[Args,varargin2] = getOptArgs(varargin,Args,'remove',{'SacAlign','NHist'});

[numevents,dataindices,Mark] = get(obj,'Number',varargin2{:});


if (~isempty(Args.NumericArguments))
    n = Args.NumericArguments{1};
    ind  = find(dataindices(:,2) == n);
    limit = dataindices(ind,2);
else
    n = numevents;
    limit = dataindices(:,1);
end

if Args.CR
    resp = 'CR';
else
    resp = 'IR';
end

if length(limit) == 1 & ~Args.nHist
    F = obj.data.F(limit,:);
    step = obj.data.step(limit);
    window = obj.data.window(limit);
    if Args.SacAlign
        ali = 'Sac';

        xevent = round((obj.data.beforeSac(limit) - window/2)/step);
    else
        ali = 'Stim';
        xevent = round((obj.data.beforeStim(limit)- window/2)/step);
    end

    par = sprintf('%s%s',ali,resp);

    nused = eval(sprintf('obj.data.salience(Args.salience).n%s(limit)',resp));
    if nused >= Args.nlimit

        P = squeeze(eval(sprintf('obj.data.salience(Args.salience).%s(limit,:,:)',par)));
        
        nanlimt = find((sum(~isnan(P),1)) == 0);
        nanlim = nanlimt(1)-1;
        T = [window/2 : step : (step * (size(P,2)-1)) + window/2];

        imagesc(P(:,1:nanlim),[0 Args.maxcolorscale]);
        hax = gca;
        I = find(F <= Args.Flimit);
        set(hax,'YLim',[0.5 I(end)+0.5]);
        set(hax,'YTick',I(1:10:end));

        set(hax,'Xtick',[1:10:nanlim]);

        set(hax,'YTickLabel',F(I(1:10:end)));
        set(hax,'XtickLabel',T(1:10:nanlim));
        ylabel('Frequency [Hz]');
        xlabel('Time [ms]');
        yrange = I(1 : 10 :end);
        hold on

        plot(repmat(xevent,1,length(yrange)),yrange,'r');
       
    else
        fprintf('number of traces used for the average is below threshold %d \n',Args.nlimit);
        imagesc(ones(300,300))
    end
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


