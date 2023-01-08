% Niall Donohoe
% 17340571
% Digital Communications - Assignment 1
% Simulation of an 8-ary Digital Communication System

clear all; 

i = 1; % loop counter
sigma2 = 1; % noise varience
No = 2*sigma2; % Noise PSD
M = 8; % number of symbols
N = 10^5; % number of symbols we simulate with

% Preallocation for speed
Es = zeros(1,N);
Eb = zeros(1,N);
SER = zeros(1,N);
SER_Theory = zeros(1,N);
BER = zeros(1,N);

% Define our Gray-coded Bit-mapping
s1Bits = [0,0,0];
s2Bits = [1,0,0];
s3Bits = [0,0,1];
s4Bits = [1,0,1];
s5Bits = [0,1,1];
s6Bits = [1,1,1];
s7Bits = [0,1,0];
s8Bits = [1,1,0];

bitMapping = [s1Bits;s2Bits;s3Bits;s4Bits;s5Bits;s6Bits;s7Bits;s8Bits];

for d=.1:.01:25 % vary d, this in turn varies Es and Eb

% Define our signals
s1 = -d/2 + 1j*3*d/2;
s2 = d/2 + 1j*3*d/2;
s3 = -d/2 + 1j*d/2;
s4 = d/2 + 1j*d/2;
s5 = -d/2 + -1j*d/2;
s6 = d/2 + -1j*d/2;
s7 = -d/2 + -1j*3*d/2;
s8 = d/2 + -1j*3*d/2;

signalSet = [s1,s2,s3,s4,s5,s6,s7,s8]; % array of possible signals

% find our signal energies 
e1 = norm(s1)^2;
e2 = norm(s2)^2;
e3 = norm(s3)^2;
e4 = norm(s4)^2;
e5 = norm(s5)^2;
e6 = norm(s6)^2;
e7 = norm(s7)^2;
e8 = norm(s8)^2;

signalEnergies = [e1,e2,e3,e4,e5,e6,e7,e8]; % array of signal energies

Es(i) = mean(signalEnergies); % average Symbol energy
Eb(i) = Es(i)/log2(M); % bit energy

noise = sqrt(No/2)*(randn(1,N)+1j*randn(1,N)); % generate random noise

% Transmitter %
TxSymbols = signalSet(randi(8,N,1)'); % randomly generate TxSymbols
[valTx,Tidx]=min(abs(signalSet'-TxSymbols)); % Find index of TxSymbols to compare later
TxBits = bitMapping(Tidx,:); % generate Tx bits from what symbols were chosen

% Channel %
RxSymbols = TxSymbols + noise; % add noise

% Receiver %
[valRx,Ridx]= min(abs(signalSet' - RxSymbols)); % find index of closest symbol
RxBits = bitMapping(Ridx,:); % match closest symbol index to bit mapping and generate recieved bits

SER(i) = sum(Tidx~=Ridx)/N; % rate of symbol errors
BER(i) = sum(TxBits(:)~=RxBits(:))/(N*log2(M)); % rate of bit errors

% Theory %
P4 = (3/2)*qfunc(sqrt((Es(i))/(No*3))); % Perror for 4-PAM system
P2 = qfunc(sqrt((Es(i))/(No*3))); % Perror for 2-PAM system
SER_Theory(i) = 1-(1-P2)*(1-P4); % combining to get SER for 8-QAM system
i = i+1; % increment loop counter
end

% plotting SER vs Es/No
figure
semilogy(10*log10(Es./No),SER)
hold on
semilogy(10*log10(Es./No),SER_Theory)
ylim([10^-6 10^0])
xlabel('E_s/N_0 (dB)')
ylabel('SER')
legend({'Simulation','Theoretical'},'Location','southwest')
grid on
hold off

% plotting BER vs Eb/No
figure
semilogy(10*log10(Eb./No),BER)
hold on
xlabel('E_b/N_0 (dB)')
ylabel('BER')
grid on
hold off