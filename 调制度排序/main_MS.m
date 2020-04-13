%%
clc;close all;clear;
%%
N=6;
for n=1:N
I(:,:,n)=double(imread(['C:\Users\Administrator\Desktop\图片2\', int2str(n) ,'.tif']));
I0(:,:,n)=imresize(I(:,:,n),[400,400]);
% I0ws(:,:,n)=wpdencmp(I0(:,:,n),'s',2,'sym4',crit,thr,keepapp);
% I(:,:,n)=double(I0(Y1:Y2,X1:X2));
end
[row,col,N]=size(I0);
Isin=zeros(row,col);
Icos=zeros(row,col);
for i=1:N
Isin=Isin+I0(:,:,i).*sin(2*pi*i/N);
Icos=Icos+I0(:,:,i).*cos(2*pi*i/N);
end
modulation=sqrt(Isin.^2+Icos.^2)/(N/2);
%% 获得截断相位
phase(:,:)=-atan2(Isin,Icos);
%% 调用调制度排序函数
Phi_unwrap = unwrap_modusort(phase,modulation);

% 李勇老师调制度排序
modulation_nor=(modulation-min(modulation(:)))/((max(modulation(:))-min(modulation(:))));
[Phi_unwrap2]=UnWrapf(phase,300,75,modulation_nor,255,0,255);
%% 显示展开相位图
figure;
imagesc(Phi_unwrap);
figure;
imagesc(Phi_unwrap2);
% mesh(X,Y,phi_unwrap)
% colorbar
%%  高度重建
% figure
% mesh(X,Y,z) 
% title('orginal image');
x=row;
y=col;
[X,Y]=meshgrid(1:x,1:y);
R_phi_unwrap=untitle_reference_mmp();
h1=((Phi_unwrap-R_phi_unwrap)+6.25)*5;      %% 自己调制度逐点展开恢复高度
h2=((Phi_unwrap2-R_phi_unwrap)+6.25)*5;

figure;
mesh(X,Y,h1);
title('Rebuilding image1');
figure;
mesh(X,Y,h2);
title('Rebuilding image2');
% er=z-h;
% figure,mesh(er);title('重建误差');
%两者比较
ep =abs(h1-h2);
figure,mesh(ep);title('两者之差');


