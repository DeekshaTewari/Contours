function obj = plotGroups(tmcs,tmcc,tmci,tmos,tmoc,tmoi,varargin)
%TIMING/plotGroups Plots grouped timing data
%   plotGroups(TMCS,TMCC,TMCI,TMOS,TMOC,TMOI) plots timing data for the following
%   data:
%      TMCS - Closed, static contours
%      TMCC - Closed, coherent contours
%      TMCI - Closed, incoherent contours
%      TMOS - Open, static contours
%      TMOC - Open, coherent contours
%      TMOI - Open, incoherent contours

% default values for optional arguments
plotcontour = 1;
plotcontrol = 0;

stim_p = tmcc.eyestarget.stim_p;

subplot(1,2,1)
q = tmos.data.quartiles.overall.contour;
hos = errorbar(stim_p,tmos.data.median.overall.contour,q(:,1),q(:,2),'bx-');
hold on
q = tmoc.data.quartiles.overall.contour;
hoc = errorbar(stim_p,tmoc.data.median.overall.contour,q(:,1),q(:,2),'ro-');
q = tmoi.data.quartiles.overall.contour;
hoi = errorbar(stim_p,tmoi.data.median.overall.contour,q(:,1),q(:,2),'g^-');

% get the axis limits
ax1 = axis;
set(gca,'XTick',stim_p)
legend([hoc(end) hos(end) hoi(end)],'Coherent','Static','Incoherent',4)
title('Open')
xlabel('Ori Jitter (degrees)')
ylabel('Time (ms)')
hold off

subplot(1,2,2)
q = tmcs.data.quartiles.overall.contour;
hcs = errorbar(stim_p,tmcs.data.median.overall.contour,q(:,1),q(:,2),'bx-');
hold on
q = tmcc.data.quartiles.overall.contour;
hcc = errorbar(stim_p,tmcc.data.median.overall.contour,q(:,1),q(:,2),'ro-');
q = tmci.data.quartiles.overall.contour;
hci = errorbar(stim_p,tmci.data.median.overall.contour,q(:,1),q(:,2),'g^-');

% get the axis limits
ax2 = axis;
% get the min and max y values
y1 = min(ax1(3),ax2(3));
y2 = max(ax1(4),ax2(4));
axis([-5 95 y1 y2])
set(gca,'XTick',stim_p)
legend([hcc(end) hcs(end) hci(end)],'Coherent','Static','Incoherent',4)
title('Closed')
xlabel('Ori Jitter (degrees)')
ylabel('Time (ms)')
hold off

% go back and set the axis for the first plot
subplot(1,2,1)
axis([-5 95 y1 y2])
