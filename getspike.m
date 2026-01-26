clear all
clc
% change these parameters
% addpath(genpath("D:\PhD\SD\electrophysiology\spike_zyw\wonder-room\WonderRoomMat"));
% addpath(genpath("D:\PhD\SD\electrophysiology\spike_zyw\CellExplorer"));
rawPath = char(""); %输入sorting后文件路径
% [filepath,subDirName,ext] = fileparts(rawPath);
% traceFile2 = char("D:\PhD\SD\electrophysiology\spike_zyw\20220915opr1\behaviour\opr1.csv");
% frameTrigger1 = ;
% frameTrigger3 = ;
% parameter processing
numChannels = 32;
sampleRateAmp = 20000;
backslashIndex = strfind(rawPath, '\');
nameBase = [rawPath, '\', rawPath(backslashIndex(end)+1: end)];
amplifierNames = {[nameBase, '.dat']};
digitalinNames = {[rawPath, '\', 'digitalin.dat']};
clear backslashIndex filepath ext

segments = [];
rawData = RawData(numChannels, sampleRateAmp, amplifierNames, digitalinNames, segments, rawPath);

clear segments sampleRateAmp 

% digital trigger
digitalTriggers = rawData.DigitalInputs(2); %choose channel 打标时间
% load spike data
spikesAllType = SpikeData(nameBase, 'kwikCell',  (1:8), [], 'groupType',"spikeGroup"); %choose ch不同脑区可选不同通道(1：8),建议分开存
% extract pyramidal neurons with good quality
[spikes, ~] = spikesAllType.TypeIndex(["pyr"], ["good", "acceptable"]);% choose"int"中间
%%save data