function imag2=precise_divide(imag,x,y)
    [hig,wid]=size(imag);
   imag2=zeros(wid,hig);
 
   for i=1:hig  
   for j=1:wid  
      if x<=imag(i,j) && imag(i,j)<y  %16档：3 4小了，3 5大了   32档：选6-9试试，也就是7 8
        imag2(i,j)=imag(i,j)*1.5; 
      end
   end
   end

