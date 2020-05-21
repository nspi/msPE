% This scripts performs all relevant computations

function glue_code(numberSignals, noiseType, noiseSNR, parameters)
% numberSignals    number of processed signals
% noiseType        type of noise
% noiseSNR         signal-to-noise ratio [dB]
% parameters       methods for selecting parameters

%% expert options

% What is the number of processed scales by msPE ?
opt.numScales = 100;    

% Define parameters of synthetic signals
opt.N = 1000;                        % number of samples for each signal
opt.step = 0.01;                     % step size between samples
opt.t = linspace(-5+opt.step,5,opt.N);

%% variable declaration

% ground truth signal parameters
if (parameters == 0)
GT.A = linspace(-1,1,numberSignals);
GT.sigma = linspace(0.1,1,numberSignals);
GT.mu = linspace(-2,2,numberSignals);
GT.B =  linspace(-2,2,numberSignals);
else
a = -1; b = 1; GT.A = (b-a).*rand(1,numberSignals) + a;
a = 0.1; b = 1; GT.sigma  = (b-a).*rand(1,numberSignals) + a;
a = -2; b = 2; GT.mu = (b-a).*rand(1,numberSignals) + a;
a = -2; b = 2; GT.B = (b-a).*rand(1,numberSignals) + a;
end

% A or sigma must not be zero
GT.A(find(GT.A==0)) = eps; 
GT.sigma(find(GT.sigma==0)) = eps;

% result vectors of estimated signal parameters
RES.A = zeros(1,numberSignals);
RES.sigma = zeros(1,numberSignals);
RES.mu = zeros(1,numberSignals);
RES.B =  zeros(1,numberSignals);

% create figure
fig = figure('units','normalized','outerposition',[0.2 0 0.4 0.6]);

%% process each signal
for curr_iteration = 1:numberSignals
        
    % declare vectors
    TMP.mu_mspe = nan(1, opt.numScales);     % is computed from a single line
    TMP.sigma_mspe = nan(2, opt.numScales);  % can be computed from 2 line combinations
    TMP.B_mspe = nan(1, opt.numScales);      % is computed from a single convolution
    TMP.A_mspe = nan(1, opt.numScales);      % is computed from a single convolution
    
    % get ground truth parameters of this iteration
    TMP.A = GT.A(1,curr_iteration);
    TMP.sigma = GT.sigma(1,curr_iteration);
    TMP.mu = GT.mu(1,curr_iteration);
    TMP.B = GT.B(1,curr_iteration);
    
    %% generate noisy Gaussian
    
    % generate raw signal
    signal_raw = TMP.B + TMP.A .* exp(-((opt.t-TMP.mu).^2 / (2*TMP.sigma.^2)));
        
    % generate normally distributed noise
    if (noiseType==0)
        signal_noise = randn(opt.N,1);
    elseif (noiseType==1)
        signal_noise = rand(opt.N,1)-0.5;
    else
        % pink noise generation according to
        % https://ccrma.stanford.edu/~jos/sasp/Example_Synthesis_1_F_Noise.html
        Nx = opt.N;  % number of samples to synthesize
        B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
        A = [1 -2.494956002   2.017265875  -0.522189400];
        nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
        v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
        x = filter(B,A,v);    % Apply 1/F roll-off to PSD
        signal_noise = x(nT60+1:end)';    % Skip transient response
    end
        
    % adjust to SNR
    noise_fak = var(signal_raw) / var(signal_noise) / (10^(noiseSNR/10));
    signal_noise = sqrt(noise_fak)*signal_noise;
       
    % add noise
    signal = signal_raw + signal_noise';
    
    %% msPE algorithm
    [mspe_result, scale_space, scale_space_full] = mspe(signal, opt.t, opt.numScales);
    
    if (isempty(mspe_result))
        disp(['Iteration: ' , num2str(curr_iteration), ' / ', num2str(numberSignals), ' -- non-successful msPE']);
        RES.A(1,curr_iteration) = NaN;
        RES.sigma(1,curr_iteration) = NaN;
        RES.mu(1,curr_iteration) = NaN;
        RES.B(1,curr_iteration) = NaN;
        continue;
    end
    
    % averaging using median() and storage of parameters
    RES.A(1,curr_iteration) = median(mspe_result.A_mspe, 'omitnan');
    RES.sigma(1,curr_iteration) = median(mspe_result.sigma_mspe(:), 'omitnan');
    RES.mu(1,curr_iteration) = median(mspe_result.mu_mspe(:), 'omitnan');
    RES.B(1,curr_iteration) = median(mspe_result.B_mspe, 'omitnan');
    
    % reconstruct input signal 
    signal_est = RES.B(1,curr_iteration) + RES.A(1,curr_iteration) * exp(-((opt.t-RES.mu(1,curr_iteration)).^2 / (2*RES.sigma(1,curr_iteration).^2))); 
   
    %% visualization
    ha = tight_subplot(4,1,[.01 .025],[0 .01],[.01 .01]);
    
    axes(ha(1));
    plot(opt.t, signal_raw,'k', 'LineWidth', 2); hold on; 
    plot_err = scatter(opt.t, signal, 'r', 'filled','SizeData', 10);
    alpha(plot_err,.3);
    limitY=get(gca,'ylim');
    limitX=get(gca,'xlim');
    legend('Model', 'Model + Noise');
    text(limitX(1)+0.1,limitY(2)-0.9*(limitY(2)-limitY(1)),['Iteration: ', num2str(curr_iteration), '/', num2str(numberSignals)]);
    text(limitX(1)+0.1,limitY(2)-0.1*(limitY(2)-limitY(1)),['\mu: ', num2str(TMP.mu), ' \sigma: ', num2str(TMP.sigma), ' A: ', num2str(TMP.A), ' B: ', num2str(TMP.B)]);

    axes(ha(2));
    imagesc(scale_space_full); 
    % create legend
    gray_cmap = flipud(colormap(gray(3)));  colormap(gray_cmap);
    hold on;
    L1 = line(1,1, 'LineWidth',2, 'Color', gray_cmap(2,:));
    L2 = line(1,1, 'LineWidth',2, 'Color', gray_cmap(3,:));
    limitY=get(gca,'ylim');
    limitX=get(gca,'xlim');
    legend('WT^1','WT^2');
    text(limitX(1)+10,limitY(2)-0.1*(limitY(2)-limitY(1)),['Scale-space']);

    axes(ha(3));
    imagesc(scale_space); 
    % create legend
    colormap(gray_cmap); hold on;
    L1 = line(1,1, 'LineWidth',2, 'Color', gray_cmap(2,:)); 
    L2 = line(1,1, 'LineWidth',2, 'Color', gray_cmap(3,:));
    limitY=get(gca,'ylim');
    limitX=get(gca,'xlim');
    legend('WT^1 Line','WT^2 Line')       
    text(limitX(1)+10,limitY(2)-0.1*(limitY(2)-limitY(1)),['Lines detected']);

    axes(ha(4));
    hold on; 
    plot_err = scatter(opt.t, signal, 'r', 'filled','SizeData', 10);
    plot(opt.t, signal_raw,'k', 'LineWidth', 2);
    plot(opt.t, signal_est, 'LineWidth', 2, 'Color', [0, 0, 1]);
    hold off;
    alpha(plot_err,.3); 
    limitY=get(gca,'ylim');
    limitX=get(gca,'xlim');
    legend('Model + Noise', 'Model', 'Model estimated by msPE');
    text(limitX(1)+0.1,limitY(2)-0.1*(limitY(2)-limitY(1)),['\mu: ', num2str(RES.mu(1,curr_iteration)), ' \sigma: ', num2str(RES.sigma(1,curr_iteration)), ' A: ', num2str(RES.A(1,curr_iteration)), ' B: ', num2str(RES.B(1,curr_iteration))], 'Color' ,'b');
    box on;
    
    % remove ticks
    yticks(ha(1),[]); yticks(ha(2),[]); yticks(ha(3),[]); yticks(ha(4),[]);
    xticks(ha(1),[]); xticks(ha(2),[]); xticks(ha(3),[]); xticks(ha(4),[]);
    
    % draw and store
    drawnow();
    saveas(gcf,['data/', num2str(curr_iteration), '.fig']);
    
    % user feedback
    disp(['Iteration: ' , num2str(curr_iteration), ' / ', num2str(numberSignals)]);
    
    % clear data
    clear TMP;
    clf;  

    
end


%% Plot results 
fig = figure('Position', [10 10 500 1000]); 

% Plot signal model
subplot(5,1,1);
signal_demo = 1 + 1 .* exp(-((opt.t-0).^2 / (2*1.^2)));
plot(opt.t, signal_demo, 'k', 'LineWidth', 2);
xticks(linspace(-5,5,5));
xticklabels({'', '', '', '' , ''});
yticks(linspace(0,3,4));
yticklabels({});
ylim([0,2.1]);
set(gca,'FontSize',14);
annotation(gcf,'textbox',[0.495 0.808 0.069 0.022],'String',{'$$\mu$$'},'LineStyle','none','Interpreter','latex','FitBoxToText','off','FontSize',14);
annotation(gcf,'doublearrow',[0.44 0.59],[0.89 0.89],'LineWidth',1);
annotation(gcf,'textbox',[0.5 0.871 0.069 0.022],'String',{'$$\sigma$$'},'LineStyle','none','Interpreter','latex','FitBoxToText','off','FontSize',14);
annotation(gcf,'doublearrow',[0.158 0.158], [0.918 0.871],'LineWidth',1, 'HeadStyle', 'plain', 'HeadSize', 8);
annotation(gcf,'textbox', [0.17 0.88 0.069 0.024],'String',{'A'},'LineStyle','none','Interpreter','latex','FitBoxToText','off','FontSize',14);
annotation(gcf,'doublearrow',[0.158 0.156],[0.855 0.808],'LineWidth',1, 'HeadStyle', 'plain', 'HeadSize', 8);
annotation(gcf,'textbox',[0.169 0.821 0.069 0.0240000000000006],'String',{'B'},'LineStyle','none','Interpreter','latex','FitBoxToText','off','FontSize',14);
title({'Pick a signal to get details.', '(Right click ends the program).' ,'', 'Signal model'}, 'FontSize', 12);
annotation(gcf,'line',[0.00200000000000001 0.994], [0.953000000000001 0.953],'LineWidth',3);
 
% Plot actual results
clickable_subplots(1) = subplot(5,1,2);
plot(GT.mu,'ko'); hold on; plot(RES.mu,'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', 'none', 'Marker', '*'); xlim([1, numberSignals]); title('Parameter \mu'); ylabel('Value'); 
axP = get(gca,'Position'); 
legend('Ground Truth', 'msPE result', 'Position',[0.66400000205636 0.761803015773122 0.239999995887279 0.0304999992251396]);
set(gca, 'Position', axP);
clickable_subplots(2) = subplot(5,1,3);
plot(GT.sigma,'ko'); hold on; plot(RES.sigma,'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', 'none', 'Marker', '*');  xlim([1, numberSignals]); title('Parameter \sigma'); ylabel('Value');
clickable_subplots(3) = subplot(5,1,4);
plot(GT.A,'ko'); hold on; plot(RES.A,'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', 'none', 'Marker', '*');  xlim([1, numberSignals]); title('Parameter A'); ylabel('Value');
clickable_subplots(4) = subplot(5,1,5);
plot(GT.B,'ko'); hold on; plot(RES.B,'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', 'none', 'Marker', '*');  xlim([1, numberSignals]); title('Parameter B'); ylabel('Value'); xlabel('Number of signal');

while(1)
    
    [x,y,button] = ginput(1);
    clickedAx = gca;
    
    % end program
    if button == 3
        break;
    end
    
    % show picked signal
    if (ismember(gca, clickable_subplots))    
        if (isfile(['data/', num2str(round(x)), '.fig']))
           openfig(['data/', num2str(round(x)), '.fig']);
           figure(fig);
        else
            disp('Sorry, msPE could not compute signal parameters for this signal');
        end
    end
    
end