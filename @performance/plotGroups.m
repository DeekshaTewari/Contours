function plotGroups(pfcs,pfcc,pfci,pfos,pfoc,pfoi)
%PERFORMANCE/plotGroups Plots grouped performance data
%   plotGroups(PFCS,PFCC,PFCI,PFOS,PFOC,PFOI) plots performance
%   data for the following data:
%      PFCS - Closed, static contours
%      PFCC - Closed, coherently moving contours
%      PFCI - Closed, incoherently moving contours
%      PFOS - Open, static contours
%      PFOC - Open, coherently moving contours
%      PFOI - Open, incoherently moving contours

stim_p = pfcs.eyestarget.stim_p;

subplot(1,2,1)
hos = errorbar(stim_p,pfos.contourmean,pfos.contoursd,'bx-');
hold on
hoc = errorbar(stim_p,pfoc.contourmean,pfoc.contoursd,'ro-');
hoi = errorbar(stim_p,pfoi.contourmean,pfoi.contoursd,'g^-');

hosc = errorbar(80,pfos.catchcontourmean,pfos.catchcontoursd,'bx-');
hocc = errorbar(85,pfoc.catchcontourmean,pfoc.catchcontoursd,'ro-');
hoic = errorbar(90,pfoi.catchcontourmean,pfoi.catchcontoursd,'g^-');

axis([-5 95 0 1])
set(gca,'XTick',stim_p)
legend([hoc(end) hos(end) hoi(end)],'Coherent','Static','Incoherent')
title('Open')
xlabel('Ori Jitter (degrees)')
ylabel('Performance')
hold off

subplot(1,2,2)
hcs = errorbar(stim_p,pfcs.contourmean,pfcs.contoursd,'bx-');
hold on
hcc = errorbar(stim_p,pfcc.contourmean,pfcc.contoursd,'ro-');
hci = errorbar(stim_p,pfci.contourmean,pfci.contoursd,'g^-');

hcsc = errorbar(80,pfcs.catchcontourmean,pfcs.catchcontoursd,'bx-');
hccc = errorbar(85,pfcc.catchcontourmean,pfcc.catchcontoursd,'ro-');
hcic = errorbar(90,pfci.catchcontourmean,pfci.catchcontoursd,'g^-');

axis([-5 95 0 1])
set(gca,'XTick',stim_p)
legend([hcc(end) hcs(end) hci(end)],'Coherent','Static','Incoherent')
title('Closed')
xlabel('Ori Jitter (degrees)')
ylabel('Performance')
hold off
