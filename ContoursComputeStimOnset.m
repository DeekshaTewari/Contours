%function to determine stimulus onset for all trials
% specify argument to determine if scanline needs to be accounted for
% since psychophysical data probably won't need it

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

% get presenter trigger onsets
stimOnset = t.presTrigOnsets;

% get presenter timing
[syncs,scanlines] = ContoursPresenterTiming;

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
scp = find(scanlines(:,2)==0);
scpSize = length(scp,1);
for 1:sypSize
	% adjust stimOnset using syncOnsets
	
	