clc
clear all;
load '.mat';%load data
[filepath,subDirName,ext] = fileparts(fpath);
channelsSelected = [1 2 3 4]; 
data_raw=readmulti_frank([fpath '\' subDirName '.lfp'],32,channelsSelected,0,inf);
data_raw=data_raw*0.194; 
data_raw=mean(data_raw,2); 

data=notchfilter(data_raw);
fs_lfp=1250; 
lfp_cut=[];



%params
params.tapers=[3,5];
params.pad=1;
params.Fs=1250;
params.fpass=[1,100];
params.err=0;

result1=[];
for i=1:size(data,2)
[result,f]=mtspectrumsegc(data(:,i),40,params,1); 
result1=horzcat(result1,result);
end

meanPSD=mean(result1,2);


% delta=find(f>1&f<4);
% theta=find(f>4&f<13);
% beta=find(f>13&f<30);
% lowgamma=find(f>30&f<50);
% highgamma=find(f>50&f<100);
frequencyband={[1 4],[4 13],[13 30],[30 50],[50 100]};
index=cellfun(@(x) find(f>x(1)&f<x(2)),frequencyband,'UniformOutput',0);

PSDindex=cellfun(@(x) trapz(f(x),meanPSD(x)),index,'UniformOutput',0);

RelativePSDindex=cellfun(@(x) x/trapz(f,meanPSD),PSDindex,'UniformOutput',0);
%
PSD=cell2mat(PSDindex)';
RelativePSD=cell2mat(RelativePSDindex)';
plot(f,meanPSD,'Color',[0.8 0.1 0.1],'LineWidth',1.5)
ylim([1 8000])




