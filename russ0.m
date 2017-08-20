diary on
warning off MATLAB:divideByZero
% get path to cpdescriptor
tname = which('cpdescriptor.tcsh');
doscommand = ['\cygwin\bin\tcsh ' tname ' "( ?? )" ..\070703\01\disco07070301_descriptor.txt'];
dos(doscommand);
% ProcessDay(nptdata,'nptSessionCmd','[p,s] = nptFileParts(pwd); [q,d] = nptFileParts(p); copyfile(''../../070703/01/disco07070301_descriptor.txt'',[''disco'' d s ''_descriptor.txt''])');
ProcessDay('eye','timing','cygwinmove')
pf = ProcessDay(performance,'savelevels',5,'ignorediff');
tm = ProcessDay(timing,'savelevels',5,'ignorediff');
bi = ProcessDay(bias,'savelevels',5,'ignorediff');
% save objects
save performance pf
save timing tm
save bias bi
% show plots
InspectGUI(bi,'rt','overallonly','salience','catch')
InspectGUI(bi,'rt','overallonly','salience',6)
InspectGUI(bi,'rt','overallonly','salience',5)
InspectGUI(bi,'rt','overallonly','salience',4)
InspectGUI(bi,'rt','overallonly','salience',3)
InspectGUI(bi,'rt','overallonly','salience',2)
InspectGUI(bi,'rt','overallonly','salience',1)
InspectGUI(bi,'rt','overall')
InspectGUI(bi,'overallonly','salience','catch')
InspectGUI(bi,'overallonly','salience',6)
InspectGUI(bi,'overallonly','salience',5)
InspectGUI(bi,'overallonly','salience',4)
InspectGUI(bi,'overallonly','salience',3)
InspectGUI(bi,'overallonly','salience',2)
InspectGUI(bi,'overallonly','salience',1)
InspectGUI(pf,'overall')
diary off
