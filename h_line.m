function l=h_line(imag)
s=edge(imag,'canny',0.07,2);  %T=0.0745����s=edge��imag����canny�����Զ��ó���   ԽС�Ļ�ϸ��Խ��
[H,~,~]=hough(s,'Theta',-90:0.2:89.8);
l=max(max(H));
