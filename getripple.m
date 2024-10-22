clear all;
close all;
load '.mat';%load data
filparts=char'.mat'
[filepath,subDirName,ext] = fileparts(fpath)
channelsSelected = [1 2 3 4]; 
data_raw=readmulti_frank(fpath,32,channelsSelected,0,inf);
data_raw1=data_raw*0.194; 
data_raw=mean(data_raw1,2);
time=((1:size(data_raw,1)))';
lfp=[time/1250, data_raw];
filtered = FilterLFP(lfp);

i=2
[ripples,sd,bad] = FindRipples(filtered(:,[1,i]));
[maps,data,stats] = RippleStats(filtered(:,[1,i]),ripples);
% % end;
% % SaveRippleEvents(filename,ripples,16);
% PlotRippleStats(ripples,maps,data,stats);
