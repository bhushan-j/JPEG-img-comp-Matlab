clear all;
close all;
%quantization matrix
Qmat=[16,11,10,16,24,40,51,61;
      12,12,14,19,26,58,60,55;
      14,13,16,24,40,57,69,56;
      14,17,22,29,51,87,80,62;
      18,22,37,56,68,109,103,77;
      24,35,55,64,81,104,113,92;
      49,64,78,87,103,121,120,101;
      72,92,95,98,112,100,103,99 ];

  img=imread('lena256.pgm');
  %image size
  
  siz=size(img);
  M=siz(1);
  N=siz(2);
  img_var_dct_qt=zeros(M,N);
  img_var_rec=zeros(M,N);
  
  %show image
  figure(1);
  imshow(img);
  title('original image');
 img_var=double(img);
 
 %intialize variable
 b8=1:8;
 M1=M/8; % # of horizontal blocks in img
 N1=N/8; % # of vertical blocks in img
%  PSNRQ=[];
%  MSEQ=[];
%  RQ=[];
%  PSNRJ=[];
%  MSEJ=[];
%  RJ=[];
%  RR=[];
%  Qvec=[];
 
R=[];
D=[];
R1=[];
D1=[];
 % loop on quality perameter q
for q=10:10:80;
 % evaluate S
 % q=10;
 Sq=s_eval(q);
 %DCT and Quantize
 for ind_block_row=0:M1-1;
   for ind_block_col=0:N1-1;
     %indexes of current block are
     %(ind_block_row*M8+rowM8,ind_block_col*N8+columnN8)
     %extract current block
     var_8x8=img_var(ind_block_row*8+b8,ind_block_col*8+b8);
     %dct of current block
     var_8x8_dct=dct2(var_8x8);
     %quantization: scale and round DCT transformed current block
     var_8x8_dct_qt = round(var_8x8_dct./(Sq*Qmat));
     %write transform and quantized current block in metrix
     img_var_dct_qt(ind_block_row*8+b8,ind_block_col*8+b8) = var_8x8_dct_qt;
     %dequantize current block
     var_8x8_dct_dqt=var_8x8_dct_qt.*Qmat*Sq;
     %IDCT of current block
     var_8x8_dct_dqt_idct=idct2(var_8x8_dct_dqt);
     %write current block with idct into idct matrix
     img_var_rec(ind_block_row*8+b8,ind_block_col*8+b8)=var_8x8_dct_dqt_idct;  
     
   end
 end
 % convert format
img_rec=uint8(img_var_rec);

fid = fopen('lena256.txt','w'); % opens a file “file1.txt”
fwrite(fid, img_var_dct_qt, 'int8'); % stores quantized into file1.txt
fclose(fid); % closes the file
zip('lena256','lena256.txt'); % compresses file1.txt into file1.zip
imwrite(img,'lena256.jpg','Quality',q);
var_jpg=imread('lena256.jpg');
sizQ = dir('lena256.zip'); % writes information about “file1.zip”
filesizeQ = sizQ.bytes; % writes in filesizeQ the number of
sizJ=dir('lena256.jpg');
filesizeJ=sizJ.bytes;
R = [R 8*filesizeQ/(M*N)];
R1 = [R1 8*filesizeJ/(M*N)];


errorQ = abs(img-img_rec);
error2Q= errorQ.^2;
D=[D mean(mean(error2Q))];
D1=[D1 mean(mean(error2Q))];


end
figure;
plot(R,D,'-o');
hold on
plot(R1,D1,'-*');
grid on;
