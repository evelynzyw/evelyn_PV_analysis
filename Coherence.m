clc
clear;
fpath = char(".");%input .lfp
[filepath,subDirName,ext] = fileparts(fpath);
% [filepath,subDirName,ext] = fileparts(fpath)
channelsSelected1 = [ ]; %dCA1 
data_raw1=readmulti_frank([fpath '\' subDirName '.lfp'],32,channelsSelected1 ,0,inf);
data_raw1=data_raw1*0.195; 
data_raw1=mean(data_raw1,2); 
channelsSelected2 = [ ]; %MS 
data_raw2=readmulti_frank([fpath '\' subDirName '.lfp'],32,channelsSelected2 ,0,inf);
data_raw2=data_raw2*0.195; 
data_raw2=mean(data_raw2,2); 
Fs=1250;
%min,截取数据时间

%% 
begin_time=
end_time=
lfp_cut1=[];
lfp_cut1(:,:)=data_raw1((begin_time*60*Fs:end_time*60*Fs),1);   % 截取时间段内[s—s]内LFP中所有通道的数据
lfp_cut2=[];
lfp_cut2(:,:)=data_raw2((begin_time*60*Fs:end_time*60*Fs),1);


%% 定义params
params.tapers=[3,5];
params.pad=1;
params.Fs=1250;
params.fpass=[1,100];
params.err=[2,0.5]; 
% Coherence1=[];
phi1=[];
S12a=[];
S1a=[];
S2a=[];
confC1=[];
phistd1=[];
for i=1:size(data_raw2,2);
% [Coherence,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencysegc(data_raw1,data_raw2,40,params);
[Coherence,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencysegc(lfp_cut1(:,i),lfp_cut2(:,i),40,params);
% Coherence1=horzcat(Coherence1,Coherence);
meanCoherence=mean(Coherence,2);
smooth=100;
Cohsmoothed = Smooth(meanCoherence,smooth); %平滑
phi1=horzcat(phi1,phi);
S12a=horzcat(S12a,S12);
S1a=horzcat(S1a,S1);
S2a=horzcat(S2a,S2);
confC1=horzcat(confC1,confC);
phistd1=horzcat(phistd1,phistd);
end;
plot(f,Cohsmoothed);
ylim([0,1]);
% %% 定义频段
frequencyband={[1 4],[4 12],[12 30],[30 50],[50 100]};
index=cellfun(@(x) find(f>x(1)&f<x(2)),frequencyband,'UniformOutput',0);
%计算各频段PSD
meanCoherenceindex=cellfun(@(x) mean(meanCoherence(x)),index,'UniformOutput',0);
Coherence_band=cell2mat(meanCoherenceindex)';
%% savefile
savepath=''; 
savefile='_Cohs';
% save([savepath subDirName savefile '.mat'],'Coherence','Coherence_band');

