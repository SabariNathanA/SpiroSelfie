
function LPCtobeReturn = SignalProcess(bOD) 
clearvars -except bOD;
samplingRate = 8000;
breathHilbertData = hilbert(abs(bOD));
%figure

%plot(abs(breathHilbertData));
%title ('hilbert')
%% Adding back to the original signal
breathAddedData = abs(breathHilbertData) + abs(bOD);
%figure
%plot(abs(breathAddedData));
%title ('added')
%% The low pass filtering - custom
%lpf = zeros(size(breathAddedData));
%lpf(1) = breathAddedData(1);
%for i=2:(size(breathAddedData))
%    lpf(i) = (breathAddedData(i) + breathAddedData(i-1))/2;
%end
%%plot (lpf);

%% Low Pass Filter - ButterWorth filter as per the reference in paper 20-2000Hz are the frequency of breath sounds 
[NumForLPF, DenomForLPF] = butter(4,0.5);
% 0.5 because fs/2 = 4000. fc/fs/2 = 0.5
lpf = filter(NumForLPF,DenomForLPF,breathAddedData);
%figure
%plot(lpf);
%title ('lpf')
%% Downsampling
downsampledLPF = decimate(lpf,121);
 %%plot (downsampledLPF);
% done with the HILBERT
%% Buffering into 30ms frame 
bufferedOriginalData = zeros();
k=1;
j=1;
oneframetime = 1/samplingRate;
frameOf30 = 0.030/oneframetime;
frameOf30with50overlap = frameOf30/2;
endindex = size(bOD);
endindex1 = endindex(1);
endindex2 = endindex(2);
endindex = max(endindex1,endindex2);
for i=1:frameOf30with50overlap:(endindex-frameOf30)
    m=i+frameOf30;    
    sum = 0;
    for j=i:m
        sum = sum + bOD(j);
    end
    bufferedOriginalData(k) = sum/frameOf30;
    k=k+1;
end


bufferedOriginalData = bufferedOriginalData.';
n=(size(bOD));first=n(1);
second = n(2);%% ??
n= max(first,second);
n1=n;
n=n-j;
sum=0;
for j=j:n1
    sum = sum+bOD(j);
end
bufferedOriginalData(k) = sum/n;
%plot (abs(bufferedOriginalData));
%title ('buffered')
%% LPC phase
LPCOriginalData = size(bufferedOriginalData);
frame_2_order = size(bufferedOriginalData);
k=1;
for i=1:frameOf30with50overlap:(n1-frameOf30)
    m=i+frameOf30;
    sum =zeros(frameOf30);
    % sum contains the 30ms overlapping frame
    sum = bOD(i:m);
    
    % lpc gives us the model_estimate = the roots of poles
    % at which the LPC filter works best for that  frame
    % variance provided is the square of the LPC gain
    % which in turn is the 'source power that excites the
    % filter.
    [model_estimate2,variance2]=lpc(abs(sum),2);
    [model_estimate4,variance4]=lpc(abs(sum),4);
    [model_estimate8,variance8]=lpc(abs(sum),8);
    [model_estimate16,variance16]=lpc(abs(sum),16);
    [model_estimate32,variance32]=lpc(abs(sum),32);
    
    % variance --> LPC Gain = Source power
    variance2 = sqrt(variance2);
    variance4 = sqrt(variance4);
    variance8 = sqrt(variance8);
    variance16 = sqrt(variance16);
    variance32 = sqrt(variance32);
    
    % an array of various LPC gains
    array_of_gains = [variance2,variance4,variance8,variance16,variance32];
    % max source power that excites the filter
    max_gain = max(array_of_gains);
    % populating the array
    LPCOriginalData(k) = max_gain;
    
    % populating the order that caused the filter excitation
    if(max_gain == variance2)
        frame_2_order(k) = 2;
    elseif(max_gain == variance4)
        frame_2_order(k) = 4;
    elseif(max_gain == variance8)
        frame_2_order(k) = 8;
    elseif(max_gain == variance16)
        frame_2_order(k) = 16;
    elseif(max_gain == variance32)
        frame_2_order(k) = 32;
    end
    k=k+1;
end
LPCtobeReturn = LPCOriginalData;
%figure
%plot(LPCOriginalData);
%title ('lpc')