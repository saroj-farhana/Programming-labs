function [ posa,nega ] = list2()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[File_Name Path_Name]=uigetfile({'*.xlsx'},'Select Review Data');
  some=strcat(Path_Name,File_Name);
data=xlsread(some);
intensity=data(:,1);
pitch=data(:,2);
%imshow(intensity);
a=max(intensity);
b=min(intensity);
x=mean(intensity);
c=max(pitch);
d=min(pitch);
y=mean(pitch);
disp('max Intensity:');
disp(a);
disp('min Intensity:');
disp(b);
disp('mean of Intensity:');
disp(x);
disp('max Pitch:');
disp(c);
disp('min Pitch:');
disp(d);
disp('mean of Pitch:');
disp(y);
xx=var(intensity);
yy=var(pitch);
sd1=sqrt(xx);
sd2=sqrt(yy);
count=0;
xy=0;
disp('variance of Intensity:');
disp(xx);
disp('Standard Deviation of Intensity:');
disp(sd1);
disp('variance of pitch:');
disp(yy);
disp('Standard Deviation of pitch:');
disp(sd2);

for i=1:99
    xy=xy+(intensity(i)-x)*(pitch(i)-y);
    if(pitch(i)==0)
        count=count+1;
    end
end
xy=xy/99;
disp('covariance is:');
disp(xy);
corr=xy/sqrt(xx*yy);
disp('correlation is :');
disp(corr);
disp('Pauses coount');
disp(count);
posa=0;
nega=0;
if(c>400 && count>35)
    disp('Audio review is postive');
    posa=posa+1;
else if(x>50 && count<35)
        disp('Audio review is negative');
        nega=nega+1;
    else
          disp('Audio is neutral');
    end
end
end

