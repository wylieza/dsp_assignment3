%filter out narrow band interference

%Clear any open plot windows
close all;

load handel;
%y(length(y)) = [];
fs = 8192; %Audio sampling frequency
num_samples = length(y);

%Generate tone at 200Hz and add it to handel to create yc
a0 = 1; %Magnitude
fi = 200; %Frequency (Hz)
w0 = 2*pi/fs*fi; %Frequency in rad/s
yc = y + a0*sin(w0*(1:length(y))'); %New and corrupted siganal

if(0)
%Plot the corrupted signal
figure();
freq_arr = fft_freq_axis(abs(fft(yc))).*fs/(2*pi);
plot(freq_arr, 20.*log10(fft_shift(abs(fft(yc)))));
title("FFT of 'handel' after adding a 200Hz interference signal");
xlabel("Frequency in (Hz)");
xlim([freq_arr(1), freq_arr(length(freq_arr))]);
ylabel("Magnitude of FFT (dB)");
%ylim([-60, 100]);
print(gcf, '-dpng', 'corrupted_handel_200hz.png') %Save as png
end

%Play the corrupted signal
%soundsc(yc, fs);

%FREQZ FOR FIR
%load the filter coeff
load('hp_firfilter_200hz');

%determine the filters frequency response
mag_response = abs(freqz(hp_firfilter_200hz, 1, 1000));
phase_response = angle(freqz(hp_firfilter_200hz, 1, 1000));
frequency_labeling = fs/(2*pi)*(0:2*pi/length(mag_response):2*pi - 2*pi/length(mag_response));

%plot the filters frequency response
figure();
subplot(2,1,1);
plot(frequency_labeling, 20*log10(mag_response));
title("FIR HP Filter Frequency Response");
xlabel("Frequency (Hz)");
xlim([0, 2000]);
ylabel("Magnitude (dB)");

subplot(2,1,2);
plot(frequency_labeling, phase_response)
xlabel("Frequency (Hz)");
xlim([0, 2000]);
ylabel("Phase (Rad)");

%save to file
print(gcf, '-dpng', 'hpfir_200hz_freqz.png') %Save as png


%FREQZ FOR IIR
%load the filter coeff
load('iirfilter_hp_200hz');

%determine the filters frequency response
mag_response = abs(freqz(iirfilter_hp_200hz_SOS, 1000));
phase_response = angle(freqz(iirfilter_hp_200hz_SOS, 1000));
frequency_labeling = fs/(2*pi)*(0:2*pi/length(mag_response):2*pi - 2*pi/length(mag_response));

%plot the filters frequency response
figure();
subplot(2,1,1);
plot(frequency_labeling, 20*log10(mag_response));
title("IIR HP Filter Frequency Response");
xlabel("Frequency (Hz)");
xlim([0, 2000]);
ylabel("Magnitude (dB)");

subplot(2,1,2);
plot(frequency_labeling, phase_response)
xlabel("Frequency (Hz)");
xlim([0, 2000]);
ylabel("Phase (Rad)");

%save to file
print(gcf, '-dpng', 'hpiir_200hz_freqz.png') %Save as png


if(0)
%Filter the corrupted signal using the bandstop filter
ycf = conv(yc, hp_firfilter_200hz);
    
%Plot the result after filtering (my fftshift)
figure();
subplot(2,1,1);
freq_arr = fft_freq_axis(abs(fft(ycf))).*fs/(2*pi);
plot(freq_arr, 20.*log10(fft_shift(abs(fft(ycf)))));
title("FFT after filtering using a 200Hz FIR HP-Filter");
xlabel("Frequency (Hz)");
%xlim([freq_arr(1), freq_arr(length(freq_arr))]);
xlim([-1000 1000]);
ylabel("Magnitude of FFT (dB)");
%ylim([-60, 100]);

subplot(2,1,2);
freq_arr = fft_freq_axis(abs(fft(ycf))).*fs/(2*pi);
plot(freq_arr, fft_shift(angle(fft(ycf))));
xlabel("Frequency (Hz)");
%xlim([freq_arr(1), freq_arr(length(freq_arr))]);
xlim([-1000 1000]);
ylabel("Anlge of FFT (Rad)");


print(gcf, '-dpng', 'hpfir_200hz_filtering_result.png') %Save as png

end

%Play the recovered signal
%soundsc(ycf, fs);

