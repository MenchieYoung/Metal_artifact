     function new=fillsmallholes(bw,threshold)    %去除面积小的黑色连通区域   %原意是imfill的指定小的面积填充
    % Fill small holes in the binary image bw using the threshold, only holes
    % with areas smaller than threshold will be filled

    filled = imfill(bw, 'holes');     %把白色圈内的填上白色。。一整副图都被填上了
    
    holes = filled & ~bw;               
 
      bigholes = bwareaopen(holes, threshold);  %去掉面积小于多少的连通区域，且背景是黑色（0）

      smallholes = holes & ~bigholes;
% 
   new = bw | smallholes;
