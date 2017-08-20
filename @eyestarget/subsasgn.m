function [obj,res] = subsasgn(obj,index,value)
%EYESTARGET/SUBSASGN Assignment method for EYESTARGET object

myerror = 0;
res = 1;
unknown = 0;

il = length(index);
if strcmp(index(1).type,'.')
    switch index(1).subs        
    case 'onsets'
    	if il==1
	        obj.onsets = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.onsets(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.onsets(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'onsetsMS'
    	if il==1
	        obj.onsetsMS = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.onsetsMS(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.onsetsMS(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'targets'
    	if il==1
	        obj.targets = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.targets(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.targets(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'tmarkers'
    	if il==1
	        obj.tmarkers = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.tmarkers(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.tmarkers(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'results'
    	if il==1
	        obj.results = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.results(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.results(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'mresults'
    	if il==1
	        obj.mresults = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.mresults(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.mresults(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'rt'
    	if il==1
	        obj.rt = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.rt(index(2).subs{:}) = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.rt(trials) = value;
	    	else
	    		myerror = 1;
	    	end
	    else
	    	myerror = 1;
	    end
    case 'markers'
    	if il==1
	        obj.markers = value;
	    elseif strcmp(index(2).type,'()')
	    	obj.markers{index(2).subs{:}} = value;
	    elseif strcmp(index(2).type,'.')
	    	s(1).type = '.';
	    	s(1).subs = 'sequence';
	    	s = [s index(2:il)];
	    	[trials,res] = subsref(obj.sesinfo,s);
	    	if res == 1
	    		obj.markers(trials) = value;
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
	[obj.sesinfo,res] = subsasgn(obj.sesinfo,index,value);
	% if parent is unable to handle
	if res==0
		% pass to other parent
		[obj.eyes,res] = subsasgn(obj.eyes,index,value);
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
