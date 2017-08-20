function [b,res] = subsref(obj,index)
%PERFORMANCE/SUBSREF Index method for PERFORMANCE object
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
	case 'daysessions'
		if il==1
			b = obj.daysessions;
		elseif strcmp(index(2).type,'()')
			if il==2
				b = obj.daysessions(index(2).subs{:});
			else
				myerror = 1;
			end
		else
			myerror = 1;
		end
	case 'session'
		if il==1
			b = obj.session;
		elseif strcmp(index(2).type,'()')
			ses = index(2).subs{:};			
			if il==2
				b = obj.session(ses);
			elseif strcmp(index(3).type,'.')
				switch index(3).subs
                case 'sessionname'
                    b = obj.session(ses).sessionname;
				case 'contour'
					switch il
					case 3
						b = obj.session(ses).contour;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).contour(index(4).subs{:});
						else
							myerror = 1;
						end
					case 5
						if strcmp(index(4).type,'()') & strcmp(index(5).type,'.') ...
						  & strcmp(index(5).subs,'result')
							b = obj.session(ses).contour(index(4).subs{:}).result;
						else
							myerror = 1;
						end
					case 6
						if strcmp(index(4).type,'()') & strcmp(index(5).type,'.') ...
						  & strcmp(index(5).subs,'result') & strcmp(index(6).type,'()')
							b = obj.session(ses).contour(index(4).subs{:}).result(index(6).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'control'
					switch il
					case 3
						b = obj.session(ses).control;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).control(index(4).subs{:});
						else
							myerror = 1;
						end
					case 5
						if strcmp(index(4).type,'()') & strcmp(index(5).type,'.') ...
						  & strcmp(index(5).subs,'result')
							b = obj.session(ses).control(index(4).subs{:}).result;
						else
							myerror = 1;
						end
					case 6
						if strcmp(index(4).type,'()') & strcmp(index(5).type,'.') ...
						  & strcmp(index(5).subs,'result') & strcmp(index(6).type,'()')
							b = obj.session(ses).control(index(4).subs{:}).result(index(6).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontour'
					switch il
					case 3
						b = obj.session(ses).catchcontour;
					case 4
						if strcmp(index(4).type,'.') & strcmp(index(4).subs,'result')
							b = obj.session(ses).catchcontour.result;
						else
							myerror = 1;
						end
					case 5
						if strcmp(index(4).type,'.') & strcmp(index(4).subs,'result') ...
						  & strcmp(index(5).type,'()')
							b = obj.session(ses).catchcontour.result(index(5).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontrol'
					switch il
					case 3
						b = obj.session(ses).catchcontrol;
					case 4
						if strcmp(index(4).type,'.') & strcmp(index(4).subs,'result')
							b = obj.session(ses).catchcontrol.result;
						else
							myerror = 1;
						end
					case 5
						if strcmp(index(4).type,'.') & strcmp(index(4).subs,'result') ...
						  & strcmp(index(5).type,'()')
							b = obj.session(ses).catchcontrol.result(index(5).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'contourresults'
					switch il
					case 3
						b = obj.session(ses).contourresults;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).contourresults(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'contourmean'
					switch il
					case 3
						b = obj.session(ses).contourmean;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).contourmean(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'contoursd'
					switch il
					case 3
						b = obj.session(ses).contoursd;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).contoursd(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'controlresults'
					switch il
					case 3
						b = obj.session(ses).controlresults;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).controlresults(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'controlmean'
					switch il
					case 3
						b = obj.session(ses).controlmean;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).controlmean(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'controlsd'
					switch il
					case 3
						b = obj.session(ses).controlsd;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).controlsd(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontourresults'
					switch il
					case 3
						b = obj.session(ses).catchcontourresults;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchcontourresults(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontourmean'
					switch il
					case 3
						b = obj.session(ses).catchcontourmean;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchcontourmean(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontoursd'
					switch il
					case 3
						b = obj.session(ses).catchcontoursd;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchcontoursd(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontrolresults'
					switch il
					case 3
						b = obj.session(ses).catchcontrolresults;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchcontrolresults(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontrolmean'
					switch il
					case 3
						b = obj.session(ses).catchcontrolmean;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchcontrolmean(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchcontrolsd'
					switch il
					case 3
						b = obj.session(ses).catchcontrolsd;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchcontrolsd(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'overallresults'
					switch il
					case 3
						b = obj.session(ses).overallresults;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).overallresults(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'overallmean'
					switch il
					case 3
						b = obj.session(ses).overallmean;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).overallmean(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'overallsd'
					switch il
					case 3
						b = obj.session(ses).overallsd;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).overallsd(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchoverallresults'
					switch il
					case 3
						b = obj.session(ses).catchoverallresults;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchoverallresults(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchoverallmean'
					switch il
					case 3
						b = obj.session(ses).catchoverallmean;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchoverallmean(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
						myerror = 1;
					end
				case 'catchoverallsd'
					switch il
					case 3
						b = obj.session(ses).catchoverallsd;
					case 4
						if strcmp(index(4).type,'()')
							b = obj.session(ses).catchoverallsd(index(4).subs{:});
						else
							myerror = 1;
						end
					otherwise
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
	case 'contourresults'
		switch il
		case 1
			b = obj.contourresults;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.contourresults(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'contourmean'
		switch il
		case 1
			b = obj.contourmean;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.contourmean(index(2).subs{:});
			elseif strcmp(index(2).type,'.') & strcmp(index(2).subs,'sessions')
			  	b = zeros(obj.sessions,length(obj.eyestarget.stim_p));
			  	for i = 1:obj.sessions
			  		b(i,:) = transpose(obj.session(i).contourmean);
			  	end
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'contoursd'
		switch il
		case 1
			b = obj.contoursd;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.contoursd(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'controlresults'
		switch il
		case 1
			b = obj.controlresults;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.controlresults(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'controlmean'
		switch il
		case 1
			b = obj.controlmean;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.controlmean(index(2).subs{:});
			elseif strcmp(index(2).type,'.') & strcmp(index(2).subs,'sessions')
			  	b = zeros(obj.sessions,length(obj.eyestarget.stim_p));
			  	for i = 1:obj.sessions
			  		b(i,:) = transpose(obj.session(i).controlmean);
			  	end
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'controlsd'
		switch il
		case 1
			b = obj.controlsd;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.controlsd(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontourresults'
		switch il
		case 1
			b = obj.catchcontourresults;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchcontourresults(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontourmean'
		switch il
		case 1
			b = obj.catchcontourmean;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchcontourmean(index(2).subs{:});
			elseif strcmp(index(2).type,'.') & strcmp(index(2).subs,'sessions')
			  	b = zeros(obj.sessions,1);
			  	for i = 1:obj.sessions
			  		b(i,:) = transpose(obj.session(i).catchcontourmean);
			  	end
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontoursd'
		switch il
		case 1
			b = obj.catchcontoursd;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchcontoursd(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontrolresults'
		switch il
		case 1
			b = obj.catchcontrolresults;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchcontrolresults(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontrolmean'
		switch il
		case 1
			b = obj.catchcontrolmean;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchcontrolmean(index(2).subs{:});
			elseif strcmp(index(2).type,'.') & strcmp(index(2).subs,'sessions')
			  	b = zeros(obj.sessions,1);
			  	for i = 1:obj.sessions
			  		b(i,:) = transpose(obj.session(i).catchcontrolmean);
			  	end
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontrolsd'
		switch il
		case 1
			b = obj.catchcontrolsd;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchcontrolsd(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'overallresults'
		switch il
		case 1
			b = obj.overallresults;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.overallresults(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'overallmean'
		switch il
		case 1
			b = obj.overallmean;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.overallmean(index(2).subs{:});
			elseif strcmp(index(2).type,'.') & strcmp(index(2).subs,'sessions')
			  	b = zeros(obj.sessions,length(obj.eyestarget.stim_p));
			  	for i = 1:obj.sessions
			  		b(i,:) = transpose(obj.session(i).overallmean);
			  	end
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'overallsd'
		switch il
		case 1
			b = obj.overallsd;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.overallsd(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchoverallresults'
		switch il
		case 1
			b = obj.catchoverallresults;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchoverallresults(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchoverallmean'
		switch il
		case 1
			b = obj.catchoverallmean;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchoverallmean(index(2).subs{:});
			elseif strcmp(index(2).type,'.') & strcmp(index(2).subs,'sessions')
			  	b = zeros(obj.sessions,1);
			  	for i = 1:obj.sessions
			  		b(i,:) = transpose(obj.session(i).catchoverallmean);
			  	end
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchoverallsd'
		switch il
		case 1
			b = obj.catchoverallsd;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.catchoverallsd(index(2).subs{:});
			else
				myerror = 1;
			end
		otherwise
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
