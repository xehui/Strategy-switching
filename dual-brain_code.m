clear;clc;
work_dir = 'D:\paper\advising strategy\NI';
processed_dir=fullfile(work_dir,'brain_afterpreprocess');
before_WTC_dir=fullfile(work_dir,'WTC\beforeWTC');

sub_list=[401:408 410:412 414 416:428 501:510];

for sub_nr = 1:numel(sub_list)
     w=sub_list(sub_nr);
%    for probe_nr=1:numel(probe_list)
%        n=probe_list(probe_nr);
      
      cd(processed_dir);
      load (['sub',num2str(w),'_MES_Probe1.mat']);
      hbo_PFC_01=hbo;
      hbr_PFC_01=hbr;
      
      load (['sub',num2str(w),'_MES_Probe2.mat']);
      hbo_TPJ_01=hbo;
      hbr_TPJ_01=hbr;
      
      load (['sub',num2str(w),'_MES_Probe3.mat']);
      hbo_PFC_02=hbo;
      hbr_PFC_02=hbr;
      
      load (['sub',num2str(w),'_MES_Probe4.mat']);
      hbo_TPJ_02=hbo;
      hbr_TPJ_02=hbr;
      
      hbo_all=[hbo_PFC_01,hbo_TPJ_01,hbo_PFC_02,hbo_TPJ_02];
      hbr_all=[hbr_PFC_01,hbr_TPJ_01,hbr_PFC_02,hbr_TPJ_02];
      
      cd(before_WTC_dir);
      save(['sub' num2str(w) '.mat'],'hbo_all','hbr_all');
      
   end
%% bad channels processing
clear;clc;
work_dir = 'D:\paper\advising strategy\NI';
processed_dir=fullfile(work_dir,'WTC\beforeWTC');% input the path for preporcessed data
WTC_dir = fullfile(work_dir,'WTC'); % input the path for WTC data
 %% Data of each file can be obtained by contacting the correspodning author

%bad channel：sub404-ch4; sub410-ch51(02Ch5); sub505-ch60 ch65
sub_list=[404 410 505];

load ('sub404.mat');%sub404的Ch4→Ch3,Ch13
hbo_new=hbo_all(:,[3 13]);
hbo_all(:,4)=mean(hbo_new,2);
save('sub404.mat','hbo_all','hbr_all');

load ('sub410.mat');%Sub410的Ch51（Ch5→Ch10,Ch14)
hbo_new = hbo_all(:,[56 60]);
hbo_all(:,51)=mean(hbo_new,2);
% hbr_new = hbr_all(:,[1:50 52:92]);
% hbr_all(:,51)=mean(hbr_new,2);
save('sub410.mat','hbo_all','hbr_all');

load ('sub505.mat');%Sub505的Ch60（Ch14→Ch5,Ch10)
hbo_new = hbo_all(:,[51,56]);
hbo_all(:,60)=mean(hbo_new,2);
hbr_new = hbr_all(:,[56 60]);%Sub505的Ch65（Ch19→Ch10,Ch14)
hbr_all(:,65)=mean(hbr_new,2);
save('sub505.mat','hbo_all','hbr_all');

%% calculate the coherence of the total experiment 
clear;clc;
work_dir = 'D:\paper\advising strategy\NI';
processed_dir=fullfile(work_dir,'WTC\beforeWTC');% input the path for preporcessed data
WTC_dir = fullfile(work_dir,'WTC'); % input the path for WTC data

sub_list=[401:408 410:412 414 416:428 501:510];

%Ignore bad channel
Num_channel =46;    

%%calculate the coherence of the total experiment 
 for sub_nr = 1:numel(sub_list)
     w=sub_list(sub_nr);
   
      cd(processed_dir);
      load (['sub',num2str(w),'.mat']);
      
        %calculate brain-to-brain coherence        
        %22+24  subject1→patch1(3*5)  patch2(4*4)    subject2→patch3(3*5)  patch4(4*4)
        %3*5→PFC        4*4→DLPFC
        %pur exp is 3*5→PFC  subject1→patch1(3*5)1:22 subject2→patch2(3*5) 23:44

        period_combined = [];
        scale_combined = [];
        rsq_allchan = cell(46,1);
 
        for Chan_nr= 1:Num_channel
            [Rsq,period,scale,coi,sig95]=wtc(hbr_all(:,Chan_nr),hbr_all(:,(Chan_nr+Num_channel)),'mcc',0,'ArrowDensity',[30 30]);
            %wtc是画图，然后可以赋值提取出来
            %直接对读取完的近红外数据进行分析
            %[Rsq,period,scale,coi,sig95]=wtc(hbo_coop(:,Chan_nr),hbo_coop(:,(Chan_nr+Num_channel)),'mcc',0);被试1通道对应被试2的23的通道
            
            rsq_allchan{Chan_nr} = Rsq;%put Rsq into the cell   
            period_combined = [period_combined;period];%put period into the cell  22*1cell
            scale_combined = [scale_combined;scale];
        end
        
        cd(WTC_dir );
        %save(['sub' num2str(i) '_wtc.mat'],'rsq_allchan','period_combined','scale_combined');%前为文件名后为变量
        save(['sub' num2str(w) '_hbr_wtc.mat'],'rsq_allchan','period_combined','scale_combined');
        disp(['sub' num2str(w) '_finished!']);
 end