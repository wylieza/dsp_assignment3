function freq_axis = fft_freq_axis(fft_in)    
    if(mod(length(fft_in),2) == 0) %Even
        freq_axis = -pi:2*pi/length(fft_in):(pi-2*pi/length(fft_in));       
    else %Odd
        freq_axis = -pi+(pi/length(fft_in)):2*pi/length(fft_in):pi-(pi/length(fft_in));     
    end
end