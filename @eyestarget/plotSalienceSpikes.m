function plotSalienceSpikes(et,varargin)
%plotSalienceSpikes Plots spike trains according to salience conditions
%   plotSalienceSpikes(OBJ)

Args = struct('iSpikes',{''},'control',0,'contour',0,'Hist',0, ...
	'correct',0,'incorrect',0,'Bins',-100:10:200,'ShowSTD',0, ...
	'UseEyeJitterLimits',0,'XLimitsEval',[]);
[Args,varargin] = getOptArgs(varargin,Args, ...
	'flags',{'control','contour','correct','incorrect','Hist','ShowSTD', ...
		'UseEyeJitterLimits'});

if(isempty(Args.iSpikes))
	Args.iSpikes = gather(ispikes);
end

if(Args.Hist)
	% plot psth for different conditions
	% we are plotting multiple trials on a raster plot
	% get number of ispikes objects
	niSObj = length(Args.iSpikes);
    % get salience conditions
    stim_p = et.sesinfo.stim_p;
	% get number of salience conditions
	nsc = length(stim_p);
	% get total number of lines to plot
	% datacols = (nsc * 2) + (et.sesinfo.data.catchtrials * 2);
    % add 1 for the 0 jitter control trials, and another 1 if there are
    % catch trials
    datacols = nsc + 1 + et.sesinfo.data.catchtrials;
	% get number of bins
	datarows = length(Args.Bins) - 1;
	% initialize vector to keep track of how many trials there are in
	% each condition
	indlengths = zeros(1,datacols);
	% initialize legend string
	lstring = {};
	for i = 1:nsc
		ind{i} = et.sesinfo.sequence.contour(i);
		indlengths(i) = length(ind{i});
		lstring = {lstring{:} ['Contour ' num2str(stim_p(i))]};
	end
	i2 = nsc + 1;
	ind{i2} = et.sesinfo.sequence.control(1);
	indlengths(i2) = length(ind{i2});
	lstring = {lstring{:} ['Control ' num2str(stim_p(1))]};
	if(et.sesinfo.data.catchtrials)
		catch1 = nsc + 2;
		ind{catch1} = et.sesinfo.sequence.catchcontour;
		indlengths(catch1) = length(ind{catch1});
		lstring = {lstring{:} 'Contour Catch'};
	end
    if(Args.UseEyeJitterLimits)
        % get trials included in the eyejitter tolerance calculation
        [i,excludedTrials] = getTrialsInFields(eyejitter('auto'),'FieldMark',1,'ReturnTrialsOut',varargin{:});
    else
        excludedTrials = [];
    end
	
    % separate axis into niSobj axes
    axesPositions = separateAxis('Horizontal',niSObj);
	% loop over number of cells
	for k = 1:niSObj
        subplot('Position',axesPositions(k,:));
		% preallocate memory for mean and stdev
		m = zeros(datarows,datacols);
		stdev = m;
		% loop over salience conditions
		for i = 1:datacols
			% preallocate memory for calculating mean and std of spike counts
			n = zeros(datarows,indlengths(i));
			% initialize nIndex to 1
			nIndex = 1;
			% loop over trials in each salience condition
			for j = 1:indlengths(i)
				% get trial number
				tn = ind{i}(j);
                % check if the eye position in this trial is okay
                if(isempty(intersect(excludedTrials,tn)))
					% get stimulus onset
					onset = et.onsetsMS(tn);
					% set up hist bins aligned to stimulus onset
					bins = Args.Bins + onset;
					% get spike times
					sp = Args.iSpikes{k}.data.trial(tn).cluster(1).spikes;
					% compute psth
					n(:,nIndex) = histcie(sp,bins,'DropLast');
					nIndex = nIndex + 1;
                else
                    indlengths(i) = indlengths(i) - 1;
                end
			end % loop over trials
			% get final data
			ndata = n(:,1:(nIndex-1));
			m(:,i) = mean(ndata,2);
			stdev(:,i) = std(ndata,0,2);
			% update legend string with number of trials included
			lstring{i} = [lstring{i} ' (n=' num2str(nIndex-1) ')'];
		end % loop over salience conditions
        % get conversion factor from counts/bin to counts/sec
        convertFactor = 1000/(Args.Bins(2)-Args.Bins(1));
        if(Args.ShowSTD)
			errorbar(repmat(Args.Bins(1:(end-1))',1,datacols),m*convertFactor, ...
                stdev*convertFactor);
        else
            plot(repmat(Args.Bins(1:(end-1))',1,datacols),m*convertFactor,'.-')
        end
        legend(lstring);
        xlabel('Time from stimulus onset (ms)')
        ylabel('Firing rate (Hz)')
        title([strrep(Args.iSpikes{k}.data.sessionname,'_highpass','') 'g' Args.iSpikes{k}.data.groupname 'c' Args.iSpikes{k}.data.cellname])
	end
else
	% we are plotting multiple trials on a raster plot
	% get number of ispikes objects
	niSObj = length(Args.iSpikes);

	if(Args.UseEyeJitterLimits)
		% get trials included in the eyejitter tolerance calculation
		[i,excludedTrials] = getTrialsInFields(eyejitter('auto'),'FieldMark',1,'ReturnTrialsOut',varargin{:});
	else
		excludedTrials = [];
	end

	% get indices of contour or control trials
	if(Args.contour)
		% loop over salience conditions for contour
		for i = 1:nsc
			% get all trials for this salience condition
			ind{i} = setdiff(et.sesinfo.sequence.contour(i),excludedTrials);
			if(Args.correct)
				% restrict to only correct trials
				ind{i} = ind{i}(find(et.results(ind{i})));
			elseif(Args.incorrect)
				% restrict to only incorrect trials
				ind{i} = ind{i}(find(et.results(ind{i})==0));
			end
			indlengths(i) = length(ind{i});
		end
	elseif(Args.control)
		% loop over salience conditions for control
		for i = 1:nsc
			% get all trials for this salience condition
			ind{i} = setdiff(et.sesinfo.sequence.control(i),excludedTrials);
			if(Args.correct)
				% restrict to only correct trials
				ind{i} = ind{i}(find(et.results(ind{i})));
			elseif(Args.incorrect)
				% restrict to only incorrect trials
				ind{i} = ind{i}(find(et.results(ind{i})==0));
			end
			indlengths(i) = length(ind{i});
		end
	else
		% get salience conditions
		stim_p = et.sesinfo.stim_p;
		% get number of salience conditions
		nsc = length(stim_p);
		% add 1 for the 0 jitter control trials, and another 1 if there are
		% catch trials
		nsctotal = nsc + 1 + et.sesinfo.data.catchtrials;
		% initialize vector to keep track of how many trials there are in
		% each condition
		indlengths = zeros(nsctotal,1);
		for i = 1:nsc
			% get all trials for this salience condition
			ind{i} = setdiff(et.sesinfo.sequence.contour(i),excludedTrials);
			if(Args.correct)
				% restrict to only correct trials
				ind{i} = ind{i}(find(et.results(ind{i})));
			elseif(Args.incorrect)
				% restrict to only incorrect trials
				ind{i} = ind{i}(find(et.results(ind{i})==0));
			end
			indlengths(i) = length(ind{i});
			% get reaction times for these trials
			indtmp = [ind{i} et.rt(ind{i})];
			% sort using reaction times
			ind{i} = sortrows(indtmp,2);
		end
		i2 = nsc + 1;
		ind{i2} = setdiff(et.sesinfo.sequence.control(1),excludedTrials);
		if(Args.correct)
			% restrict to only correct trials
			ind{i2} = ind{i2}(find(et.results(ind{i2})));
		elseif(Args.incorrect)
			% restrict to only incorrect trials
			ind{i2} = ind{i2}(find(et.results(ind{i2})==0));
		end
		indlengths(i2) = length(ind{i2});
		% get reaction times for these trials
		indtmp = [ind{i2} et.rt(ind{i2})];
		% sort using reaction times
		ind{i2} = sortrows(indtmp,2);
		if(et.sesinfo.data.catchtrials)
			catch1 = nsc + 2;
			ind{catch1} = setdiff(et.sesinfo.sequence.catchcontour,excludedTrials);
			if(Args.correct)
				% restrict to only correct trials
				ind{catch1} = ind{catch1}(find(et.results(ind{catch1})));
			elseif(Args.incorrect)
				% restrict to only incorrect trials
				ind{catch1} = ind{catch1}(find(et.results(ind{catch1})==0));
			end
			indlengths(catch1) = length(ind{catch1});
			% get reaction times for these trials
			indtmp = [ind{catch1} et.rt(ind{catch1})];
			% sort using reaction times
			ind{catch1} = sortrows(indtmp,2);
		end
	end
	% get total number of trials
	ilengthTotal = sum(indlengths);
	pheight = 1/(ilengthTotal*niSObj);
	pvec = 0:pheight:1;
	% set up plot colors - niSObj plus one for onset and another for
	% reaction time
	ncolors = niSObj + 2;
	pcolors = hsv(ncolors);
	% shift the colors so the middle color is shifted to the top and
	% used as the onset color so we maximize the color contrast 
	% between spike trains
	pcolors = circshift(pcolors,-floor(ncolors/2));
	xmax = 0;
	pindex = 1;
	% clear the current axis instead of figure in order to use panGUI
	cla
    % get the number of trials in ispikes
    trialnumber = length(Args.iSpikes{1}.data.trial);
	% loop over salience conditions
	for i = 1:nsctotal
		% loop over trials in each salience condition
		for j = 1:indlengths(i)
			% get trial number
			tn = ind{i}(j,1);
			% get stimulus onset
			onset = et.onsetsMS(tn);
			% get reaction time
			rt = onset + ind{i}(j,2);
			% draw stimulus onset
			line([onset onset],[pvec(pindex) pvec(pindex+niSObj)],'Color',pcolors(1,:));
			% draw reaction time
			line([rt rt],[pvec(pindex) pvec(pindex+niSObj)],'Color',pcolors(2,:));
			% loop over number of cells
			for k = 1:niSObj
				% get spike times
                % if(tn<=trialnumber)
				sp = Args.iSpikes{k}.data.trial(tn).cluster(1).spikes;
                % else
                % 	sp = [];
                % end
				if(~isempty(sp))
					% get time of last spike
					spt = sp(end);
					if(spt>xmax)
						xmax = spt;
					end
					y1 = pvec(pindex);
					pindex = pindex + 1;
					line([sp; sp],[y1 pvec(pindex)],'Color',pcolors(k+2,:));
				else
					pindex = pindex + 1;
				end
			end
		end
	end
	
	if(~isempty(Args.XLimitsEval))
		xlimits = eval(Args.XLimitsEval);
		xlim(xlimits)
	end
	% draw lines corresponding to salience maps
	% get cummulative sums of indlengths to get where each salience
	% condition ends
	pcvec = [0; cumsum(indlengths) * niSObj * pheight];
	% loop over salience conditions
	for i = 2:nsctotal
        y = pcvec(i);
        line([0 xmax],[y y],'Color','k'); 
	end
	xlabel('Time (ms)')
end