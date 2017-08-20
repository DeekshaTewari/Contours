function [b,res] = subsref(obj, index)
%EYESTARGET/SUBSREF Index method for EYESTARGET object

myerror = 0;
res = 1;
unknown = 0;

il = length(index);
if strcmp(index(1).type,'.')
    switch index(1).subs        
    case 'onsets'
    	if il==1
	        b = obj.onsets;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.onsets(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.onsets(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'onsetsMS'
    	if il==1
	        b = obj.onsetsMS;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.onsetsMS(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.onsetsMS(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'targets'
    	if il==1
	        b = obj.targets;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.targets(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.targets(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'tmarkers'
    	if il==1
	        b = obj.tmarkers;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.tmarkers(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.tmarkers(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'results'
    	if il==1
	        b = obj.results;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.results(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.results(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'mresults'
    	if il==1
	        b = obj.mresults;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.mresults(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.mresults(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'rt'
    	if il==1
	        b = obj.rt;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.rt(index(2).subs{:});
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.rt(trials);
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'markers'
    	if il==1
	        b = obj.markers;
	    elseif strcmp(index(2).type,'()')
	    	b = obj.markers{index(2).subs{:}};
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		b = obj.markers(trials);
	    	else
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
	[b,res] = subsref(obj.sesinfo,index);
	% if parent is unable to handle
	if res==0
		% pass to other parent
		[b,res] = subsref(obj.eyes,index);
	end
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
