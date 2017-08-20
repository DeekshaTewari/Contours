function [b,res] = subsref(obj, index)
%SESINFO/SUBSREF Index method for SESINFO object

myerror = 0;
res = 1;
il = length(index);

if il>0 & strcmp(index(1).type,'.')
    switch index(1).subs        
    case 'data'
    	% if this is the only index, just return the entire thing
    	if(il==1)
    		b = obj.data;
    	else
    		% there are more than 1 index so pass on the subsref call
    		b = subsref(obj.data,index(2:end));
    	end
    % keep remaining code for backward compatability
    case 'sessionname'
    	if il == 1
	        b = obj.data.sessionname;
	    else
	    	myerror = 1;
	    end
    case 'presenterversion'
        b = obj.data.presenterversion;
    case 'width'
        b = obj.data.width;
    case 'height'
        b = obj.data.height;
    case 'includetuning'
    	b = obj.data.includetuning;
    case 'stim_steps'
    	if il == 1
	        b = obj.data.stimsteps;
	    elseif strcmp(index(2).type,'.')
	    	switch index(2).subs
	    	case 'contour'
	    		b = obj.data.stimsteps;
	    	case 'control'
	    		if obj.data.contourtype == 2
	    			b = obj.data.stimsteps;
	    		else
	    			b = 0;
	    		end
	    	case 'catchcontour'
	    		if obj.data.catchtrials == 1
	    			b = 1;
	    		else
	    			b = 0;
	    		end
	    	case 'catchcontrol'
	    		if (obj.data.catchtrials == 1) & (obj.data.contourtype == 2)
	    			b = 1;
	    		else
	    			b = 0;
	    		end
	    	otherwise
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'stim_sets'
        b = obj.data.stimsets;
    case 'catch_trials'
        b = obj.data.catchtrials;
    case 'stim_p'
        b = obj.data.stim_p;
    case 'repeats'
        b = obj.data.repeats;
    case 'fixx'
        b = obj.data.fixx;
    case 'fixy'
        b = obj.data.fixy;
    case 'matchlimit'
        b = obj.data.matchlimit;
    case 'etfix'
        b = obj.data.etfix;
    case 'nTotalStimuli'
    	b = ((obj.data.stimsteps * 2) + obj.data.catchtrials) * obj.data.stimsets;
    case {'nContourStimuli','nControlStimuli'}
    	b = obj.data.stimsteps  * obj.data.stimsets;
    case 'trials'
        b = obj.data.trials;
    case 'isequence'
    	if il==1
    		b = obj.data.isequence;
        elseif strcmp(index(2).type,'()')
            b = obj.data.isequence(index(2).subs{:});
        else
        	myerror = 1;
        end
    case 'ulsequence'
    	if il==1
    		b = obj.data.ulsequence;
        elseif strcmp(index(2).type,'()')
            b = obj.data.ulsequence(index(2).subs{:});
        elseif strcmp(index(2).type,'.')
        	switch index(2).subs
        	case 'contour'
        		switch il
        		case 2
        			% e.g. m.ulsequence.contour - return all contour 
        			% trials
        			tstart = 1;
        			tend = obj.data.stimsteps * obj.data.stimsets * obj.data.repeats;
        			b = obj.data.ulsequence(tstart:tend);
        		case 3
        			if (strcmp(index(3).type,'()'))
						% e.g. m.ulsequence.contour(1) - return all 
						% trials for a specific salience value
						svalue = index(3).subs{:};
						if (svalue > obj.data.stimsteps)
							myerror = 1;
						else
							tstart = (svalue - 1) * obj.data.stimsets * obj.data.repeats + 1;
							tend = svalue * obj.data.stimsets * obj.data.repeats;
							b = obj.data.ulsequence(tstart:tend);
						end
					else
						myerror = 1;
					end
				case 5
					if ( strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
                	  & strcmp(index(4).subs,'stimulus') & strcmp(index(5).type,'()') )
                	  	% e.g. m.ulsequence.contour(2).stimulus(3) - return 
                	  	% all trials of a particular stimulus
                	  	svalue = index(3).subs{:};
                	  	tvalue = index(5).subs{:};
                	  	if ( (svalue > obj.data.stimsteps) | (tvalue > obj.data.stimsets) )
                	  		myerror = 1;
                	  	else
							tstart = (svalue - 1) * obj.data.stimsets * obj.data.repeats ...
							  + ((tvalue - 1) * obj.data.repeats) + 1;
							tend = (svalue - 1) * obj.data.stimsets * obj.data.repeats ...
							  + tvalue * obj.data.repeats;
							b = obj.data.ulsequence(tstart:tend);
						end
                    else
                    	myerror = 1;
                    end
				case 7
					if ( strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
                	  & strcmp(index(4).subs,'stimulus') & strcmp(index(5).type,'()') ...
                	  & strcmp(index(6).type,'.') & strcmp(index(6).subs,'repetition') ...
                	  & strcmp(index(7).type,'()') )
                	  	% e.g. m.ulsequence.contour(2).stimulus(3).repetition(2) 
                	  	% - return all trials of a particular stimulus
                	  	svalue = index(3).subs{:};
                	  	tvalue = index(5).subs{:};
                	  	rvalue = index(7).subs{:};
                	  	if ( (svalue > obj.data.stimsteps) | (tvalue > obj.data.stimsets) ...
                	  	  | (rvalue > obj.data.repeats) )
                	 		myerror = 1;
                	 	else
							tstart = (svalue - 1) * obj.data.stimsets * obj.data.repeats ...
							  + ((tvalue - 1) * obj.data.repeats) + rvalue;
							b = obj.data.ulsequence(tstart);
						end
                    else
                    	myerror = 1;
                    end
                otherwise
                	myerror = 1;
                end
        	case 'control'
        		if (obj.data.contourtype == 2)
					switch il
					case 2
						% e.g. m.ulsequence.control - return all control
						% trials
						tstart = obj.data.stimsteps * obj.data.stimsets * obj.data.repeats + 1;
						tend = 2 * obj.data.stimsteps * obj.data.stimsets * obj.data.repeats;
						b = obj.data.ulsequence(tstart:tend);
					case 3
						if (strcmp(index(3).type,'()'))
							% e.g. m.ulsequence.control(1) - return all 
							% trials for a specific salience value
							svalue = index(3).subs{:};
							if (svalue > obj.data.stimsteps) 
								myerror = 1;
							else
								tstart = (obj.data.stimsteps + svalue - 1) * obj.data.stimsets ...
								  * obj.data.repeats + 1;
								tend = (obj.data.stimsteps + svalue) * obj.data.stimsets * obj.data.repeats;
								b = obj.data.ulsequence(tstart:tend);
							end
						else
							myerror = 1;
						end
					case 5
						if ( strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
						  & strcmp(index(4).subs,'stimulus') & strcmp(index(5).type,'()') )
							% e.g. m.ulsequence.control(2).stimulus(3) - return 
							% all trials of a particular stimulus
							svalue = index(3).subs{:};
							tvalue = index(5).subs{:};
							if ( (svalue > obj.data.stimsteps) | (tvalue > obj.data.stimsets) )
								myerror = 1;
							else
								tstart = (obj.data.stimsteps + svalue - 1) * obj.data.stimsets ...
								  * obj.data.repeats + ((tvalue - 1) * obj.data.repeats) + 1;
								tend = (obj.data.stimsteps + svalue - 1) * obj.data.stimsets ...
								  * obj.data.repeats + tvalue * obj.data.repeats;
								b = obj.data.ulsequence(tstart:tend);
							end
						else
							myerror = 1;
						end
					case 7
						if ( strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
						  & strcmp(index(4).subs,'stimulus') & strcmp(index(5).type,'()') ...
						  & strcmp(index(6).type,'.') & strcmp(index(6).subs,'repetition') ...
						  & strcmp(index(7).type,'()') )
							% e.g. m.ulsequence.contour(2).stimulus(3).repetition(2) 
							% - return all trials of a particular stimulus
							svalue = index(3).subs{:};
							tvalue = index(5).subs{:};
							rvalue = index(7).subs{:};
							if ( (svalue > obj.data.stimsteps) | (tvalue > obj.data.stimsets) ...
							  | (rvalue > obj.data.repeats) )
								myerror = 1;
							else
								tstart = (obj.data.stimsteps + svalue - 1) * obj.data.stimsets ...
								  * obj.data.repeats + ((tvalue - 1) * obj.data.repeats) + rvalue;
								b = obj.data.ulsequence(tstart);
							end
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				else
					myerror = 1;
				end
        	case 'catchcontour'
	    		if obj.data.catchtrials == 1
					switch il
					case 2
						% e.g. m.ulsequence.catchcontour - return all 
						% catch trials at contour location
						if (obj.data.contourtype == 2)
							tstart = 2 * obj.data.stimsteps * obj.data.stimsets * obj.data.repeats + 1;
							tend = (2 * obj.data.stimsteps + 0.5) * obj.data.stimsets * obj.data.repeats;
						else
							tstart = obj.data.stimsteps * obj.data.stimsets * obj.data.repeats + 1;
							tend = (obj.data.stimsteps + 1) * obj.data.stimsets * obj.data.repeats;
						end
						b = obj.data.ulsequence(tstart:tend);							
					case 4
						% e.g. m.ulsequence.catchcontour.stimulus(2) - return all 
						% trials of a particular catch trial at the contour location
						if ( strcmp(index(3).type,'.') & strcmp(index(3).subs,'stimulus') ...
						  & strcmp(index(4).type,'()') )
						  	tvalue = index(4).subs{:};
							if (obj.data.contourtype == 2)
								if (tvalue > (obj.data.stimsets / 2))
									myerror = 1;
								else
									tstart = 2 * obj.data.stimsteps * obj.data.stimsets * obj.data.repeats ...
									  + ((tvalue - 1) * obj.data.repeats) + 1;
									tend = 2 * obj.data.stimsteps * obj.data.stimsets * obj.data.repeats ...
									  + (tvalue * obj.data.repeats);
									b = obj.data.ulsequence(tstart:tend);
								end
							else
								if (tvalue > obj.data.stimsets)
									myerror = 1;
								else
									tstart = obj.data.stimsteps * obj.data.stimsets * obj.data.repeats ...
									  + ((tvalue - 1) * obj.data.repeats) + 1;
									tend = obj.data.stimsteps * obj.data.stimsets * obj.data.repeats ...
									  + (tvalue * obj.data.repeats);
									b = obj.data.ulsequence(tstart:tend);
								end
							end
						else
							myerror = 1;
						end
					case 6
						% e.g. m.ulsequence.catchcontour.stimulus(3).repetition(2) - return 
						% trials of a particular catch trial at the contour location
						if ( strcmp(index(3).type,'.') & strcmp(index(3).subs,'stimulus') ...
						  & strcmp(index(4).type,'()') & strcmp(index(5).type,'.') ...
						  & strcmp(index(5).subs,'repetition') & strcmp(index(6).type,'()') )
						  	tvalue = index(4).subs{:};
						  	rvalue = index(6).subs{:};
							if (obj.data.contourtype == 2)
								if ( (tvalue > (obj.data.stimsets / 2)) | (rvalue > obj.data.repeats) )
									myerror = 1;
								else
									tstart = 2 * obj.data.stimsteps * obj.data.stimsets * obj.data.repeats ...
									  + ((tvalue - 1) * obj.data.repeats) + rvalue;
								b = obj.data.ulsequence(tstart);
								end
							else
								if ( (tvalue > obj.data.stimsets) | (rvalue > obj.data.repeats) )
									myerror = 1;
								else
									tstart = obj.data.stimsteps * obj.data.stimsets * obj.data.repeats ...
									  + ((tvalue - 1) * obj.data.repeats) + rvalue;
								b = obj.data.ulsequence(tstart);
								end
							end
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
	    		else
	    			myerror = 1;
	    		end
        	case 'catchcontrol'
	    		if (obj.data.catchtrials == 1) & (obj.data.contourtype == 2)
					switch il
					case 2
						% e.g. m.ulsequence.catchcontrol - return all 
						% catch trials at control location
						tstart = (2 * obj.data.stimsteps + 0.5) * obj.data.stimsets * obj.data.repeats + 1;
						tend = (2 * obj.data.stimsteps + 1) * obj.data.stimsets * obj.data.repeats;
						b = obj.data.ulsequence(tstart:tend);							
					case 4
						% e.g. m.ulsequence.catchcontrol.stimulus(2) - return all 
						% trials of a particular catch trial at the control location
						if ( strcmp(index(3).type,'.') & strcmp(index(3).subs,'stimulus') ...
						  & strcmp(index(4).type,'()') )
						  	tvalue = index(4).subs{:};
							if (tvalue > (obj.data.stimsets / 2))
								myerror = 1;
							else
								tstart = (2 * obj.data.stimsteps + 0.5) * obj.data.stimsets ...
								  * obj.data.repeats + ((tvalue - 1) * obj.data.repeats) + 1;
								tend = (2 * obj.data.stimsteps + 0.5) * obj.data.stimsets ...
								  * obj.data.repeats + (tvalue * obj.data.repeats);
								b = obj.data.ulsequence(tstart:tend);
							end
						else
							myerror = 1;
						end
					case 6
						% e.g. m.ulsequence.catchcontrol.stimulus(3).repetition(2) - return 
						% trials of a particular catch trial at the control location
						if ( strcmp(index(3).type,'.') & strcmp(index(3).subs,'stimulus') ...
						  & strcmp(index(4).type,'()') & strcmp(index(5).type,'.') ...
						  & strcmp(index(5).subs,'repetition') & strcmp(index(6).type,'()') )
						  	tvalue = index(4).subs{:};
						  	rvalue = index(6).subs{:};
							if ( (tvalue > (obj.data.stimsets / 2)) | (rvalue > obj.data.repeats) )
								myerror = 1;
							else
								tstart = (2 * obj.data.stimsteps + 0.5) * obj.data.stimsets ...
								  * obj.data.repeats + ((tvalue - 1) * obj.data.repeats) + rvalue;
								b = obj.data.ulsequence(tstart);
							end
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
	    		else
	    			myerror = 1;
	    		end
        	otherwise
        		myerror = 1;
        	end
        else
        	myerror = 1;
        end
    case 'sequence'
    	if il==1
    		b = obj.data.sequence;
        elseif strcmp(index(2).type,'.')
            switch index(2).subs
            case 'contour'
            	switch il
            	case 2
            		b = obj.data.sequence.contour;
				case 3
					if strcmp(index(3).type,'()')
                        a = obj.data.sequence.contour(:,index(3).subs{:});
                        % remove 0's due to incompletes
                        b = a(a~=0);
                    else
                    	myerror = 1;
                    end
                otherwise
                	myerror = 1;
                end
            case 'control'
            	switch il
            	case 2
            		b = obj.data.sequence.control;
				case 3
					if strcmp(index(3).type,'()')
                        a = obj.data.sequence.control(:,index(3).subs{:});
                        % remove 0's due to incompletes
                        b = a(a~=0);
                    else
                    	myerror = 1;
                    end
                otherwise
                	myerror = 1;
                end
            case 'catchcontour'
            	switch il
            	case 2
            		a = obj.data.sequence.catchcontour;
					% remove 0's due to incompletes
					b = a(a~=0);
                otherwise
                	myerror = 1;
                end
            case 'catchcontrol'
            	switch il
            	case 2
            		a = obj.data.sequence.catchcontrol;
					% remove 0's due to incompletes
					b = a(a~=0);
                otherwise
                	myerror = 1;
                end
            case 'tuning'
            	switch il
            	case 2
            		b = obj.data.sequence.tuning;
				case 3
					if strcmp(index(3).type,'()')
                        a = obj.data.sequence.tuning(:,index(3).subs{:});
                        % remove 0's due to incompletes
                        b = a(a~=0);
                    else
                    	myerror = 1;
                    end
                otherwise
                	myerror = 1;
                end
            otherwise 
                myerror = 1;
            end
        end
    otherwise 
        myerror = 1;
    end
end

if myerror==1
	if isempty(inputname(1))
		% means some other function is calling this function, so
		% just return error instead of printing error
		res = 0;
		b = 0;
	else
		error('Invalid field name')
	end
end

