% Demo by Image Analyst, December, 2020.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clearvars;
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 10;
fprintf('Beginning to run %s.m ...\n', mfilename);

% 1st image
workingDir = "C:\Users\547711\Documents\img\scenario3";

mkdir(workingDir)
mkdir(workingDir,"images_front")

f=VideoReader("C:\Users\547711\Desktop\matlab\parneet\HandoverOscarOwen\video\scenario3\output1.avi");
 
i = 1;

while hasFrame(f)
   ima = readFrame(f);
   filename = sprintf("%03d",i)+".png";
   fullname1 = fullfile(workingDir,"images_front",filename);
   imwrite(ima,fullname1)    % Write to a JPEG file (001.jpg, 002.jpg, ..., 121.jpg)
   i = i+1;
end
imageNames_front= dir(fullfile(workingDir,"images","*.png"));
imageNames_f = {imageNames_front.name}';

%For 2nd video

mkdir(workingDir)
mkdir(workingDir,"images_left")

t=VideoReader("C:\Users\547711\Desktop\matlab\parneet\HandoverOscarOwen\video\scenario3\output2.avi");
 
i = 1;

while hasFrame(t)
   ima = readFrame(t);
   filename = sprintf("%03d",i)+".png";
   fullname2 = fullfile(workingDir,"images_left",filename);
   imwrite(ima,fullname2)    % Write to a JPEG file (001.jpg, 002.jpg, ..., 121.jpg)
   i = i+1;
end
imageNames_left= dir(fullfile(workingDir,"images","*.png"));
imageNames_l = {imageNames_left.name}';

%For 3rd video
mkdir(workingDir)
mkdir(workingDir,"images_right")

r=VideoReader("C:\Users\547711\Desktop\matlab\parneet\HandoverOscarOwen\video\scenario3\output3.avi");
 
i = 1;

while hasFrame(r)
   pic = readFrame(r);
   filename = sprintf("%03d",i)+".png";
   fullname3 = fullfile(workingDir,"images_right",filename);
   imwrite(pic,fullname3)    % Write to a JPEG file (001.jpg, 002.jpg, ..., 121.jpg)
   i = i+1;
end
imageNames_right= dir(fullfile(workingDir,"images","*.png"));
imageNames_r = {imageNames_right.name}';

%For 4th video
mkdir(workingDir)
mkdir(workingDir,"images_back")

b=VideoReader("C:\Users\547711\Desktop\matlab\parneet\HandoverOscarOwen\video\scenario3\output4.avi");
 
i = 1;

while hasFrame(b)
   pic = readFrame(b);
   filename = sprintf("%03d",i)+".png";
   fullname4 = fullfile(workingDir,"images_back",filename);
   imwrite(pic,fullname4)    % Write to a JPEG file (001.jpg, 002.jpg, ..., 121.jpg)
   i = i+1;
end
imageNames_back= dir(fullfile(workingDir,"images","*.png"));
imageNames_b = {imageNames_back.name}';

 
