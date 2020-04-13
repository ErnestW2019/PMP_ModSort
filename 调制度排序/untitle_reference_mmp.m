function R_Phi_unwraped=untitle_reference_mmp()
N=6;
for n=1:N
I(:,:,n)=double(imread(['C:\Users\Administrator\Desktop\图片2\参考面\', int2str(n) ,'.tif']));
I0(:,:,n)=imresize(I(:,:,n),[400,400]);
% I0ws(:,:,n)=wpdencmp(I0(:,:,n),'s',2,'sym4',crit,thr,keepapp);
% I(:,:,n)=double(I0(Y1:Y2,X1:X2));
end
[row,col,N]=size(I0);
Isin=zeros(row,col);
Icos=zeros(row,col);
x=row;
y=col;
for i=1:N
Isin=Isin+I0(:,:,i).*sin(2*pi*i/N);
Icos=Icos+I0(:,:,i).*cos(2*pi*i/N);
end
 for j=1:x
    for i=1:y
        phase(i,j)=-atan2(Isin(i,j),Icos(i,j));
    end
 end
% % ****************************
%%  相位展开
n=zeros(x,y);  
n(1,1)=0;
for i=2:x  %遍历相位图像素第一行
    if abs(phase(1,i)-phase(1,i-1))<pi
        n(1,i)=n(1,i-1);
    elseif phase(1,i)-phase(1,i-1)<=-pi
        n(1,i)=n(1,i-1)+1;
    elseif phase(1,i)-phase(1,i-1)>=pi
        n(1,i)=n(1,i-1)-1;
    end
end
for i=2:x
    for j=1:y
        if abs(phase(i,j)-phase(i-1,j))<pi
            n(i,j)=n(i-1,j);
        elseif phase(i,j)-phase(i-1,j)<=-pi
            n(i,j)=n(i-1,j)+1;
        elseif phase(i,j)-phase(i-1,j)>=pi
            n(i,j)=n(i-1,j)-1;
        end
    end
end    
R_Phi_unwraped=phase+2*pi.*n;
end
