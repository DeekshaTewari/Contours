function r = diff(p,q)
%SESINFO/DIFF List differences between SESINFO objects
%   R = DIFF(P,Q) lists differences between SESINFO objects P and Q. 
%   R is 0 if there are no differences and 1 otherwise. The differences 
%   will also be printed out to the screen.
%
%   Dependencies: None.

% will return 0 for no change if nothing is different
r = 0;

if ~strcmp(p.data.presenterversion,q.data.presenterversion)
	r = 1;
	fprintf('presenterversion: %s\t%s\n', p.data.presenterversion, q.data.presenterversion);
end

if p.data.width~=q.data.width
	r = 1;
	fprintf('width: %i\t%i\n', p.data.width, q.data.width);
end

if p.data.height~=q.data.height
	r = 1;
	fprintf('height: %i\t%i\n', p.data.height, q.data.height);
end

if p.data.density~=q.data.density
	r = 1;
	fprintf('density: %i\t%i\n', p.data.density, q.data.density);
end

if p.data.bgspacing~=q.data.bgspacing
	r = 1;
	fprintf('bgspacing: %i\t%i\n', p.data.bgspacing, q.data.bgspacing);
end

if p.data.fgspacing~=q.data.fgspacing
	r = 1;
	fprintf('fgspacing: %i\t%i\n', p.data.fgspacing, q.data.fgspacing);
end

if p.data.angle~=q.data.angle
	r = 1;
	fprintf('angle: %i\t%i\n', p.data.angle, q.data.angle);
end

if p.data.orijitter~=q.data.orijitter
	r = 1;
	fprintf('orijitter: %i\t%i\n', p.data.orijitter, q.data.orijitter);
end

if p.data.figelts~=q.data.figelts
	r = 1;
	fprintf('figelts: %i\t%i\n', p.data.figelts, q.data.figelts);
end

if p.data.stimdim~=q.data.stimdim
	r = 1;
	fprintf('stimdim: %i\t%i\n', p.data.stimdim, q.data.stimdim);
end

if p.data.stimincr~=q.data.stimincr
	r = 1;
	fprintf('stimincr: %i\t%i\n', p.data.stimincr, q.data.stimincr);
end

if p.data.stimend~=q.data.stimend
	r = 1;
	fprintf('stimend: %i\t%i\n', p.data.stimend, q.data.stimend);
end

if p.data.catchtrials~=q.data.catchtrials
	r = 1;
	fprintf('catchtrials: %i\t%i\n', p.data.catchtrials, q.data.catchtrials);
end

if p.data.gabsize~=q.data.gabsize
	r = 1;
	fprintf('gabsize: %i\t%i\n', p.data.gabsize, q.data.gabsize);
end

if p.data.vel~=q.data.vel
	r = 1;
	fprintf('vel: %i\t%i\n', p.data.vel, q.data.vel);
end

if p.data.sf~=q.data.sf
	r = 1;
	fprintf('sf: %i\t%i\n', p.data.sf, q.data.sf);
end

if p.data.ecc~=q.data.ecc
	r = 1;
	fprintf('ecc: %i\t%i\n', p.data.ecc, q.data.ecc);
end

if p.data.restricttarget~=q.data.restricttarget
	r = 1;
	fprintf('restricttarget: %i\t%i\n', p.data.restricttarget, q.data.restricttarget);
end

if p.data.restricttargetstart~=q.data.restricttargetstart
	r = 1;
	fprintf('restricttargetstart: %i\t%i\n', p.data.restricttargetstart, q.data.restricttargetstart);
end

if p.data.restricttargetend~=q.data.restricttargetend
	r = 1;
	fprintf('restricttargetend: %i\t%i\n', p.data.restricttargetend, q.data.restricttargetend);
end

if p.data.contourtype~=q.data.contourtype
	r = 1;
	fprintf('contourtype: %i\t%i\n', p.data.contourtype, q.data.contourtype);
end

if p.data.stimmotion~=q.data.stimmotion
	r = 1;
	fprintf('stimmotion: %i\t%i\n', p.data.stimmotion, q.data.stimmotion);
end

if p.data.stimsets~=q.data.stimsets
	r = 1;
	fprintf('stimsets: %i\t%i\n', p.data.stimsets, q.data.stimsets);
end

if p.data.numstim~=q.data.numstim
	r = 1;
	fprintf('numstim: %i\t%i\n', p.data.numstim, q.data.numstim);
end

if p.data.repeatblocks~=q.data.repeatblocks
	r = 1;
	fprintf('repeatblocks: %i\t%i\n', p.data.repeatblocks, q.data.repeatblocks);
end

if p.data.repeats~=q.data.repeats
	r = 1;
	fprintf('repeats: %i\t%i\n', p.data.repeats, q.data.repeats);
end

if p.data.trials~=q.data.trials
	r = 1;
	fprintf('trials: %i\t%i\n', p.data.trials, q.data.trials);
end

if p.data.includetuning~=q.data.includetuning
	r = 1;
	fprintf('includetuning: %i\t%i\n', p.data.includetuning, q.data.includetuning);
end

if p.data.numtuningdir~=q.data.numtuningdir
	r = 1;
	fprintf('numtuningdir: %i\t%i\n', p.data.numtuningdir, q.data.numtuningdir);
end

if p.data.tuningstepsize~=q.data.tuningstepsize
	r = 1;
	fprintf('tuningstepsize: %i\t%i\n', p.data.tuningstepsize, q.data.tuningstepsize);
end

if p.data.fixx~=q.data.fixx
	r = 1;
	fprintf('fixx: %i\t%i\n', p.data.fixx, q.data.fixx);
end

if p.data.fixy~=q.data.fixy
	r = 1;
	fprintf('fixy: %i\t%i\n', p.data.fixy, q.data.fixy);
end

if p.data.fixsize~=q.data.fixsize
	r = 1;
	fprintf('fixsize: %i\t%i\n', p.data.fixsize, q.data.fixsize);
end

if p.data.fixtype~=q.data.fixtype
	r = 1;
	fprintf('fixtype: %i\t%i\n', p.data.fixtype, q.data.fixtype);
end

if p.data.figcont~=q.data.figcont
	r = 1;
	fprintf('figcont: %i\t%i\n', p.data.figcont, q.data.figcont);
end

if p.data.fixcont~=q.data.fixcont
	r = 1;
	fprintf('fixcont: %i\t%i\n', p.data.fixcont, q.data.fixcont);
end

if p.data.bglum~=q.data.bglum
	r = 1;
	fprintf('bglum: %i\t%i\n', p.data.bglum, q.data.bglum);
end

if p.data.fixwinsize~=q.data.fixwinsize
	r = 1;
	fprintf('fixwinsize: %i\t%i\n', p.data.fixwinsize, q.data.fixwinsize);
end

if p.data.targetwinsize~=q.data.targetwinsize
	r = 1;
	fprintf('targetwinsize: %i\t%i\n', p.data.targetwinsize, q.data.targetwinsize);
end

if p.data.usetargetcenter~=q.data.usetargetcenter
	r = 1;
	fprintf('usetargetcenter: %i\t%i\n', p.data.usetargetcenter, q.data.usetargetcenter);
end

if p.data.tcentercontrast~=q.data.tcentercontrast
	r = 1;
	fprintf('tcentercontrast: %i\t%i\n', p.data.tcentercontrast, q.data.tcentercontrast);
end

if p.data.showstimwithfix~=q.data.showstimwithfix
	r = 1;
	fprintf('showstimwithfix: %i\t%i\n', p.data.showstimwithfix, q.data.showstimwithfix);
end

if p.data.transient~=q.data.transient
	r = 1;
	fprintf('transient: %i\t%i\n', p.data.transient, q.data.transient);
end

if p.data.maskp~=q.data.maskp
	r = 1;
	fprintf('maskp: %i\t%i\n', p.data.maskp, q.data.maskp);
end

if p.data.paradigm~=q.data.paradigm
	r = 1;
	fprintf('paradigm: %i\t%i\n', p.data.paradigm, q.data.paradigm);
end

if p.data.stimstart~=q.data.stimstart
	r = 1;
	fprintf('stimstart: %i\t%i\n', p.data.stimstart, q.data.stimstart);
end

if p.data.stimsteps~=q.data.stimsteps
	r = 1;
	fprintf('stimsteps: %i\t%i\n', p.data.stimsteps, q.data.stimsteps);
end

if p.data.stim_p~=q.data.stim_p
	r = 1;
	fprintf('stim_p: %i\t%i\n', p.data.stim_p, q.data.stim_p);
end

if p.data.iti~=q.data.iti
	r = 1;
	fprintf('iti: %i\t%i\n', p.data.iti, q.data.iti);
end

if p.data.itimax~=q.data.itimax
	r = 1;
	fprintf('itimax: %i\t%i\n', p.data.itimax, q.data.itimax);
end

if p.data.riti~=q.data.riti
	r = 1;
	fprintf('riti: %i\t%i\n', p.data.riti, q.data.riti);
end

if p.data.audio~=q.data.audio
	r = 1;
	fprintf('audio: %i\t%i\n', p.data.audio, q.data.audio);
end

if p.data.cuelat~=q.data.cuelat
	r = 1;
	fprintf('cuelat: %i\t%i\n', p.data.cuelat, q.data.cuelat);
end

if p.data.cuelatmax~=q.data.cuelatmax
	r = 1;
	fprintf('cuelatmax: %i\t%i\n', p.data.cuelatmax, q.data.cuelatmax);
end

if p.data.rcuelat~=q.data.rcuelat
	r = 1;
	fprintf('rcuelat: %i\t%i\n', p.data.rcuelat, q.data.rcuelat);
end

if p.data.cuedur~=q.data.cuedur
	r = 1;
	fprintf('cuedur: %i\t%i\n', p.data.cuedur, q.data.cuedur);
end

if p.data.cuedurmax~=q.data.cuedurmax
	r = 1;
	fprintf('cuedurmax: %i\t%i\n', p.data.cuedurmax, q.data.cuedurmax);
end

if p.data.rcuedur~=q.data.rcuedur
	r = 1;
	fprintf('rcuedur: %i\t%i\n', p.data.rcuedur, q.data.rcuedur);
end

if p.data.postcuedur~=q.data.postcuedur
	r = 1;
	fprintf('postcuedur: %i\t%i\n', p.data.postcuedur, q.data.postcuedur);
end

if p.data.postcuedurmax~=q.data.postcuedurmax
	r = 1;
	fprintf('postcuedurmax: %i\t%i\n', p.data.postcuedurmax, q.data.postcuedurmax);
end

if p.data.rpostcuedur~=q.data.rpostcuedur
	r = 1;
	fprintf('rpostcuedur: %i\t%i\n', p.data.rpostcuedur, q.data.rpostcuedur);
end

if p.data.fixlimit~=q.data.fixlimit
	r = 1;
	fprintf('fixlimit: %i\t%i\n', p.data.fixlimit, q.data.fixlimit);
end

if p.data.stimlat~=q.data.stimlat
	r = 1;
	fprintf('stimlat: %i\t%i\n', p.data.stimlat, q.data.stimlat);
end

if p.data.stimlatmax~=q.data.stimlatmax
	r = 1;
	fprintf('stimlatmax: %i\t%i\n', p.data.stimlatmax, q.data.stimlatmax);
end

if p.data.rstimlat~=q.data.rstimlat
	r = 1;
	fprintf('rstimlat: %i\t%i\n', p.data.rstimlat, q.data.rstimlat);
end

if p.data.stimdur~=q.data.stimdur
	r = 1;
	fprintf('stimdur: %i\t%i\n', p.data.stimdur, q.data.stimdur);
end

if p.data.stimdurmax~=q.data.stimdurmax
	r = 1;
	fprintf('stimdurmax: %i\t%i\n', p.data.stimdurmax, q.data.stimdurmax);
end

if p.data.rstimdur~=q.data.rstimdur
	r = 1;
	fprintf('rstimdur: %i\t%i\n', p.data.rstimdur, q.data.rstimdur);
end

if p.data.poststimdur~=q.data.poststimdur
	r = 1;
	fprintf('poststimdur: %i\t%i\n', p.data.poststimdur, q.data.poststimdur);
end

if p.data.poststimdurmax~=q.data.poststimdurmax
	r = 1;
	fprintf('poststimdurmax: %i\t%i\n', p.data.poststimdurmax, q.data.poststimdurmax);
end

if p.data.rpoststimdur~=q.data.rpoststimdur
	r = 1;
	fprintf('rpoststimdur: %i\t%i\n', p.data.rpoststimdur, q.data.rpoststimdur);
end

if p.data.matchlat~=q.data.matchlat
	r = 1;
	fprintf('matchlat: %i\t%i\n', p.data.matchlat, q.data.matchlat);
end

if p.data.matchlatmax~=q.data.matchlatmax
	r = 1;
	fprintf('matchlatmax: %i\t%i\n', p.data.matchlatmax, q.data.matchlatmax);
end

if p.data.rmatchlat~=q.data.rmatchlat
	r = 1;
	fprintf('rmatchlat: %i\t%i\n', p.data.rmatchlat, q.data.rmatchlat);
end

if p.data.matchlimit~=q.data.matchlimit
	r = 1;
	fprintf('matchlimit: %i\t%i\n', p.data.matchlimit, q.data.matchlimit);
end

if p.data.reward~=q.data.reward
	r = 1;
	fprintf('reward: %i\t%i\n', p.data.reward, q.data.reward);
end

if p.data.rewardmax~=q.data.rewardmax
	r = 1;
	fprintf('rewardmax: %i\t%i\n', p.data.rewardmax, q.data.rewardmax);
end

if p.data.rreward~=q.data.rreward
	r = 1;
	fprintf('rreward: %i\t%i\n', p.data.rreward, q.data.rreward);
end

if p.data.penalty~=q.data.penalty
	r = 1;
	fprintf('penalty: %i\t%i\n', p.data.penalty, q.data.penalty);
end

if p.data.penaltymax~=q.data.penaltymax
	r = 1;
	fprintf('penaltymax: %i\t%i\n', p.data.penaltymax, q.data.penaltymax);
end

if p.data.rpenalty~=q.data.rpenalty
	r = 1;
	fprintf('rpenalty: %i\t%i\n', p.data.rpenalty, q.data.rpenalty);
end

if p.data.etfix~=q.data.etfix
	r = 1;
	fprintf('etfix: %i\t%i\n', p.data.etfix, q.data.etfix);
end

if p.data.etstray~=q.data.etstray
	r = 1;
	fprintf('etstray: %i\t%i\n', p.data.etstray, q.data.etstray);
end

% p.data.sequence is always different so don't bother comparing
