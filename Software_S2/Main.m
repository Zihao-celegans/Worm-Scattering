%% Software S2
%
% Source MATLAB scripts for the data analysis performed in the manuscript
% "Mechanisms of volume and surface light scattering from Caenorhabditis 
% elegans revealed by angle-resolved measurements"
% written by Zihao (John) Li and Christopher Fang-Yen (2025)
%
% Required MatLab Toolboxes: Curve Fitting Toolbox, Statistics and Machine 
% Learning Toolbox
% To install, go to HOME, click Add-Ons, then search the toolboxs you want
% to install.
% Please run this script session by session
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set parameters
clc
close all
clear

% Set directories, modify the following according to your device
% The main working directory should be set to the folder containing "Main.m"
main_work_dir = 'C:\Users\lizih\Dropbox\Publication\WormScatter\Supplement\Software_S2';
% The folder containing the raw data (Dataset S1)
f_dataset_S1 = 'C:\Users\lizih\Dropbox\Publication\WormScatter\Supplement\Dataset_S1';
% The folder containing the statistics spreadsheets (Table S1)
f_table_S1 = 'C:\Users\lizih\Dropbox\Publication\WormScatter\Supplement\Table_S1';


% Plot colors
red_color = [162, 20, 47] / 255;
green_color = [119, 172,  48] / 255;
blue_color = [0, 114, 189] / 255;

green_color_bright = [0, 230, 0] / 255;


gray_color = [0.7, 0.7, 0.7];
red_color_dim = gray_color * 0.5 + red_color * 0.5;
blue_color_dim = gray_color * 0.5 + blue_color * 0.5;


%% Read power meter data from files

% Read power meter data from the spreadsheet
f_power_data = append(f_dataset_S1, '\Power_Meter_data\Power_Meter_data.xlsx');

% radius of LED ring, unit: mm
radius_LED = 95 * 0.5;

% Read data for red
red_power_data = readtable(f_power_data, 'Sheet', 'Red');

% Correction for wavelength
red_power_ratio = 15.1 / 14.7;
red_power_data.Corrected_reading = red_power_data.Reading * red_power_ratio;

% Read data for green
green_power_data = readtable(f_power_data, 'Sheet', 'Green');

% Correction for wavelength
green_power_ratio = 12.2 / 11.6;
green_power_data.Corrected_reading = green_power_data.Reading * green_power_ratio;

% Read data for blue
blue_power_data = readtable(f_power_data, 'Sheet', 'Blue');

% Correction for wavelength
blue_power_ratio = 30 / 26.5;
blue_power_data.Corrected_reading = blue_power_data.Reading * blue_power_ratio;


%% Load data of pixel irradiance coefficient (PIC) unit: ADU*mm^2*sec^-1*µW^-1
f_PIC_data = append(f_dataset_S1, '\PIC\PIC.mat');
load(f_PIC_data);

%% Generation of Fig. 1C
% statistic file name
f_fig1c_stat = ...
    append(f_table_S1, '\Fig1C.xlsx');

% Scattering functions for Red, Seeded
f_red_seed_BF = ...
    append(f_dataset_S1, '\BF_seeded_RGB\Non_idx_mat\red\data.xlsx');

f_red_seed_fwrd = ...
    append(f_dataset_S1, '\DF_seeded_RGB\red\data.xlsx');

f_red_seed_bck = ...
    append(f_dataset_S1, '\Backscat_seeded_RGB\red\data.xlsx');

condition_str = 'seeded, non-idx matched';
[theta_red_seed, contrast_red_seed, WSFC_red_seed, BSFC_red_seed] = ...
    bulk_scatter_contrast_analysis( ...
    f_red_seed_BF, ...
    f_red_seed_fwrd, ...
    f_red_seed_bck, ...
    red_power_data, ...
    'red', ...
    PIC_red, ...
    Area_PM_sensor, ...
    condition_str ...
    );

% Save to statistic file
saveStat(WSFC_red_seed, theta_red_seed, f_fig1c_stat, 'worm_seeded', 'sfc');
saveStat(BSFC_red_seed, theta_red_seed, f_fig1c_stat, 'agar_seeded', 'sfc');

% Scattering functions for Red, Unseeded
f_red_unseed_BF = ...
    append(f_dataset_S1, '\BF_unseed_RGB\Non_idx_Mat\red\data.xlsx');

f_red_unseed_fwrd = ...
    append(f_dataset_S1, '\DF_unseed_RGB\red\data.xlsx');

f_red_unseed_bck = ...
    append(f_dataset_S1, '\Backscat_unseed_RGB\red\data.xlsx');

condition_str = 'unseeded, non-idx matched';
[theta_red_unseed, contrast_red_unseed, WSFC_red_unseed, BSFC_red_unseed] = ...
    bulk_scatter_contrast_analysis( ...
        f_red_unseed_BF, ...
        f_red_unseed_fwrd, ...
        f_red_unseed_bck, ...
        red_power_data, ...
        'red', ...
        PIC_red, ...
        Area_PM_sensor, ...
        condition_str ...
    );

% Save to statistic file
saveStat(WSFC_red_unseed, theta_red_unseed, f_fig1c_stat, 'worm_unseeded', 'sfc');
saveStat(BSFC_red_unseed, theta_red_unseed, f_fig1c_stat, 'agar_unseeded', 'sfc');

% Plot the scattering functions
close all; clc;
marker_size = 60;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 115;
text_x_offset = 7;
text_y = 10.^(3.5 - 0.4 * [0:3]);

figure;
hold on;

scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean,'o', ...
    'SizeData', marker_size, 'DisplayName', 'Worm, seeded', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Worm, seeded', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed), BSFC_red_seed.mean,'square', ...
    'SizeData', marker_size, 'DisplayName', 'Agar, seeded', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(2),'square', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(2), 'Agar, seeded', 'FontSize', font_size);


scatter(rad2deg(theta_red_unseed), WSFC_red_unseed.mean,'+', ...
    'SizeData', marker_size, 'DisplayName', 'Worm, unseeded', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(3),'+', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3), 'Worm, unseeded', 'FontSize', font_size);


scatter(rad2deg(theta_red_unseed), BSFC_red_unseed.mean, 'x', ...
    'SizeData', marker_size, 'DisplayName', 'Agar, unseeded', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(4), 'x', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(4), 'Agar, unseeded', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-2:4));
%title('Scattering functions (629 nm)');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% t-test for the trend of scattering functions for worm on seeded agar
disp('Under H0: scattering function at 0 degree =< 62 degree for worm on seeded plate, ')
ttest2_from_summary( ...
    WSFC_red_seed.mean(1), WSFC_red_seed.std(1), WSFC_red_seed.count(1), ...
    WSFC_red_seed.mean(18), WSFC_red_seed.std(18), WSFC_red_seed.count(18), ...
    'welch', 'right');

disp('Under H0: scattering function at 172 degree =< 128 degree for worm on seeded plate, ')
ttest2_from_summary( ...
    WSFC_red_seed.mean(end), WSFC_red_seed.std(end), WSFC_red_seed.count(end), ...
    WSFC_red_seed.mean(22), WSFC_red_seed.std(22), WSFC_red_seed.count(22), ...
    'welch', 'right');

% t-test for the trend of scattering functions for seeded agar
disp('Under H0: scattering function at 0 degree =< 62 degree for seeded agar, ')
ttest2_from_summary( ...
    BSFC_red_seed.mean(1), BSFC_red_seed.std(1), BSFC_red_seed.count(1), ...
    BSFC_red_seed.mean(18), BSFC_red_seed.std(18), BSFC_red_seed.count(18), ...
    'welch', 'right');

disp('Under H0: scattering function at 172 degree =< 128 degree for seeded agar, ')
ttest2_from_summary( ...
    BSFC_red_seed.mean(end), BSFC_red_seed.std(end), BSFC_red_seed.count(end), ...
    BSFC_red_seed.mean(22), BSFC_red_seed.std(22), BSFC_red_seed.count(22), ...
    'welch', 'right');

% t-test for the trend of scattering functions for worm on unseeded agar
disp('Under H0: scattering function at 0 degree =< 62 degree for worm on unseeded plate, ')
ttest2_from_summary( ...
    WSFC_red_unseed.mean(1), WSFC_red_unseed.std(1), WSFC_red_unseed.count(1), ...
    WSFC_red_unseed.mean(18), WSFC_red_unseed.std(18), WSFC_red_unseed.count(18), ...
    'welch', 'right');

disp('Under H0: scattering function at 172 degree =< 128 degree for worm on unseeded plate, ')
ttest2_from_summary( ...
    WSFC_red_unseed.mean(end), WSFC_red_unseed.std(end), WSFC_red_unseed.count(end), ...
    WSFC_red_unseed.mean(22), WSFC_red_unseed.std(22), WSFC_red_unseed.count(22), ...
    'welch', 'right');


% t-test for the trend of scattering functions for unseeded agar
disp('Under H0: scattering function at 0 degree =< 62 degree for unseeded agar, ')
ttest2_from_summary( ...
    BSFC_red_unseed.mean(1), BSFC_red_unseed.std(1), BSFC_red_unseed.count(1), ...
    BSFC_red_unseed.mean(18), BSFC_red_unseed.std(18), BSFC_red_unseed.count(18), ...
    'welch', 'right');

disp('Under H0: scattering function at 172 degree =< 128 degree for unseeded agar, ')
ttest2_from_summary( ...
    BSFC_red_unseed.mean(end), BSFC_red_unseed.std(end), BSFC_red_unseed.count(end), ...
    BSFC_red_unseed.mean(22), BSFC_red_unseed.std(22), BSFC_red_unseed.count(22), ...
    'welch', 'right');


%% Generation of Fig. 1D

% statistic file name
f_fig1d_stat = ...
    append(f_table_S1, '\Fig1D.xlsx');

close all; clc;
marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 85;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:1]);

figure;
hold on;


errorbar(rad2deg(theta_red_seed), contrast_red_seed.mean, contrast_red_seed.sem, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.07, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), 'Worm on seeded agar', 'FontSize', font_size);


errorbar(rad2deg(theta_red_unseed), contrast_red_unseed.mean, contrast_red_unseed.sem, ...
    'Marker', 'v', 'MarkerEdgeColor', 'k', 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', 'k');
errorbar(x_icon, text_y(2), 0.07, ...
    'Marker', 'v', 'MarkerEdgeColor', 'k', 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', 'k');
text(x_icon + text_x_offset, text_y(2), 'Worm on unseeded agar', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(-1:0.2:1);
%title('Image contrast (629 nm)');
ylim([-1 1])
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% Save to statistic file
saveStat(contrast_red_seed, theta_red_seed, f_fig1d_stat, 'worm_on_seeded_agar', 'ctrst');
saveStat(contrast_red_unseed, theta_red_unseed, f_fig1d_stat, 'worm_on_unseeded_agar', 'ctrst');

% Test whether contrast index positive or negative for seeded plate at 0 degree
disp('Under H0: contrast => 0 for seeded plate at 0 degree,')
ttest1_from_summary( ...
                contrast_red_seed.mean(1), contrast_red_seed.std(1), contrast_red_seed.count(1), ...
                0, 'left');

% Test whether contrast index positive or negative for unseeded plate at 0 degree
disp('Under H0: contrast => 0 for unseeded plate at 0 degree,')
ttest1_from_summary( ...
                contrast_red_unseed.mean(1), contrast_red_unseed.std(1), contrast_red_unseed.count(1), ...
                0, 'left');

% Test whether contrast index positive or negative for seeded plate at 172 degree
disp('Under H0: contrast => 0 for seeded plate at 172 degree,')
ttest1_from_summary( ...
                contrast_red_seed.mean(end), contrast_red_seed.std(end), contrast_red_seed.count(end), ...
                0, 'left');


% t-test for the trend of scattering functions for worm on seeded agar from
% 0 - 12 degree
disp('Under H0: scattering function at 12 degree =< 0 degree for worm on seeded plate, ')
ttest2_from_summary( ...
    contrast_red_seed.mean(7), contrast_red_seed.std(7), contrast_red_seed.count(7), ...
    contrast_red_seed.mean(1), contrast_red_seed.std(1), contrast_red_seed.count(1), ...
    'welch', 'right');

% t-test for the trend of scattering functions for worm on unseeded agar from
% 0 - 12 degree
disp('Under H0: scattering function at 12 degree =< 0 degree for worm on unseeded plate, ')
ttest2_from_summary( ...
    contrast_red_unseed.mean(7), contrast_red_unseed.std(7), contrast_red_unseed.count(7), ...
    contrast_red_unseed.mean(1), contrast_red_unseed.std(1), contrast_red_unseed.count(1), ...
    'welch', 'right');


%% Generation of Fig. 1E

% statistic file name
f_fig1e_stat = ...
    append(f_table_S1, '\Fig1E.xlsx');

% Scattering functions for Green, Seeded
f_green_seed_BF = ...
    append(f_dataset_S1, '\BF_seeded_RGB\Non_idx_mat\green\data.xlsx');

f_green_seed_fwrd = ...
    append(f_dataset_S1, '\DF_seeded_RGB\green\data.xlsx');

f_green_seed_bck = ...
    append(f_dataset_S1, '\Backscat_seeded_RGB\green\data.xlsx');

condition_str = 'seeded, non-idx matched';

[theta_green_seed, contrast_green_seed, WSFC_green_seed, BSFC_green_seed] = ...
bulk_scatter_contrast_analysis( ...
    f_green_seed_BF, ...
    f_green_seed_fwrd, ...
    f_green_seed_bck, ...
    green_power_data, ...    
    'green', ...             
    PIC_green, ...           
    Area_PM_sensor, ...
    condition_str ...
);


% Scattering functions for Blue, Seeded

f_blue_seed_BF = ...
    append(f_dataset_S1, '\BF_seeded_RGB\Non_idx_mat\blue\data.xlsx');

f_blue_seed_fwrd = ...
    append(f_dataset_S1, '\DF_seeded_RGB\blue\data.xlsx');

f_blue_seed_bck = ...
    append(f_dataset_S1, '\Backscat_seeded_RGB\blue\data.xlsx');

condition_str = 'seeded, non-idx matched';

[theta_blue_seed, contrast_blue_seed, WSFC_blue_seed, BSFC_blue_seed] = ...
bulk_scatter_contrast_analysis( ...
    f_blue_seed_BF, ...
    f_blue_seed_fwrd, ...
    f_blue_seed_bck, ...
    blue_power_data, ...    
    'blue', ...             
    PIC_blue, ...           
    Area_PM_sensor, ...
    condition_str ...
);


% t-test at 0 degree
disp("Under H0: red =< green for worm scattering function at 0 degree,")
ttest2_from_summary( ...
    WSFC_red_seed.mean(1), WSFC_red_seed.std(1), WSFC_red_seed.count(1), ...
    WSFC_green_seed.mean(1), WSFC_green_seed.std(1), WSFC_green_seed.count(1), ...
    'welch', 'right');

disp("Under H0: green =< blue for worm scattering function at 0 degree,")
ttest2_from_summary( ...
    WSFC_green_seed.mean(1), WSFC_green_seed.std(1), WSFC_green_seed.count(1), ...
    WSFC_blue_seed.mean(1), WSFC_blue_seed.std(1), WSFC_blue_seed.count(1), ...
    'welch', 'right');

% Save to statistic file
saveStat(WSFC_red_seed, theta_red_seed, f_fig1e_stat, 'worm_629nm', 'sfc');
saveStat(BSFC_red_seed, theta_red_seed, f_fig1e_stat, 'seeded_agar_629nm', 'sfc');
saveStat(WSFC_green_seed, theta_green_seed, f_fig1e_stat, 'worm_516nm', 'sfc');
saveStat(BSFC_green_seed, theta_green_seed, f_fig1e_stat, 'seeded_agar_516nm', 'sfc');
saveStat(WSFC_blue_seed, theta_blue_seed, f_fig1e_stat, 'worm_447nm', 'sfc');
saveStat(BSFC_blue_seed, theta_blue_seed, f_fig1e_stat, 'seeded_agar_447nm', 'sfc');


% Plot scattering functions for RGB, Seeded
close all; clc;
marker_size = 40;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 95;
text_x_offset = 7;
text_y = 10.^(2.8 - 0.4 * [0:5]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'o';

red_bg_mrk = 'square';
green_bg_mrk = '*';
blue_bg_mrk = '>';


figure;
hold on;

% bg, green

green_bg_color = [0, 230, 0] / 255;
scatter(rad2deg(theta_green_seed), BSFC_green_seed.mean, green_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Seeded agar, 516 nm', ...
    'MarkerEdgeColor', green_bg_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(5), green_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_color_bright, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(5), ...
    'Seeded agar, 516 nm', ...
    'FontSize', font_size);


% worm, red
scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean, red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 629 nm', ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(1), red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), ...
    'Worm, 629 nm', ...
    'FontSize', font_size);


% worm, blue
scatter(rad2deg(theta_blue_seed), WSFC_blue_seed.mean, blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 447 nm', ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(3), blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(3), ...
    'Worm, 447 nm', ...
    'FontSize', font_size);

% worm, green

scatter(rad2deg(theta_green_seed), WSFC_green_seed.mean, green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Worm, 516 nm', ...
    'MarkerEdgeColor', green_color_bright, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(2), green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_color_bright, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(2), ...
    'Worm, 516 nm', ...
    'FontSize', font_size);

% bg, red

scatter(rad2deg(theta_red_seed), BSFC_red_seed.mean, red_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Seeded agar, 629 nm', ...
    'MarkerEdgeColor', red_color_dim, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(4), red_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', red_color_dim, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(4), ...
    'Seeded agar, 629 nm', ...
    'FontSize', font_size);


% bg, blue
scatter(rad2deg(theta_blue_seed), BSFC_blue_seed.mean, blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Seeded agar, 447 nm', ...
    'MarkerEdgeColor', blue_color_dim, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(6), blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', blue_color_dim, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(6), ...
    'Seeded agar, 447 nm', ...
    'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-2:3));
%title('\lambda-dependent scattering functions');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

%% Generation of Fig. 1F

% statistic file name
f_fig1f_stat = ...
    append(f_table_S1, '\Fig1F.xlsx');

close all; clc;

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;


x_icon = 140;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:2]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'v';

figure;
hold on;

errorbar(rad2deg(theta_red_seed), contrast_red_seed.mean, contrast_red_seed.sem, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.07, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), '629 nm', 'FontSize', font_size);


errorbar(rad2deg(theta_blue_seed), contrast_blue_seed.mean, contrast_blue_seed.sem, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
errorbar(x_icon, text_y(3), 0.07, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
text(x_icon + text_x_offset, text_y(3), '447 nm', 'FontSize', font_size);


errorbar(rad2deg(theta_green_seed), contrast_green_seed.mean, contrast_green_seed.sem, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
errorbar(x_icon, text_y(2), 0.07, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);

text(x_icon + text_x_offset, text_y(2), '516 nm', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(-1:0.2:1);
ylim([-1 1])
%title('\lambda-dependent image contrast');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test at peak contrast indices
[~, idx_max_red] = max(contrast_red_seed.mean);
[~, idx_max_green] = max(contrast_green_seed.mean);
[~, idx_max_blue] = max(contrast_blue_seed.mean);

disp("Under H0: red =< green for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_seed.mean(idx_max_red), contrast_red_seed.std(idx_max_red), contrast_red_seed.count(idx_max_red), ...
    contrast_green_seed.mean(idx_max_green), contrast_green_seed.std(idx_max_green), contrast_green_seed.count(idx_max_green), ...
    'welch', 'right');

disp("Under H0: green =< blue for peak contrast indices,")
ttest2_from_summary( ...
    contrast_green_seed.mean(idx_max_green), contrast_green_seed.std(idx_max_green), contrast_green_seed.count(idx_max_green), ...
    contrast_blue_seed.mean(idx_max_blue), contrast_blue_seed.std(idx_max_blue), contrast_blue_seed.count(idx_max_blue), ...
    'welch', 'right');

% Save to statistic file
saveStat(contrast_red_seed, theta_red_seed, f_fig1f_stat, '629nm', 'ctrst');
saveStat(contrast_green_seed, theta_green_seed, f_fig1f_stat, '516nm', 'ctrst');
saveStat(contrast_blue_seed, theta_blue_seed, f_fig1f_stat, '447nm', 'ctrst');


%% Generation of Fig. 2C

close all; clc;

% statistic file name
f_fig2c_stat = ...
    append(f_table_S1, '\Fig2C.xlsx');

% Scattering functinos for Red, seeded, idxMat

f_red_seed_idxMat_BF = ...
    append(f_dataset_S1, '\BF_seeded_RGB\idx_mat\red_idxMat\data.xlsx');

f_red_seed_idxMat_fwrd = ...
    append(f_dataset_S1, '\DF_seeded_idx_mat_RGB\red\data.xlsx');

f_red_seed_idxMat_bck = ...
    append(f_dataset_S1, '\Backscat_seeded_idx_mat_RGB\red\data.xlsx');

condition_str = 'seeded, idx matched';
[theta_red_seed_idxMat, contrast_red_seed_idxMat, WSFC_red_seed_idxMat, BSFC_red_seed_idxMat] = ...
    bulk_scatter_contrast_analysis( ...
        f_red_seed_idxMat_BF, ...
        f_red_seed_idxMat_fwrd, ...
        f_red_seed_idxMat_bck, ...
        red_power_data, ...
        'red', ...
        PIC_red, ...
        Area_PM_sensor, ...
        condition_str ...
    );


% t-test at 0 degree
disp("Under H0: IM =< non-IM for worm scattering function at 0 degree,")
ttest2_from_summary( ...
    WSFC_red_seed_idxMat.mean(1), WSFC_red_seed_idxMat.std(1), WSFC_red_seed_idxMat.count(1), ...
    WSFC_red_seed.mean(1), WSFC_red_seed.std(1), WSFC_red_seed.count(1), ...
    'welch', 'right');

disp("Under H0: IM =< non-IM for seeded agar scattering function at 0 degree,")
ttest2_from_summary( ...
    BSFC_red_seed_idxMat.mean(1), BSFC_red_seed_idxMat.std(1), BSFC_red_seed_idxMat.count(1), ...
    BSFC_red_seed.mean(1), BSFC_red_seed.std(1), BSFC_red_seed.count(1), ...
    'welch', 'right');


% Save to statistic file
saveStat(WSFC_red_seed, theta_red_seed, f_fig2c_stat, 'worm_non_IM', 'sfc');
saveStat(BSFC_red_seed, theta_red_seed, f_fig2c_stat, 'seeded_agar_non_IM', 'sfc');
saveStat(WSFC_red_seed_idxMat, theta_red_seed_idxMat, f_fig2c_stat, 'worm_IM', 'sfc');
saveStat(BSFC_red_seed_idxMat, theta_red_seed_idxMat, f_fig2c_stat, 'seeded_agar_IM', 'sfc');


% plot the Scattering functions
marker_size = 60;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 100;
text_x_offset = 7;
text_y = 10.^(3.5 - 0.4 * [0:3]);

figure;
hold on;

scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean,'o', ...
    'SizeData', marker_size, 'DisplayName', 'Worm, non-idx matched', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Worm, non-IM', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed), BSFC_red_seed.mean, 's', ...
    'SizeData', marker_size, 'DisplayName', 'Seeded agar, non-idx matched', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(2),'s', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(2), 'Seeded agar, non-IM', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed_idxMat), WSFC_red_seed_idxMat.mean,'+', ...
    'SizeData', marker_size, 'DisplayName', 'Worm, idx matched', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(3),'+', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3), 'Worm, IM', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed_idxMat), BSFC_red_seed_idxMat.mean,'x', ...
    'SizeData', marker_size, 'DisplayName', 'Seeded agar, idx matched', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(4),'x', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(4), 'Seeded agar, IM', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-2:4));
%title('Scat. func. from idx-match experiment');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


%% Generation of Fig. 2D

% statistic file name
f_fig2d_stat = ...
    append(f_table_S1, '\Fig2D.xlsx');


close all; clc;
figure;
hold on;

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 150;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:1]);

errorbar(rad2deg(theta_red_seed), contrast_red_seed.mean, contrast_red_seed.sem, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.07, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), 'Non-IM', 'FontSize', font_size);

errorbar(rad2deg(theta_red_seed_idxMat), contrast_red_seed_idxMat.mean, contrast_red_seed_idxMat.sem, ...
    'Marker', 'v', 'MarkerEdgeColor', 'k', 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', 'k');
errorbar(x_icon, text_y(2), 0.07, ...
    'Marker', 'v', 'MarkerEdgeColor', 'k', 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', 'k');
text(x_icon + text_x_offset, text_y(2), 'IM', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(-1:0.2:1);
%title('Img contrast from idx-match experiment');
ylim([-1 1])
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test at 0 degree
disp("Under H0: IM = non-IM for contrast indices at 0 degree,")
ttest2_from_summary( ...
    contrast_red_seed.mean(1), contrast_red_seed.std(1), contrast_red_seed.count(1), ...
    contrast_red_seed_idxMat.mean(1), contrast_red_seed_idxMat.std(1), contrast_red_seed_idxMat.count(1), ...
    'welch', 'both');

% t-test at peak contrast indicies
[~, idx_max_nonIM] = max(contrast_red_seed.mean);
[~, idx_max_IM] = max(contrast_red_seed_idxMat.mean);
disp("Under H0: non-IM =< IM for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_seed.mean(idx_max_nonIM), contrast_red_seed.std(idx_max_nonIM), contrast_red_seed.count(idx_max_nonIM), ...
    contrast_red_seed_idxMat.mean(idx_max_IM), contrast_red_seed_idxMat.std(idx_max_IM), contrast_red_seed_idxMat.count(idx_max_IM), ...
    'welch', 'right');

% Save to statistic file
saveStat(contrast_red_seed, theta_red_seed, f_fig2d_stat, 'non_IM', 'ctrst');
saveStat(contrast_red_seed_idxMat, theta_red_seed_idxMat, f_fig2d_stat, 'IM', 'ctrst');

%% Generation of Fig. 2E

% statistic file name
f_fig2e_stat = ...
    append(f_table_S1, '\Fig2E.xlsx');

% Read the Zemax optical simulation data
N_sim = 10;
f_offline_zmx_data = append(f_dataset_S1, '\Zemax\WSFC_zemax_N_10.mat');
load(f_offline_zmx_data);

% index matched, volume scattering only
mean_theta_zemax_idxMat_N = mean(theta_zemax_idxMat_N, 1);
mean_WSFC_zemax_idxMat_N  = mean(WSFC_zemax_idxMat_N,  1);
std_WSFC_zemax_idxMat_N   = std(WSFC_zemax_idxMat_N, 0, 1);

WSFC_zemax_idxMat.mean = mean_WSFC_zemax_idxMat_N';
WSFC_zemax_idxMat.std = std_WSFC_zemax_idxMat_N';
WSFC_zemax_idxMat.sem = WSFC_zemax_idxMat.std/sqrt(N_sim);
WSFC_zemax_idxMat.count = repmat(N_sim, size(mean_WSFC_zemax_idxMat_N, 2), 1);

% surface scattering only
mean_theta_zemax_ext_N = mean(theta_zemax_ext_N, 1);
mean_WSFC_zemax_ext_N = mean(WSFC_zemax_ext_N, 1);
std_WSFC_zemax_ext_N = std(WSFC_zemax_ext_N, 0, 1);

WSFC_zemax_ext.mean = mean_WSFC_zemax_ext_N';
WSFC_zemax_ext.std = std_WSFC_zemax_ext_N';
WSFC_zemax_ext.sem = WSFC_zemax_ext.std/sqrt(N_sim);
WSFC_zemax_ext.count = repmat(N_sim, size(mean_WSFC_zemax_ext_N, 2), 1);

% full scattering
mean_theta_zemax_full_N = mean(theta_zemax_full_N, 1);
mean_WSFC_zemax_full_N = mean(WSFC_zemax_full_N, 1);
std_WSFC_zemax_full_N = std(WSFC_zemax_full_N, 0, 1);

WSFC_zemax_full.mean = mean_WSFC_zemax_full_N';
WSFC_zemax_full.std = std_WSFC_zemax_full_N';
WSFC_zemax_full.sem = WSFC_zemax_full.std/sqrt(N_sim);
WSFC_zemax_full.count = repmat(N_sim, size(mean_WSFC_zemax_full_N, 2), 1);

% plot the scattering functions

close all; clc;
marker_size = 40;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 55;
text_x_offset = 12;
text_y = 10.^(3 - 0.45 * [0:4]);

figure;
hold on;

errorbar(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N, WSFC_zemax_idxMat.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(4), 5.5^(3.9/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-10 x_icon+10], [text_y(4)-1 text_y(4)-1],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(4)-1, 'Model, IM', 'FontSize', font_size);


errorbar(mean_theta_zemax_full_N,mean_WSFC_zemax_full_N, WSFC_zemax_full.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
errorbar(x_icon, text_y(2), 40^(3.2/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
line([x_icon-10 x_icon+10], [text_y(2)-5 text_y(2)-5],...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
text(x_icon + text_x_offset, text_y(2)-5, 'Model, non-IM', 'FontSize', font_size);

% Model IM + Experiment seeded agar IM
mean_WSFC_zemax_idxMat_N_interp = interp1(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N, rad2deg(theta_red_seed_idxMat), 'linear');
sum = BSFC_red_seed_idxMat.mean + mean_WSFC_zemax_idxMat_N_interp;

scatter(rad2deg(theta_red_seed_idxMat), sum,'^', ...
    'SizeData', marker_size, 'MarkerEdgeColor', "magenta", 'LineWidth', Line_Width)
scatter(x_icon, text_y(5),'^', ...
    'SizeData', marker_size, 'MarkerEdgeColor', "magenta", 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(5), 'Model + seeded agar, IM', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean,'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Experiment, non-IM', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed_idxMat), WSFC_red_seed_idxMat.mean,'+', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(3)-2,'+', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3)-2, 'Experiment, IM', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:3));
ylim(10.^[-3 3.5])
% title('Scat. func. of worm (Exp. vs. Model)');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test at 0 degree
disp("Under H0: IM =< non-IM for simulated worm scattering function at 0 degree,")
ttest2_from_summary( ...
    WSFC_zemax_idxMat.mean(1), WSFC_zemax_idxMat.std(1), WSFC_zemax_idxMat.count(1), ...
    WSFC_zemax_full.mean(1), WSFC_zemax_full.std(1), WSFC_zemax_full.count(1), ...
    'welch', 'right');


% t-test at 180 degree
disp("Under H0: IM =< non-IM for simulated worm scattering function at 180 degree,")
ttest2_from_summary( ...
    WSFC_zemax_idxMat.mean(end), WSFC_zemax_idxMat.std(end), WSFC_zemax_idxMat.count(end), ...
    WSFC_zemax_full.mean(end), WSFC_zemax_full.std(end), WSFC_zemax_full.count(end), ...
    'welch', 'right');


% t-test for the trend of scattering functions for non-IM model
disp('Under H0: scattering function at 0 degree =< 65 degree for non-IM model, ')
ttest2_from_summary( ...
    WSFC_zemax_full.mean(1), WSFC_zemax_full.std(1), WSFC_zemax_full.count(1), ...
    WSFC_zemax_full.mean(14), WSFC_zemax_full.std(14), WSFC_zemax_full.count(14), ...
    'welch', 'right');

disp('Under H0: scattering function at 180 degree =< 150 degree for non-IM model, ')
ttest2_from_summary( ...
    WSFC_zemax_full.mean(end), WSFC_zemax_full.std(end), WSFC_zemax_full.count(end), ...
    WSFC_zemax_full.mean(31), WSFC_zemax_full.std(31), WSFC_zemax_full.count(31), ...
    'welch', 'right');


% t-test for the trend of scattering functions for IM model
disp('Under H0: scattering function at 0 degree =< 65 degree for IM model, ')
ttest2_from_summary( ...
    WSFC_zemax_idxMat.mean(1), WSFC_zemax_idxMat.std(1), WSFC_zemax_idxMat.count(1), ...
    WSFC_zemax_idxMat.mean(14), WSFC_zemax_idxMat.std(14), WSFC_zemax_idxMat.count(14), ...
    'welch', 'right');

disp('Under H0: scattering function at 180 degree =< 150 degree for IM model, ')
ttest2_from_summary( ...
    WSFC_zemax_idxMat.mean(end), WSFC_zemax_idxMat.std(end), WSFC_zemax_idxMat.count(end), ...
    WSFC_zemax_idxMat.mean(31), WSFC_zemax_idxMat.std(31), WSFC_zemax_idxMat.count(31), ...
    'welch', 'right');


% save to stats file
saveStat(WSFC_red_seed, theta_red_seed, f_fig2e_stat, 'experiment_non_IM', 'sfc');
saveStat(WSFC_zemax_full, deg2rad(mean_theta_zemax_full_N'), f_fig2e_stat, 'model_non_IM', 'sfc');
saveStat(WSFC_red_seed_idxMat, theta_red_seed_idxMat, f_fig2e_stat, 'experiment_IM', 'sfc');
saveStat(WSFC_zemax_idxMat, deg2rad(mean_theta_zemax_idxMat_N'), f_fig2e_stat, 'model_IM', 'sfc');

%% Generation of Fig. 2F

% statistic file name
f_fig2f_stat = ...
    append(f_table_S1, '\Fig2F.xlsx');

close all; clc;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 85;
text_x_offset = 12;
text_y = 10.^(3 - 0.45 * [0:3]);

figure;
hold on;

errorbar(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N, WSFC_zemax_idxMat.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(2), 40^(3.2/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-10 x_icon+10], [text_y(2)-5 text_y(2)-5],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(2)-5, 'Volume scat. (VS)', 'FontSize', font_size);


errorbar(mean_theta_zemax_full_N,mean_WSFC_zemax_full_N, WSFC_zemax_full.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
errorbar(x_icon, text_y(1), 120^(3/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
line([x_icon-10 x_icon+10], [text_y(1) text_y(1)]-25,...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
text(x_icon + text_x_offset, text_y(1)-25, 'Complete scat.', 'FontSize', font_size);


errorbar(mean_theta_zemax_ext_N,mean_WSFC_zemax_ext_N,WSFC_zemax_ext.sem',...
    'LineWidth', Line_Width, 'Color', [0.9 0.2 0]);
errorbar(x_icon, text_y(3), 15^(3.4/2.5),...
    'LineWidth', Line_Width, 'Color', [0.9 0.2 0]);
line([x_icon-10 x_icon+10], [text_y(3)-2 text_y(3)-2],...
    'LineWidth', Line_Width, 'Color', [0.9 0.2 0]);
text(x_icon + text_x_offset, text_y(3)-2, 'Surface scat. (SS)', 'FontSize', font_size);


brightness = 0.5;
plot(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N + mean_WSFC_zemax_ext_N, '--o', ...
    'MarkerSize', 7, 'Color', brightness * ones(1, 3), 'LineWidth', Line_Width);
plot([x_icon-10 x_icon+10], [text_y(4)-1 text_y(4)-1], '--',...
    'Color', brightness * ones(1, 3), 'LineWidth', Line_Width);
scatter(x_icon, text_y(4)-1, 'o', 'SizeData', 50, ...
    'MarkerEdgeColor', brightness * ones(1, 3), 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(4)-1, 'VS + SS', 'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:3));
ylim(10.^[-3 3.5])
% title('Interplay between vol. & surf. scattering');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test for surface and full scattering
angles_to_test = 5:5:45;
idx_to_test = angles_to_test/5 + 1;
for idx = idx_to_test
    fprintf('Under H0: surface scat. =< complete scat. at %d degree, ', (idx-1)*5)
    ttest2_from_summary( ...
                    WSFC_zemax_ext.mean(idx), WSFC_zemax_ext.std(idx), WSFC_zemax_ext.count(idx), ...
                    WSFC_zemax_full.mean(idx), WSFC_zemax_full.std(idx), WSFC_zemax_full.count(idx), ...
                    'welch', 'right');
end

% t-test for full and volume scattering
for idx = idx_to_test
    fprintf('Under H0: full scat. =< volume scat. at %d degree, ', (idx-1)*5)
    ttest2_from_summary( ...
                    WSFC_zemax_full.mean(idx), WSFC_zemax_full.std(idx), WSFC_zemax_full.count(idx), ...
                    WSFC_zemax_idxMat.mean(idx), WSFC_zemax_idxMat.std(idx), WSFC_zemax_idxMat.count(idx), ...
                    'welch', 'right');
end


% t-test for surface and volume scattering from 0 to 50 deg
angles_to_test = 0:5:50;
idx_to_test = angles_to_test/5 + 1;
for idx = idx_to_test
    fprintf('Under H0: surface scat. =< volume scat. at %d degree, ', (idx-1)*5)
    ttest2_from_summary( ...
                    WSFC_zemax_ext.mean(idx), WSFC_zemax_ext.std(idx), WSFC_zemax_ext.count(idx), ...
                    WSFC_zemax_idxMat.mean(idx), WSFC_zemax_idxMat.std(idx), WSFC_zemax_idxMat.count(idx), ...
                    'welch', 'right');
end

% t-test for surface and volume scattering from 55 to 85 deg
angles_to_test = 55:5:85;
idx_to_test = angles_to_test/5 + 1;
for idx = idx_to_test
    fprintf('Under H0: surface scat. => volume scat. at %d degree, ', (idx-1)*5)
    ttest2_from_summary( ...
                    WSFC_zemax_ext.mean(idx), WSFC_zemax_ext.std(idx), WSFC_zemax_ext.count(idx), ...
                    WSFC_zemax_idxMat.mean(idx), WSFC_zemax_idxMat.std(idx), WSFC_zemax_idxMat.count(idx), ...
                    'welch', 'left');
end


% t-test for surface and volume scattering from 115 to 175 deg
angles_to_test = 115:5:175;
idx_to_test = angles_to_test/5 + 1;
for idx = idx_to_test
    fprintf('Under H0: surface scat. =< volume scat. at %d degree, ', (idx-1)*5)
    ttest2_from_summary( ...
                    WSFC_zemax_ext.mean(idx), WSFC_zemax_ext.std(idx), WSFC_zemax_ext.count(idx), ...
                    WSFC_zemax_idxMat.mean(idx), WSFC_zemax_idxMat.std(idx), WSFC_zemax_idxMat.count(idx), ...
                    'welch', 'right');
end

% save to stats file
saveStat(WSFC_zemax_full, deg2rad(mean_theta_zemax_full_N'), f_fig2f_stat, 'complete_scat', 'sfc');
saveStat(WSFC_zemax_idxMat, deg2rad(mean_theta_zemax_idxMat_N'), f_fig2f_stat, 'volume_scat', 'sfc');
saveStat(WSFC_zemax_ext, deg2rad(mean_theta_zemax_ext_N'), f_fig2f_stat, 'surface_scat', 'sfc');

%% Generation of Fig. 3B

% Read the spatial data for the non-index matching
f_spatial_data = append(f_dataset_S1, '\Spatial_distribution\Spatial_nonIdxMat.mat');
load(f_spatial_data);

f_stat_repProfile_Zemax = append(f_dataset_S1, '\Spatial_distribution\stat_repProfile_Zemax_N_nonIdxMat.mat');
load(f_stat_repProfile_Zemax);

% Hardcoded params for dimension conversion
% Experiment
Mag_exp = 179.85075 * 2.2 * 10^(-3) / 1;
pix_size_exp = 2.2; % Unit: μm

% Zemax
Mag_zemax = 142.37/400;
pix_size_zemax = 0.44 * 1000 / 200; % Unit: μm


% plot the representative profiles
close all; clc;
x_ax_micron_exp = (1:size(rep_profiles,2)) * (pix_size_exp/Mag_exp); % Unit: μm
x_ax_micron_exp = x_ax_micron_exp - mean(x_ax_micron_exp);

rep_rnds_zemax = 1;
x_ax_micron_zemax = (1:size(repProfile_Zemax_N{rep_rnds_zemax},2)) * (pix_size_zemax / Mag_zemax);
x_ax_micron_zemax = x_ax_micron_zemax - mean(x_ax_micron_zemax);


Line_Width = 5;
font_size = 30;
tick_len = 0.02;



for i = 1:numel(rep_theta)

    figure;
    hold on;
    plot(x_ax_micron_exp, rep_profiles(i, :), 'color', red_color, 'LineWidth', Line_Width);
    errorbar(x_ax_micron_zemax, mean_repProfile_Zemax_N(:, i), sem_repProfile_Zemax_N(:, i), '--k', ...
        'LineWidth', 2, 'CapSize', 12);

    xticks([-150 0 150]);
    xlim([-150 150])
    yticks([0 1]);
    ylim([0 1])
    pbaspect([1.2 1 1])
    ax = gca;
    ax.FontSize = font_size;
    ax.TickLength = [tick_len, 0];
    hold off;
end

%% Generation of Fig. 3D

% Read the spatial data for index matching
f_spatial_data_idxMat = append(f_dataset_S1, '\Spatial_distribution\Spatial_idxMat.mat');
load(f_spatial_data_idxMat);

f_stat_repProfile_Zemax_idxMat = append(f_dataset_S1, '\Spatial_distribution\stat_repProfile_Zemax_N_idxMat.mat');
load(f_stat_repProfile_Zemax_idxMat);


% Hardcoded params for dimension conversion
% Experiment
Mag_exp = 179.85075 * 2.2 * 10^(-3) / 1;
pix_size_exp = 2.2; % Unit: μm

% Zemax
Mag_zemax = 142.37/400;
pix_size_zemax = 0.44 * 1000 / 200; % Unit: μm


% plot the representative profiles
close all; clc;
x_ax_micron_exp_idxMat = (1:size(rep_profiles_idxMat,2)) * (pix_size_exp/Mag_exp); % Unit: μm
x_ax_micron_exp_idxMat = x_ax_micron_exp_idxMat - mean(x_ax_micron_exp_idxMat);

rep_rnds_zemax_idxMat = 1;
x_ax_micron_zemax_idxMat = (1:size(repProfile_Zemax_N_idxMat{rep_rnds_zemax_idxMat},2)) * (pix_size_zemax / Mag_zemax);
x_ax_micron_zemax_idxMat = x_ax_micron_zemax_idxMat - mean(x_ax_micron_zemax_idxMat);

Line_Width = 5;
font_size = 30;
tick_len = 0.02;


for i = 1:numel(rep_theta_idxMat)
    figure;
    hold on;
    plot(x_ax_micron_exp_idxMat, rep_profiles_idxMat(i, :), 'color', red_color, 'LineWidth', Line_Width);
    errorbar(x_ax_micron_zemax_idxMat, mean_repProfile_Zemax_N_idxMat(:, i), sem_repProfile_Zemax_N_idxMat(:, i), '--k', ...
        'LineWidth', 2, 'CapSize', 12);

    xticks([-150 0 150]);
    xlim([-150 150])
    yticks([0 1]);
    ylim([0 1])
    pbaspect([1.2 1 1])
    ax = gca;
    ax.FontSize = font_size;
    ax.TickLength = [tick_len, 0];
    hold off;
end


%% Generation of Fig. 3E

close all; clc;

% Read EMCI data for 2 more trials
f_shapeIdx_exp_nonIM_2 = append(f_dataset_S1, ['\Spatial_distribution\' ...
    'shapeIdx_exp_nonIdxMat_2.mat']);
EMCI_exp_nonIM_2 = matfile(f_shapeIdx_exp_nonIM_2).shapeIdx_exp_2;

f_shapeIdx_exp_nonIM_3 = append(f_dataset_S1, ['\Spatial_distribution\' ...
    'shapeIdx_exp_nonIdxMat_3.mat']);
EMCI_exp_nonIM_3 = matfile(f_shapeIdx_exp_nonIM_3).shapeIdx_exp_3;

EMCI_exp_nonIM_N = [shapeIdx_exp; EMCI_exp_nonIM_2; EMCI_exp_nonIM_3];

% Compute mean and SEM for experimental and simulated EMCI

mean_EMCI_exp_nonIM_N = mean(EMCI_exp_nonIM_N, 1);
std_EMCI_exp_nonIM_N = std(EMCI_exp_nonIM_N, 0, 1);
sem_EMCI_exp_nonIM_N = std_EMCI_exp_nonIM_N./sqrt(size(EMCI_exp_nonIM_N, 1));

mean_theta_xsec_Zemax_N = mean(theta_xsec_Zemax_N, 1);
mean_shapeIdx_Zemax_N = mean(shapeIdx_Zemax_N, 1);
sem_shapeIdx_Zemax_N = std(shapeIdx_Zemax_N, 0, 1)./sqrt(size(shapeIdx_Zemax_N, 1));

% generate the plot
marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 80;
text_x_offset = 15;
text_y = (0.9 - 0.15 * [0:1]);

figure;
hold on

errorbar(theta_xsec_exp, mean_EMCI_exp_nonIM_N, sem_EMCI_exp_nonIM_N, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.05, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size, ...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), 'Experiment, non-IM', 'FontSize', font_size);


errorbar(mean_theta_xsec_Zemax_N, mean_shapeIdx_Zemax_N, sem_shapeIdx_Zemax_N, ...
    '--k', 'LineWidth', Line_Width);
errorbar(x_icon, text_y(2), 0.05, ...
    '--k', 'LineWidth', Line_Width);
plot([x_icon-10 x_icon+10] , [text_y(2) text_y(2)], ...
    '--k', 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(2), 'Model, non-IM', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('EMCI', 'FontWeight', 'bold');
ylim([-0.5 1]);
yticks(-0.5:0.25:1);
% title('EMCI for non-idx matching')
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test for positive or negative for different angle ranges

N_angles = size(mean_EMCI_exp_nonIM_N, 2);

idx_end_1 = 2;

idx_start_2 = 7;
idx_end_2 = 31;

idx_start_3 = 33;

for idx = 1:idx_end_1
    fprintf('Under H0: EMCI =< 0 for experiment at %.2f degree, ', theta_xsec_exp(idx))
    ttest1_from_summary( ...
                    mean_EMCI_exp_nonIM_N(idx), std_EMCI_exp_nonIM_N(idx), 3, ...
                    0, 'right');

end

ps = [];
for idx = idx_start_2 : idx_end_2
    fprintf('Under H0: EMCI => 0 for experiment at %.2f degree, ', theta_xsec_exp(idx))
    [~,~,p] = ttest1_from_summary( ...
        mean_EMCI_exp_nonIM_N(idx), std_EMCI_exp_nonIM_N(idx), 3, ...
                    0, 'left');
    ps(end+1) = p;
end

fprintf('Maximum p = %.3f\n\n', max(ps));



for idx = idx_start_3 : N_angles
    fprintf('Under H0: EMCI =< 0 for experiment at %.2f degree, ', theta_xsec_exp(idx))
    ttest1_from_summary( ...
        mean_EMCI_exp_nonIM_N(idx), std_EMCI_exp_nonIM_N(idx), 3, ...
                    0, 'right');
end


%% Generation of Fig. 3F

close all; clc;

% Read EMCI data for 2 more trials
f_shapeIdx_exp_IM_2 = append(f_dataset_S1, ['\Spatial_distribution\' ...
    'shapeIdx_exp_idxMat_2.mat']);
EMCI_exp_IM_2 = matfile(f_shapeIdx_exp_IM_2).shapeIdx_exp_idxMat_2;

f_shapeIdx_exp_IM_3 = append(f_dataset_S1, ['\Spatial_distribution\' ...
    'shapeIdx_exp_idxMat_3.mat']);
EMCI_exp_IM_3 = matfile(f_shapeIdx_exp_IM_3).shapeIdx_exp_idxMat_3;

EMCI_exp_IM_N = [shapeIdx_exp_idxMat; EMCI_exp_IM_2; EMCI_exp_IM_3];

% Compute mean and SEM for experimental and simulated EMCI

mean_EMCI_exp_IM_N = mean(EMCI_exp_IM_N, 1);
std_EMCI_exp_IM_N = std(EMCI_exp_IM_N, 0, 1);
sem_EMCI_exp_IM_N = std_EMCI_exp_IM_N./sqrt(size(EMCI_exp_IM_N, 1));

mean_theta_xsec_Zemax_N_idxMat = mean(theta_xsec_Zemax_N_idxMat, 1);
mean_shapeIdx_Zemax_N_idxMat = mean(shapeIdx_Zemax_N_idxMat, 1);
sem_shapeIdx_Zemax_N_idxMat = std(shapeIdx_Zemax_N_idxMat, 0, 1)./sqrt(size(shapeIdx_Zemax_N_idxMat, 1));

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 105;
text_x_offset = 15;
text_y = (0.9 - 0.15 * [0:1]);


figure;
hold on;

errorbar(theta_xsec_exp_idxMat, mean_EMCI_exp_IM_N, sem_EMCI_exp_IM_N, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.05, ...
    'Marker', 'o', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size, ...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), 'Experiment, IM', 'FontSize', font_size);


errorbar(mean_theta_xsec_Zemax_N_idxMat,mean_shapeIdx_Zemax_N_idxMat, sem_shapeIdx_Zemax_N_idxMat, ...
    '--k', 'LineWidth', Line_Width);
errorbar(x_icon, text_y(2), 0.05, ...
    '--k', 'LineWidth', Line_Width);
plot([x_icon-10 x_icon+10] , [text_y(2) text_y(2)], ...
    '--k', 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(2), 'Model, IM', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('EMCI', 'FontWeight', 'bold');
ylim([-0.5 1]);
yticks(-0.5:0.25:1);
% title('EMCI for idx matching')
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% t-test whether significantly higher than zero
ps = [];
for idx = 2 : 35
    fprintf('Under H0: EMCI =< 0 for experiment at %.2f degree, ', theta_xsec_exp_idxMat(idx))
    [~,~,p] = ttest1_from_summary( ...
        mean_EMCI_exp_IM_N(idx), std_EMCI_exp_IM_N(idx), 3, ...
                    0, 'right');
    ps(end+1) = p;
end

fprintf('Minimal p = %.2f\n\n', min(ps))


%% Generation of Fig. 5A

close all; clc;

% statistic file name
f_fig5a_stat = ...
    append(f_table_S1, '\Fig5A.xlsx');

is_forward = true;

% Agar, red
f_red_agar = ...
    append(f_dataset_S1, '\Substrate_RGB\Agar\red\data.xlsx');

[theta_red_agar, contrast_red_agar, WSFC_red_agar, BSFC_red_agar] = ...
    scatter_contrast_analysis(f_red_agar, 'Sheet1', red_power_data, 'red', PIC_red, Area_PM_sensor, is_forward);

contrast_red_agar.sem = (contrast_red_agar.std)./sqrt(contrast_red_agar.count);

WSFC_red_agar.sem = (WSFC_red_agar.std)./sqrt(WSFC_red_agar.count);
BSFC_red_agar.sem = (BSFC_red_agar.std)./sqrt(BSFC_red_agar.count);

% save to stats file
saveStat(WSFC_red_agar, theta_red_agar, f_fig5a_stat, 'worm_on_agar', 'sfc');
saveStat(BSFC_red_agar, theta_red_agar, f_fig5a_stat, 'agar', 'sfc');

% Gelatin, red
f_red_gelatin = ...
    append(f_dataset_S1, '\Substrate_RGB\Gelatin\red\data.xlsx');

[theta_red_gelatin, contrast_red_gelatin, WSFC_red_gelatin, BSFC_red_gelatin] = ...
    scatter_contrast_analysis(f_red_gelatin, 'Sheet1', red_power_data, 'red', PIC_red, Area_PM_sensor, is_forward);

contrast_red_gelatin.sem = (contrast_red_gelatin.std)./sqrt(contrast_red_gelatin.count);

WSFC_red_gelatin.sem = (WSFC_red_gelatin.std)./sqrt(WSFC_red_gelatin.count);
BSFC_red_gelatin.sem = (BSFC_red_gelatin.std)./sqrt(BSFC_red_gelatin.count);

% save to stats file
saveStat(WSFC_red_gelatin, theta_red_gelatin, f_fig5a_stat, 'worm_on_gelatin', 'sfc');
saveStat(BSFC_red_gelatin, theta_red_gelatin, f_fig5a_stat, 'gelatin', 'sfc');


% Gellan gum, red
f_red_rite = ...
    append(f_dataset_S1, '\Substrate_RGB\Rite\red\data.xlsx');

[theta_red_rite, contrast_red_rite, WSFC_red_rite, BSFC_red_rite] = ...
    scatter_contrast_analysis(f_red_rite, 'Sheet1', red_power_data, 'red', PIC_red, Area_PM_sensor, is_forward);

contrast_red_rite.sem = (contrast_red_rite.std)./sqrt(contrast_red_rite.count);

WSFC_red_rite.sem = (WSFC_red_rite.std)./sqrt(WSFC_red_rite.count);
BSFC_red_rite.sem = (BSFC_red_rite.std)./sqrt(BSFC_red_rite.count);

% save to stats file
saveStat(WSFC_red_rite, theta_red_rite, f_fig5a_stat, 'worm_on_gellan_gum', 'sfc');
saveStat(BSFC_red_rite, theta_red_rite, f_fig5a_stat, 'gellan_gum', 'sfc');

% plot the scattering functions

agar_mark_shape_fig = 'o';
gelatin_mark_shape_fig = '>';
rite_mark_shape_fig = '+';

marker_size = 60;
marker_size_erbr = 8;
capsz = 12;

Line_Width = 1.5;
font_size = 13;
tick_len = 0.02;

x_icon = 60;
text_x_offset = 5;
text_y = 10.^(0.8 - 0.3 * [0:5]);


figure;
hold on;


scatter(rad2deg(theta_red_agar), WSFC_red_agar.mean, agar_mark_shape_fig, 'Filled', ...
    'MarkerFaceColor', red_color, 'SizeData', marker_size, 'DisplayName', 'Worm on agar', ...
    'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),agar_mark_shape_fig, 'Filled', 'MarkerFaceColor', red_color, ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Worm on agar', 'FontSize', font_size);


scatter(rad2deg(theta_red_gelatin), WSFC_red_gelatin.mean,gelatin_mark_shape_fig, ...
    'SizeData', marker_size, 'DisplayName', 'Worm on gelatin', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(2),gelatin_mark_shape_fig, ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(2), 'Worm on gelatin', 'FontSize', font_size);


scatter(rad2deg(theta_red_rite), WSFC_red_rite.mean,rite_mark_shape_fig, ...
    'SizeData', marker_size, 'DisplayName', 'Worm on gellan gum', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(3),rite_mark_shape_fig, ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3), 'Worm on gellan gum', 'FontSize', font_size);


text(x_icon + text_x_offset, text_y(4), 'Agar', 'FontSize', font_size);
errorbar(rad2deg(theta_red_agar), BSFC_red_agar.mean, BSFC_red_agar.sem, ...
    'Marker', agar_mark_shape_fig, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size_erbr,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color, 'CapSize', capsz);
errorbar(x_icon, text_y(4), 0.22, ...
    'Marker', agar_mark_shape_fig, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size_erbr,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color, 'CapSize', capsz);


text(x_icon + text_x_offset, text_y(5), 'Gelatin', 'FontSize', font_size);
errorbar(rad2deg(theta_red_gelatin), BSFC_red_gelatin.mean, BSFC_red_gelatin.sem, ...
    'Marker', 'v', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size_erbr,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color, 'CapSize', capsz);
errorbar(x_icon, text_y(5), 0.09, ...
    'Marker', 'v', 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size_erbr,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color, 'CapSize', capsz);


text(x_icon + text_x_offset, text_y(6), 'Gellan gum', 'FontSize', font_size);
errorbar(rad2deg(theta_red_rite), BSFC_red_rite.mean, BSFC_red_rite.sem, ...
    'Marker', 'Pentagram', 'MarkerEdgeColor', 'k', 'MarkerSize', marker_size_erbr,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', 'k', 'CapSize', capsz);
errorbar(x_icon, text_y(6), 0.053, ...
    'Marker', 'Pentagram', 'MarkerEdgeColor', 'k', 'MarkerSize', marker_size_erbr,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', 'k', 'CapSize', capsz);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:15:90);
xlim([0 90]);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:1));
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = 14;
ax.TickLength = [tick_len, 0];
% title('Substrate-dependent scattering functions', 'FontSize', 15);
hold off;

% t-test for surface and volume scattering from 10 to 62 deg
for idx = 5:10
    fprintf('Under H0: scattering of agar =< gelatin. at %.2f degree, ', rad2deg(theta_red_agar(idx)))
    ttest2_from_summary( ...
                    BSFC_red_agar.mean(idx), BSFC_red_agar.std(idx), BSFC_red_agar.count(idx), ...
                    BSFC_red_gelatin.mean(idx), BSFC_red_gelatin.std(idx), BSFC_red_gelatin.count(idx), ...
                    'welch', 'right');
end

for idx = 5:10
    fprintf('Under H0: scattering of agar =< gellan gum. at %.2f degree, ', rad2deg(theta_red_agar(idx)))
    ttest2_from_summary( ...
                    BSFC_red_agar.mean(idx), BSFC_red_agar.std(idx), BSFC_red_agar.count(idx), ...
                    BSFC_red_rite.mean(idx), BSFC_red_rite.std(idx), BSFC_red_rite.count(idx), ...
                    'welch', 'right');
end


% t-test to see whether the scattering functions decrease with angle
disp('Under H0: scattering at 6 degree =< 62 degree for agar,')
ttest2_from_summary( ...
                    BSFC_red_agar.mean(2), BSFC_red_agar.std(2), BSFC_red_agar.count(2), ...
                    BSFC_red_agar.mean(end), BSFC_red_agar.std(end), BSFC_red_agar.count(end), ...
                    'welch', 'right');

disp('Under H0: scattering at 6 degree =< 62 degree for gelatin,')
ttest2_from_summary( ...
                    BSFC_red_gelatin.mean(2), BSFC_red_gelatin.std(2), BSFC_red_gelatin.count(2), ...
                    BSFC_red_gelatin.mean(end), BSFC_red_gelatin.std(end), BSFC_red_gelatin.count(end), ...
                    'welch', 'right');

disp('Under H0: scattering at 6 degree =< 62 degree for gellan gum,')
ttest2_from_summary( ...
                    BSFC_red_rite.mean(2), BSFC_red_rite.std(2), BSFC_red_rite.count(2), ...
                    BSFC_red_rite.mean(end), BSFC_red_rite.std(end), BSFC_red_rite.count(end), ...
                    'welch', 'right');

%% Generation of Fig. 5B

close all; clc;

is_forward = true;

% Agar, green
f_green_agar = ...
    append(f_dataset_S1, '\Substrate_RGB\Agar\green\data.xlsx');

[theta_green_agar, contrast_green_agar, WSFC_green_agar, BSFC_green_agar] = ...
    scatter_contrast_analysis( ...
        f_green_agar, ...
        'Sheet1', ...
        green_power_data, ...   
        'green', ...            
        PIC_green, ...          
        Area_PM_sensor, ...
        is_forward ...
    );
contrast_green_agar.sem = (contrast_green_agar.std)./sqrt(contrast_green_agar.count);
WSFC_green_agar.sem = (WSFC_green_agar.std)./sqrt(WSFC_green_agar.count);
BSFC_green_agar.sem = (BSFC_green_agar.std)./sqrt(BSFC_green_agar.count);

% Agar, blue
f_blue_agar = ...
    append(f_dataset_S1, '\Substrate_RGB\Agar\blue\data.xlsx');

[theta_blue_agar, contrast_blue_agar, WSFC_blue_agar, BSFC_blue_agar] = ...
    scatter_contrast_analysis( ...
        f_blue_agar, ...
        'Sheet1', ...
        blue_power_data, ...    
        'blue', ...             
        PIC_blue, ...           
        Area_PM_sensor, ...
        is_forward ...
    );
contrast_blue_agar.sem = (contrast_blue_agar.std)./sqrt(contrast_blue_agar.count);
WSFC_blue_agar.sem = (WSFC_blue_agar.std)./sqrt(WSFC_blue_agar.count);
BSFC_blue_agar.sem = (BSFC_blue_agar.std)./sqrt(BSFC_blue_agar.count);


% Gelatin, green
f_green_gelatin = ...
    append(f_dataset_S1, '\Substrate_RGB\Gelatin\green\data.xlsx');

[theta_green_gelatin, contrast_green_gelatin, WSFC_green_gelatin, BSFC_green_gelatin] = ...
    scatter_contrast_analysis( ...
        f_green_gelatin, ...
        'Sheet1', ...
        green_power_data, ...   
        'green', ...            
        PIC_green, ...          
        Area_PM_sensor, ...
        is_forward ...
    );
contrast_green_gelatin.sem = (contrast_green_gelatin.std)./sqrt(contrast_green_gelatin.count);
WSFC_green_gelatin.sem = (WSFC_green_gelatin.std)./sqrt(WSFC_green_gelatin.count);
BSFC_green_gelatin.sem = (BSFC_green_gelatin.std)./sqrt(BSFC_green_gelatin.count);

% Gelatin, blue
f_blue_gelatin = ...
    append(f_dataset_S1, '\Substrate_RGB\Gelatin\blue\data.xlsx');

[theta_blue_gelatin, contrast_blue_gelatin, WSFC_blue_gelatin, BSFC_blue_gelatin] = ...
    scatter_contrast_analysis( ...
        f_blue_gelatin, ...
        'Sheet1', ...
        blue_power_data, ...   
        'blue', ...            
        PIC_blue, ...          
        Area_PM_sensor, ...
        is_forward ...
    );
contrast_blue_gelatin.sem = (contrast_blue_gelatin.std)./sqrt(contrast_blue_gelatin.count);
WSFC_blue_gelatin.sem = (WSFC_blue_gelatin.std)./sqrt(WSFC_blue_gelatin.count);
BSFC_blue_gelatin.sem = (BSFC_blue_gelatin.std)./sqrt(BSFC_blue_gelatin.count);

% Gellan gum, green
f_green_rite = ...
    append(f_dataset_S1, '\Substrate_RGB\Rite\green\data.xlsx');

[theta_green_rite, contrast_green_rite, WSFC_green_rite, BSFC_green_rite] = ...
    scatter_contrast_analysis( ...
        f_green_rite, ...
        'Sheet1', ...
        green_power_data, ...   
        'green', ...            
        PIC_green, ...          
        Area_PM_sensor, ...
        is_forward ...
    );
contrast_green_rite.sem = (contrast_green_rite.std)./sqrt(contrast_green_rite.count);
WSFC_green_rite.sem = (WSFC_green_rite.std)./sqrt(WSFC_green_rite.count);
BSFC_green_rite.sem = (BSFC_green_rite.std)./sqrt(BSFC_green_rite.count);

% Gellan gum, blue
f_blue_rite = ...
    append(f_dataset_S1, '\Substrate_RGB\Rite\blue\data.xlsx');

[theta_blue_rite, contrast_blue_rite, WSFC_blue_rite, BSFC_blue_rite] = ...
    scatter_contrast_analysis( ...
        f_blue_rite, ...
        'Sheet1', ...
        blue_power_data, ...   
        'blue', ...            
        PIC_blue, ...          
        Area_PM_sensor, ...
        is_forward ...
    );
contrast_blue_rite.sem = (contrast_blue_rite.std)./sqrt(contrast_blue_rite.count);
WSFC_blue_rite.sem = (WSFC_blue_rite.std)./sqrt(WSFC_blue_rite.count);
BSFC_blue_rite.sem = (BSFC_blue_rite.std)./sqrt(BSFC_blue_rite.count);

% barchat for contrast for different plates RGB

plate_contrast_data = [...
    contrast_blue_agar.mean, contrast_blue_gelatin.mean, contrast_blue_rite.mean;...
    contrast_green_agar.mean, contrast_green_gelatin.mean, contrast_green_rite.mean;...
    contrast_red_agar.mean, contrast_red_gelatin.mean, contrast_red_rite.mean;...
    ];

group_inx = [ones(1,size(contrast_blue_agar.mean,1)), ...
    2.*ones(1,size(contrast_green_agar.mean,1)), ...
    3.*ones(1,size(contrast_red_agar.mean,1))];


c =  [blue_color;...
      green_color;...
      red_color];  

group_names = {'447 nm', '516 nm' , '629 nm'};
condition_names = {'Agar', 'Gelatin' , 'Gellan gum'};

h_plate_contrast = dabarplot(plate_contrast_data,'groups',group_inx,...
    'errorbars', 'SE', 'errorhats', 1, ...
    'xtlabels', condition_names,...
    'scatter',1,'scattersize',80,'scatteralpha',0.5,...
    'barspacing',0.8, 'colors',c, 'baralpha', 0.6, 'scatteralpha', 0.5, ...
    'scattercolors', {0.4*[1 1 1], 'w'});

ylabel('Contrast index');
% yl = ylim; ylim([yl(1), yl(2)+0.4]);  % make more space for the legend
ylim([0 1])
yticks(0:0.1:1)
% fontsize(h_plate_contrast.lg, 12, 'points'); % Sets the font size
% title('Substrate-dependent image contrast')
pbaspect([1.2 1 1])

tick_len = 0.02;
font_size = 14;

ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];

h_ylabel = get(ax, 'YLabel');
h_xtick = get(ax, 'XAxis');
set(h_ylabel, 'FontWeight', 'bold');
set(h_xtick, 'FontWeight', 'bold');


hold off;

% t-test at peak contrast indices
[~, idx_max_agar] = max(contrast_red_agar.mean);
[~, idx_max_gelatin] = max(contrast_red_gelatin.mean);
[~, idx_max_rite] = max(contrast_red_rite.mean);

disp("Under H0: gelatin =< agar for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_gelatin.mean(idx_max_gelatin), contrast_red_gelatin.std(idx_max_gelatin), contrast_red_gelatin.count(idx_max_gelatin), ...
    contrast_red_agar.mean(idx_max_agar), contrast_red_agar.std(idx_max_agar), contrast_red_agar.count(idx_max_agar), ...
    'welch', 'right');

disp("Under H0: gellan gum =< agar for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_rite.mean(idx_max_rite), contrast_red_rite.std(idx_max_rite), contrast_red_rite.count(idx_max_rite), ...
    contrast_red_agar.mean(idx_max_agar), contrast_red_agar.std(idx_max_agar), contrast_red_agar.count(idx_max_agar), ...
    'welch', 'right');

%% Generation of Fig. S1A

% statistic file name
f_figS1A_stat = ...
    append(f_table_S1, '\FigS1A.xlsx');

% Scattering functions for Green, Seeded, Idx-matched
f_green_seed_BF_IM = ...
    append(f_dataset_S1, '\BF_seeded_RGB\Idx_mat\green_idxMat\data.xlsx');

f_green_seed_fwrd_IM = ...
    append(f_dataset_S1, '\DF_seeded_idx_mat_RGB\green\data.xlsx');

f_green_seed_bck_IM = ...
    append(f_dataset_S1, '\Backscat_seeded_idx_mat_RGB\green\data.xlsx');

condition_str = 'seeded, idx matched';

[theta_green_seed_IM, contrast_green_seed_IM, WSFC_green_seed_IM, BSFC_green_seed_IM] = ...
bulk_scatter_contrast_analysis( ...
    f_green_seed_BF_IM, ...
    f_green_seed_fwrd_IM, ...
    f_green_seed_bck_IM, ...
    green_power_data, ...    
    'green', ...             
    PIC_green, ...           
    Area_PM_sensor, ...
    condition_str ...
);


% Scattering functions for Blue, Seeded, Idx-matched
f_blue_seed_BF_IM = ...
    append(f_dataset_S1, '\BF_seeded_RGB\Idx_mat\blue_idxMat\data.xlsx');

f_blue_seed_fwrd_IM = ...
    append(f_dataset_S1, '\DF_seeded_idx_mat_RGB\blue\data.xlsx');

f_blue_seed_bck_IM = ...
    append(f_dataset_S1, '\Backscat_seeded_idx_mat_RGB\blue\data.xlsx');

condition_str = 'seeded, idx matched';

[theta_blue_seed_IM, contrast_blue_seed_IM, WSFC_blue_seed_IM, BSFC_blue_seed_IM] = ...
bulk_scatter_contrast_analysis( ...
    f_blue_seed_BF_IM, ...
    f_blue_seed_fwrd_IM, ...
    f_blue_seed_bck_IM, ...
    blue_power_data, ...    
    'blue', ...             
    PIC_blue, ...           
    Area_PM_sensor, ...
    condition_str ...
);


% Plot scattering functions for RGB, Seeded, Idx-matched
close all; clc;
marker_size = 40;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 95;
text_x_offset = 7;
text_y = 10.^(3.8 - 0.4 * [0:5]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'o';

red_bg_mrk = 'square';
green_bg_mrk = '*';
blue_bg_mrk = '>';


figure;
hold on;

% bg, green

green_bg_color = [0, 230, 0] / 255;
scatter(rad2deg(theta_green_seed_IM), BSFC_green_seed_IM.mean, green_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Seeded agar, 516 nm', ...
    'MarkerEdgeColor', green_bg_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(5), green_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_color_bright, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(5), ...
    'Seeded agar, 516 nm', ...
    'FontSize', font_size);


% worm, red
scatter(rad2deg(theta_red_seed_idxMat), WSFC_red_seed_idxMat.mean, red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 629 nm', ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(1), red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), ...
    'Worm, 629 nm', ...
    'FontSize', font_size);


% worm, blue
scatter(rad2deg(theta_blue_seed_IM), WSFC_blue_seed_IM.mean, blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 447 nm', ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(3), blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(3), ...
    'Worm, 447 nm', ...
    'FontSize', font_size);

% worm, green

scatter(rad2deg(theta_green_seed_IM), WSFC_green_seed_IM.mean, green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Worm, 516 nm', ...
    'MarkerEdgeColor', green_color_bright, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(2), green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_color_bright, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(2), ...
    'Worm, 516 nm', ...
    'FontSize', font_size);

% bg, red

scatter(rad2deg(theta_red_seed_idxMat), BSFC_red_seed_idxMat.mean, red_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Seeded agar, 629 nm', ...
    'MarkerEdgeColor', red_color_dim, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(4), red_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', red_color_dim, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(4), ...
    'Seeded agar, 629 nm', ...
    'FontSize', font_size);


% bg, blue
scatter(rad2deg(theta_blue_seed_IM), BSFC_blue_seed_IM.mean, blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Seeded agar, 447 nm', ...
    'MarkerEdgeColor', blue_color_dim, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(6), blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', blue_color_dim, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(6), ...
    'Seeded agar, 447 nm', ...
    'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-2:4));
%title('\lambda-dependent scattering functions');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% Save to statistic file
saveStat(WSFC_red_seed_idxMat, theta_red_seed_idxMat, f_figS1A_stat, 'worm_629nm', 'sfc');
saveStat(BSFC_red_seed_idxMat, theta_red_seed_idxMat, f_figS1A_stat, 'seeded_agar_629nm', 'sfc');
saveStat(WSFC_green_seed_IM, theta_green_seed_IM, f_figS1A_stat, 'worm_516nm', 'sfc');
saveStat(BSFC_green_seed_IM, theta_green_seed_IM, f_figS1A_stat, 'seeded_agar_516nm', 'sfc');
saveStat(WSFC_blue_seed_IM, theta_blue_seed_IM, f_figS1A_stat, 'worm_447nm', 'sfc');
saveStat(BSFC_blue_seed_IM, theta_blue_seed_IM, f_figS1A_stat, 'seeded_agar_447nm', 'sfc');

%% Generation of Fig. S1B

% statistic file name
f_figS1B_stat = ...
    append(f_table_S1, '\FigS1B.xlsx');

close all; clc;

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;


x_icon = 140;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:2]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'v';

figure;
hold on;

errorbar(rad2deg(theta_red_seed_idxMat), contrast_red_seed_idxMat.mean, contrast_red_seed_idxMat.sem, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.07, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), '629 nm', 'FontSize', font_size);


errorbar(rad2deg(theta_blue_seed_IM), contrast_blue_seed_IM.mean, contrast_blue_seed_IM.sem, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
errorbar(x_icon, text_y(3), 0.07, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
text(x_icon + text_x_offset, text_y(3), '447 nm', 'FontSize', font_size);


errorbar(rad2deg(theta_green_seed_IM), contrast_green_seed_IM.mean, contrast_green_seed_IM.sem, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
errorbar(x_icon, text_y(2), 0.07, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);

text(x_icon + text_x_offset, text_y(2), '516 nm', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(-1:0.2:1);
ylim([-1 1])
%title('\lambda-dependent image contrast');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test at peak contrast indices
[~, idx_max_red_IM] = max(contrast_red_seed_idxMat.mean);
[~, idx_max_green_IM] = max(contrast_green_seed_IM.mean);
[~, idx_max_blue_IM] = max(contrast_blue_seed_IM.mean);

disp("Under H0: red =< green for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_seed_idxMat.mean(idx_max_red_IM), contrast_red_seed_idxMat.std(idx_max_red_IM), contrast_red_seed_idxMat.count(idx_max_red_IM), ...
    contrast_green_seed_IM.mean(idx_max_green_IM), contrast_green_seed_IM.std(idx_max_green_IM), contrast_green_seed_IM.count(idx_max_green_IM), ...
    'welch', 'right');

disp("Under H0: green =< blue for peak contrast indices,")
ttest2_from_summary( ...
    contrast_green_seed_IM.mean(idx_max_green_IM), contrast_green_seed_IM.std(idx_max_green_IM), contrast_green_seed_IM.count(idx_max_green_IM), ...
    contrast_blue_seed_IM.mean(idx_max_blue_IM), contrast_blue_seed_IM.std(idx_max_blue_IM), contrast_blue_seed_IM.count(idx_max_blue_IM), ...
    'welch', 'right');

% Save to statistic file
saveStat(contrast_red_seed_idxMat, theta_red_seed_idxMat, f_figS1B_stat, '629nm', 'ctrst');
saveStat(contrast_green_seed_IM, theta_green_seed_IM, f_figS1B_stat, '516nm', 'ctrst');
saveStat(contrast_blue_seed_IM, theta_blue_seed_IM, f_figS1B_stat, '447nm', 'ctrst');

%% Generation of Fig. S3 - calculate Mie scattering
clc;
[angles_deg_vol, Mie_SFC_vol, ~] = Mie_scat( ...
    50, 1000, 'vol', 1.33, 629, 1, 30);

[angles_deg_surf, Mie_SFC_surf, ~] = Mie_scat( ...
    50, 1000, 'surf', 1.33, 629, 1, 30);

[angles_deg_worm_r, Mie_SFC_worm_r, ~] = Mie_scat( ...
    50, 1000, 'worm_r', 1.33, 629, 1, 30);

% interplotation for statistical tests
Mie_SFC_vol_interp = interp1( ...
    angles_deg_vol, Mie_SFC_vol, ...
    rad2deg(theta_red_seed), 'linear');

Mie_SFC_surf_interp = interp1( ...
    angles_deg_surf, Mie_SFC_surf, ...
    rad2deg(theta_red_seed), 'linear');

Mie_SFC_worm_r_interp = interp1( ...
    angles_deg_worm_r, Mie_SFC_worm_r, ...
    rad2deg(theta_red_seed), 'linear');
%% Generation of Fig. S3A
close all; clc;
marker_size = 40;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 70;
text_x_offset = 20;
text_y = 10.^(5 - 0.6 * [0:2]);


figure;
hold on;

scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean,'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Experiment', 'FontSize', font_size);

errorbar(mean_theta_zemax_full_N, mean_WSFC_zemax_full_N, WSFC_zemax_full.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(2), 5.5^(13.5/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-15 x_icon+15], [text_y(2)-2000 text_y(2)-2000],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(2)-150, 'Our model', 'FontSize', font_size);

plot(angles_deg_vol, Mie_SFC_vol, '-v', 'Color', green_color_bright, ...
    'LineWidth', Line_Width, 'MarkerSize', 6);
line([x_icon-15 x_icon+15], [text_y(3) text_y(3)],...
    'LineWidth', Line_Width, 'Color', green_color_bright);
scatter(x_icon, text_y(3), 'v', ...
    'SizeData', marker_size, 'MarkerEdgeColor', green_color_bright, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3), 'Mie, vol. equiv.', 'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:5));
ylim(10.^[-3.5 5.5])
yscale('log');
pbaspect([1 1.3 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
f = gcf;
f.Position(3) = f.Position(3) * 0.7;
hold off;

% t-test at 0 degree
disp('Under H0: Mie =< experiment at 0 degree,')
ttest1_from_summary( ...
                WSFC_red_seed.mean(1), WSFC_red_seed.std(1), WSFC_red_seed.count(1), ...
                Mie_SFC_vol(1), 'left');


% t-test at higher angles
for i = 2:size(WSFC_red_seed.mean, 1)
    fprintf('Under H0: Mie => experiment at %.2f degree,', rad2deg(theta_red_seed(i)))
    ttest1_from_summary( ...
                    WSFC_red_seed.mean(i), WSFC_red_seed.std(i), WSFC_red_seed.count(i), ...
                    Mie_SFC_vol_interp(i), 'right');
end
%% Generation of Fig. S3B

close all; clc;
marker_size = 40;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 70;
text_x_offset = 20;
text_y = 10.^(5 - 0.6 * [0:2]);


figure;
hold on;

scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean,'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Experiment', 'FontSize', font_size);

errorbar(mean_theta_zemax_full_N, mean_WSFC_zemax_full_N, WSFC_zemax_full.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(2), 5.5^(13.5/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-15 x_icon+15], [text_y(2)-2000 text_y(2)-2000],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(2)-150, 'Our model', 'FontSize', font_size);

plot(angles_deg_surf, Mie_SFC_surf, '-v', 'Color', green_color_bright, ...
    'LineWidth', Line_Width, 'MarkerSize', 6);
line([x_icon-15 x_icon+15], [text_y(3) text_y(3)],...
    'LineWidth', Line_Width, 'Color', green_color_bright);
scatter(x_icon, text_y(3), 'v', ...
    'SizeData', marker_size, 'MarkerEdgeColor', green_color_bright, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3), 'Mie, surf. equiv.', 'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:5));
ylim(10.^[-3.5 5.5])
yscale('log');
pbaspect([1 1.3 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
f = gcf;
f.Position(3) = f.Position(3) * 0.7;
hold off;

% t-test at 0 degree
disp('Under H0: Mie =< experiment at 0 degree,')
ttest1_from_summary( ...
                WSFC_red_seed.mean(1), WSFC_red_seed.std(1), WSFC_red_seed.count(1), ...
                Mie_SFC_surf(1), 'left');


% t-test at higher angles
for i = 2:size(WSFC_red_seed.mean, 1)
    fprintf('Under H0: Mie => experiment at %.2f degree,', rad2deg(theta_red_seed(i)))
    ttest1_from_summary( ...
                    WSFC_red_seed.mean(i), WSFC_red_seed.std(i), WSFC_red_seed.count(i), ...
                    Mie_SFC_surf_interp(i), 'right');
end

%% Generation of Fig. S3C

close all; clc;
marker_size = 40;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 70;
text_x_offset = 20;
text_y = 10.^(5 - 0.6 * [0:2]);


figure;
hold on;

scatter(rad2deg(theta_red_seed), WSFC_red_seed.mean,'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Experiment', 'FontSize', font_size);

errorbar(mean_theta_zemax_full_N, mean_WSFC_zemax_full_N, WSFC_zemax_full.sem',...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(2), 5.5^(13.5/2.5),...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-15 x_icon+15], [text_y(2)-2000 text_y(2)-2000],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(2)-150, 'Our model', 'FontSize', font_size);

plot(angles_deg_worm_r, Mie_SFC_worm_r, '-v', 'Color', green_color_bright, ...
    'LineWidth', Line_Width, 'MarkerSize', 6);
line([x_icon-15 x_icon+15], [text_y(3) text_y(3)],...
    'LineWidth', Line_Width, 'Color', green_color_bright);
scatter(x_icon, text_y(3), 'v', ...
    'SizeData', marker_size, 'MarkerEdgeColor', green_color_bright, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(3), 'Mie, cross-sec. equiv.', 'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:5));
ylim(10.^[-3.5 5.5])
yscale('log');
pbaspect([1 1.3 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
f = gcf;
f.Position(3) = f.Position(3) * 0.7;
hold off;

% t-test at 0 degree
disp('Under H0: Mie =< experiment at 0 degree,')
ttest1_from_summary( ...
                WSFC_red_seed.mean(1), WSFC_red_seed.std(1), WSFC_red_seed.count(1), ...
                Mie_SFC_worm_r(1), 'left');

% t-test at higher angles
for i = 2:size(WSFC_red_seed.mean, 1)
    fprintf('Under H0: Mie => experiment at %.2f degree,', rad2deg(theta_red_seed(i)))
    ttest1_from_summary( ...
                    WSFC_red_seed.mean(i), WSFC_red_seed.std(i), WSFC_red_seed.count(i), ...
                    Mie_SFC_worm_r_interp(i), 'right');
end
%% Generation of Fig. S4A

close all; clc;
marker_size = 70;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 55;
text_x_offset = 5;
text_y = 10.^(0.8 - 0.25 * [0:5]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'o';

red_bg_mrk = 'square';
green_bg_mrk = '*';
blue_bg_mrk = '>';

green_worm_color = [0, 230, 0] / 255;


figure;
hold on;


% bg, green

green_bg_color = [0, 230, 0] / 255;
scatter(rad2deg(theta_green_agar), BSFC_green_agar.mean, green_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Agar, 516 nm', ...
    'MarkerEdgeColor', green_bg_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(5), green_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(5), ...
    'Agar, 516 nm', ...
    'FontSize', font_size);



% worm, red
scatter(rad2deg(theta_red_agar), WSFC_red_agar.mean, red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 629 nm', ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(1), red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), ...
    'Worm, 629 nm', ...
    'FontSize', font_size);


% worm, blue
scatter(rad2deg(theta_blue_agar), WSFC_blue_agar.mean, blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 447 nm', ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(3), blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(3), ...
    'Worm, 447 nm', ...
    'FontSize', font_size);

% worm, green

scatter(rad2deg(theta_green_agar), WSFC_green_agar.mean, green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Worm, 516 nm', ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(2), green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(2), ...
    'Worm, 516 nm', ...
    'FontSize', font_size);


% bg


% bg, red

scatter(rad2deg(theta_red_agar), BSFC_red_agar.mean, red_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Agar, 629 nm', ...
    'MarkerEdgeColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(4), red_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(4), ...
    'Agar, 629 nm', ...
    'FontSize', font_size);


% bg, blue
scatter(rad2deg(theta_blue_agar), BSFC_blue_agar.mean, blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Agar, 447 nm', ...
    'MarkerEdgeColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(6), blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(6), ...
    'Agar, 447 nm', ...
    'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xlim([0 90])
xticks(0:15:90);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:1));
ylim(10.^[-3 1])
% title('\lambda-dependent scat. func. for agar');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% statistic file name
f_figS4A_stat = append(f_table_S1, '\FigS4A.xlsx');

% save to stats file
saveStat(WSFC_red_agar, theta_red_agar, f_figS4A_stat, 'worm_629nm', 'sfc');
saveStat(BSFC_red_agar, theta_red_agar, f_figS4A_stat, 'agar_629nm', 'sfc');
saveStat(WSFC_green_agar, theta_green_agar, f_figS4A_stat, 'worm_516nm', 'sfc');
saveStat(BSFC_green_agar, theta_green_agar, f_figS4A_stat, 'agar_516nm', 'sfc');
saveStat(WSFC_blue_agar, theta_blue_agar, f_figS4A_stat, 'worm_447nm', 'sfc');
saveStat(BSFC_blue_agar, theta_blue_agar, f_figS4A_stat, 'agar_447nm', 'sfc');

%% Generation of Fig. S4B

close all; clc;

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;


x_icon = 70;
text_x_offset = 5;
text_y = (0.9 - 0.1 * [0:2]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'v';

figure;
hold on;


errorbar(rad2deg(theta_red_agar), contrast_red_agar.mean, contrast_red_agar.sem, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.035, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), '629 nm', 'FontSize', font_size);

errorbar(rad2deg(theta_green_agar), contrast_green_agar.mean, contrast_green_agar.sem, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
errorbar(x_icon, text_y(2), 0.035, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
text(x_icon + text_x_offset, text_y(2), '629 nm', 'FontSize', font_size);

errorbar(rad2deg(theta_blue_agar), contrast_blue_agar.mean, contrast_blue_agar.sem, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
errorbar(x_icon, text_y(3), 0.035, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
text(x_icon + text_x_offset, text_y(3), '629 nm', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:15:90);
xlim([0 90])
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(0:0.1:1);
ylim([0 1])
% title('\lambda-dependent image contrast for agar');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% t-test at peak contrast indices
[~, idx_max_red] = max(contrast_red_agar.mean);
[~, idx_max_green] = max(contrast_green_agar.mean);
[~, idx_max_blue] = max(contrast_blue_agar.mean);

disp("Under H0: red =< green for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_agar.mean(idx_max_red), contrast_red_agar.std(idx_max_red), contrast_red_agar.count(idx_max_red), ...
    contrast_green_agar.mean(idx_max_green), contrast_green_agar.std(idx_max_green), contrast_green_agar.count(idx_max_green), ...
    'welch', 'right');

disp("Under H0: green =< blue for peak contrast indices,")
ttest2_from_summary( ...
    contrast_green_agar.mean(idx_max_green), contrast_green_agar.std(idx_max_green), contrast_green_agar.count(idx_max_green), ...
    contrast_blue_agar.mean(idx_max_blue), contrast_blue_agar.std(idx_max_blue), contrast_blue_agar.count(idx_max_blue), ...
    'welch', 'right');

% save to statistic file
f_figS4B_stat = append(f_table_S1, '\FigS4B.xlsx');
saveStat(contrast_red_agar, theta_red_agar, f_figS4B_stat, '629nm', 'ctrst');
saveStat(contrast_green_agar, theta_green_agar, f_figS4B_stat, '516nm', 'ctrst');
saveStat(contrast_blue_agar, theta_blue_agar, f_figS4B_stat, '447nm', 'ctrst');

%% Generation of Fig. S4C
close all; clc;
marker_size = 70;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 55;
text_x_offset = 5;
text_y = 10.^(0.8 - 0.25 * [0:5]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'o';

red_bg_mrk = 'square';
green_bg_mrk = '*';
blue_bg_mrk = '>';

green_worm_color = [0, 230, 0] / 255;

figure;
hold on;

% bg, green
green_bg_color = [0, 230, 0] / 255;
scatter(rad2deg(theta_green_gelatin), BSFC_green_gelatin.mean, green_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Gelatin, 516 nm', ...
    'MarkerEdgeColor', green_bg_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(5), green_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(5), ...
    'Gelatin, 516 nm', ...
    'FontSize', font_size);

% worm, red
scatter(rad2deg(theta_red_gelatin), WSFC_red_gelatin.mean, red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 629 nm', ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(1), red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), ...
    'Worm, 629 nm', ...
    'FontSize', font_size);

% worm, blue
scatter(rad2deg(theta_blue_gelatin), WSFC_blue_gelatin.mean, blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 447 nm', ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(3), blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(3), ...
    'Worm, 447 nm', ...
    'FontSize', font_size);

% worm, green
scatter(rad2deg(theta_green_gelatin), WSFC_green_gelatin.mean, green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Worm, 516 nm', ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(2), green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(2), ...
    'Worm, 516 nm', ...
    'FontSize', font_size);

% bg

% bg, red
scatter(rad2deg(theta_red_gelatin), BSFC_red_gelatin.mean, red_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Gelatin, 629 nm', ...
    'MarkerEdgeColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(4), red_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(4), ...
    'Gelatin, 629 nm', ...
    'FontSize', font_size);

% bg, blue
scatter(rad2deg(theta_blue_gelatin), BSFC_blue_gelatin.mean, blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Gelatin, 447 nm', ...
    'MarkerEdgeColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(6), blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(6), ...
    'Gelatin, 447 nm', ...
    'FontSize', font_size);

% lgd = legend('show');
% fontsize(lgd, 12, 'points'); % Sets the font size

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xlim([0 90])
xticks(0:15:90);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:1));
ylim(10.^[-3 1])
% title('\lambda-dependent scat. func. for gelatin');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% statistic file name 
f_figS4C_stat = append(f_table_S1, '\FigS4C.xlsx'); 

% save to stats file
saveStat(WSFC_red_gelatin, theta_red_gelatin, f_figS4C_stat, 'worm_629nm', 'sfc');
saveStat(BSFC_red_gelatin, theta_red_gelatin, f_figS4C_stat, 'gelatin_629nm', 'sfc');
saveStat(WSFC_green_gelatin, theta_green_gelatin, f_figS4C_stat, 'worm_516nm', 'sfc');
saveStat(BSFC_green_gelatin, theta_green_gelatin, f_figS4C_stat, 'gelatin_516nm', 'sfc');
saveStat(WSFC_blue_gelatin, theta_blue_gelatin, f_figS4C_stat, 'worm_447nm', 'sfc');
saveStat(BSFC_blue_gelatin, theta_blue_gelatin, f_figS4C_stat, 'gelatin_447nm', 'sfc');


%% Generation of Fig. S4D

close all; clc

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;


x_icon = 70;
text_x_offset = 5;
text_y = (0.3 - 0.1 * [0:2]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'v';


figure;
hold on;

errorbar(rad2deg(theta_red_gelatin), contrast_red_gelatin.mean, contrast_red_gelatin.sem, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.035, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), '629 nm', 'FontSize', font_size);

errorbar(rad2deg(theta_green_gelatin), contrast_green_gelatin.mean, contrast_green_gelatin.sem, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
errorbar(x_icon, text_y(2), 0.035, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
text(x_icon + text_x_offset, text_y(2), '629 nm', 'FontSize', font_size);

errorbar(rad2deg(theta_blue_gelatin), contrast_blue_gelatin.mean, contrast_blue_gelatin.sem, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
errorbar(x_icon, text_y(3), 0.035, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
text(x_icon + text_x_offset, text_y(3), '629 nm', 'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:15:90);
xlim([0 90])
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(0:0.1:1);
ylim([0 1])
% title('\lambda-dependent image contrast for gelatin');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% t-test at peak contrast indices
[~, idx_max_red] = max(contrast_red_gelatin.mean);
[~, idx_max_green] = max(contrast_green_gelatin.mean);
[~, idx_max_blue] = max(contrast_blue_gelatin.mean);

disp("Under H0: red =< green for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_gelatin.mean(idx_max_red), contrast_red_gelatin.std(idx_max_red), contrast_red_gelatin.count(idx_max_red), ...
    contrast_green_gelatin.mean(idx_max_green), contrast_green_gelatin.std(idx_max_green), contrast_green_gelatin.count(idx_max_green), ...
    'welch', 'right');

disp("Under H0: green =< blue for peak contrast indices,")
ttest2_from_summary( ...
    contrast_green_gelatin.mean(idx_max_green), contrast_green_gelatin.std(idx_max_green), contrast_green_gelatin.count(idx_max_green), ...
    contrast_blue_gelatin.mean(idx_max_blue), contrast_blue_gelatin.std(idx_max_blue), contrast_blue_gelatin.count(idx_max_blue), ...
    'welch', 'right');

% save to statistic file
f_figS4D_stat = append(f_table_S1, '\FigS4D.xlsx');
saveStat(contrast_red_gelatin, theta_red_gelatin, f_figS4D_stat, '629nm', 'ctrst');
saveStat(contrast_green_gelatin, theta_green_gelatin, f_figS4D_stat, '516nm', 'ctrst');
saveStat(contrast_blue_gelatin, theta_blue_gelatin, f_figS4D_stat, '447nm', 'ctrst');

%% Generation of Fig. S4E

close all; clc;
marker_size = 70;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 50;
text_x_offset = 5;
text_y = 10.^(0.8 - 0.25 * [0:5]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'o';

red_bg_mrk = 'square';
green_bg_mrk = '*';
blue_bg_mrk = '>';

green_worm_color = [0, 230, 0] / 255;

figure;
hold on;

% bg, green
green_bg_color = [0, 230, 0] / 255;
scatter(rad2deg(theta_green_rite), BSFC_green_rite.mean, green_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Rite, 516 nm', ...
    'MarkerEdgeColor', green_bg_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(5), green_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(5), ...
    'Gellan gum, 516 nm', ...
    'FontSize', font_size);

% worm, red
scatter(rad2deg(theta_red_rite), WSFC_red_rite.mean, red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 629 nm', ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(1), red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), ...
    'Worm, 629 nm', ...
    'FontSize', font_size);

% worm, blue
scatter(rad2deg(theta_blue_rite), WSFC_blue_rite.mean, blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'DisplayName', 'Worm, 447 nm', ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(3), blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, ...
    'MarkerFaceColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(3), ...
    'Worm, 447 nm', ...
    'FontSize', font_size);

% worm, green
scatter(rad2deg(theta_green_rite), WSFC_green_rite.mean, green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Worm, 516 nm', ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(2), green_wrm_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', green_worm_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(2), ...
    'Worm, 516 nm', ...
    'FontSize', font_size);

% bg
% bg, red
scatter(rad2deg(theta_red_rite), BSFC_red_rite.mean, red_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Rite, 629 nm', ...
    'MarkerEdgeColor', red_color, ...
    'LineWidth', Line_Width);
scatter(x_icon, text_y(4), red_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', red_color, ...
    'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(4), ...
    'Gellan gum, 629 nm', ...
    'FontSize', font_size);

% bg, blue
scatter(rad2deg(theta_blue_rite), BSFC_blue_rite.mean, blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'DisplayName', 'Rite, 447 nm', ...
    'MarkerEdgeColor', blue_color, ...
    'LineWidth', Line_Width);

scatter(x_icon, text_y(6), blue_bg_mrk, ...
    'SizeData', marker_size, ...
    'MarkerEdgeColor', blue_color, ...
    'LineWidth', Line_Width);

text(x_icon + text_x_offset, text_y(6), ...
    'Gellan gum, 447 nm', ...
    'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xlim([0 90])
xticks(0:15:90);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:1));
ylim(10.^[-3 1])
% title('\lambda-dependent scat. func. for gellan gum');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

% statistic file name 
f_figS4E_stat = append(f_table_S1, '\FigS4E.xlsx'); 

% save to stats file
saveStat(WSFC_red_rite, theta_red_rite, f_figS4E_stat, 'worm_629nm', 'sfc');
saveStat(BSFC_red_rite, theta_red_rite, f_figS4E_stat, 'rite_629nm', 'sfc');
saveStat(WSFC_green_rite, theta_green_rite, f_figS4E_stat, 'worm_516nm', 'sfc');
saveStat(BSFC_green_rite, theta_green_rite, f_figS4E_stat, 'rite_516nm', 'sfc');
saveStat(WSFC_blue_rite, theta_blue_rite, f_figS4E_stat, 'worm_447nm', 'sfc');
saveStat(BSFC_blue_rite, theta_blue_rite, f_figS4E_stat, 'rite_447nm', 'sfc');
%% Generation of Fig. S4F

close all; clc

marker_size = 8;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;


x_icon = 70;
text_x_offset = 5;
text_y = (0.3 - 0.1 * [0:2]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'x';
blue_wrm_mrk = 'v';


figure;
hold on;

errorbar(rad2deg(theta_red_rite), contrast_red_rite.mean, contrast_red_rite.sem, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
errorbar(x_icon, text_y(1), 0.035, ...
    'Marker', red_wrm_mrk, 'MarkerEdgeColor', red_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', red_color);
text(x_icon + text_x_offset, text_y(1), '629 nm', 'FontSize', font_size);

errorbar(rad2deg(theta_green_rite), contrast_green_rite.mean, contrast_green_rite.sem, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
errorbar(x_icon, text_y(2), 0.035, ...
    'Marker', green_wrm_mrk, 'MarkerEdgeColor', green_color_bright, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', green_color_bright);
text(x_icon + text_x_offset, text_y(2), '629 nm', 'FontSize', font_size);

errorbar(rad2deg(theta_blue_rite), contrast_blue_rite.mean, contrast_blue_rite.sem, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
errorbar(x_icon, text_y(3), 0.035, ...
    'Marker', blue_wrm_mrk, 'MarkerEdgeColor', blue_color, 'MarkerSize', marker_size,...
    'LineWidth', Line_Width, 'LineStyle', 'none', 'Color', blue_color);
text(x_icon + text_x_offset, text_y(3), '629 nm', 'FontSize', font_size);


xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:15:90);
xlim([0 90])
ylabel('Contrast index', 'FontWeight', 'bold');
yticks(0:0.1:1);
ylim([0 1])
% title('\lambda-dependent img contrast for gellan gum');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


% t-test at peak contrast indices
[~, idx_max_red] = max(contrast_red_rite.mean);
[~, idx_max_green] = max(contrast_green_rite.mean);
[~, idx_max_blue] = max(contrast_blue_rite.mean);

disp("Under H0: red =< green for peak contrast indices,")
ttest2_from_summary( ...
    contrast_red_rite.mean(idx_max_red), contrast_red_rite.std(idx_max_red), contrast_red_rite.count(idx_max_red), ...
    contrast_green_rite.mean(idx_max_green), contrast_green_rite.std(idx_max_green), contrast_green_rite.count(idx_max_green), ...
    'welch', 'right');

disp("Under H0: green =< blue for peak contrast indices,")
ttest2_from_summary( ...
    contrast_green_rite.mean(idx_max_green), contrast_green_rite.std(idx_max_green), contrast_green_rite.count(idx_max_green), ...
    contrast_blue_rite.mean(idx_max_blue), contrast_blue_rite.std(idx_max_blue), contrast_blue_rite.count(idx_max_blue), ...
    'welch', 'right');

% save to statistic file
f_figS4F_stat = append(f_table_S1, '\FigS4F.xlsx');
saveStat(contrast_red_rite, theta_red_rite, f_figS4F_stat, '629nm', 'ctrst');
saveStat(contrast_green_rite, theta_green_rite, f_figS4F_stat, '516nm', 'ctrst');
saveStat(contrast_blue_rite, theta_blue_rite, f_figS4F_stat, '447nm', 'ctrst');
