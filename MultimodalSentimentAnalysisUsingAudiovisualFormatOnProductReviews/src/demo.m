function [vidoutput] = demo( )
vidoutput='';
reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end
s1=evalin('base','z1');
s2=evalin('base','z2');
I=im2single(s1);
detector = buildDetector();
[bbox bbimg faces bbfaces] = detectFaceParts(detector,I,2);

lefteye1= bbox(:, 5: 8);
a=imcrop(I,lefteye1);
a=rgb2gray(a);
righteye1=bbox(:, 9:12); 
nose1=bbox(:,17:20);
b=imcrop(I,nose1);
b=rgb2gray(b);
mouth1=bbox(:,13:16);
c=imcrop(I,mouth1);
c=rgb2gray(c);
disp('Lefteye points')
disp(lefteye1);
disp('Rightteye points')
disp(righteye1);
disp('Nose points')
disp(nose1);
disp('Mouth points')
disp(mouth1);


for i=1:size(bbfaces,1)
 figure;imshow(bbfaces{i});
end
%[File_Name Path_Name]=uigetfile({'*.jpg'},'Select Test Image');
F=im2single(s2);
detector = buildDetector();
[bbox bbimg faces bbfaces] = detectFaceParts(detector,F,2);

lefteye2= bbox(:, 5: 8);
a1=imcrop(F,lefteye2);
a1=rgb2gray(a1);
righteye2=bbox(:, 9:12);
nose2=bbox(:,17:20);
b1=imcrop(F,nose2);
b1=rgb2gray(b1);
mouth2=bbox(:,13:16); 
c1=imcrop(F,mouth2);
c1=rgb2gray(c1);
disp('Lefteye points')
disp(lefteye2);
disp('Rightteye points')
disp(righteye2);
disp('Nose points')
disp(nose2);
disp('Mouth points')
disp(mouth2);

for i=1:size(bbfaces,1)
 figure;imshow(bbfaces{i});
end
corners1 = detectMinEigenFeatures(a);
eyepts1=corners1.selectStrongest(6);
figure, imshow(a), title('Detected faces'); hold on; 
plot(eyepts1);
disp(int32(eyepts1.Location));

corners2 =detectMinEigenFeatures(a1);
eyepts2=corners2.selectStrongest(6);
plot(eyepts2);
disp(int32(eyepts2.Location));

corners3 = detectMinEigenFeatures(b);
nose1=corners3.selectStrongest(4);
figure, imshow(b), title('Detected faces'); hold on; 
plot(nose1);
disp(int32(nose1.Location));

corners4= detectMinEigenFeatures(b1);
nose2=corners4.selectStrongest(4);
plot(nose2);
disp(int32(nose2.Location));

corners5 =detectMinEigenFeatures(c);
mouth1=corners5.selectStrongest(8);
plot(mouth1);
disp(int32(mouth1.Location));

corners6=detectMinEigenFeatures(c1);
mouth2=corners6.selectStrongest(8);
figure, imshow(c1), title('Detected faces'); hold on; 
plot(mouth2);
disp(int32(mouth2.Location));
x1=eyepts1.Location(1,:);
y1=eyepts1.Location(2,:);
x2=eyepts2.Location(1,:);
y2=eyepts2.Location(2,:);
x3=nose1.Location(1,:);
y3=nose1.Location(2,:);
x4=nose2.Location(1,:);
y4=nose2.Location(2,:);
x5=mouth1.Location(1,:);
y5=mouth1.Location(2,:);
x6=mouth2.Location(1,:);
y6=mouth2.Location(2,:);
eye_dist=sqrt(sum(((x1-y1)-(x2-y2)).^2));
eye_dist=int32(eye_dist);
nose_dist=sqrt(sum(((x3-y3)-(x4-y4)).^2));
nose_dist=int32(nose_dist);
mouth_dist=sqrt(sum(((x5-y5)-(x6-y6)).^2));
mouth_dist=int32(mouth_dist);
disp('eye-dist');
disp(eye_dist);
disp('nose-dist');
disp(nose_dist);
disp('mouth-dist');
disp(mouth_dist);
sup=0; sad=0; smi=0;neu=0;ang=0;
if(eye_dist<10 && nose_dist<10)
        disp('Test Image Expression is Disgust');
        ang=ang+1;
        vidoutput='Expression is Disgust';
else if(nose_dist>10 && mouth_dist<10)
    disp('Test Image Expression is sad');
    vidoutput='Expression is sad';
    sad=sad+1;
else if(mouth_dist>40 || eye_dist>40)
        disp('Test Image Expression is suprise');
        vidoutput='Expression is surprise';
        sup=sup+1;
else if(mouth_dist>10 && mouth_dist<40)
        disp('Test Image Expression is smile');
        vidoutput='Expression is smile';
        smi=smi+1;

else
        disp('Test image Expression is neutral');
        vidoutput='Expression is neutral';
        neu=neu+1;
    end
    end
    end
  
end

%{
 img = imrotate(img,180);
 detector = buildDetector(2,2);
 [fp bbimg faces bbfaces] = detectRotFaceParts(detector,img,15,2);

 figure;imshow(bbimg);
 for i=1:size(bbfaces,1)
  figure;imshow(bbfaces{i});
 end
%}


end

