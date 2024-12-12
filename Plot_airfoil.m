data = load('A320-200_airfoil.dat'); % Replace 'filename.dat' with your file name

sorted_data = sortrows(data, 1); % Sort by the first column

% Find the greatest element in the first row
max_val = max(sorted_data(:, 1)); % Maximum value in the first row

% Divide all values in the sorted data by this maximum value
normalized_data = sorted_data / max_val;

% Separate rows based on the sign of y
positive_y = normalized_data(normalized_data(:, 2) > 0, :); % Rows where y > 0
negative_y = normalized_data(normalized_data(:, 2) < 0, :); % Rows where y < 0

% Sort positive_y rows in descending order of x
positive_y_sorted = sortrows(positive_y, 1);
positive_y_sorted(1,2) = 0;
positive_y_sorted(1,1) = 0;
positive_y_sorted(end,2) = 0;

% Sort negative_y rows in descending order of x
negative_y_sorted = sortrows(negative_y, -1);
negative_y_sorted(1,2) = 0;
negative_y_sorted(end,1) = 0;
negative_y_sorted(end,2) = 0;

% Combine the sorted subsets
rearranged_data = [positive_y_sorted; negative_y_sorted];

% Save the rearranged dataset to a file
save('A320-200_rearranged.dat', 'rearranged_data', '-ascii');

% Extract normalized x and y coordinates
x = rearranged_data(:, 1); % First column (x)
y = rearranged_data(:, 2); % Second column (y)

figure; % Create a new figure
plot(x, y, 'o-', 'LineWidth', 1.5); % Plot with markers and lines
xlabel('X Coordinate'); % Label for X-axis
ylabel('Y Coordinate'); % Label for Y-axis
title('Coordinates from .dat File'); % Add a title
grid on; % Enable grid for better visualization