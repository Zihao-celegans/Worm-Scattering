%% Helper function that perform contrast analysis of worm and background, using power meter data as a normalization factor

% Input args:
% in_data_worm_bg: worm and background image summary data, it can be a file
%   path string or a table object
% sheet_name: sheet name of the data loacted at. The variable is ONLY used
%   when "in_data_worm_bg" is a file path string.
% power_data: table object containing power meter data
% colot_str: string that represent what color is processing, it can be
%   'red', 'green', and 'blue'
% PIC: pixel irradiance coefficient (PIC) unit: ADU*mm^2*sec^-1*µW^-1.
% area_PM_sensor: Area of power meter sensor, unit: mm^2
% is_forward: whether it is forward scattering, it affects how the incident
%   angle is computed

% returns:
% theta_out: theta values, unit: rad
% contrast_out: computed contrast corresponding to each theta value
% worm_ScatFunc: struct containing 'mean' and 'std'. Scattering function
%   for worms as a function of theta, unit: sr^-1
% bg_ScatFunc: struct containing 'mean' and 'std'. Scattering function
%   for background as a function of theta, unit: sr^-1

function [theta_out, contrast_out, worm_ScatFunc, bg_ScatFunc] = scatter_contrast_analysis(in_data_worm_bg, sheet_name, power_data, color_str, PIC, area_PM_sensor, is_forward)

%% hardcoded geometery params for conversion from position reading to incident angle theta
% refer to comput_incident_angle.m for detail explanation of each params

radius_LED = 95 * 0.5;

if (is_forward == true)
    max_pos_read_cm = 51;
    mini_dist_mm = 15;
else
    max_pos_read_cm = 0;
    mini_dist_mm = 7;
end
%% hardcoded params for imaging setup
% Magnification. Unit: dimensionless
Mag = 179.85075 * 2.2 * 10^(-3) / 1;

% Focal length
Focal_leng = 105; % Unit: mm

% F-number
F_num = 16;

% Diameter of Iris
D_iris = Focal_leng / F_num; % Unit: mm

% Area of Iris
Area_iris = pi * (D_iris/2)^2;  % Unit: mm^2

% Distance between the lens and plate
Dist_Lens_plate = 40 * 10; % Unit: mm

% Solid angle of Iris
Omega_iris = Area_iris / (Dist_Lens_plate)^2; % Unit: sr

%% Part 1: Compute optical power idx as a function of theta

% Read input data
if (isa(in_data_worm_bg,'char'))
    % read into a table object if a file name is provided
    worm_bg_data = readtable(in_data_worm_bg, 'Sheet', sheet_name);
elseif (isa(in_data_worm_bg,'table'))
    % copy the data if the data is a table object already
    worm_bg_data = in_data_worm_bg;
end

% Verify variable names (should show: {'Position'}, {'Category'}, {'Mean'} for data,
% and {'Position'}, {'Reading'} for readings)
disp(worm_bg_data.Properties.VariableNames);
disp(power_data.Properties.VariableNames);

% Divide the 'mean' pixel value by 'exposure' time to get mean_per_sec
% (power measured by camera). Unit: AU*Sec^(-1)
if (is_forward == true && ~ismember('Exposure', worm_bg_data.Properties.VariableNames))
    worm_bg_data.Mean_per_sec = worm_bg_data.Mean / 0.125;
    disp('Exposure time is set to 0.125s by default!');
else
    worm_bg_data.Mean_per_sec = worm_bg_data.Mean ./ worm_bg_data.Exposure;
end


% Divide the pixel value (ADU) by the product of exposure time (sec)
% and pixel irradiance coefficient (PIC, unit: ADU*mm^2*sec^-1*µW^-1)
% to get irradiance on pixel (µW * mm^-2)

% Copmute resultant optical power
worm_bg_data.Irradiance = worm_bg_data.Mean_per_sec / PIC;

% Group the experimental data by Position and Category, computing mean and standard deviation of 'Mean'
grpStats = groupsummary(worm_bg_data, {'Position','Category'}, {'mean','std'}, 'Irradiance');

% Separate the grouped data into worm and background categories
wormData = grpStats(strcmp(grpStats.Category, 'worm'), :);
backgroundData = grpStats(strcmp(grpStats.Category, 'background'), :);

% interpolate the power reading as a function of theta
max_pos_read_cm_power_data = 51;
mini_dist_mm_power_data = 15;
power_data.Theta = comput_incident_angle(power_data.Position, radius_LED, max_pos_read_cm_power_data, mini_dist_mm_power_data);
power_data.Theta = round(power_data.Theta,1);

% Incident power, unit: µW
power_data.incident_power = (power_data.Corrected_reading .* power_data.N_LED_used) ./ power_data.N_LED_measured;

% Divide Incident power by area of power meter sensor to get incident
% irradiance, unit: µW*mm^-2
power_data.incident_irradiance = power_data.incident_power / area_PM_sensor;

[fitresult, ~] = createPowerFit(power_data.Theta, power_data.incident_irradiance);

% create a table object for the interpolated power data
interp_theta = 0:0.1:90;
interp_incident_irradiance = fitresult(interp_theta);
% figure
% plot(interp_theta, interp_incident_irradiance);
interp_irradiance_data = table(round(interp_theta',1), interp_incident_irradiance, ...
           'VariableNames', {'view_LED_Theta','incident_irradiance'} );

% Convert Position to Theta for worm data and background data
if (is_forward == true)
    wormData.view_LED_Theta = round(comput_incident_angle(wormData.Position, radius_LED, max_pos_read_cm, mini_dist_mm),1);
    wormData.Theta = wormData.view_LED_Theta;
    backgroundData.view_LED_Theta = round(comput_incident_angle(backgroundData.Position, radius_LED, max_pos_read_cm, mini_dist_mm),1);
    backgroundData.Theta = backgroundData.view_LED_Theta;
else
    wormData.view_LED_Theta = round(comput_incident_angle(-wormData.Position, radius_LED, max_pos_read_cm, mini_dist_mm),1);
    wormData.Theta = 180 - wormData.view_LED_Theta;
    backgroundData.view_LED_Theta = round(comput_incident_angle(-backgroundData.Position, radius_LED, max_pos_read_cm, mini_dist_mm),1);
    backgroundData.Theta = 180 - backgroundData.view_LED_Theta;
end

% Join each group with the readings data based on 'Position'
% (Using innerjoin assumes every Position in grpStats has a matching Reading.)

% based on theta instead
wormData = innerjoin(wormData, interp_irradiance_data, 'Keys', 'view_LED_Theta');
backgroundData = innerjoin(backgroundData, interp_irradiance_data, 'Keys', 'view_LED_Theta');


% Compute scattering function ScatFunc (Unit: sr^-1) for worm and background
wormData.ScatFunc_Mean = (wormData.mean_Irradiance ./ wormData.incident_irradiance) * Mag^2 / Omega_iris;
wormData.ScatFunc_Std = (wormData.std_Irradiance ./ wormData.incident_irradiance) * Mag^2 / Omega_iris;
backgroundData.ScatFunc_Mean = (backgroundData.mean_Irradiance ./ backgroundData.incident_irradiance) * Mag^2 / Omega_iris;
backgroundData.ScatFunc_Std = (backgroundData.std_Irradiance ./ backgroundData.incident_irradiance) * Mag^2 / Omega_iris;


% Plot the scattering function with error bars (standard deviation) as a function of Theta
% figure;
% errorbar(wormData.Theta, wormData.ScatFunc_Mean, wormData.ScatFunc_Std, '-o', 'DisplayName', 'Worm', 'LineWidth', 2, 'MarkerSize', 8);
% hold on;
% errorbar(backgroundData.Theta, backgroundData.ScatFunc_Mean, backgroundData.ScatFunc_Std, '-o', 'DisplayName', 'Background', 'LineWidth', 2, 'MarkerSize', 8);
% xlabel('Theta (degrees)');
% ylabel('p(\theta) (sr^{-1})');
% legend('show');
% title(strcat('Scattering Function (', color_str, ')'));
% hold off;

% return values
worm_ScatFunc.mean = wormData.ScatFunc_Mean;
worm_ScatFunc.std = wormData.ScatFunc_Std;

bg_ScatFunc.mean = backgroundData.ScatFunc_Mean;
bg_ScatFunc.std = backgroundData.ScatFunc_Std;

%% Part 2: Compute and Plot Contrast vs. Theta

% Ensure the Theta values match between worm and background
if ~isequal(wormData.Theta, backgroundData.Theta)
    error('Theta values for worm and background do not match.');
end

% Compute contrast
contrast = (wormData.ScatFunc_Mean - backgroundData.ScatFunc_Mean) ./ (wormData.ScatFunc_Mean + backgroundData.ScatFunc_Mean);

% Plot contrast vs. Theta
% figure;
% 
% if (strcmp(color_str, 'red'))
%     plot_color = "#A2142F";
% elseif(strcmp(color_str, 'green'))
%     plot_color = "#77AC30";
% elseif(strcmp(color_str, 'blue'))
%     plot_color = "#0072BD";
% end
% 
% plot(wormData.Theta, contrast, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'Color', 	plot_color);
% xlabel('Theta (degrees)');
% ylabel('Contrast');
% title(strcat('Contrast vs. Theta (', color_str, ')'));

% return values
theta_out = deg2rad(wormData.Theta);
contrast_out = contrast;

end