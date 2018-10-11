%Input Matrix S stores all the control points of all the patches of
%a Bezier surface such that
%Size of S(:,:,:) is 4 x 4 x 3, i.e., 16 control points and each
%control point has three coordinates (x,y,z)
%S(:,:,1): x-coordates of control points of kth patch as 4 x 4 matrix 
%S(:,:,2): y-coordates of control points of kth patch as 4 x 4 matrix 
%S(:,:,3): z-coordates of control points of kth patch as 4 x 4 matrix

function rtn = bezier_surface(S)

[r c dim]=size(S);

az=21;  %azimuth
el=19;  %elevation. 

lw=1; %plotting linewidth

str1='\bf Control Point';
str2='\bf Control Polygon';
str3='\bf Surface (bi-directional Bezier curve)';

% %-----------------------------------------------
% % For plotting it is convenient if we reshape the data
% % into vecotor format and separate (X,Y,Z) coordinates

xS=[]; yS=[]; zS=[];
     xS =horzcat(xS, reshape(S(:,:,1),1,[])); 
     yS =horzcat(yS, reshape(S(:,:,2),1,[]));
     zS =horzcat(zS, reshape(S(:,:,3),1,[]));     
% % Plot of Surface using control points 
figure, hold on
surface(S(:,:,1),S(:,:,2),S(:,:,3),'FaceColor','green')
title('\bf Bezier Surface using Control Points');
view(3); box;  view(az,el)
end

%Command to run
%S(:,:,1) = [1.3 1.3 1.3 1.3; 2.5 2.5 2.5 2.5; 3.1 3.1 3.1 3.1; 4.7 4.7 4.7 4.7]
%S(:,:,2) = [0.4 0.5 0.7 0.9; 0.4 0.5 0.7 0.9; 0.4 0.5 0.7 0.9; 0.4 0.5 0.7 0.9]
%S(:,:, 3) = [2.792 2.949 3.314 3.760; 3.992 4.149 4.514 4.960; 4.592 4.749 5.114 5.560; 6.192 6.349 6.714 7.160]
%bezier_surface(S)