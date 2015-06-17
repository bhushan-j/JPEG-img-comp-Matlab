clear all;
close all;

qmat = [16,11,10,16,24,40,51,61;
      12,12,14,19,26,58,60,55;
      14,13,16,24,40,57,69,56;
      14,17,22,29,51,87,80,62;
      18,22,37,56,68,109,103,77;
      24,35,55,64,81,104,113,92;
      49,64,78,87,103,121,120,101;
      72,92,95,98,112,100,103,99 ];
  
  img = imread('lena256.pgm');
  
  %Size of image
  siz = size((img));
  M=siz(1);
  N=siz(2);
  img_var_dct_qt=zeros(M,N);
  img_var_rec=zeros (M,N);
  
  %show Image
  figure(1);
  imshow(img);
  title('orig_img');
  
  img_var = double(img);

  %initialize variables
  b8=1:8;
  M1=M/8;
  N1=N/8;
  
  PSNRQ=[];
  Mseq=[];
  rq=[];
  psnrj=[];
  msej=[];
  rj=[];
  rr=[];
  qvec=[];
  
  %Loop on quality parameter q
  
  %for q= 10:10:80;
  q=5
  sq = s_eval(q);
  
%   %dct & quantization
  for ind_blk_row=0: M1-1;
   for ind_blk_col=0: N1-1;
    
  %Indexes of current blk are(ind_blk_row*M8+rowM8,ind_blk_col*N8+colN8)
  %extract current block
  var_8x8=img_var(ind_blk_row*8+b8,ind_blk_col*8+b8);
  %Dct of current block
  var_8x8_dct = dct2(var_8x8);
  %Quantoization, scale and round dct transform current block
  var_8x8_dct_qt= round(var_8x8_dct./(sq*qmat));
  % write tranform and quantoze current block in matrix
  img_var_dct_qt(ind_blk_row*8+b8, ind_blk_col*8+b8)= var_8x8_dct_qt;
  %dequantize current block
  var_8x8_dct_dqt = var_8x8_dct_qt.*qmat*sq;
  %IDCT of current block
  var_8x8_dct_dqt_idct = idct2(var_8x8_dct_dqt);
  %write current block with idct into idct matrix
  img_var_rec(ind_blk_row*8+b8,ind_blk_col*8+b8) = var_8x8_dct_dqt_idct;
   end
  end
  
 %convert format
 img_rec=uint8(img_var_rec);
%  
%  %vizualization decompressed images for 
figure(2);
imshow(img_rec);