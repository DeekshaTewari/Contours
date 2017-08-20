function obj = plot(obj,varargin)
%TIMING/PLOT Plot data from TIMING object
%   T = PLOT(T,N) plots the data in the TIMING object T for session
%   N, with lines separating different salience values. By
%   default, it plots the median and quartiles for the reaction
%   times for the contour trials without catch trials. The raw
%   reaction times are also plotted. The T object is returned
%   by the function.
%
%   PLOT(T,N,'overall') plots the overall median and quartiles
%   along with the session data.
%
%   PLOT(T) plots all the data points along with the median and
%   quartiles.
%
%   PLOT(...,'includecatch') includes data for catch trials.
%
%   PLOT(...,'control') plots the reaction times for the control
%   trials.
%
%   PLOT(...,'plots',PVEC) specifies which contour locations
%   are to be plotted. PVEC is a 2 element vector of 0 and 1
%   representing the following: [plotcontour plotcontrol] where:
%      plotcontour: Plots data at the target location.
%      plotcontrol: Plots data at the control location.
%   e.g. PLOT(T,N,'plots',[1 1]) plots data at both the target
%   and control locations.
%
%   PLOT(...,'catchstep',NUM) separates the data for the catch
%   trials by NUM steps. The default value is 5 steps.
%
%   Dependencies: None.

Args = struct('Overall',0,'CatchStep',5);
Args.flags = {'Overall'};
[Args,varargin] = getOptArgs(varargin,Args);

if(isempty(Args.NumericArguments))
    % individual data set not specified so plot only overall data
    Args.Session = 0;
    Args.Overall = 1;
else
    n = Args.NumericArguments{1};
    Args.Session = 1;
end

plotcontour = 1;
% if there are control trials, set plotcontrol to 1
if(obj.eyestarget.stim_steps.control>0)
    plotcontrol = 1;
else
    plotcontrol = 0;
end
% if there are catch trials, set plotcatch to 1
if(obj.eyestarget.stim_steps.catchcontour)
    plotcatch = 1;
else
    plotcatch = 0;
end

stim_p = obj.eyestarget.stim_p;
cla
hold on
% initialize legend handles and legend string
lhandles = [];
lstring = {};
slimiters = [];
tlc = 0;
% initialize errorbar data
ebdata = [];

% plot raw data for session, add median and quartiles, and then add
% raw data, medians and quartiles from catch trials if present
if Args.Session
    % put a title on the plot
    title(obj.sessionname{n});
    if plotcontour
        % plot raw data
        for sal = 1:obj.eyestarget.stim_steps.contour
            % contour correct
            % get indexes for this session, this salience condition
            ind = obj.data.contour(sal).indexes(n,:);
            % get the reaction times for this session, this salience condition
            t = obj.data.contour(sal).timing(ind(1):ind(2));
            % need to subtract ind(1) from ind(2) in case we are dealing
            % with an object with multiple sessions where their indices
            % would have been added together
            tl = ind(2) - ind(1) + 1;
            if (tl > 0)
                if (sal==1)
                    % first salience condition so just plot the data
                    % and stick tl in slimiters
                    plot(t,'b.')
                    slimiters = max(2,tl);
                    ebdata = [obj.data.median.contour(sal,n) ...
                        obj.data.quartiles.contour(sal,n,1) ...
                        obj.data.quartiles.contour(sal,n,2)];
                else
                    % not first plot so add last slimiter value to 1:tl
                    % px = slimiters(sal-1);
                    px = slimiters(end);
                    plot(px+(1:tl),t,'b.');
                    % just to make sure that slimiters are separated by at least
                    % 2, we add max(2,tl) to px
                    slimiters = [slimiters px+max(2,tl)];
                    ebdata = [ebdata; obj.data.median.contour(sal,n) ...
                        obj.data.quartiles.contour(sal,n,1) ...
                        obj.data.quartiles.contour(sal,n,2)];
                end
            else % if (tl > 0)
                if (sal==1)
                    % first salience condition so set up an empty bin
                    slimiters = 2;
                else
                    % no entries in this salience condition so just add 1 to slimiters
                    % so there will be space for the overall data point
                    % slimiters = [slimiters slimiters(sal-1)+2];
                    slimiters = [slimiters slimiters(end)+2];
                end
                ebdata = [ebdata; repmat(nan,1,3)];
            end % if (tl > 0)
            
%             % contour incorrect
%             % get indexes for this session, this salience condition
%             ind = obj.data.incorrect.contour(sal).indexes(n,:);
%             % get the reaction times for this session, this salience condition
%             t = obj.data.incorrect.contour(sal).timing(ind(1):ind(2));
%             % need to subtract ind(1) from ind(2) in case we are dealing
%             % with an object with multiple sessions where their indices
%             % would have been added together
%             tl = ind(2) - ind(1) + 1;
%             if (tl > 0)
%                 % can't be first plot so add last slimiter value to 1:tl
%                 px = slimiters(end);
%                 plot(px+(1:tl),t,'bx');
%                 % just to make sure that slimiters are separated by at least
%                 % 2, we add max(2,tl) to px
%                 slimiters = [slimiters px+max(2,tl)];
%                 ebdata = [ebdata; obj.data.incorrect.median.contour(sal,n) ...
%                     obj.data.incorrect.quartiles.contour(sal,n,1) ...
%                     obj.data.incorrect.quartiles.contour(sal,n,2)];
%             else
%                 % no entries in this salience condition so just add 1 to slimiters
%                 % so there will be space for the overall data point
%                 slimiters = [slimiters slimiters(end)+2];
%                 ebdata = [ebdata; repmat(nan,1,3)];
%             end
            
            if(plotcontrol)
                % control correct
                % get indexes for this session, this salience condition
                ind = obj.data.control(sal).indexes(n,:);
                % get the reaction times for this session, this salience condition
                t = obj.data.control(sal).timing(ind(1):ind(2));
                % need to subtract ind(1) from ind(2) in case we are dealing
                % with an object with multiple sessions where their indices
                % would have been added together
                tl = ind(2) - ind(1) + 1;
                if (tl > 0)
                    % can't be first plot so add last slimiter value to 1:tl
                    px = slimiters(end);
                    plot(px+(1:tl),t,'r.');
                    % just to make sure that slimiters are separated by at least
                    % 2, we add max(2,tl) to px
                    slimiters = [slimiters px+max(2,tl)];
                    ebdata = [ebdata; obj.data.median.control(sal,n) ...
                        obj.data.quartiles.control(sal,n,1) ...
                        obj.data.quartiles.control(sal,n,2)];
                else
                    % no entries in this salience condition so just add 1 to slimiters
                    % so there will be space for the overall data point
                    slimiters = [slimiters slimiters(end)+2];
                    ebdata = [ebdata; repmat(nan,1,3)];
                end
                
%                 % control incorrect
%                 % get indexes for this session, this salience condition
%                 ind = obj.data.incorrect.control(sal).indexes(n,:);
%                 % get the reaction times for this session, this salience condition
%                 t = obj.data.incorrect.control(sal).timing(ind(1):ind(2));
%                 % need to subtract ind(1) from ind(2) in case we are dealing
%                 % with an object with multiple sessions where their indices
%                 % would have been added together
%                 tl = ind(2) - ind(1) + 1;
%                 if (tl > 0)
%                     % can't be first plot so add last slimiter value to 1:tl
%                     px = slimiters(end);
%                     plot(px+(1:tl),t,'rx');
%                     % just to make sure that slimiters are separated by at least
%                     % 2, we add max(2,tl) to px
%                     slimiters = [slimiters px+max(2,tl)];
%                     ebdata = [ebdata; obj.data.incorrect.median.control(sal,n) ...
%                         obj.data.incorrect.quartiles.control(sal,n,1) ...
%                         obj.data.incorrect.quartiles.control(sal,n,2)];
%                 else
%                     % no entries in this salience condition so just add 1 to slimiters
%                     % so there will be space for the overall data point
%                     slimiters = [slimiters slimiters(end)+2];
%                     ebdata = [ebdata; repmat(nan,1,3)];
%                 end
            end % if(plotcontrol)
        end % for sal = 1:obj.eyestarget.stim_steps.contour
        
        % plot catchcontour data if there are any
        if (plotcatch)
            % catchcontour correct
            % get indexes for this session
            ind = obj.data.catchcontour.indexes(n,:);
            % get the reaction times for this session
            t = obj.data.catchcontour.timing(ind(1):ind(2));
            tl = ind(2) - ind(1) + 1;
            if (tl > 0)
                px = slimiters(end);
                plot(px+(1:tl),t,'b.');
                % just to make sure that slimiters are separated by at least
                % 2, we add max(2,tl) to px
                slimiters = [slimiters px+max(2,tl)];
                ebdata = [ebdata; obj.data.median.catchcontour(1,n) ...
                    obj.data.quartiles.catchcontour(1,n,1) ...
                    obj.data.quartiles.catchcontour(1,n,2)];
            else
                % no entries in this salience condition so just add 1 to slimiters
                % so there will be space for the overall data point
                slimiters = [slimiters slimiters(end)+2];
                ebdata = [ebdata; repmat(nan,1,3)];
            end
            
%             % catchcontour incorrect
%             % get indexes for this session
%             ind = obj.data.incorrect.catchcontour.indexes(n,:);
%             % get the reaction times for this session
%             t = obj.data.incorrect.catchcontour.timing(ind(1):ind(2));
%             tl = ind(2) - ind(1) + 1;
%             if (tl > 0)
%                 px = slimiters(end);
%                 plot(px+(1:tl),t,'b.');
%                 % just to make sure that slimiters are separated by at least
%                 % 2, we add max(2,tl) to px
%                 slimiters = [slimiters px+max(2,tl)];
%                 ebdata = [ebdata; obj.data.incorrect.median.catchcontour(1,n) ...
%                     obj.data.incorrect.quartiles.catchcontour(1,n,1) ...
%                     obj.data.incorrect.quartiles.catchcontour(1,n,2)];
%             else
%                 % no entries in this salience condition so just add 1 to slimiters
%                 % so there will be space for the overall data point
%                 slimiters = [slimiters slimiters(end)+2];
%                 ebdata = [ebdata; repmat(nan,1,3)];
%             end
            
            if(plotcontrol)
                % catchcontrol correct
                % get indexes for this session
                ind = obj.data.catchcontrol.indexes(n,:);
                % get the reaction times for this session
                t = obj.data.catchcontrol.timing(ind(1):ind(2));
                tl = ind(2) - ind(1) + 1;
                if (tl > 0)
                    px = slimiters(end);
                    plot(px+(1:tl),t,'b.');
                    % just to make sure that slimiters are separated by at least
                    % 2, we add max(2,tl) to px
                    slimiters = [slimiters px+max(2,tl)];
                    ebdata = [ebdata; obj.data.median.catchcontrol(1,n) ...
                        obj.data.quartiles.catchcontrol(1,n,1) ...
                        obj.data.quartiles.catchcontrol(1,n,2)];
                else
                    % no entries in this salience condition so just add 1 to slimiters
                    % so there will be space for the overall data point
                    slimiters = [slimiters slimiters(end)+2];
                    ebdata = [ebdata; repmat(nan,1,3)];
                end
                
%                 % catchcontrol incorrect
%                 % get indexes for this session
%                 ind = obj.data.incorrect.catchcontrol.indexes(n,:);
%                 % get the reaction times for this session
%                 t = obj.data.incorrect.catchcontrol.timing(ind(1):ind(2));
%                 tl = ind(2) - ind(1) + 1;
%                 if (tl > 0)
%                     px = slimiters(end);
%                     plot(px+(1:tl),t,'b.');
%                     % just to make sure that slimiters are separated by at least
%                     % 2, we add max(2,tl) to px
%                     slimiters = [slimiters px+max(2,tl)];
%                     ebdata = [ebdata; obj.data.incorrect.median.catchcontrol(1,n) ...
%                         obj.data.incorrect.quartiles.catchcontrol(1,n,1) ...
%                         obj.data.incorrect.quartiles.catchcontrol(1,n,2)];
%                 else
%                     % no entries in this salience condition so just add 1 to slimiters
%                     % so there will be space for the overall data point
%                     slimiters = [slimiters slimiters(end)+2];
%                     ebdata = [ebdata; repmat(nan,1,3)];
%                 end
            end % if(plotcontrol)
        end % if(plotcatch)
        
        % plot medians and quartiles for this session
        % get the centers of each condition
        slimiters1 = diff([0 slimiters]);
        slimiters2 = floor(slimiters1/2) + [0 slimiters(1:(end-1))];
        slsize = length(slimiters2);

        if(plotcontrol)
        	if(plotcatch)
        		% plot contour, control, & catch
        		ctourcidx = 1:2:slsize;
        		% ctourwidx = 2:4:slsize;
        		ctrolcidx = 2:2:slsize;
        		% ctrolwidx = 4:4:slsize;
        		
        		cctourcidx = slsize - 1;
        		% cctourwifx = slsize - 2;
        		cctrolcidx = slsize;
        		% cctrolwidx = slsize;
        		
        		sa = errorbar(slimiters2(ctourcidx) - 0.5,ebdata(ctourcidx,1), ...
        				ebdata(ctourcidx,2), ebdata(ctourcidx,3),'.');
				lhandles = [lhandles sa(end)];
				lstring = {lstring{:}, 'contour correct'};

%         		sa = errorbar(slimiters2(ctourwidx) - 0.5,ebdata(ctourwidx,1), ...
%         				ebdata(ctourwidx,2), ebdata(ctourwidx,3),'.');
% 				lhandles = [lhandles sa(end)];
% 				lstring = {lstring{:}, 'contour incorrect'};

        		sa = errorbar(slimiters2(ctrolcidx) - 0.5,ebdata(ctrolcidx,1), ...
        				ebdata(ctrolcidx,2), ebdata(ctrolcidx,3),'.');
				lhandles = [lhandles sa(end)];
				lstring = {lstring{:}, 'control correct'};
				
%         		sa = errorbar(slimiters2(ctrolcidx) - 0.5,ebdata(ctrolcidx,1), ...
%         				ebdata(ctrolcidx,2), ebdata(ctrolcidx,3),'.');
% 				lhandles = [lhandles sa(end)];
% 				lstring = {lstring{:}, 'control incorrect'};

        		sa = errorbar(slimiters2(cctourcidx) - 0.5,ebdata(cctourcidx,1), ...
        				ebdata(cctourcidx,2), ebdata(cctourcidx,3),'.');
				lhandles = [lhandles sa(end)];
				lstring = {lstring{:}, 'catchcontour correct'};

%         		sa = errorbar(slimiters2(cctourwifx) - 0.5,ebdata(cctourwifx,1), ...
%         				ebdata(cctourwifx,2), ebdata(cctourwifx,3),'.');
% 				lhandles = [lhandles sa(end)];
% 				lstring = {lstring{:}, 'catchcontour incorrect'};

        		sa = errorbar(slimiters2(cctrolcidx) - 0.5,ebdata(cctrolcidx,1), ...
        				ebdata(cctrolcidx,2), ebdata(cctrolcidx,3),'.');
				lhandles = [lhandles sa(end)];
				lstring = {lstring{:}, 'catchcontrol correct'};
				
%         		sa = errorbar(slimiters2(cctrolwidx) - 0.5,ebdata(cctrolwidx,1), ...
%         				ebdata(cctrolwidx,2), ebdata(cctrolwidx,3),'.');
% 				lhandles = [lhandles sa(end)];
% 				lstring = {lstring{:}, 'catchcontrol incorrect'};
				
				set(gca,'XTick',slimiters2)
				set(gca,'XTickLabel',reshape(repmat(stim_p,4,1),[],1))

				legend(lstring)
        	else
        		% plot contour & control
        	end
        else
        	if(plotcatch)
        		% plot contour & catch
        	else
        		% plot contour
        	end
        end

%         if(plotcontrol)
%             % shift slimiters left by 0.5 so as not to overlap with raw data points
%             sa = errorbar(slimiters2 - 0.5,obj.data.median.contour(:,n),...
%                 obj.data.quartiles.contour(:,n,1),obj.data.quartiles.contour(:,n,2),'bo');
%         else
%             % shift slimiters left by 0.5 so as not to overlap with raw data points
%             sa = errorbar(slimiters2 - 0.5,obj.data.median.contour(:,n),...
%                 obj.data.quartiles.contour(:,n,1),obj.data.quartiles.contour(:,n,2),'bo');
%         end
%         lhandles = [lhandles sa(end)];
%         lstring = {lstring{:}, 'contour'};
%         
%         % make sure tlc is at least 2 so that when we plot the medians and
%         % quartiles, it will be centered
%         tlc = max(2,tlc);
%         
%         % plot medians and quartiles for this session
%         % put the plot in the center of this bin, and shifted to the left by 0.5
%         errorbar(slimiters(end)+floor(tlc/2)-0.5,obj.data.median.catchcontour(:,n),...
%             obj.data.quartiles.catchcontour(1,n,1),...
%             obj.data.quartiles.catchcontour(1,n,2),'bo');
%         % end
%         % end % if (~isempty(obj.data.catchcontour))
%     end % if plotcontour
%     
%     if plotcontrol
%         for sal = 1:obj.eyestarget.stim_steps.control
%             % get indexes for this session, this salience condition
%             ind = obj.data.control(sal).indexes(n,:);
%             % get the reaction times for this session, this salience condition
%             t = obj.data.control(sal).timing(ind(1):ind(2));
%             tl = ind(2) - ind(1) + 1;
%             if (tl > 0)
%                 if (sal==1)
%                     % first salience condition so just plot the data
%                     % and stick tl in slimiters
%                     plot(t,'r.')
%                     slimiters = max(2,tl);
%                 else
%                     % not first plot so add last slimiter value to 1:tl
%                     % px = slimiters(sal-1);
%                     px = slimiters(end);
%                     plot(px+(1:tl),t,'r.');
%                     % just to make sure that slimiters are separated by at least
%                     % 2, we add max(2,tl) to px
%                     slimiters = [slimiters px+max(2,tl)];
%                 end
%             else
%                 if (sal==1)
%                     % first salience condition so set up an empty bin
%                     slimiters = 2;
%                 else
%                     % no entries in this salience condition so just add 1 to slimiters
%                     % so there will be space for the overall data point
%                     % slimiters = [slimiters slimiters(sal-1)+2];
%                     slimiters = [slimiters slimiters(end)+2];
%                 end
%             end % if (tl > 0)
%         end % for sal = 1:obj.eyestarget.stim_steps.control
%         
%         % plot medians and quartiles for this session
%         % get the centers of each condition
%         slimiters1 = diff([0 slimiters]);
%         slimiters2 = floor(slimiters1/2) + [0 slimiters(1:(end-1))];
%         sa = errorbar(slimiters2 - 0.5,obj.data.median.control(:,n),...
%             obj.data.quartiles.control(:,n,1),obj.data.quartiles.control(:,n,2),'ro');
%         lhandles = [lhandles sa(end)];
%         lstring = {lstring{:}, 'control'};
%         
%         % plot catchcontrol data if there are any
%         if (~isempty(obj.data.catchcontrol))
%             % get indexes for this session
%             ind = obj.data.catchcontrol.indexes(n,:);
%             % get the reaction times for this session
%             t = obj.data.catchcontrol.timing(ind(1):ind(2));
%             tlc = ind(2) - ind(1) + 1;
%             if (tlc > 0)
%                 plot(slimiters(end)+(1:tlc),t,'r.');
%                 % make sure tlc is at least 2 so that when we plot the medians and
%                 % quartiles, it will be centered
%                 tlc = max(2,tlc);
%                 
%                 % plot medians and quartiles for this session
%                 % put the plot in the center of this bin, and shifted to the left by 0.5
%                 errorbar(slimiters(end)+floor(tlc/2)-0.5,obj.data.median.catchcontrol(:,n),...
%                     obj.data.quartiles.catchcontrol(1,n,1),...
%                     obj.data.quartiles.catchcontrol(1,n,2),'ro');
%             end
%         end % if (~isempty(obj.data.catchcontrol))
    end % if plotcontrol
end % if Args.Session

% if overall only, plot all reaction times
% medians and quartiles will be plotted later
if (Args.Overall & (~Args.Session))
    if plotcontour
        % plot raw data
        for sal = 1:obj.eyestarget.stim_steps.contour
            % get all reaction times for this salience condition
            t = obj.data.contour(sal).timing;
            % the second col of the last row should contain the total number of points
            tl = obj.data.contour(sal).indexes(end,2);
            if (tl > 0)
                if (sal==1)
                    % first salience condition so just plot the data
                    % and stick tl in slimiters
                    plot(t,'b.');
                    slimiters = max(2,tl);
                else
                    % not the first plot so add last slimiter value to 1:tl
                    px = slimiters(end);
                    plot(px+(1:tl),t,'b.');
                    % just to make sure that slimiters are separated by at least
                    % 2, we add max(2,tl) to px
                    slimiters = [slimiters px+max(2,tl)];
                end
            else
                if (sal==1)
                    % first salience condition so set up an empty bin
                    slimiters = 2;
                else
                    % no entries in this salience condition so just add 1 to slimiters
                    % so there will be space for the overall data point
                    slimiters = [slimiters slimiters(end)+2];
                end
            end % if (tl > 0)
        end % for sal = 1:obj.eyestarget.stim_steps.contour
        
        % get the centers of each condition
        slimiters1 = diff([0 slimiters]);
        slimiters2 = floor(slimiters1/2) + [0 slimiters(1:(end-1))];
        
        % plot catchcontour data if there are any
        if (~isempty(obj.data.catchcontour))
            % get all reaction times for this salience condition
            t = obj.data.catchcontour.timing;
            % the second col of the last row should contain the total number of points
            tlc = obj.data.catchcontour.indexes(end,2);
            if (tlc > 0)
                plot(slimiters(end)+(1:tlc),t,'b.');
                % make sure tlc is at least 2 so that when we plot the medians and
                % quartiles, it will be centered
                tlc = max(2,tlc);
            end
        end % if (~isempty(obj.data.catchcontour))
    end % if plotcontour

    if plotcontrol
        % plot raw data
        for sal = 1:obj.eyestarget.stim_steps.control
            % get all reaction times for this salience condition
            t = obj.data.control(sal).timing;
            % the second col of the last row should contain the total number of points
            tl = obj.data.control(sal).indexes(end,2);
            if (tl > 0)
                if (sal==1)
                    % first salience condition so just plot the data
                    % and stick tl in slimiters
                    plot(t,'r.');
                    slimiters = max(2,tl);
                else
                    % not the first plot so add last slimiter value to 1:tl
                    px = slimiters(sal-1);
                    plot(px+(1:tl),t,'r.');
                    % just to make sure that slimiters are separated by at least
                    % 2, we add max(2,tl) to px
                    slimiters = [slimiters px+max(2,tl)];
                end
            else
                if (sal==1)
                    % first salience condition so set up an empty bin
                    slimiters = 2;
                else
                    % no entries in this salience condition so just add 1 to slimiters
                    % so there will be space for the overall data point
                    slimiters = [slimiters slimiters(end)+2];
                end
            end % if (tl > 0)
        end % for sal = 1:obj.eyestarget.stim_steps.control
        
        % get the centers of each condition
        slimiters1 = diff([0 slimiters]);
        slimiters2 = floor(slimiters1/2) + [0 slimiters(1:(end-1))];
        
        % plot catchcontrol data if there are any
        if (~isempty(obj.data.catchcontrol))
            % get all reaction times for this salience condition
            t = obj.data.catchcontrol.timing;
            % the second col of the last row should contain the total number of points
            tlc = obj.data.catchcontrol.indexes(end,2);
            if (tlc > 0)
                plot(slimiters(end)+(1:tlc),t,'r.');
                % make sure tlc is at least 2 so that when we plot the medians and
                % quartiles, it will be centered
                tlc = max(2,tlc);
            end
        end % if (~isempty(obj.data.catchcontrol))
    end % if plotcontrol
end % if (Args.Overall & (~Args.Session))

% add overall median and quartiles
if Args.Overall
    if plotcontour
        % if slimiters is empty, that means we are plotting only overall data
        % so plot medians and quartiles against stim_p
        if isempty(slimiters)
            sa = errorbar(stim_p,obj.data.median.overall.contour,...
                obj.data.quartiles.overall.contour(:,1,1),...
                obj.data.quartiles.overall.contour(:,1,2),'b^');
            lhandles = [lhandles sa(end)];
            lstring = {lstring{:}, 'contour overall'};
            
            % plot catchcontour if there were catch trials
            if (~isempty(obj.data.catchcontour))
                errorbar(stim_p(end)+Args.CatchStep,obj.data.median.overall.catchcontour,...
                    obj.data.quartiles.overall.catchcontour(1,1),...
                    obj.data.quartiles.overall.catchcontour(1,2),'b^');
            end
        else % if isempty(slimiters)
            % plot medians and quartiles for this session
            % shift slimiters right by 0.5 so as not to overlap with raw data points
            sa = errorbar(slimiters2 + 0.5,obj.data.median.overall.contour,...
                obj.data.quartiles.overall.contour(:,1),...
                obj.data.quartiles.overall.contour(:,2),'b^');
            lhandles = [lhandles sa(end)];
            lstring = {lstring{:}, 'contour overall'};
            
            % plot catchcontour if there were catch trials
            if (~isempty(obj.data.catchcontour))
                % check if tlc is empty, which means that we didn't plot catch trials
                % in the session data
                if tlc
                    errorbar(slimiters(end)+floor(tlc/2)+0.5,...
                        obj.data.median.overall.catchcontour,...
                        obj.data.quartiles.overall.catchcontour(1,1),...
                        obj.data.quartiles.overall.catchcontour(1,2),'b^');
                else
                    errorbar(slimiters(end)+0.5,obj.data.median.overall.catchcontour,...
                        obj.data.quartiles.overall.catchcontour(1,1),...
                        obj.data.quartiles.overall.catchcontour(1,2),'b^');
                end
            end % if (~isempty(obj.data.catchcontour))
        end % if isempty(slimiters)
    end % if plotcontour

    if plotcontrol
        % if slimiters is empty, that means we are plotting only overall data
        % so plot medians and quartiles against stim_p
        if isempty(slimiters)
            sa = errorbar(stim_p,obj.data.median.overall.control,...
                obj.data.quartiles.overall.control(1,1,1),...
                obj.data.quartiles.overall.control(1,1,2),'r^');
            lhandles = [lhandles sa(end)];
            lstring = {lstring{:}, 'control overall'};
            
            % plot catchcontour if there were catch trials
            if (~isempty(obj.data.catchcontrol))
                errorbar(stim_p(end)+Args.CatchStep,obj.data.median.overall.catchcontour,...
                    obj.data.quartiles.overall.catchcontour(1,1),...
                    obj.data.quartiles.overall.catchcontour(1,2),'r^');
            end
        else % if isempty(slimiters)
            % plot medians and quartiles for this session
            % shift slimiters right by 0.5 so as not to overlap with raw data points
            sa = errorbar(slimiters2 + 0.5,obj.data.median.overall.control,...
                obj.data.quartiles.overall.control(:,1,1),...
                obj.data.quartiles.overall.control(:,1,2),'r^');
            lhandles = [lhandles sa(end)];
            lstring = {lstring{:}, 'control overall'};
            
            % plot catchcontrol if there were catch trials
            if (~isempty(obj.data.catchcontrol))
                % check if tlc is empty, which means that we didn't plot catch trials
                % in the session data
                if tlc
                    errorbar(slimiters(end)+floor(tlc/2)+0.5,...
                        obj.data.median.overall.catchcontrol,...
                        obj.data.quartiles.overall.catchcontrol(1,1),...
                        obj.data.quartiles.overall.catchcontrol(1,2),'r^');
                else
                    errorbar(slimiters(end)+0.5,obj.data.median.overall.catchcontrol,...
                        obj.data.quartiles.overall.catchcontrol(1,1),...
                        obj.data.quartiles.overall.catchcontrol(1,2),'r^');
                end
            end % if (~isempty(obj.data.catchcontrol))
        end % if isempty(slimiters)
    end % if plotcontrol
end % if Args.Overall

% draw line between conditions
% get y axis limits
ax1 = axis;
slimiters3 = slimiters + 0.5;
line([slimiters3;slimiters3],repmat([ax1(3); ax1(4)],1,slsize),'Color',[0 0 0]);

ylabel('Time (ms)')
xlabel('Ori Jitter (degrees)')
% if isempty(slimiters)
%     set(gca,'XTick',stim_p);
% else
%     set(gca,'XTick',slimiters2)
% end
% set(gca,'XTickLabel',stim_p)

hold off
