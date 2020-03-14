% uncoded
BER0   = [];
bits  = randi([0 1],1,1e6);                    % data sequence

for SNR   = 0:2:30;
Tx        = (bits.*2)-1;                      % BPSK modulation
Rx        = awgn(Tx,SNR);                        % Received signal after adding awgn.
Rxdet     = Rx>=0.5;                               % BPSK demodulation
[neo,ber] = biterr(bits,Rxdet);                % BER of data sequence
BER0       = [BER0 ber];                           % Array of BER
end

%  repition
% simulation starting data part %
% identifying Simulation parameters:
n=1e6;                   % Number of bits/SNR=1 million bits
SNR=0:2:30;              % Signal to noise ratio range in dB
snr=10.^(SNR/10);        % Signal to noise ratio
Pe_3=zeros(1,16);
Pe_5=zeros(1,16);
Pe_11=zeros(1,16);
% TX 
bits=randi([0,1],1,n);                              %Generate random binary data vector(1 x n)
bits_repeated_3 = repelem(bits,3);                        % repeating each bit 3 times
bits_repeated_5 = repelem(bits,5);                        % repeating each bit 5 times
bits_repeated_11 = repelem(bits,11);                      % repeating each bit 11 times
bits_repeated_3=((2*bits_repeated_3)-1)*(sqrt(1/3));% modulating the bits and normalizing their energy 
bits_repeated_5=((2*bits_repeated_5)-1)*(sqrt(1/5));% modulating the bits and normalizing their energy 
bits_repeated_11=((2*bits_repeated_11)-1)*(sqrt(1/11));% modulating the bits and normalizing their energy 
% RX

%recovering the original bit stream and removing the noise effect 
%by comparing each bit with a certain threshold = 1/2
for i=1:16
    noise=(sqrt(1/(2*snr(i))))*(randn(1,3*n)+(1j*randn(1,3*n)));
    Rx_sequence_3=bits_repeated_3+noise;
    noise=(sqrt(1/(2*snr(i))))*(randn(1,5*n)+(1j*randn(1,5*n)));
    Rx_sequence_5=bits_repeated_5+noise;
    noise=(sqrt(1/(2*snr(i))))*(randn(1,11*n)+(1j*randn(1,11*n)));
    Rx_sequence_11=bits_repeated_11+noise;
     
    %recovering bits in case of n=3
    %==============================
    Rx_bits_3=(real(Rx_sequence_3)>=0);
    Rx_bits_3=reshape(Rx_bits_3,3,n);
    s=sum(Rx_bits_3);
    Rx_3=(s>=2);
    % calculating the number of error bits in the sequence
    [~,Pe_3(i)]=biterr(bits,Rx_3);
    % calculating the probability of error in each sequence
    
    %recovering bits in case of n=5
    %==============================
    Rx_bits_5=(real(Rx_sequence_5)>=0);
    Rx_bits_5=reshape(Rx_bits_5,5,n);
    s=sum(Rx_bits_5);
    Rx_5=(s>=3);
    % calculating the number of error bits in the sequence
    [~,Pe_5(i)]=biterr(bits,Rx_5);
    % calculating the probability of error in each sequence
    
    %recovering bits in case of n=11
    %==============================
    Rx_bits_11=(real(Rx_sequence_11)>=0);
    Rx_bits_11=reshape(Rx_bits_11,11,n);
    s=sum(Rx_bits_11);
    Rx_11=(s>=6);
    % calculating the number of error bits in the sequence
    [~,Pe_11(i)]=biterr(bits,Rx_11);
   % calculating the probability of error in each sequence    
end

%   plotting part 

SNR=0:2:30;
figure;
semilogy(SNR,Pe_3,'r-*','LineWidth',2)
hold on;
semilogy(SNR,Pe_5,'g-*','LineWidth',2)
hold on;
semilogy(SNR,Pe_11,'b-*','LineWidth',2)
 hold on;
semilogy (SNR,BER0,'k','linewidth',2);                                    %semilogy plot between BER & SNR
xlabel   ('SNR(dB)');
ylabel   ('BER');
grid on
legend('repetition code n=3','repetition code n=5','repetition code n=11','uncoded case');

