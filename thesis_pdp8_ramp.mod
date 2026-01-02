// ==================================================================
// FILE: thesis_pdp8_ramp.mod
// SCENARIO: Smooth PDP8 Transition (2025-2050)
// ==================================================================

// 1. VARIABLES
var 
    Y C I K L w r_k u F 
    A_bat MPK_bat               
    K_g K_b I_g I_b             
    MPK_b_physical              
    tau_res G_cost              
    Welfare;                    

varexo 
    E_ren; // Policy Input

// 2. PARAMETERS
parameters 
    beta delta alpha psi phi_int mu rho sigma_L A 
    eta_dtc delta_g delta_b phi_g
    phi_sub cost_scale;         

// 3. CALIBRATION 
beta    = 0.99;    
delta   = 0.025;   
alpha   = 0.35;    
sigma_L = 1.0;     
A       = 1.0;     

// Energy Parameters
psi     = 2.0;     
phi_int = 0.3;     
mu      = 0.16;    
rho     = 0.4;     

// Innovation & Rigor
eta_dtc = 0.5;     
delta_g = 0.015;   
delta_b = 0.025;   
phi_g   = 2.0;     

phi_sub    = 0.0;  
cost_scale = 0.05; 

// 4. THE MODEL
model;
    // Standard Macro
    1/C = beta * (1/C(+1)) * (r_k(+1) + 1 - delta);
    w = C * L^sigma_L;
    Y = A * ( (u * K(-1))^alpha ) * (L^(1-alpha));
    w = (1-alpha) * Y / L;
    r_k = alpha * Y / K(-1);

    // Reliability
    u = 1 - exp( -psi * (F / (phi_int * E_ren)) );

    // Flexibility
    F = ( mu * (A_bat * K_b(-1))^((rho-1)/rho) + (1-mu) * K_g(-1)^((rho-1)/rho) )^(rho/(rho-1));

    // Laws of Motion
    I_g = delta_g * 15 * (0.99 / u)^phi_g; 
    K_g = (1 - delta_g) * K_g(-1) + I_g(-4); // Time-to-Build

    MPK_b_physical = (Y / F) * (1 - u) * (mu * (F / (A_bat*K_b(-1)))^(1/rho)) * A_bat;
    1 = beta * (C / C(+1)) * (MPK_b_physical(+1) + (1 - delta_b));
    K_b = (1 - delta_b) * K_b(-1) + I_b;

    // Innovation
    tau_res = phi_sub * (0.99 - u);
    G_cost  = cost_scale * tau_res * Y;
    MPK_bat = MPK_b_physical; 
    log(A_bat) = 0.95 * log(A_bat(-1)) + eta_dtc * (1 + tau_res) * (log(MPK_bat) - log(MPK_bat(-1)));

    // Closing
    Y = C + I + I_g + I_b + G_cost;
    K = (1-delta)*K(-1) + I;
    Welfare = log(C) - (L^(1+sigma_L))/(1+sigma_L) + beta * Welfare(+1);
end;

// 5. TRANSITION SETUP 

// A. Start (2025)
initval;
    E_ren = 10;
    // ... guesses ...
    A_bat = 1; L = 0.93; u = 0.99;    
    MPK_b_physical = (1/beta) - (1-delta_b);
    MPK_bat = MPK_b_physical;
    r_k = (1/beta) - (1-delta);
    K_g = 15; I_g = delta_g * K_g; 
    K_b = 2.0; I_b = delta_b * K_b; F = 6.0; 
    K = 30; I = delta * K;
    tau_res = 0; G_cost = 0;
    Y = 3.2; C = Y - I - I_g - I_b; w = (1-alpha)*Y/L;
    Welfare = (log(C) - (L^(1+sigma_L))/(1+sigma_L)) / (1-beta);
end;
steady; 

// B. End (2050)
endval;
    E_ren = 15; // Target
end;
steady;

// 6. CREATE THE LINEAR RAMP
perfect_foresight_setup(periods=100);

// --- THE FIX: MANUALLY OVERWRITE THE PATH ---
// We create a linear vector from 10 to 15 over 102 periods (0 to 101)
// Dynare stores exogenous paths in oo_.exo_simul
verbatim;
    ramp_path = linspace(10, 15, size(oo_.exo_simul, 1))';
    oo_.exo_simul(:, strmatch('E_ren', M_.exo_names, 'exact')) = ramp_path;
end;
// --------------------------------------------

perfect_foresight_solver(robust_lin_solve);

// 7. PLOTTING
write_latex_dynamic_model;

verbatim;
    figure('Name', 'Chapter 6: Smooth PDP8 Transition');
    T = 1:100;
    
    % Panel 1: Renewable Ramp
    subplot(2,2,1);
    path_E_ren = oo_.exo_simul(2:101, strmatch('E_ren', M_.exo_names, 'exact'));
    plot(T, path_E_ren, 'b-', 'LineWidth', 2);
    title('Renewable Capacity Target (PDP8)');
    grid on; ylabel('Capacity (GW Equivalent)');
    
    % Panel 2: Reliability
    subplot(2,2,2);
    plot(T, oo_.endo_simul(strmatch('u', M_.endo_names, 'exact'), 1:100), 'r-', 'LineWidth', 2);
    title('Grid Reliability (u)');
    grid on; ylabel('Utilization');
    
    % Panel 3: Investment
    subplot(2,2,3);
    I_b_idx = strmatch('I_b', M_.endo_names, 'exact');
    I_g_idx = strmatch('I_g', M_.endo_names, 'exact');
    plot(T, oo_.endo_simul(I_b_idx, 1:100), 'b-', 'LineWidth', 2); hold on;
    plot(T, oo_.endo_simul(I_g_idx, 1:100), 'k--', 'LineWidth', 1.5);
    legend('Private Batteries', 'Public Grid');
    title('Investment Agility');
    grid on;
    
    % Panel 4: Innovation
    subplot(2,2,4);
    plot(T, oo_.endo_simul(strmatch('A_bat', M_.endo_names, 'exact'), 1:100), 'g-', 'LineWidth', 2);
    title('Battery Innovation (A_{bat})');
    grid on;
end;