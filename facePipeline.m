function facePipeline(EEG_all_tasks, taskList, Output_Dir_root)
% facePipeline processes FACE EEG tasks (V03, V04, V06...) and generates ERPs and topoplots
%
% Inputs:
%   EEG_all_tasks   - struct of loaded EEG datasets for each task
%   taskList        - cell array of task names (e.g., {'faceV03','faceV04'})
%   Output_Dir_root - root folder where outputs will be saved

%% Define channels of interest
chanGroups = struct();
chanGroups.Oz = {'E70','E75','E83'};
chanGroups.P7 = {'E65','E64','E59','E58'};
chanGroups.P8 = {'E96','E91','E90','E95'};
chanGroups.FCz = {'E6','E7','E13','E106','E112'};
chanNames = fieldnames(chanGroups);

%% Loop over tasks
for t = 1:numel(taskList)
    taskName = taskList{t};
    EEG_all = EEG_all_tasks.(taskName);

    % Create output folder for this task
    Output_Dir = fullfile(Output_Dir_root, taskName);
    if ~exist(Output_Dir,'dir')
        mkdir(Output_Dir);
    end

    fprintf('Processing task %s with %d subjects\n', taskName, numel(EEG_all));

    pIdx = 0; % participant index
    allData = [];
    TrialNums = struct();
    cutoff = 0; % minimum number of trials per condition
    conditions = {'1','2','3','4'};
    condNames = {'Upright','Inverted','Object','Upright2'};

    %% Loop over subjects
    for subject = 1:numel(EEG_all)
        EEG = EEG_all{subject};
        if isempty(EEG)
            warning('Skipping empty EEG for subject %d', subject);
            continue
        end

        EEG = eeg_checkset(EEG);

        % --- Select events of interest ---
        EEG = pop_selectevent(EEG, 'latency','-.1 <= .1','deleteevents','on');

        % --- Count trials per condition ---
        for c = 1:4
            TrialNums(subject).(condNames{c}) = sum(strcmp({EEG.event.Condition}, conditions{c}));
        end

        % --- Check if all conditions exceed cutoff ---
        trialCounts = zeros(1,4);
        for f = 1:4
            val = TrialNums(subject).(condNames{f});
            if numel(val) > 1
                val = val(1); % just in case
            end
            trialCounts(f) = val;
        end

        if all(trialCounts > cutoff)
            pIdx = pIdx + 1;
            % Compute ERP per condition
            for c = 1:4
                EEGc = pop_selectevent(EEG, 'Condition', conditions{c}, 'deleteevents','on');
                EEGc = eeg_checkset(EEGc);
                allData(pIdx,c,:,:) = mean(EEGc.data,3); % store averaged ERP per condition
            end
            TrialNums(subject).IncludedERP = 1;
        else
            TrialNums(subject).IncludedERP = 0;
        end
    end

    %% Save ERP data
    param.date = datestr(now,'mm_dd_yyyy');
    save(fullfile(Output_Dir, ['FACE_erp_allData_' param.date '.mat']),'allData');
    table_events = struct2table(TrialNums);
    writetable(table_events, fullfile(Output_Dir, ['FACE_TrialNums_' param.date '.csv']));

    %% Generate ERPs for all sites
    for ch = 1:numel(chanNames)
        chName = chanNames{ch};
        ind = find(ismember({EEG.chanlocs.labels}, chanGroups.(chName)));

        if isempty(ind)
            warning('No channels found for %s', chName);
            continue
        end

        ERP_mat = squeeze(mean(allData(:,:,ind,:),3)); % average across channels
        ERP_mat = squeeze(mean(ERP_mat,1));            % average across participants
        ERP_mat(5,:) = ERP_mat(1,:) - ERP_mat(2,:);   % diff Upright - Inverted
        ERP_mat(6,:) = ERP_mat(4,:) - ERP_mat(3,:);   % diff Upright2 - Object

        % Plot ERP
        erpFig = figure;
        erpFig.Name = [taskName '.' chName];
        hold on
        grey = [.5 .5 .5 .5];
        time = EEG.times; % time vector
        plot(time, ERP_mat(:,:), 'LineWidth', 1.5);
        title(erpFig.Name, 'FontSize', 20);
        legend('Upright1','Inverted','Object','Upright2','up1-inv','up2-obj');
        xlabel('Time (ms)'); ylabel('Amplitude (\muV)');
        set(gcf,'Color',[1 1 1]);
        saveas(erpFig, fullfile(Output_Dir, [erpFig.Name '_GrandAverage_erp.jpg']));
        hold off;
    end

    %% Topoplots
    timeWindows = [200 350; 350 600]; % adjust as needed
    climValues = [-15 15; -15 15];

    for w = 1:size(timeWindows,1)
        PeakRange = find(abs(EEG.times - timeWindows(w,1)) < 1e-4) : ...
            find(abs(EEG.times - timeWindows(w,2)) < 1e-4);

        PeakData = squeeze(mean(allData(:,:,:,PeakRange),4));
        PeakData = squeeze(mean(PeakData,1));

        plt = figure;
        set(plt,'Name',[taskName '.' num2str(timeWindows(w,1)) '-' num2str(timeWindows(w,2))]);
        for c = 1:4
            subplot(2,2,c);
            topoplot(PeakData(c,:), EEG.chanlocs, 'maplimits', climValues(w,:), ...
                'electrodes','off','numcontour',0);
            title(condNames{c});
        end
        set(gcf,'color','w');
        saveas(plt, fullfile(Output_Dir, ['FACE_Topoplots_Window' num2str(w) '_' taskName '.jpg']));
    end
end
end
