%% Tutorial for linear filtering written by Chris McIntosh (chris.mcintosh@rmp.uhn.on.ca)
clear all;close all;

%Load a grayscale image
img = double(imread('cameraman.tif'));

figure;imagesc(img);axis image;colormap gray;

%Create a separable filter
hx =[1 2 1];
hy = [1 2 1]';
H = hy*hx;
hx = hx/sum(hx(:));
hy = hy/sum(hy(:));
H = H/sum(H(:));%normalize the filter

%Zero-padding
imgSmooth = conv2(img,H,'full');
figure;imagesc(imgSmooth);axis image;colormap gray;

%Automatically discard the information at the boundary
imgSmooth = conv2(img,H,'same');
figure;imagesc(imgSmooth);axis image;colormap gray;



%Compare the results to the separable version
imgSmoothS1 = conv2(conv2(img,hy,'same'),hx,'same');
mean(abs(imgSmoothS1(:)-imgSmooth(:)))

%Does the order matter?
imgSmoothS2 = conv2(conv2(img,hy,'same'),hx,'same');
mean(abs(imgSmoothS2(:)-imgSmooth(:)))

%What about with FFT?
imSize = size(img);
filterSize = size(H);
%The images must be padded to the product of the sizes minus 1, why?
imgFFT = fft2(img,imSize(1)+filterSize(1)-1,imSize(2)+filterSize(2)-1);
HFFT = fft2(H,imSize(1)+filterSize(1)-1,imSize(2)+filterSize(2)-1);

%multiply and perform the inverse FFT to obtain the result
imgSmoothFFT = ifft2(imgFFT.*HFFT);
%remove the padding, is it the same padding as conv2 without the 'same'
%argument?
imgSmoothFFT = imgSmoothFFT(2:end-1,2:end-1);
figure;imagesc(imgSmoothFFT);axis image;colormap gray;
mean(abs(imgSmoothFFT(:)-imgSmooth(:)))
%Why are they different?

%What if we don't padd the fft? It assumes a circular signal!
imgFFT = fft2(img);
HFFT = fft2(H,imSize(1),imSize(2));

%multiply and perform the inverse FFT to obtain the result
imgSmoothFFT = ifft2(imgFFT.*HFFT);
%remove the padding, is it the same padding as conv2 without the 'same'
%argument?
p = 512;
imgPadd = padarray(img,[p,p],'circular');
imgPaddSmooth = conv2(imgPadd,H,'same');
imgPaddSmooth = imgPaddSmooth(p+(0:255),p+(0:255));
figure;imagesc(imgPaddSmooth);axis image;
figure;imagesc(imgSmoothFFT);axis image;
mean(abs(imgSmoothFFT(:)-imgPaddSmooth(:)))

%Can we re-obtain the original image?
imgO = ifft2(fft2(imgSmooth,imSize(1)+filterSize(1)-1,imSize(2)+filterSize(2)-1)./(HFFT+eps));
imgO = imgO(2:end-1,2:end-1);
figure;imagesc(imgO);
mean(abs(img(:)-imgO(:)))

%We discarded data!
imgO = ifft2(fft2(conv2(img,H,'full'),imSize(1)+filterSize(1)-1,imSize(2)+filterSize(2)-1)./(HFFT+eps));
imgO = imgO(2:end-1,2:end-1);
figure;imagesc(imgO);axis image;colormap gray;
%Better, but still some gridding. It comes down to the numerics
mean(abs(img(:)-imgO(:)))

%% What would a random filter do?
figure;
for a= 1:5;
    H = rand(15,15);H = H/sum(H(:));
imgRand = conv2(img,H,'same');
subplot(2,5,a);
imagesc(imgRand);axis image;axis off; colormap gray
subplot(2,5,a+5);
imagesc(H);axis image;axis off; colormap gray
end

%With a Gaussian distribution? Will it look like the results in lecture?
figure;
for a= 1:5;
    H = randn(15,15);H = H/sum(H(:));
imgRand = conv2(img,H,'same');
subplot(2,5,a);
imagesc(imgRand);axis image;axis off; colormap gray
subplot(2,5,a+5);
imagesc(H);axis image;axis off; colormap gray
end

%% What about a colour image?
imgColour = imread('peppers.png');
figure;imagesc(imgColour);

%Make it a double!
imgColour = double(imgColour);
figure;imagesc(imgColour);
%What just happened!


%Matlab expects color images to be in [0,1] if they are double.
imgColour = imgColour/max(imgColour(:));
figure;imagesc(imgColour);

H = fspecial('Gaussian',[15 15],4);
try
    imgColourSmooth = conv2(imgColour,H);
catch e
    fprintf('%s\n',e.message);
end

%The colour image has three channels
imgColourSmooth = zeros(size(imgColour));%Pre-allocate for speed in a for-loop
for a = 1:3
    imgColourSmooth(:,:,a) = conv2(imgColour(:,:,a),H,'same');
end
figure;imagesc(imgColourSmooth);axis image;

%A more compact way, but how does it work??
imgColourSmooth = convn(imgColour,H,'same');
figure;imagesc(imgColourSmooth);axis image;

%% Covered through here in tutorial (Sep. 14 2017)

%% Does the blur make sense? A synthetic example
H = ones(30,50);H = H/sum(H(:));
imgTest = zeros(512,512,3);
imgTest(:,1:256,1) = repmat(linspace(0.5,1,512)',[1 256]);
imgTest(:,257:end,2) = repmat(linspace(0.5,1,512)',[1 256]);
figure;imagesc(imgTest);

tstFig = figure;subplot(1,3,1);
imagesc(imgTest);axis image;
subplot(1,3,2);
imagesc(convn(imgTest,H,'same'));axis image;
%Why did it get so dark in the middle?

%Let's try again, but first, a change of the colour space
imgTestlab = rgb2lab(imgTest);
figure;imagesc(imgTestlab);
%That looks weird...why?
figure;imagesc(imgTestlab(:,:,1));axis image;title('Just the L');
%Smooth it again
imgTestlabSmooth = convn(imgTestlab,H,'same');

imgTestlabRGBSmooth = lab2rgb(imgTestlabSmooth);
imgTestlabRGBSmooth(imgTestlabRGBSmooth<0)=0;
%It is in lab, but imagesc expects rgb, so we need to convert back!
figure(tstFig);%return focus to the old figure
subplot(1,3,3);
imagesc(imgTestlabRGBSmooth);axis image;


%% Back to the original one last time
close all;
figure;
subplot(2,2,1);imagesc(imgColour);axis image;
H = fspecial('Gaussian',[15 15],4);
subplot(2,2,2);
imagesc(imgColourSmooth);axis image;
subplot(2,2,3);
imgColourlab = rgb2lab(imgColour);
imgColourlabSmooth = lab2rgb(convn(imgColourlab,H,'same'));
imgColourlabSmooth(imgColourlabSmooth<0)=0;
imagesc(imgColourlabSmooth);axis image;

H = fspecial('Gaussian',[45 45],40);
imgColourlabSmooth = imgColourlab;%Pre-allocate for speed in a for-loop
for a = 1:1
    imgColourlabSmooth(:,:,a) = conv2(imgColourlab(:,:,a),H,'same');
end
subplot(2,2,4);
imagesc(lab2rgb(imgColourlabSmooth));axis image;

