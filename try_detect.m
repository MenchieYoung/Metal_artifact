load('image7.mat');
imag=image7;
s6=Detect_artifact(imag);
figure,imshow(imag,[]);title('原');
figure,imshow(imag+0.1*(~s6),[]);
figure,imshow(s6,[]);title('artifact');

[high,width]=size(s6);
% for i=1:high
%     for j=1:width
%         if s6(i,j)==0
%             sum=0;
%             k=0;
%             for a=-20:20
%                 for b=-20:20
%                     if s6(i+a,j+b)~=0
%                         sum=sum+imag(i+a,j+b);
%                         k=k+1;
%                     end
%                 end
%             end
%             imag(i,j)=sum/k;
%         end
%     end
% end
a=5;
imag2=zeros(2*a+1);
for i=3:1:high-2
    for j=3:1:width-2
        if s6(i,j)==0
             for b=-5:1:5   %相当于把s6里的线加粗，但并不是直接置0，否则中位数可能为0
              imag2=imag(i+b+(-a:1:a),j+b+(-a:1:a));
              imag2=imag2(:);
              mm = median(imag2);
              imag(i+b,j+b)=mm;
             end
        end
    end
end
figure,imshow(imag,[]);title('无伪影')
                        
                   
