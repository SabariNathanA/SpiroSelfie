%% Smart Spirometer
% A trial by Beginners' united
% This will be the main function calling every other part
function name = main(filename)
toRead = filename
s2 = '.wav';
toRead = strcat(toRead,s2)
[breathOriginalData,samplingRate] = audioread(toRead);
LPCpressure = SignalProcess(breathOriginalData);
%plot(LPCpressure);

chead= 50;
darm = 58;
cspeed = 34029;
pressureLips = zeros(size(breathOriginalData));
for i=1:(size(breathOriginalData))
    pressureLips(i) = (chead/darm);
    justavariable = exp(-1*(darm/cspeed));
    pressureLips(i) = breathOriginalData(i)*justavariable*pressureLips(i);
end
LPCpressureAtLips = SignalProcess(pressureLips);
%figure
%plot(LPCpressureAtLips);
%title('plips(t)')
%% Plips to ulips
ulips = size(pressureLips);
for i=1:(size(pressureLips))
    ulips(i) = 2*pi*4.5*4.5;
    justavariable = sqrt(2*pressureLips(i));
    ulips(i) = ulips(i)*justavariable;
end

LPCFlowAtLips = SignalProcess(ulips);
%figure
%plot(LPCFlowAtLips);
%title ('flowlpc')

Regression(LPCpressure,toRead,filename);
%{
Regression(LPCpressureAtLips)
Regression(LPCFlowAtLips)
Regression(LPCpressure)
title('pressure regressed')
Regression(LPCpressureAtLips)
title('pressure at lips')
Regression(LPCFlowAtLips)
title('flow volume at lips')
%}
%{
AnalysePLips = Regression(LPCpressureAtLips)
AnaylseFlowLips = Regression(LPCFlowAtLips)
%}
disp (filename);
%figure
%plot(LPCFlowAtLips);
%print(filename,'-djpeg');