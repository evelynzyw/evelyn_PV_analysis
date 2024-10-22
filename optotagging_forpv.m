%% load data for example cell
% load spike;
clc
clear all
rawPath = char("spikes.mat");
load 'digitalTriggers_tag';
[filepath,subDirName,ext] = fileparts(rawPath);
load(rawPath);
logicalArray = ones(size(spikes(:,2)));

%% load stimulation information


Triggers=digitalTriggers_tag/20000;
numUnits = size(spikes(:,2), 1);%spike
P_default=[];
for iUnit = 1: numUnits;
    if ~isempty(spikes{iUnit,2});
     spikes_res=spikes{iUnit,2}/20000;
    [vecTime,vecRate,sIFR] = getIFR(spikes_res,Triggers);
    dblZetaP_default = getZeta(spikes_res,Triggers);
    else
     dblZetaP_default=1;
    logicalArray(iUnit)=0;
    end
     P_default=vertcat(P_default,dblZetaP_default);
end

tagging_row=any(P_default <=0.05,2);
spikes_tagging=spikes(tagging_row,:);


 dblUseMaxDur = median(diff(Triggers)); %median of trial-to-trial durations
intResampNum = 50; % 50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
intPlot = 4; %what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
vecRestrictRange = [0 0.5];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
boolDirectQuantile = false
dblBaselineDuration = 0.01;
matEventTimesWithPrecedingBaseline = Triggers - dblBaselineDuration; 
itagging=size(spikes_tagging,1);
taggingcell=cell(itagging,1);
dblBaselineDurationMs = dblBaselineDuration*1000;
tagging_dblZetaP=[];
for iUnit = 1: itagging;
    spikes_res=spikes_tagging{iUnit,2}/20000;
    [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikes_res,matEventTimesWithPrecedingBaseline,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
    drawnow;hFig = gcf;
   for intPlot=1:numel(hFig.Children)
	%adjust x-ticks
	if contains(hFig.Children(intPlot).XLabel.String,'Time ')
		set(hFig.Children(intPlot),'xticklabel',cellfun(@(x) num2str(str2double(x)-dblBaselineDuration),get(hFig.Children(intPlot),'xticklabel'),'UniformOutput',false));
	end
	%adjust timings in title
	strTitle = hFig.Children(intPlot).Title.String;
	[vecStart,vecStop]=regexp(strTitle,'[=].*?[m][s]');
	for intEntry=1:numel(vecStart)
		strOldNumber=hFig.Children(intPlot).Title.String((vecStart(intEntry)+1):(vecStop(intEntry)-2));
		strTitle = strrep(strTitle,strcat('=',strOldNumber,'ms'),strcat('=',num2str(str2double(strOldNumber)-dblBaselineDurationMs),'ms'));
	end
	hFig.Children(intPlot).Title.String = strTitle;
   end
   vecLatencies = vecLatencies - dblBaselineDuration;
sZETA.vecSpikeT = sZETA.vecSpikeT - dblBaselineDuration;
sRate.vecT = sRate.vecT - dblBaselineDuration;
sRate.dblPeakTime = sRate.dblPeakTime - dblBaselineDuration;
sRate.dblOnset = sRate.dblOnset - dblBaselineDuration;
tagging_dblZetaP=vertcat(tagging_dblZetaP,dblZetaP);
end