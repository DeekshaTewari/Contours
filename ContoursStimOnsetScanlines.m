function stimOnset = ContoursStimOnsetScanlines(vpos)
%ContoursStimOnsetScanlines Function to determine stimulus onset to scanline accuracy
%   STIM_ONSET = ContoursStimOnsetScanlines(VERTICAL_POS) returns the 
%   datapoint corresponding to the stimulus onset. This will usually 
%   correspond to the Presenter trigger unless the scanline on which
%   the update occurred exceeds VERTICAL_POS. In that case, the data
%   point corresponding to the next sync will be used.

% need time of presenter trigger, sync-datapoint table, and sync and 
% scanline analysis

% load timing data
fname = nptDir('*timing.mat');
fsize = size(fname,1);
if fsize==1
	t = load(fname(1).name);
else
	error('No timing.mat file found');
end

% get presenter trigger onsets, grab first column in case there are more
% than 1 presenter trigger
stimOnset = t.presTrigOnsets(:,1);

% get presenter timing
[syncs,scanlines,maxsl] = ContoursPresenterTiming;

% sequence on Presenter is:
% Cycle = 0;
% Trial++;
% CommModule->DataAcqTrigger(true);
% CommModule->ElapsedSyncs(); // reset to 0
% lpPalette->SetEntries(...);
% GetScanLine(&Scanlines[Trial][Cycle]);
% Syncs[Trial][Cycle] = CommModule->ElapsedSyncs();
% Cycle++;

% check to see if there were any problems with the first cycle
scp = find(scanlines(:,2)==1);
scpSize = length(scp,1);
for i=1:scpSize
	% check to see if the scanline number is larger than vpos
	if scanlines(scp(i),3)>vpos
		% get trial number for the trial with problem
		trial = scanlines(scp(i),1);
		% get the syncs for that trial
		tsyncs = t.syncOnsets(trial,:);
		% find the sync point that is larger than the Presenter trigger
		tsi = find(tsyncs>stimOnset(trial));
		% adjust stimOnset using syncOnsets	
		stimOnset(t) = tsyncs(tsi(1));
	end
end

% should perhaps compute onset relative to vpos and the actual number of scanlines
