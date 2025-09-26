%{ 
%% Helper function that perform BULK scattering and contrast analysis across 
%% BF, forward, and backscatter regime for one specific condition, i.e. red,
%% seeded, non-idx mat

It outputs a COMPLETE contrast and scattering function from 0 to pi (180
% deg)
%}

% Input args:
%   f_bf, f_fwrd, f_bck: string, containing the directory of dataset for
%       brightfield, forward scatter, back scatter, accordingly
%   power_data: table object containing power meter data
%   colot_str: string that represent what color is processing, it can be
%       'red', 'green', and 'blue'
%   PIC: pixel irradiance coefficient (PIC) unit: ADU*mm^2*sec^-1*µW^-1.
%   area_PM_sensor: Area of power meter sensor, unit: mm^2
%   plate_condition_str: string, indicating the plate condition, e.g. 'seeded, non-idx mat'


% returns:
%   theta_rad_out: theta values, from 0 to pi, unit: rad
%   contrast_out: computed contrast corresponding to each theta value, from 0 to pi
%   worm_SFunc_out: struct containing 'mean' and 'std'. Scattering function
%       for worms as a function of theta, from 0 to pi, unit: sr^-1
%   bg_SFunc_out: struct containing 'mean' and 'std'. Scattering function
%       for background as a function of theta, from 0 to pi, unit: sr^-1

function [theta_rad_out, contrast_out, worm_SFunc_out, bg_SFunc_out] = bulk_scatter_contrast_analysis(f_bf, f_fwrd, f_bck, power_data, color_str, PIC, area_PM_sensor, plate_condition_str)

%% Plot color string
red_color_str = [162, 20, 47] / 255;
green_color_str = [119, 172,  48] / 255;
blue_color_str = [0, 114, 189] / 255;

if (strcmp(color_str, 'red'))
    worm_plot_color = red_color_str;
elseif(strcmp(color_str, 'green'))
    worm_plot_color = green_color_str;
elseif(strcmp(color_str, 'blue'))
    worm_plot_color = blue_color_str;
end

bg_plot_color = [0.7 0.7 0.7]*0.7 + worm_plot_color*0.3;

%% forward scat including brgiht field
is_forward = true;

close all

data_BF = readtable(f_bf, 'Sheet', 'Sheet1');

data_fwrd = readtable(f_fwrd, 'Sheet', 'Sheet1');

all_data_fwrd = [data_BF; data_fwrd];

[theta_fwrd, contrast_fwrd, WSFC_fwrd, BSFC_fwrd] = ...
    scatter_contrast_analysis( ...
        all_data_fwrd, ...
        'Sheet1', ...
        power_data, ...
        color_str, ...
        PIC, ...
        area_PM_sensor, ...
        is_forward ...
    );

% WSFC = worm scattering function
% BSFC = background scattering function
%% Back scat
is_forward = false;

close all

[theta_bck, contrast_bck, WSFC_bck, BSFC_bck] = ...
    scatter_contrast_analysis( ...
        f_bck, ...
        'Sheet1', ...
        power_data, ...
        color_str, ...
        PIC, ...
        area_PM_sensor, ...
        is_forward ...
    );

%% Generate plots for contrast as a function of theta
close all

theta = [theta_fwrd; flipud(theta_bck)];

theta_rad = theta;
contrast = [contrast_fwrd; flipud(contrast_bck)];

% figure;
% plot(theta_rad, contrast, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'Color', worm_plot_color);
% 
% xlabel('\theta (rad)');
% ylabel('Contrast');
% title(append('Contrast (', color_str, ', ', plate_condition_str, ')'));
% grid on;


%% Generate plots for scattering function of theta

WSFC.mean = [WSFC_fwrd.mean; flipud(WSFC_bck.mean)];
WSFC.std  = [WSFC_fwrd.std;  flipud(WSFC_bck.std)];

BSFC.mean = [BSFC_fwrd.mean; flipud(BSFC_bck.mean)];
BSFC.std  = [BSFC_fwrd.std;  flipud(BSFC_bck.std)];

% figure;
% hold on;
% 
% errorbar(theta_rad, WSFC.mean, WSFC.std, '-o', 'DisplayName', 'Worm', 'LineWidth', 2, 'MarkerSize', 4, 'Color', worm_plot_color);
% errorbar(theta_rad, BSFC.mean, BSFC.std, '-o', 'DisplayName', 'background', 'LineWidth', 2, 'MarkerSize', 4, 'Color', bg_plot_color);
% 
% legend('show');
% xlabel('\theta (rad)');
% ylabel('p(\theta) (sr^{-1})');
% title(append('Scattering function (', color_str, ', ', plate_condition_str, ')'));
% yscale('log');
% grid on;
% hold off;


%% Generate plots for scattering function p(theta) and ring version of scattering function (2pi*sin(theta)*p(theta))
% calculate integral for ring version of scattering function from 0 to pi to
% check whether it closes to 1

%% For worm

% figure;
% hold on;
% 
% plot(theta_rad, WSFC.mean, '-o', 'DisplayName', 'p(\theta)', 'LineWidth', 2, 'MarkerSize', 4, 'Color', worm_plot_color);
% 
ring_WSFC = WSFC.mean * 2 * pi .* sin(theta_rad);
% plot(theta_rad, ring_WSFC, '-o', 'DisplayName', 'p(\theta)*2\pi*sin\theta', 'LineWidth', 2, 'MarkerSize', 4, 'Color', 'k');
% 
% legend('show');
% xlabel('\theta (rad)');
% ylabel('p(\theta), p(\theta)*2\pi*sin\theta');
% title(append('Scattering function (worm, ', color_str, ', ', plate_condition_str, ')'));
% yscale('log');
% grid on;
% hold off;

% compute integral of ring version of scattering function from 0 to pi
Integral_ring_WSFC = trapz(theta_rad, ring_WSFC);

disp(['Integral_ring_WSFC = ' num2str(Integral_ring_WSFC)]);

%% For background

% figure;
% hold on;
% 
% plot(theta_rad, BSFC.mean, '-o', 'DisplayName', 'p(\theta)', 'LineWidth', 2, 'MarkerSize', 4, 'Color', bg_plot_color);
% 
ring_BSFC = BSFC.mean * 2 * pi .* sin(theta_rad);
% plot(theta_rad, ring_BSFC, '-o', 'DisplayName', 'p(\theta)*2\pi*sin\theta', 'LineWidth', 2, 'MarkerSize', 4, 'Color', 'k');
% 
% legend('show');
% xlabel('\theta (rad)');
% ylabel('p(\theta), p(\theta)*2\pi*sin\theta');
% title(append('Scattering function (background, ', color_str, ', ', plate_condition_str, ')'));
% yscale('log');
% grid on;
% hold off;

Integral_ring_BSFC = trapz(theta_rad, ring_BSFC);

disp(['Integral_ring_BSFC = ' num2str(Integral_ring_BSFC)]);

%% returns
theta_rad_out = theta_rad;
contrast_out = contrast;
worm_SFunc_out = WSFC;
bg_SFunc_out = BSFC;
end