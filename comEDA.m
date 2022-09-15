function comp=comEDA(ser, fs, emb, t_delay)
%
% ComEDA: Complexity index of Electrodermal activity (EDA) dynamics
% This function implements the ComEDA algorithm described in "ComEDA: 
% a new tool for stress assessment based on electrodermal activity"
% 
% ComEDA relies on a novel method for the reconstruction of EDA-derived
% phase space, where each series is embedded using its proper time delay.
% ComEDA may be computed by using fixed values of embedding dimension and
% time delay or their optimized values searched through the FNN method and
% the auto-mutual information function.
% ComEDA value can be calculated on the EDA signal, and on its two main
% components: the tonic and the phasic components, after the application of 
% cvxEDA approach (DOI: 10.1109/TBME.2015.2474131).
%
% Syntax:
%   comp=comEDA(ser, fs, varargin)
%
%   Inputs:
% ser: vector related to a series from the raw EDA signal: cleaned EDA
% signal, the tonic component or the phasic component
% fs: sampling frequency of EDA-related series
% emb: value of the embedding dimensions to be used to recontruct the phase
% space according to Takens' time-delay embedding theorem.
% t_delay: value of time delay 
%
%   Output:
% comp: value of ComEDA index for the input series 

%
% Ref:
% [1] Nardelli, M., Greco, A., Sebastiani, L., & Scilingo, E.P. (2022). 
% ComEDA: Complexity index of Electrodermal activity (EDA) dynamics. (Under
% revision in Computers in Biology and Medicine) 
% [2] Greco, A., Valenza, G., Lanata, A., Scilingo, E. P., & Citi,L.(2015). 
% cvxEDA: A convex optimization approach to electrodermal activity 
% processing. IEEE Transactions on Biomedical Engineering, 63(4), 797-804.
%
% If you use the code, please make sure that you cite reference [1] and [2].
%
% You may contact the author by e-mail: 
% Mimma Nardelli
% mimma.nardelli@unipi.it
%
% Copyright Mimma Nardelli, Alberto Greco, Laura Sebastiani, and Enzo Pasquale Scilingo
% August, 2022
%______________________________________________________________________________
%
% File:                         comEDA.m
% Last revised:                 30 August 2022
% ______________________________________________________________________________
%
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the Creative Commons Attribution 4.0 for more details.
%
% ______________________________________________________________________________


% If the values of embedding dimension (emb) and time delay (t_delay) 
% for the considered time series are not passed as inputs, the FNN method and the auto-mutual 
% information function and used for their computation

if nargin<3
 
    t_delay = mdDelay(ser,'criterion','localMin','numBins',20,'plottype','none');
    Fx=knn_deneme(ser,t_delay,20); 
    min_fx = find(islocalmin(Fx)); 
    if isempty(min_fx)
            [d emb]=min(Fx);
    else
    emb=min_fx(1);
    end
end

% Each time series is rescaled using a min-max normalization
nser = (ser-min(ser)) ./ (max(ser)-min(ser));

% Phase space reconstruction
N=length(ser);
M=N-(emb-1)*t_delay; 
ind=hankel(1:M, M:N);
vect=ser(ind(:, 1:t_delay:end));

% Computing the angular distances between each pair of vectors in the
% reconstructed phase space
angd=1-pdist(vect, 'cosine');

% Calculating the numer of bins B applying the Sturges method
B=calcnbins(angd, 'sturges');
B=2^ceil(log2(B));

% Esimating probability density by a kernel density estimator for one-dimensional data
[xi,den] = kde(angd,B);
freq = den./sum(den);

% Computing Renyi entropy
[w,h]=size(freq);
       renyi=zeros(1,h);
       for n=1:h
           renyi(1,n)=log(sum(freq(:,n).^2))/(1-2);
       end       
comp = renyi./log(B);
