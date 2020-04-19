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

%Plot the corrupted signal in DTFT domain
figure();
freq_arr = fft_freq_axis(abs(fft(yc))).*fs/(2*pi);
plot(freq_arr, 20.*log10(fft_shift(abs(fft(yc)))));
title("FFT of 'handel' after adding 1024Hz signal");
xlabel("Frequency in (Hz)");
xlim([freq_arr(1), freq_arr(length(freq_arr))]);
ylabel("Magnitude of FFT (dB)");
ylim([-60, 100]);

%save plot
%print(gcf, '-dpng', 'corrupted_handel.png') %Save as png

%View the signals in the time domain
figure();
duration = 0.1; %Plot length in seconds
%Plot original
subplot(2,1,1);
time_axis = (0:1:length(y))/fs;
plot(time_axis(1:ceil(duration*fs)), y(1:ceil(duration*fs)));
title("Time Domain plot of original signal 'Handel'");
xlabel("Time in seconds");
ylabel("Sample Value");
%Plot corrupted signal
subplot(2,1,2);
time_axis = (0:1:length(yc))/(fs);
plot(time_axis(1:ceil(duration*fs)), yc(1:ceil(duration*fs)));
title("Time Domain plot of corrupted signal");
xlabel("Time in seconds");
ylabel("Sample Value");

%save plot
%print(gcf, '-dpng', 'corrupted_hande_time_a1.png') %Save as png

%Play the corrupted signal
%soundsc(yc, fs);

%Filter the corrupted signal using the bandstop filter
load('filter_coeff_1024bs');
ycf = conv(yc, filter_coeff);

%Plot the result after filtering (my fftshift) in DTFT domain
figure();
freq_arr = fft_freq_axis(abs(fft(ycf))).*fs/(2*pi);
plot(freq_arr, 20.*log10(fft_shift(abs(fft(ycf)))));
title("FFT of 'handel' after filtering out the 1024Hz signal");
xlabel("Frequency (Hz)");
xlim([freq_arr(1), freq_arr(length(freq_arr))]);
ylabel("Magnitude of FFT (dB)");
ylim([-60, 100]);

%save figure
%print(gcf, '-dpng', 'filtering_result.png') %Save as png

%View the signals in the time domain
figure();
duration = 0.1; %Plot length in seconds
%Plot original
subplot(2,1,1);
time_axis = (0:1:length(y))/fs;
plot(time_axis(1:ceil(duration*fs)), y(1:ceil(duration*fs)));
title("Time Domain plot of original signal 'Handel'");
xlabel("Time in seconds");
ylabel("Sample Value");
ylim([-0.6, 0.6]);
%Plot corrupted signal
subplot(2,1,2);
time_axis = (0:1:length(ycf)-1)/(fs);
plot(time_axis, ycf);
title("Time Domain plot of recovered signal");
xlabel("Time in seconds");
ylabel("Sample Value");
xlim([0.01172, duration + 0.01172])

%save plot
%print(gcf, '-dpng', 'filtered_handel_time.png') %Save as png


%Play the recovered signal
%soundsc(ycf, fs);

