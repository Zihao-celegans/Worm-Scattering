%% Helper function that converts position reading from the post to incident angle theta

% Input args
% input_array_pos_read_cm: position reading read from the post, unit: cm
% radius_LED: radius of the LED ring, unit: mm
% max_pos_read_cm: maximum position reading written on the post, unit:cm
% mini_dist_mm: reachable minimal distance (in vertical) between the LED
%   ring and the worm/object. This value coresponding to the distance
%   measured when the LED is positioned at "max_pos_read_cm". unit: mm

% Output
% theta: incident angle of light, unit: degree

function theta = comput_incident_angle(input_array_pos_read_cm, radius_LED, max_pos_read_cm, mini_dist_mm)

theta = rad2deg(atan(radius_LED ./ (mini_dist_mm + (max_pos_read_cm - input_array_pos_read_cm) * 10)));

end