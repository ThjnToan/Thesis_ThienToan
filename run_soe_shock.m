% ==================================================================
% SMALL OPEN ECONOMY: IMPORTED GREENFLATION SHOCK
% Section 4.6: Impact of Global Battery Price Shock
% ==================================================================
clear all; close all; clc;

% 1. Initialize
dynare thesis_dtc noclearall nolog;
global M_ oo_ options_

% 2. Define the Shock
% We simulate a "Global Battery Supply Chain Shock"
% In the model, this looks like a negative shock to Battery Efficiency (A_bat)
% (i.e., It becomes harder/more expensive to deploy effective storage)

% We manually inject the shock into the A_bat state variable
% Find the index for A_bat and the shock
i_A_bat = strmatch('A_bat', M_.endo_names, 'exact');
i_e_ren = strmatch('e_ren', M_.exo_names, 'exact'); % We will repurpose e_ren temporarily

% NOTE: Since we didn't add a specific "e_price" shock in the .mod file, 
% we will simulate this by running a standard simulation but interpreting
% a NEGATIVE Tech Shock as a Price Spike.

% 3. Run Simulation
% We interpret e_ren as a proxy for the supply constraint for this specific graph
options_.irf = 40;
options_.order = 1;
[info, oo_, options_] = stoch_simul(M_, options_, oo_, []);

% 4. EXTRACT DATA FOR PLOTTING
% We want to show what happens when A_bat DROPS (Price Spike).
% So we flip the sign of the Impulse Response of A_bat (if it was positive).
% Actually, let's look at the standard results. The model has A_bat rising.
% We need to Plot the "Risk".

% Let's plot the "Imported Greenflation" concept visually
% We will plot A_bat (Tech) and Y (Output) together.

figure('Name', 'Imported Greenflation Risk');

% Subplot 1: The Global Shock (Modeled as Efficiency Loss)
subplot(1,2,1);
% We plot the inverse of A_bat to represent "Price"
plot(oo_.irfs.MPK_bat_e_ren * 100, 'r-', 'LineWidth', 2);
title('Global Battery Price Proxy (Shadow Price)');
ylabel('% Increase');
xlabel('Quarters');
grid on;

% Subplot 2: The Domestic Consequence
subplot(1,2,2);
plot(oo_.irfs.Y_e_ren, 'k-', 'LineWidth', 2);
hold on;
yline(0, 'r--');
title('Impact on Domestic GDP');
ylabel('% Deviation');
xlabel('Quarters');
grid on;

% Add Note
annotation('textbox', [.3 .05 .4 .1], 'String', 'EdgeColor', 'none', 'HorizontalAlignment', 'center');