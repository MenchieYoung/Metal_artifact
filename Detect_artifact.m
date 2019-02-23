function [s6]=Detect_artifact(imag)
% load('image6.mat');
% imag=image6;

[high,width]=size(imag);  
a=max(max(imag));
imag=imag/a;
imag3=zeros(high,width);

 [~,x]=imhist(imag,32);  % 0-1  16个点，15个间隔。取15个间隔的中点，与0和1组成16个bin  左闭右开+最后一个闭 
%如果x=[0  0.3333  0.6667  1]
%然而统计区间是：  [0,0.1667)  [0.1667-0.5)    [0.5,0.8333)  [0.8333,1]

  p1=(x(8)+x(8))/2;
  q=(x(16)+x(18))/2;
  
 for i=1:high  
 for j=1:width    
     if (x(16)+x(18))/2<=imag(i,j) ||  imag(i,j)<(x(2)+x(4))/2  
       imag(i,j)=imag(i,j)/2;      
     end
 end
 end 
 %  figure,imshow(imag,[]);title('total'),hold on;
   imag=imadjust(imag,[],[],1.1); %gamma>1,相当于有把图片往低亮度移动的趋势，微调
   [counts,x]=imhist(imag,32);  
   counts=counts/high/width;  
%     figure, stem(x,counts), title('hist');hold on;   %结果发现预处理1后直方图分布变化不大

 m=sum(counts(7:17));
 if m>0.3
     imag=zeros(high,width);
 end
 
C=mat2cell(imag,[high/2,high/2],[width/2,width/2]);  
% C_up=[C{1,1},C{1,2}];
C_down=[C{2,1},C{2,2}];
l1=h_line(C_down);
if l1>200
    p2=(x(7)+x(7))/2;
else
    p2=(x(5)+x(5))/2;
end

 %C0=cellfun(@precise_divide,C,'UniformOutput',false);
 C1{1,1}=precise_divide(C{1,1},p1,q);
 C1{1,2}=precise_divide(C{1,2},p1,q);
 %C1{1,3}=precise_divide(C{1,3},p1,q);
 %C1{1,4}=precise_divide(C{1,4},p1,q);
 C1{2,1}=precise_divide(C{2,1},p2,q);
 C1{2,2}=precise_divide(C{2,2},p2,q);
%  C1{2,3}=precise_divide(C{2,3},p1,q);
%  C1{2,4}=precise_divide(C{2,4},p1,q);
%  C1{3,1}=precise_divide(C{3,1},p2,q);
%  C1{3,2}=precise_divide(C{3,2},p2,q);
%  C1{3,3}=precise_divide(C{3,3},p2,q);
%  C1{3,4}=precise_divide(C{3,4},p2,q);
%  C1{4,1}=precise_divide(C{4,1},p2,q);
%  C1{4,2}=precise_divide(C{4,2},p2,q);
%  C1{4,3}=precise_divide(C{4,3},p2,q);
%  C1{4,4}=precise_divide(C{4,4},p2,q);

C_total=cell2mat(C1);

  for i=1:high  
   for j=1:width  
      if imag(i,j)<(x(2)+x(2))/2;
         imag3(i,j)=x(18);
      end
   end
  end
   
  s=edge(imag,'canny',0.06,2);    %total
  s2=edge(C_total,'canny',0.07,2);  %高亮的牙和组织
  s3=edge(imag3,'canny',0.06,2);  %黑色的无东西地方
   s=~s;
   s4= s2|s3;
   s5=(s|s4);
   s6=fillsmallholes(s5,30);
 %  figure,imshow(s6,[]),title('wy');
