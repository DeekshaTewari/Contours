dirs = ['052901';'053001';'060101';'060601';'060801'];

for i=1:7
	cd(dirs(i,:))
	dirs2 = nptDir;
	dsize = size(dirs2,1);
	for j=1:dsize
		cd(dirs2(j).name)
		sessionname = ['annie' dirs(i,:) dirs2(j).name];
		[result,stim_p,stim_params] = ContoursGetResult(sessionname);
		ContoursPlotResult(stim_p,result)	
		varname = [sessionname '_results'];
		eval([varname '= result;'])
		save(varname,varname);
		pause
		cd ..
	end
	cd ..
end
