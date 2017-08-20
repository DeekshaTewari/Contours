diary on
warning off MATLAB:divideByZero
% get path to cpdescriptor
tname = which('cpdescriptor.tcsh');
[s,w] = system([tname '  "( *[0-9][0-9] )" /Data/clark/050510/session01/clark05051001_descriptor.txt']);
% doscommand = ['\cygwin\bin\tcsh ' tname ' "( *[0-9][0-9] )" /Data/clark/050324/session01/clark05032401_descriptor.txt'];
% dos(doscommand);
% ProcessDay(nptdata,'nptSessionCmd','[p,s] = nptFileParts(pwd); [q,d] = nptFileParts(p); copyfile(''../../070703/01/disco07070301_descriptor.txt'',[''disco'' d s ''_descriptor.txt''])');
ProcessDay('eye','timing')%,'eyeSessions',{'../091902/01'},'redo')
% ProcessDay(nptdata,'nptSessionCmd','performance(''auto'',''savelevels'',5);timing(''auto'',''savelevels'',5);bias(''auto'',''savelevels'',5);');
% nd = ProcessDay(nptdata,'nptSessionCmd','robj = nptdata(0,0,''Eval'',''ispresent(''''performance.mat'''',''''file'''')'');');
% % save object
% save nptdata nd
% % show plots
% InspectGUI(nd,'Objects',{{'performance'};{'bias',{'rt','flat','salience',1}};{'bias',{'rt','flat','salience',2}};{'bias',{'rt','flat','salience',3}}},'SP',[1 4]);
% diary off
