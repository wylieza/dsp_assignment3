%Upsample Handel to 16384Hz (from 8192Hz)

%Close plots
close all;

%Load in handel
load('handel');
fs = 8192;

%Create an expanded signal array to hold the extra samples
yexp = zeros(2*length(y), 1);

%Every second sample will be from y (handel)
yexp(1:2:end) = y;

%Play the unfiltered, upscaled sound
%soundsc(yexp, 16384);

%View the waveform's replicas in the DTFT domain
%Create fft and freq labling axis
Yexp = fft(yexp);
freq_main = fft_freq_axis(Yexp)*2*fs/1000;

Y = fft(y);
Y_fa = fft_freq_axis(Y)*fs/1000;

subplot(2,1,1);
plot(Y_fa, fftshift(abs(Y)));
title("FFT of original signal 'Handel'");
xlabel("Frequency in kHz");
ylabel("Magnitude of FFT");
xlim([freq_main(1), freq_main(end)]);
subplot(2,1,2)
plot(freq_main, fftshift(abs(Yexp)));
title("FFT of upsampled signal prior to filtering");
xlabel("Frequency in kHz");
ylabel("Magnitude of FFT");
xlim([freq_main(1), freq_main(end)]);

%save to file
print(gcf, '-dpng', 'upsampling_prefilter_fft.png') %Save as png

%View the signals in the time domain
figure();
duration = 0.02; %Plot length in seconds
%Plot original
subplot(2,1,1);
time_axis = (0:1:length(y))/fs;
plot(time_axis(1:ceil(duration*fs)), y(1:ceil(duration*fs)));
title("Time Domain plot of original signal 'Handel'");
xlabel("Time in seconds");
ylabel("Sample Value");
%Plot unfiltered, upsampled signal
subplot(2,1,2);
time_axis = (0:1:length(yexp))/(2*fs);
plot(time_axis(1:ceil(duration*2*fs)), yexp(1:ceil(duration*2*fs)));
title("Time Domain plot of upsampled signal prior to filtering");
xlabel("Time in seconds");
ylabel("Sample Value");

%save to file
print(gcf, '-dpng', 'upsampling_prefilter_time.png') %Save as png



%The replica is the upper half of the frequency spectrum, thus the
%downsampling lpf should work fine as it will remove the top half of the
%frequencies.

%Filter to remove top half (relative to fs) of higher frequencies
load('lp_downsampling_fc');

%Perform filtering action
yexpf = conv(yexp, lp_downsampling_fc);


%Plot the results, roughly comparing original to upsampled version us DTFT
%Create fft and freq labling axis
Yexpf = fft(yexpf);
freq_main = fft_freq_axis(Yexpf)*2*fs/1000;

Y = fft(y);
Y_fa = fft_freq_axis(Y)*fs/1000;

figure();
subplot(2,1,1);
plot(Y_fa, fftshift(abs(Y)));
title("FFT of original signal 'Handel'");
xlabel("Frequency in kHz");
ylabel("Magnitude of FFT");
xlim([freq_main(1), freq_main(end)]);
subplot(2,1,2)
plot(freq_main, fftshift(abs(Yexpf)));
title("FFT of upsampled signal after filtering");
xlabel("Frequency in kHz");
ylabel("Magnitude of FFT");
xlim([freq_main(1), freq_main(end)]);

%save to file
print(gcf, '-dpng', 'upsampling_postfilter_fft.png') %Save as png

%View the signals in the time domain
figure();
duration = 0.02; %Plot length in seconds
%Plot original
subplot(2,1,1);
time_axis = (0:1:length(y))/fs;
plot(time_axis(1:ceil(duration*fs)), y(1:ceil(duration*fs)));
title("Time Domain plot of original signal 'Handel'");
xlabel("Time in seconds");
ylabel("Sample Value");
%Plot unfiltered, upsampled signal
subplot(2,1,2);
time_axis = (0:1:length(yexpf)-1)/(2*fs); %105 is a sample offset that needs to be corrected
plot(time_axis, yexpf);
title("Time Domain plot of upsampled signal after filtering");
xlabel("Time in seconds");
ylabel("Sample Value");
xlim([0.00641, duration+0.00641]);

%save to file
print(gcf, '-dpng', 'upsampling_postfilter_time.png') %Save as png


%Play the correctly upsampled track
%soundsc(yexpf, 16384);


