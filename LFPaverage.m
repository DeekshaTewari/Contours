function [average,n,before,meanSTD,varargout] = LFPaverage(ep,TrialType,response,salience,channel,events,varargin)
% Function LFPaverage computes an averaged evoked potential, spectrogram or
% cohgram. This last arguments needs to be specified as following (default
% output for all the cases is DATA.AVERAGE, DATA.BEFORE and N (# of elements
% averaged) if the # of trials is zero the output if NaN):
%
% - 'EP' : coomputes the evoked potential.
%
% - 'spectrogram' : computes the spectrogram. Optional output F, step and window
%                   for the frequency scale, step size and window size respectively.
%
% - 'cohgram' : computes the cohgram. Optional output F, step, window and
%               ang for the frequency scale, step size, window size and the angular
%               info respectively.
%
% - 'fft' : uses standard fft methods to compute spectrums. By default, it
%           uses the multi-taper (chronux toolbox).
%
% Inputs :
%
% - ep : @lfptraces object
%
% - Trial types : types of trials coded as following :
%
%                 -1 catch control
%                  0 catch contour
%                  1 control
%                  2 contour
%
% - Response : types of behavioral responses to be studied. Those
%               are coded as the following :
%
%               0 - no saccades
%               1 - single saccade to target window within MATCH_TIME
%                 (default is 300 ms)
%               2 - multiple saccades all within target window with first
%                 saccade within MATCH_TIME
%               -1 - single saccade to any other location other than target window
%               -2 - single saccade to target window but not within MATCH_TIME
%               -3 - multiple saccades all within target window but first saccade
%                  was not within MATCH_TIME
%               -4 - multiple saccades with at least one saccade to a location
%                  outside the target window
%
% - salience : salience level (from 1 to 3 for the contour and control,
%              use 1 for the catch trials)
%
% - events : a vector of time points of same length than size(ep.data.LFP,1).
%            Those events are going to be used to align the LFP traces accordingly
%            to those events.
%
% The following parameters can be specified:
%
% - window : sliding window used for the spectrogram (default is 128)
%
% - noeverlap : number of overlapped point for the spectrogram (default is
%               118)
% - nfft : number of point used for the fast fourier transform
%          (zero-padded). Default is 1000.
%
% - before : Number of points shown before the event onset. Default is 300.
%
% - maxpoints : number of points used in total. Default is 1000. This number needs
%               to be bigger or equal than the length of the
%               longest LFP traces
%
% Dependencies : cohgram, cohgramc, mtspecgramc.

Args = struct('fft',0,'EP',0,'spectrogram',0,'cohgram',0,'normalized',0,'basecut',50,'before',[],'window',128,'noverlap',118,'nfft',512,'maxpoints',1000,'NW',2,'k',3,'Flimit',200);
Args.flags = {'spectrogram','cohgram','EP','fft','normalized'};
[Args,modvarargin] = getOptArgs(varargin,Args,'remove',{'EP','cohgram','spectrogram','fft','normalized'});

window = Args.window;
noverlap = Args.noverlap;
stepms = window-noverlap;
nfft = Args.nfft;
srate = 1000; % sampling rate
mindist = Args.maxpoints/ (window - noverlap); % takes a maximum of 500 points after cue onset to be used in the analysis


ind = getTrials(ep,TrialType,response,salience,channel,modvarargin{:});

if Args.normalized
    before = 500;
    cut = round(((before - Args.before)-(window/2))/stepms);
else
    before = Args.before;
    cut = 1;
end

if ~isempty(ind)
    [data,error,before] = alignData(ep.data.LFP(ind,:),events(ind),'maxpoints',Args.maxpoints,'before',before,modvarargin{:});
    bcut = round(Args.basecut/stepms);
    nbaset = round((before-(window/2))/stepms) - bcut;
    data = double(data);
    meanSTD(:,1) = nanmean(ep.data.RT(ind));
    meanSTD(:,2) = nanstd(ep.data.RT(ind));
    if error == 1
        if Args.EP
            average = nanmean(data,1);

        end
        if Args.spectrogram

            dummy = nan(nfft/2 + 1,mindist,length(ind));
            for nt = 1 : length(ind)
                if ~isempty(data(nt,~isnan(data(nt,:))))
                    if Args.fft
                        [S,F,T,P] = spectrogram(data(nt,~isnan(data(nt,:))),window,noverlap,nfft,srate);
                    else
                        step = (window - noverlap)/srate;
                        params.tapers = [Args.NW Args.k];
                        params.Fs = srate;
                        [S,T,F] = mtspecgramc(data(nt,~isnan(data(nt,:)))',[window/srate step],params);
                        P = S';
                    end
                    P = P .* repmat(vecc(F),1,size(P,2));
                    if size(P,2) > (before/stepms)
                        if Args.normalized
                            warning off MATLAB:divideByZero
                            baselinestd = std(P(:,1+bcut:nbaset),0,2);
                            baselinem = mean(P(:,1+bcut:nbaset),2);
                            before = Args.before;
                            P = (P - repmat(baselinem,1,size(P,2))) ./(repmat(baselinestd,1,size(P,2)));
                        end
%                         dummy(cut:size(P,1),1:size(P,2),nt) = P;
                            dummy(:,cut:size(P,2),nt) = P(:,cut:size(P,2));
                    end
                end

            end
            varargout{1} = vecr(F);
            varargout{2} = window-noverlap;
            varargout{3} = window;
            average = nanmean(dummy,3);
        end

        n = length(ind);

        if Args.cohgram
            if length(channel) == 2
                ntrial = floor(size(data,1)/2);
                dummy = nan(nfft/2 + 1,mindist,ntrial);
                dumang = nan(nfft/2 + 1,mindist,ntrial);
                nch = length(channel);
                nnan = isnan(data(1 : nch : end,:));
                startnan = find(sum(nnan,1) ~= 0);
                if ~isempty(startnan)
                    limit = startnan(1)-1;
                else
                    limit = Args.maxpoints;
                end
                wlimit = floor((limit - window) / (window-noverlap)) + 1;
                wlimit = min([wlimit mindist]);
                step = (window - noverlap)/srate;
                params.tapers = [Args.NW Args.k];
                params.Fs = srate;
%                 params.trialave = 1;
                for t = 1 : ntrial
                    if Args.fft
                        [P,Ang,F,T] = cohgram(data((t-1)*2 +1,1 : limit)',data((t-1)*2 +2,1 : limit)',nfft,srate,window,noverlap);
                    else

                        [S,A,S12,S1,S2,T,F] = cohgramc(data((t-1)*2 +1,1 : limit)',data((t-1)*2 +2,1 : limit)',[window/srate step],params);
                        P = S';
                        Ang = A';
                    end
                    
                    if size(P,2) > (before/stepms)
                        if Args.normalized
                             warning off MATLAB:divideByZero
                            baselinestd = std(P(:,1+bcut:nbaset),0,2);
                            baselinem = mean(P(:,1+bcut:nbaset),2);
                            P = (P - repmat(baselinem,1,size(P,2))) ./(repmat(baselinestd,1,size(P,2)));
                            
                            baselinestd = std(Ang(:,1+bcut:nbaset),0,2);
                            baselinem = mean(Ang(:,1+bcut:nbaset),2);
                            Ang = (Ang - repmat(baselinem,1,size(P,2))) ./(repmat(baselinestd,1,size(P,2)));
                            before = Args.before;
                        end
                        dummy(:,cut:wlimit,t) = P(:,cut:wlimit);
                        dumang(:,cut:wlimit,t) = Ang(:,cut:wlimit);
                    end
                end
                varargout{1} = vecr(F);
                varargout{2} = window-noverlap;
                varargout{3} = window;
                varargout{4} = nanmean(Ang,3);
                average = nanmean(dummy,3);
                n = ntrial;
            else
                error('Please choose 2 channels only \n');
                average = nan(nfft/2 + 1,mindist);
                n = NaN;
                before = NaN;
                freqres = srate / nfft;
                varargout{1} = vecr([0 : freqres : freqres * nfft/2]);
                varargout{2} = window-noverlap;
                varargout{3} = window;
                varargout{4} = nan(nfft/2 + 1,mindist);
            end
        end

    else

        if Args.EP
            average = nan(1,size(ep.data.LFP,2));
        else
            average = nan(nfft/2 + 1,mindist);
        end
        n = NaN;
        before = NaN;
    end
else

    fprintf('No trial found that satisfies the searching parameters \n');
    if Args.EP
        average = nan(1,Args.maxpoints);
    else
        average = nan(nfft/2 + 1,mindist);
    end
    freqres = srate / nfft;
    varargout{1} = vecr([0 : freqres : freqres * nfft/2]);
    varargout{2} = window-noverlap;
    varargout{3} = window;
    n = 0;
    before = NaN;
    meanSTD = nan(1,2);
end
















