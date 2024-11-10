net = squeezenet
aboxes = {[10,10;10,10;10,10];[10,10;10,10;10,10]};
classes = {'Car'};
layer = {'fire9-concat','fire8-concat'};
detector = yolov3ObjectDetector(net,classes,aboxes,'ModelName','Custom YOLO v3','DetectionNetworkSource',layer);


img = imread('C:\Users\547711\Downloads\tryimage.jpg');
img = preprocess(detector,img);
img = im2single(img);
[bboxes,scores,labels] = detect(detector,img,'Threshold',0.7);
detectedImg = insertObjectAnnotation(img,"Rectangle",bboxes,labels);


figure
imshow(detectedImg)

