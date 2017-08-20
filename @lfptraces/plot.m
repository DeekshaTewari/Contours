function obj = plot(obj,varargin)
%   @lfptraces/plot plots by default the first raw lfp trace
%   Other option are :
%
% - spectrogram: plots a spectrogram from the trace. By default,
%   it uses the multi taper method. If this option is followed 
%   by 'fft', it will use the traditional fast Fourier instead.
%   The parameters 'window' (128 ms),'noverlap'(118 ms),'nfft' (512),
%   'NW' (2),'k' (3) can be specified. Defaults are shown in parentheses.
%   Another option is 'normalized', which will transform the 
%   spectrogram in a Z-score (the mean and standard deviation are 
%   calculated from a period that can be specified by the arguments
%   'bstart' and 'bend', which are by default 1 and 300 ms, respectively).
%   Finally, the colorscale (default [-50 50 ) can be specified with
%   'colorscale'.
%   
% - TrialTraces: plots all the traces of the session. This option 
%   should be followed by 'TrialType' (-1,0,1,2) to specify the 
%   trial type to plot. Additional arguments can be used:
%   'response',1,'salience',1,'channel',1.   
%
% - 'SacAlign' will align all the data according to the onset of the
%   saccade and can be combined with the arguments above.
%
%   Dpendencies: alignData, spectrogram, mtspecgramc
%
%

Args = struct('fft',0,'spectrogram',0,'TrialTraces',0,'SacAlign',0,'normalized',0,'colorscale',[-10 100],'bstart',1,'bend',300,'window',128,'noverlap',118,'nfft',512,'Flimit',100,'NW',2,'k',3);
Args.flags = {'spectrogram','TrialTraces','SacAlign','fft','normalized'};
[Args,varargin2] = getOptArgs(varargin,Args,'remove',{'spectrogram','TrialTraces','SacAlign','fft','normalized'});

[numevents,dataindices,Mark] = get(obj,'Number',varargin2{:});


step = (Args.window - Args.noverlap);
params.tapers = [Args.NW Args.k];

bstart = round(Args.bstart/step) + 1;
bend = round(Args.bend/step) -1;

if Args.TrialTraces
    if (~isempty(Args.NumericArguments))
        n = Args.NumericArguments{1};
        ind  = find(dataindices(:,1) == n);
        limit = dataindices(ind,3);
    else
        n = numevents;
        limit = dataindices(:,1);
    end
    if Args.SacAlign
        events = obj.data.RT(limit) + obj.data.TargetOnset(limit);
        b = 300;

    else
        events = obj.data.TargetOnset(limit);
        b = 400;
    end
    SR = unique(obj.data.SamplingRate(dataindices(ind,1)));
    params.Fs = SR;

    if ~isempty(ind)
        [traces,error] = alignData(obj.data.LFP(limit,:),events,'before',b);
        [order,sind] = sort(obj.data.RT(limit));
        limit =limit(sind);
        if Args.spectrogram

            maxxlim = [];
            maxylim = [];
            maxzlim = [];
            for i = 1 : length(limit)

                if Args.fft
                    [S,F,T,P{i}] = spectrogram(traces(i,~isnan(traces(i,:))),Args.window,Args.noverlap,Args.nfft,SR);
                else
                    [S,T,F] = mtspecgramc(traces(i,~isnan(traces(i,:)))',[Args.window/SR step/SR],params);
                    P{i} = S';
                    F = F';
                    T = T';
                end
                if Args.normalized
                    baseline = std(P{i}(:,bstart:bend),0,2);
                    baselinem = mean(P{i}(:,bstart:bend),2);
                    P{i} = (P{i} - (repmat(baselinem,1,size(P{i},2))))./(repmat(baseline,1,size(P{i},2)));
                end
                I = find(F <= Args.Flimit);
                maxxlim = max([maxxlim size(P{i},2)]);
                maxylim = max([maxylim length(I)]);
                maxzlim = max([maxzlim max(max(P{i}))]);
            end

            allP = nan(length(limit) * maxylim,maxxlim);
            ytick = [];
            for i = 1 : length(limit)
                xt = size(P{i},2);
                allP((i-1)* maxylim + 1 : (i-1)* maxylim + maxylim, 1 : xt) = P{i}(1: maxylim,1:xt);
                ytick = [ytick; I(1:500:end)+(i-1)*maxylim];
            end

            T = T * 1000; % to have th evalues in ms
            imagesc(allP,Args.colorscale)
            hold on
            hax = gca;

            set(hax,'YLim',[0.5 size(allP,1)+0.5]);

            set(hax,'YTick',ytick);

            set(hax,'Xtick',[1:10:length(T)]);

            set(hax,'YTickLabel',repmat(F(I(1:50:end)),length(limit),1));
            set(hax,'XtickLabel',T(1:10:end));
            ylabel('Frequency [Hz]');
            xlabel('Time [ms]');
            range = maxylim;
            xxlim = maxxlim;
        else
            maxlim = max(max(traces));
            minlim = min(min(traces));
            range = floor(maxlim - minlim);
            nnan = sum(~isnan(traces),1);
            xxlim = find(nnan == 0);
            if ~isempty(xxlim)
                xxlim = xxlim;
            else
                xxlim = size(traces,2);
            end
        end


        x = [0 : (xxlim(1)-1) ];
        for i = 1 : length(limit)
            RT = round(obj.data.RT(limit(i)));
            if Args.spectrogram

                if Args.SacAlign
                    b2 = ceil((b - RT - Args.window/2) / step) + 1;
                else
                    b2 = ceil((b + RT - Args.window/2) / step) + 1;
                end
                plot(repmat(b2,1,maxylim), [(i-1) * maxylim + 1 : (i-1) * maxylim + maxylim],'r--');

            else
                plot(x,traces(i,1:xxlim(1)) + (i-1) * range);
                if Args.SacAlign
                    b2 = round(b - RT);
                else
                    b2 = round(b + RT);
                end
                hold on
                plot(x,ones(1,xxlim(1)) * (i-1) * range,'k--');
                plot(repmat(b2,1,range+1), [-range/2 + (i-1) * range : range/2 + (i-1) * range],'r--');
                axis([0 xxlim(1) -range/2 length(limit)*range]);
                allrange = ceil(-range/2) : floor(length(limit)*range);
            end


        end
        if Args.spectrogram
            b = ceil((b - Args.window/2) / (Args.window - Args.noverlap)) + 1;
            allrange = [1 : size(allP,1)];

        end

        plot(repmat(b,1,length(allrange)),allrange,'r')
        hold off
    else
        plot(NaN)
    end
    fprintf('%s \n',obj.data.setNames{unique(dataindices(ind,1))})

else




    if (~isempty(Args.NumericArguments))
        n = Args.NumericArguments{1};
        ind  =  n;
        limit = dataindices(ind,3);
    else
        n = numevents;
        limit = dataindices(:,1);
    end

    if length(limit) == 1;
        if Args.spectrogram
            SR = unique(obj.data.SamplingRate(dataindices(ind,1)));
            params.Fs = SR;

            if Args.fft
                [S,F,T,P] = spectrogram(obj.data.LFP(limit,~isnan(obj.data.LFP(limit,:))),Args.window,Args.noverlap,Args.nfft,SR);

            else
                [S,T,F] = mtspecgramc(obj.data.LFP(limit,~isnan(obj.data.LFP(limit,:)))',[Args.window/SR step/SR],params);
                P = S';
                F = F';
                T = T';
            end
            if Args.normalized
                baseline = std(P(:,bstart:bend),0,2);
                P = P./(repmat(baseline,1,size(P,2)));
                baseline = std(P(:,bstart:bend),0,2);
                baselinem = mean(P(:,bstart:bend),2);
                P = (P - (repmat(baselinem,1,size(P,2))))./(repmat(baseline,1,size(P,2)));
            end
            T = T * 1000; % to have th evalues in ms
            imagesc(P,Args.colorscale);
            hax = gca;
            I = find(F <= Args.Flimit);
            set(hax,'YLim',[0.5 I(end)+0.5]);
            set(hax,'YTick',I(1:10:end));

            set(hax,'Xtick',[1:10:length(T)]);

            set(hax,'YTickLabel',F(I(1:10:end)));
            set(hax,'XtickLabel',T(1:10:end));
            ylabel('Frequency [Hz]');
            xlabel('Time [ms]');
            yrange = I(1 : 10 :end);
            hold on
            sac = ceil((obj.data.RT(limit) + obj.data.TargetOnset(limit) - Args.window/2)/step);
            stim = ceil((obj.data.TargetOnset(limit)- Args.window/2)/step);
            plot(repmat(sac,1,length(yrange)),yrange,'r--');
            plot(repmat(stim,1,length(yrange)),yrange,'r');
            
            hold off
        else
            nnan = ~isnan(obj.data.LFP(limit,:));
            xxlim = find(nnan == 0);
            x = [0 : xxlim(1) - 1];
            
            plot(x,obj.data.LFP(limit,1:xxlim(1)));
            xlabel('Time [ms]')
            ylabel('Voltage [uV]')
            yrange = [ceil(min(obj.data.LFP(limit,:))) : floor(max(obj.data.LFP(limit,:)))];
            hold on
            plot(repmat(obj.data.RT(limit) + obj.data.TargetOnset(limit),1,length(yrange)),yrange,'r--');
            plot(repmat(obj.data.TargetOnset(limit),1,length(yrange)),yrange,'r');
            axis([Args.window/2-step/2 (xxlim(1)-1-Args.window/2-step/2) -500 500])
            hold off
        end

        title(sprintf('%s/trial %d',obj.data.setNames{dataindices(ind,1)},dataindices(ind,2)));
    else
        fprintf('Warning!! The @lfptraces/get selected more than one trace \n');
    end
end