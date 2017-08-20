function b = subsref(obj, index)
%MARKERS/SUBSREF Index method for MARKERS object
%
%   Dependencies: None.

myerror = 0;
il = length(index);

if il~=0 & strcmp(index(1).type,'.')
	switch index(1).subs
	case 'session'
		b = obj.session;
	case 'contour'
		switch il
		case 1
			b = obj.contour;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.contour(index(2).subs{:});
			else
				myerror = 1;
			end
		case 3
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') 
				b = obj.contour(index(2).subs{:}).stimulus;
			else
				myerror = 1;
			end
		case 4
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()')
				b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:});
			else
				myerror = 1;
			end
		case 5
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition')
				b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:}).repetition;
			else
				myerror = 1;
			end
		case 6
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition') ...
			  & strcmp(index(6).type,'()')
				b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:});
			else
				myerror = 1;
			end
		case 7
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition') ...
			  & strcmp(index(6).type,'()') & strcmp(index(7).type,'.')
				switch index(7).subs
				case 'response'
					b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).response;
				case 'num_of_markers'
					b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).num_of_markers;
				case 'markers'
					b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).markers;
				end
			else
				myerror = 1;
			end
		case 8
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition') ...
			  & strcmp(index(6).type,'()') & strcmp(index(7).type,'.') ...
			  & strcmp(index(7).subs,'markers') & strcmp(index(8).type,'()')
				b = obj.contour(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).markers(index(8).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'control'
		switch il
		case 1
			b = obj.control;
		case 2
			if strcmp(index(2).type,'()')
				b = obj.control(index(2).subs{:});
			else
				myerror = 1;
			end
		case 3
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') 
				b = obj.control(index(2).subs{:}).stimulus;
			else
				myerror = 1;
			end
		case 4
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()')
				b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:});
			else
				myerror = 1;
			end
		case 5
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition')
				b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:}).repetition;
			else
				myerror = 1;
			end
		case 6
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition') ...
			  & strcmp(index(6).type,'()')
				b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:});
			else
				myerror = 1;
			end
		case 7
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition') ...
			  & strcmp(index(6).type,'()') & strcmp(index(7).type,'.')
				switch index(7).subs
				case 'response'
					b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).response;
				case 'num_of_markers'
					b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).num_of_markers;
				case 'markers'
					b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).markers;
				end
			else
				myerror = 1;
			end
		case 8
			if strcmp(index(2).type,'()') & strcmp(index(3).type,'.') ...
			  & strcmp(index(3).subs,'stimulus') & strcmp(index(4).type,'()') ...
			  & strcmp(index(5).type,'.') & strcmp(index(5).subs,'repetition') ...
			  & strcmp(index(6).type,'()') & strcmp(index(7).type,'.') ...
			  & strcmp(index(7).subs,'markers') & strcmp(index(8).type,'()')
				b = obj.control(index(2).subs{:}).stimulus(index(4).subs{:}).repetition(index(6).subs{:}).markers(index(8).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontour'
		switch il
		case 1
			b = obj.catchcontour;
		case 2
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') 
				b = obj.catchcontour.stimulus;
			else
				myerror = 1;
			end
		case 3
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()')
				b = obj.catchcontour.stimulus(index(3).subs{:});
			else
				myerror = 1;
			end
		case 4
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition')
				b = obj.catchcontour.stimulus(index(3).subs{:}).repetition;
			else
				myerror = 1;
			end
		case 5
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition') & strcmp(index(5).type,'()')
				b = obj.catchcontour.stimulus(index(3).subs{:}).repetition(index(5).subs{:});
			else
				myerror = 1;
			end
		case 6
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition') & strcmp(index(5).type,'()') ...
			  & strcmp(index(6).type,'.')
				switch index(6).subs
				case 'response'
					b = obj.catchcontour.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).response;
				case 'num_of_markers'
					b = obj.catchcontour.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).num_of_markers;
				case 'markers'
					b = obj.catchcontour.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).markers;
				end
			else
				myerror = 1;
			end
		case 7
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition') & strcmp(index(5).type,'()') ...
			  & strcmp(index(6).type,'.') & strcmp(index(6).subs,'markers') ...
			  & strcmp(index(7).type,'()')
				b = obj.catchcontour.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).markers(index(7).subs{:});
			else
				myerror = 1;
			end
		otherwise
			myerror = 1;
		end
	case 'catchcontrol'
		switch il
		case 1
			b = obj.catchcontrol;
		case 2
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') 
				b = obj.catchcontrol.stimulus;
			else
				myerror = 1;
			end
		case 3
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()')
				b = obj.catchcontrol.stimulus(index(3).subs{:});
			else
				myerror = 1;
			end
		case 4
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition')
				b = obj.catchcontrol.stimulus(index(3).subs{:}).repetition;
			else
				myerror = 1;
			end
		case 5
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition') & strcmp(index(5).type,'()')
				b = obj.catchcontrol.stimulus(index(3).subs{:}).repetition(index(5).subs{:});
			else
				myerror = 1;
			end
		case 6
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition') & strcmp(index(5).type,'()') ...
			  & strcmp(index(6).type,'.')
				switch index(6).subs
				case 'response'
					b = obj.catchcontrol.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).response;
				case 'num_of_markers'
					b = obj.catchcontrol.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).num_of_markers;
				case 'markers'
					b = obj.catchcontrol.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).markers;
				end
			else
				myerror = 1;
			end
		case 7
			if strcmp(index(2).type,'.') & strcmp(index(2).subs,'stimulus') ...
			  & strcmp(index(3).type,'()') & strcmp(index(4).type,'.') ...
			  & strcmp(index(4).subs,'repetition') & strcmp(index(5).type,'()') ...
			  & strcmp(index(6).type,'.') & strcmp(index(6).subs,'markers') ...
			  & strcmp(index(7).type,'()')
				b = obj.catchcontrol.stimulus(index(3).subs{:}).repetition(index(5).subs{:}).markers(index(7).subs{:});
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

if myerror==1
	error('Invalid field name')
end
