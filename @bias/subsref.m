function [b,res] = subsref(obj,index)
%BIAS/SUBSREF Index method for BIAS object
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
				case 'theta'
					si = obj.sesindexes(ses,:);
					if il==3
						b = obj.theta(obj.indexes(si(1):si(2)));
					elseif strcmp(index(4).type,'.')
						switch index(4).subs
						case 'contour'
							if (il == 4)
								% remove catch trials and return the rest
								if obj.eyestarget.stim_steps.catchcontour
									% if there are catch trials, get all but 
									% last column which would be the catch trials
									ind = reshape(obj.indexes(si(1):si(2),...
										1:obj.eyestarget.stim_steps),[],1);
								else
									% if there are no catch trials, reshape
									% all indexes
									ind = reshape(obj.indexes(si(1):si(2),:),[],1);
								end
								b = obj.theta(ind);
							elseif strcmp(index(5).type,'()')
								% get salience value
								sal = index(5).subs{:};
								ind = obj.indexes(si(1):si(2),sal);
								b = obj.theta(ind);
							end
						case 'catchcontour'
							b = obj.theta(obj.indexes(si(1):si(2),end));
						otherwise
							myerror = 1;
						end
					else
						myerror = 1;
					end
				case 'rt'
					si = obj.sesindexes(ses,:);
					if il==3
						b = obj.rt(obj.indexes(si(1):si(2)));
					elseif strcmp(index(4).type,'.')
						switch index(4).subs
						case 'contour'
							if (il == 4)
								% remove catch trials and return the rest
								if obj.eyestarget.stim_steps.catchcontour
									% if there are catch trials, get all but 
									% last column which would be the catch trials
									ind = reshape(obj.indexes(si(1):si(2),...
										1:obj.eyestarget.stim_steps),[],1);
								else
									% if there are no catch trials, reshape
									% all indexes
									ind = reshape(obj.indexes(si(1):si(2),:),[],1);
								end
								b = obj.rt(ind);
							elseif strcmp(index(5).type,'()')
								% get salience value
								sal = index(5).subs{:};
								ind = obj.indexes(si(1):si(2),sal);
								b = obj.rt(ind);
							end
						case 'catchcontour'
							b = obj.rt(obj.indexes(si(1):si(2),end));
						otherwise
							myerror = 1;
						end
					else
						myerror = 1;
					end
				case 'results'
					si = obj.sesindexes(ses,:);
					if il==3
						b = obj.results(obj.indexes(si(1):si(2)));
					elseif strcmp(index(4).type,'.')
						switch index(4).subs
						case 'contour'
							if (il == 4)
								% remove catch trials and return the rest
								if obj.eyestarget.stim_steps.catchcontour
									% if there are catch trials, get all but 
									% last column which would be the catch trials
									ind = reshape(obj.indexes(si(1):si(2),...
										1:obj.eyestarget.stim_steps),[],1);
								else
									% if there are no catch trials, reshape
									% all indexes
									ind = reshape(obj.indexes(si(1):si(2),:),[],1);
								end
								b = obj.results(ind);
							elseif strcmp(index(5).type,'()')
								% get salience value
								sal = index(5).subs{:};
								ind = obj.indexes(si(1):si(2),sal);
								b = obj.results(ind);
							end
						case 'catchcontour'
							b = obj.results(obj.indexes(si(1):si(2),end));
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
	case 'theta'
		if il==1
			b = obj.theta;
		elseif strcmp(index(2).type,'.')
			switch index(2).subs
			case 'contour'
				if (il==2)
					% remove catch trials and return the rest
					if obj.eyestarget.stim_steps.catchcontour
						% if there are catch trials, get all but
						% last column which would be the catch trials
						ind = reshape(obj.indexes(:,1:obj.eyestarget.stim_steps),[],1);
					else
						% if there are no catch trials, reshape
						% all indexes
						ind = reshape(obj.indexes,[],1);
					end
					b = obj.theta(ind);
				elseif strcmp(index(3).type,'()')
					% get salience value
					sal = index(3).subs{:};
					ind = obj.indexes(:,sal);
					b = obj.theta(ind);
				end
			case 'catchcontour'
				b = obj.theta(obj.indexes(:,end));
			otherwise
				myerror = 1;
			end
		else
			myerror = 1;
		end
	case 'rt'
		if il==1
			b = obj.rt;
		elseif strcmp(index(2).type,'.')
			switch index(2).subs
			case 'contour'
				if (il==2)
					% remove catch trials and return the rest
					if obj.eyestarget.stim_steps.catchcontour
						% if there are catch trials, get all but
						% last column which would be the catch trials
						ind = reshape(obj.indexes(:,1:obj.eyestarget.stim_steps),[],1);
					else
						% if there are no catch trials, reshape
						% all indexes
						ind = reshape(obj.indexes,[],1);
					end
					b = obj.rt(ind);
				elseif strcmp(index(3).type,'()')
					% get salience value
					sal = index(3).subs{:};
					ind = obj.indexes(:,sal);
					b = obj.rt(ind);
				end
			case 'catchcontour'
				b = obj.rt(obj.indexes(:,end));
			otherwise
				myerror = 1;
			end
		else
			myerror = 1;
		end
	case 'results'
		if il==1
			b = obj.results;
		elseif strcmp(index(2).type,'.')
			switch index(2).subs
			case 'contour'
				if (il==2)
					% remove catch trials and return the rest
					if obj.eyestarget.stim_steps.catchcontour
						% if there are catch trials, get all but
						% last column which would be the catch trials
						ind = reshape(obj.indexes(:,1:obj.eyestarget.stim_steps),[],1);
					else
						% if there are no catch trials, reshape
						% all indexes
						ind = reshape(obj.indexes,[],1);
					end
					b = obj.results(ind);
				elseif strcmp(index(3).type,'()')
					% get salience value
					sal = index(3).subs{:};
					ind = obj.indexes(:,sal);
					b = obj.results(ind);
				end
			case 'catchcontour'
				b = obj.results(obj.indexes(:,end));
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
