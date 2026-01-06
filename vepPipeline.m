function vepPipeline(EEG_all_tasks_group, taskList, Output_RootDir)

% --- Initialize ---
fprintf('Starting VEP pipeline...\n');
pIdx = 0; % participant index

for t = 1:numel(taskList)
    taskName = taskList{t};
    EEG_files = EEG_all_tasks_group.(taskName);

    fprintf('----- VEP: Processing task %s -----\n', taskName);

    % Detect version code from task name
    if contains(taskName, '0336')
        versionCode = 336;
        timeWindows = [40 79; 80 140; 141 300];  % P1, N1, N2
    elseif contains(taskName, '0369')
        versionCode = 369;
        timeWindows = [40 79; 80 120; 121 170];
    elseif contains(taskName, 'V04')
        versionCode = 4;
        timeWindows = [40 79; 80 120; 121 170];
    else
        warning('Unknown VEP version for task %s — defaulting to V04 timings', taskName);
        versionCode = 4;
        timeWindows = [40 79; 80 120; 121 170];
    end

    numParticipants = numel(EEG_files);
    fprintf('Found %d entries for %s\n', numParticipants, taskName);

    TrialNums = struct();
    allData = [];

    for subject = 1:numParticipants
        EEG = EEG_files{subject};

        % Skip empty slots
        if isempty(EEG)
            warning('Skipping empty EEG for participant %d', subject);
            continue
        end

        % Dynamically detect conditions
        allConds = unique({EEG.event.Condition});
        uprightConds = intersect(allConds, {'1','2'}); % ch1+ and ch2+ as same
        if isempty(uprightConds)
            warning('Participant %d has no upright checkerboard events, skipping', subject);
            continue
        end

        % Combine upright events
        EEG_upright = pop_selectevent(EEG, 'Condition', uprightConds, 'deleteevents','on');
        EEG_upright = eeg_checkset(EEG_upright);

        % Count trials
        TrialNums(subject).VEP = length(EEG_upright.event);
        if TrialNums(subject).VEP <= 0
            continue
        end

        % Compute ERP (all channels x time)
        pIdx = pIdx + 1;
        meanEpochs = mean(EEG_upright.data, 3); 
        allData(pIdx,1,:,:) = meanEpochs; 
        TrialNums(subject).IncludedERP = 1;
    end

    % --- Create subfolder for this task/version inside root ---
    Output_Dir = fullfile(Output_RootDir, taskName); % e.g., vep/v0336
    if ~exist(Output_Dir, 'dir'), mkdir(Output_Dir); end

    % Save trial numbers
    table_events = struct2table(TrialNums);
    writetable(table_events, fullfile(Output_Dir, ...
        sprintf('VEP_TrialNums_%s.csv', taskName)));

    % Save ERP mat
    FileName = sprintf('VEP_erp_allData_%s.mat', taskName);
    save(fullfile(Output_Dir, FileName), 'allData');

    % --- Compute grand-average ERP across participants ---
    ERP_avg = squeeze(mean(allData, 1)); % channels x time

    % ROI average (Oz region)
    firstEEG = EEG_files{find(~cellfun(@isempty, EEG_files),1)};
    Oz_ind = find(ismember({firstEEG.chanlocs.labels}, {'E70','E75','E83'}));
    roi_avg = squeeze(mean(ERP_avg(Oz_ind,:),1));

    % --- ERP Plot ---
    figure; hold on;
    plot(firstEEG.times, roi_avg, 'LineWidth',1.5);
    xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
    title(sprintf('%s.%s ERPs', taskName, 'Oz'));
    set(gca,'Box','off'); grid on;
    saveas(gcf, fullfile(Output_Dir, sprintf('%s_%s_ERPs.jpg', taskName, 'Oz')));
    hold off;

    % --- Topoplots for defined windows ---
    for w = 1:size(timeWindows,1)
        tStart = timeWindows(w,1);
        tEnd   = timeWindows(w,2);

        % Find indices for time window
        timeIdx = find(firstEEG.times >= tStart & firstEEG.times <= tEnd);
        if isempty(timeIdx), continue; end

        topoData = squeeze(mean(allData(:,:,:,timeIdx),4,'omitnan'));
        topoData = squeeze(mean(topoData,1));

        figure;
        topoplot(topoData, firstEEG.chanlocs, 'maplimits', [-3 3], 'electrodes','off');
        title(sprintf('%s %d-%d ms', taskName, tStart, tEnd));
        colorbar;
        saveas(gcf, fullfile(Output_Dir, sprintf('%s_Topoplot_%d-%dms.jpg', taskName, tStart, tEnd)));
    end

    fprintf('Finished VEP task %s. Included participants: %d\n', taskName, pIdx);
end

end
