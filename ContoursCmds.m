% process eye data, extract spikes, get Presenter trigger timing, create
% KlustaKwik files but don't run KlustaKwik on local file
% instead use remotekk to send KlustaKwik files to ogier for processing
% the remotekke script called by the remotekk option will send the files
% back to the original machine after they are processed by ogier
% 'cygwinmove' is useful on Windows machines but not needed on Unix
% machines
cd 080604; diary([pwd filesep 'diary.txt']); ProcessDay('eye','timing',...
	'extraction','threshold',4,'highpass','cygwinmove','lowpass', ...
	'clustoptions',{'Do_AutoClust','fet'},'remotekk'); diary off

% for annie data without sync channel data
cs = ProcessDays(checksystem,1:336,1:2,1,352,1);

% for clark data with sync channel data
cs = ProcessDays(checksystem,1:336,4:5,2,352,3);

InspectGUI(cs)

% to check eye positions relative to target window for a session
et = eyestarget('auto');
InspectGUI(et,'addObjs',{et},'optArgs',{{},{'XY'}})

% generate behavioral objects
diary on; ProcessDays(nptdata,'nptSessionCmd', ...
	'performance(''auto'',''savelevels'',5);timing(''auto'',''savelevels'',5);bias(''auto'',''savelevels'',5);'); diary off
% get directories with contour data
nd = ProcessDays(nptdata,'nptSessionCmd', ...
	'robj = nptdata(''Eval'',''ispresent(''''performance.mat'''', ...
	''''file'''')'');');
% get directories with more than 1 salience level
[nd,contourDirs] = ProcessDirs(nd,'DataInit',{},'nptDirCmd', ...
	'pf = performance(''auto'');if(size(subsref(pf,struct(''type'',''.'',''subs'',''stim_p'')),2)>1) data = {data{:} pwd}; end')
ndcontours = nptdata('SessionDirs',contourDirs);
InspectGUI(ndcontours,'Objects',{{'performance'}})

load contoursDirs

InspectGUI(ndcontours,'Objects',{{'eyejitter' ...
	{'InFields','FieldMark',1}}})
InspectGUI(ndcontours,'Objects',{{'eyejitter' ...
	{'InFields','Centroid','FieldMark',1}}})

InspectGUI(ndcontours,'Objects',{{'gaborcontours' {}}})
InspectGUI(ndcontours,'Objects',{{'mapfields' {}}})

plot(mfcontours,'Mark',1,'NoOri','NoNumber','FromFix');
plot(mfcontours,'Mark',1,'NoOri','NoNumber','FromFix','UseDegrees');

ndsorted = ProcessDays(nptdata,'GroupDirName','group*','nptCellCmd', ...
	'robj = nptdata(0,0,''Eval'',''~isempty(contourspsth(''''auto'''',''''save'''',''''UseEyeJitterLimits''''))'');');

InspectGUI(ndsorted,'Objects',{{'contourspsth'}})
InspectGUI(ndsorted,'Objects',{{'contourspsth',{'ShowSTD'}}})
InspectGUI(ndsorted,'Objects', ...
	{{'contourspsth',{'ShowSTD'},{'RadiusDegrees',0.3,'UseEyeJitterLimits','redo'}}; ...
	 {'contourspsth',{'EyesTarget','RadiusDegrees',0.3,'UseEyeJitterLimits',1,'XLimitsEval','[round(onset)-150 round(onset)+200]'}}},'SP',[2 1])
InspectGUI(ndcells,'Objects', ...
	{{'contourspsth',{'XLim',[-50 200]}}; ...
	 {'contourspsth',{'EyesTarget','XLimitsEval','[round(onset)-50 round(onset)+200]'}}},'SP',[2 1])

[ndcells,ct100] = ProcessDirs(ndcells,'Object','contourstuning','OnsetWindow',100);

% instantiate ispikes object in appropriate cluster directory
isp1 = ispikes('auto');
% plot spike trains according to salience and sorted by reaction times
plotSalienceSpikes(eyestarget('auto'),'iSpikes',{isp1,isp2})

[ndsessions,ndcells] = ProcessDirs(ndsessions,'nptDirCmd','s = ProcessSession(nptdata,''CellDirName'',''*s'');data = data + s;');
[ndsessions,ndintra] = ProcessDirs(ndsessions,'nptDirCmd','s = ProcessSession(nptdata,''CellDirName'',''*s'',''AnalysisLevel'',''Pairs'',''Intragroup'');data = data + s;');
[ndsessions,ndinter] = ProcessDirs(ndsessions,'nptDirCmd','s = ProcessSession(nptdata,''CellDirName'',''*s'',''AnalysisLevel'',''Pairs'',''Intergroup'');data = data + s;');
[ndsessions,ndmua] = ProcessDirs(ndsessions,'nptDirCmd','s = ProcessSession(nptdata,''CellDirName'',''*m'');data = data + s;');
[ndsessions,ndmuaintra] = ProcessDirs(ndsessions,'nptDirCmd','s = ProcessSession(nptdata,''CellDirName'',''*m'',''AnalysisLevel'',''Pairs'',''Intragroup'');data = data + s;');
[ndsessions,ndmuainter] = ProcessDirs(ndsessions,'nptDirCmd','s = ProcessSession(nptdata,''CellDirName'',''*m'',''AnalysisLevel'',''Pairs'',''Intergroup'');data = data + s;');

InspectGUI(ndcells,'Objects', ...
    {{'gaborcontours',{'Limits',[400 800]}}; ...
     {'contourspsth',{'EyesTarget','XLimitsEval','[round(onset)-50 round(onset)+200]'}}; ...
     {'performance'}; ...
     {'contourspsth',{'XLim',[-50 200]}}; ...
     {'contourstuning'}}, ...
    'SP',[3 2])

ProcessDirs(ndsessions,'nptDirCmd','em = eyemvt(''auto''); et = eyestarget(''auto''); InspectGUI(em,''addObjs'',{et,et},''optArgs'',{{},{},{''XY''}},''SP'',[3 1]);pause;')

InspectGUI(ndmuagrps,'Objects',{{'nptgroup',{'Object',{'contourstuning',{'Normalized'}}},{'CellDirName','*m'}};{'nptgroup',{'Object',{'contourstuning',{'Normalized'}}},{'CellDirName','*s'}}},'SP',[2 1])
