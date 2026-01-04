% ==================================================================
% SMALL OPEN ECONOMY: IMPORTED GREENFLATION SHOCK
% Section 6.6: Impact of Global Battery Price Shock
% ==================================================================
clear all; close all; clc;

% 1. Initialize
dynare thesis_dtc noclearall nolog;
global M_ oo_ options_

% 2. Isolate the Global Price Shock
% We want to see what happens when P_tech spikes (e_price shock)
% Set renewable shock to 0 for this experiment
options_.irf = 40;
options_.order = 1;

% Manually zero out the e_ren shock variance for this run
M_.xo_variance = zeros(M_.exo_nbr, M_.exo_nbr);
i_price = strmatch('e_price', M_.exo_names, 'exact');
M_.xo_variance(i_price, i_price) = (0.10)^2; % 10% Price Shock

% 3. Run Simulation
[info, oo_, options_] = stoch_simul(M_, options_, oo_, []);

% 4. PLOTTING FIGURE
figure('Name', 'Imported Greenflation (SOE)');

% Panel 1: The Global Shock
subplot(1,2,1);
plot(oo_.irfs.P_tech_e_price * 100, 'r-', 'LineWidth', 2);
title('Global Battery Price (P_{tech})');
ylabel('% Increase (USD)');
xlabel('Quarters');
grid on;

% Panel 2: The Domestic Fallout
subplot(1,2,2);
plot(oo_.irfs.Y_e_price * 100, 'k-', 'LineWidth', 2);
title('Impact on Domestic GDP');
ylabel('% Deviation');
xlabel('Quarters');
grid on;

% Add Note
annotation('textbox', [.3 .05 .4 .1], 'String', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');
