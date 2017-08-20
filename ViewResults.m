cd 060801
cd 08
annie060801s08sesinfo = ContoursGetSessionInfo('annie06080108','0001');

load annie06080108_results
ContoursPlotResult(sesinfo.stim_p,annie06080108_results)
axis([-5 65 0 1])
title('annie06080108 Performance')
xlabel('Orientation Jitter')
ylabel('Performance')

cd sort
load annie060801s08g01
load annie060801s08g02
cd ..

annie060801s08g01us = ContoursUnleaveSpikes(annie060801s08g01,annie060801s08sesinfo);
annie060801s08g02us = ContoursUnleaveSpikes(annie060801s08g02,annie060801s08sesinfo);

annie060801s08g01psth = ContoursNeuCalPSTH(annie060801s08g01us,1);
annie060801s08g02psth = ContoursNeuCalPSTH(annie060801s08g02us,1);

ContoursNeuPlotPSTH(annie060801s08g01psth,1,'contour','catch')
subplot(4,1,1),title('annie060801s08g01 PSTH Contour Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

ContoursNeuPlotPSTH(annie060801s08g01psth,1,'control','catch')
subplot(4,1,1),title('annie060801s08g01 PSTH Control Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

ContoursNeuPlotPSTH(annie060801s08g02psth,1,'contour','catch')
subplot(4,1,1),title('annie060801s08g02 PSTH Contour Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

ContoursNeuPlotPSTH(annie060801s08g02psth,1,'control','catch')
subplot(4,1,1),title('annie060801s08g02 PSTH Control Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

lfpsesinfo = sesinfo;
lfpsesinfo.sampling_rate = 1000;

cd lfp
annie060801s08g01ulfp = ContoursUnleaveSignals('annie06080108_lfp',lfpsesinfo,1);
annie060801s08g02ulfp = ContoursUnleaveSignals('annie06080108_lfp',lfpsesinfo,2);
cd ..

ContoursPlotUnleavedSignals(annie060801s08g01ulfp,'contour','catch')
subplot(4,1,1),title('annie060801s08g01 Lowpass Contour Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

ContoursPlotUnleavedSignals(annie060801s08g01ulfp,'control','catch')
subplot(4,1,1),title('annie060801s08g01 Lowpass Control Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

ContoursPlotUnleavedSignals(annie060801s08g02ulfp,'contour','catch')
subplot(4,1,1),title('annie060801s08g02 Lowpass Contour Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

ContoursPlotUnleavedSignals(annie060801s08g02ulfp,'control','catch')
subplot(4,1,1),title('annie060801s08g02 Lowpass Control Target')
ylabel('0 deg jitter')
subplot(4,1,2),ylabel('20 deg jitter')
subplot(4,1,3),ylabel('40 deg jitter')
subplot(4,1,4),ylabel('no contour')

set(gca,'YTick',[9 26 41 58],'YTickLabel',[' 0 deg jitter';'20 deg jitter';'40 deg jitter';'   no contour'])

% look only at correct trials
annie060801s08imarkers = ContoursProcessMarkerFile('annie06080108');
annie060801s08markers = ContoursUnleaveMarkers(annie060801s08imarkers,annie060801s08sesinfo);

annie060801s08g01rs = ContoursGetResultSpikes(annie060801s08markers,annie060801s08g01s);
annie060801s08g02rs = ContoursGetResultSpikes(annie060801s08markers,annie060801s08g02s);

% plot rasters
figure(1)
ContoursPlotSpikes(annie060801s08g01rs.correct,1,'contour','allcatch')
figure(2)
ContoursPlotSpikes(annie060801s08g02rs.correct,1,'contour','allcatch')

% get psth
annie060801s08g01rpsth = ContoursCalPSTH(annie060801s08g01rs.correct,1);
annie060801s08g02rpsth = ContoursCalPSTH(annie060801s08g02rs.correct,1);

figure(1)
ContoursPlotPSTH(annie060801s08g01rpsth,1,'contour','allcatch')
figure(2)
ContoursPlotPSTH(annie060801s08g02rpsth,1,'contour','allcatch')

% plot rasters for full salience group1
subplot(3,2,1)
spikes = s08g01rs.correct;
y = 0;
si = 1;
cluster = 1;
reps = size(spikes.contour(si).repetition,2);
for ri=1:reps
	yend = y + 0.75;
	for spi=1:spikes.contour(si).repetition(ri).cluster(cluster).spikecount
		spiketime = spikes.contour(si).repetition(ri).cluster(cluster).spikes(spi);
		line([spiketime spiketime],[y yend])
	end
	y = y + 1;
end
axis([500 800 0 18]);

markers = s08rmarkers.correct;
y = 0.5;
hold on
for ri=1:reps
	for spi=1:markers.contour(si).repetition(ri).num_of_markers
		marker = markers.contour(si).repetition(ri).markers(spi,1);
		mtime = markers.contour(si).repetition(ri).markers(spi,2);
		switch(marker)
			% case 3,
				% time of fixation off i.e. go signal
				% plot(mtime,y,'r^');
			case 983040,
				% out of ROI
				plot(mtime,y,'co');
			case 983041,
				% in ROI
				plot(mtime,y,'md');
			case 983042,
				% fixation established
				plot(mtime,y,'yv');
			case 983043,
				% lost fixation
				plot(mtime,y,'ks');
			case 983044,
				% timed out
				plot(mtime,y,'g*');
		end % switch
	end % for spi
	y = y + 1;
end % for ri

title('annie060801s08g01 Contour Target Correct Trials')
xlabel('Time (ms)')
ylabel('0 deg jitter')

% plot rasters for full salience group2
subplot(3,2,2)
spikes = s08g02rs.correct;

markers = s08rmarkers.correct;

title('annie060801s08g02 Contour Target Correct Trials')

% plot psth for full salience group1
subplot(3,2,3)
mypsth = s08g01rpsth;
bar(mypsth.timebins,mypsth.contour(si).cluster(cluster).psth)
axis([500 800 0 1])
ylabel('PSTH 1 ms bins')

% plot psth for full salience group2
subplot(3,2,4)
mypsth = s08g02rpsth;

% plot avg lfp full salience group1
subplot(3,2,5)
signals = s08g01avgrlfps;
ri = 1;
points = size(signals.contour(si).repetition(ri).data,2);
plot(signals.timeseries(1:points),signals.contour(si).repetition(ri).data,'-')
axis([500 800 -5000 5000])
ylabel('Averaged low-pass 1-150 Hz')

% plot avg lfp full salience group2
subplot(3,2,6)
signals = s08g02avgrlfps;

% draw Gabor size on eye traces
line([fixX-gHalf fixX+gHalf],[fixY+gHalf fixY+gHalf],'Color',[1 0 0])
line([fixX-gHalf fixX+gHalf],[fixY-gHalf fixY-gHalf],'Color',[1 0 0])
line([fixX+gHalf fixX+gHalf],[fixY-gHalf fixY+gHalf],'Color',[1 0 0])
line([fixX-gHalf fixX-gHalf],[fixY-gHalf fixY+gHalf],'Color',[1 0 0])

% draw fix window on eye traces
line([fixX-fHalf fixX+fHalf],[fixY+fHalf fixY+fHalf],'Color',[0 1 0])
line([fixX-fHalf fixX+fHalf],[fixY-fHalf fixY-fHalf],'Color',[0 1 0])
line([fixX+fHalf fixX+fHalf],[fixY-fHalf fixY+fHalf],'Color',[0 1 0])
line([fixX-fHalf fixX-fHalf],[fixY-fHalf fixY+fHalf],'Color',[0 1 0])

meanX = mean(eyeData.X)
meanY = mean(eyeData.Y)
meanXf = ones(68,1) * meanX;
meanYf = ones(68,1) * meanY;
diffX = eyeData.X - meanXf;
diffY = eyeData.Y - meanYf;
figure(1)
barh(1:68,diffX(:,6))
figure(2)
barh(1:68,diffY(:,6))

maxmag = max(mag);
minmag = min(mag);

magnorm = [];

for i=1:11
   inorm = (mag(:,i)-minmag(i))/(maxmag(i)-minmag(i));
   magnorm = [magnorm inorm];
end

for i = 1:11
	latmagcorr(i) = xcorr(s08g01rlatencynorm,magnorm(:,i),0);
end

s02sesinfo = ContoursGetSessionInfo('annie05230102','0001');
s02imarkers = ContoursProcessMarkerFile('annie05230102');
s02markers = ContoursUnleaveMarkers(s02imarkers,s02sesinfo);

s02g01 = GenerateSessionSpikeTrains('0001',0,0);
s02g02 = GenerateSessionSpikeTrains('0002',0,0);
s02g01s = ContoursUnleaveSpikes(s02g01is,s02sesinfo);
s02g02s = ContoursUnleaveSpikes(s02g02is,s02sesinfo);
s02g01rs = ContoursGetResultSpikes(s02markers,s02g01s);
s02g02rs = ContoursGetResultSpikes(s02markers,s02g02s);

s02g01lfp = ContoursUnleaveSignals('annie05230102_lfp',s02sesinfo,1,1000);
s02g02lfp = ContoursUnleaveSignals('annie05230102_lfp',s02sesinfo,2,1000);
s02g01rlfp = ContoursGetResultSignals(s02markers,s02g01lfp);
s02g02rlfp = ContoursGetResultSignals(s02markers,s02g02lfp);
