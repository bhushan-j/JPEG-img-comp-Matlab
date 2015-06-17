clear all
close all

A=[16,11,10,16,24,40,51,61;
12,12,14,19,26,58,60,55;
14,13,16,24,40,57,69,56;
14,17,22,29,51,87,80,62;
18,22,37,56,68,109,103,77;
24,35,55,64,81,104,113,92;
49,64,78,87,103,121,120,101;
72,92,95,98,112,100,103,99 ];
image=imread('lena512.pgm'); %to read the image
figure(1);
imshow(image); %to show the image
hold on;
img_var=double(image); % to represent an image as real variable
siz=size(img_var);
M=siz(1);
N=siz(2);
quantized=zeros(M,N); %to return a M-by-N matrix
reconstructed=zeros(M,N);
D=[];
R=[];
for q = 10:10:90;
S = s_eval(q); %to store the output from q in specified variables
b8=1:1:8;
M1=M/8; % no. of vertical blocks in image
N1=N/8; % no. of horizontal blocks in image
for i_row=0:M1-1;
for i_col=0:N1-1;
block=img_var(i_row*8+b8,i_col*8+b8);
block_dct=dct2(block); %discrete cosine transform of 8*8 block
block_dct_qt=round(block_dct./(S*A)); %quantization of 8*8 block
quantized(i_row*8+b8,i_col*8+b8) = block_dct_qt; %quantized image
block_dct_dqt=block_dct_qt.*A*S; %dequantization of 8*8 block
block_dct_dqt_idct=idct2(block_dct_dqt); %inverse discrete cosine transform
reconstructed(i_row*8+b8,i_col*8+b8)=block_dct_dqt_idct; %reassembling reconstructed matrix
end
end
image_reconstructed=uint8(reconstructed); % to convert to 8-bit unsigned integer
fid = fopen('file1.txt','w'); % opens a file "file1.txt"
fwrite(fid, quantized, 'int8'); % stores quantized into file1.txt
fclose(fid); % closes the file
zip('file1','file1.txt'); % compresses file1.txt into file1.zip
sizQ = dir('file1.zip'); % writes information about "file1.zip"
% into the variable sizQ (getFileStat function)
filesizeQ = sizQ.bytes; % writes in filesizeQ the number of

% bytes of "file1.zip"
R = [R 8*filesizeQ/(M*N)]; % number of bits/pixel
errorQ = abs(image-image_reconstructed); %absolute value of image reconstructed
error2Q= errorQ.^2;
D=[D mean(mean(error2Q))]; % mean value of error
imwrite(image,'file1.jpg','Quality',q); % file1.jpg is a JPEG compressed file
image_jpg=imread('file1.jpg'); % image.jpg is a JPEG compressed image

end
figure
plot(R,D);
grid on
xlabel('R');
ylabel('D');

