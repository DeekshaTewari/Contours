% demo
% figure 1
figure
cd /Volumes/STREAMB/Data/Neural/Clark
load nptdata
% figure 2
InspectGUI(nd,'Objects',{'performance',{}; ...
	'bias',{'rt','flat','salience',1}; ...
	'bias',{'rt','flat','salience',2}; ...
	'bias',{'rt','flat','salience',3}}, ...
	'SP',[1 4]);
cd 081303
cd 04/sort
load g0001sua01_ispikes
isp1 = obj;
load g0001sua02_ispikes
isp2 = obj;
clear obj
cd ../eye
load eyestarget
onsets = round(et.onsetsMS);
ej = eyejitter('auto','onsets',onsets,'offsets',onsets+100);
ej = set(ej,'HoldAxis',0);
sc = getSpikeCounts(isp1,'DataStart',506,'DataEnd',606);
% figure 3
figure
plot(et,1,'ispikes',{isp1,isp2},'correct');
% figure 4
figure
plot(et,1,'ispikes',{isp1},'correct');
% figure 5
figure
plot(et,1,'ispikes',{isp2},'correct');
% figure 6
InspectGUI(et,'XY','Calib')
% figure 7
InspectGUI(ej,'ShowRaw','HoldPlot')
% figure 8
figure
plot(ej);
trials1 = et.sequence.contour(1);
ctrials = et.sequence.control(1);
tctrials = [et.sequence.contour; ctrials];
% figure 9
figure
subplot(2,3,1)
plot(ej,'Trials',tctrials,'Responses',sc(tctrials),'mesh');
subplot(2,3,2)
plot(ej,'Trials',trials1,'Responses',sc(trials1),'mesh');
subplot(2,3,3)
plot(ej,'Trials',ctrials,'Responses',sc(ctrials),'mesh');
subplot(2,3,4)
plot(ej,'Trials',tctrials,'Responses',sc(tctrials),'imagesc');
subplot(2,3,5)
plot(ej,'Trials',trials1,'Responses',sc(trials1),'imagesc');
subplot(2,3,6)
plot(ej,'Trials',ctrials,'Responses',sc(ctrials),'imagesc');
% figure 10
figure
subplot(1,3,1)
plot(ej,'Trials',tctrials,'Responses',sc(tctrials));
subplot(1,3,2)
plot(ej,'Trials',trials1,'Responses',sc(trials1));
subplot(1,3,3)
plot(ej,'Trials',ctrials,'Responses',sc(ctrials));
