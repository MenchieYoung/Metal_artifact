     function new=fillsmallholes(bw,threshold)    %ȥ�����С�ĺ�ɫ��ͨ����   %ԭ����imfill��ָ��С��������
    % Fill small holes in the binary image bw using the threshold, only holes
    % with areas smaller than threshold will be filled

    filled = imfill(bw, 'holes');     %�Ѱ�ɫȦ�ڵ����ϰ�ɫ����һ����ͼ����������
    
    holes = filled & ~bw;               
 
      bigholes = bwareaopen(holes, threshold);  %ȥ�����С�ڶ��ٵ���ͨ�����ұ����Ǻ�ɫ��0��

      smallholes = holes & ~bigholes;
% 
   new = bw | smallholes;
