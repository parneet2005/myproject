% 
% location = 'C:\Users\547711\Documents\img\images_back';       %  folder in which your images exists
% ds = imageDatastore(location) ;       %  Creates a datastore for all images in your folder
% while hasdata(ds) 
%     img = read(ds) ;             % read image from datastore
%     figure, imshow(img);    % creates a new window for each image
% end
% Define paths to the four folders
% folderPaths = {"C:\Users\547711\Documents\img\images_front", ...
%                "C:\Users\547711\Documents\img\images_back", ...
%                "C:\Users\547711\Documents\img\images_right", ...
%                "C:\Users\547711\Documents\img\images_left"};
% 
% % Initialize an empty cell array to store the first images
% firstImages = cell(1, numel(folderPaths));
% 
% % Read the first image from each folder
% for i = 1:numel(folderPaths)
%     % Get the image file list in the folder
%     imageFiles = dir(fullfile(folderPaths{i}, '*.png')); % Update file extension if needed
% 
%     % Check if there are any image files in the folder
%     if ~isempty(imageFiles)
%         % Read the first image in the folder
%         firstImage = imread(fullfile(folderPaths{i}, imageFiles(1).name));
% 
%         % Store the first image in the cell array
%         firstImages{i} = firstImage;
%     else
%         % Handle the case where no images are found in the folder
%         fprintf('No images found in folder %d\n', i);
%     end
% end
% 
% % Create a montage of the first images
% montageImages = cat(4, firstImages{:});
% montage(montageImages, 'Size', [2, 2]); % Adjust montage size if needed
% Define paths to the four folders
% Define paths to the four folders
folderPaths = {"C:\Users\547711\Documents\img\images_front", ...
               "C:\Users\547711\Documents\img\images_back", ...
               "C:\Users\547711\Documents\img\images_right", ...
               "C:\Users\547711\Documents\img\images_left"};

% Define the output directory for saving montages
outputDirectory = 'C:\Users\547711\Documents\img\MontageOutput'; % Update with your desired output directory
if ~exist(outputDirectory, 'dir')
    mkdir(outputDirectory); % Create the directory if it doesn't exist
end

numImages = 121; % Assuming there are 121 images in each folder
numFolders = numel(folderPaths);

for imageIndex = 1:numImages
    % Initialize an empty cell array to store images for this iteration
    imagesForMontage = cell(1, numFolders);
    
    for folderIndex = 1:numFolders
        % Get the image file list in the folder
        imageFiles = dir(fullfile(folderPaths{folderIndex}, '*.png')); % Update file extension if needed
        
        % Check if the image index is within the number of images in the folder
        if imageIndex <= numel(imageFiles)
            % Read the image at the specified index in the folder
            image = imread(fullfile(folderPaths{folderIndex}, imageFiles(imageIndex).name));
            
            % Store the image in the cell array
            imagesForMontage{folderIndex} = image;
        else
            fprintf('Image index %d exceeds number of images in folder %d\n', imageIndex, folderIndex);
        end
    end
    
    % Create a montage from the images
    montageImages = cat(4, imagesForMontage{:});
    montageImage = montage(montageImages, 'Size', [2, 2]); % Adjust montage size if needed
    
    % Save the montage image to the output directory
    outputFileName = fullfile(outputDirectory, sprintf('montage_%d.jpg', imageIndex));
    imwrite(montageImage.CData, outputFileName); % Save the montage image
    
    fprintf('Saved montage image %d\n', imageIndex);
end
