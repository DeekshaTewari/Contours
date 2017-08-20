function ContoursInspectEyes(sessionname,fixX,fixY,gHalf,fHalf,hor,ver)
%ContoursInspectEyes	Plot eye traces with fix and Gabor windows
%	ContoursInspectEyes(sessionname,fixX,fixY,gHalf,fHalf,hor,ver)

% get list of files
filelist = nptDir([sessionname '.0*']);
numTrials = size(filelist,1);

% calculate the axis limits
xmin = 0.9 * fixX;
xmax = fixX * 1.5;
ymin = fixY * 0.5;
ymax = fixY * 1.5;

trial = 1;
while trial<=numTrials
	filename = [sessionname '.' num2str(trial,'%04i')];
	fprintf('Reading %s\n',filename);
	[eyedata,numChannels,samplingRate,dataType,points] = nptReadDataFile(filename);
	
	hold off
	plot(eyedata(hor,:),eyedata(ver,:))
	hold on
	
	% draw Gabor window
	line([fixX-gHalf fixX+gHalf],[fixY+gHalf fixY+gHalf],'Color',[1 0 0])
	line([fixX-gHalf fixX+gHalf],[fixY-gHalf fixY-gHalf],'Color',[1 0 0])
	line([fixX+gHalf fixX+gHalf],[fixY-gHalf fixY+gHalf],'Color',[1 0 0])
	line([fixX-gHalf fixX-gHalf],[fixY-gHalf fixY+gHalf],'Color',[1 0 0])
	
	% draw fix window on eye traces
	% line([fixX-fHalf fixX+fHalf],[fixY+fHalf fixY+fHalf],'Color',[0 1 0])
	% line([fixX-fHalf fixX+fHalf],[fixY-fHalf fixY-fHalf],'Color',[0 1 0])
	% line([fixX+fHalf fixX+fHalf],[fixY-fHalf fixY+fHalf],'Color',[0 1 0])
	% line([fixX-fHalf fixX-fHalf],[fixY-fHalf fixY+fHalf],'Color',[0 1 0])
	
	axis([xmin xmax ymin ymax])

	% get keyboard input to see what to do next
	key = input('RETURN - Next Trial; p - Previous trial; N - Trial N; q - Quit: ','s');
	n = str2num(key);
	if strcmp(key,'p')
		trial = trial - 1;
		if trial<1
			trial = 1;
		end
	elseif strcmp(key,'q')
		return;
	elseif ~isempty(n)
		if n>0 & n<=numTrials
			trial = n;
		end	
	else
		trial = trial + 1;
	end
end
