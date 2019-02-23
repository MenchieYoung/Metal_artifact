    load('image3.mat');
    img=image3; 
    mask=Detect_artifact(img); 
    
%     a1=find(mask>127);  
%     b1=find(mask<=127);  
%     mask(a1)=0;  
%     mask(b1)=255;  
    [m,n]=size(img);  
    for i=1:m  
        for j=1:n  
            if mask(i,j)==0  
               img(i+(-1:1:1),j+(-1:1:1))=0;   
            end  
        end  
    end  
    figure,imshow(img,[]);title('需修复');     %合成的需要修复的图像  
      
    lambda=0.2;  %自定义
    a=0.001;%避免分母为0  %自定义
    imgn=img;  
    for l=1:1500         %迭代次数  
        for i=2:m-1  
            for j=2:n-1  
                if mask(i,j)==0     %如果当前像素是被污染的像素，则进行处理  
                    Un=sqrt((img(i,j)-img(i-1,j))^2+((img(i-1,j-1)-img(i-1,j+1))/2)^2);  
                    Ue=sqrt((img(i,j)-img(i,j+1))^2+((img(i-1,j+1)-img(i+1,j+1))/2)^2);  
                    Uw=sqrt((img(i,j)-img(i,j-1))^2+((img(i-1,j-1)-img(i+1,j-1))/2)^2);  
                    Us=sqrt((img(i,j)-img(i+1,j))^2+((img(i+1,j-1)-img(i+1,j+1))/2)^2);  
      
                    Wn=1/sqrt(Un^2+a^2);  
                    We=1/sqrt(Ue^2+a^2);  
                    Ww=1/sqrt(Uw^2+a^2);  
                    Ws=1/sqrt(Us^2+a^2);  
      
                    Hon=Wn/((Wn+We+Ww+Ws)+lambda);  
                    Hoe=We/((Wn+We+Ww+Ws)+lambda);  
                    How=Ww/((Wn+We+Ww+Ws)+lambda);  
                    Hos=Ws/((Wn+We+Ww+Ws)+lambda);  
      
                    Hoo=lambda/((Wn+We+Ww+Ws)+lambda);  
                    value = Hon*img(i-1,j)+Hoe*img(i,j+1)+How*img(i,j-1)+Hos*img(i+1,j)+Hoo*img(i,j);  
                    imgn(i,j)= value;  
                end  
            end  
        end  
        img=imgn;   
    end  
    figure,imshow(img,[]); title('TV修复后');