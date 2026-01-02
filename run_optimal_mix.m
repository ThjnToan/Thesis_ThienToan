% ==================================================================
% FINDING THE OPTIMAL FLEXIBILITY MIX
% Section 4.5: Sensitivity of Welfare to Battery Share (Mu)
% ==================================================================
clear all; close all; clc;

% 1. INITIALIZE GLOBAL VARIABLES
% Run the model once to initialize the structures
dynare thesis_dtc noclearall nolog;
global M_ oo_ options_

% 2. SETUP THE EXPERIMENT
% We will test Mu values from 0.05 (5% Battery) to 0.60 (60% Battery)
mu_values = 0.05:0.05:0.60; 
output_drop = zeros(length(mu_values), 1);

% Find the index of the parameter 'mu'
i_mu = strmatch('mu', M_.param_names, 'exact');

fprintf('Running Optimization Loop...\n');

% Force IRFs to be computed (essential for the loop)
options_.irf = 40; 
options_.order = 1;

% 3. RUN THE LOOP
for i = 1:length(mu_values)
    % Update Mu
    M_.params(i_mu) = mu_values(i);
    
    % Run Simulation (Quietly)
    % FIX: We pass [] as the 4th argument instead of options_.var_list_
    % Passing [] tells Dynare to calculate everything.
    [info, oo_, options_] = stoch_simul(M_, options_, oo_, []);
    
    % Capture the "Max Drop" (Recession Depth)
    % We take the minimum value of the Impulse Response Function for Y
    % Note: Check if 'Y_e_ren' exists. If you changed shock names, update this.
    if isfield(oo_.irfs, 'Y_e_ren')
        output_drop(i) = min(oo_.irfs.Y_e_ren) * 100; % Convert to %
    else
        error('IRF for Y_e_ren not found. Check if the shock is named "e_ren".');
    end
    
    fprintf('  Mu = %.2f | Max Output Drop = %.4f%%\n', mu_values(i), output_drop(i));
end

% 4. PLOT THE "POLICY FRONTIER"
figure('Name', 'Optimal Flexibility Mix');

% Plot the Curve
plot(mu_values, output_drop, 'b-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
hold on;

% Highlight Vietnam (0.16)
xline(0.16, 'r--', 'LineWidth', 2);
text(0.17, min(output_drop)*0.9, 'Vietnam (Current)', 'Color', 'r', 'FontSize', 10);

% Highlight The Optimal Point
[min_loss, min_idx] = max(output_drop); % Max because values are negative
optimal_mu = mu_values(min_idx);

xline(optimal_mu, 'g--', 'LineWidth', 2);
text(optimal_mu + 0.02, min_loss, 'Optimal Mix', 'Color', 'g', 'FontSize', 10, 'FontWeight', 'bold');

% Formatting
xlabel('Battery Share of Flexibility (\mu)', 'FontSize', 12);
ylabel('Output Response to Shock (%)', 'FontSize', 12);
grid on;
box on;

% Add annotation
dim = [.15 .6 .3 .3];
str = {'The "Reliability Trap"', 'Low \mu makes the grid', 'too brittle.'};
annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor', 'white');