% concatenate_trial_measures.m

%% Setup

% Load paths
directory_path = 'X:/Projects/hbcd/EEG/Main_Study/Lasso output/bids/derivatives/made/'; %location where summary stats & trial measures data are saved
output_path = 'Z:/Dropboxes/SMcNair/SMcNair_Playground/HBCD/Data Release/DataRelease_Githhub/test_lasso_deid/'; %desired output location
cd(directory_path);

% Get subject IDs
dirInfo = dir(directory_path);
dccids = {dirInfo([dirInfo.isdir] & ~ismember({dirInfo.name}, {'.','..'})).name};

% Initialize outputs
FACE_trialmeasures = [];
MMN_trialmeasures = [];
VEP_trialmeasures = [];

% Helper function for reading + renaming
function renamed = rename_columns(tbl, mapping)
    for i = 1:size(mapping, 1)
        tbl.Properties.VariableNames{mapping{i, 1}} = mapping{i, 2};
    end
    renamed = tbl;
end

%% Concatenate trial measures output
% Loop over each ID
for i = 1:length(dccids)
    x = dccids{i};
    processed_data = fullfile(x, 'ses-V03', 'eeg', 'processed_data');

    %% FACE
    file = fullfile(directory_path, processed_data, [x '_ses-V03_task-FACE_ERPTrialMeasures.csv']);
    if isfile(file)
        tmp = readtable(file);
        disp(['Compiling ' x]);
        mapping = {
            1, 'MeanAmp_N290_p8';
            2, 'Peak_N290_p8';
            3, 'Latency_N290_p8';
            7, 'MeanAmp_P1_Oz';
            8, 'Peak_P1_Oz';
            9, 'Latency_P1_Oz';
            10, 'MeanAmp_N290_Oz';
            11, 'Peak_N290_Oz';
            12, 'Latency_N290_Oz';
            13, 'MeanAmp_P400_Oz';
            14, 'Peak_P400_Oz';
            15, 'Latency_P400_oz';
            16, 'MeanAmp_Nc_fcz';
            17, 'Peak_Nc_fcz';
            18, 'Latency_Nc_fcz'
        };
        tmp = rename_columns(tmp, mapping);
        FACE_trialmeasures = [FACE_trialmeasures; tmp];
    else
        disp(['FACE file not found for ' x]);
    end

    %% MMN
    file = fullfile(directory_path, processed_data, [x '_ses-V03_task-MMN_ERPTrialMeasures.csv']);
    if isfile(file)
        tmp = readtable(file);
        disp(['Compiling ' x]);
        mapping = {
            1, 'MeanAmp_MMR_t7t8';
            2, 'Peak_MMR_t7t8';
            3, 'Latency_MMR_t7t8';
            7, 'MeanAmp_MMR_f7f8';
            8, 'Peak_MMR_f7f8';
            9, 'Latency_MMR_f7f8';
            10, 'MeanAmp_MMR_fcz';
            11, 'Peak_MMR_fcz';
            12, 'Latency_MMR_fcz'
        };
        tmp = rename_columns(tmp, mapping);
        MMN_trialmeasures = [MMN_trialmeasures; tmp];
    else
        disp(['MMN file not found for ' x]);
    end

    %% VEP
    file = fullfile(directory_path, processed_data, [x '_ses-V03_task-VEP_ERPTrialMeasures.csv']);
    if isfile(file)
        tmp = readtable(file);
        disp(['Compiling ' x]);
        mapping = {
            1, 'MeanAmp_N1_t7t8';
            2, 'Peak_N1_oz';
            3, 'Latency_N1_oz';
            7, 'MeanAmp_P1_oz';
            8, 'Peak_P1_oz';
            9, 'Latency_P1_oz';
            10, 'MeanAmp_N2_oz';
            11, 'Peak_N2_oz';
            12, 'Latency_N2_oz'
        };
        tmp = rename_columns(tmp, mapping);
        VEP_trialmeasures = [VEP_trialmeasures; tmp];
    else
        disp(['VEP file not found for ' x]);
    end
end

% Reorder columns by index
FACE_trialmeasures = FACE_trialmeasures(:, [4,5,6,1,2,3,7,8,9,10,11,12,13,14,15,16,17,18]);
MMN_trialmeasures = MMN_trialmeasures(:, [4,5,6,1,2,3,7,8,9,10,11,12]);
VEP_trialmeasures = VEP_trialmeasures(:, [4,5,6,1,2,3,7,8,9,10,11,12]);

% Save .csv outputs 
st = datestr(now, 'yyyy-mm-dd');
writetable(FACE_trialmeasures, fullfile(output_path, ['FACE_trialMeasures_V03_' st '.csv']));
writetable(MMN_trialmeasures, fullfile(output_path, ['MMN_trialMeasures_V03_' st '.csv']));
writetable(VEP_trialmeasures, fullfile(output_path, ['VEP_trialMeasures_V03_' st '.csv']));
