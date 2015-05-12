%% Main program that identifies the road from a map-image

clc
clear all

% Read image of simple road
I = imread('Bild4.png');

% % Show original image
figure(1)
imshow(I)
title('Original image')

% Cut the image
IR=im2double(cutImage(I(:,:,1)));
IG=im2double(cutImage(I(:,:,2)));
IB=im2double(cutImage(I(:,:,3)));

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.5);
IG_thres = IG > getThreshold(IG, 0.5);
IB_thres = IB > getThreshold(IB, 0.5);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3);
IS = IS < IS_threshold; % Good pic to extract the road from!

IV = cutImage(Ihsv(:,:,3));
IV_threshold = getThreshold(IV,0.85);
IV = IV > IV_threshold; % Doesn't give too much info

% Sum all images up to get the best image. Works good for 'Bild2' to reduce
%the reflections from the water
% I_best = IB_thres+IR_thres+IG_thres+IS+IV;
% I_best = I_best > 4;

% Sum all images up to get the best image
I_best = IB_thres+IR_thres+IG_thres+IS;
I_best = I_best > 3;

% Find white lines

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.9);
IG_thres = IG > getThreshold(IG, 0.9);
IB_thres2 = IB > getThreshold(IB, 0.9);

% Sum all images up to get the best image
I_bestLines = IB_thres2+IR_thres+IG_thres+IS;
I_bestLines = I_bestLines > 3;


% Removed noise from actual road
InoNoiseRoad=imcomplement(bwareaopen(imcomplement(I_best),100));
InoNoise=bwareaopen(InoNoiseRoad, 1000);
IroadLines=InoNoise-I_bestLines;
IroadLinesNoNoise=imcomplement(bwareaopen(imcomplement(IroadLines), 100));

figure(2)
subplot(1,1,1)
imshow(IroadLinesNoNoise)
