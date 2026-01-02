# The Agility Gap: A Structural DSGE Model for Vietnam

**Author:** Toan T. Nguyen  
**Advisor:** Dr. Xavier Martin Gochoco Bautista  
**Institution:** Fulbright University Vietnam  

## 1. Overview
This repository contains the replication codes for the undergraduate capstone thesis **"The Agility Gap."**

The project develops a **Structural DSGE** model to quantify the macroeconomic costs of the "Agility Gap"—the structural mismatch between rapid renewable energy deployment and slow grid infrastructure development in Vietnam. The model features:
* **Reliability Function:** Endogenous capital utilization driven by the ratio of flexibility assets to renewable volatility.
* **Directed Technical Change (DTC):** Endogenous innovation choice between Generation efficiency vs. Storage efficiency.
* **Investment Inertia:** Structural friction distinguishing agile private batteries ($K_b$) from rigid public grid ($K_g$).

## 2. Repository Structure

### **Core Model Files**
* `thesis_dtc.mod`: The primary **Stochastic** model. Runs impulse response functions (IRFs) for short-run shocks.
* `thesis_pdp8.mod`: The **Deterministic** transition model. Simulates the 25-year "perfect foresight" path of Vietnam's Power Development Plan 8 (PDP8).

### **Replication Scripts (Run these in MATLAB)**
| Script Name | Corresponds To | Description |
| :--- | :--- | :--- |
| `dynare thesis_dtc` | **Figs 1, 2, 3** | Runs the baseline model. Generates the Reliability Penalty, Macro Transmission, and Innovation Dynamics graphs. |
| `run_counterfactual.m` | **Figure 4** | **Innovation Rescue:** Compares the DTC model (Blue) vs. a Fixed-Technology Counterfactual (Red). |
| `run_optimal_mix.m` | **Figure 5** | **The Transition Trap:** Plots the "Optimal Flexibility Frontier" to show the recessionary impact of low battery shares ($\mu$). |
| `run_soe_shock.m` | **Figure 6** | **Imported Greenflation:** Simulates a global battery price shock to test SOE vulnerability. |
| `run_transition_pdp8.m` | **Figure 7** | **PDP8 Path:** Simulates the deterministic linear ramp of renewable capacity from 2025–2050. |
| `run_second_best_policy.m` | **Figure 8** | **Fiscal Impotence:** Tests R&D subsidy efficacy under Perfect vs. Regulated markets. |

## 3. Requirements & Installation
1.  **MATLAB** (R2018b or later recommended).
2.  **Dynare** (Version 4.6 or later).
    * *Note:* Ensure the `dynare/matlab` folder is added to your MATLAB Path.

## 4. How to Replicate
1.  Clone this repository or download the source files.
2.  Set the `Code/` folder as your Current Folder in MATLAB.
3.  **To replicate the Main Results (Figs 1-3):**
    ```matlab
    dynare thesis_dtc
    ```
4.  **To replicate the Scenario Analysis (Figs 4-8):**
    Simply run the corresponding `.m` script listed in the table above.
    * *Example:* Type `run_counterfactual` in the Command Window to generate Figure 4.

## 5. Key Results
* **The Agility Gap:** The lack of storage infrastructure in Vietnam causes a **0.065% output loss** per renewable supply shock due to the "Reliability Penalty."
* **Innovation Value:** Endogenous storage innovation mitigates **80%** of the welfare loss compared to a fixed-technology scenario.
* **Policy Insight:** In a regulated market (like Vietnam), R&D subsidies are **ineffective** ("Fiscal Impotence") because broken price signals prevent the private sector from responding to incentives. Price deregulation is a prerequisite for innovation.

---
*For questions regarding the code or calibration, please contact the author.*
