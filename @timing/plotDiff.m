function obj = plotDiff(tmcc,tmcnobg,tmdot)
%TIMING/plotDiff Plots timing difference between contour and motor tasks
%   plotDiff(TMCC,TMCNOBG, TMDOT) plots timing data for the following
%   data:
%      TMCC - Closed, coherent contours
%      TMCNOBG - Closed, coherent contours with no distractors
%      TMDOT - Target was a dot

q = tmcc.data.quartiles.overall.contour;
sa = errorbar(tmcc.eyestarget.stim_p,tmcc.data.median.overall.contour,q(:,1),q(:,2),'bx-');
hold on
lhandles = sa(2);
lstring = {'contour'};
qb = tmcnobg.data.quartiles.overall.contour;
sa = errorbar(0,tmcnobg.data.median.overall.contour,qb(1),qb(2),'ro');
lhandles = [lhandles sa(end)];
lstring = {lstring{:}, 'no distractors'};
qd = tmdot.data.quartiles.overall.contour;
sa = errorbar(5,tmdot.data.median.overall.contour,qd(1),qd(2),'g^');
lhandles = [lhandles sa(end)];
lstring = {lstring{:}, 'dot'};
% put a legend in the bottom right hand corner
legend(lhandles,lstring,4)
% adjust XTicks
set(gca,'XTick',tmcc.eyestarget.stim_p);
xlabel('Ori Jitter (degrees)')
ylabel('Time (ms)')

hold off
