function rsPipeline(EEG_all_tasks_group, taskList, Output_RootDir)

fprintf('Starting RS pipeline...\n');

%% Loop over RS tasks (e.g., rsV03, rsV04)
for t = 1:numel(taskList)
    taskName = taskList{t};

    if ~isfield(EEG_all_tasks_group, taskName)
        warning('RS task %s not found — skipping', taskName);
        continue
    end

    EEG_files = EEG_all_tasks_group.(taskName);
    nFiles = numel(EEG_files);

    fprintf('----- RS: Processing task %s -----\n', taskName);

    % Create visit-level output folder (rs/rsV03, rs/rsV04, etc.)
    Output_Dir = fullfile(Output_RootDir, taskName);
    if ~exist(Output_Dir,'dir'), mkdir(Output_Dir); end

    %% Find first non-empty EEG (reference)
    refIdx = find(~cellfun(@isempty, EEG_files), 1);
    if isempty(refIdx)
        warning('No valid EEG files for %s — skipping', taskName);
        continue
    end
    EEGref = EEG_files{refIdx};

    Fs = EEGref.srate;
    num_channels = size(EEGref.data, 1);

    %% Frequency parameters
    total = [1 50];   % Hz

    %% Initialize accumulators (averaged across files)
    all_abs_pow_sum = [];
    all_log_pow_sum = [];
    all_db_pow_sum  = [];
    total_epochs    = 0;

    %% ======================================================
    %  LOOP OVER FILES (participants) — VISIT-LEVEL AVERAGE
    %% ======================================================
    for f = 1:nFiles
        EEG = EEG_files{f};
        if isempty(EEG)
            continue
        end

        fprintf('  Including RS file %d/%d\n', f, nFiles);

        x = EEG.data;
        n_epochs = size(x, 3);
        total_epochs = total_epochs + n_epochs;

        winSize = size(x, 2);
        WINDOW  = winSize;
        NOVERLAP = 0;
        NFFT    = WINDOW;

        power_matrix = zeros(num_channels, NFFT/2 + 1, n_epochs);

        %% ---- pwelch (FIX APPLIED HERE) ----
        for chan = 1:num_channels
            for trial = 1:n_epochs
                [spectra, freqs] = pwelch( ...
                    double(x(chan, :, trial)), ...
                    WINDOW, NOVERLAP, NFFT, Fs);
                power_matrix(chan, :, trial) = spectra';
            end
        end

        %% Restrict to 1–50 Hz
        totalIdx = dsearchn(freqs, total');
        freqs_use = freqs(totalIdx(1):totalIdx(2));

        all_abs_pow = power_matrix(:, totalIdx(1):totalIdx(2), :);
        avg_abs_pow = mean(all_abs_pow, 3);

        all_log_pow = log10(1 + all_abs_pow);
        avg_log_pow = mean(all_log_pow, 3);

        all_db_pow  = 10 * log10(all_abs_pow);
        avg_db_pow  = mean(all_db_pow, 3);

        %% Accumulate across files
        if isempty(all_abs_pow_sum)
            all_abs_pow_sum = avg_abs_pow;
            all_log_pow_sum = avg_log_pow;
            all_db_pow_sum  = avg_db_pow;
        else
            all_abs_pow_sum = all_abs_pow_sum + avg_abs_pow;
            all_log_pow_sum = all_log_pow_sum + avg_log_pow;
            all_db_pow_sum  = all_db_pow_sum  + avg_db_pow;
        end
    end

    %% ======================================================
    %  FINAL VISIT-LEVEL AVERAGES
    %% ======================================================
    nIncluded = sum(~cellfun(@isempty, EEG_files));

    if nIncluded == 0
        warning('No RS data included for %s — skipping outputs', taskName);
        continue
    end

    avg_abs_pow = all_abs_pow_sum / nIncluded;
    avg_log_pow = all_log_pow_sum / nIncluded;
    avg_db_pow  = all_db_pow_sum  / nIncluded;
    avg_elec_db_pow = mean(avg_db_pow, 1);

    %% ======================================================
    %  PLOT PSD (visit-level)
    %% ======================================================
    psd = figure;
    plot(freqs_use, avg_db_pow', 'LineWidth', 1); hold on;
    plot(freqs_use, avg_elec_db_pow, 'k', 'LineWidth', 4);
    xlabel('Frequency (Hz)');
    ylabel('Power Spectral Density (dB μV²/Hz)');
    title(sprintf('%s RS PSD (N files = %d)', taskName, nIncluded));
    grid on;

    saveas(psd, fullfile(Output_Dir, ...
        sprintf('%s_task-RS_desc-allCh_PSD.jpg', taskName)));
    close(psd);

    %% ======================================================
    %  SAVE CSVs
    %% ======================================================
    elec_names = {EEGref.chanlocs.labels};
    freq_labels = arrayfun(@(x) sprintf('%.1fHz', x), freqs_use, 'UniformOutput', false);

    writetable(array2table(avg_abs_pow, 'VariableNames', freq_labels, 'RowNames', elec_names), ...
        fullfile(Output_Dir, sprintf('%s_task-RS_AbsPowerSpectra.csv', taskName)), ...
        'WriteRowNames', true);

    writetable(array2table(avg_log_pow, 'VariableNames', freq_labels, 'RowNames', elec_names), ...
        fullfile(Output_Dir, sprintf('%s_task-RS_LogPowerSpectra.csv', taskName)), ...
        'WriteRowNames', true);

    writetable(array2table(avg_db_pow, 'VariableNames', freq_labels, 'RowNames', elec_names), ...
        fullfile(Output_Dir, sprintf('%s_task-RS_dbPowerSpectra.csv', taskName)), ...
        'WriteRowNames', true);

    %% ======================================================
    %  SAVE MAT
    %% ======================================================
    save(fullfile(Output_Dir, sprintf('%s_task-RS_spectra.mat', taskName)), ...
        'avg_abs_pow','avg_log_pow','avg_db_pow','freqs_use','Fs','elec_names');

    fprintf('Finished RS task %s\n', taskName);
end

end
