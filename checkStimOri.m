function checkStimOri

s = sesinfo('auto');

plot(gaborcontours('auto'),1);

a = nptDir('*_stimuli.bin','CaseInsensitive');
session = a(1).name;

stimelts = ReadContourStimuli(session,0);
[(1:20)' stimelts(1:20,:)]

s.includetuning
get(mapfields('auto'),'CenterXY','Mark',1)
elts = input('Elts: ');

for idx = 1:3
	c = s.sequence.contour(idx);
	cl = length(c);
	a = zeros(cl,length(elts)*3);
	for cidx = 1:cl
		stimelts = ReadContourStimuli(session,s.isequence(c(cidx)));
		p = stimelts(elts,:)';
		a(cidx,:) = reshape(p,1,[]);
	end
	fprintf('Contour %d\n',idx)
	display(a)
	pause
end
for idx = 1:3
	c = s.sequence.control(idx);
	cl = length(c);
	a = zeros(cl,length(elts)*3);
	for cidx = 1:cl
		stimelts = ReadContourStimuli(session,s.isequence(c(cidx)));
		p = stimelts(elts,:)';
		a(cidx,:) = reshape(p,1,[]);
	end
	fprintf('Control %d\n',idx)
	display(a)
	pause
end
c = s.sequence.catchcontour;
cl = length(c);
a = zeros(cl,length(elts)*3);
for cidx = 1:cl
	stimelts = ReadContourStimuli(session,s.isequence(c(cidx)));
	p = stimelts(elts,:)';
	a(cidx,:) = reshape(p,1,[]);
end
fprintf('CatchContour\n')
display(a)
pause
c = s.sequence.catchcontrol;
cl = length(c);
a = zeros(cl,length(elts)*3);
for cidx = 1:cl
	stimelts = ReadContourStimuli(session,s.isequence(c(cidx)));
	p = stimelts(elts,:)';
	a(cidx,:) = reshape(p,1,[]);
end
fprintf('CatchControl\n')
display(a)
pause
if(s.includetuning)
	for idx = 1:8
		c = s.sequence.tuning(idx);
		cl = length(c);
		a = zeros(cl,length(elts)*3);
		for cidx = 1:cl
			stimelts = ReadContourStimuli(session,s.isequence(c(cidx)));
			p = stimelts(elts,:)';
			a(cidx,:) = reshape(p,1,[]);
		end
		fprintf('Tuning %d\n',idx)
		display(a)
		pause
	end
end