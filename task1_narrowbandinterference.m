%filter out narrow band interference

%Clear any open plot windows
close all;

load handel;
%y(length(y)) = [];
fs = 8192; %Audio sampling frequency
num_samples = length(y);

%Generate tone at 1024Hz and add it to handel to create yc
a0 = 1; %Magnitude
fi = 1024; %Frequency (Hz)
w0 = 2*pi/fs*fi; %Frequency in rad/s
yc = y + a0*sin(w0*(1:length(y))'); %New and corrupted siganal

%Plot the corrupted signal
figure();
freq_arr = fft_freq_axis(abs(fft(yc))).*fs/(2*pi);
plot(freq_arr, 20.*log10(fft_shift(abs(fft(yc)))));
title("FFT of 'handel' after adding 1024Hz signal");
xlabel("Frequency in (Hz)");
xlim([freq_arr(1), freq_arr(length(freq_arr))]);
ylabel("Magnitude of FFT (dB)");
ylim([-60, 100]);
print(gcf, '-dpng', 'corrupted_handel.png') %Save as png

%Play the corrupted signal
%soundsc(yc, fs);

%Filter the corrupted signal using the bandstop filter
load('filter_coeff_1024bs');
ycf = conv(yc, filter_coeff);

%Plot the result after filtering (my fftshift)
figure();
freq_arr = fft_freq_axis(abs(fft(ycf))).*fs/(2*pi);
plot(freq_arr, 20.*log10(fft_shift(abs(fft(ycf)))));
title("FFT of 'handel' after filtering out the 1024Hz signal");
xlabel("Frequency (Hz)");
xlim([freq_arr(1), freq_arr(length(freq_arr))]);
ylabel("Magnitude of FFT (dB)");
ylim([-60, 100]);
print(gcf, '-dpng', 'filtering_result.png') %Save as png

%Play the recovered signal
%soundsc(ycf, fs);

