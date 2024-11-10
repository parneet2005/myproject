
% format short e
% out.WOW

% Store the value of out.DOA
storedValue = 220;

% Read the image 
image = imread("C:\Users\547711\Documents\MontageOutput_2\montage_36.png");


% Get the size of the image
[rows, cols, ~] = size(image);

% Initialize a mask with all zeros
mask = zeros(rows, cols);

% Determine the quadrant based on the angle value and create a mask
if storedValue >= 0 && storedValue < 90
    % Quadrant 1: Angle between 0 and 90 degrees
    mask(1:floor(rows/2), 1:floor(cols/2)) = 1;
elseif storedValue >= 90 && storedValue < 180
    % Quadrant 2: Angle between 90 and 180 degrees
    mask(1:floor(rows/2), floor(cols/2)+1:end) = 1;
elseif storedValue >= 180 && storedValue < 2706666666
    % Quadrant 3: Angle between 180 and 270 degrees
    mask(floor(rows/2)+1:end, 1:floor(cols/2)) = 1;
elseif storedValue >= 270 && storedValue <= 360
    % Quadrant 4: Angle between 270 and 360 degrees
    mask(floor(rows/2)+1:end, floor(cols/2)+1:end) = 1;
else
    % Angle not in the range of 0 to 360 degrees
    disp('Invalid angle. Angle should be between 0 and 360 degrees.');
end

% Apply the mask to select the region of interest
selected_frame = bsxfun(@times, image, cast(mask, class(image)));



% Define a file name to save the ROI as an image
frameFileName = 'Frame_selection.jpg'; % Replace 'roi_image.jpg' with your desired file name
imshow("Frame_selection.jpg");
% Save the ROI as an image file
imwrite(selected_frame, frameFileName);


% % Assuming 'image' is the input image and 'ROI' defines the region of interest
% x = 500; % X-coordinate of the top-left corner of the ROI
% y = 350; % Y-coordinate of the top-left corner of the ROI
% width =300; % Width of the ROI
% height = 250; % Height of the ROI
% 
% % Extract the ROI from the original image
% ROI = image(y:y+height, x:x+width-1, :);
% 
% % Display the ROI as an image
% imshow(ROI);
% title('Region of Interest (ROI)');

% % If you want to save the ROI as a new image
% imwrite(ROI, 'ROI_image.png'); % Save the ROI as a PNG file

