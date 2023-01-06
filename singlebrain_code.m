clc,clear
work_dir = 'D:\paper\advising strategy\NI';
processed_dir=fullfile(work_dir,'brain_afterpreprocess');
before_WTC_dir=fullfile(work_dir,'nirsdata');
Marktime_dir = fullfile(work_dir,'marker_all');
Specification_dir = fullfile(work_dir,'single brain\model specification\');
if ~exist(Specification_dir,'dir')
        mkdir(Specification_dir)
end 
Estimation_dir = fullfile(work_dir,'single brain\estimation\');
if ~exist(Estimation_dir,'dir')
        mkdir(Estimation_dir)
end 

sub_list=[401:408 410:412 414 416:428 501:510];
mark = [3 7]; % you can select by yourself

for sub_nr = 1:numel(sub_list)
    % read the fnirs rawdata  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 使用去过运动伪迹后的数据，所以光学数据转成成血样数据这一步省略
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % step 2: model specification
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('step 2: model specification');
    cd(before_WTC_dir);
    fname_nirs = fullfile(before_WTC_dir,['sub' num2str(sub_list(sub_nr)) '.mat']);
    hb = 'hbo'; % hb = 'hbr'
    HPF = 'wavelet'; 
    method_cor = 0;  
    save_dir = fullfile(Specification_dir,['sub_' num2str(sub_list(sub_nr))]);
    if ~exist(save_dir,'dir')
        mkdir(save_dir);
    end
    flag_window = 0;  % 0: do not show the design matrix, 1 : show the design matrix
    hrf_type = 0;  % the basis function to model the hemodynamic response
    units = 0;  
    names{1} = 'Incentivized'; % in a row  
    cd(Marktime_dir);
    load(['sub' num2str(sub_list(sub_nr)) '_mark.mat']);    
     %% Data of each file can be obtained by contacting the correspodning author
    %%%%%%%%%%%%%%%%%
 for trial_nr=1:numel(trial_list2)
               if  any( sub_list(sub_nr) == sub_list1(:))
                Block_timestamp(1,1)=task_mark(trial_list(trial_nr),1); %first condition (reward)
                Block_timestamp(1,2)=task_mark(trial_list(trial_nr),5);
               else
                Block_timestamp(1,1)=task_mark(trial_list(trial_nr),1); %second condition (reward)   
                Block_timestamp(1,2)=task_mark(trial_list(trial_nr),5);
               end
 end
    onsets{1} = Block_timestamp(1,1);  %onset
    durations{1} = Block_timestamp(1,2)-Block_timestamp(1,1); 
   %%%%%%%%%%%%%%%%%%%%%
     cd(Marktime_dir);
    load(['sub' num2str(sub_list(sub_nr)) '_mark.mat']);    
    %%%%%%%%%%%%%%%%%
 for trial_nr=1:numel(trial_list2)
               if  any( sub_list(sub_nr) == sub_list1(:))
                Block_timestamp(2,1)=task_mark(trial_list(trial_nr)+36,1);
                Block_timestamp(2,2)=task_mark(trial_list(trial_nr)+36,5);
               else
                Block_timestamp(2,1)=task_mark(trial_list(trial_nr)+36,1); 
                Block_timestamp(2,2)=task_mark(trial_list(trial_nr)+36,5);
               end
 end
   names{2} = 'Non-Incentivized';
   onsets{2} = Block_timestamp(2,1);  
   durations{2} = Block_timestamp(2,2)-Block_timestamp(2,1);
   [SPM_nirs] = specification_batch(fname_nirs, hb, HPF, LPF, method_cor, save_dir, flag_window, hrf_type, units,  names, onsets, durations);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % step 3: model estimation click or refer to the code in NIRS_SPM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
end 