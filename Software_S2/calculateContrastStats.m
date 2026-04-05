function resultTable = calculateContrastStats(dataTable)
    % Clean the Category column by removing any literal single quotes
    % This prevents matching errors if the strings imported as "'worm'"
    cleanCategories = strrep(string(dataTable.Category), "'", "");
    
    % Separate the table into worm and background rows
    wormData = dataTable(cleanCategories == "worm", :);
    bgData = dataTable(cleanCategories == "background", :);
    
    % Verify that we have matching pairs
    if height(wormData) ~= height(bgData)
        error('Mismatch in number of "worm" and "background" rows. Cannot form perfect pairs.');
    end
    
    % Calculate the Contrast for each pair
    contrastValues = (wormData.Mean - bgData.Mean)./ (wormData.Mean + bgData.Mean);
    
    % Create a temporary table with just the Position and the new Contrast values
    tempTable = table(wormData.Position, contrastValues, ...
        'VariableNames', {'Position', 'Contrast'});
    
    % Group by 'Position' and calculate the mean and standard deviation
    % groupsummary automatically creates the exact column names you requested!
    resultTable = groupsummary(tempTable, 'Position', {'mean', 'std'}, 'Contrast');

    % ADD THE NEW CATEGORY COLUMN HERE
    resultTable.Category = repmat("contrast", height(resultTable), 1);
end