function [b,res] = subsref(obj,index)
%TIMING/SUBSREF Index method for TIMING object
%
%   Dependencies: None.

myerror = 0;
unknown = 0;
res = 1;

il = length(index);
if il>0 & strcmp(index(1).type,'.')
	switch index(1).subs
	case 'sessions'
		b = obj.sessions;
	case 'session'
		if il==1
			myerror = 1;
		elseif strcmp(index(2).type,'()')
			ses = index(2).subs{:};			
			if ((il==2) | (ses>obj.sessions))
				myerror = 1;
			elseif strcmp(index(3).type,'.')
				switch index(3).subs
				case 'sessionname'
					if (il == 3)
						b = obj.sessionname{ses};
					else
						myerror = 1;
					end
				case 'timing'
					if il==3
						myerror = 1;
					elseif strcmp(index(4).type,'.')
						switch index(4).subs
						case 'contour'
							if il==4
								b = [];
								for i = 1:obj.eyestarget.stim_steps.contour
									ind = obj.data.contour(i).indexes(ses,:);
									b = [b; obj.data.contour(i).timing(ind(1):ind(2))];
								end
							elseif strcmp(index(5).type,'()')
								sal = index(5).subs{:};
								if sal>obj.eyestarget.stim_steps.contour
									myerror = 1;
								elseif sal>0
									ind = obj.data.contour(sal).indexes(ses,:);
									b = obj.data.contour(sal).timing(ind(1):ind(2));
								else
									myerror = 1;
								end
							else
								myerror = 1;
							end
						case 'control'
							csteps = obj.eyestarget.stim_steps.control;
							if (csteps>0)
								if il==4
									b = [];
									for i = 1:csteps
										ind = obj.data.control(i).indexes(ses,:);
										b = [b; obj.data.control(i).timing(ind(1):ind(2))];
									end
								elseif strcmp(index(5).type,'()')
									sal = index(5).subs{:};
									if sal>obj.eyestarget.stim_steps.control
										myerror = 1;
									elseif sal>0
										ind = obj.data.control(sal).indexes(ses,:);
										b = obj.data.control(sal).timing(ind(1):ind(2));
									else
										myerror = 1;
									end
								else
									myerror = 1;
								end
							end
						case 'catchcontour'
							csteps = obj.eyestarget.stim_steps.catchcontour;
							if (csteps>0)
								if il==4
									ind = obj.data.catchcontour.indexes(ses,:);
									b = obj.data.catchcontour.timing(ind(1):ind(2));
								else
									myerror = 1;
								end
							end
						case 'catchcontrol'
							csteps = obj.eyestarget.stim_steps.catchcontrol;
							if (csteps>0)
								if il==4
									ind = obj.data.catchcontrol.indexes(ses,:);
									b = obj.data.catchcontrol.timing(ind(1):ind(2));
								else
									myerror = 1;
								end
							end
						otherwise
							myerror = 1;
						end
					else
						myerror = 1;
					end
				case 'median'
					if il==3
						myerror = 1;
					elseif strcmp(index(4).type,'.')
						switch index(4).subs
						case 'contour'
							if il==4
								b = obj.data.median.contour(:,ses);
							elseif strcmp(index(5).type,'()')
								sal = index(5).subs{:};
								if sal>obj.eyestarget.stim_steps.contour
									myerror = 1;
								elseif sal>0
									b = obj.data.median.contour(sal,ses);
								else
									myerror = 1;
								end
							else
								myerror = 1;
							end
						case 'control'
							csteps = obj.eyestarget.stim_steps.control;
							if (csteps>0)
								if il==4
									b = obj.data.median.control(:,ses);
								elseif strcmp(index(5).type,'()')
									sal = index(5).subs{:};
									if sal>obj.eyestarget.stim_steps.control
										myerror = 1;
									elseif sal>0
										b = obj.data.median.control(sal,ses);
									else
										myerror = 1;
									end
								else
									myerror = 1;
								end
							end
						case 'catchcontour'
							csteps = obj.eyestarget.stim_steps.catchcontour;
							if (csteps>0)
								if il==4
									b = obj.data.median.catchcontour(1,ses);
								else
									myerror = 1;
								end
							end
						case 'catchcontrol'
							csteps = obj.eyestarget.stim_steps.catchcontrol;
							if (csteps>0)
								if il==4
									b = obj.data.median.catchcontrol(1,ses);
								else
									myerror = 1;
								end
							end
						otherwise
							myerror = 1;
						end
					else
						myerror = 1;
					end
				case 'quartiles'
					if il==3
						myerror = 1;
					elseif strcmp(index(4).type,'.')
						switch index(4).subs
						case 'contour'
							if il==4
								csteps = obj.eyestarget.stim_steps.contour;
								b = reshape(obj.data.quartiles.contour(:,ses,:),csteps,2);
							elseif strcmp(index(5).type,'()')
								sal = index(5).subs{:};
								if sal>obj.eyestarget.stim_steps.contour
									myerror = 1;
								elseif sal>0									
									b = reshape(obj.data.quartiles.contour(sal,ses,:),length(sal),2);
								else
									myerror = 1;
								end
							else
								myerror = 1;
							end
						case 'control'
							csteps = obj.eyestarget.stim_steps.control;
							if (csteps>0)
								if il==4
									b = reshape(obj.data.quartiles.control(:,ses,:),csteps,2);
								elseif strcmp(index(5).type,'()')
									sal = index(5).subs{:};
									if sal>obj.eyestarget.stim_steps.control
										myerror = 1;
									elseif sal>0									
										b = reshape(obj.data.quartiles.control(sal,ses,:),length(sal),2);
									else
										myerror = 1;
									end
								else
									myerror = 1;
								end
							end
						case 'catchcontour'
							csteps = obj.eyestarget.stim_steps.catchcontour;
							if (csteps>0)
								if il==4
									b = reshape(obj.data.quartiles.catchcontour(1,ses,:),1,2);
								else
									myerror = 1;
								end
							end
						case 'catchcontrol'
							csteps = obj.eyestarget.stim_steps.catchcontrol;
							if (csteps>0)
								if il==4
									b = reshape(obj.data.quartiles.catchcontrol(1,ses,:),1,2);
								else
									myerror = 1;
								end
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
		else
			myerror = 1;
		end
	case 'timing'
		if il==1
			myerror = 1;
		elseif strcmp(index(2).type,'.')
			switch index(2).subs
			case 'contour'
				if il==2
					b = [];
					for i = 1:obj.eyestarget.stim_steps.contour
						b = [b; obj.data.contour(i).timing];
					end
				elseif strcmp(index(3).type,'()')
					sal = index(3).subs{:};
					if sal>obj.eyestarget.stim_steps.contour
						myerror = 1;
					elseif sal>0
						b = obj.data.contour(sal).timing;
					else
						myerror = 1;
					end
				else
					myerror = 1;
				end
			case 'control'
				csteps = obj.eyestarget.stim_steps.control;
				if (csteps>0)
					if il==2
						b = [];
						for i = 1:csteps
							b = [b; obj.data.control(i).timing];
						end
					elseif strcmp(index(3).type,'()')
						sal = index(3).subs{:};
						if sal>obj.eyestarget.stim_steps.control
							myerror = 1;
						elseif sal>0
							b = obj.data.control(sal).timing;
						else
							myerror = 1;
						end
					else
						myerror = 1;
					end
				end
			case 'catchcontour'
				csteps = obj.eyestarget.stim_steps.catchcontour;
				if (csteps>0)
					if il==2
						b = obj.data.catchcontour.timing;
					else
						myerror = 1;
					end
				end
			case 'catchcontrol'
				csteps = obj.eyestarget.stim_steps.catchcontrol;
				if (csteps>0)
					if il==2
						b = obj.data.catchcontrol.timing;
					else
						myerror = 1;
					end
				end
			otherwise
				myerror = 1;
			end
		else
			myerror = 1;
		end
	case 'median'
		if il==1
			myerror = 1;
		elseif strcmp(index(2).type,'.')
			switch index(2).subs
			case 'contour'
				if il==2
					b = obj.data.median.overall.contour;
				elseif strcmp(index(3).type,'()')
					sal = index(3).subs{:};
					if sal>obj.eyestarget.stim_steps.contour
						myerror = 1;
					elseif sal>0
						b = obj.data.median.overall.contour(sal,1);
					else
						myerror = 1;
					end
				else
					myerror = 1;
				end
			case 'control'
				csteps = obj.eyestarget.stim_steps.control;
				if (csteps>0)
					if il==2
						b = obj.data.median.overall.control;
					elseif strcmp(index(3).type,'()')
						sal = index(3).subs{:};
						if sal>obj.eyestarget.stim_steps.control
							myerror = 1;
						elseif sal>0
							b = obj.data.median.overall.control(sal,1);
						else
							myerror = 1;
						end
					else
						myerror = 1;
					end
				end
			case 'catchcontour'
				csteps = obj.eyestarget.stim_steps.catchcontour;
				if (csteps>0)
					if il==2
						b = obj.data.median.overall.catchcontour;
					else
						myerror = 1;
					end
				end
			case 'catchcontrol'
				csteps = obj.eyestarget.stim_steps.catchcontrol;
				if (csteps>0)
					if il==2
						b = obj.data.median.overall.catchcontrol;
					else
						myerror = 1;
					end
				end
			otherwise
				myerror = 1;
			end
		else
			myerror = 1;
		end
	case 'quartiles'
		if il==1
			myerror = 1;
		elseif strcmp(index(2).type,'.')
			switch index(2).subs
			case 'contour'
				if il==2
					b = obj.data.quartiles.overall.contour;
				elseif strcmp(index(3).type,'()')
					sal = index(3).subs{:};
					if sal>obj.eyestarget.stim_steps.contour
						myerror = 1;
					elseif sal>0									
						b = obj.data.quartiles.overall.contour(sal,:);
					else
						myerror = 1;
					end
				else
					myerror = 1;
				end
			case 'control'
				csteps = obj.eyestarget.stim_steps.control;
				if (csteps>0)
					if il==2
						b = obj.data.quartiles.overall.control;
					elseif strcmp(index(3).type,'()')
						sal = index(3).subs{:};
						if sal>obj.eyestarget.stim_steps.control
							myerror = 1;
						elseif sal>0									
							b = obj.data.quartiles.overall.control(sal,:);
						else
							myerror = 1;
						end
					else
						myerror = 1;
					end
				end
			case 'catchcontour'
				csteps = obj.eyestarget.stim_steps.catchcontour;
				if (csteps>0)
					if il==2
						b = obj.data.quartiles.overall.catchcontour;
					else
						myerror = 1;
					end
				end
			case 'catchcontrol'
				csteps = obj.eyestarget.stim_steps.catchcontrol;
				if (csteps>0)
					if il==2
						b = obj.data.quartiles.overall.catchcontrol;
					else
						myerror = 1;
					end
				end
			otherwise
				myerror = 1;
			end
		else
			myerror = 1;
		end
	otherwise
		unknown = 1;
	end
else
	unknown = 1;
end

if unknown == 1
	% pass to parent to see if they know what to do with this index
	[b,res] = subsref(obj.eyestarget,index);
end

if (myerror == 1) | (res == 0)
	if isempty(inputname(1))
		% means some other function is calling this function, so we 
		% just return error instead of printing error
		res = 0;
		b = 0;
	else
		error('Invalid field name')
	end
end
