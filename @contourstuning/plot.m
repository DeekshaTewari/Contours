function obj = plot(obj,varargin)
%contourstuning/plot Plot function for contourstuning object
%   OBJ = plot(OBJ) plots the orientation tuning curves for all data
%   sets.
%
%   OBJ = plot(OBJ,N) plots the curves for the N-th data set.

Args = struct('MeanStd',0,'ImageSC',0,'Hist',0,'BoxPlot',0, ...
    'LabelsOff',0,'Color','b','Normalized',0);
Args.flags = {'MeanStd','ImageSC','Hist','BoxPlot','LabelsOff','Normalized'};
Args = getOptArgs(varargin,Args);

if(isempty(Args.NumericArguments))
	% grab all the data
	data = obj.data.responses;
	ori = obj.data.ori;
    ncells = obj.data.numSets;
    if(isempty(data))
        cla
        title([getDataDirs('ShortName','DirString',obj.data.setNames{1}) ' No tuning trials found!'])
        return
    elseif(ncells>1)
    	titlestr = ['Orientation tuning data for ' num2str(ncells) ' cells'];
    else
    	titlestr = getDataDirs('ShortName','DirString',obj.data.setNames{1});
    end
else
	n = Args.NumericArguments{1};
	% grab relevant data
    if(~isempty(obj.data.responses))
		cols = (obj.data.setIndex(n)+1):obj.data.setIndex(n+1);
		data = obj.data.responses(:,cols);
        % check to make sure there are non-nan values
        if(isempty(data(~isnan(data))))
            data = [];
        end
		odata = obj.data.ori(:,n);
        odatanan = isnan(odata);
		% remove nan
		ori = odata(~odatanan);
		titlestr = getDataDirs('ShortName','DirString',obj.data.setNames{n});
    else
        cla
        title([getDataDirs('ShortName','DirString',obj.data.setNames{n}) ' No tuning trials found!'])
        return
    end
end

if(Args.MeanStd)
    % if ori is empty that means there were no tuning stimuli in this session
    if(~isempty(ori))
		meansc = nanmean(data);
		stdsc = nanstd(data);	
		ehand = errorbar(ori,meansc,stdsc);
        set(ehand(1),'Color',Args.Color);
        % Matlab 7 returns only 1 handle while Matlab 6 returns two
        % handles, one for the and another for the errorbars so the
        % following code will work with both versions
        set(ehand(end),'Color',Args.Color);
	end
    xlabelstr = 'Relative Orientation (degrees)';
    ylabelstr = 'Spike count';
elseif(Args.ImageSC || Args.Hist)
    if(~isempty(data))
		% find max spike counts
		maxsc = max(nanmax(data));
		binedges = 0:maxsc;
		n = hist(data,binedges);
        if(~isempty(n))
			if(Args.ImageSC)
				% normalize each column since there are a lot more trials at the
				% optimal orientation
				nmax = max(n);
				n1 = n ./ repmat(nmax,maxsc+1,1);
				% get number of orientations
				numOri = length(ori);
				imagesc(ori,binedges,n1);
				set(gca,'YDir','normal','XTick',ori);
                xlabelstr = 'Relative Orientation (degrees)';
                ylabelstr = 'Spike count';
			else
				plot(binedges,n,'.-');
                legend(num2str(ori))
                xlabelstr = 'Spike count';
                ylabelstr = 'Number of Occurrences';
			end
        end
	end
elseif(Args.BoxPlot)
	if(~isempty(data))
		boxplot(data,1);
		% set xtick labels
		set(gca,'XTickLabel',num2str(ori))
	end
    xlabelstr = 'Relative Orientation (degrees)';
    ylabelstr = 'Spike count';
else
    % if ori is empty that means there were no tuning stimuli in this session
    if(~isempty(ori))
		meansc = nanmean(data);
        warning off MATLAB:divideByZero
		stderrsc = nanstd(data)./sqrt(sum(~isnan(data)));	
        warning on MATLAB:divideByZero
        if(Args.Normalized)
            % normalize max of meansc to 1
            % find max of meansc
            mscmax = max(meansc);
            % check to make sure mscmax is not 0
            if(mscmax~=0)
                % divide meansc and stderrsc by mscmax
                meansc = meansc/mscmax;
                stderrsc = stderrsc/mscmax;
            end
            ylabelstr = 'Normalized Spike count';
        else
            ylabelstr = 'Spike count';
        end
		ehand = errorbar(ori,meansc,stderrsc);
        set(ehand(1),'Color',Args.Color);
        % Matlab 7 returns only 1 handle while Matlab 6 returns two
        % handles, one for the and another for the errorbars so the
        % following code will work with both versions
        set(ehand(end),'Color',Args.Color);
	end
    xlabelstr = 'Relative Orientation (degrees)';
end
title(titlestr);
if(~Args.LabelsOff)
    xlabel(xlabelstr)
    ylabel(ylabelstr)
end

