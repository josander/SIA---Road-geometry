%% PROJECT 142 1.0
I=imread('Bild5.png');

rate = size(I,2)/size(I,1);
Ir=resample(I,rate);
figure(1), imshow(Ir)


% creating 3 images f�r RGB
IR =Ir(:,1:length(Ir)/3);
IG =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 : length(Ir));


threshold_IB = midpoint(IB);
% creating binary images
IR_threshold = IR < 0.8;
IG_threshold = IG < 0.7;
IB_threshold = IB < 0.8;%threshold_IB;%mean(mean(IB)); %0.6 good for bild1
%imshow(IB_threshold)

%% test for interative analysis

for i=1:10
    figure(i)
    IB_threshold = IB < 0.1*i*threshold_IB;
    imshow(IB_threshold)
end

%% test for making things work...
I1 = IB > 0.4*threshold_IB;
figure(1), imshow(I1)
I2 = IB > 0.8*threshold_IB;
figure(2), imshow(I2)

I3 = I1 + I2;
I3 = I3 > 0;
I3= imcomplement(I3);
figure(3), imshow(I3)
% %
R = 3;
SE = strel('diamond', R);

I1 = IB < threshold_IB;
%figure(1), imshow(I1)

I1 = imclose(I1,SE);
%figure(2), imshow(I1)

I1 = imcomplement(I1);
I2 = IB > 0.8*threshold_IB;
I3 = I1 + I2;
I3 = I3 > 0;
I3= imcomplement(I3);
figure(3), imshow(I3)

I3 = imclose(I3,SE);
figure(4), imshow(I3)

%% interative analysis
R = 1;
R2 = 1;%7;%10;
first= 90;
last = 40;
SE = strel('diamond', R);
SE2 = strel('diamond', R2);
I = IB < threshold_IB;
%figure(99), imshow(I);
for i=first:-1:last
    
    I = imclose(I,SE);
    
    figure(i)
    imshow(I)
    
    Itemp1 = imcomplement(I);
    Itemp2 = IB > 1/first*i*threshold_IB;
    I = Itemp1 + Itemp2;
    I = I > 0;
    I = imcomplement(I);
    
end
I = imclose(I,SE2);
figure(last+1)
imshow(I)
figure(last+2)
imshow(IB < threshold_IB)


%%
%grayscale
Igray = rgb2gray(I);
figure(2), imshow(Igray, [0 255])

%% Prewitt filter on the image to find contours

wy = [-1 -1 -1; 0 0 0; 1 1 1]/6;
wx = [-1 0 1; -1 0 1; -1 0 1]/6;

Ix = filter2(wx, IB_threshold);
Iy = filter2(wy, IB_threshold);

Ipre = sqrt(Ix.^2 + Iy.^2);

imshow(Ipre)
shg
