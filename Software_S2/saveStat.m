%% Helper function for saving statistic data to file

function saveStat(data_struct, theta_rad, f_out, sheet_name, data_type)

if (strcmp(data_type, 'sfc'))
    struct_to_save.theta_degrees = rad2deg(theta_rad);
    struct_to_save.mean_inverse_steradian = data_struct.mean;
    struct_to_save.std_inverse_steradian = data_struct.std;
    struct_to_save.sem_inverse_steradian = data_struct.sem;
    struct_to_save.sem_to_mean_ratio = (data_struct.sem)./data_struct.mean;
    struct_to_save.N = data_struct.count;
    fprintf('%s\n',sheet_name);
    fprintf('N = %d - %d\n', min(struct_to_save.N), max(struct_to_save.N));
    fprintf('The maximum SEM/Mean = %f\n\n',max(struct_to_save.sem_to_mean_ratio));
elseif (strcmp(data_type, 'ctrst'))
    struct_to_save.theta_degrees = rad2deg(theta_rad);
    struct_to_save.mean_contrast_index = data_struct.mean;
    struct_to_save.std_contrast_index = data_struct.std;
    struct_to_save.sem_contrast_index = data_struct.sem;
    struct_to_save.N = data_struct.count;
    fprintf('%s\n',sheet_name);
    fprintf('N = %d - %d\n', min(struct_to_save.N), max(struct_to_save.N));
    fprintf('The maximum SEM = %f\n\n', max(struct_to_save.sem_contrast_index));
else
    error('Unexpected data type! It must be either scf or ctrst!');
end

writetable(struct2table(struct_to_save), f_out, 'Sheet', sheet_name);
end