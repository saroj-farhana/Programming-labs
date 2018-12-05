[File_Name Path_Name]=uigetfile({'*.tiff'},'Select Base Image');
baseimage=strcat(Path_Name,File_Name);
I=imread(baseimage);
%I=rgb2gray(I);
for i=1:4
    [File_Name Path_Name]=uigetfile({'*.tiff'},'Select Test Image');
    testimage=strcat(Path_Name,File_Name);
    disp(testimage);
    F=imread(testimage);
    %F=rgb2gray(F);
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    AA=step(EyeDetect,I);
    figure,imshow(I);
    rectangle('Position',AA,'LineWidth',4,'LineStyle','-','EdgeColor','r');
    MouthDetector=vision.CascadeObjectDetector('Mouth','MergeThreshold',40);
    BB=step(MouthDetector,I);
    NoseDetector=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
    CC=step(NoseDetector,I);
    hold on
    for i=1:size(CC,1)
        rectangle('Position',CC(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
    end
    for i=1:size(BB,1)
        J=rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
    end
    hold off;
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
    figure,imshow(F);
    rectangle('Position',aa,'LineWidth',4,'LineStyle','-','EdgeColor','r');
    MouthDetector=vision.CascadeObjectDetector('Mouth','MergeThreshold',40);
    bb=step(MouthDetector,F);
    NoseDetector=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
    cc=step(NoseDetector,F);
    hold on
    for i=1:size(cc,1)
        rectangle('Position',cc(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
    end
    hold off
    hold on
    for i=1:size(bb,1)
        J=rectangle('Position',bb(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
    end
    hold off;
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
    sup=0;
    sad=0;
    smi=0;
    neu=0;
    if(mouth_dist>10)
            sup=sup+1;
            disp('Test Image Expression is suprise');
    else if(nose_dist>7)
            sad=sad+1;
            disp('Test Image Expression is sad');
    else if(mouth_dist>=2&&mouth_dist<=10)
            smi=smi+1;
        disp('Test Image Expression is smile');


     else
            disp('Test image Expression is neutral');
            neu=neu+1;
        end
        end
    end

end
if(smi>sup && smi>sad && smi>neu)
    disp('Final video expressio is smile i.e postive');
else if(sup>smi && sup>sad && sup>neu)
    disp('Final video expressio is suprise i.e postive');   
else if(sad>smi && sad>sup && saf>neu)
    disp('Final video expressio is sad i.e negative'); 
else
    disp('Final video expression is neutral')
    end
    end
end

    
    



    
            
