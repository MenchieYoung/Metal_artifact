function l=h_line(imag)
s=edge(imag,'canny',0.07,2);  %T=0.0745是用s=edge（imag，‘canny’）自动得出的   越小的话细节越多
[H,~,~]=hough(s,'Theta',-90:0.2:89.8);
l=max(max(H));
