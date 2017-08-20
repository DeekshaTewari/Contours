function eyedata = ContoursExtractEyeData(sessionname,tstart,tend,hor,ver,seq)
%ContoursExtractEyeData		Extract eye data
%	EYE_DATA = ContoursExtractEyeData(SESSIONNAME,T_START,T_END,
%	HOR,VER,SEQUENCE)

saliencesteps = size(seq.contour,2);
eyedata.X = [];
eyedata.Y = [];

for si=1:saliencesteps
	reps = size(seq.contour(si).repetition,2);
	for ri=1:reps
		% open the file
		fliename = [sessionname '.' num2str(seq.contour(si).repetition(ri),'%04i')];
		fprintf('Reading %s\n',filename);
		[data,numChannels,samplingRate,dataType,points] = nptReadDataFile(filename);
		eyedata.X = [eyedata.X; data(hor,tstart:tend)];
		eyedata.Y = [eyedata.Y; data(ver,tstart:tend)];
		clear data;
	end
end

if isfield(seq,'allcatch')
	reps = size(seq.allcatch.repetition,2);
	for ri=1:reps
		% open the file
		filename = [sessionname '.' num2str(seq.allcatch.repetition(ri),'%04i')];
		fprintf('Reading %s\n',filename);
		[data,numChannels,samplingRate,dataType,points] = nptReadDataFile(filename);
		eyedata.X = [eyedata.X; data(hor,tstart:tend)];
		eyedata.Y = [eyedata.Y; data(ver,tstart:tend)];
		clear data;
	end
end
		