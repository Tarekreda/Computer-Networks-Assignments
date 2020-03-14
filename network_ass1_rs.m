N = 63;  % Codeword length
K = 51;  % Message length
M = 64;  % Modulation order
numErrors = 200;
numBits = 1e7;
ebnoVec = (8:13)';
[ber0,ber1] = deal(zeros(size(ebnoVec)));
errorRate = comm.ErrorRate;
rsEncoder = comm.RSEncoder(N,K,'BitInput',true);
rsDecoder = comm.RSDecoder(N,K,'BitInput',true);
rate = K/N;
for k = 1:length(ebnoVec)
    
    % Convert the coded Eb/No to an SNR. Initialize the error statistics
    % vector.
    snrdB = ebnoVec(k) + 10*log10(rate) + 10*log10(log2(M));
    errorStats = zeros(3,1);
    
    while errorStats(2) < numErrors && errorStats(3) < numBits
        
        % Generate binary data.
        txData = randi([0 1],K*log2(M),1);
        
        % Encode the data.
        encData = step(rsEncoder,txData);
        
        % Apply 64-QAM modulation.
        txSig = qammod(encData,M, ...
            'UnitAveragePower',true,'InputType','bit');
        
        % Pass the signal through an AWGN channel.
        rxSig = awgn(txSig,snrdB);
        
        % Demodulated the noisy signal.
        demodSig = qamdemod(rxSig,M, ...
            'UnitAveragePower',true,'OutputType','bit');
        
        % Decode the data.
        rxData = step(rsDecoder,demodSig);
        
        % Compute the error statistics.
        errorStats = step(errorRate,txData,rxData);
    end
    
    % Save the BER data, and reset the errorRate counter.
    ber0(k) = errorStats(1);
    reset(errorRate)
end
%gp = rsgenpoly(N,K,[],0);
for k = 1:length(ebnoVec)
    
    % Convert the coded Eb/No to an SNR. Initialize the error statistics
    % vector.
    snrdB = ebnoVec(k) + 10*log10(rate) + 10*log10(log2(M));
    errorStats = zeros(3,1);
    
    while errorStats(2) < numErrors && errorStats(3) < numBits
        
        % Generate binary data.
        txData = randi([0 1],K*log2(M),1);
              
        % Apply 64-QAM modulation.
        txSig = qammod(txData,M, ...
            'UnitAveragePower',true,'InputType','bit');
        
        % Pass the signal through an AWGN channel.
        rxSig = awgn(txSig,snrdB);
        
        % Demodulated the noisy signal.
        demodSig = qamdemod(rxSig,M, ...
            'UnitAveragePower',true,'OutputType','bit');
        
        % Decode the data.
        rxData = demodSig;
        
        % Compute the error statistics.
        errorStats = step(errorRate,txData,rxData);
    end
    
    % Save the BER data, and reset the errorRate counter.
    ber1(k) = errorStats(1);
    reset(errorRate)
end
berapprox = bercoding(ebnoVec,'RS','hard',N,K,'qam',64);
uncodedBER = berawgn(ebnoVec,'qam',64);


figure(1)
semilogy(ebnoVec,ber0,'o-',ebnoVec,ber1,'c^-')
legend('RS(63,51)-practical','UnCoded-practical')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
grid
figure(2)
semilogy(ebnoVec,berapprox,'o-',ebnoVec,uncodedBER,'c^-')
legend('RS(63,51)-Theoritical','UnCoded-Theoritical')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
grid
