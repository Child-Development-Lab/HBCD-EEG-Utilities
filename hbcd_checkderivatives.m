% Check derivatives for hbcd data releases
% Alicia Vallorani 12.11.2025

% This script is adapted from code written by Santiago Morales to save 
% different mat files for each ERP, so we can generate different grand 
% averages and plots in MATLAB and R. This is done for each task separately.

% This script expects that you have a .csv of file names you want to run
% for each task with appropriate column names. If you do not already have
% such a list generated, you can do so with hbcd_createfilelist.R.

% This script pulls in each individual eeg derivatives task pipeline. Put 
% this script and the individual pipeline scripts in a folder called code. 
% Make an additional folder called "output" where this script will create 
% individual task folders and under each task a folder for each visit.

% Signal Processing Toolbox is required for the rsPipeline and can be
% installed through apps

%% Set Paths
% Change paths to match your needs

% Path to eeglab and load eeglab
addpath('/Users/aliciavallorani/Library/CloudStorage/Box-Box/hbcd/eeglab2023.0');
eeglab;

% Path to pipelines (needed if below the working directory)
addpath('/Users/aliciavallorani/Library/CloudStorage/Box-Box/hbcd/data_releases/br20.1/code');

% Path to data
rootDir = '/Volumes/cdl/Projects/hbcd/BR20.2 made derivatives/br20.2/hbcd/derivatives/made';

% Path to primary output folder
outputRoot = '/Users/aliciavallorani/Library/CloudStorage/Box-Box/hbcd/data_releases/br20.2/output';

% Path to list of files
fileListCSV = '/Users/aliciavallorani/Library/CloudStorage/Box-Box/hbcd/data_releases/br20.2/data/br20.2_filelist.csv';

%% Read in file list CSV (from R)
T = readtable(fileListCSV, ...
              'Delimiter', ',', ...
              'ReadVariableNames', true, ...
              'TextType', 'string');

% Build full file paths
tasks = T.Properties.VariableNames;
filePaths = struct();

for c = 1:numel(tasks)
    colName = tasks{c};
    filePaths.(colName) = strings(height(T),1);

    for r = 1:height(T)
        fname = T.(colName)(r);

        % force string -> char and strip any quotes MATLAB may show
        fname = erase(string(fname), '"');
        fname = strtrim(fname);

        if fname == "" || fname == "NA"
            continue
        end

        % Extract ID and session
        idMatch  = regexp(fname, '(sub-\d+)', 'match', 'once');
        sesMatch = regexp(fname, '(ses-V\d+)', 'match', 'once');

        if isempty(idMatch) || isempty(sesMatch)
            warning("Could not parse: %s", fname);
            continue
        end

        % Build full path
        fullPath = fullfile( ...
            rootDir, ...
            idMatch, ...
            sesMatch, ...
            'eeg', ...
            'processed_data', ...
            fname ...
        );

        filePaths.(colName)(r) = string(fullPath);
    end
end


%% Automatically detect tasks from filePaths (dynamic)
allTasks = fieldnames(filePaths);

% face task
faceTasks = allTasks(contains(allTasks, 'faceV')); % columns labeled faceV04, etc.
tasksToProcess.face = faceTasks;

% mmn task
mmnTasks = allTasks(contains(allTasks, 'mmnV')); % columns labeled mmnV04, etc.
tasksToProcess.mmn = mmnTasks; 

% vep task
vepTasks = allTasks(contains(allTasks, 'vepV')); % columns labeled vepV04, etc.
tasksToProcess.vep = vepTasks; 

% rs task
rsTasks = allTasks(contains(allTasks, 'rsV')); % columns labeled rsV04, etc.
tasksToProcess.rs = rsTasks;

% Loop over task groups
groupNames = fieldnames(tasksToProcess);

for g = 1:numel(groupNames)
    groupName = groupNames{g};
    taskList  = tasksToProcess.(groupName);

    fprintf('Processing group: %s\n', groupName);

    % Load all files for this group
    EEG_all_tasks_group = struct();
    for t = 1:numel(taskList)
        taskName = taskList{t};
        files = filePaths.(taskName);
        EEG_all = cell(size(files));

        fprintf('  Loading task: %s\n', taskName);

        for i = 1:numel(files)
            thisFile = files(i);

            % Skip empty entries
            if thisFile == ""
                warning("    Skipping empty entry at row %d for task %s", i, taskName);
                continue
            end

            % Convert string to char for pop_loadset
            thisFileChar = char(thisFile);

            % Load if file exists
            if isfile(thisFileChar)
                try
                    EEG_all{i} = pop_loadset(thisFileChar);
                catch ME
                    warning("    Failed to load %s: %s", thisFileChar, ME.message);
                end
            else
                warning("    File not found: %s", thisFileChar);
            end
        end

        EEG_all_tasks_group.(taskName) = EEG_all;
    end

    % -----------------------------
    % Apply processing for this group
    % -----------------------------
    switch groupName
    case 'face'
        fprintf('  Running FACE preprocessing pipeline\n');
        facePipeline(EEG_all_tasks_group, taskList, fullfile(outputRoot, 'face'));

    case 'mmn'
        fprintf('  Running MMN preprocessing pipeline\n');
        mmnPipeline(EEG_all_tasks_group, taskList, fullfile(outputRoot, 'mmn'));

    case 'vep'
        fprintf('  Running VEP preprocessing pipeline\n');
        vepPipeline(EEG_all_tasks_group, taskList, fullfile(outputRoot, 'vep'));

    case 'rs'
        fprintf('  Running RS preprocessing pipeline\n');
        rsPipeline(EEG_all_tasks_group, taskList, fullfile(outputRoot, 'rs'));
    end
end