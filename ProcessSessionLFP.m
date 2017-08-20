function [data,events,varargout] = ProcessSessionLFP(bi,SR,varargin)
% process the session lfp data. The output data is a
% structure with the following fields:
%
% - LFP = lfp time serie in uV (single precision).
% - Index = index in the format c x 2. First column is the session number
%           and the second column is the channel number.
% - RT = reaction times in ms.
% - results = type of saccadic response coded as the following: 
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
% - TrialType = type trials coded as followed:
%                             -1 catch control
%                              0 catch contour
%                              1 control
%                              2 contour
% - OriJitter = orijitter;
% - salience = salience;
% - SamplingRate = sampling_rate;
% - TargetOnset = target';
% - Nchannels = num_channels;
% 
% Trial types :


amplification = 2000 /1000 ; % 4000 due to the amplifier and 1000 due to the change from mV to uV
numTrials = min([length(bi.rt) length(bi.results)]);
maxpoints = 3000;% max(points);
files = nptDir;
totc = 0;
for t = 1 : numTrials

    [lfp{t},num_channels,sampling_rate,scan_order,points(t)]=nptReadStreamerFile(files(t).name);

end



Tonsets = bi.onsets/(SR/sampling_rate); % assumes that the sampling used the bi object is 30000 Hz


allrt = bi.rt;
allresults = bi.results;
alljitter = bi.stim_p;

trialtypes{4} = bi.sequence.contour;
trialtypes{3} = bi.sequence.control;
trialtypes{2} = bi.sequence.catchcontour; 
trialtypes{1} = bi.sequence.catchcontrol;
trialcode{1} = '-1 catch control';
trialcode{2} = ' 0 catch contour';
trialcode{3} = ' 1 control';
trialcode{4} = ' 2 contour';
trialcode{5} = 'or indices -2 contour';

LFP = [];
Index = [];
RT = [];
results = [];
orijitter = [];
salience = [];
Ttype = [];
events = 0;
target = [];
for t = 1 : numTrials
    fprintf('%d ',t)
    for ch = 1 : num_channels
        lfpnan = ones(1,maxpoints) * NaN;
        lfpnan(1:size(lfp{t}(ch,:),2)) = lfp{t}(ch,:); 
        LFP = [LFP;lfpnan];
        
        lindex = [1 t t ((t-1)*num_channels + ch)];
        Index = [Index;lindex];

        RT = [RT;allrt(t)];

        results = [results;allresults(t)];

        notfound = 0;
        type = 1;
        while notfound == 0

            [r,c] = find(t == trialtypes{type});
            if ~isempty(r)
                trial = (type - 2);
                notfound = 1;
            end
            type = type + 1;
        end
        Ttype = [Ttype;trial];
        orijitter = [orijitter;alljitter(c)];
        salience = [salience;c];
        events = events + 1;
        target = [target;Tonsets(t)];
    end
end

LFP = LFP / amplification; % 
data.LFP = single(LFP);
data.Index = Index;
data.RT = RT;
data.results = results;
data.TrialType = Ttype;
data.OriJitter = orijitter;
data.salience = salience;
data.SamplingRate = sampling_rate;
data.TargetOnset = target;
data.Nchannels = num_channels;


varargout{1} = trialcode;
