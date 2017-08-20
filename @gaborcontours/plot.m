function obj = plot(obj,varargin)
%@gaborcontours/plot Plot function for GABORCONTOURS class
%   OBJ = PLOT(OBJ,N) plots the N-th stimulus. The stimuli are
%   arranged in the following order:
%      A1,A2,...,AN,B1,...,BN,...,a1,...,aN,b1,...,bN,...,T1,...,TM,t1,...,tM
%   where A, B, etc. are stimuli where the target is at the neural
%   location, and A is the highest salience; N is sesinfo.stim_sets;
%   a, b, etc. are stimuli where the target is at the control location,
%   and a is the higest salience; T are catch trials at the neural 
%   location; t are catch trials at the control location; M is N/2.

Args = struct('Blah',0,'XLim',[],'YLim',[]);
Args = getOptArgs(varargin,Args,'aliases',{'Limits' {'XLim','YLim'}});
if(isempty(Args.NumericArguments))
    n = 1;
else
    n = Args.NumericArguments{1};
end

% read the specified stimulus
if(n>0 & n<obj.data.nStimuli)
    % change to proper directory
    cwd = pwd;
    cd(obj.mapfields.SessionDirs{n});
	elts = ReadContourStimuli(obj.data.stimulifile,n-1);
	plot(obj.mapfields,'Marked','Fix');
    hold on
    % not sure how to go from screen pixels to points so we are going to
    % use rectangle instead to plot the exact size of the gabors
	% plot(elts(:,1),elts(:,2),'o')
    % get diameter of gabors
    diam = obj.data.gabsize;
    % get radius of gabor
    radius = diam / 2;
    % use rectangle to plot exact size of gabors
    for i = 1:size(elts,1)
        rectangle('Position',[elts(i,1)-radius,elts(i,2)-radius,diam,diam], ...
            'Curvature',1);
    end
	hold on
	% get rectangle coordinates
	x = obj.data.target(1,:);
	y = obj.data.target(2,:);
	w = obj.data.target(3,:) - x;
	h = obj.data.target(4,:) - y;
	rectangle('Position',[x(1) y(1) w(1) h(1)])
	rectangle('Position',[x(2) y(2) w(2) h(2)])
    hold off
    if(~isempty(Args.XLim))
        xlim(Args.XLim)
    end
    if(~isempty(Args.YLim))
        ylim(Args.YLim)
    end
    cd(cwd);
end
