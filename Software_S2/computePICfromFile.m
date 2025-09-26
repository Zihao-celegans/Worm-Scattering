%% Helper function for reading files to compute pixel irradiance coefficient (PIC) unit: ADU*mm^2*sec^-1*µW^-1
function PIC_out = computePICfromFile(f_OFF, f_ON, expo, opt_pow_OFF, opt_pow_ON, Area_pow_sensor)

    % OFF
    [OFF_pixel_val, ~, ~] = computeAvgPixelValues(f_OFF);
    
    % ON
    [ON_pixel_val, ~, ~] = computeAvgPixelValues(f_ON);

    % Effective pixel value
    eff_pixel_val = ON_pixel_val - OFF_pixel_val;

    % Optical power measured from power meter
    opt_pow = opt_pow_ON - opt_pow_OFF;

    % return PIC
    PIC_out = computePIC(eff_pixel_val, expo, opt_pow, Area_pow_sensor);
    
end

%% Compute pixel irradiance coefficient (PIC) unit: ADU*mm^2*sec^-1*µW^-1

% pixel_val: pixel value, unit: ADU
% expo: exposure time of camera, unit: sec
% optical_power: optical power recevied by power meter, unit: µW
% Area_pow_sensor: area of sensor of power meter, unit: mm^2

function PIC = computePIC(pixel_val, expo, optical_power, Area_pow_sensor)

    PIC = pixel_val * Area_pow_sensor * (expo)^(-1) * (optical_power)^(-1);

end
%% Copmute Camera Power Per Optical Power (AUperSec/µW)
function CamPow_per_OptPow = computeCamPowPerOptPow(f_OFF, f_ON, expo, opt_pow_OFF, opt_pow_ON)

    % OFF
    [OFF_pixel_val, ~, ~] = computeAvgPixelValues(f_OFF);
    
    % ON
    [ON_pixel_val, ~, ~] = computeAvgPixelValues(f_ON);
    
    % Power measured from camera
    cam_pow = (ON_pixel_val - OFF_pixel_val) / expo;
    
    % Optical power measured from power meter
    opt_pow = opt_pow_ON - opt_pow_OFF;
    
    % Camera power per optical power
    CamPow_per_OptPow = cam_pow / opt_pow;

end

%% computeAvgPixelValues
function [avgVal_all, avgValues, filenames] = computeAvgPixelValues(imageFolder)
% computeAvgPixelValues  Compute the mean pixel value for each image in a folder.
%
%   [avgValues, filenames] = computeAvgPixelValues(imageFolder) returns:
%     • avgVal_all: a double number, mean over all the images' average
%                   pixel values
%     • avgValues : an N×1 vector of mean intensities, where N is the number
%                   of images found in imageFolder.
%     • filenames : an N×1 cell array of strings listing the image filenames.
%
%   The function looks for .png and .jpg files by default. You can edit the
%   extensions inside the function if needed.

    % Collect all .png and .jpg files in the folder
    pngList = dir(fullfile(imageFolder, '*.png'));
    jpgList = dir(fullfile(imageFolder, '*.jpg'));
    bmpList = dir(fullfile(imageFolder, '*.bmp'));
    fileList = [pngList; jpgList; bmpList];
    
    nFiles = numel(fileList);
    avgValues = zeros(nFiles, 1);
    filenames = cell(nFiles, 1);
    
    for k = 1:nFiles
        % Full path of the k-th image
        fullName = fullfile(imageFolder, fileList(k).name);
        filenames{k} = fileList(k).name;
        
        % Read image and convert to double for accurate averaging
        I = imread(fullName);
        I = double(I);
        
        % Compute mean over all pixels (and all channels, if RGB)
        avgValues(k) = mean(I(:));
    end

    % compute mean over all the images
    avgVal_all = mean(avgValues);
end