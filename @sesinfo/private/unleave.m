function sesinfo = unleave1(sesinfo,nfiles)
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

stimsteps2 = stimsteps * 2;
ncond = stimsteps2 + (tcatch * 2);
% create array to store indices for each salience condition
nrows = ceil(nfiles/ncond);
if(tcatch)
	% indices corresponding to start of each salience condition
	saledges = [0:stimsteps2 stimsteps2+[0.5 1]] * stimsets;
else
    saledges = [0:stimsteps2] * stimsets;
end
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
sesinfo.data.sequence.control = salindices(:,stimstepind+stimsteps);
if(tcatch)
    sesinfo.data.sequence.catchcontour = salindices(:,stimsteps2+1);
    sesinfo.data.sequence.catchcontrol = salindices(:,stimsteps2+2);
else    
    sesinfo.data.sequence.catchcontour = [];
    sesinfo.data.sequence.catchcontrol = [];
end

% now unleave the tuning stimuli if it was used
if sesinfo.data.includetuning
    % set up edges to separate out the tuning stimuli
	% the tuning trials in this version are all in the control trials
    tunstart = saledges(stimsteps+1);
    tunend = saledges(end);
    numtun = tunend - tunstart;
    tundirs = sesinfo.data.numtuningdir;
    tunstep = numtun / tundirs;
    tunedges = tunstart:tunstep:tunend;
    [n2,tbinidx] = histc(isequence,tunedges);
    % create memory for tuning indices
    tunindices = zeros(tunstep,tundirs);
    for ti = 1:tundirs
        tbi = find(tbinidx==ti);
        tbil = length(tbi);
        tunindices(1:tbil,ti) = tbi;
    end
    sesinfo.data.sequence.tuning = tunindices;
else
	sesinfo.data.sequence.tuning = [];
end
