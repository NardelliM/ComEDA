close all
clear all
clc

% Loading the test signals:
% - data_hg.mat: a structure containing six test signals (three for the
%                resting state and three for the stressful task) for each
%                EDA, tonic, and phasic components, related to three subjects
%                undergoing the submaximal hand-grip protocol (Exp1),
% - data_stroop.mat: a structure containing six test signals (three for the
%                resting state and three for the stressful task) for each
%                EDA, tonic and phasic components, related to three subjects
%                undergoing the Stroop Color and Word Test (Exp4)

%All the time series skin conductance-derived time series are already
%pre-processed by applying the cvxEDA method with the zscore normalization.

load data_hg_test.mat
load data_stroop_test.mat


comp_rest_hg=[];
comp_stress_hg=[];

comp_rest_stroop=[];
comp_stress_stroop=[];

ser={'eda','tonic','phasic'};
prot={'hg', 'stroop'};
fs=4; % sampling frequency of eda, tonic, and phasic signals

for p=1:2
    figure(p)
    for s=1:3
           for subj=1:3
            cmd=sprintf('comp_rest_%s.%s(subj)=comEDA(data_%s.sub%d.%s.rest, fs);',prot{p},ser{s},prot{p},subj,ser{s});
            eval(cmd)
            
            cmd=sprintf('comp_stress_%s.%s(subj)=comEDA(data_%s.sub%d.%s.stress, fs);',prot{p},ser{s},prot{p},subj,ser{s});
            eval(cmd)
        end
    subplot(1,3,s)

cmd=sprintf('boxplot([comp_rest_%s.%s;comp_stress_%s.%s]'',''Labels'',{''Rest'',''Stress''},''PlotStyle'',''compact'');title(''%s %s'')',prot{p},ser{s},prot{p},ser{s},ser{s},prot{p});
    eval(cmd)
    end
end




