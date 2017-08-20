% load eyestarget
% isp1 = ispikes('0001',1);
% isp2 = ispikes('0002',1);
isp1d = struct(isp1);
isp2d = struct(isp2);
etd = struct(et);
ind1 = et.sequence.control(1);
ind2 = et.sequence.control(2);
ind3 = et.sequence.control(3);
% get results of trials in ind1, find the indices in results that had 
% correct result, and then get the actual trial number corresponding to 
% those indices.
ind1 = ind1(find(et.results(ind1)));
ind2 = ind2(find(et.results(ind2)));
ind3 = ind3(find(et.results(ind3)));
indlength1 = size(ind1,1);
indlength2 = size(ind2,1);
indlength3 = size(ind3,1);
indlength = indlength1 + indlength2 + indlength3;
pheight = 1/indlength;
ph2 = pheight/2;
pvec = 0:pheight:1;
xmax = 0;
for i = 1:indlength1
	% subplot('position',[0.05 pvec(i) 0.9 pheight])
	% get stimulus onset
	onset = etd.onsetsMS(ind1(i));
	sp1 = isp1d.trial(ind1(i)).cluster.spikes;
	% get time of last spike
	spt = sp1(end);
	if(spt>xmax)
		xmax = spt;
	end
	sp2 = isp2d.trial(ind1(i)).cluster.spikes;
	% get time of last spike
	spt = sp2(end);
	if(spt>xmax)
		xmax = spt;
	end
	pv2 = pvec(i) + ph2;
	line([sp1;sp1],[pvec(i) pv2],'Color',[0 0 1]);
	% hold on
	line([sp2;sp2],[pv2 pvec(i+1)],'Color',[1 0 0]);
    line([onset onset],[pvec(i) pvec(i+1)],'Color',[0 1 0]);
	% hold off
	% set(gca,'XTick',[],'YTick',[])
	% pause
end
for i = 1:indlength2
	j = indlength1 + i;
	% subplot('position',[0.05 pvec(indlength1+i) 0.9 pheight])
	% get stimulus onset
	onset = etd.onsetsMS(ind2(i));
	sp1 = isp1d.trial(ind2(i)).cluster.spikes;
	% get time of last spike
	spt = sp1(end);
	if(spt>xmax)
		xmax = spt;
	end
	sp2 = isp2d.trial(ind2(i)).cluster.spikes;
	% get time of last spike
	spt = sp2(end);
	if(spt>xmax)
		xmax = spt;
	end
	pv2 = pvec(j) + ph2;
	line([sp1;sp1],[pvec(j) pv2],'Color',[0 0 1]);
	% hold on
	line([sp2;sp2],[pv2 pvec(j+1)],'Color',[1 0 0]);
    line([onset onset],[pvec(j) pvec(j+1)],'Color',[0 1 0]);
	% hold off
	% set(gca,'XTick',[],'YTick',[],'Color',repmat(0.8,1,3))
	% pause
end
y = indlength1 + indlength2;
for i = 1:indlength3
	j = y + i;
	% subplot('position',[0.05 pvec(y+i) 0.9 pheight])
	% get stimulus onset
	onset = etd.onsetsMS(ind3(i));
	sp1 = isp1d.trial(ind3(i)).cluster.spikes;
	% get time of last spike
	spt = sp1(end);
	if(spt>xmax)
		xmax = spt;
	end
	sp2 = isp2d.trial(ind3(i)).cluster.spikes;
	% get time of last spike
	spt = sp2(end);
	if(spt>xmax)
		xmax = spt;
	end
	pv2 = pvec(j) + ph2;
	line([sp1;sp1],[pvec(j) pv2],'Color',[0 0 1]);
	% hold on
	line([sp2;sp2],[pv2 pvec(j+1)],'Color',[1 0 0]);
    line([onset onset],[pvec(j) pvec(j+1)],'Color',[0 1 0]);
	% hold off
	% set(gca,'XTick',[],'YTick',[],'Color',repmat(0.6,1,3))
	% pause
end

xlim([0 xmax])

% draw regions corresponding to salience steps
y0 = pvec(1);
y1 = pvec(indlength1+1);
patch([0 0 xmax xmax],[y0 y1 y1 y0],repmat(1,1,3));
y0 = y1;
y1 = pvec(y+1);
patch([0 0 xmax xmax],[y0 y1 y1 y0],repmat(0.8,1,3));
y0 = y1;
y1 = pvec(end);
patch([0 0 xmax xmax],[y0 y1 y1 y0],repmat(0.6,1,3));

% move patch objects to the back
chi = get(gca,'Children');
set(gca,'Children',flipud(chi));
