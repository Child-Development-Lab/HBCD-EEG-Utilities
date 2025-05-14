function concatenate_files_summary(data_path, task_list, concat_location)

%% Concatenate files for SummaryStats.csvs
cd(data_path)

% Initialize outputs
MMN_ERP = [];
FACE_ERP = [];
VEP_ERP = [];

% list files for each task
datafile_names=dir(fullfile(data_path, '**\*SummaryStats.csv'));
datafile_names=datafile_names(~ismember({datafile_names.name},{'.', '..', '.DS_Store'}));
datafile_names_MMN=datafile_names((contains({datafile_names.name}, 'MMN')));
MMN_names = {datafile_names_MMN.name};
MMN_path = {datafile_names_MMN.folder};
datafile_names_FACE=datafile_names((contains({datafile_names.name}, 'FACE')));
FACE_names = {datafile_names_FACE.name};
FACE_path = {datafile_names_FACE.folder};
datafile_names_VEP=datafile_names((contains({datafile_names.name}, 'VEP')));
VEP_names = {datafile_names_VEP.name};
VEP_path = {datafile_names_VEP.folder};

% Loop over each ID

% MMN
if any(contains(task_list, 'MMN'))
for i = 1:length(MMN_names)
    x = MMN_names{i};
    MMN_ERP_file = fullfile([MMN_path{i} filesep x]);
    x = extractBefore(x, '_ses');
    if isfile(MMN_ERP_file)
        MMN_ERP_sheet = readtable(MMN_ERP_file);
        if height(MMN_ERP_sheet) > 0
            MMN_ERP_sheet.ID = repmat({x}, height(MMN_ERP_sheet), 1);
            new_names = {
                'SME_MMR_t7t8', 'MeanAmp_MMR_t7t8', ...
                'SME_MMR_f7f8', 'MeanAmp_MMR_f7f8', ...
                'SME_MMR_fcz', 'MeanAmp_MMR_fcz'
            };
            MMN_ERP_sheet.Properties.VariableNames(3:8) = new_names;
            MMN_ERP = [MMN_ERP; MMN_ERP_sheet];
            disp(['Compiling MMN: ' x]);
        end
    else
        disp(['MMN ERP file not found for ' x]);
    end
end
end


% FACE
if any(contains(task_list, 'FACE'))
for i = 1:length(FACE_names)
    x = FACE_names{i};
    FACE_ERP_file = fullfile([FACE_path{i} filesep x]);
    x = extractBefore(x, '_ses');
    if isfile(FACE_ERP_file)
        FACE_ERP_sheet = readtable(FACE_ERP_file);
        if height(FACE_ERP_sheet) > 0
            FACE_ERP_sheet.ID = repmat({x}, height(FACE_ERP_sheet), 1);
            new_names = {
                'SME_N290_p8', 'MeanAmp_N290_p8', ...
                'SME_N290_p7', 'MeanAmp_N290_p7', ...
                'SME_P1', 'MeanAmp_P1', ...
                'SME_N290_Oz', 'MeanAmp_N290_Oz', ...
                'SME_P400', 'MeanAmp_P400', ...
                'SME_Nc', 'MeanAmp_Nc'
            };
            FACE_ERP_sheet.Properties.VariableNames(3:14) = new_names;
            FACE_ERP = [FACE_ERP; FACE_ERP_sheet];
            disp(['Compiling FACE: ' x]);
        end
    else
        disp(['FACE ERP file not found for ' x]);
    end
end
end

% VEP
if any(contains(task_list, 'VEP'))
for i = 1:length(VEP_names)
    x = VEP_names{i};
    VEP_ERP_file = fullfile([VEP_path{i} filesep x]);
    x = extractBefore(x, '_ses');
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
end


% Save .csv outputs 
st = datestr(now, 'yyyy-mm-dd');

% only write out specified tasks
if any(contains(task_list, 'MMN'))
    writetable(MMN_ERP, fullfile(concat_location, ['MMN_ERP_V03_' st '.csv']));
end
if any(contains(task_list, 'FACE'))
    writetable(FACE_ERP, fullfile(concat_location, ['FACE_ERP_V03_' st '.csv']));
end
if any(contains(task_list, 'VEP'))
    writetable(VEP_ERP, fullfile(concat_location, ['VEP_ERP_V03_' st '.csv']));
end

end