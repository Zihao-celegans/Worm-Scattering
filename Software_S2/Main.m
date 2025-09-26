%% Software S2
%
% Source MATLAB scripts for the data analysis performed in the manuscript
% "Mechanisms of volume and surface light scattering from Caenorhabditis 
% elegans revealed by angle-resolved measurements"
% written by Zihao (John) Li and Christopher Fang-Yen (2025)
%
% Please run this script session by session
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set parameters
clc
close all
clear

% Set directories, modify the following according to your device
% The main working directory should be set to the folder containing "Main.m"
main_work_dir = 'C:\Users\Yuchi\Dropbox\Publication\WormScatter\Supplement\Software_S2';
% The folder containing the raw data (Dataset S1)
f_dataset_S1 = 'C:\Users\Yuchi\Dropbox\Publication\WormScatter\Supplement\Dataset_S1';

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

% Plot the scattering functions
close all
marker_size = 120;
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
%% Generation of Fig. 1D
close all
marker_size = 120;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 85;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:1]);

figure;
hold on;
scatter(rad2deg(theta_red_seed), contrast_red_seed, 'o', ...
    'SizeData', marker_size, 'DisplayName', 'Worm on seeded agar', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width);
scatter(x_icon, text_y(1), 'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), 'Worm on seeded agar', 'FontSize', font_size);

scatter(rad2deg(theta_red_unseed), contrast_red_unseed, '+', ...
    'SizeData', marker_size, 'DisplayName', 'Worm on unseeded agar', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width);
scatter(x_icon, text_y(2), '+', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width);
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

%% Generation of Fig. 1E

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


% Plot scattering functions for RGB, Seeded
close all
marker_size = 70;
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

close all

marker_size = 120;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;


x_icon = 140;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:2]);

red_wrm_mrk = 'o';
green_wrm_mrk = 'o';
blue_wrm_mrk = 'o';

figure;
hold on;

scatter(rad2deg(theta_red_seed), contrast_red_seed, red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, 'DisplayName', '629 nm', 'MarkerFaceColor', red_color);
scatter(x_icon, text_y(1), red_wrm_mrk, ...
    'filled', 'SizeData', marker_size, 'MarkerFaceColor', red_color, 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), '629 nm', 'FontSize', font_size);


scatter(rad2deg(theta_green_seed), contrast_green_seed, green_wrm_mrk, ...
    'filled', 'SizeData', marker_size, 'DisplayName', '516 nm', 'MarkerFaceColor', green_color);
scatter(x_icon, text_y(2), green_wrm_mrk, ...
    'filled', 'SizeData', marker_size, 'MarkerFaceColor', green_color, 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(2), '516 nm', 'FontSize', font_size);


scatter(rad2deg(theta_blue_seed), contrast_blue_seed, blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, 'DisplayName', '447 nm', 'MarkerFaceColor', blue_color);
scatter(x_icon, text_y(3), blue_wrm_mrk, ...
    'filled', 'SizeData', marker_size, 'MarkerFaceColor', blue_color, 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(3), '447 nm', 'FontSize', font_size);


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


%% Generation of Fig. 2C

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


% plot the Scattering functions

close all;
marker_size = 120;
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

close all
figure;
hold on;

marker_size = 120;
Line_Width = 1.5;
font_size = 14;
tick_len = 0.02;

x_icon = 150;
text_x_offset = 7;
text_y = (0.85 - 0.2 * [0:1]);


scatter(rad2deg(theta_red_seed), contrast_red_seed, 'o', ...
    'SizeData', marker_size, 'DisplayName', 'Non-IM', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width);
scatter(x_icon, text_y(1), 'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width);
text(x_icon + text_x_offset, text_y(1), 'Non-IM', 'FontSize', font_size);


scatter(rad2deg(theta_red_seed_idxMat), contrast_red_seed_idxMat, '+', ...
    'SizeData', marker_size, 'DisplayName', 'IM', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width);
scatter(x_icon, text_y(2), '+', ...
    'SizeData', marker_size, 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width);
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

%% Generation of Fig. 2E

% Read the Zemax optical simulation data
f_offline_zmx_data = append(f_dataset_S1, '\Zemax\WSFC_zemax_N_10.mat');
load(f_offline_zmx_data);

mean_theta_zemax_idxMat_N = mean(theta_zemax_idxMat_N, 1);
mean_WSFC_zemax_idxMat_N  = mean(WSFC_zemax_idxMat_N,  1);
std_WSFC_zemax_idxMat_N   = std(WSFC_zemax_idxMat_N, 0, 1);

mean_theta_zemax_full_N = mean(theta_zemax_full_N, 1);
mean_WSFC_zemax_full_N = mean(WSFC_zemax_full_N, 1);
std_WSFC_zemax_full_N = std(WSFC_zemax_full_N, 0, 1);

mean_theta_zemax_ext_N = mean(theta_zemax_ext_N, 1);
mean_WSFC_zemax_ext_N = mean(WSFC_zemax_ext_N, 1);
std_WSFC_zemax_ext_N = std(WSFC_zemax_ext_N, 0, 1);


% plot the scattering functions

close all;
marker_size = 120;
Line_Width = 2;
font_size = 14;
tick_len = 0.02;

x_icon = 90;
text_x_offset = 12;
text_y = 10.^(2.5 - 0.45 * [0:3]);

figure;
hold on;


errorbar(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N, std_WSFC_zemax_idxMat_N,...
    'LineWidth', 2, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(4), 5.5,...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-10 x_icon+10], [text_y(4)-1 text_y(4)-1],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(4)-1, 'Model, IM', 'FontSize', font_size);


errorbar(mean_theta_zemax_full_N,mean_WSFC_zemax_full_N,std_WSFC_zemax_full_N,...
    'LineWidth', 2, 'Color', [0 0.9 0]);
errorbar(x_icon, text_y(2), 40,...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
line([x_icon-10 x_icon+10], [text_y(2)-5 text_y(2)-5],...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
text(x_icon + text_x_offset, text_y(2)-5, 'Model, non-IM', 'FontSize', font_size);


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
ylim(10.^[-3 3])
% title('Scat. func. of worm (Exp. vs. Model)');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;

%% Generation of Fig. 2F

close all;
Line_Width = 2;
font_size = 14;
tick_len = 0.02;

x_icon = 85;
text_x_offset = 12;
text_y = 10.^(2.5 - 0.45 * [0:3]);

figure;
hold on;

errorbar(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N, std_WSFC_zemax_idxMat_N,...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
errorbar(x_icon, text_y(2), 40,...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
line([x_icon-10 x_icon+10], [text_y(2)-5 text_y(2)-5],...
    'LineWidth', Line_Width, 'Color', [0 0.1 1]);
text(x_icon + text_x_offset, text_y(2)-5, 'Volume scat. (VS)', 'FontSize', font_size);


errorbar(mean_theta_zemax_full_N,mean_WSFC_zemax_full_N,std_WSFC_zemax_full_N,...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
errorbar(x_icon, text_y(1), 120,...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
line([x_icon-10 x_icon+10], [text_y(1) text_y(1)]-25,...
    'LineWidth', Line_Width, 'Color', [0 0.9 0]);
text(x_icon + text_x_offset, text_y(1)-25, 'Complete scat.', 'FontSize', font_size);


errorbar(mean_theta_zemax_ext_N,mean_WSFC_zemax_ext_N,std_WSFC_zemax_ext_N,...
    'LineWidth', Line_Width, 'Color', [0.9 0.2 0]);
errorbar(x_icon, text_y(3), 15,...
    'LineWidth', Line_Width, 'Color', [0.9 0.2 0]);
line([x_icon-10 x_icon+10], [text_y(3)-2 text_y(3)-2],...
    'LineWidth', Line_Width, 'Color', [0.9 0.2 0]);
text(x_icon + text_x_offset, text_y(3)-2, 'Surface scat. (SS)', 'FontSize', font_size);


brightness = 0.5;
plot(mean_theta_zemax_idxMat_N, mean_WSFC_zemax_idxMat_N + mean_WSFC_zemax_ext_N, '--*', ...
    'Color', brightness * ones(1, 3), 'LineWidth', Line_Width);
plot([x_icon-10 x_icon+10], [text_y(4)-1 text_y(4)-1], '--',...
    'Color', brightness * ones(1, 3), 'LineWidth', Line_Width);
scatter(x_icon, text_y(4)-1, '.', 'SizeData', 550, ...
    'MarkerEdgeColor', brightness * ones(1, 3));
text(x_icon + text_x_offset, text_y(4)-1, 'VS + SS', 'FontSize', font_size);

xlabel('\theta (degrees)', 'FontWeight', 'bold');
xticks(0:30:180);
ylabel('p(\theta) (sr^{-1})', 'FontWeight', 'bold');
yticks(10.^(-3:3));
ylim(10.^[-3 3])
% title('Interplay between vol. & surf. scattering');
yscale('log');
pbaspect([1.2 1 1])
ax = gca;
ax.FontSize = font_size;
ax.TickLength = [tick_len, 0];
hold off;


%% Generation of Fig. 3B

% Read the spatial data for the non-index matching
f_spatial_data = append(f_dataset_S1, '\Spatial_distribution\Spatial_nonIdxMat.mat');
load(f_spatial_data);


% Hardcoded params for dimension conversion
% Experiment
Mag_exp = 179.85075 * 2.2 * 10^(-3) / 1;
pix_size_exp = 2.2; % Unit: μm

% Zemax
Mag_zemax = 142.37/400;
pix_size_zemax = 0.44 * 1000 / 200; % Unit: μm


% plot the representative profiles
close all;
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
    plot(x_ax_micron_zemax, repProfile_Zemax_N{rep_rnds_zemax}(i, :), '--k', 'LineWidth', Line_Width);

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


% Hardcoded params for dimension conversion
% Experiment
Mag_exp = 179.85075 * 2.2 * 10^(-3) / 1;
pix_size_exp = 2.2; % Unit: μm

% Zemax
Mag_zemax = 142.37/400;
pix_size_zemax = 0.44 * 1000 / 200; % Unit: μm


% plot the representative profiles
close all;
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
    plot(x_ax_micron_zemax_idxMat, repProfile_Zemax_N_idxMat{rep_rnds_zemax_idxMat}(i, :), '--k', 'LineWidth', Line_Width);

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

close all;
mean_theta_xsec_Zemax_N = mean(theta_xsec_Zemax_N, 1);
mean_shapeIdx_Zemax_N = mean(shapeIdx_Zemax_N, 1);
std_shapeIdx_Zemax_N = std(shapeIdx_Zemax_N, 0, 1);

marker_size = 120;
Line_Width = 2;
font_size = 14;
tick_len = 0.02;

x_icon = 80;
text_x_offset = 15;
text_y = (0.9 - 0.15 * [0:1]);


figure;
hold on


scatter(theta_xsec_exp, shapeIdx_exp,'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'o', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Experiment, non-IM', 'FontSize', font_size);


errorbar(mean_theta_xsec_Zemax_N,mean_shapeIdx_Zemax_N,std_shapeIdx_Zemax_N, ...
    '--k', 'LineWidth', Line_Width);
errorbar(x_icon, text_y(2), 0.04, ...
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

%% Generation of Fig. 3F

close all
mean_theta_xsec_Zemax_N_idxMat = mean(theta_xsec_Zemax_N_idxMat, 1);
mean_shapeIdx_Zemax_N_idxMat = mean(shapeIdx_Zemax_N_idxMat, 1);
std_shapeIdx_Zemax_N_idxMat = std(shapeIdx_Zemax_N_idxMat, 0, 1);

marker_size = 120;
Line_Width = 2;
font_size = 14;
tick_len = 0.02;

x_icon = 105;
text_x_offset = 15;
text_y = (0.9 - 0.15 * [0:1]);

figure;
hold on;

scatter(theta_xsec_exp_idxMat, shapeIdx_exp_idxMat,'d', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),'d', ...
    'SizeData', marker_size, 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(1), 'Experiment, IM', 'FontSize', font_size);


errorbar(mean_theta_xsec_Zemax_N_idxMat,mean_shapeIdx_Zemax_N_idxMat,std_shapeIdx_Zemax_N_idxMat, ...
    '--k', 'LineWidth', Line_Width);
errorbar(x_icon, text_y(2), 0.04, ...
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

%% Generation of Fig. 5A

is_forward = true;

close all

% Agar, red
f_red_agar = ...
    append(f_dataset_S1, '\Substrate_RGB\Agar\red\data.xlsx');

[theta_red_agar, contrast_red_agar, WSFC_red_agar, BSFC_red_agar] = ...
    scatter_contrast_analysis(f_red_agar, 'Sheet1', red_power_data, 'red', PIC_red, Area_PM_sensor, is_forward);

% Gelatin, red
f_red_gelatin = ...
    append(f_dataset_S1, '\Substrate_RGB\Gelatin\red\data.xlsx');

[theta_red_gelatin, contrast_red_gelatin, WSFC_red_gelatin, BSFC_red_gelatin] = ...
    scatter_contrast_analysis(f_red_gelatin, 'Sheet1', red_power_data, 'red', PIC_red, Area_PM_sensor, is_forward);

% Gellan gum, red
f_red_rite = ...
    append(f_dataset_S1, '\Substrate_RGB\Rite\red\data.xlsx');

[theta_red_rite, contrast_red_rite, WSFC_red_rite, BSFC_red_rite] = ...
    scatter_contrast_analysis(f_red_rite, 'Sheet1', red_power_data, 'red', PIC_red, Area_PM_sensor, is_forward);


% plot the scattering functions

agar_mark_shape_fig = 'o';
gelatin_mark_shape_fig = '>';
rite_mark_shape_fig = '+';

marker_size = 120;
Line_Width = 1.5;
font_size = 13;
tick_len = 0.02;

x_icon = 60;
text_x_offset = 5;
text_y = 10.^(0.8 - 0.25 * [0:5]);


figure;
hold on;


scatter(rad2deg(theta_red_agar), WSFC_red_agar.mean,agar_mark_shape_fig, ...
    'SizeData', marker_size, 'DisplayName', 'Worm on agar', 'MarkerEdgeColor', red_color, 'LineWidth', Line_Width)
scatter(x_icon, text_y(1),agar_mark_shape_fig, ...
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


scatter(rad2deg(theta_red_agar), BSFC_red_agar.mean,agar_mark_shape_fig, ...
    'filled', 'SizeData', marker_size, 'DisplayName', 'Agar', 'MarkerFaceColor', red_color)
scatter(x_icon, text_y(4),agar_mark_shape_fig, ...
    'filled', 'SizeData', marker_size, 'MarkerFaceColor', red_color)
text(x_icon + text_x_offset, text_y(4), 'Agar', 'FontSize', font_size);


scatter(rad2deg(theta_red_gelatin), BSFC_red_gelatin.mean,gelatin_mark_shape_fig, ...
    'filled', 'SizeData', marker_size, 'DisplayName', 'Gelatin', 'MarkerFaceColor', red_color)
scatter(x_icon, text_y(5),gelatin_mark_shape_fig, ...
    'filled', 'SizeData', marker_size, 'MarkerFaceColor', red_color)
text(x_icon + text_x_offset, text_y(5), 'Gelatin', 'FontSize', font_size);


scatter(rad2deg(theta_red_rite), BSFC_red_rite.mean,'Pentagram', ...
    'SizeData', marker_size, 'DisplayName', 'Gellan gum', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
scatter(x_icon, text_y(6),'Pentagram', ...
    'SizeData', marker_size, 'DisplayName', 'Gellan gum', 'MarkerEdgeColor', 'k', 'LineWidth', Line_Width)
text(x_icon + text_x_offset, text_y(6), 'Gellan gum', 'FontSize', font_size);


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


%% Generation of Fig. 5B

is_forward = true;

close all

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



% barchat for contrast for different plates RGB

plate_contrast_data = [...
    contrast_blue_agar, contrast_blue_gelatin, contrast_blue_rite;...
    contrast_green_agar, contrast_green_gelatin, contrast_green_rite;...
    contrast_red_agar, contrast_red_gelatin, contrast_red_rite;...
    ];

group_inx = [ones(1,size(contrast_blue_agar,1)), ...
    2.*ones(1,size(contrast_green_agar,1)), ...
    3.*ones(1,size(contrast_red_agar,1))];


c =  [blue_color;...
      green_color;...
      red_color];  

group_names = {'447 nm', '516 nm' , '629 nm'};
condition_names = {'Agar', 'Gelatin' , 'Gellan gum'};

h_plate_contrast = dabarplot(plate_contrast_data,'groups',group_inx,...
    'xtlabels', condition_names,'errorbars',0,...
    'scatter',1,'scattersize',80,'scatteralpha',0.5,...
    'barspacing',0.8, 'colors',c, 'baralpha', 0.6); 
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