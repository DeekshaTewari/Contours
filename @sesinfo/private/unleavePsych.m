function sesinfo = unleavePsych(sesinfo,nfiles)
%SESINFO/UNLEAVE1 Rearrange trial numbers into salience values
%	S = UNLEAVE1(S) takes a SESINFO object S and unleaves the trial
%   sequence into salience values. This function unleaves version 1 
%   of the interleaved sequence.
%
%   Dependencies: None.

% get number of salience conditions
stimsteps = sesinfo.data.stimsteps;
stimsets = sesinfo.data.stimsets;
tcatch = sesinfo.data.catchtrials;
isequence = sesinfo.data.isequence;

ncond = stimsteps + tcatch;
% create array to store indices for each salience condition
nrows = ceil(nfiles/ncond);
saledges = [0:(stimsteps+tcatch)] * stimsets;
% take the histogram to get the bin indices
[n,binind] = histc(isequence,saledges);
salindices = zeros(nrows,ncond);
for condi = 1:ncond
    % get the indices that match each binidx
    bi = find(binind==condi);
    % get the length of bi
    bil = length(bi);
    % set the indices in salindices
    salindices(1:bil,condi) = bi;
end
% separate salindices into contour, control, catchcontour, and catchcontrol
stimstepind = 1:stimsteps;
sesinfo.data.sequence.contour = salindices(:,stimstepind);
sesinfo.data.sequence.control = [];
if(tcatch)
    sesinfo.data.sequence.catchcontour = salindices(:,stimsteps+1);
else
    sesinfo.data.sequence.catchcontour = [];
end

sesinfo.data.sequence.catchcontrol = [];
sesinfo.data.sequence.tuning = [];
