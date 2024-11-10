% Define paths to the four folders
folderPaths = {'C:\Users\547711\Documents\img\scenario3\images_front', ...
               'C:\Users\547711\Documents\img\scenario3\images_right', ...
               'C:\Users\547711\Documents\img\scenario3\images_left', ...
               'C:\Users\547711\Documents\img\scenario3\images_back'};

% Define the output directory for saving montages
outputDirectory = 'C:\Users\547711\Documents\img\MontageOutput_3'; % Update with your desired output directory
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
    outputFileName = fullfile(outputDirectory, sprintf('montage_%d.png', imageIndex));
    imwrite(montageImage.CData, outputFileName); % Save the montage image
    
    fprintf('Saved montage image %d\n', imageIndex);
end

