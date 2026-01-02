% ==================================================================
% COUNTERFACTUAL ANALYSIS: THE VALUE OF INNOVATION
% Fixed for Scope / "Dot Indexing" Error
% ==================================================================

clear all; close all; clc;

% 1. INITIALIZE DYNARE
% Run the model once to create the global structures (M_, oo_, etc.)
dynare thesis_dtc noclearall;

% 2. DECLARE GLOBALS
% This fixes the "Dot indexing" error. Now the script can see the variables.
global M_ oo_ options_ var_list_

% Find the "Address" of the innovation parameter in the list
i_eta = strmatch('eta_dtc', M_.param_names, 'exact');

% ------------------------------------------------------------------
% RUN 1: NO INNOVATION (The "Standard" Model)
% ------------------------------------------------------------------
% Manually set eta_dtc to 0 in the parameter list
M_.params(i_eta) = 0; 

% Force a re-simulation using the internal Dynare solver
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);

% Save the results (No Innovation)
Y_no_innov = oo_.irfs.Y_e_ren;
u_no_innov = oo_.irfs.u_e_ren;

% ------------------------------------------------------------------
% RUN 2: WITH INNOVATION (Your Thesis Model)
% ------------------------------------------------------------------
% Manually set eta_dtc back to 0.5 (or your calibrated value)
M_.params(i_eta) = 0.5;

% Force a re-simulation
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);

% Save the results (With Innovation)
Y_with_innov = oo_.irfs.Y_e_ren;
u_with_innov = oo_.irfs.u_e_ren;

% ==================================================================
% PLOTTING (CORRECTED)
% ==================================================================
figure('Name', 'Counterfactual_Welfare');
hold on;
grid on;

% 1. Define X-axis
T_steps = length(Y_no_innov);
x_axis = 1:T_steps;

% 2. Ensure vectors are Row Vectors (1xN) to fix 'fill' error
Y_no_innov = reshape(Y_no_innov, 1, []); 
Y_with_innov = reshape(Y_with_innov, 1, []);

% 3. Plot the Shaded Area (The "Welfare Gain")
% We flip the vectors to create a closed polygon for the fill command
fill([x_axis, fliplr(x_axis)], ...
     [Y_with_innov, fliplr(Y_no_innov)], ...
     [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5); 
     % Uses a light gray color for professional look

% 4. Plot the Lines
p1 = plot(x_axis, Y_with_innov, 'b-', 'LineWidth', 3);       % DTC Model
p2 = plot(x_axis, Y_no_innov,   'r--', 'LineWidth', 3);      % Counterfactual

% 5. Labels & Formatting (NO TITLE)
xlabel('Quarters');
ylabel('% Deviation from SS');
legend([p1 p2], 'Thesis Model (Endogenous Innovation)', 'Counterfactual (Fixed Tech)', ...
       'Location', 'SouthEast');
axis tight;

hold off;
% Save this as image_fig4.png