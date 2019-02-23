function [ x2 ] = median_filter( image, m )
%----------------------------------------------
%��ֵ�˲�
%���룺
%image��ԭͼ
%m��ģ��Ĵ�С3*3��ģ�壬m=3

%�����
%img����ֵ�˲�������ͼ��
%----------------------------------------------
    n = m;
    [ height, width ] = size(image);
    x1 = double(image);
    x2 = x1;
    for i = 1:n:height-n+1
        for j = 1:n:width-n+1
            mb = x1( i:(i+n-1),  j:(j+n-1) );
            mb = mb(:);  %���кϲ���һ�����������
            mm = median(mb);
            x2( i+(n-1)/2,  j+(n-1)/2 ) = mm;  %ÿ���㶼����ֵΪ����ģ�������е����ֵ
           
        end
    end
        % x2(3,3)=mm;
   % img = uint8(x2);
   % figure,imshow(x2,[]);title('median'),hold on;
end