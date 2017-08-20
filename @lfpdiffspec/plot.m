function obj = plot(obj,varargin)
%   @lfptraces/plot
% needs to implement specific selection of sessions
%   Dpendencies:
%
%
Args = struct('salience',1,'both',0,'diff1',0,'diff2',0,'Flimit',200,'colorscale',[0 50]);
Args.flags = {'both','diff1','diff2'};
[Args,varargin2] = getOptArgs(varargin,Args,'remove',{'both','diff1','diff2'});

[numevents,dataindices,Mark] = get(obj,'Number','salience',Args.salience,varargin2{:});


if (~isempty(Args.NumericArguments))
    n = Args.NumericArguments{1};
%     ind  = find(dataindices(:,2) == n);
    limit = dataindices(n,2);
    
else
    n = numevents;
    limit = dataindices(:,1);
end


if length(limit) == 1
    F = obj.data.F(limit,:);
    step = obj.data.step(limit);
    window = obj.data.window(limit);
    
    I = find(F <= Args.Flimit);
    if Args.both

        P1 = squeeze(obj.data.salience(Args.salience).ampl1(limit,:,:));
        P2 = squeeze(obj.data.salience(Args.salience).ampl2(limit,:,:));

        P = [P1(1:I(end),:);P2(1:I(end),:)];
        ndata = 2;
        ytick = [I(1:10:end) I(1:10:end)+length(I)];

    elseif Args.diff1
        P1 = squeeze(obj.data.salience(Args.salience).ampl1(limit,:,:));
        P = P1(1:I(end),:);
        ytick = I(1:10:end);
        ndata = 1;
    elseif Args.diff2
        P2 = squeeze(obj.data.salience(Args.salience).ampl2(limit,:,:));
        P = P2(1:I(end),:);
        ytick = I(1:10:end);
        ndata = 1;
    else
        P = squeeze(obj.data.salience(Args.salience).ks(limit,:,:));
        ndata = 1;
        ytick = I(1:10:end);

    end

    nanlimt = find((sum(~isnan(P),1)) == 0);
    nanlim = nanlimt(1)-3;
    if nanlim ~= 0
    T = [0 : step : (size(P,2)-1) *step];

    imagesc(P(:,1:nanlim),Args.colorscale);
    hax = gca;
    
    set(hax,'YLim',[0.5 size(P,1)+0.5]);% set(hax,'YLim',[0.5 I(end)+0.5]);

    set(hax,'YTick',ytick);

    set(hax,'Xtick',[1:5:nanlim]);

    set(hax,'YTickLabel',repmat(F(I(1:10:end)),1,ndata));% set(hax,'YTickLabel',F(I(1:10:end)));
    
    set(hax,'XtickLabel',T(1:5:nanlim));
    ylabel('Frequency [Hz]');
    xlabel('Time [ms]');
    yrange = ytick;
   
    end
    fprintf('%s \n',obj.data.setNames{dataindices(n,2)});

end


