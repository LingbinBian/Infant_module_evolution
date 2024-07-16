% DEMON Number of communities versus resolution
%
%
% Version 1.0
% 27-Sep-2023
% Copyright (c) 2023, Lingbin Bian

clear
clc
close all

scan=2; % 1: AP 2:PA
N_roi=100; % number of ROIs
N_res=17;  % number of modularity resolutions
N_window=9;  % age window number

K_longi=zeros(N_window,N_res);
K_ave_longi=zeros(N_window,N_res);
K_indi_longi=cell(N_window,1);
for n=1:N_window
    [K_longi(n,:),K_ave_longi(n,:),K_indi_longi{n,1}]=number_commu(scan,N_roi,N_res,n);
end


colorvector=[1,1,0;0.78,0.38,0.08;0,0,1;1,0,0;0,1,0;0,0.5,0;0.5,0.5,0;1,0.5,0.5];
res=0.9:0.1:2.5;  % modularity resolutions

for j=1:N_res
    count_K=tabulate(K_indi_longi{1,1}(:,j));
    count_K_og=count_K;
    count_K(count_K(:,2)==0,:)=[];
    scatter(res(j),count_K(:,1),20*count_K(:,2),'filled')
    alpha(0.6)
    hold on
end

hold on

plot(res,K_longi(1,:),'--ks',...
'LineWidth',1.2,...
'MarkerSize',7,...
'MarkerEdgeColor','k',...
'MarkerFaceColor',colorvector(1,:));

hold on

%set(gca,'fontsize',16)
set(gca,'box','on')
set(gca, 'linewidth', 1.2, 'fontsize', 12, 'fontname', 'times')
if scan==1
    title(['AP',', ROI=',num2str(N_roi)],'fontsize', 16)
else
    title(['PA',', ROI=',num2str(N_roi)],'fontsize', 16)
end
xlabel('\gamma','fontsize',16)
ylabel('K','fontsize',16)
set(gca, 'linewidth', 1.2, 'fontsize', 16, 'fontname', 'times')
%set(gcf,'unit','centimeters','position',[6 10 22 12])
xlim([0.7,2.7]); % range of x
set(gcf,'unit','centimeters','position',[6 10 14 12])
set(gca,'Position',[.22 .2 .65 .65]);
data_path = fileparts(mfilename('fullpath'));

% figure
% c=0;
% for n=1:N_window
%     plot(res,K_longi(n,:),'--ks',...
%     'LineWidth',1.2,...
%     'MarkerSize',7,...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[c,c,c]);
%     c=c+0.1;
%     hold on
% end



if scan==1

    saveas(gcf,['../figures/','roi_',num2str(N_roi),'_AP','_number_communities.fig'])
    saveas(gcf,['../figures_paper/','roi_',num2str(N_roi),'_AP','_number_communities.png'])
elseif scan==2
  
    saveas(gcf,['../figures/','roi_',num2str(N_roi),'_PA','_number_communities.fig'])
    saveas(gcf,['../figures_paper/','roi_',num2str(N_roi),'_PA','_number_communities.png'])
end

% plot(res,K_ave_longi(1,:),'--ks',...
% 'LineWidth',1.2,...
% 'MarkerSize',7,...
% 'MarkerEdgeColor','k',...
% 'MarkerFaceColor',colorvector(2,:));

% -------------------------------------------------------------------------
% nested function
function [K,K_ave,K_indi]=number_commu(scan,N_roi,N_res,age_window)
% scan: 1 AP, 2 PA
% N_roi: number of ROIs
% N_res: number of modularity resolutions    
% N_window: age window number

    K=zeros(1,N_res);  % number of communities estimated by hierarchical Bayesian modelling
    K_ave=zeros(1,N_res);  % number of communities using group averaged FC
    label_res=cell(1,N_res); % a struct containing individual community labels
    res=0.9:0.1:2.5;  % modularity resolutions
    if scan==1
     
        for j=1:N_res
            load(['../results/','roi_',num2str(N_roi),'_1_','AP','/',num2str(res(j)),'/labels_AP.mat']); 
            K(j)=max(label_AP(:,age_window));
            load(['../results/','roi_',num2str(N_roi),'_1_','AP','/',num2str(res(j)),'/labels_AP_ave.mat']); 
            K_ave(j)=max(label_AP_ave(:,age_window));
        end
        
        for j=1:N_res
            label_res{j}=load(['../results/','roi_',num2str(N_roi),'_1_','AP','/',num2str(res(j)),'/grouplevel_data_AP.mat']);
        end
    else
        for j=1:N_res
            load(['../results/','roi_',num2str(N_roi),'_1_','PA','/',num2str(res(j)),'/labels_PA.mat']); 
            K(j)=max(label_PA(:,age_window));
            load(['../results/','roi_',num2str(N_roi),'_1_','PA','/',num2str(res(j)),'/labels_PA_ave.mat']); 
            K_ave(j)=max(label_PA_ave(:,age_window));
        end
        
        for j=1:N_res
            label_res{j}=load(['../results/','roi_',num2str(N_roi),'_1_','PA','/',num2str(res(j)),'/grouplevel_data_PA.mat']);

        end
    end
    K_indi=zeros(label_res{1,1}.count_subj(1,age_window),N_res); % number of communities of individual FC
    for j=1:N_res
        for i=1:label_res{1,1}.count_subj(1,age_window)
            K_indi(i,j)=max(label_res{1,j}.label{i,age_window});
        end
    end
end








