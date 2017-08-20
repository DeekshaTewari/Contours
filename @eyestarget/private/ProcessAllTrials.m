function et = ProcessAllTrials(et,varargin)
%EYESTARGET/ProcessAllTrials Process session data.
%   ProcessAllTrials(OBJ) calls ProcessTrial(OBJ) for all trials in
%   session.
%
%	Dependencies: ProcessTrial. 

Args = struct('EyeMovements',0,'EyeMovementsObj',{''});
Args.flags = {'EyeMovements'};
[Args,varargin2] = getOptArgs(varargin,Args,'remove',{'EyeMovements', ...
        'EyeMovementsObj'});
if(~isempty(Args.EyeMovementsObj))
    Args.EyeMovements = 1;
    emObj = 1;
else
    emObj = 0;
end

if(Args.EyeMovements)
    if(emObj)
        em = Args.EyeMovementsObj;
    else
   		% calculate the eye movement data
		em = eyemvt('auto',varargin2{:});
    end
	for i = 1 : min([et.eyes.number length(et.targets)])
		fprintf('.');
        idx = find(em.data.sacSetIndex(:,2) == i);
        sacdata.start = em.data.sacStart(idx);
        sacdata.finish = em.data.sacEnd(idx);
		et = ProcessTrial(et,i,sacdata);
	end
else
	for i = 1:et.eyes.number
		fprintf('.');
		et = ProcessTrial(et,i);
	end
end
fprintf('\n');
