function [syncs,scanlines,maxscanline] = ContoursPresenterTiming(varargin)
%ContoursPresenterTiming Check syncs and scanlines for a session
%   [SYNCS,SCANLINES,MAX_SCANLINE] = ContoursPresenterTiming looks 
%   for trials and cycles in the current session directory where the 
%   number of syncs and the scanlines were abnormal. The problem 
%   trials and cycles are returned in SYNCS and SCANLINES, with the 
%   first column in each representing the trial, the second column 
%   representing the cycle number, and the third column the number 
%   of syncs or the scanline that was abnormal. By default, this 
%   function assumes the vertical resolution of the monitor is 1024 
%   and thus identifies scanlines smaller than 1000 to be abnormal.
%   The maximum number for scanlines is also returned to allow
%   estimation of the actual number of scanlines in a refresh.
%
%   [SYNCS,SCANLINES,MAX_SCANLINE] = ContoursPresenterTiming(SCANLINE_LIMIT) 
%   allows the user to specify the scanline limit.
%
%   Dependencies: None.

scanlinelimit = 1000;

switch nargin
case 1
    scanlinelimit = varargin{1};
end    

% get session name
flist = nptDir('*_syncs.txt');
if size(flist,1)==1
	[path,filename,ext] = nptFileParts(flist(1).name);
	fnl = length(filename);
	sessionname = filename(1:fnl-6);
end

scanFN = [sessionname '_scanlines.txt'];

% read syncs and scanlines files
sync = csvread(flist(1).name);
scan = csvread(scanFN);

% get indexes that separate the trials
trialsep = find(sync(:,2)==0);

% get number of trials
trials = length(trialsep);
% get number of cycles
cycles = length(sync)/trials;

% get the onset syncs first since it is usually 0 and we just need to find
% cases when it is not 0
% this will get us syncs for the first cycle of each trial
onsetsync = sync(trialsep,3);
% find the non-zero entries. osi will correspond to the trial number
% and oxy will give us the number of syncs in that trial
[osi,osj,osy] = find(onsetsync);

% now look at the rest of the syncs
synci = find(sync(:,3)>1);

% now check for scanlines smaller than scanlinelimit
scan3 = scan(:,3);
% -1 is used to initialize the scanlines array in Presenter so we want to
% look only at the entries larger than 0
scani = find(scan3<scanlinelimit & scan3>0);

% now convert indices to trial and cycle number
% we want to concatenate the 2 vectors into 1 vector for simplicity
% so we first grab the length of synci
lsynci = length(synci);
% concatenate vectors
sysci = [synci;scani];

% get trial number
tsysc = fix(sysci ./ cycles) + 1;

% get cycle number
csysc = mod(sysci,cycles);

% concatenate onset syncs with the rest of the syncs. Build matrix with
% trial number in the 1st column, cycle number in the second column
% and the problem sync in the 3rd column. 
% for the onset syncs, osi represents trial numbers, and since osj is a 
% vector with all 1 we subtract 1 to get a zero vector of the right length, 
% and then put osy (number of syncs) in the third column.
% for the other syncs, we put the first lsynci rows of tsysc and csysc as 
% the 1st 2 columns and then index into sync to get the number of syncs.
syncs = [osi (osj-1) osy;tsysc(1:lsynci) csysc(1:lsynci) sync(synci,3)];

% build scanlines matrix
lscan = lsynci + 1;
scanlines = [tsysc(lscan:end) csysc(lscan:end) scan(scani,3)];

maxscanline = max(scan(:,3));