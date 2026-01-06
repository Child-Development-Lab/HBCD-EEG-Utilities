function mmnPipeline(EEG_all_tasks_group, taskList, Output_Dir_root)
% mmnPipeline: MMN ERPs & topoplots using EEG.event.Condition = '1','2','3'
% Keeps original selection logic (latency trimming + Condition='1','2','3'),
% but runs per-task (v03, v04) and is robust to missing/empty subjects.
%
% Inputs:
%  EEG_all_tasks_group - struct of cell arrays of EEG structs (per task)
%  taskList            - cell array of task names to process (e.g., {'mmnV03','mmnV04'})
%  Output_Dir_root     - folder where outputs will be saved (a subfolder per task is created)
%
% Preserves ROI definitions, ERP plotting, topoplots.
%
% Example:
% mmnPipeline(EEG_all_tasks_group, {'mmnV03','mmnV04'}, '/path/to/output/mmn');

% Parameters
cutoff = 0; % minimum trials per condition (same as your original code default)
conds_numeric = {'1','2','3'}; % condition codes in EEG.event.Condition
cond_names = {'Standard','PreDeviant','Deviant'};

%% ROI definitions (unchanged)
ROIs = struct();
ROIs.F7F8 = ["E33","E34","E38","E122","E116","E121"];
ROIs.F3F4 = ["E27","E28","E24","E23","E20","E19","E123","E117","E124","E118","E4","E3"];
ROIs.FCz  = ["E6","E7","E13","E106","E112","E12","E5"];
ROIs.T7T8 = ["E45","E40","E46","E108","E109","E102"];
ROI_names = fieldnames(ROIs);

%% Loop tasks (use taskList to control which tasks to run)
for t = 1:numel(taskList)
    taskName = taskList{t};
    if ~isfield(EEG_all_tasks_group, taskName)
        warning('Task %s not present in EEG_all_tasks_group — skipping', taskName);
        continue
    end

    EEG_list = EEG_all_tasks_group.(taskName);
    nSubs = numel(EEG_list);

    fprintf('Processing MMN for %s (n=%d files)\n', taskName, nSubs);

    % create task-specific output dir
    Output_Dir = fullfile(Output_Dir_root, taskName);
    if ~exist(Output_Dir,'dir'), mkdir(Output_Dir); end

    % find first non-empty EEG to get channel/time info
    firstIdx = find(~cellfun(@isempty, EEG_list), 1);
    if isempty(firstIdx)
        warning('No EEG files found for %s — skipping', taskName);
        continue
    end
    EEGref = EEG_list{firstIdx};
    chanlabels = {EEGref.chanlocs.labels};
    nChans = EEGref.nbchan;
    nTimes = numel(EEGref.times);

    % precompute ROI channel indices
    ROI_idx = struct();
    for r = 1:numel(ROI_names)
        ROI_idx.(ROI_names{r}) = find(ismember(chanlabels, ROIs.(ROI_names{r})));
    end

    % initialize trial counts & included subject storage
    TrialNums = repmat(struct('Standard',0,'PreDeviant',0,'Deviant',0,'IncludedERP',0), nSubs, 1);
    pIdx = 0; % index for included participants in allData
    allData = []; % will be pIdx x cond x chan x time

    %% Loop subjects and perform original selection logic
    for s = 1:nSubs
        EEG = EEG_list{s};
        if isempty(EEG)
            warning('Subject %d: EEG empty for %s; skipping', s, taskName);
            continue
        end

        try
            EEG = eeg_checkset(EEG);
        catch
            warning('Subject %d: eeg_checkset failed — continuing', s);
        end

        % Apply latency trimming as in original:
        % "Deleting all the epochs that are not of interest"
        try
            EEG = pop_selectevent(EEG, 'latency', '-.1 <= .1', 'deleteevents','on');
        catch ME
            warning('Subject %d: pop_selectevent latency trimming failed: %s', s, ME.message);
            continue
        end

        % Make sure 'Condition' field exists
        if ~isfield(EEG.event, 'Condition')
            % if not present, try case variations or 'condition'
            % but per your check Condition exists — only fallback for safety
            evFields = fieldnames(EEG.event);
            fld = evFields{contains(lower(evFields),'cond', 'IgnoreCase', true)};
            if ~isempty(fld)
                condField = fld{1};
            else
                warning('Subject %d: no Condition field in EEG.event — skipping subject', s);
                continue
            end
        else
            condField = 'Condition';
        end

        % Count trials per numeric-coded condition (original uses '1','2','3')
        % Use strcmp to match string values: {EEG.event.Condition}
        evCondVals = {EEG.event.(condField)};
        % If values are numeric or cell numbers, convert to strings
        if ~all(cellfun(@ischar, evCondVals))
            evCondVals = cellfun(@(x) num2str(x), evCondVals, 'UniformOutput', false);
        end

        Cond1Num = sum(strcmp(evCondVals, conds_numeric{1}));
        Cond2Num = sum(strcmp(evCondVals, conds_numeric{2}));
        Cond3Num = sum(strcmp(evCondVals, conds_numeric{3}));

        % Record raw counts (even if zero)
        TrialNums(s).Standard = Cond1Num;
        TrialNums(s).PreDeviant = Cond2Num;
        TrialNums(s).Deviant = Cond3Num;

        % Select each condition if there are > cutoff trials
        EEG1 = []; EEG2 = []; EEG3 = [];
        if Cond1Num > cutoff
            try
                EEG1 = pop_selectevent(EEG, 'Condition', conds_numeric{1}, 'deleteevents','on');
                EEG1 = eeg_checkset(EEG1);
            catch ME
                warning('Subject %d: selecting Condition=%s failed: %s', s, conds_numeric{1}, ME.message);
                EEG1 = [];
            end
        end
        if Cond2Num > cutoff
            try
                EEG2 = pop_selectevent(EEG, 'Condition', conds_numeric{2}, 'deleteevents','on');
                EEG2 = eeg_checkset(EEG2);
            catch ME
                warning('Subject %d: selecting Condition=%s failed: %s', s, conds_numeric{2}, ME.message);
                EEG2 = [];
            end
        end
        if Cond3Num > cutoff
            try
                EEG3 = pop_selectevent(EEG, 'Condition', conds_numeric{3}, 'deleteevents','on');
                EEG3 = eeg_checkset(EEG3);
            catch ME
                warning('Subject %d: selecting Condition=%s failed: %s', s, conds_numeric{3}, ME.message);
                EEG3 = [];
            end
        end

        % Update TrialNums to exact retained counts after pop_selectevent (if chosen)
        if ~isempty(EEG1) && isfield(EEG1, 'event'), TrialNums(s).Standard = numel(EEG1.event); end
        if ~isempty(EEG2) && isfield(EEG2, 'event'), TrialNums(s).PreDeviant = numel(EEG2.event); end
        if ~isempty(EEG3) && isfield(EEG3, 'event'), TrialNums(s).Deviant = numel(EEG3.event); end

        % Only include this subject in ERP if all conditions exceed cutoff (original logic)
        if TrialNums(s).Standard > cutoff && TrialNums(s).PreDeviant > cutoff && TrialNums(s).Deviant > cutoff
            % Ensure EEG1/2/3 are not empty (should not be)
            if isempty(EEG1) || isempty(EEG2) || isempty(EEG3)
                warning('Subject %d: condition data missing even though counts > cutoff; skipping inclusion', s);
                TrialNums(s).IncludedERP = 0;
                continue
            end

            pIdx = pIdx + 1;
            % Average across trials (mean across 3rd dim)
            meanEpochs1 = mean(EEG1.data, 3, 'omitnan'); % chan x time
            meanEpochs2 = mean(EEG2.data, 3, 'omitnan');
            meanEpochs3 = mean(EEG3.data, 3, 'omitnan');

            % Dynamically grow allData: pIdx x cond x chan x time
            if isempty(allData)
                % initialize with sizes [estimated included x 3 x nChans x nTimes] is unknown
                % so we start with pIdx == 1 and expand as needed
                allData = NaN(1, 3, nChans, nTimes);
            elseif size(allData,1) < pIdx
                allData(pIdx,3,nChans,nTimes) = NaN; % expand (MATLAB will auto-size)
            end

            allData(pIdx,1,:,:) = meanEpochs1;
            allData(pIdx,2,:,:) = meanEpochs2;
            allData(pIdx,3,:,:) = meanEpochs3;
            TrialNums(s).IncludedERP = 1;
        else
            TrialNums(s).IncludedERP = 0;
        end
    end % subjects

    % If no included participants, warn and continue
    if isempty(allData)
        warning('No included participants met trial criteria for %s — skipping plots and saving empty outputs.', taskName);
        % Still write TrialNums table for diagnostics
        try
            table_events = struct2table(TrialNums);
            writetable(table_events, fullfile(Output_Dir, sprintf('%s_MMN_TrialNums_%s.csv', taskName, datestr(now,'mmddyyyy'))));
        catch
            warning('Could not write TrialNums for %s', taskName);
        end
        continue
    end

    % Trim allData to actual participants included (pIdx x 3 x chan x time)
    allData = allData(1:pIdx,:,:,:);

    % Save ERP data and TrialNums
    param.date = datestr(now,'mm_dd_yyyy');
    save(fullfile(Output_Dir, sprintf('MMN_erp_allData_%s_%s.mat', taskName, param.date)), 'allData', '-v7.3');
    table_events = struct2table(TrialNums);
    writetable(table_events, fullfile(Output_Dir, sprintf('%s_MMN_TrialNums_%s.csv', taskName, param.date)));

    %% ---- Now create ERP figures for each ROI (average across included subjects) ----
    % allData dims: subj x cond x chan x time
    for r = 1:numel(ROI_names)
        roiName = ROI_names{r};
        chIdx = ROI_idx.(roiName);
        if isempty(chIdx)
            warning('ROI %s has no matching channels in this montage — skipping ROI.', roiName);
            continue
        end

        % average across subjects and channels -> cond x time
        data_sub_cond_chan_time = allData; % alias
        % mean across subjects (1) then channels (3)
        roi_avg_over_subjects = squeeze(mean(mean(data_sub_cond_chan_time(:,: , chIdx, :),3,'omitnan'),1,'omitnan')); % cond x time

        if all(isnan(roi_avg_over_subjects(:)))
            warning('All NaN for ROI %s in %s — skipping ERP plot', roiName, taskName);
            continue
        end

        % Plot ERPs
figure; hold on;
colors = [0 0 1; 0 1 0; 1 0 0]; % Standard, PreDeviant, Deviant
for c = 1:3
    plot(EEGref.times, squeeze(roi_avg_over_subjects(c,:)), 'LineWidth', 1.5, 'Color', colors(c,:));
end

% Difference waves
plot(EEGref.times, squeeze(roi_avg_over_subjects(3,:) - roi_avg_over_subjects(2,:)), '--', 'Color', [0.5 0 0.5], 'LineWidth', 1.5);
plot(EEGref.times, squeeze(roi_avg_over_subjects(3,:) - roi_avg_over_subjects(1,:)), '--', 'Color', [0.5 0.5 0], 'LineWidth', 1.5);

% Corrected title
title(sprintf('%s — %s', taskName, roiName), 'FontSize', 14);
xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
legend({'Standard','PreDeviant','Deviant','Dev-PreDev','Dev-Stan'});
set(gca,'Box','off'); grid on; hold off;

% Save figure
saveas(gcf, fullfile(Output_Dir, sprintf('%s_%s_ERPs.jpg', taskName, roiName)));

    end

%% ===============================================================
%  TOPOPLOTS — version-specific timing (V03 vs V04)
% ===============================================================

%% ---- Select time windows based on task version ----
if contains(taskName, 'V03')
    timeWindows = [100 200; 200 400];  % ms
    climValues  = [-5 5; -5 5];
elseif contains(taskName, 'V04')
    timeWindows = [100 200; 200 450];  % ms
    climValues  = [-5 5; -5 5];
else
    warning('Unknown MMN version for %s — defaulting to V04 windows', taskName);
    timeWindows = [100 200; 200 450];
    climValues  = [-5 5; -5 5];
end


%% ===============================================================
%  TOPOPLOTS — version-specific timing (V03 vs V04)
% ===============================================================

%% ---- Select time windows based on task version ----
if contains(taskName, 'V03')
    timeWindows = [100 200; 200 400];  % ms
    climValues  = [-5 5; -5 5];    % one row per window
elseif contains(taskName, 'V04')
    timeWindows = [100 200; 200 450];  % ms
    climValues  = [-5 5; -5 5];
else
    warning('Unknown MMN version for %s — defaulting to V04 windows', taskName);
    timeWindows = [100 200; 200 450];
    climValues  = [-5 5; -5 5];
end

%% ===============================================================
%  ---- Topoplots (all channels) ----
%% ===============================================================
for w = 1:size(timeWindows,1)
    tStart = timeWindows(w,1);
    tEnd   = timeWindows(w,2);
    clim   = climValues(w,:);

    timeIdx = find(EEGref.times >= tStart & EEGref.times <= tEnd);
    if isempty(timeIdx)
        warning('Time window %d-%d not found in times vector, skipping', tStart, tEnd);
        continue
    end

    % cond x chan averaged over subjects and time window
    topoData = squeeze(mean(mean(allData(:,:,:,timeIdx),4,'omitnan'),1,'omitnan')); % cond x chan

    if all(isnan(topoData(:)))
        warning('All NaN topoData for %s %d-%d ms — skipping topoplots', taskName, tStart, tEnd);
        continue
    end

    figure;
    for c = 1:3
        ax(c) = subplot(3,1,c);
        if all(isnan(topoData(c,:)))
            warning('All NaN for %s cond %d — skip panel', taskName, c);
            continue
        end
        topoplot(topoData(c,:), EEGref.chanlocs, ...
            'maplimits', clim, 'electrodes','off');
        title(sprintf('%s %d-%d ms', cond_names{c}, tStart, tEnd));
        colorbar;
    end

    % Add main title with extra spacing
    sgtitle(sprintf('%s', taskName), 'FontSize', 16, 'FontWeight', 'bold');

    % Adjust subplot positions to make room for sgtitle
    for c = 1:3
        pos = get(ax(c), 'Position');
        pos(2) = pos(2) * 0.9;  % push down slightly
        set(ax(c), 'Position', pos);
    end

    saveas(gcf, fullfile(Output_Dir, ...
        sprintf('%s_Topoplot_%d-%dms.jpg', taskName, tStart, tEnd)));
end

%% ===============================================================
%  ---- Difference topoplots ----
%% ===============================================================
for w = 1:size(timeWindows,1)
    tStart = timeWindows(w,1);
    tEnd   = timeWindows(w,2);
    clim   = climValues(w,:);

    timeIdx = find(EEGref.times >= tStart & EEGref.times <= tEnd);
    if isempty(timeIdx)
        continue
    end

    topoData = squeeze(mean(mean(allData(:,:,:,timeIdx),4,'omitnan'),1,'omitnan')); % cond x chan
    if all(isnan(topoData(:)))
        continue
    end

    figure;

    % Dev - PreDev
    diff1 = topoData(3,:) - topoData(2,:);
    if ~all(isnan(diff1))
        ax1 = subplot(2,1,1);
        topoplot(diff1, EEGref.chanlocs, 'maplimits', clim, 'electrodes','off');
        title(sprintf('Dev - PreDev %d-%d ms', tStart, tEnd));
        colorbar;
    end

    % Dev - Standard
    diff2 = topoData(3,:) - topoData(1,:);
    if ~all(isnan(diff2))
        ax2 = subplot(2,1,2);
        topoplot(diff2, EEGref.chanlocs, 'maplimits', clim, 'electrodes','off');
        title(sprintf('Dev - Stan %d-%d ms', tStart, tEnd));
        colorbar;
    end

    % Add main title
    sgtitle(sprintf('Difference %s', taskName), 'FontSize', 16, 'FontWeight', 'bold');

    % Adjust subplot positions
    if exist('ax1','var'), pos = get(ax1,'Position'); pos(2)=pos(2)*0.9; set(ax1,'Position',pos); end
    if exist('ax2','var'), pos = get(ax2,'Position'); pos(2)=pos(2)*0.9; set(ax2,'Position',pos); end

    saveas(gcf, fullfile(Output_Dir, ...
        sprintf('%s_DiffTopoplot_%d-%dms.jpg', taskName, tStart, tEnd)));
end

    fprintf('Finished task %s. Included participants: %d\n', taskName, pIdx);
end % tasks

end
