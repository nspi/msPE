%% msPE interactive demo
%
% This algorithm demonstrates the fundamentals of multiscale 
% parameter estimation (msPE) by using it for parameter estimation
% of noisy Gaussians signals. As demonstrated in the article, 
% even better parameter estimates can be achieved my means of a 
% simple multivariate optimization, where msPE results serve as starting
% values.
%
% Information on the methodology & potential applications can be found here:
%
% M. Kukuk and N. Spicher,
% "Parameter Estimation Based on Scale-Dependent Algebraic Expressions and
% Scale-Space Fitting" in IEEE Transactions on Signal Processing, vol. 67,
% no. 6, pp. 1431-1446, March 15, 2019.
% Open Access: http://dx.doi.org/10.1109/tsp.2018.2887190
%
% N. Spicher and M. Kukuk,
% "Delineation of Electrocardiograms Using Multiscale Parameter Estimation"
% in IEEE Journal of Biomedical and Health Informatics (2020, accepted).
% Open Access: http://dx.doi.org/10.1109/JBHI.2019.2963786
%
% Changelog:
% 2020-05-19 v.01: several bugfixes
% 2020-05-10 v.01: added simple gui menu and changed visualization
% 2020-04-29 v.01: new visualization and minor changes
% 2020-04-17 v.01: initial release
%
% Supported Versions:
% This algorithm was tested using MATLAB R2018b and R2019b.
%
% Dependencies:
% Wavelet Toolbox
%
% Further notice:
% We use the tight_subplot() script by P. Kumpulainen for visualizations
% and the crossing() script by S. Brueckner for zero-crossing detection.
% Both are available on Matlab Central File Exchange.

clear all; close all; 
delete('data/*.fig');
format('compact');

addpath("scripts/");
addpath("external scripts/");

menu;