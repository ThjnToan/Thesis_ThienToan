# Thesis_ThienToan
Dynare code for DSGE model in Vietnam's energy sector.

# Directed Technical Change in Vietnam's Energy Transition
**Thesis Code Repository**
**Author:** Nguyen Thien Toan (Justin)
**Year:** 2025

## Overview
This repository contains the replication code for my Master's thesis. The project utilizes a DSGE model with Directed Technical Change (DTC) and Time-to-Build frictions to analyze the "Agility Gap" between private battery investment and public grid infrastructure in Vietnam.

## File Structure

### 1. The Core Model
* `thesis_dtc.mod`: The main Dynare model file. It contains:
    * The structural equations (Euler equations, Production functions).
    * The Analytical Steady State block.
    * The Laws of Motion (including the 4-quarter Time-to-Build lag for the Grid).

### 2. Driver Scripts (Run these to generate Thesis Figures)
* `run_optimal_subsidy.m`:
    * **Generates Figure 4.7.**
    * Loops the subsidy parameter to find the welfare-maximizing policy.
    * Result: Shows the optimal R&D subsidy is near zero due to fiscal crowding-out.
    
* `run_sensitivity_rho.m`:
    * **Generates Figure A.2 (Appendix).**
    * Compares the "Agility Gap" under Baseline (Complements) vs. High Substitution regimes.
    
* `run_welfare_analysis.m`:
    * **Calculates Consumption Equivalent Variation (CEV).**
    * Computes the lifetime consumption loss caused by the reliability crisis.

## How to Run
1.  Ensure **Dynare** (Version 5.x+) is installed and added to your MATLAB path.
2.  Open any `.m` driver script in MATLAB.
3.  Run the script. It will automatically call the `.mod` file and generate the figures.
