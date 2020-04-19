%downsample handel to 4192
%max frequency allowable is 2048Hz

%Clear any open plot windows
close all;

load handel;
fs = 8192; %Audio sampling frequency
num_samples = length(y);

%filter to remove all higher frequencies
load('lp_downsampling_fc');

%show the filter's frequency response
%FREQZ FOR FIR low-pass
%load the filter coeff

%determine the filters frequency response
mag_response = abs(freqz(lp_downsampling_fc, 1, 1000));
phase_response = angle(freqz(lp_downsampling_fc, 1, 1000));
frequency_labeling = (fs/2)/(2*pi)*(0:2*pi/length(mag_response):2*pi - 2*pi/length(mag_response));

%plot the filters frequency response
figure();
subplot(2,1,1);
plot(frequency_labeling, 20*log10(mag_response));
title("FIR LP Filter Frequency Response");
xlabel("Frequency (Hz)");
xlim([0, frequency_labeling(end)]);
ylabel("Magnitude (dB)");

subplot(2,1,2);
plot(frequency_labeling, phase_response)
xlabel("Frequency (Hz)");
xlim([0, frequency_labeling(end)]);
ylabel("Phase (Rad)");

%save to file
print(gcf, '-dpng', 'lp_downsampling_response.png') %Save as png




%lowpass handel
y_lp = conv(y, lp_downsampling_fc);

%downsample filtered signal by removing every second sample
yd2 = y_lp(1:2:end);

%compare the correctly downsampled version to the aliased version
%correct version
%soundsc(yd2, 4192); 

%aliased version
%soundsc(y(1:2:end)), 4192);



%downsample a second time
%lowpass handel
y_lp = conv(yd2, lp_downsampling_fc);

%downsample filtered signal by removing every second sample
yd4 = y_lp(1:2:end);

%compare the correctly downsampled version to the aliased version
%correct version
%soundsc(yd4, 2091); 

%aliased version
%soundsc(y(1:4:end), 2091);
    