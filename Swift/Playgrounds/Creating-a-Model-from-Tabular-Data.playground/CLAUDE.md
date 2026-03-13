# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an ISLR2 (Introduction to Statistical Learning, 2nd Edition) study repository. It contains:

- **Labs/**: Jupyter notebooks (`.ipynb`) implementing ISLR2 labs (Lab01–Lab10), primarily in Python/R
- **Swift/Playgrounds/**: Xcode Swift Playgrounds for ML model training using Apple's CreateML/CoreML frameworks
- **Swift/CreateML/**: CreateML project files (`.mlproj`) for training models via the CreateML app
- **Swift/CoreML/**: Exported `.mlmodel` files for use in apps
- **data/**: CSV datasets used across labs and playgrounds

## Swift Playgrounds

Playgrounds target **macOS** and use `CreateML` and `TabularData` frameworks. They are opened and run in **Xcode** (not Swift Playgrounds app) since they require macOS-only CreateML APIs.

### Current Playgrounds

- **Creating-a-Model-from-Tabular-Data.playground**: Apple sample demonstrating `MLRegressor` and `MLClassifier` on Martian habitat data (`MarsHabitats.csv`). Saves trained models to the Desktop.
- **Carseats.playground**: Trains an `MLClassifier` on the ISLR2 Carseats dataset to predict `High` (binary sales classification). Saves model to `~/Projects/R/ISLR2/Swift/CoreML/CarseatsClassifier.mlmodel`.

### Playground Structure

```
<Name>.playground/
  contents.xcplayground     # Declares pages and target platform
  Pages/                    # Multi-page playgrounds use this
  Resources/                # CSV data files bundled with the playground
```

Single-page playgrounds use `Contents.swift` at the root; multi-page ones use `Pages/<PageName>.xcplaygroundpage/Contents.swift`.

### Key Patterns

- Load CSV data via `Bundle.main.url(forResource:withExtension:)` for resources inside the playground, or `FileManager.default.homeDirectoryForCurrentUser` for external files
- Use `MLDataTable` (older API) or `DataFrame` from `TabularData` (newer API) to read CSVs
- Train with `MLRegressor` or `MLClassifier`, then evaluate with `.trainingMetrics` / `.validationMetrics` / `.evaluation(on:)`
- Save models with `.write(to:metadata:)`

## Datasets

All CSV datasets live in `data/`. Key ones used in Swift:
- `MarsHabitats.csv` — fictional Mars habitat data (price, size, greenhouses, solarPanels, purpose)
- `Carseats_all.csv`, `Carseats_train.csv`, `Carseats_test.csv` — ISLR2 Carseats data with `High` binary target
