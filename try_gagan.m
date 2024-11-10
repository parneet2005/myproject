
% Read the image 
image = imread("C:\Users\547711\Documents\img\scenario3\images_front\280.png");

% Assuming 'image' is the input image and 'ROI' defines the region of interest
x = 780; % X-coordinate of the top-left corner of the ROI
y = 200; % Y-coordinate of the top-left corner of the ROI
width =200; % Width of the ROI
height = 300; % Height of the ROI

% % Extract the ROI from the original image
% ROI = image(:, x:x+width-1, :);
% 
% % Display the ROI as an image
% imshow(ROI);
% title('Region of Interest (ROI)');
% 
% % If you want to save the ROI as a new image
% imwrite(ROI, 'ROI_image.png'); % Save the ROI as a PNG file

mask = zeros(size(image, 1), size(image, 2)); % Initialize a mask with zeros
mask(y:y+height-1, x:x+width-1) = 1; % Set the ROI region to 1 in the mask

% Apply the mask to the RGB image
masked_image = bsxfun(@times, image, cast(mask, class(image)));

% Display the masked image
imshow(masked_image);
title('Masked Image');

% If you want to save the masked image
imwrite(masked_image, 'ROI_image2.png'); % Save the masked image as a PNG file