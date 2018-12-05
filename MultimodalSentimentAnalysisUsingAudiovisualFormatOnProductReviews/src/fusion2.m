function [ finalotp ] = fusion2()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
finalotp='';
[posa,nega]=list2();
disp(posa);
disp(nega);
[pos,neg]=expression2();
finalp=posa+pos;
finaln=nega+neg;
if(finalp>finaln)
    disp('Total Review is postive');
   finalotp='Product Review has Postive Sentiment';
else if(finalp==finaln)
	disp('Total review is Neutral');
   finalotp='Product Review has Postive Sentiment';
else
    disp('Total Review is Negative');
    finalotp='Product Review has Postive Sentiment';
end
end

end





