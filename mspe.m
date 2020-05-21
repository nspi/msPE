% This function contains the main functionality of msPE

function [res, scale_space, scale_space_full] = mspe(signal, t, numScales)
% Input:
% signal                values of signal to be processed
% t                     time axis of signal to be processed
% numScales             number of scales to process

% Output:
res = [];                % results
scale_space = [];        % visualization of the filtered scale-space
scale_space_full = [];   % visualization of the full scale-space


% compute continuous wavelet transform
wt1 = cwt(signal, 1:numScales, 'gaus1');
wt2 = cwt(signal, 1:numScales, 'gaus2');

% detect zero-crossings in WT1 and WT2
wt1_zcl = zeros(numScales,size(wt1,2));
wt1_zcl = calc_zero_crossings(wt1, wt1_zcl);
wt2_zcl = zeros(numScales,size(wt2,2));
wt2_zcl = calc_zero_crossings(wt2, wt2_zcl);

% detect lines of zero-crossings in WT1 and WT2
scale_space_full = wt1_zcl+wt2_zcl*2;
scale_space = zeros(size(wt1,1),size(signal,2));
[ scale_space, u01Lines] = calc_lines( wt1_zcl, scale_space, numScales, 1);
[ scale_space, ~ ] = calc_lines( wt2_zcl, scale_space, numScales, 2, u01Lines);

% iterate over all scales
for curr_scale=2:numScales
    
    step = t(2)-t(1);    
    s = step * curr_scale;
    
    % Find position of u01 and u02 lines at current scale
    wt1_lines = find(scale_space(curr_scale,:)==1);
    wt1_lines = (wt1_lines - length(t)/2) * step;
    wt2_lines = find(scale_space(curr_scale,:)==2);
    wt2_lines = (wt2_lines - length(t)/2) * step;
    
    % if there are not enough lines, cancel computation
    if (isempty(wt1_lines) || isempty(wt2_lines))
        continue;
    end
    
    % compute parameter mu according to eq. (27) in (Kukuk & Spicher 2019)
    res.mu_mspe(curr_scale) = wt1_lines;
    
     % compute parameter sigma according to eq. (29) in (Kukuk & Spicher 2019)
     if (numel(wt2_lines)>=1)
        res.sigma_mspe(1, curr_scale)  = real(sqrt ( ( wt2_lines(1) - res.mu_mspe(curr_scale))^2-(s^2)/2));
    end
    if (numel(wt2_lines)==2)
        res.sigma_mspe(2, curr_scale)  = real(sqrt ( ( wt2_lines(2) - res.mu_mspe(curr_scale))^2-(s^2)/2));
    end
    
    % prepare computation of A and B
    [~, mu_idx] =     min( abs(t - res.mu_mspe(curr_scale)));
    [~, mu_sig_idx] = min( abs(t - res.mu_mspe(curr_scale) - median(res.sigma_mspe(:,curr_scale), 'omitnan')));
    
    % compute convolution with gaussian function
    theta = -1/sqrt(s) * exp(-t.^2 / s^2);
    fconv = conv(signal, theta, 'same') * step;
    
    % compute constants
    K3 = s^2+2*median(res.sigma_mspe(:,curr_scale), 'omitnan')^2;
    K2 = 1/K3;
    
    % eq. (33) in (Kukuk & Spicher 2019)
    res.B_mspe(curr_scale) = (1/(sqrt(pi)*sqrt(s)))*( (fconv(mu_idx)-fconv(mu_sig_idx))/(exp(K2*median(res.sigma_mspe(:,curr_scale), 'omitnan')^2)-1) - fconv(mu_sig_idx));
    
    % eq. (31) in (Kukuk & Spicher 2019)
    res.A_mspe(curr_scale) = -( (sqrt(2*median(res.sigma_mspe(:,curr_scale), 'omitnan')^2/s+s)*(sqrt(pi)*res.B_mspe(curr_scale)*sqrt(s)+fconv(mu_idx)))) / (sqrt(2*pi)*median(res.sigma_mspe(:,curr_scale), 'omitnan'));
    
end