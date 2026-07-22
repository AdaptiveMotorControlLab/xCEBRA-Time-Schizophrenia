# xCEBRA-Time-Schizophrenia

This repository contains notebooks for running xCEBRA-based analyses and figure generation for schizophrenia time-series experiments.

## Repository contents

- `xCEBRA_combined.ipynb` — main xCEBRA workflow.
- `Ensemble_xCEBRA_models.ipynb` — ensemble modeling workflow.
- `Decode_clinical_variables_different_decoders.ipynb` — decoder comparison for clinical variables.
- `Data_Pipeline_for_publishing/` — preprocessing and atlas/time-course preparation notebooks.
- `Plotting_for_figures/` — plotting notebooks and generated figures.

## View notebooks with Jupyter Book

This repo includes Jupyter Book configuration files:

- `_config.yml`
- `_toc.yml`

To build and serve the book locally:

1. Install Jupyter Book:
   - `pip install jupyter-book`
2. Build the site from the repository root:
   - `jupyter-book build .`
3. Open:
   - `_build/html/index.html`

## Table of contents

The notebook navigation is defined in `_toc.yml` and grouped into:

- Main analyses
- Data pipeline
- Plotting notebooks
