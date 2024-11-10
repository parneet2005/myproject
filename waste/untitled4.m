% Define the image and its dimensions
image = imread("C:\Users\547711\Documents\MontageOutput_2\montage_36.png");
[rows, cols, channels] = size(image);

% Define the desired angle range and the division angle
startAngle = 220;
endAngle = 360;
divisionAngle = 45;

% Create the mask
mask = zeros(rows, cols);

% Calculate the starting and ending indices for each quadrant
for i = 0:3
    % Calculate the current angle range
    currentRangeStart = startAngle + i * divisionAngle;
    currentRangeEnd = currentRangeStart + divisionAngle;
    if currentRangeEnd > endAngle
        currentRangeEnd = endAngle;
    end
    
    % Calculate the corresponding mask indices
    maskRows = floor(rows/2) + 1;
    maskCols = floor(cols/2) + 1;
    if i == 0
        maskRows = 1:floor(rows/2);
    elseif i == 1
        maskCols = 1:floor(cols/2);
    end
    
    % Set the mask values within the angle rang
    for angle = currentRangeStart:currentRangeEnd
        % Convert angle to radians
        angleRad = deg2rad(angle);
        
        % Calculate the mask indices based on the angle
        maskIndicesRow = round(maskRows - cos(angleRad) * maskRows);
        maskIndicesCol = round(maskCols + sin(angleRad) * maskCols);
        
        % Set the mask values within the calculated indices
        mask(sub2ind([rows, cols], maskIndicesRow, maskIndicesCol)) = 1;
    end
end

% Apply the mask to select the ROI
ROI = bsxfun(@times, image, cast(mask, class(image)));

% Display the ROI
imshow(ROI);

% Save the ROI as an image (optional)
% imwrite(ROI, 'roi_image.jpg');
