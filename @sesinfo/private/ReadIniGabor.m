function stim_info = ReadIniGabor(ini_fid,stim_info)

% if ini_fid is -1 that means that we should return an empty structure
if ini_fid~=-1
	% get version info
	version = fscanf(ini_fid,'%*[^=]=%i\n',1);
	
	i = 1;
	switch version
	case 1
		% get all parameters from ini file
		[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',37);
		
		stim_info.data.density = stim_array(i); i = i + 1;
		stim_info.data.bgspacing = stim_array(i); i = i + 1;
		stim_info.data.fgspacing = stim_array(i); i = i + 1;
		stim_info.data.angle = stim_array(i); i = i + 1;
		stim_info.data.orijitter = stim_array(i); i = i + 1;
		stim_info.data.figelts = stim_array(i); i = i + 1;
		stim_info.data.stimdim = stim_array(i); i = i + 1;
		stim_info.data.stimincr = stim_array(i); i = i + 1;
		stim_info.data.stimend = stim_array(i); i = i + 1;
		stim_info.data.catchtrials = stim_array(i); i = i + 1;
		stim_info.data.gabsize = stim_array(i); i = i + 1;
		stim_info.data.vel = stim_array(i); i = i + 1;
		stim_info.data.sf = stim_array(i); i = i + 1;
		stim_info.data.ecc = stim_array(i); i = i + 1;
		% need to set these fields to zero as we have to make sure the fields of the
		% class are the same and are also in the same order
		stim_info.data.restricttarget = 0;
		stim_info.data.restricttargetstart = 0;
		stim_info.data.restricttargetend = 359;
		stim_info.data.controlangle = 0;
		stim_info.data.contourtype = stim_array(i); i = i + 1;
		stim_info.data.stimmotion = stim_array(i); i = i + 1;
		
		stim_info.data.stimsets = stim_array(i+3);
		stim_info.data.numstim = stim_array(i+4);
		
		% stim_info.data.useblockedseq = 0;
		% stim_info.data.includedirsac = stim_array(i+19);
		stim_info.data.repeatblocks = 0;
		stim_info.data.repeats = 1;
		stim_info.data.trials = stim_info.data.numstim;
      stim_info.data.includetuning = stim_array(i+16);
      if stim_info.data.includetuning==1
			stim_info.data.numtuningdir = stim_array(i+17);
         stim_info.data.tuningstepsize = stim_array(i+18);
      else
         stim_info.data.numtuningdir = 0;
         stim_info.data.tuningstepsize = 0;
      end
		
		% need to do some reordering because Matlab requires object fields 
		% to be defined in the same sequence every time
		stim_info.data.fixx = stim_array(i+5);
		stim_info.data.fixy = stim_array(i+6);
		stim_info.data.fixsize = stim_array(i+7);
		stim_info.data.fixtype = stim_array(i+8);
		
		stim_info.data.figcont = stim_array(i);
		stim_info.data.fixcont = stim_array(i+1);
		stim_info.data.bglum = stim_array(i+2);
		
		stim_info.data.fixwinsize = stim_array(i+9);
		stim_info.data.targetwinsize = stim_array(i+10);
      stim_info.data.usetargetcenter = stim_array(i+11);
      if stim_info.data.usetargetcenter==1         
			stim_info.data.tcentercontrast = stim_array(i+12);
      else
         stim_info.data.tcentercontrast = 0;
		end
      stim_info.data.showstimwithfix = stim_array(i+13);
      stim_info.data.transient = stim_array(i+14);
      if stim_info.data.transient==1
         stim_info.data.maskp = stim_array(i+15);
      else
         stim_info.data.maskp = 0;
      end
		stim_info.data.paradigm = stim_array(i+20);
	
		switch stim_info.data.stimdim
		case {0}
		   stim_info.data.stimstart = stim_info.data.density;
		case {1}
		   stim_info.data.stimstart = stim_info.data.bgspacing;
		case {2}
		   stim_info.data.stimstart = stim_info.data.fgspacing;
		case {3}
		   stim_info.data.stimstart = stim_info.data.angle;
		case {4}
		   stim_info.data.stimstart = stim_info.data.orijitter;
		case {5}
		   stim_info.data.stimstart = stim_info.data.figelts;
		otherwise
		   disp('unknown stimulus dimension');
		   return
		end
		
		% figure out number of stimulus steps
		% if contour type is interpolated
		if stim_info.data.contourtype==2
			if stim_info.data.catchtrials == 1,
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets - 1) / 2;
			else
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets) / 2;
			end
		% if contour type is open or closed (i.e. not interpolated)
		else
			if stim_info.data.catchtrials == 1,
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets) - 1;
			else
				stim_info.data.stimsteps = stim_info.data.numstim / stim_info.data.stimsets;
			end
		end
						
		stim_info.data.stim_p = stim_info.data.stimstart:stim_info.data.stimincr:stim_info.data.stimend;
	case 2
		% get all parameters from ini file
		[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',42);
		
		stim_info.data.density = stim_array(i); i = i + 1;
		stim_info.data.bgspacing = stim_array(i); i = i + 1;
		stim_info.data.fgspacing = stim_array(i); i = i + 1;
		stim_info.data.angle = stim_array(i); i = i + 1;
		stim_info.data.orijitter = stim_array(i); i = i + 1;
		stim_info.data.figelts = stim_array(i); i = i + 1;
		stim_info.data.stimdim = stim_array(i); i = i + 1;
		stim_info.data.stimincr = stim_array(i); i = i + 1;
		stim_info.data.stimend = stim_array(i); i = i + 1;
		stim_info.data.catchtrials = stim_array(i); i = i + 1;
		stim_info.data.gabsize = stim_array(i); i = i + 1;
		stim_info.data.vel = stim_array(i); i = i + 1;
		stim_info.data.sf = stim_array(i); i = i + 1;
		stim_info.data.ecc = stim_array(i); i = i + 1;
      stim_info.data.restricttarget = stim_array(i); i = i + 1;
      if stim_info.data.restricttarget==1         
			stim_info.data.restricttargetstart = stim_array(i); i = i + 1;
         stim_info.data.restricttargetend = stim_array(i); i = i + 1;
      else
         stim_info.data.restricttargetstart = 0;
         stim_info.data.restricttargetend = 359;
         i = i + 2;
      end
		stim_info.data.controlangle = 0;
		stim_info.data.contourtype = stim_array(i); i = i + 1;
		stim_info.data.stimmotion = stim_array(i); i = i + 1;
		stim_info.data.stimsets = stim_array(i); i = i + 1;
		stim_info.data.numstim = stim_array(i); i = i + 1;
      stim_info.data.repeatblocks = stim_array(i); i = i + 1;
      if stim_info.data.repeatblocks==1
         stim_info.data.repeats = stim_array(i); i = i + 1;
      else
         stim_info.data.repeats = 1; i = i + 1;
      end
		stim_info.data.trials = stim_array(i); i = i + 1;
      stim_info.data.includetuning = stim_array(i); i = i + 1;
      if stim_info.data.includetuning==1
			stim_info.data.numtuningdir = stim_array(i); i = i + 1;
         stim_info.data.tuningstepsize = stim_array(i); i = i + 1;
      else
         stim_info.data.numtuningdir = 0;
         stim_info.data.tuningstepsize = 0; 
         i = i + 2;
      end
		stim_info.data.fixx = stim_array(i); i = i + 1;
		stim_info.data.fixy = stim_array(i); i = i + 1;
		stim_info.data.fixsize = stim_array(i); i = i + 1;
		stim_info.data.fixtype = stim_array(i); i = i + 1;
		stim_info.data.figcont = stim_array(i); i = i + 1;
		stim_info.data.fixcont = stim_array(i); i = i + 1;
		stim_info.data.bglum = stim_array(i); i = i + 1;
		stim_info.data.fixwinsize = stim_array(i); i = i + 1;
		stim_info.data.targetwinsize = stim_array(i); i = i + 1;
      stim_info.data.usetargetcenter = stim_array(i); i = i + 1;
      if stim_info.data.usetargetcenter==1
         stim_info.data.tcentercontrast = stim_array(i); i = i + 1;
      else
         stim_info.data.tcentercontrast = 0; i = i + 1;
      end
		stim_info.data.showstimwithfix = stim_array(i); i = i + 1;
      stim_info.data.transient = stim_array(i); i = i + 1;
      if stim_info.data.transient==1
         stim_info.data.maskp = stim_array(i); i = i + 1;
      else
         stim_info.data.maskp = 0; i = i + 1;
      end
		stim_info.data.paradigm = stim_array(i); i = i + 1;
	
		switch stim_info.data.stimdim
		case {0}
		   stim_info.data.stimstart = stim_info.data.density;
		case {1}
		   stim_info.data.stimstart = stim_info.data.bgspacing;
		case {2}
		   stim_info.data.stimstart = stim_info.data.fgspacing;
		case {3}
		   stim_info.data.stimstart = stim_info.data.angle;
		case {4}
		   stim_info.data.stimstart = stim_info.data.orijitter;
		case {5}
		   stim_info.data.stimstart = stim_info.data.figelts;
		otherwise
		   disp('unknown stimulus dimension');
		   return
		end
		
		% figure out number of stimulus steps
		% if contour type is interpolated
		if stim_info.data.contourtype==2
			if stim_info.data.catchtrials == 1,
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets - 1) / 2;
			else
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets) / 2;
			end
		% if contour type is open or closed (i.e. not interpolated)
		else
			if stim_info.data.catchtrials == 1,
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets) - 1;
			else
				stim_info.data.stimsteps = stim_info.data.numstim / stim_info.data.stimsets;
			end
		end
		
		stim_info.data.stim_p = stim_info.data.stimstart:stim_info.data.stimincr:stim_info.data.stimend;		
	case 3
		% get all parameters from ini file
		[stim_array,count] = fscanf(ini_fid,'%*[^=]=%i\n',43);
		
		stim_info.data.density = stim_array(i); i = i + 1;
		stim_info.data.bgspacing = stim_array(i); i = i + 1;
		stim_info.data.fgspacing = stim_array(i); i = i + 1;
		stim_info.data.angle = stim_array(i); i = i + 1;
		stim_info.data.orijitter = stim_array(i); i = i + 1;
		stim_info.data.figelts = stim_array(i); i = i + 1;
		stim_info.data.stimdim = stim_array(i); i = i + 1;
		stim_info.data.stimincr = stim_array(i); i = i + 1;
		stim_info.data.stimend = stim_array(i); i = i + 1;
		stim_info.data.catchtrials = stim_array(i); i = i + 1;
		stim_info.data.gabsize = stim_array(i); i = i + 1;
		stim_info.data.vel = stim_array(i); i = i + 1;
		stim_info.data.sf = stim_array(i); i = i + 1;
		stim_info.data.ecc = stim_array(i); i = i + 1;
      stim_info.data.restricttarget = stim_array(i); i = i + 1;
      if stim_info.data.restricttarget==1         
			stim_info.data.restricttargetstart = stim_array(i); i = i + 1;
         stim_info.data.restricttargetend = stim_array(i); i = i + 1;
      else
         stim_info.data.restricttargetstart = 0;
         stim_info.data.restricttargetend = 359;
         i = i + 2;
      end
		stim_info.data.controlangle = stim_array(i); i = i + 1;
		stim_info.data.contourtype = stim_array(i); i = i + 1;
		stim_info.data.stimmotion = stim_array(i); i = i + 1;
		stim_info.data.stimsets = stim_array(i); i = i + 1;
		stim_info.data.numstim = stim_array(i); i = i + 1;
      stim_info.data.repeatblocks = stim_array(i); i = i + 1;
      if stim_info.data.repeatblocks==1
         stim_info.data.repeats = stim_array(i); i = i + 1;
      else
         stim_info.data.repeats = 1; i = i + 1;
      end
		stim_info.data.trials = stim_array(i); i = i + 1;
      stim_info.data.includetuning = stim_array(i); i = i + 1;
      if stim_info.data.includetuning==1
			stim_info.data.numtuningdir = stim_array(i); i = i + 1;
         stim_info.data.tuningstepsize = stim_array(i); i = i + 1;
      else
         stim_info.data.numtuningdir = 0;
         stim_info.data.tuningstepsize = 0; 
         i = i + 2;
      end
		stim_info.data.fixx = stim_array(i); i = i + 1;
		stim_info.data.fixy = stim_array(i); i = i + 1;
		stim_info.data.fixsize = stim_array(i); i = i + 1;
		stim_info.data.fixtype = stim_array(i); i = i + 1;
		stim_info.data.figcont = stim_array(i); i = i + 1;
		stim_info.data.fixcont = stim_array(i); i = i + 1;
		stim_info.data.bglum = stim_array(i); i = i + 1;
		stim_info.data.fixwinsize = stim_array(i); i = i + 1;
		stim_info.data.targetwinsize = stim_array(i); i = i + 1;
      stim_info.data.usetargetcenter = stim_array(i); i = i + 1;
      if stim_info.data.usetargetcenter==1
         stim_info.data.tcentercontrast = stim_array(i); i = i + 1;
      else
         stim_info.data.tcentercontrast = 0; i = i + 1;
      end
		stim_info.data.showstimwithfix = stim_array(i); i = i + 1;
      stim_info.data.transient = stim_array(i); i = i + 1;
      if stim_info.data.transient==1
         stim_info.data.maskp = stim_array(i); i = i + 1;
      else
         stim_info.data.maskp = 0; i = i + 1;
      end
		stim_info.data.paradigm = stim_array(i); i = i + 1;
	
		switch stim_info.data.stimdim
		case {0}
		   stim_info.data.stimstart = stim_info.data.density;
		case {1}
		   stim_info.data.stimstart = stim_info.data.bgspacing;
		case {2}
		   stim_info.data.stimstart = stim_info.data.fgspacing;
		case {3}
		   stim_info.data.stimstart = stim_info.data.angle;
		case {4}
		   stim_info.data.stimstart = stim_info.data.orijitter;
		case {5}
		   stim_info.data.stimstart = stim_info.data.figelts;
		otherwise
		   disp('unknown stimulus dimension');
		   return
		end
		
		% figure out number of stimulus steps
		% if contour type is interpolated
		if stim_info.data.contourtype==2
			if stim_info.data.catchtrials == 1,
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets - 1) / 2;
			else
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets) / 2;
			end
		% if contour type is open or closed (i.e. not interpolated)
		else
			if stim_info.data.catchtrials == 1,
				stim_info.data.stimsteps = (stim_info.data.numstim / stim_info.data.stimsets) - 1;
			else
				stim_info.data.stimsteps = stim_info.data.numstim / stim_info.data.stimsets;
			end
		end
		
		stim_info.data.stim_p = stim_info.data.stimstart:stim_info.data.stimincr:stim_info.data.stimend;
	end
end