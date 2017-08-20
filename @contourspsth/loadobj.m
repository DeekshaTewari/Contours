function b = loadobj(a)
%contourspsth/loadobj Function to update old saved objects

b=a;

if(isa(a,'contourspsth'))
	if(isempty(get(a,'SessionDirs')))
		fprintf('Adding directory to nptdata object in saved contourspsth object...\n');
		a = set(a,'SessionDirs',{pwd});
		fprintf('Saving updated contourspsth object...\n');
		cp = a;
		save contourspsth cp
	end
end
