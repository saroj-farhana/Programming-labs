function [ finalotp ] = fusion()
finalotp='';
[posa,nega]=list2();
disp(posa);
disp(nega);
[pos,neg]=demo2();
finalp=posa+pos;
finaln=nega+neg;
if(finalp>finaln)
    disp('Total Review is postive');
    finalotp='Product Review has Postive Sentiment';
else if(finalp==finaln)
	disp('Total review is Neutral');
    finalotp='Product Review has Neutral Sentiment';
else
    disp('Total Review is Negative');
    finalotp='Product Review has Negative Sentiment';
end
end

end

