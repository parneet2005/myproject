name = 'tiny-yolov3-coco';

detector = yolov3ObjectDetector(name);

disp(detector)

img = imread('C:\Users\547711\Documents\img\images_left\018.png');
img = preprocess(detector,img);
img = im2single(img);
[bboxes,scores,labels] = detect(detector,img,'DetectionPreprocessing','none');

detectedImg = insertObjectAnnotation(img,'Rectangle',bboxes,labels);
figure
imshow(detectedImg)
% 
% % Load Faster R-CNN detector
% data = load('fasterRCNNVehicleTrainingData.mat', 'detector');
% detector = data.detector;
% 
% % Read and resize the image
% imgPath = 'C:\Users\547711\Documents\img\MontageOutput\montage_4.png';
% I = imread(imgPath);
% I_resized = imresize(I, [480, 640]); % Resize to a smaller size
% 
% % Adjust detection parameters (if needed)
% detector.MinObjectSize = [20, 20]; % Minimum object size
% detector.NumStrongestRegions = 1000; % Number of strongest object proposals
% detector.ConfidenceThreshold = 0.5; % Confidence threshold for detection
% 
% % Perform object detection
% [bboxes, scores, labels] = detect(detector, I_resized);
% 
% % Display the detected objects on the image
% if ~isempty(bboxes)
%     detectedImg = insertObjectAnnotation(I_resized, 'rectangle', bboxes, labels);
%     imshow(detectedImg);
% else
%     disp('No objects detected.');
% end
% 
% deepNetworkDesigner














% % Load a pre-trained object detection network (such as Faster R-CNN)
% net = alexnet; % Replace with your chosen pre-trained network
% 
% % Read and preprocess the image
% imagePath = "C:\Users\547711\Documents\img\MontageOutput\montage_70.png";
% I = imread(imagePath);
% I = imresize(I, net.Layers(1).InputSize(1:2)); % Resize to match network input size
% inputSize = net.Layers(1).InputSize(1:2);
% 
% % Perform object detection
% [bboxes,scores] = detect(net,I);
% 
% % Visualize detected objects
% if ~isempty(bboxes)
%     detectedImg = insertObjectAnnotation(I, 'rectangle', bboxes, labels);
%     figure;
%     imshow(detectedImg);
%     title('Detected Objects');
% else
%     disp('No objects detected.');
% end