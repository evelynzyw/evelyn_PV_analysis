clear all;
close all;
% [n,p]=uigetfile;
% filename=[p n]; %键入计算通道
% channelinput=input('输入需要计算的通道，从1开始,记得多个通道需要加中括号，并用空格间开：'); %导入数据
fpath = char("D:\JeffreyTong\data\LE14\LE14_231127\LE14_231127_lfp\LE14_231127.lfp");%导入数据
[filepath,subDirName,ext] = fileparts(fpath)
channelsSelected = [1 2 3 4]; %选择有spike的通道数
data_raw=readmulti_frank(fpath,32,channelsSelected,0,inf);
data_raw1=data_raw*0.194; %导入时间
data_raw=mean(data_raw1,2);
time=((1:size(data_raw,1)))';
lfp=[time/1250, data_raw];
filtered = FilterLFP(lfp);
% ripples1=[];
% for i=2:size(filtered,2)
i=2
[ripples,sd,bad] = FindRipples(filtered(:,[1,i]));
[maps,data,stats] = RippleStats(filtered(:,[1,i]),ripples);
% % end;
% % SaveRippleEvents(filename,ripples,16);
% PlotRippleStats(ripples,maps,data,stats);
