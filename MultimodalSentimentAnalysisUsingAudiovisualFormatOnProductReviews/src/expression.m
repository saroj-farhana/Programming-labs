function [ output ] = expression()

%I=rgb2gray(I);
I=evalin('base','z1');
F=evalin('base','z2');
output='';
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    AA=step(EyeDetect,I);
    %rectangle('Position',AA,'LineWidth',4,'LineStyle','-','EdgeColor','r');
    MouthDetector=vision.CascadeObjectDetector('Mouth','MergeThreshold',40);
    BB=step(MouthDetector,I);
    NoseDetector=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
    CC=step(NoseDetector,I);
    eyes=AA;
    nose=CC;
    mouth=BB;
    disp('Base Image Feature points');
    disp(AA);
    disp(CC);
    disp(BB);
    jj=CC(1,:);
    dd=BB(1,:);
    aa=step(EyeDetect,F);
    %rectangle('Position',aa,'LineWidth',4,'LineStyle','-','EdgeColor','r');
    MouthDetector=vision.CascadeObjectDetector('Mouth','MergeThreshold',40);
    bb=step(MouthDetector,F);
    NoseDetector=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
    cc=step(NoseDetector,F);
    corners1 = detectMinEigenFeatures(cc);
        eyepts1=corners1.selectStrongest(6);
        plot(eyepts1);
    disp(int32(eyepts1.Location));
   
    eyes=aa;
    nose=cc;
    mouth=bb;
    disp('Test Image Feature points');
    disp(aa);
    disp(cc);
    disp(bb);
    ss=cc(1,:);
    gg=bb(1,:);
    nose_dist=sqrt(sum((jj-ss).^2));
    nose_dist=int32(nose_dist);
    eye_dist=sqrt(sum((AA-aa).^2));
    mouth_dist=sqrt(sum((dd-gg).^2));
    eye_dist=int32(eye_dist);
    mouth_dist=int32(mouth_dist);
    disp(eye_dist);
    disp(nose_dist);
     disp(mouth_dist);
    sup=0;
    sad=0;
    smi=0;
    neu=0;
    dis=0;
   if(eye_dist>10 && mouth_dist<10)
            dis=dis+1;
        disp('Test Image Expression is Disgust');
        output='Expression is Disgust';
   else if(mouth_dist>10)
            sup=sup+1;
            disp('Test Image Expression is suprise');
            output='Expression is suprise';
    else if(nose_dist>7)
            sad=sad+1;
            disp('Test Image Expression is sad');
            output='Expression is sad';
    else if(mouth_dist>=2&&mouth_dist<=10)
            smi=smi+1;
        disp('Test Image Expression is smile');
        output='Expression is smile';

     else
            disp('Test image Expression is neutral');
            neu=neu+1;
            output='Expression is neutral';
        end
        end
       end
   end



end

    
    



    
    
