%concatenate_files_summary.m

%% Setup

% Load paths
directory_path = 'X:/Projects/hbcd/EEG/Main_Study/Lasso output/bids/derivatives/made/';
output_path = 'Z:/Dropboxes/SMcNair/SMcNair_Playground/HBCD/Data Release/DataRelease_Githhub/test_lasso_deid/';
cd(directory_path);

% Get subject IDs
dirInfo = dir(directory_path);
dccids = {dirInfo([dirInfo.isdir] & ~ismember({dirInfo.name}, {'.','..'})).name};

% Initialize outputs
RS_power = [];
MMN_ERP = [];
FACE_ERP = [];
VEP_ERP = [];

%% Concatenate summary statistics output
% Loop over each ID
for i = 1:length(dccids)
    x = dccids{i};
    processed_data = fullfile(x, 'ses-V03', 'eeg', 'processed_data');
    
    %% RS
    RS_power_file = fullfile(directory_path, processed_data, [x '_ses-V03_task-RS_powerSummaryStats.csv']);
    if isfile(RS_power_file)
        RS_power_sheet = readtable(RS_power_file);
        if height(RS_power_sheet) > 0
            RS_power_sheet.Properties.VariableNames(2:3) = {'SME_oz', 'Mean_Power_oz'};
            RS_power_sheet.ID = repmat({x}, height(RS_power_sheet), 1);
            RS_power = [RS_power; RS_power_sheet];
            disp(['Compiling RS: ' x]);
        end
    else
        disp(['RS Power file not found for ' x]);
    end

    %% MMN
    MMN_ERP_file = fullfile(directory_path, processed_data, [x '_ses-V03_task-MMN_ERPSummaryStats.csv']);
    if isfile(MMN_ERP_file)
        MMN_ERP_sheet = readtable(MMN_ERP_file);
        if height(MMN_ERP_sheet) > 0
            MMN_ERP_sheet.ID = repmat({x}, height(MMN_ERP_sheet), 1);
            new_names = {
                'SME_MMR_t7t8', 'Peak_MMR_t7t8', 'Latency_MMR_t7t8', 'MeanAmp_MMR_t7t8', ...
                'SME_MMR_f7f8', 'Peak_MMR_f7f8', 'Latency_MMR_f7f8', 'MeanAmp_MMR_f7f8', ...
                'SME_MMR_fcz', 'Peak_MMR_fcz', 'Latency_MMR_fcz', 'MeanAmp_MMR_fcz'
            };
            MMN_ERP_sheet.Properties.VariableNames(3:14) = new_names;
            MMN_ERP = [MMN_ERP; MMN_ERP_sheet];
            disp(['Compiling MMN: ' x]);
        end
    else
        disp(['MMN ERP file not found for ' x]);
    end

    %% FACE
    FACE_ERP_file = fullfile(directory_path, processed_data, [x '_ses-V03_task-FACE_ERPSummaryStats.csv']);
    if isfile(FACE_ERP_file)
        FACE_ERP_sheet = readtable(FACE_ERP_file);
        if height(FACE_ERP_sheet) > 0
            FACE_ERP_sheet.ID = repmat({x}, height(FACE_ERP_sheet), 1);
            new_names = {
                'SME_N290_p8', 'Peak_N290_p8', 'Latency_N290_p8', 'MeanAmp_N290_p8', ...
                'SME_P1', 'Peak_P1', 'Latency_P1', 'MeanAmp_P1', ...
                'SME_N290_Oz', 'Peak_N290_Oz', 'Latency_N290_Oz', 'MeanAmp_N290_Oz', ...
                'SME_P400', 'Peak_P400', 'Latency_P400', 'MeanAmp_P400'
            };
            FACE_ERP_sheet.Properties.VariableNames(3:18) = new_names;
            FACE_ERP = [FACE_ERP; FACE_ERP_sheet];
            disp(['Compiling FACE: ' x]);
        end
    else
        disp(['FACE ERP file not found for ' x]);
    end

    %% VEP
    VEP_ERP_file = fullfile(directory_path, processed_data, [x '_ses-V03_task-VEP_ERPSummaryStats.csv']);
    if isfile(VEP_ERP_file)
        VEP_ERP_sheet = readtable(VEP_ERP_file);
        if height(VEP_ERP_sheet) > 0
            VEP_ERP_sheet.ID = repmat({x}, height(VEP_ERP_sheet), 1);
            new_names = {
                'SME_N1', 'Peak_N1', 'Latency_N1', 'MeanAmp_N1', ...
                'SME_P1', 'Peak_P1', 'Latency_P1', 'MeanAmp_P1', ...
                'SME_N2', 'Peak_N2', 'Latency_N2', 'MeanAmp_N2'
            };
            VEP_ERP_sheet.Properties.VariableNames(3:14) = new_names;
            VEP_ERP = [VEP_ERP; VEP_ERP_sheet];
            disp(['Compiling VEP: ' x]);
        end
    else
        disp(['VEP ERP file not found for ' x]);
    end
end

% Save .csv outputs 
st = datestr(now, 'yyyy-mm-dd');
writetable(RS_power, fullfile(output_path, ['RS_power_V03_' st '.csv']));
writetable(MMN_ERP, fullfile(output_path, ['MMN_ERP_V03_' st '.csv']));
writetable(FACE_ERP, fullfile(output_path, ['FACE_ERP_V03_' st '.csv']));
writetable(VEP_ERP, fullfile(output_path, ['VEP_ERP_V03_' st '.csv']));