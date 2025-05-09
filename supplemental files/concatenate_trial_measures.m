function concatenate_trial_measures(data_path, task_list, concat_location)
%% Setup

cd(data_path)

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

% list files for each task
datafile_names=dir(fullfile(data_path, '**\*ERPTrialMeasures.csv'));
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

%% Concatenate trial measures output
% Loop over each ID

% FACE
if any(contains(task_list, 'FACE'))
for j = 1:length(FACE_names)
    x = FACE_names{j};
    file = fullfile([FACE_path{j} filesep x]);
    x = extractBefore(x, '_ses');
    if isfile(file)
        tmp = readtable(file);
        disp(['Compiling ' x]);
        mapping = {
            1, 'MeanAmp_N290_p8';
            5, 'MeanAmp_N290_p7';
            6, 'MeanAmp_P1_Oz';
            7, 'MeanAmp_N290_Oz';
            8, 'MeanAmp_P400_Oz';
            9, 'MeanAmp_Nc_fcz'
        };
        tmp = rename_columns(tmp, mapping);
        FACE_trialmeasures = [FACE_trialmeasures; tmp];
    else
        disp(['FACE file not found for ' x]);
    end
end
end

% MMN
if any(contains(task_list, 'MMN'))
for j = 1:length(MMN_names)
    x = MMN_names{j};
    file = fullfile([MMN_path{j} filesep x]);
    x = extractBefore(x, '_ses');
    if isfile(file)
        tmp = readtable(file);
        disp(['Compiling ' x]);
        mapping = {
            1, 'MeanAmp_MMR_t7t8';
            5, 'MeanAmp_MMR_f7f8';
            6, 'MeanAmp_MMR_fcz';
        };
        tmp = rename_columns(tmp, mapping);
        MMN_trialmeasures = [MMN_trialmeasures; tmp];
    else
        disp(['MMN file not found for ' x]);
    end
end
end

% VEP
if any(contains(task_list, 'VEP'))
for j = 1:length(VEP_names)
    x = VEP_names{j};
    file = fullfile([VEP_path{j} filesep x]);
    x = extractBefore(x, '_ses');
    if isfile(file)
        tmp = readtable(file);
        disp(['Compiling ' x]);
        mapping = {
            1, 'MeanAmp_N1_t7t8';
            2, 'AdaptiveMean_N1_oz';
            3, 'Latency_N1_oz';
            7, 'MeanAmp_P1_oz';
            8, 'AdaptiveMean_P1_oz';
            9, 'Latency_P1_oz';
            10, 'MeanAmp_N2_oz';
            11, 'AdaptiveMean_N2_oz';
            12, 'Latency_N2_oz'
        };
        tmp = rename_columns(tmp, mapping);
        VEP_trialmeasures = [VEP_trialmeasures; tmp];
    else
        disp(['VEP file not found for ' x]);
    end
end
end

% Save .csv outputs 
st = datestr(now, 'yyyy-mm-dd');

if any(contains(task_list, 'MMN'))
    MMN_trialmeasures = MMN_trialmeasures(:, [2,3,4,1,5,6]);
    writetable(MMN_trialmeasures, fullfile(concat_location, ['MMN_trialMeasures_V03_' st '.csv']));
end
if any(contains(task_list, 'FACE'))
    FACE_trialmeasures = FACE_trialmeasures(:, [2,3,4,1,5,6,7,8,9]);
    writetable(FACE_trialmeasures, fullfile(concat_location, ['FACE_trialMeasures_V03_' st '.csv']));
end
if any(contains(task_list, 'VEP'))
    VEP_trialmeasures = VEP_trialmeasures(:, [4,5,6,1,2,3,7,8,9,10,11,12]);
    writetable(VEP_trialmeasures, fullfile(concat_location, ['VEP_trialMeasures_V03_' st '.csv']));
end


end