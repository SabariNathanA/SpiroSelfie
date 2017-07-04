function Regression(processedSignal,toRead11,filename)
clearvars -except processedSignal toRead11 filename;

[pks,locs] = findpeaks(processedSignal);
global_pks = max(pks);
global_loc = 1;
disp(size(pks));

%finding location correslonding to global peak
for s = 1 : 1: length(pks)
    %disp(pks(s));
    if( pks(s) == global_pks )
        global_loc = s;
    end 
end

% removing initial data and negatives 
p = 1;

for index2 = locs(global_loc) : length(processedSignal)
    if(processedSignal(index2) > 0 )
        processedSignalpositiveranged(p) = processedSignal(index2);
       
        p = p + 1;
    end
end

%{
figure
plot(processedSignalpositiveranged);
title('regressed positive ranged');
%}

a = locs(global_loc) : 1 : length(processedSignal);
b = linspace(locs(global_loc),length(processedSignal),(length(processedSignal) - locs(global_loc) + 1));
p = polyfit(b,processedSignalpositiveranged,2);
v = polyval(p, locs(global_loc));
%disp(p);
%disp(v);
%disp(size(b));
%disp(length(processedSignal) - locs(global_loc));
%disp(size(processedSignalpositiveranged));
%disp(size(p));
plot(b,processedSignalpositiveranged);
title(filename);
grid;
print(filename,'-djpeg');
s2 = '.txt';
toRead1 = strcat(toRead11,s2);

fileID = fopen(toRead1,'w');
%fmtfile = '%s\t';
fmtval = '%d';
%fprintf(fileID,fmtfile,toRead);
fprintf(fileID,fmtval,v);
% v is the value of pef after fitting
%plot(processedSignalpositiveranged,v,processedSignalpositiveranged,exp(processedSignalpositiveranged))

%{
save('peffile.txt','v','-ascii');
type('peffile.txt');

breathOriginalData(1)
display (myfun(breathOriginalData));
%plot (LPCpositiveranged);
%}
%{
%plot (LPCOriginalData);
%plot(LPCpositive);
%plot(LPCranged);
%plot(LPCpositiveranged);
%}