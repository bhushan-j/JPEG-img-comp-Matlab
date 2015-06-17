close all;

% lena512
Qmat=[16,11,10,16,24,40,51,61;
      12,12,14,19,26,58,60,55;
      14,13,16,24,40,57,69,56;
      14,17,22,29,51,87,80,62;
      18,22,37,56,68,109,103,77;
      24,35,55,64,81,104,113,92;
      49,64,78,87,103,121,120,101;
      72,92,95,98,112,100,103,99 ];
  
image=imread('lena512.pgm'); % image reading

figure(1); 
imshow(image);% to show image
title(' original image ');
hold on;
img_var=double(image);% image in floating point number
siz=size (img_var); % number of rows and coloumns

M = siz (1); %initializing matrix same as img_var
N = siz (2); 
b8 =1:8;
M1=M/8;% n. of vertical blocks in image
N1=N/8;% n. of horizontal blocks in image
quantize = zero(M,N);
recon = zero(M,N);

PSNRQ=[];
Mseq=[];   rq=[];
psnrj=[];  msej=[];
rj=[];     rr=[];
qvec=[];

for q= 10:10:80;
  % q= 10
  sq = s_eval(q);
  
 
 for i_row=0: M1-1; %   %dct & quantization
  for i_col=0: N1-1;  
  block=img_var(i_row*8+b8,i_col*8+b8);%extract  block
  block_dct = dct2(block); %Dct of block
  block_dct_qt= round(block_dct./(sq*qmat)); %Quantoization, scale and round dct transform current block
  img_var_dct_qt(i_row*8+b8, i_col*8+b8)= block_dct_qt; % write tranform and quantoze  block in matrix
  block_dct_dqt = block_dct_qt.*qmat*sq; %dequantize  block
  block_dct_dqt_idct = idct2(block_dct_dqt);  %IDCT of current block
  img_var_rec(i_row*8+b8,i_col*8+b8) = block_dct_dqt_idct; %write current block with idct into idct matrix
   end
  end
   image_recon= uint8(img_var_rec); %convert format
  
figure(2);%  decompressed images
imshow(image_recon);

end

fid = fopen('file1.txt','w'); % opens a file “file1.txt”
fwrite(fid, quantized, 'int8'); % stores quantized into file1.txt
fclose(fid); % closes the file
zip('file1','file1.txt'); % compresses file1.txt into file1.zip
sizQ = dir('file1.zip'); % writes information about “file1.zip”
% into the variable sizQ (getFileStat function)
filesizeQ = sizQ.bytes; % writes in filesizeQ the number of
% bytes of “file1.zip”
R = 8*filesizeQ/(M*N); % number of bits/pixel
errorQ = abs(img-image_reconstructed);
error2Q= errorQ.^2;
D=mean(mean(error2Q));
imwrite(image,'file1.jpg','Quality',q); 
  
% var_8= var_im(ind_block_row*8+b8,ind_block_col*8+b8); %copies all the 8x8 blocks of the matrix img_var in the 8 x 8 submatrix var_8x8.
% var_8_dct= dct2 (var_8);%bidimensional DCT
% 
% var_8_dct_qt = round(var_8_dct./(S*qmat));
% img_var_dct_qt(ind_block_row*8+b8,ind_block_col*8+b8) = var_8x8_dct_qt;%Assembles all the quantized 8x8 blocks
% var_8_dct_dqt=var_8_dct_qt.*qmat*S; %applying the expression
% img_var_rec = idct2 (var_8_dct_dqt);%inverse DCT transform of each block
% uint8 (img_var_rec);
% 
% fid = fopen('file1.txt','w'); % opens a file “file1.txt”
% fwrite(fid, img_var_dct_qt, 'int8'); % stores img_var_dct_qt into file1.txt
% fclose(fid); % closes the file
% zip('file1','file1.txt'); % compresses file1.txt into file1.zip
% sizQ = dir('file1.zip'); % writes information about “file1.zip”% into the variable sizQ (getFileStat function)
% filesizeQ = sizQ.bytes; % writes in filesizeQ the number of % bytes of “file1.zip”
% 
% d = mse(net,var_im,img_var_rec);%Evaluate the MSE (expression (1))
% r = psnr(img_var_rec,var_im);%Evaluate the PSNR (expression (1b))
% 
% plot(d,r); % plot D-R curv
% imwrite(img,'file1.jpg','Quality',q);