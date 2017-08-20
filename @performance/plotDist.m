function plotDist(obj,varargin)
%@PERFORMANCE/plotDist Plots distribution of session means
%   plotDist(OBJ) creates subplots for each salience condition to
%   show the distribution of means for each session.
%
%   Dependencies: None.

% default values for optional arguments
contour = 1;
control = 0;

% look for optional arguments
num_args = nargin - 1;
i = 1;
while(i <= num_args)
	if ischar(varargin{i})
		switch varargin{i}
		case('contour')
			contour = 1;
			control = 0;
		case('control')
			contour = 0;
			control = 1;
		end
	end
	i = i + 1;
end

if contour
	index(1).type = '.';
	index(1).subs = 'contourmean';
    m = obj.contourmean;
elseif control
	index(1).type = '.';
	index(1).subs = 'contourmean';
    m = obj.controlmean;
end
	
index(2).type = '.';
index(2).subs = 'sessions';
sm = subsref(obj,index);

n = obj.eyestarget.stim_steps;
bins = 0:0.05:1;
for i = 1:n
	subplot(n,1,i)
	[h,ho] = hist(sm(:,i),bins);
    bar(ho,h);
    hold on
    [hm,hom] = hist(m(i),bins);
    bar(hom,h .* hm,'r');
    ax1 = axis;
    axis([-0.05 1.05 ax1(3) ax1(4)])
    hold off
end

subplot(n,1,n)
xlabel('Performance')
ylabel('Frequency')
