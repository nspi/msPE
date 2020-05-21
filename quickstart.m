clear all; close all; format('compact');
addpath("scripts/");
addpath("external scripts/");

% create a Gaussian
t = [-5:0.01:5];                                      % time axis
A = 5;                                                % amplitude
B = 0;                                                % baseline level
sigma = 1;                                            % width
mu = 0;                                               % shift on time axis
signal = B + A .* exp(-((t-mu).^2 / (2*sigma.^2)));   % Gaussian
signal = signal + randn(size(signal));                % Add noise

% apply it to msPE
[res, ~, ~] = mspe(signal, t, 256);                   % 256 = number scales

% average results over all scales;
A_mspe = median(res.A_mspe(:), 'omitnan');
B_mspe = median(res.B_mspe(:), 'omitnan');
sigma_mspe = median(res.sigma_mspe(:), 'omitnan');
mu_mspe = median(res.mu_mspe(:), 'omitnan');

% generate signal with parameters from msPE
signal_mspe = B_mspe + A_mspe .* exp(-((t-mu_mspe).^2 / (2*sigma_mspe.^2)));

% show results
figure; hold on; box on;
plot(t, signal, 'r.');
plot(t, signal_mspe, 'Color', 'k', 'LineWidth', 2);
legend('Data', 'Gaussian estimated by msPE');