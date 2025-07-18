%% HBCD_EEG_Utilities


%% Generating ERP Summary Statistics, Trial Measures, and Power Spectra output information for HBCD data release
% This code is provided by the HBCD EEG Core team at the Child Development Lab, University of Maryland, College Park
% This code is designed to be used on processed HBCD EEG data 

% Before using this code, please refer to the HBCD documentation available
% here: https://hbcd-eeg-utilities.readthedocs.io/en/latest/

% Ongoing Contributors:
% Trisha Maheshwari (tmahesh@umd.edu)
% Whitney Kasenetz (kazenetz@umd.edu)
% Savannah McNair (smcnair1@umd.edu)
% For specific questions, contact eegdata@umd.edu


% This code uses EEGLAB toolbox and some of its plugins. Before running the pipeline, you have to install the following:
% EEGLab: https://sccn.ucsd.edu/eeglab/download.php

%% Setup -- DO NOT CHANGE
if ~exist('repoPath', 'var')
    repoPath = fileparts(matlab.desktop.editor.getActiveFilename);
end
cd(repoPath);

json_settings_file = fullfile(repoPath, 'supplemental files', 'proc_settings_HBCD.json');
%This file is necessary, it will set up all time windows, ERP directions,
%and ROIs-- please make sure you download the file from the Github page
%before running

CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
box = msgbox('\fontsize{16}Please remember to read the data warnings, available here: https://hbcd-docs.readthedocs.io/changelog/knownissues/', CreateStruct);
uiwait(box);

% Select where you downloaded your files from LASSO
if ~exist('data_path','var')
    CreateStruct.Interpreter = 'tex';
    CreateStruct.WindowStyle = 'modal';
    box = msgbox('\fontsize{16} Select location of derivative data from LASSO download (select the "made" folder)', CreateStruct);
    uiwait(box);
    data_path = uigetdir();
end

% Select where you downloaded your raw files from LASSO -- for age
if ~exist('age_info','var')
    CreateStruct.Interpreter = 'tex';
    CreateStruct.WindowStyle = 'modal';
    box = msgbox('\fontsize{16} Select location of raw data from LASSO download (select the "rawdata" folder)', CreateStruct);
    uiwait(box);
    age_info = uigetdir();
end

% ADD BLOCK TO CHECK RIGHT FOLDERS OR BREAK
if ~strcmp(data_path(end-3:end), 'made')
    clear
    error('You have not selected the made folder, please restart! NOTE: If you renamed the folder this error will pop up.')
end

if ~strcmp(age_info(end-6:end), 'rawdata')
    clear
    error('You have not selected the rawdata folder, please restart! NOTE: If you renamed the folder this error will pop up.')
end

% Create new folder in your data path to save the new concatenated csvs
concat_location = [data_path filesep 'Concatenated outputs for ERPs'];
if exist(concat_location, 'dir') == 0
        mkdir(concat_location);
end

%Add the plugin path and start EEGLAB
try
    eeglab;
catch
    box = msgbox('Select the location of where you downloaded your EEGLAB plugin');
    uiwait(box);
    eeg_path = uigetdir('Select where you downloaded EEGLAB');
    addpath(eeg_path);
    eeglab;
end


% Define the list of tasks
task_options = {'FACE', 'MMN', 'VEP', 'RS'};

% Use a GUI list dialog to let the user select tasks
[selected, ok] = listdlg( ...
    'PromptString', 'CTRL + click to select tasks:', ...
    'SelectionMode', 'multiple', ...
    'ListString', task_options);

% Check if the user clicked OK
if ok
    task_list = task_options(selected);
    disp('You selected:');
    disp(task_list);
else
    disp('No tasks selected.');
    return;
end

addpath([repoPath filesep 'supplemental files']);
% Path to supplemental files in repo



%% Here we will read in all the processed set files and ID paths
cd(data_path);

% Delete out any RS powerSummaryStat.csv files -- this should not be used
% as they contain stale and inaccurate calculations
datafile_names=dir(fullfile(data_path, '**\*powerSummaryStats.csv'));
datafile_names=datafile_names(~ismember({datafile_names.name},{'.', '..', '.DS_Store'}));
if ~isempty(datafile_names)
    for k=1:length(datafile_names)
        delete([datafile_names(k).folder filesep datafile_names(k).name]);
    end
end

datafile_names=dir(fullfile(data_path, '**\*filteredprocessed_eeg.set'));
datafile_names=datafile_names(~ismember({datafile_names.name},{'.', '..', '.DS_Store'}));
set_names={datafile_names.name};

%Filter out which tasks you have selected
for c=length(set_names):-1:1
    task = extractBetween(set_names{c}, 'task-', '_acq');
    if ~contains(task_list, task)
        %remove the file
        datafile_names(c) = [];
    end
end
%remake the new list of filtered files
set_names={datafile_names.name};
set_path = {datafile_names.folder};


%% Generate tables here
% Run a loop for each set file to create output tables - if everything is
% set up as expected, you should be able to just run this all together!
pIdx = 0;
allData = [];
cutoff = 0;
TrialNums = [];
EEG=eeg_checkset(EEG);
for subject=1:length(set_names)
    s = grab_settings(set_names{subject}, json_settings_file);
    participant_Id = set_names{subject}(1:14); %Get ID for data path to read set file
    output_location = [data_path filesep participant_Id filesep 'ses-V03' filesep 'eeg' filesep 'processed_data'];
    % Subject level csvs will be saved in the subject folder

    % RS Code here, if RS call other function, otherwise continue to next
    % subject
    if contains(set_names{subject}, 'RS')
        % Run RS separate script
        RS_ERP_Topo_Indv(output_location, set_names, subject, set_path, participant_Id);
        cd(data_path)
        continue
    end


    % Age calculations
    try
        % look for scans.tsv for the participant
        tsvpath= [age_info filesep participant_Id filesep 'ses-V03'];
        agetable = readtable([tsvpath filesep participant_Id '_ses-V03_scans.tsv'],"Filetype","text",'Delimiter','\t');
        try
            taskages=agetable.age(contains(agetable.filename,'eeg'));
            age = taskages(1)*12;   
        catch
            error("Age data is missing!")
        end

    catch
        %default to older age bin if age scans.tsv file is missing!
        age = 7;
    end
    
    % Code for Age calculations/bins
    age_bin = 1;
    in_range = 0;
    scoreROIs = s.score_ROIs;
    scoreAges = s.score_ages;
    erp_dirs = s.ERP_dirs; 

    if isempty(scoreAges)
        %Assert that the correct number of parameters are present
        scoreTimes = s.score_times;
        assert(length(scoreTimes)== length(scoreROIs), "Must have the same number of score times and ROIs!")
        
    else
        age_bin = 1;
        in_range = 0;
        for i=1:length(scoreAges)
            agemin = scoreAges(i,1);
            agemax = scoreAges(i,2);
            
            if age >= agemin && age < agemax
                age_bin = i;
                in_range = 1;
                break
            end    
            
        end 
        if in_range==0
            if age < scoreAges(1,1)
                age_bin=1;
        
            else
                age_bin=2;
            end
        end
    
        if age_bin == 1
            scoreTimes = s.score_times1;
        elseif age_bin == 2
            scoreTimes = s.score_times2;
        end
    end


    TrialNums(subject).Subject = set_names{subject};
    %load the preprocessed file
    EEG = pop_loadset('filename', strrep(set_names{subject}, '.set', '.set'),'filepath', set_path{subject} );
    EEG = eeg_checkset(EEG);
    
for i=1:length(scoreTimes)
    %select time window of interest
    scoreTime = scoreTimes(i,:);
    PeakStart = scoreTime(1);
    PeakEnd = scoreTime(2);

    direction = erp_dirs(i);

    PeakRange = find(EEG.times == PeakStart):find(EEG.times == PeakEnd);

    %select ROI
        Cluster = scoreROIs{i};
        ROI = get_Cluster(Cluster);

    if isempty(ROI)
        ROI = {EEG.chanlocs.labels}; %default to all channels
    end

    roi_ind = find(ismember({EEG.chanlocs.labels},ROI));

    if contains(set_names{subject}, 'FACE')
        tab=[];
        tab2=[];
        tab3=[];
        tab4=[];
        conditions = unique({EEG.event.Condition}); %check which conditions exist
        if sum(contains(conditions, '1'))==1
            EEG_ui = pop_selectevent(EEG, 'Condition', '1', 'deleteevents','on'); %select only uprightInv trials
            EEG_ui = eeg_checkset(EEG_ui);
            if EEG_ui.trials == 1 %exception for when there is only one trial retained for this condition
                EEG_ui_trialnums = {EEG_ui.event.TrialNum}';
                EEG_ui_roi = squeeze(mean(EEG_ui.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_ui_peak = squeeze(mean(EEG_ui_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_ui_peak';

                tab = array2table(Scores); %make table
                tab = renamevars(tab,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table


                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_ui, PeakRange, roi_ind, direction);%NEW TM
                %tab.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;

                tab.Condition(:) = "uprightInv"; %add condition variable
                tab.("TrialNum") = EEG_ui_trialnums; %add trial num variable
            else
                EEG_ui_trialnums = {EEG_ui.event.TrialNum}';
                EEG_ui_roi = squeeze(mean(EEG_ui.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_ui_peak = squeeze(mean(EEG_ui_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_ui_peak';
                tab = array2table(Scores); %make table
                tab = renamevars(tab,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_ui, PeakRange, roi_ind, direction);%NEW TM
                %tab.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;

                tab.Condition(:) = "uprightInv"; %add condition variable
                tab.("TrialNum") = EEG_ui_trialnums; %add trial num variable
            end
        end

        if sum(contains(conditions, '2'))==1
            EEG_i = pop_selectevent(EEG, 'Condition', '2', 'deleteevents','on'); %select only inverted trials
            EEG_i = eeg_checkset(EEG_i);
            if EEG_i.trials == 1
                EEG_i_trialnums = {EEG_i.event.TrialNum}';
                EEG_i_roi = squeeze(mean(EEG_i.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_i_peak = squeeze(mean(EEG_i_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_i_peak';
                tab2 = array2table(Scores); %make table
                tab2 = renamevars(tab2,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_i, PeakRange, roi_ind, direction);%NEW TM
                %tab2.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab2.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab2.Condition(:) = "inverted"; %add condition variable
                tab2.("TrialNum") = EEG_i_trialnums; %add trial num variable
            else
                EEG_i_trialnums = {EEG_i.event.TrialNum}';
                EEG_i_roi = squeeze(mean(EEG_i.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_i_peak = squeeze(mean(EEG_i_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_i_peak';
                tab2 = array2table(Scores); %make table
                tab2 = renamevars(tab2,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_i, PeakRange, roi_ind, direction);%NEW TM
                %tab2.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab2.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab2.Condition(:) = "inverted"; %add condition variable
                tab2.("TrialNum") = EEG_i_trialnums;
            end
        end

        if sum(contains(conditions, '3'))==1
            EEG_o = pop_selectevent(EEG, 'Condition', '3', 'deleteevents','on'); %select only object trials
            EEG_o = eeg_checkset(EEG_o);
            if EEG_o.trials == 1
                EEG_o_trialnums = {EEG_o.event.TrialNum}';
                EEG_o_roi = squeeze(mean(EEG_o.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_o_peak = squeeze(mean(EEG_o_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_o_peak';
                tab3 = array2table(Scores); %make table
                tab3 = renamevars(tab3,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % TODO: Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_o, PeakRange, roi_ind, direction);%NEW TM
                %tab3.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab3.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab3.Condition(:) = "object"; %add condition variable
                tab3.("TrialNum") = EEG_o_trialnums; %add trial num variable
            else
                EEG_o_trialnums = {EEG_o.event.TrialNum}';
                EEG_o_roi = squeeze(mean(EEG_o.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_o_peak = squeeze(mean(EEG_o_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_o_peak';
                tab3 = array2table(Scores); %make table
                tab3 = renamevars(tab3,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_o, PeakRange, roi_ind, direction);%NEW TM
                %tab3.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab3.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab3.Condition(:) = "object"; %add condition variable
                tab3.("TrialNum") = EEG_o_trialnums;
            end
        end

        if sum(contains(conditions, '4'))==1
            EEG_uo = pop_selectevent(EEG, 'Condition', '4', 'deleteevents','on'); %select only uprightObj trials
            EEG_uo = eeg_checkset(EEG_uo);
            if EEG_uo.trials == 1
                EEG_uo_trialnums = {EEG_uo.event.TrialNum}';
                EEG_uo_roi = squeeze(mean(EEG_uo.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_uo_peak = squeeze(mean(EEG_uo_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_uo_peak';
                tab4 = array2table(Scores); %make table
                tab4 = renamevars(tab4,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                %Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_uo, PeakRange, roi_ind, direction);%NEW TM
                %tab4.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab4.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab4.Condition(:) = "uprightObj"; %add condition variable
                tab4.("TrialNum") = EEG_uo_trialnums; %add trial num variable
            else
                EEG_uo_trialnums = {EEG_uo.event.TrialNum}';
                EEG_uo_roi = squeeze(mean(EEG_uo.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_uo_peak = squeeze(mean(EEG_uo_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_uo_peak';
                tab4 = array2table(Scores); %make table
                tab4 = renamevars(tab4,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_uo, PeakRange, roi_ind, direction);%NEW TM
                %tab4.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab4.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab4.Condition(:) = "uprightObj"; %add condition variable
                tab4.("TrialNum") = EEG_uo_trialnums;
            end
        end

        tabFull = [tab; tab2; tab3; tab4;];
        tabFull.ID(:) = convertCharsToStrings(participant_Id);

    elseif contains(set_names{subject}, 'MMN')
        tab=[];
        tab2=[];
        tab3=[];

        conditions = unique({EEG.event.Condition}); %check which conditions exist

        if sum(contains(conditions, '1'))==1
            EEG_s = pop_selectevent(EEG, 'Condition', '1', 'deleteevents','on'); %select only standard trials
            EEG_s = eeg_checkset(EEG_s);
            if EEG_s.trials == 1 %exception for when there is only one trial retained for this condition
                EEG_s_trialnums = {EEG_s.event.TrialNum}';
                EEG_s_roi = squeeze(mean(EEG_s.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_s_peak = squeeze(mean(EEG_s_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_s_peak';
                tab = array2table(Scores); %make table
                tab = renamevars(tab,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_s, PeakRange, roi_ind, direction);%NEW TM
                %tab.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab.Condition(:) = "standard"; %add condition variable
                tab.("TrialNum") = EEG_s_trialnums;
            else
                EEG_s_trialnums = {EEG_s.event.TrialNum}';
                EEG_s_roi = squeeze(mean(EEG_s.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_s_peak = squeeze(mean(EEG_s_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_s_peak';
                tab = array2table(Scores); %make table
                tab = renamevars(tab,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_s, PeakRange, roi_ind, direction);%NEW TM
                %tab.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab.Condition(:) = "standard"; %add condition variable
                tab.("TrialNum") = EEG_s_trialnums;
            end
        end

        if sum(contains(conditions, '2'))==1
            EEG_p = pop_selectevent(EEG, 'Condition', '2', 'deleteevents','on'); %select only predeviant trials
            EEG_p = eeg_checkset(EEG_p);
            if EEG_p.trials == 1
                EEG_p_trialnums = {EEG_p.event.TrialNum}';
                EEG_p_roi = squeeze(mean(EEG_p.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_p_peak = squeeze(mean(EEG_p_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_p_peak';
                tab2 = array2table(Scores); %make table
                tab2 = renamevars(tab2,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_p, PeakRange, roi_ind, direction);%NEW TM
                %tab2.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab2.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab2.Condition(:) = "predeviant"; %add condition variable
                tab2.("TrialNum") = EEG_p_trialnums;
            else
                EEG_p_trialnums = {EEG_p.event.TrialNum}';
                EEG_p_roi = squeeze(mean(EEG_p.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_p_peak = squeeze(mean(EEG_p_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_p_peak';
                tab2 = array2table(Scores); %make table
                tab2 = renamevars(tab2,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_p, PeakRange, roi_ind, direction);%NEW TM
                %tab2.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab2.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab2.Condition(:) = "predeviant"; %add condition variable
                tab2.("TrialNum") = EEG_p_trialnums;
            end
        end

        if sum(contains(conditions, '3'))==1
            EEG_d = pop_selectevent(EEG, 'Condition', '3', 'deleteevents','on'); %select only deviant trials
            EEG_d = eeg_checkset(EEG_d);
            if EEG_d.trials == 1
                EEG_d_trialnums = {EEG_d.event.TrialNum}';
                EEG_d_roi = squeeze(mean(EEG_d.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_d_peak = squeeze(mean(EEG_d_roi(PeakRange))); %select and average across timerange of interest
                Scores = EEG_d_peak';
                tab3 = array2table(Scores); %make table
                tab3 = renamevars(tab3,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_d, PeakRange, roi_ind, direction);%NEW TM
                %tab3.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab3.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab3.Condition(:) = "deviant"; %add condition variable
                tab3.("TrialNum") = EEG_d_trialnums;
            else
                EEG_d_trialnums = {EEG_d.event.TrialNum}';
                EEG_d_roi = squeeze(mean(EEG_d.data(roi_ind, :,:),1)); %select and average across channels of interest
                EEG_d_peak = squeeze(mean(EEG_d_roi(PeakRange, :),1)); %select and average across timerange of interest
                Scores = EEG_d_peak';
                tab3 = array2table(Scores); %make table
                tab3 = renamevars(tab3,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

                % Insert peak latency function here
                %[AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_d, PeakRange, roi_ind, direction);%NEW TM
                %tab3.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
                %tab3.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


                tab3.Condition(:) = "deviant"; %add condition variable
                tab3.("TrialNum") = EEG_d_trialnums;
            end
        end

        tabFull = [tab; tab2; tab3];
        tabFull.ID(:) = convertCharsToStrings(participant_Id);

    elseif contains(set_names{subject}, 'VEP')
        EEG_v = pop_selectevent(EEG, 'Condition', '1', 'deleteevents','on');
        EEG_v = eeg_checkset(EEG_v);
        if EEG_v.trials == 1
            EEG_v_trialnums = {EEG_v.event.TrialNum}';
            EEG_v_roi = squeeze(mean(EEG_v.data(roi_ind, :,:),1)); %select and average across channels of interest
            EEG_v_peak = squeeze(mean(EEG_v_roi(PeakRange))); %select and average across timerange of interest
            Scores = EEG_v_peak';
            tab = array2table(Scores); %make table
            tab = renamevars(tab,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

            % Insert peak latency function here
            [AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_v, PeakRange, roi_ind, direction);%NEW TM
            tab.(['Peak_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
            tab.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


            tab.("TrialNum") = EEG_v_trialnums;
            tab.Condition(:) = "vep";
            tabFull = tab;
            tabFull.ID(:) = convertCharsToStrings(participant_Id);
        else
            EEG_v_trialnums = {EEG_v.event.TrialNum}';
            EEG_v_roi = squeeze(mean(EEG_v.data(roi_ind, :,:),1)); %select and average across channels of interest
            EEG_v_peak = squeeze(mean(EEG_v_roi(PeakRange, :),1)); %select and average across timerange of interest
            Scores = EEG_v_peak';
            tab = array2table(Scores); %make table
            tab = renamevars(tab,["Scores"], ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]); %label table

            % Insert peak latency function here
            [AvgPeakScores, PeakLatencies] =  compute_peaks_latencies(EEG_v, PeakRange, roi_ind, direction);%NEW TM
            tab.(['AdaptiveMean_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = AvgPeakScores;
            tab.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = PeakLatencies;


            tab.("TrialNum") = EEG_v_trialnums;
            tab.Condition(:) = "vep";
            tabFull = tab;
            tabFull.ID(:) = convertCharsToStrings(participant_Id);
        end

    else
        error("Not a scoreable task!")
    end

    %writetable(tabFull, [output_location filesep participant_label '_' session_label '_task-' task '_' num2str(PeakStart) '-' num2str(PeakEnd) '_ERP-Scores.csv']);

    %new changes to keep original order of conditions
    tabFull = convertvars(tabFull,["Condition"],"categorical");
    % Group-wise sme calculations
    conditions2 = cellstr(unique(tabFull.Condition, 'stable'));
    sme = grpstats(tabFull, 'Condition', {@(x) std(x)/sqrt(numel(x))}, 'DataVars', ['MeanAmplitude_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]);
    sme.Properties.VariableNames{3} = ['SME_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)];
    %sme(cellstr(conditions2), :) = sme
    [X,Y] = ismember(sme.Condition, conditions2);
    [~,Z] = sort(Y);
    sme2 = sme(Z,:);
    sme = sme2;


    ncond = height(sme);
    peakVals = zeros(ncond, 1);
    latVals = zeros(ncond, 1);
    meanVals = zeros(ncond, 1);
    conditions1 = unique({EEG.event.Condition}); %check which conditions exist
    
    for c=1:ncond
        EEG_c = pop_selectevent(EEG, 'Condition', conditions1{c}, 'deleteevents','on'); %select only inverted trials
        EEG_c = eeg_checkset(EEG_c);

        EEG_c_roi = squeeze(mean(EEG_c.data(roi_ind, :,:),1)); %select and average across channels of interest
        EEG_c_mean = mean(EEG_c_roi,2);
        EEG_roi_tw = EEG_c_mean(PeakRange);
        if direction==1
            EEG_peak_value = max(EEG_roi_tw);
        elseif direction==-1
            EEG_peak_value = min(EEG_roi_tw);
        end


        peak_index = find(EEG_c_mean== EEG_peak_value,1);
        peak_latency = EEG.times(peak_index);

        %window_ms is the variable determining the window around the
        %adaptive mean. DG edit on 7/8
        window_ms = 10;

        % Find index range within ±10 ms of the peak
        peakav_start = find(EEG.times >= peak_latency - window_ms, 1, 'first');
        peakav_end   = find(EEG.times <= peak_latency + window_ms, 1, 'last');

        if isempty(peakav_start)
            peakav_start = 1;

        elseif isempty(peakav_end)
            peakav_end = length(EEG.times);

        end

        AvgPeakRange = peakav_start:peakav_end;

        avg_peak_value = mean(EEG_c_mean(AvgPeakRange));

        mean_value = mean(EEG_c_mean(PeakRange));

        peakVals(c) = avg_peak_value;
        latVals(c) = peak_latency;
        meanVals(c) = mean_value;

    end
    
    if contains(set_names{subject}, 'FACE')
        sme.(['MeanAmp_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = meanVals;
    elseif contains(set_names{subject}, 'MMN')
        sme.(['MeanAmp_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = meanVals;
    else
        sme.(['AdaptiveMean_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = peakVals;
        sme.(['Latency_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = latVals;
        sme.(['MeanAmp_' num2str(PeakStart) '-' num2str(PeakEnd) '_' char(Cluster)]) = meanVals;
    end

    if i==1
        smeWide = sme;
        tabWide = tabFull;
    else
        smeWide = join(smeWide, sme);
        try
            tabWide = join(tabWide, tabFull);
        catch
            % One participant has error in trial num
            tabWide.TrialNum{78} = '94';
            tabFull.TrialNum{78} = '94';
            tabWide = join(tabWide, tabFull);
        end
    end

end    

smeWide.Properties.VariableNames{2} = 'NTrials';
writetable(smeWide, [output_location filesep strrep(set_names{subject}, '_desc-filteredprocessed_eeg.set', '_ERPSummaryStats.csv')]);
writetable(tabWide, [output_location filesep strrep(set_names{subject}, '_desc-filteredprocessed_eeg.set', '_ERPTrialMeasures.csv')]);

end %subject loop
        


%% Concatenate files for SummaryStats.csvs
% This section will pull all the summarystat files together into one larger
% csv file for each of the tasks you specified in the task list.
concatenate_files_summary(data_path, task_list, concat_location);


%% Concatenate files for TrialMeasures.csvs
% This section will pull all the trialmeasures files together into one
% larger csv file for each of the tasks you specified in the task list.
concatenate_trial_measures(data_path, task_list, concat_location);


%% Reset directory here
cd(repoPath)