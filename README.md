# ComEDA
ComEDA: a new tool for complexity assessment of electrodermal activity dynamics

This function implements the ComEDA algorithm described in 

[1] Nardelli, M., Greco, A., Sebastiani, L., & Scilingo, E.P. (2022). ComEDA: Complexity index of Electrodermal activity (EDA) dynamics. (Under
revision in Computers in Biology and Medicine)

ComEDA relies on a novel method for the reconstruction of EDA-derived phase space, where each series is embedded using its proper time delay.
ComEDA may be computed by using fixed values of embedding dimension and time delay or their optimized values searched through the FNN method and
the auto-mutual information function.
ComEDA value can be calculated on the EDA signal, and on its two main components: the tonic and the phasic components, after the application of 
cvxEDA approach (DOI: 10.1109/TBME.2015.2474131).


Copyright (C) 2022 Mimma Nardelli, Alberto Greco, Laura Sebastiani, Enzo Pasquale Scilingo

This program is free software; you can use it under the terms of the Creative Commons License: Attribution 4.0 International.

If you use this program in support of published research, please include a citation of the reference [1]. If you use this code in a software package, please explicitly inform the end users of this copyright notice and ask them to cite the reference above in their published research.

To use this software from Matlab, simply call the comEDA function in the path/folder. Type 'help comEDA' from the Matlab command window for help on the command's syntax and input/output arguments.

The software does not come with a GUI. 

Syntax:
comp=comEDA(sig, fs, varargin)

Inputs:
 sig: vector related to a series from the raw EDA signal: cleaned EDA
 signal, the tonic component or the phasic component
 fs: sampling frequency of EDA-related series
 emb: value of the embedding dimensions to be used to recontruct the phase
 space according to Takens' time-delay embedding theorem.
 t_delay: value of time delay 

Output:
 comp: value of ComEDA index for the input series 
