clc;
clear all;
close all;
[J P]=uigetfile('*.*','select the video File');
X=VideoReader(strcat(P,J));
NF=65;
V=read(X);

%figure()
%hist(V(:),0:255)

% % Save Frames %
% for img = 1:X.NumberOfFrames;
%     filename=strcat('frame',num2str(img),'.jpg');
%     b = read(X, img);
%    imwrite(b,filename);
% end

[K T]=uigetfile('*.*','select the Logo');
G=imread(strcat(T,K));
if size(G,3)>1
    G=rgb2gray(G);
end
x = 0.4;  %% 
% decreased from 10 to 0.1, PSNR will increase from ~118 to ~165
G=imresize(G,[64 64]);
GB=double(imbinarize(G,0.4));
GBB=reshape(GB,[1 64*64]);
key=5;                                        % ARNOLD TRANSFORM
[ out ] = Arnold_transformation( GB, key )
GB=[out]                                      % END OF ARNOLD TRANSFORM
%=========================================
t=1;k=64;
for ff=1:NF    
F1=V(:,:,:,ff);
F1=imresize(F1,[256 256]);
OV(:,:,:,ff)=F1;
if k<=(length(GBB))
    
%============ Embedding ====================%

Y=rgb2ycbcr(F1);

[LL1 LH1 HL1 HH1]=inwavtras(double(Y(:,:,1)));
[LL2 LH2 HL2 HH2]=inwavtras(LL1);

[UHL2, SHL2]=hess(HL2);       % Hessenberg Decomposition
HL2 = magic(5);               % QR Decomposition
[Q,R] = qr(HL2)               % QR Decomposition

%---------------------------------------%
%---------------------------------------%
SS=diag(SHL2)./100;
SE=uencode(SS,8);
SB=dec2bin(SE);
SB(:,8)=num2str(GBB(t:k)');
SD=bin2dec(SB);
SDE=udecode(uint8(SD),8)*100;
for ii=1:length(SDE)
SHL2(ii,ii)=SDE(ii);
end
MHL2=UHL2*SHL2*UHL2';
MLL1=myinvinwavtras(LL2,LH2,MHL2,HH2);
MY=myinvinwavtras(MLL1,LH1,HL1,HH1);

[UHL1, SHL1]=hess(HL1);     % Apply Inverse Hessenberg Decomposition
HL1 = magic(5);             % QR Decomposition
[Q,R] = qr(HL1)             % QR Decomposition

Y(:,:,1)=uint8(MY);
YW(:,:,:,ff)=(SDE);
FM=ycbcr2rgb(Y);
WV(:,:,:,ff)=FM;
t=k+1;
k=k+64;
[Ms rs(ff)]=Calc_MSE_PSNR(F1(:,:,1),FM(:,:,1));
else
WV(:,:,:,ff)=F1;
end
end
%%%%%% Attacks %%%%%%%%%%%%
%WV= imcomplement(WV);                              % Complement
%WV = imnoise(WV,'salt & pepper',0.07);             % Salt &peperrs
%WV= imrotate(WV,50,'bilinear','crop');             % Rotation
%WV = imgaussfilt(WV,2);                            % 2-D Gaussian filtering 
%WV =(imresize(WV,1.5  ,'bicubic'));                % Scaling
%WV = imtranslate(WV,[50, 50],'FillValues',128);    % @Translation Attack
%WV = imtranslate(WV,[50, 50],'FillValues',128);    % @Translation Attack
%H = fspecial('motion',20,45);                      % 1-Motion Blur attack
%WV = imfilter(WV,H,'replicate');                   % 2-Motion Blur attack
%WV = motionAttack(WV);                             % Motion Blur attack
%WV = histAttack(WV);                               % Histogram Attack

%%%%%% End Of Attacks %%%%%%
%===================================================
%=========== Extraction ============================
E=[];
for ff=1:size(YW,4)
F2=YW(:,:,:,ff);
SS1=F2;
SE1=uencode(SS1/100,8);
SB1=dec2bin(double(SE1));
E=[E; str2num(SB1(:,8))];
end
EE=reshape(E,[64 64]);

%====================================================
%================== Display =========================
mplay(OV);
mplay(WV);
%figure()
%hist(OV(:),0:255)
%figure()
%hist(WV(:),0:255)
%%%%%%%
figure,subplot(121),imshow(GB);title('Embedding Logo');

key=5;                                           %Inverse ARNOLD
[ out ]=Inverse_Arnold_trans(EE,key);

subplot(122),imshow(EE);title('Extracted Logo'); %Extracted Watermark
imwrite(im2bw(EE),'Extracted_Watermark.png')

figure,stem(1:ff,rs,'k-x','Linewidth',2);grid on;
xlabel('--Frame Number');
ylabel('---PSNR');

%%%%%%% BER computing %%%%%%%
BER=0.0;
for k=1:64
BER=BER+abs(EE(k)-G(k));
end
BER=BER/64;

NC=0.0;
for k=1:64
NC= nc(EE(k),G(k));
end

% display results
fprintf('BER = %0.4f\n',BER)
fprintf('NC = %0.4f\n',NC)
