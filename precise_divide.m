function imag2=precise_divide(imag,x,y)
    [hig,wid]=size(imag);
   imag2=zeros(wid,hig);
 
   for i=1:hig  
   for j=1:wid  
      if x<=imag(i,j) && imag(i,j)<y  %16����3 4С�ˣ�3 5����   32����ѡ6-9���ԣ�Ҳ����7 8
        imag2(i,j)=imag(i,j)*1.5; 
      end
   end
   end

