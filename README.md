# Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements

**Authors:** Zihao (John) Li and Christopher Fang-Yen  
**Affiliation:** Department of Biomedical Engineering, The Ohio State University  
**Related manuscript:** Li Z, Fang-Yen C. "Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements." iScience (2026). https://doi.org/10.1016/j.isci.2026.116117

---

## Overview

This dataset contains the raw experimental measurements, optical simulation results, 3D design files, and analysis code supporting a study of how *Caenorhabditis elegans* (a microscopic roundworm widely used as a model organism in biology) scatters light. The study used angle-resolved measurements — that is, measurements of scattered light at many different angles relative to the illumination direction — to characterize and separate two mechanisms of light scattering: (1) **surface scattering**, which occurs at the boundary between the worm's body and its surrounding medium, and (2) **volume scattering** (also called bulk scattering), which occurs within the interior of the worm's body due to its internal structure.

Understanding these scattering mechanisms has practical value for optimizing the imaging contrast of *C. elegans* under microscopes, because different illumination angles and wavelengths favor different scattering mechanisms and thus produce different amounts of contrast between the worm and its background.

### Experimental Setup (brief summary)

A custom angle-resolved scattering system was used. A ring of LEDs (radius 47.5 mm) was mounted on a motorized post, allowing the illumination angle θ (the angle between the incident light and the axis normal to the sample plane) to be varied from near 0° (nearly perpendicular to the sample) to approximately 90°. Three LED colors were used: red (~629 nm), green (~516 nm), and blue (~447 nm). Images of individual *C. elegans* worms on agar plates were captured using a camera, and measurements were taken in three geometric configurations: brightfield (BF, forward-scattered light collected on-axis), darkfield (DF, forward-scattered light collected off-axis), and backscatter (Backscat, light scattered back toward the source side). Together, BF and DF data cover the forward scattering angular range (θ = 0°–90°), and Backscat data covers the backward scattering range (θ = 90°–180°). Experiments were repeated under different substrate conditions (seeded agar with *E. coli* bacteria, unseeded agar, gelatin, and gellan gum) and index-matching conditions (standard vs. index-matched, in which the refractive index of the medium surrounding the worm is matched to that of the worm's body surface to suppress surface scattering and isolate volume scattering).

---

## Contents and File Structure

```
Dataset_S1/          Raw experimental and simulation data
Design_File_S1/      3D CAD design files for optical simulations
Software_S1/         Zemax OpticStudio simulation project files
Software_S2/         MATLAB data analysis scripts
```

---

## Dataset S1

Raw data for all figures in the manuscript. All measurement data files share a common format described below.

### Common Format: `data.xlsx` (imaging measurement files)

Every `data.xlsx` file is a spreadsheet with the following columns:

| Column | Units | Description |
|---|---|---|
| `Position` | cm | Position reading from the motorized LED post. Higher values correspond to the LED being closer to the sample, yielding smaller illumination angles. Converted to angle θ by the `comput_incident_angle.m` script (see Software S2). |
| `Category` | — | Label identifying whether the row corresponds to a measurement region containing a `"worm"` or a `"background"` region (the nearby agar/substrate without a worm). |
| `Mean` | ADU (analog-to-digital units) | Mean pixel intensity of the image region of interest (ROI), in raw camera units. |
| `Exposure` | seconds | Camera exposure time for that image. Used to normalize pixel intensity to a per-second rate. |

Each row represents one image (one worm or one background ROI at one LED position). Multiple rows at the same Position reflect measurements from multiple individual worms (for `"worm"` rows) or multiple background regions (for `"background"` rows).

**How `Position` maps to angle θ:** The motorized post holds the LED ring (radius = 47.5 mm). As the post is raised (increasing Position reading), the LED moves farther from the sample, decreasing the illumination angle. The formula used is:  
θ = arctan(R / (d_min + (P_max − P) × 10))  
where R = 47.5 mm is the LED ring radius, d_min is the minimum vertical distance (mm), P_max is the maximum position reading (cm), and P is the measured position reading (cm). For forward scattering (BF, DF), P_max = 51 cm and d_min = 15 mm. For backscatter, the geometry is mirrored and θ is reported as 180° minus the equivalent forward angle.

---

### Folder Structure within Dataset S1

#### BF_seeded_RGB/ — Brightfield imaging on seeded agar

*Seeded agar* plates contain a lawn of *Escherichia coli* bacteria that the worms feed on. Bacteria on the agar create additional scattering at the substrate surface.

In brightfield imaging, light scattered by the worm in the near-forward direction (small angles relative to the optical axis) is collected by the camera. This configuration primarily captures forward scattering from the worm.

**Sub-folders:**

- `Non_idx_mat/` — Standard (non-index-matched) conditions, in which the worm is surrounded by agar and water, creating a refractive index contrast between the worm surface and its surroundings. This contrast gives rise to surface scattering.
  - `red/data.xlsx`, `green/data.xlsx`, `blue/data.xlsx` — Measurements at 629 nm, 516 nm, and 447 nm, respectively.
- `Idx_mat/` — Index-matched conditions, in which the worm surroundings are replaced with a fluid whose refractive index closely matches that of the worm body. This suppresses surface scattering so that the remaining scattering is predominantly due to volume (bulk) scattering from within the worm's body.
  - `red_idxMat/data.xlsx`, `green_idxMat/data.xlsx`, `blue_idxMat/data.xlsx`
- `setting/` — Screenshots of the microscopy software settings used during acquisition (`.PNG` files). These are for documentation purposes and are not read by the analysis scripts.

#### DF_seeded_RGB/ — Darkfield (off-axis forward scatter) imaging on seeded agar

In darkfield imaging, the direct (unscattered) beam is blocked and only off-axis scattered light is collected. This allows detection of light scattered at larger forward angles that would otherwise be masked by the bright transmitted beam in brightfield. Together, BF and DF cover complementary angular ranges of the forward hemisphere.

- `red/data.xlsx`, `green/data.xlsx`, `blue/data.xlsx`
- `setting/` — Acquisition settings screenshots.

#### DF_seeded_idx_mat_RGB/ — Darkfield imaging on seeded agar, index-matched

Same configuration as DF_seeded_RGB, but with the index-matching fluid.

- `red/data.xlsx`, `green/data.xlsx`, `blue/data.xlsx`
- `setting/` — Acquisition settings screenshots.

#### Backscat_seeded_RGB/ — Backscatter imaging on seeded agar

Light scattered back toward the illumination side (θ ≈ 90°–180°) is measured. Together with forward scattering data, this completes the full angular profile of the scattering function.

- `red/data.xlsx`, `green/data.xlsx`, `blue/data.xlsx`
- `setting/` — Acquisition settings screenshots.

#### Backscat_seeded_idx_mat_RGB/ — Backscatter imaging on seeded agar, index-matched

Same as Backscat_seeded_RGB, but with the index-matching fluid.

- `red/data.xlsx`, `green/data.xlsx`, `blue/data.xlsx`
- `setting/` — Acquisition settings screenshots.

#### BF_unseed_RGB/ — Brightfield imaging on unseeded agar

*Unseeded agar* plates have no bacteria. Without the bacterial lawn, the agar substrate scatters less light, providing a cleaner background for isolating worm scattering.

- `Non_idx_Mat/red/data.xlsx` — Standard conditions, red channel only.
- `Idx_Mat/red/data.xlsx` — Index-matched conditions, red channel only.
- `setting/` — Acquisition settings screenshots.

#### DF_unseed_RGB/ — Darkfield imaging on unseeded agar

- `red/data.xlsx`
- `setting/` — Acquisition settings screenshots.

#### Backscat_unseed_RGB/ — Backscatter imaging on unseeded agar

- `red/data.xlsx`
- `setting/` — Acquisition settings screenshots.

#### Substrate_RGB/ — Scattering measurements on different substrates without worms

These measurements characterize the scattering properties of three substrate materials used in *C. elegans* research, both as backgrounds and as hosts for worm imaging. Worms were placed on each substrate for the worm measurements; substrate-only (no-worm) background measurements are captured in these files. Three substrates were tested:

- **Agar** — Standard agarose gel, the most common substrate in worm research. Prepared from agar powder in M9 buffer.
- **Gelatin** — Gelatin-based gel, sometimes used as an alternative substrate.
- **Rite** (gellan gum, commercially sold as "Rite-On") — A synthetic polymer gel used as an alternative substrate.

Sub-folder structure: `Substrate_RGB/{Agar,Gelatin,Rite}/{red,green,blue}/data.xlsx`

Each `data.xlsx` follows the same format as above (Position, Category, Mean, Exposure). The `Category` column contains `"worm"` (worm on substrate) and `"background"` (substrate without worm).

> **Note (Rite/red/):** A `Note.txt` file is present in `Substrate_RGB/Rite/red/` with the note: *"this analysis includes the track in calculating the background"*. This means that in this particular dataset, the worm's movement track on the gellan gum substrate was included in the background region ROI when calculating the background scattering value.

`setting/` — Screenshots of acquisition settings.

#### Power_Meter_data/

`Power_Meter_data.xlsx` — Calibration measurements of the incident light power delivered by the LED ring as a function of LED position. This is used to normalize the scattering measurements by the incident optical power so that results are expressed as scattering functions (sr⁻¹) independent of the source intensity.

The spreadsheet has three sheets, one per color: `Red`, `Green`, `Blue`. Each sheet has the following columns:

| Column | Units | Description |
|---|---|---|
| `Position` | cm | LED post position reading, same scale as in `data.xlsx` files. |
| `Reading` | µW | Raw power meter reading (optical power incident on the sensor). |
| `N_LED_used` | — | Number of LEDs in the ring that were turned on for the measurement. |
| `N_LED_measured` | — | Number of LEDs whose power was actually measured (may differ from `N_LED_used` if only a subset was measured, in which case the total power is scaled by `N_LED_used / N_LED_measured`). |

A wavelength correction factor is applied in software to account for the wavelength-dependent sensitivity of the power meter sensor:
- Red: corrected reading = raw reading × (15.1 / 14.7)
- Green: corrected reading = raw reading × (12.2 / 11.6)
- Blue: corrected reading = raw reading × (30.0 / 26.5)

These ratios correct for the difference in sensor responsivity between the LED peak wavelength and the reference wavelength used during calibration.

#### PIC/

`PIC.mat` — A MATLAB data file containing the **Pixel Irradiance Coefficient (PIC)**, a camera calibration constant that relates pixel values (ADU) recorded by the camera to the actual optical irradiance (power per unit area) at the camera sensor.

Variables in `PIC.mat`:

| Variable | Units | Description |
|---|---|---|
| `PIC_red` | ADU · mm² · s⁻¹ · µW⁻¹ | Pixel irradiance coefficient for red channel (629 nm). |
| `PIC_green` | ADU · mm² · s⁻¹ · µW⁻¹ | Pixel irradiance coefficient for green channel (516 nm). |
| `PIC_blue` | ADU · mm² · s⁻¹ · µW⁻¹ | Pixel irradiance coefficient for blue channel (447 nm). |
| `Area_PM_sensor` | mm² | Area of the power meter sensor aperture, used to convert total incident power (µW) to incident irradiance (µW · mm⁻²). |

The PIC was determined by illuminating the camera with a known irradiance (measured by a calibrated power meter) and recording the resulting pixel value at a known exposure time. It allows conversion: Irradiance (µW · mm⁻²) = Mean pixel value (ADU) / (Exposure time (s) × PIC).

#### Zemax/

`WSFC_zemax_N_10.mat` — MATLAB data file containing the results of 10 independent Zemax OpticStudio non-sequential ray-tracing simulations of light scattering from a 3D model of *C. elegans*. Each simulation run uses a different random realization of the worm's internal refractive index distribution (modeled as a random 3D texture), so the 10 runs provide an estimate of variability.

Variables in `WSFC_zemax_N_10.mat`:

| Variable | Dimensions | Units | Description |
|---|---|---|---|
| `theta_zemax_idxMat_N` | 10 × M | degrees | Scattering angles for each of the 10 simulation runs, **index-matched** condition (volume scattering only; surface scattering is disabled by matching refractive indices at the worm surface). |
| `WSFC_zemax_idxMat_N` | 10 × M | sr⁻¹ | Worm scattering function values at each angle, index-matched condition. |
| `theta_zemax_ext_N` | 10 × M | degrees | Scattering angles, **surface scattering only** condition (volume scattering is disabled by making the worm interior homogeneous). |
| `WSFC_zemax_ext_N` | 10 × M | sr⁻¹ | Worm scattering function values, surface scattering only. |
| `theta_zemax_full_N` | 10 × M | degrees | Scattering angles, **full (complete) scattering** condition (both surface and volume scattering active). |
| `WSFC_zemax_full_N` | 10 × M | sr⁻¹ | Worm scattering function values, full scattering. |

The **scattering function p(θ)** (sr⁻¹) quantifies the fraction of incident optical power scattered per steradian of solid angle in the direction θ, normalized by the cross-sectional area of the worm. It characterizes the angular distribution of light scattering.

#### Spatial_distribution/

MATLAB data files containing measurements and simulations of the **spatial distribution** of scattered light across the cross-section of the worm (i.e., how the scattered intensity varies across the width of the worm image at a given illumination angle). These data support the analysis of whether scattering originates predominantly from the worm surface or interior.

The **Edge-to-Mean Contrast Index (EMCI)** is a scalar quantity computed from the cross-sectional intensity profile: EMCI = (I_edge − I_center) / (I_edge + I_center), where I_edge is the intensity near the worm edge and I_center is the intensity at the worm center. EMCI > 0 indicates the scattering is brighter at the worm edges (consistent with surface scattering); EMCI < 0 indicates the center is brighter (consistent with volume scattering).

| File | Description |
|---|---|
| `Spatial_nonIdxMat.mat` | Experimental cross-sectional intensity profiles and EMCI data for the **non-index-matched** condition (both surface and volume scattering active). Contains variables: `rep_profiles` (representative normalized cross-sectional intensity profiles, rows = illumination angles, columns = spatial position across worm width); `rep_theta` (illumination angles in degrees corresponding to each row of `rep_profiles`); `shapeIdx_exp` (EMCI values for one experimental trial, rows = repeat measurements, columns = illumination angles); `theta_xsec_exp` (illumination angles in degrees for EMCI measurements); `theta_xsec_Zemax_N` (simulation angles for EMCI); `shapeIdx_Zemax_N` (simulated EMCI values, rows = simulation runs). |
| `Spatial_idxMat.mat` | Same structure as above, but for the **index-matched** condition. Variable names are suffixed with `_idxMat` (e.g., `rep_profiles_idxMat`, `rep_theta_idxMat`, `shapeIdx_exp_idxMat`, `theta_xsec_exp_idxMat`, `theta_xsec_Zemax_N_idxMat`, `shapeIdx_Zemax_N_idxMat`). |
| `shapeIdx_exp_nonIdxMat_2.mat` | EMCI data for a second experimental trial, non-index-matched. Contains variable `shapeIdx_exp_2`. |
| `shapeIdx_exp_nonIdxMat_3.mat` | EMCI data for a third experimental trial, non-index-matched. Contains variable `shapeIdx_exp_3`. |
| `shapeIdx_exp_idxMat_2.mat` | EMCI data for a second experimental trial, index-matched. Contains variable `shapeIdx_exp_idxMat_2`. |
| `shapeIdx_exp_idxMat_3.mat` | EMCI data for a third experimental trial, index-matched. Contains variable `shapeIdx_exp_idxMat_3`. |
| `stat_repProfile_Zemax_N_nonIdxMat.mat` | Statistical summary of simulated cross-sectional intensity profiles, non-index-matched. Contains: `repProfile_Zemax_N` (cell array of simulated profiles for each run), `mean_repProfile_Zemax_N` (mean profile at each angle), `sem_repProfile_Zemax_N` (standard error of the mean of the profile). |
| `stat_repProfile_Zemax_N_idxMat.mat` | Same as above for index-matched condition. Variables: `repProfile_Zemax_N_idxMat`, `mean_repProfile_Zemax_N_idxMat`, `sem_repProfile_Zemax_N_idxMat`. |

---

## Design File S1

3D CAD model files in STEP format (.step) representing the physical geometry of *C. elegans* and its surrounding environment as used in the Zemax optical simulations.

| File | Description |
|---|---|
| `Worm.step` | 3D model of the *C. elegans* body (ellipsoidal geometry approximating the worm's shape). |
| `Agar.step` | 3D model of the agar substrate layer beneath the worm. |
| `Gel_pad_low.step` | 3D model of the gel pad component for alternative substrate geometries. |
| `Gel_socket_low.step` | 3D model of the gel socket component for alternative substrate geometries. |
| `WaterFilm_Low.step` | 3D model of the thin water film surrounding the worm (between worm and air). |

These STEP files must be imported into Ansys Zemax OpticStudio to set up the simulation. See Software S1 for instructions.

---

## Software S1

Optical simulation files for Ansys Zemax OpticStudio 2024 R2. Non-sequential ray tracing is used to simulate the propagation of light rays through the 3D model of the worm and its surroundings at different scattering conditions.

| File | Description |
|---|---|
| `WormScat.zmx` | Zemax OpticStudio project file defining the optical system: 3D geometry (imported from Design File S1), light source (ray bundle), and detector configuration. |
| `WormScat_macro.ZPL` | Zemax Programming Language (ZPL) macro script that automates running the simulation across multiple random refractive index realizations of the worm interior and saves the results. The output path must be edited before running (instructions are inside the file). |

**Setup instructions:**

1. Copy all `.step` files from Design File S1 to the Zemax CAD files folder (on Windows: `C:\Users\<username>\Documents\Zemax\Objects\CAD Files`).
2. Copy `WormScat_macro.ZPL` to the Zemax Macros folder (on Windows: `C:\Users\<username>\Documents\Zemax\Macros`).
3. Edit `WormScat_macro.ZPL` to specify the desired output directory for simulation results.
4. Open `WormScat.zmx` in Ansys Zemax OpticStudio 2024 R2 and run the macro.

Simulation output is saved as a MATLAB `.mat` file, which is provided pre-computed in `Dataset_S1/Zemax/WSFC_zemax_N_10.mat` and `Dataset_S1/Spatial_distribution/`.

---

## Software S2

MATLAB scripts for analyzing the experimental data and reproducing the figures in the manuscript. Requires MATLAB with the **Curve Fitting Toolbox** and **Statistics and Machine Learning Toolbox**.

### Running the analysis

1. Open `Main.m` in MATLAB.
2. Edit the three directory path variables near the top of `Main.m` to point to the locations of the downloaded data on your computer:
   - `main_work_dir` — folder containing `Main.m` (i.e., the Software S2 folder).
   - `f_dataset_S1` — folder containing Dataset S1.
3. Run `Main.m` section by section (each `%%` section corresponds to one figure).

### Script descriptions

| Script | Description |
|---|---|
| `Main.m` | Master script. Each `%%` section generates one figure from the manuscript and performs corresponding statistical tests. Calls all helper functions below. |
| `bulk_scatter_contrast_analysis.m` | Combines brightfield (BF), darkfield (DF), and backscatter data to compute the complete angle-resolved scattering function p(θ) (sr⁻¹) and contrast index over the full range θ = 0°–180°. BF and DF cover forward scattering (0°–90°); backscatter covers the backward range (90°–180°). |
| `scatter_contrast_analysis.m` | Processes a single imaging modality (BF, DF, or backscatter). Converts pixel values (ADU) to irradiance (µW · mm⁻²) using the PIC and exposure time, normalizes by incident power, and computes p(θ) and contrast index. |
| `calculateContrastStats.m` | Computes the **contrast index** for each paired worm–background image: contrast = (I_worm − I_background) / (I_worm + I_background), dimensionless, ranging from −1 to +1. Positive values indicate the worm is brighter than its background; negative values indicate the worm is darker. Groups results by position and returns mean and standard deviation across measurements. |
| `comput_incident_angle.m` | Converts the position reading (cm) from the motorized LED post to the corresponding illumination angle θ (degrees) using the known LED ring radius and geometry. |
| `computePICfromFile.m` | Computes the pixel irradiance coefficient (PIC) from camera images taken with the illumination off and on, combined with simultaneous power meter readings. |
| `createPowerFit.m` | Fits the measured incident irradiance (µW · mm⁻²) as a function of illumination angle using linear interpolation, producing a smooth function used to normalize measurements at each angle. |
| `Mie_scat.m` | Calculates theoretical Mie scattering functions for a sphere with equivalent volume or surface area to the worm, for comparison with experimental data. |
| `saveStat.m` | Saves computed statistics to an Excel spreadsheet. Output columns for scattering function data: `theta_degrees`, `mean_inverse_steradian`, `std_inverse_steradian`, `sem_inverse_steradian`, `sem_to_mean_ratio`, `N`. Output columns for contrast index data: `theta_degrees`, `mean_contrast_index`, `std_contrast_index`, `sem_contrast_index`, `N`. |
| `dabarplot.m` | Custom bar chart function with overlaid scatter points and error bars, used for Figure 5B. |
| `ttest1_from_summary.m` | One-sample t-test using pre-computed summary statistics (mean, standard deviation, N) rather than raw data. Tests whether a mean differs significantly from a specified value (e.g., whether contrast index differs from zero). |
| `ttest2_from_summary.m` | Two-sample t-test (Welch's or equal-variance) using summary statistics. Tests whether two means are significantly different (e.g., whether the scattering function differs between conditions). |

### Figure index

The sections of `Main.m` correspond to the following manuscript figures:

| Section in Main.m | Figure | Description |
|---|---|---|
| Generation of Fig. 1C | Fig. 1C | Worm and agar scattering functions p(θ) vs. angle at 629 nm (red), comparing seeded vs. unseeded agar. Illustrates the angular distribution of forward and backward scattering from the worm and its substrate. Data from `BF_seeded_RGB/Non_idx_mat/red/`, `DF_seeded_RGB/red/`, `Backscat_seeded_RGB/red/`, and unseeded equivalents. |
| Generation of Fig. 1D | Fig. 1D | Contrast index vs. angle at 629 nm (red), comparing worm on seeded vs. unseeded agar. Shows how image contrast between the worm and background changes with illumination angle. |
| Generation of Fig. 1E | Fig. 1E | Worm and agar scattering functions p(θ) at three wavelengths (629 nm red, 516 nm green, 447 nm blue), seeded agar. Demonstrates wavelength dependence of scattering. |
| Generation of Fig. 1F | Fig. 1F | Contrast index vs. angle at three wavelengths (629 nm, 516 nm, 447 nm), seeded agar. Shows wavelength dependence of image contrast. |
| Generation of Fig. 2C | Fig. 2C | Scattering functions p(θ) comparing non-index-matched (NIM) vs. index-matched (IM) conditions at 629 nm, seeded agar. Separates surface and volume scattering contributions. |
| Generation of Fig. 2D | Fig. 2D | Contrast index vs. angle for NIM vs. IM conditions. |
| Generation of Fig. 2E | Fig. 2E | Experimental scattering functions (NIM and IM) vs. Zemax simulation predictions. Validates the computational model and compares the model + seeded agar background with experiment. |
| Generation of Fig. 2F | Fig. 2F | Simulation-derived scattering functions for volume scattering only (IM model), surface scattering only (SS model), and complete scattering (full model), plus their sum (VS + SS). Illustrates how the two scattering mechanisms interact. |
| Generation of Fig. 3B | Fig. 3B | Representative normalized cross-sectional intensity profiles across the worm width at multiple illumination angles, NIM condition, comparing experiment (red) and simulation (black dashed). |
| Generation of Fig. 3D | Fig. 3D | Same as Fig. 3B but for the IM condition. |
| Generation of Fig. 3E | Fig. 3E | EMCI (edge-to-mean contrast index, dimensionless) vs. illumination angle, NIM condition, experiment vs. simulation. EMCI > 0: edges brighter (surface scattering dominant); EMCI < 0: center brighter (volume scattering dominant). |
| Generation of Fig. 3F | Fig. 3F | EMCI vs. angle for IM condition. |
| Generation of Fig. 5A | Fig. 5A | Worm and substrate scattering functions p(θ) for three substrate materials (agar, gelatin, gellan gum) at 629 nm. Characterizes substrate-dependent scattering in the forward direction (0°–90°). |
| Generation of Fig. 5B | Fig. 5B | Bar chart of peak contrast index for three substrates (agar, gelatin, gellan gum) at three wavelengths (blue/green/red). Summarizes which substrate and wavelength combination produces the best imaging contrast. |
| Generation of Fig. S1A | Fig. S1A | Scattering functions and contrast index for green (516 nm) and blue (447 nm) channels under IM and NIM conditions. Supplementary wavelength comparison. |

---

## Abbreviations and Key Terms

| Term | Definition |
|---|---|
| *C. elegans* | *Caenorhabditis elegans*, a microscopic (~1 mm long) transparent roundworm used extensively as a model organism in biology. |
| θ (theta) | Illumination angle: the angle between the incident light direction and the optical axis of the imaging system. θ = 0° corresponds to light traveling directly into the camera (transmission/brightfield); θ = 180° corresponds to light traveling directly back toward the source (backscatter). |
| p(θ) | Scattering function: characterizes how much light is scattered per unit solid angle in the direction θ, normalized by incident irradiance and worm cross-sectional area. Unit: sr⁻¹ (inverse steradians). |
| sr | Steradian, the SI unit of solid angle. A full sphere subtends 4π steradians. |
| Contrast index | (I_worm − I_background) / (I_worm + I_background), dimensionless. Measures how distinguishable the worm is from its background in an image. Range: −1 to +1. |
| EMCI | Edge-to-Mean Contrast Index: (I_edge − I_center) / (I_edge + I_center) computed from the cross-sectional intensity profile across the worm. Indicates whether scattering is stronger at the worm edge (surface scattering, EMCI > 0) or interior (volume scattering, EMCI < 0). |
| BF | Brightfield imaging: camera collects light transmitted straight through or scattered at small angles near the optical axis. |
| DF | Darkfield imaging: the unscattered direct beam is blocked; only off-axis scattered light is collected. |
| Backscat | Backscatter imaging: light scattered back in the direction of the illumination source is detected. |
| IM | Index-matched: the fluid surrounding the worm has the same refractive index as the worm surface, suppressing surface reflections and surface scattering. Only volume (internal) scattering remains. |
| Non-IM (NIM) | Non-index-matched: standard experimental condition with refractive index contrast between the worm and its surroundings, giving rise to both surface and volume scattering. |
| Volume scattering (VS) | Light scattering caused by spatial variations in refractive index within the interior of the worm's body. |
| Surface scattering (SS) | Light scattering caused by refraction and reflection at the interface between the worm's body surface and the surrounding medium. |
| PIC | Pixel Irradiance Coefficient: camera calibration constant converting raw pixel values (ADU) to optical irradiance (µW · mm⁻²). Units: ADU · mm² · s⁻¹ · µW⁻¹. |
| ADU | Analog-to-digital unit: the raw integer unit of pixel intensity reported by a digital camera. |
| LED | Light-emitting diode, used as the illumination source. |
| nm | Nanometers, unit of light wavelength. Red ≈ 629 nm, green ≈ 516 nm, blue ≈ 447 nm. |
| µW | Microwatt, unit of optical power (1 µW = 10⁻⁶ W). |
| mm² | Square millimeter, unit of area. |
| sr⁻¹ | Inverse steradian, unit of the scattering function p(θ). |
| SEM | Standard error of the mean = standard deviation / √N. |
| STEP | Standard for the Exchange of Product model data, a 3D CAD file format (.step). |
| ZMX | Zemax project file format for Ansys Zemax OpticStudio. |
| ZPL | Zemax Programming Language, used for automation macros in Zemax OpticStudio. |
| Seeded agar | Agar growth plate inoculated with *E. coli* bacteria, the standard food source for *C. elegans* in the laboratory. |
| Unseeded agar | Agar plate without bacteria. |
| Gellan gum (Rite-On) | A synthetic polysaccharide gel used as an alternative *C. elegans* substrate; marketed under the brand name Rite-On. |

---

## Software Requirements

- **MATLAB** (tested with R2023 or later; requires Curve Fitting Toolbox and Statistics and Machine Learning Toolbox) — for running Software S2.
- **Ansys Zemax OpticStudio 2024 R2** (non-sequential mode) — for running the optical simulations in Software S1.
- **Microsoft Excel** or compatible spreadsheet software — for viewing `data.xlsx` and `Power_Meter_data.xlsx` files.

---

## Sharing and Access

This dataset is deposited on Dryad in support of the manuscript:

> Li Z, Fang-Yen C. "Mechanisms of surface and volume light scattering from *Caenorhabditis elegans* revealed by angle-resolved measurements." iScience (2026). https://doi.org/10.1016/j.isci.2026.116117
