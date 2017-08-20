%Contours Classes and Functions
%SESINFO
%      S.session
%      S.stim_p
%      S.stim_steps
%      S.stim_sets
%      S.catch_trials
%      S.sequence()
%
%SESINFO Constructor function for SESINFO object
%   S = SESINFO(SESSIONNAME)
%
%SESINFO/DIFF List differences between SESINFO objects
%   R = DIFF(P,Q) 
%
%MARKERS
%      M.session
%      M.contour(i).repetition(j).response
%      M.contour(i).repetition(j).num_of_markers
%      M.contour(i).repetition(j).markers()
%      M.control
%      M.catchcontour
%      M.catchcontrol
%
%MARKERS Constructor function for MARKERS object
%   M = MARKERS(SESINFO)
%
%MARKERS/PLOT Plot markers according to salience conditions
%   PLOT(MARKERS,TARGET,CATCH)
%
%PERFORMANCE
%      P.session 
%      P.contour(i).result
%      P.control(i).result
%      P.catchcontour(i).result
%      P.catchcontrol(i).result
%      P.contourresults
%      P.contourmean
%      P.contoursd
%      P.controlresults
%      P.controlmean
%      P.controlsd
%      P.catchcontourresults
%      P.catchcontourmean
%      P.catchcontoursd
%      P.catchcontrolresults
%      P.catchcontrolmean
%      P.catchcontrolsd
%      P.overallresults
%      P.overallmean
%      P.overallsd
%      P.catchoverallresults
%      P.catchoverallmean
%      P.catchoverallsd
%
%PERFORMANCE Constructor function for PERFORMANCE object
%   P = PERFORMANCE(MARKERS)
%
%PERFORMANCE/PLOT Plot data from PERFORMANCE object
%   PLOT(P,STIM_P,CSTEP) 
%
%PERFORMANCE/PLUS Overloaded plus function for PERFORMANCE objects
%   R = PLUS(P,Q)
%
%SIGNALS
%
%SIGNALS Constructor function for SIGNALS object


%ContoursReadIniFile		Reads INI file for contour experiments.
%	STIM_INFO = ContoursReadIniFile(SESSIONNAME)
%
%ContoursGetSessionInfo		Gets session information from INI and HDR files
%	SES_INFO = ContoursGetSessionInfo(SESSIONNAME,GROUP_NAME)
%
%MARKERS
%ContoursReadMarkerFile		Opens and reads marker files created by Control III
%	[RAW_MARKERS,RECORDS] = ContoursReadMarkerFile(FILENAME)
%
%ContoursMarkersToTrials	Rearranges markers into trials
%	INTERLEAVED_MARKERS = ContoursMarkersToTrials(RAW_MARKERS)
%
%ContoursProcessMarkerFile	Reads marker file and parses into trials
%	INTERLEAVED_MARKERS = ContoursProccessMarkerFile(SESSIONNAME)
%
%ContoursUnleaveMarkers		Rearrange reaction times into salience values
%	MARKERS = ContoursUnleaveMarkers(INTERLEAVED_MARKERS,SES_INFO)
%
%ContoursPlotMarkers		Plot signals according to salience conditions
%	ContoursPlotMarkers(MARKERS,TARGET,CATCH)
%
%RESULT
%ContoursBehGetResults		Parse unleaved markers
%	RESULT = ContoursBehGetResults(MARKERS,SES_INFO)
%
%ContoursBehCalMeanStdev	Compute mean and standard error for contour task
%	RESULT = ContoursBehCalMeanStdev(RESULT)
%
%ContoursBehCombineSessions	Combines results from multiple sessions
%	RESULT = ContoursBehCombineSessions(RESULT1,RESULT2,...)
%
%ContoursPlotResult			Plots the psychophysical curves for the contour task
%	ContoursPlotResult(RESULT)
%
%SPIKES
%ContoursUnleaveSpikes		Rearrange spikes into salience values
%	SPIKES = ContoursUnleaveSpikes(INTERLEAVED_SPIKES,SESINFO)
%
%ContoursGetResultsSpikes	Rearrange spikes according to the result of the trials
%	RESULT_SPIKES = ContoursGetResultSpikes(MARKERS,SPIKES)
%
%ContoursPlotSpikes			Plot spike trains according to salience conditions
%	ContoursPlotSpikes(SPIKES,CLUSTER,TARGET,CATCH)
%
%ContoursCombineSpikes		Combines spikes from multiple sessions
%	RESULT = ContoursCombineSpikes(SPIKES1,SPIKES2,...)
%
%ContoursExtractSpikeTimes	Extract response latency
%	SPIKE_TIMES = ContoursExtractSpikeTimes(SPIKES,CLUSTER,T_START)
%
%ContoursCalOriTuning		Calculate orientation tuning for a session
%	TUNING = ContoursCalOriTuning(SPIKES,TSTART,TEND,SESINFO)
%
%PSTH
%ContoursCalPSTH			Calculates PSTH according to salience conditions
%	PSTH = ContoursCalPSTH(SPIKES,BINSIZE)
%
%ContoursPlotPSTH			Plots PSTH according to salience conditions
%	ContoursPlotPSTH(PSTH,CLUSTER,TARGET,CATCH)
%
%SIGNALS
%ContoursUnleaveSignals		Rearrange signals into salience values
%	SIGNALS = ContoursUnleaveSignals(SIGNALFILENAME,SESINFO,CHANNEL,SAMPLING_RATE)
%
%ContoursGetResultSignals	Rearrange signals according to the result of the trials
%	RESULT_SIGNALS = ContoursGetResultSignals(MARKERS,SIGNALS)
%
%ContoursPlotSignals		Plot signals according to salience conditions
%	ContoursPlotSignals(SIGNALS,TARGET,CATCH)
%
%EYES
%ContoursInspectEyes		Plot eye traces with fixation and Gabor windows
%	ContoursInspectEyes(sessionname,fixX,fixY,gHalf,fHalf,hor,ver)
%
%ContoursExtractEyeData		Extract eye data
%	EYE_DATA = ContoursExtractEyeData(SESSIONNAME,T_START,T_END,
%	HOR,VER,SEQUENCE)
%
%SEQUENCE
%ContoursUnleaveSequence	Converts trial sequence into stimulus conditions
%	SEQUENCE = ContoursUnleaveSequence(SESINFO) 
%
%ContoursGetResultSequence	Sorts trial sequence into salience conditions and 
%result of the trial.
%	RESULT_SEQUENCE = ContoursGetResultSequence(MARKERS,SEQUENCE)
%
%MISC
%ContoursBehProcessSession	Reads INI and MRK file
%	[RESULT,STIM_P,STIM_PARAMS,STIMTRIALSEQ] = ContoursBehProcessSession
%	(SESSIONNAME) 
%
%ContoursUnleaveSequence	Converts trial sequence into stimulus conditions
%	SEQ = ContoursUnleaveSequence(STIMTRIALSEQ) converts the stimulus
%
%Data Types
%	RESULT.session
%	RESULT.contor(salience).repetition(rep)
%	RESULT.contourresults
%	RESULT.control(salience).repetition(rep)
%	RESULT.controlresults
%	RESULT.overallresults
%	RESULT.catchcontour.repetition(rep)
%	RESULT.catchcontourresults
%	RESULT.catchcontrol.repetition(rep)
%	RESULT.catchcontrolresults
%	RESULT.catchoverallresults
%	RESULT.contourmean
%	RESULT.controlmean
%	RESULT.overallmean
%	RESULT.contoursd
%	RESULT.controlsd
%	RESULT.overallsd
%	RESULT.catchcontourmean
%	RESULT.catchcontrolmean
%	RESULT.catchoverallmean
%	RESULT.catchcontoursd
%	RESULT.catchcontrolsd
%	RESULT.catchoverallsd
%
% 	INTERLEAVED_SPIKES.name	data file from which the spikes were extracted
% 	INTERLEAVED_SPIKES.duration	duration used to form continuous trial
% 	INTERLEAVED_SPIKES.signal	signal number in the data file
% 	INTERLEAVED_SPIKES.means	means for all trials
% 	INTERLEAVED_SPIKES.thresholds	thresholds used in extraction for all trials
% 	INTERLEAVED_SPIKES.trial(trial).cluster(clusternum).spikecount
% 	INTERLEAVED_SPIKES.trial(trial).cluster(clusternum).spikes()
%
%	SPIKES.duration
%	SPIKES.contour(salience).repetition(rep).cluster(clusternum).spikecount
%	SPIKES.contour(salience).repetition(rep).cluster(clusternum).spikes
%	SPIKES.control(salience).repetition(rep).cluster(clusternum).spikecount
%	SPIKES.control(salience).repetition(rep).cluster(clusternum).spikes
%	SPIKES.catchcontour.repetition(rep).cluster(clusternum).spikecount
%	SPIKES.catchcontour.repetition(rep).cluster(clusternum).spikes
%	SPIKES.catchcontrol.repetition(rep).cluster(clusternum).spikecount
%	SPIKES.catchcontrol.repetition(rep).cluster(clusternum).spikes
%	SPIKES.allcatch.repetition(rep).cluster(clusternum).spikecount
%	SPIKES.allcatch.repetition(rep).cluster(clusternum).spikes
%
%	RESULT_SPIKES.correct.contour(salience).repetition(rep).cluster(clusternum).spikecount
%	...
%	RESULT_SPIKES.incorrect.contour(salience).repetition(rep).cluster(clusternum).spikecount
%	...
%
%	PSTH.timebins
%	PSTH.contour(salience).cluster(clusternum).psth
%	PSTH.control(salience).cluster(clusternum).psth
%	PSTH.catchcontour.cluster(clusternum).psth
%	PSTH.catchcontrol.cluster(clusternum).psth
%	PSTH.allcatch.cluster(clusternum).psth
%
%	RAW_MARKERS
%	INTERLEAVED_MARKERS
%	MARKERS.contour(salience).repetition(rep).markers
%	MARKERS.contour(salience).repetition(rep).response
%	MARKERS.contour(salience).repetition(rep).num_of_markers
%	MARKERS.control(salience).repetition(rep).markers
%	MARKERS.control(salience).repetition(rep).response
%	MARKERS.control(salience).repetition(rep).num_of_markers
%	MARKERS.catchcontour.repetition(rep).markers
%	MARKERS.catchcontour.repetition(rep).response
%	MARKERS.catchcontour.repetition(rep).num_of_markers
%	MARKERS.catchcontrol.repetition(rep).markers
%	MARKERS.catchcontrol.repetition(rep).response
%	MARKERS.catchcontrol.repetition(rep).num_of_markers
%
%	SIGNALS.timeseries
%	SIGNALS.sampling_rate
%	SIGNALS.contour(salience).repetition(rep).data
%	SIGNALS.contour(salience).repetition(rep).data
%	SIGNALS.control(salience).repetition(rep).data
%	SIGNALS.control(salience).repetition(rep).data
%	SIGNALS.catchcontour.repetition(rep).data
%	SIGNALS.catchcontour.repetition(rep).data
%	SIGNALS.catchcontrol.repetition(rep).data
%	SIGNALS.catchcontrol.repetition(rep).data
%	SIGNALS.allcatch.repetition(rep).data
%
%	RESULT_SIGNALS.correct.contour(salience).repetition(rep).data
%	...
%	RESULT_SIGNALS.incorrect.contour(salience).repetition(rep).data
%	...



