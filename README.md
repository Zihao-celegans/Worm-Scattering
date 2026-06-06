# Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements

**Authors:** Zihao (John) Li and Christopher Fang-Yen  
**Affiliation:** Department of Biomedical Engineering, The Ohio State University  
**Related publication:** Li Z, Fang-Yen C. "Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements." *iScience* (2026). [https://doi.org/10.1016/j.isci.2026.116117](https://doi.org/10.1016/j.isci.2026.116117)  
[Access this dataset on Dryad](https://doi.org/10.5061/dryad.s1rn8pkpj)

---

## Overview

This dataset contains raw experimental data, optical simulation results, 3D design files, and MATLAB analysis code from a study characterizing angle-resolved light scattering from *C. elegans* (a microscopic roundworm ~1 mm in length). Scattering measurements were taken across illumination angles θ = 0°–180° at three wavelengths (red 629 nm, green 516 nm, blue 447 nm) under varied substrate and index-matching conditions, allowing analysis of **surface scattering** (at the worm–environment interface) and **volume scattering** (within the worm body). Key quantities reported are the **scattering function p(θ)** and the **contrast index**. The scattering function has units of sr⁻¹ (inverse steradian) and describes the probability per unit solid angle of a photon being scattered by a polar angle θ relative to its original trajectory. The contrast index is dimensionless and quantifies how *C. elegans* appears relative to its background in an image.

---

## Contents

```
Dataset_S1/          Raw experimental and simulation data
Design_File_S1/      3D CAD files for modeling C. elegans and its surroundings
Software_S1/         Zemax OpticStudio simulation source files
Software_S2/         MATLAB data analysis scripts
```

Each subfolder contains a `_README.txt` with brief usage notes for the components in the folder.

---

## Dataset S1

### Common format: `data.xlsx`

All imaging measurement files are named `data.xlsx` and share four columns: `Position` (cm, LED post reading used to compute illumination angle θ), `Category` (`"worm"` or `"background"`), `Mean` (analog-to-digital units (ADU), mean pixel intensity of the region of interest), and `Exposure` (seconds, camera exposure time). Each row is the measurement for a worm or a background region.

### Imaging data folders

Folders are named by imaging modality, substrate type, and whether index-matching was applied:

- **BF** (brightfield) — collects near-forward scattered light (θ = 0°).
- **DF** (darkfield) — collects off-axis forward scattered light (θ = 5°–65°).
- **Backscat** (backscatter) — collects light scattered back toward the light source (θ = 90°–180°).
- **seeded** — agar plates seeded with *E. coli* food bacteria; **unseeded** — agar plates without bacteria.
- **idx_mat** (index-matched) — worm surrounded by refractive-index-matched medium to suppress surface scattering; **Non_idx_mat** — standard conditions with both surface and volume scattering present.

Each folder contains `data.xlsx` files organized by color of illumination (`red/`, `green/`, `blue/`) and, where applicable, an index-matched subfolder. `setting/` subfolders contain camera software screenshots for documentation of imaging parameter settings.

### Power_Meter_data/

`Power_Meter_data.xlsx` — Incident optical power (µW) as a function of LED position, used to normalize scattering measurements. Three sheets (`Red`, `Green`, `Blue`), each with columns `Position` (cm), `Reading` (µW, raw power meter reading), `N_LED_used` (total number of LEDs activated during the experiment), and `N_LED_measured` (number of LEDs whose power was sampled by the power meter).

### PIC/

`PIC.mat` — Camera calibration data containing the Pixel Irradiance Coefficient (PIC, units ADU·mm²·s⁻¹·µW⁻¹) for each illumination color (`PIC_red`, `PIC_green`, `PIC_blue`) and the power meter sensor area (`Area_PM_sensor`, mm²).

### Zemax/

`WSFC_zemax_N_10.mat` — Results of 10 Zemax ray-tracing simulation runs of *C. elegans* scattering. Contains paired theta (degrees) and scattering function (sr⁻¹) arrays for three simulation conditions: index-matched/volume-only (`theta_zemax_idxMat_N`, `WSFC_zemax_idxMat_N`), surface-only (`theta_zemax_ext_N`, `WSFC_zemax_ext_N`), and full scattering (`theta_zemax_full_N`, `WSFC_zemax_full_N`).

### Spatial_distribution/

MATLAB `.mat` files containing cross-sectional intensity profiles and the Edge-to-Mean Contrast Index as a function of illumination angle. EMCI > 0 indicates scattering stronger at body edges; EMCI < 0 indicates scattering stronger at body center.

---

## Design File S1

STEP-format 3D CAD files for the object geometries used in Zemax optical simulation: `Worm.step` (worm body), `Agar.step` (agar substrate), `Gel_pad_low.step` and `Gel_socket_low.step` (components of index-matching gelatin media), `WaterFilm_Low.step` (water film around the worm). These files must be copied to the Zemax CAD files folder before running Software S1. Plain-text copies (`.txt`) of each file are provided for readability without CAD software.

---

## Software S1

Ansys Zemax OpticStudio 2024 R2 simulation files. `WormScat.zmx` is the main project file defining the 3D optical system. `WormScat_macro.ZPL` is a ZPL macro that automates simulation runs across illumination angles; the output path must be set before running (instructions inside the file). Pre-computed simulation outputs are provided in `Dataset_S1/Zemax/` and `Dataset_S1/Spatial_distribution/`. Plain-text copies (`WormScat.txt` and `WormScat_macro.txt`) are provided for readability without Zemax OpticStudio.

**Setup:** Copy `.step` files to `Documents\Zemax\Objects\CAD Files` and `WormScat_macro.ZPL` to `Documents\Zemax\Macros`.

---

## Software S2

MATLAB scripts for data analysis and figure generation. Requires the **Curve Fitting Toolbox** and **Statistics and Machine Learning Toolbox**.

**To reproduce figures:** open `Main.m`, set `main_work_dir` and `f_dataset_S1` to your local paths, then run each `%%` section.

| Script | Description |
|---|---|
| `Main.m` | Master script that generates manuscript figures and runs the corresponding statistical tests. |
| `bulk_scatter_contrast_analysis.m` | Combines BF, DF, and backscatter data to compute the full-angle (0°–180°) scattering function p(θ) and contrast index. |
| `scatter_contrast_analysis.m` | Processes an image dataset for a certain range of illumination angles: converts ADU pixel values to irradiance, normalizes by incident power, and returns p(θ) and contrast index. |
| `calculateContrastStats.m` | Computes contrast index per worm–background pair and returns grouped mean and standard deviation. |
| `comput_incident_angle.m` | Converts LED post Position (cm) to illumination angle θ (degrees). |
| `computePICfromFile.m` | Computes the PIC calibration constant from images and corresponding power meter readings. |
| `createPowerFit.m` | Interpolates incident irradiance as a function of illumination angle. |
| `Mie_scat.m` | Computes theoretical Mie scattering functions for a sphere equivalent in volume, surface area, or cross-sectional area to the worm. |
| `saveStat.m` | Saves computed statistics (mean, std, SEM, N per angle) to an Excel spreadsheet, generating Tables S1-S5 as [supplemental materials](https://doi.org/10.1016/j.isci.2026.116117). |
| `dabarplot.m` | Generates bar chart with overlaid scatter points and error bars. |
| `ttest1_from_summary.m` | One-sample t-test from summary statistics (mean, SD, N). |
| `ttest2_from_summary.m` | Two-sample Welch's or equal-variance t-test from summary statistics. |

---

## Code/Software

The following software is required to open and run the files in this repository:

- **[Ansys Zemax OpticStudio 2024 R2](https://www.ansys.com/products/optics/ansys-zemax-opticstudio)** — required to open and run the simulation files in `Software_S1/` and to view the 3D geometry files in `Design_File_S1/`.
- **[MATLAB R2025b](https://www.mathworks.com/products/matlab.html)** — required to run the analysis scripts in `Software_S2/` and to open `.mat` data files in `Dataset_S1/`. Requires the **Curve Fitting Toolbox** and **Statistics and Machine Learning Toolbox**.

---

## Sharing/Access information

Links to other publicly accessible locations of the data: N/A

Data was derived from the following sources: N/A

This dataset is deposited on Dryad ([https://doi.org/10.5061/dryad.s1rn8pkpj](https://doi.org/10.5061/dryad.s1rn8pkpj)) in support of the manuscript:

> Li Z, Fang-Yen C. "Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements." *iScience* (2026). [https://doi.org/10.1016/j.isci.2026.116117](https://doi.org/10.1016/j.isci.2026.116117)
