# Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements

**Authors:** Zihao (John) Li and Christopher Fang-Yen  
**Affiliation:** Department of Biomedical Engineering, The Ohio State University  
**Related manuscript:** Li Z, Fang-Yen C. "Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements." iScience (2026). https://doi.org/10.1016/j.isci.2026.116117

---

## Overview

This dataset contains raw experimental measurements, optical simulation results, 3D design files, and MATLAB analysis code from a study characterizing angle-resolved light scattering from *C. elegans* (a microscopic roundworm ~1 mm in length). Scattering measurements were taken across illumination angles θ = 0°–180° at three wavelengths (red 629 nm, green 516 nm, blue 447 nm) under varied substrate and index-matching conditions, allowing separation of **surface scattering** (at the worm–medium interface) from **volume scattering** (within the worm body). Key quantities reported are the **scattering function p(θ)** (sr⁻¹, power scattered per steradian normalized by incident irradiance and worm area) and the **contrast index** = (I_worm − I_background) / (I_worm + I_background), which ranges from −1 to +1.

---

## Contents

```
Dataset_S1/          Raw experimental and simulation data
Design_File_S1/      3D CAD files for Zemax optical simulations
Software_S1/         Zemax OpticStudio simulation project files
Software_S2/         MATLAB data analysis scripts
```

---

## Dataset S1

### Common format: `data.xlsx`

All imaging measurement files are named `data.xlsx` and share four columns: `Position` (cm, LED post reading used to compute illumination angle θ), `Category` (`"worm"` or `"background"`), `Mean` (ADU, mean pixel intensity of the region of interest), and `Exposure` (seconds, camera exposure time). Each row is one image at one LED position. The conversion from Position to θ is handled by `comput_incident_angle.m` (see Software S2).

### Imaging data folders

Folders are named by imaging modality, substrate condition, and whether index-matching was applied:

- **BF** (brightfield) — collects near-forward scattered light (θ ≈ 0°–30°).
- **DF** (darkfield) — collects off-axis forward scattered light (θ ≈ 30°–90°); together BF and DF cover the full forward hemisphere.
- **Backscat** (backscatter) — collects light scattered back toward the source (θ ≈ 90°–180°).
- **seeded** — agar plates inoculated with *E. coli* bacteria (standard lab condition); **unseed** — agar plates without bacteria.
- **idx_mat** (index-matched) — worm surroundings replaced with a refractive-index-matched fluid to suppress surface scattering, isolating volume scattering; **Non_idx_mat** — standard conditions with both surface and volume scattering present.

Each folder contains `data.xlsx` files organized by color (`red/`, `green/`, `blue/`) and, where applicable, an index-matched subfolder. `setting/` subfolders contain microscopy software screenshots for documentation only.

| Folder | Contents |
|---|---|
| `BF_seeded_RGB/Non_idx_mat/` | BF, seeded agar, non-index-matched; red, green, blue channels. |
| `BF_seeded_RGB/Idx_mat/` | BF, seeded agar, index-matched; red, green, blue channels. |
| `DF_seeded_RGB/` | DF, seeded agar, non-index-matched; red, green, blue. |
| `DF_seeded_idx_mat_RGB/` | DF, seeded agar, index-matched; red, green, blue. |
| `Backscat_seeded_RGB/` | Backscatter, seeded agar, non-index-matched; red, green, blue. |
| `Backscat_seeded_idx_mat_RGB/` | Backscatter, seeded agar, index-matched; red, green, blue. |
| `BF_unseed_RGB/Non_idx_Mat/` | BF, unseeded agar, non-index-matched; red only. |
| `BF_unseed_RGB/Idx_Mat/` | BF, unseeded agar, index-matched; red only. |
| `DF_unseed_RGB/` | DF, unseeded agar, non-index-matched; red only. |
| `Backscat_unseed_RGB/` | Backscatter, unseeded agar, non-index-matched; red only. |
| `Substrate_RGB/` | BF measurements of worms and background on three substrates (Agar, Gelatin, Rite/gellan gum) at red, green, and blue. Same `data.xlsx` format. Note: `Rite/red/Note.txt` states the worm movement track was included in the background ROI for that dataset. |

### Power_Meter_data/

`Power_Meter_data.xlsx` — Incident optical power (µW) as a function of LED position, used to normalize scattering measurements. Three sheets (`Red`, `Green`, `Blue`), each with columns `Position` (cm), `Reading` (µW, raw power meter reading), `N_LED_used`, and `N_LED_measured`. A wavelength-dependent sensitivity correction is applied in software (factors: red ×15.1/14.7, green ×12.2/11.6, blue ×30.0/26.5).

### PIC/

`PIC.mat` — Camera calibration file containing the Pixel Irradiance Coefficient (PIC, units ADU·mm²·s⁻¹·µW⁻¹) for each color channel (`PIC_red`, `PIC_green`, `PIC_blue`) and the power meter sensor area (`Area_PM_sensor`, mm²). PIC converts raw pixel values to irradiance via: Irradiance = Mean / (Exposure × PIC).

### Zemax/

`WSFC_zemax_N_10.mat` — Results of 10 Zemax ray-tracing simulation runs of *C. elegans* scattering (each run uses a different random refractive index texture for the worm interior). Contains paired theta (degrees) and scattering function (sr⁻¹) arrays for three simulation conditions: index-matched/volume-only (`theta_zemax_idxMat_N`, `WSFC_zemax_idxMat_N`), surface-only (`theta_zemax_ext_N`, `WSFC_zemax_ext_N`), and full scattering (`theta_zemax_full_N`, `WSFC_zemax_full_N`). All arrays are 10 × M (runs × angles).

### Spatial_distribution/

MATLAB `.mat` files containing cross-sectional intensity profiles and the Edge-to-Mean Contrast Index (EMCI = (I_edge − I_center)/(I_edge + I_center)) as a function of illumination angle. EMCI > 0 indicates edge-bright scattering (surface scattering dominant); EMCI < 0 indicates center-bright scattering (volume scattering dominant).

| File | Contents |
|---|---|
| `Spatial_nonIdxMat.mat` | Experimental profiles and EMCI for non-index-matched condition (trial 1). Variables: `rep_profiles` (normalized cross-sectional profiles, angles × positions), `rep_theta` (angles in degrees), `shapeIdx_exp` (EMCI values), `theta_xsec_exp` (angles for EMCI), `shapeIdx_Zemax_N` and `theta_xsec_Zemax_N` (simulated EMCI, runs × angles). |
| `Spatial_idxMat.mat` | Same structure for index-matched condition; variable names suffixed with `_idxMat`. |
| `shapeIdx_exp_nonIdxMat_2.mat` | EMCI for non-index-matched trial 2 (`shapeIdx_exp_2`). |
| `shapeIdx_exp_nonIdxMat_3.mat` | EMCI for non-index-matched trial 3 (`shapeIdx_exp_3`). |
| `shapeIdx_exp_idxMat_2.mat` | EMCI for index-matched trial 2 (`shapeIdx_exp_idxMat_2`). |
| `shapeIdx_exp_idxMat_3.mat` | EMCI for index-matched trial 3 (`shapeIdx_exp_idxMat_3`). |
| `stat_repProfile_Zemax_N_nonIdxMat.mat` | Mean and SEM of simulated cross-sectional profiles, non-index-matched (`mean_repProfile_Zemax_N`, `sem_repProfile_Zemax_N`). |
| `stat_repProfile_Zemax_N_idxMat.mat` | Same for index-matched condition (`mean_repProfile_Zemax_N_idxMat`, `sem_repProfile_Zemax_N_idxMat`). |

---

## Design File S1

STEP-format 3D CAD files for the Zemax optical simulation geometry: `Worm.step` (worm body), `Agar.step` (agar substrate), `Gel_pad_low.step` and `Gel_socket_low.step` (gel substrate components), `WaterFilm_Low.step` (water film around the worm). These files must be copied to the Zemax CAD files folder before running Software S1.

---

## Software S1

Ansys Zemax OpticStudio 2024 R2 simulation files. `WormScat.zmx` is the main project file defining the 3D optical system. `WormScat_macro.ZPL` is a ZPL macro that automates simulation runs across multiple refractive index realizations; the output path must be set before running (instructions inside the file). Pre-computed simulation outputs are provided in `Dataset_S1/Zemax/` and `Dataset_S1/Spatial_distribution/`.

**Setup:** Copy `.step` files to `Documents\Zemax\Objects\CAD Files` and `WormScat_macro.ZPL` to `Documents\Zemax\Macros`.

---

## Software S2

MATLAB scripts for data analysis and figure generation. Requires the **Curve Fitting Toolbox** and **Statistics and Machine Learning Toolbox**.

**To reproduce figures:** open `Main.m`, set `main_work_dir` and `f_dataset_S1` to your local paths, then run each `%%` section (one section per figure).

| Script | Description |
|---|---|
| `Main.m` | Master script; each `%%` section generates one manuscript figure and runs the corresponding statistical tests. |
| `bulk_scatter_contrast_analysis.m` | Combines BF, DF, and backscatter data to compute the full-angle (0°–180°) scattering function p(θ) and contrast index. |
| `scatter_contrast_analysis.m` | Processes a single imaging modality: converts ADU pixel values to irradiance, normalizes by incident power, and returns p(θ) and contrast index. |
| `calculateContrastStats.m` | Computes contrast index per worm–background pair and returns grouped mean and standard deviation. |
| `comput_incident_angle.m` | Converts LED post Position (cm) to illumination angle θ (degrees). |
| `computePICfromFile.m` | Computes the PIC calibration constant from illumination-off and illumination-on camera images with simultaneous power meter readings. |
| `createPowerFit.m` | Interpolates incident irradiance as a function of angle for power normalization. |
| `Mie_scat.m` | Computes theoretical Mie scattering functions for a sphere equivalent in volume or surface area to the worm. |
| `saveStat.m` | Saves computed statistics (mean, std, SEM, N per angle) to an Excel spreadsheet. |
| `dabarplot.m` | Custom bar chart with overlaid scatter points and error bars. |
| `ttest1_from_summary.m` | One-sample t-test from summary statistics (mean, SD, N). |
| `ttest2_from_summary.m` | Two-sample Welch's or equal-variance t-test from summary statistics. |

---

## Sharing and Access

This dataset is deposited on Dryad in support of the manuscript:

> Li Z, Fang-Yen C. "Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements." iScience (2026). https://doi.org/10.1016/j.isci.2026.116117
