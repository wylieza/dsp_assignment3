function fft_out = fft_shift(fft_in)
    len_positive = ceil(length(fft_in)/2); %If even l/2 if odd l/2 +1
    
    if (mod(length(fft_in), 2) == 0) %Even
        fft_out(1:len_positive) = fft_in(len_positive+1:length(fft_in));
        fft_out(len_positive+1:length(fft_in)) = fft_in(1:len_positive);
    else %Odd
        fft_out(1:len_positive-1) = fft_in(len_positive+1:length(fft_in));
        fft_out(len_positive:length(fft_in)) = fft_in(1:len_positive);  
    end
    
    
end