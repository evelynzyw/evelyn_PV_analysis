clc
clear all
edfFilePath = char(".edf");
[filepath,subDirName,ext] = fileparts(edfFilePath);
% use edfread readedf
% if ~ exist([[filepath '\' subDirName '.mat']],'file') 
[header, data] = edfread(edfFilePath);
%channel data
eegcell1 = header.EEGEEG1A_B; 

eegcell2 = header.EEGEEG2A_B;
emgcell = header.EMGEMG;
%savedata