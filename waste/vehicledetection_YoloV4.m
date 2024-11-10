detector = vehicleDetectorYOLOv2();
I = imread("C:\Users\547711\Desktop\matlab\parneet\HandoverOscarOwen\Region of interest IMAGES\MY_ROI_IMAGE\ROI_image1.png");

[bboxes,scores] = detect(detector,I);

I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure
imshow(I)
title('Detected vehicles and detection scores');