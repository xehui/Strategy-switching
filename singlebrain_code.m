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
    disp('step 2: model specification');
    cd(before_WTC_dir);
    fname_nirs = fullfile(before_WTC_dir,['sub' num2str(sub_list(sub_nr)) '.mat']);
    hb = 'hbo'; % hb = 'hbr'
    HPF = 'wavelet'; 
    method_cor = 0;  
    flag_window = 0; 
    hrf_type = 0;  
    units = 0;  
    names{1} = 'Incentivized'; 
    cd(Marktime_dir);
    load(['sub' num2str(sub_list(sub_nr)) '_mark.mat']);    
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

 
end 
