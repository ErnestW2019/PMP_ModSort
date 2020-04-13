function Phi_unwrap=unwrap_modusort(phase,modulation)
%unwrap_modusort 调制度排序相位展开
% phase 截断相位
% Phi_unwrap 为展开相位
% modulation  为调制度矩阵
% copyright Ernest wang 2019-01-04

%% 调制度排序        
phi_unwrap=phase;
Modulation = modulation;
[row,col,N]=size(modulation);
x=row;
y=col;
[X,Y]=meshgrid(1:x,1:y);
% package.A=padarray(package.A,[1,1],0);                     %对矩阵上下左右各加一行0
im_mask=zeros(x,y);                             %Mask
% im_mask=padarray(im_mask,[1,1],1);
P=zeros(x-2,y-2);
P=padarray(P,[1,1],1); 
[a,b]=find(Modulation==max(max(Modulation)));                 %作为展开的起始点
a=a(1);b=b(1);
im_mask(a,b)=1; 
Modulation(a,b)=0;
% for i = 1:40000
%     x1(i).x = 0; 
%     x1(i).y = 0;
%     x1(i).value = 0; 
% end
     x1.x = []; 
     x1.y = [];
     x1.value = []; 
%把起始点上下左右四个点放入队列
head=1;
x1(head).value=Modulation(a,b-1);
x1(head).x=a;
x1(head).y=b-1;
head=head+1;
x1(head).value=Modulation(a-1,b);
x1(head).x=a-1;
x1(head).y=b;
head=head+1;
x1(head).value=Modulation(a,b+1);
x1(head).x=a;
x1(head).y=b+1;
head=head+1;
x1(head).value=Modulation(a+1,b);
x1(head).x=a+1;
x1(head).y=b;
P(a,b-1)=1;P(a-1,b)=1;P(a,b+1)=1;P(a+1,b)=1;P(a,b)=1;                %B标记已放入队列的像素
[ida, idx]=sort([x1.value],'descend');
sortResult = x1(idx);
% [c,d]=find(package.A==max(max([x1.value])));
c=sortResult(1).x;
d=sortResult(1).y;
sortResult(1)=[];
   Q=phi_unwrap(a,b);    %已展开点的相位
   M=phase(c,d);         %待展开点的相位
   if M-Q<-pi
       M=M+2*pi*round(-(M-Q)/(2*pi));
   end
   if M-Q>pi
       M=M-2*pi*round((M-Q)/(2*pi));
   end
   phi_unwrap(c,d) = M;
while(sum(im_mask(:)~=(x-2)*(y-2)))
   %  phi_unwrap=unwrap([phase(c,d) phase(a,b)]);
   %    a=c;b=d; 
im_mask(c,d)=1;                                         %标记，表示已展开   
Modulation(c,d)=0;
    if (P(c,d-1)~=1)                   %左                 %判断是否是之前取过的像素，不是的话放入队列，是的话删除  
        sortResult(head).value=Modulation(c,d-1);
        sortResult(head).x=c;
        sortResult(head).y=d-1;
        head=head+1;
    end
    if (P(c-1,d)~=1)                   %上        
        sortResult(head).value=Modulation(c-1,d);
        sortResult(head).x=c-1;
        sortResult(head).y=d;
        head=head+1;
    end
    if (P(c,d+1)~=1)                   %右
        sortResult(head).value=Modulation(c,d+1);
        sortResult(head).x=c;
        sortResult(head).y=d+1;
        head=head+1;
    end
    if (P(c+1,d)~=1)                   %下   
        sortResult(head).value=Modulation(c+1,d);
        sortResult(head).x=c+1;
        sortResult(head).y=d;
        head=head+1;
    end
    P(c,d-1)=1;P(c-1,d)=1;P(c,d+1)=1;P(c+1,d)=1;P(c,d)=1;            %标记，表示已索引过这几个像素并放入队列里了
    [ida, idx]=sort([sortResult.value],'descend');
    sortResult = sortResult(idx);
    
    if(isempty(sortResult))
        break;
    end
    
    c=sortResult(1).x;
    d=sortResult(1).y;
    sortResult(1)=[];
        head=head-1;
    
    if (head==0)
        break
    end
    
    if im_mask(c,d-1)==1
        Q=phi_unwrap(c,d-1);    %已展开点的相位（取左点）
    elseif im_mask(c,d+1)==1
        Q=phi_unwrap(c,d+1);    %已展开点的相位（取右点）
   
    elseif im_mask(c+1,d)==1
        Q=phi_unwrap(c+1,d);    %已展开点的相位（取下点）
     elseif im_mask(c-1,d)==1
        Q=phi_unwrap(c-1,d);    %已展开点的相位（取上点）
    end

%    Q=phi_unwrap(c-1,d);    %已展开点的相位
   M=phase(c,d);         %待展开点的相位
   if M-Q<-pi
       M=M+2*pi*round(-(M-Q)/(2*pi));
   end
   if M-Q>pi
       M=M-2*pi*round((M-Q)/(2*pi));
   end
phi_unwrap(c,d) = M;

end                                                           
%% 处理边界
for i=1:x-1             %上边界
    b=phi_unwrap(1,i+1);
    a=phi_unwrap(2,i+1);
    b = b + ((b-a) < -pi).*2*pi*round(-(b-a)/(2*pi)) -  ((b-a) > pi).*2*pi*round((b-a)/(2*pi)); %相位展开 
    phi_unwrap(1,i+1)=b;
end
for i=1:x-1              %下边界
    b=phi_unwrap(x,i);
    a=phi_unwrap(x-1,i);
    b = b + ((b-a) < -pi).*2*pi*round(-(b-a)/(2*pi)) -  ((b-a) > pi).*2*pi*round((b-a)/(2*pi)); %相位展开 
    phi_unwrap(x,i)=b;
end
for j=1:x              %右边界
    b=phi_unwrap(j,x);
    a=phi_unwrap(j,x-1);
    b = b + ((b-a) < -pi).*2*pi*round(-(b-a)/(2*pi)) -  ((b-a) > pi).*2*pi*round((b-a)/(2*pi)); %相位展开 
    phi_unwrap(j,x)=b;
end
for j=1:x              %左边界
    b=phi_unwrap(j,1);
    a=phi_unwrap(j,2);
    b = b + ((b-a) < -pi).*2*pi*round(-(b-a)/(2*pi)) -  ((b-a) > pi).*2*pi*round((b-a)/(2*pi)); %相位展开 
    phi_unwrap(j,1)=b;
end
Phi_unwrap = phi_unwrap;
end