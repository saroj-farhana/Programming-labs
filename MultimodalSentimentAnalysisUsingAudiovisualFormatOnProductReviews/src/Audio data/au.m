[posa,nega]=list2();
disp(posa);
disp(nega);
[pos,neg]=expression2();
finalp=posa+pos;
finaln=nega+neg;
if(finalp>finaln)
    disp('Total Review is postive');
else if(finalp==finaln)
	disp('Total review is Neutral');
else
    disp('Total Review is negative');
end
end

