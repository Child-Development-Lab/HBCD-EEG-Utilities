function mmnPipeline(EEG_all_tasks_group, taskList, Output_Dir_root)

cutoff = 0;
conds_numeric = {'1','2','3'};
cond_names = {'Standard','PreDeviant','Deviant'};

%% ROI definitions
ROIs = struct();
ROIs.F7F8 = ["E33","E34","E38","E122","E116","E121"];
ROIs.F3F4 = ["E27","E28","E24","E23","E20","E19","E123","E117","E124","E118","E4","E3"];
ROIs.FCz  = ["E6","E7","E13","E106","E112","E12","E5"];
ROIs.T7T8 = ["E45","E40","E46","E108","E109","E102"];
ROI_names = fieldnames(ROIs);

%% Loop tasks
for t = 1:numel(taskList)

    taskName = taskList{t};

    if ~isfield(EEG_all_tasks_group, taskName)
        warning('Task %s not present — skipping', taskName);
        continue
    end

    EEG_list = EEG_all_tasks_group.(taskName);
    nSubs = numel(EEG_list);

    fprintf('Processing MMN for %s (n=%d files)\n', taskName, nSubs);

    Output_Dir = fullfile(Output_Dir_root, taskName);
    if ~exist(Output_Dir,'dir')
        mkdir(Output_Dir);
    end

    %% --- same fix used in facePipeline ---
    validIdx = find(~cellfun(@isempty, EEG_list), 1);

    if isempty(validIdx)
        warning('No valid EEG datasets found for task %s', taskName);
        continue
    end

    EEG_ref = EEG_list{validIdx};

    chanlabels = {EEG_ref.chanlocs.labels};
    nChans = EEG_ref.nbchan;
    nTimes = numel(EEG_ref.times);

    %% ROI indices
    ROI_idx = struct();
    for r = 1:numel(ROI_names)
        ROI_idx.(ROI_names{r}) = find(ismember(chanlabels, ROIs.(ROI_names{r})));
    end

    TrialNums = repmat(struct('Standard',0,'PreDeviant',0,'Deviant',0,'IncludedERP',0), nSubs, 1);

    pIdx = 0;
    allData = [];

    %% Subject loop
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

        try
            EEG = pop_selectevent(EEG, 'latency', '-.1 <= .1', 'deleteevents','on');
        catch ME
            warning('Subject %d latency trimming failed: %s', s, ME.message);
            continue
        end

        if ~isfield(EEG.event,'Condition')
            evFields = fieldnames(EEG.event);
            fld = evFields{contains(lower(evFields),'cond','IgnoreCase',true)};
            if ~isempty(fld)
                condField = fld{1};
            else
                warning('Subject %d missing Condition field — skipping', s);
                continue
            end
        else
            condField = 'Condition';
        end

        evCondVals = {EEG.event.(condField)};

        if ~all(cellfun(@ischar, evCondVals))
            evCondVals = cellfun(@(x) num2str(x), evCondVals, 'UniformOutput', false);
        end

        Cond1Num = sum(strcmp(evCondVals, conds_numeric{1}));
        Cond2Num = sum(strcmp(evCondVals, conds_numeric{2}));
        Cond3Num = sum(strcmp(evCondVals, conds_numeric{3}));

        TrialNums(s).Standard = Cond1Num;
        TrialNums(s).PreDeviant = Cond2Num;
        TrialNums(s).Deviant = Cond3Num;

        EEG1 = []; EEG2 = []; EEG3 = [];

        if Cond1Num > cutoff
            try
                EEG1 = pop_selectevent(EEG,'Condition',conds_numeric{1},'deleteevents','on');
                EEG1 = eeg_checkset(EEG1);
            end
        end

        if Cond2Num > cutoff
            try
                EEG2 = pop_selectevent(EEG,'Condition',conds_numeric{2},'deleteevents','on');
                EEG2 = eeg_checkset(EEG2);
            end
        end

        if Cond3Num > cutoff
            try
                EEG3 = pop_selectevent(EEG,'Condition',conds_numeric{3},'deleteevents','on');
                EEG3 = eeg_checkset(EEG3);
            end
        end

        if ~isempty(EEG1) && isfield(EEG1,'event'), TrialNums(s).Standard = numel(EEG1.event); end
        if ~isempty(EEG2) && isfield(EEG2,'event'), TrialNums(s).PreDeviant = numel(EEG2.event); end
        if ~isempty(EEG3) && isfield(EEG3,'event'), TrialNums(s).Deviant = numel(EEG3.event); end

        if TrialNums(s).Standard > cutoff && TrialNums(s).PreDeviant > cutoff && TrialNums(s).Deviant > cutoff

            if isempty(EEG1) || isempty(EEG2) || isempty(EEG3)
                warning('Subject %d missing condition data', s);
                continue
            end

            pIdx = pIdx + 1;

            meanEpochs1 = mean(EEG1.data,3,'omitnan');
            meanEpochs2 = mean(EEG2.data,3,'omitnan');
            meanEpochs3 = mean(EEG3.data,3,'omitnan');

            if isempty(allData)
                allData = NaN(1,3,nChans,nTimes);
            elseif size(allData,1) < pIdx
                allData(pIdx,3,nChans,nTimes) = NaN;
            end

            allData(pIdx,1,:,:) = meanEpochs1;
            allData(pIdx,2,:,:) = meanEpochs2;
            allData(pIdx,3,:,:) = meanEpochs3;

            TrialNums(s).IncludedERP = 1;

        end

    end

    if isempty(allData)
        warning('No included participants for %s', taskName);
        table_events = struct2table(TrialNums);
        writetable(table_events, fullfile(Output_Dir, sprintf('%s_MMN_TrialNums_%s.csv',taskName,datestr(now,'mmddyyyy'))));
        continue
    end

    allData = allData(1:pIdx,:,:,:);

    param.date = datestr(now,'mm_dd_yyyy');

    save(fullfile(Output_Dir, sprintf('MMN_erp_allData_%s_%s.mat', taskName, param.date)), 'allData','-v7.3');

    table_events = struct2table(TrialNums);
    writetable(table_events, fullfile(Output_Dir, sprintf('%s_MMN_TrialNums_%s.csv',taskName,param.date)));

    %% ERP plots
    for r = 1:numel(ROI_names)

        roiName = ROI_names{r};
        chIdx = ROI_idx.(roiName);

        if isempty(chIdx)
            continue
        end

        roi_avg = squeeze(mean(mean(allData(:,:,chIdx,:),3,'omitnan'),1,'omitnan'));

        figure; hold on

        colors=[0 0 1;0 1 0;1 0 0];

        for c=1:3
            plot(EEG_ref.times,roi_avg(c,:),'LineWidth',1.5,'Color',colors(c,:));
        end

        plot(EEG_ref.times,roi_avg(3,:)-roi_avg(2,:),'--','LineWidth',1.5)
        plot(EEG_ref.times,roi_avg(3,:)-roi_avg(1,:),'--','LineWidth',1.5)

        title(sprintf('%s — %s',taskName,roiName))
        xlabel('Time (ms)')
        ylabel('Amplitude (\muV)')
        legend({'Standard','PreDeviant','Deviant','Dev-PreDev','Dev-Stan'})
        grid on

        saveas(gcf, fullfile(Output_Dir, sprintf('%s_%s_ERPs.jpg',taskName,roiName)))

    end

    %% Topoplots
    if contains(taskName,'V03')
        timeWindows=[100 200;200 400];
    else
        timeWindows=[100 200;200 450];
    end

    climValues=[-5 5;-5 5];

    for w=1:size(timeWindows,1)

        tStart=timeWindows(w,1);
        tEnd=timeWindows(w,2);

        timeIdx=find(EEG_ref.times>=tStart & EEG_ref.times<=tEnd);

        topoData=squeeze(mean(mean(allData(:,:,:,timeIdx),4,'omitnan'),1,'omitnan'));

        figure

        for c=1:3
            subplot(3,1,c)
            topoplot(topoData(c,:),EEG_ref.chanlocs,'maplimits',climValues(w,:),'electrodes','off')
            title(sprintf('%s %d-%d ms',cond_names{c},tStart,tEnd))
            colorbar
        end

        sgtitle(taskName)

        saveas(gcf, fullfile(Output_Dir, sprintf('%s_Topoplot_%d-%dms.jpg',taskName,tStart,tEnd)))

    end

    fprintf('Finished task %s. Included participants: %d\n',taskName,pIdx)

end

end