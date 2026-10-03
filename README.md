# Bird Species Identification

## Setup

### Windows

1. Install Python if it is not already installed.
2. Open the project folder.
3. Run `setup.bat`. It creates the `.venv` virtual environment and installs the pinned dependencies from `requirements.txt`.
4. In VS Code, open the notebooks and choose the project's `.venv` Python kernel.
5. Ensure the four prepared input files listed below are present locally.
6. Run `notebooks/prepare_bird_species_data.ipynb` first to create the processed train/test CSV files.
7. Then run all cells in `notebooks/train_bird_species_models.ipynb`. This trains the four classifiers and generates `naive_bayes.pkl`, `random_forest.pkl`, `svm_rbf.pkl`, and `logistic_regression.pkl` in `models/`, along with the comparison results in `results/`.

The notebooks use the environment created by `setup.bat`; they do not create another environment. To activate it later in Command Prompt, run:

```bat
.venv\Scripts\activate
```

This project prepares bird-attribute annotations for machine learning, splits the data into training and test sets, trains four classifiers, and compares baseline accuracy with PCA and feature-selection methods.

## Dataset summary

- **11,788 images**
- **200 bird species**
- **312 binary attributes per image**

The notebooks use only the prepared files in `data/separated_actual_data_required/`. They do not read or require `data/CUB_200_2011/`. GitHub will contain only a folder marker for `CUB_200_2011/`; any local contents remain ignored.

## Classes and attributes

Each image has a numeric **class ID** identifying its bird species. Class IDs are categories, not image IDs. For example, **class 1** maps to `001.Black_footed_Albatross` in `class_names.txt`. The notebooks keep these one-based IDs in the target vectors.

The 312 features are semantic bird attributes, not image pixels. The attribute ID maps to its readable name in `feature_names.txt`:

| Feature value | Meaning |
| --- | --- |
| `X[i, j] = 1` | Attribute `j` is present for image `i` |
| `X[i, j] = 0` | Attribute `j` is not present for image `i` |

Examples of attribute names include bill-shape properties such as `has_bill_shape::dagger` and `has_bill_shape::hooked`.

## Data files

The preparation notebook expects the following files locally:

```text
data/
├── CUB_200_2011/                 # unused placeholder; no contents required
├── processed/                    # generated train/test CSV files
└── separated_actual_data_required/
    ├── features/
    │   ├── image_features.txt
    │   └── feature_names.txt
    └── labels/
        ├── image_labels.txt
        └── class_names.txt
```

The prepared filenames correspond to these source-dataset concepts:

| Source dataset file | Information | Prepared project file |
| --- | --- | --- |
| `attributes/image_attribute_labels.txt` | Image ID, attribute ID, presence value, and annotation metadata such as certainty/time | `features/image_features.txt` |
| `attributes/attributes.txt` | Attribute ID to attribute name | `features/feature_names.txt` |
| `image_class_labels.txt` | Image ID to numeric class ID | `labels/image_labels.txt` |
| `classes.txt` | Class ID to species name | `labels/class_names.txt` |

The actual prepared `image_features.txt` rows contain at least `image_id`, `attribute_id`, and `is_present`; they may also include certainty and time fields. The preparation notebook uses the first three fields to build `X`. It combines repeated judgments for an image/attribute pair using a majority vote; ties count as present. Certainty/time fields are not used to weight the feature values.

`image_labels.txt` contains an image ID and a one-based class ID. `class_names.txt` maps each class ID to its species name. For example, `y[i] = 1` means that row belongs to class 1; look up class 1 in `class_names.txt` to get `001.Black_footed_Albatross`.

## GitHub data policy

The root `.gitignore` is set up to:

- Allow `data/processed/` and its train/test CSVs to be committed.
- Ignore the contents of `data/CUB_200_2011/` and `data/separated_actual_data_required/`.
- Keep `.gitkeep` placeholders so the dataset directory names, and the `features/` and `labels/` subdirectory names, can appear in GitHub without uploading their contents.
- Ignore trained files in `models/` while preserving `models/.gitkeep`.

Git does not track empty directories by itself. The `.gitkeep` files are empty placeholders; they are not datasets or trained models. Since the raw inputs are not uploaded, provide the prepared files in `data/separated_actual_data_required/` locally before running the preparation notebook. The notebooks do not use `CUB_200_2011/`.

## Prepare the data

Open `notebooks/prepare_bird_species_data.ipynb` and run its cells in order. It reads the prepared input directory and creates:

```text
X = (11788, 312)   # images by binary bird attributes
y = (11788,)       # one-based bird species IDs
```

It uses a reproducible, stratified 70/30 split with `random_state=42`:

| Array/file | Shape | Contents |
| --- | ---: | --- |
| `X_train` / `data/processed/X_train.csv` | `(8251, 312)` | Training attributes |
| `X_test` / `data/processed/X_test.csv` | `(3537, 312)` | Test attributes |
| `y_train` / `data/processed/y_train.csv` | `(8251,)` | Training species IDs |
| `y_test` / `data/processed/y_test.csv` | `(3537,)` | Test species IDs |

The CSV files contain no header or row index. Each label remains aligned with the corresponding feature row.

## Train and compare models

After creating the processed CSV files, open `notebooks/train_bird_species_models.ipynb` and run all cells in order. The notebook trains:

- Bernoulli Naive Bayes
- Random Forest
- SVM with an RBF kernel
- Logistic Regression

The comparison table reports baseline training and test accuracy, and test accuracy using:

- **PCA:** retain 95% of variance.
- **Feature selection:** select the 100 highest-scoring attributes using chi-square.
- **PCA + Feature Selection:** select 100 attributes, then apply PCA retaining 95% of variance.

The transformations are fitted using training data only and then applied to the held-out test data. The certainty-metric column from the reference table is not included. Baseline classification reports and F1/runtime metrics are also saved.

Latest recorded accuracy results:

| Method | Training Accuracy | Testing Accuracy | Using PCA | Using Feature Selection | Using PCA + Feature Selection |
| --- | ---: | ---: | ---: | ---: | ---: |
| Naive Bayes | 58.61% | 45.60% | 38.85% | 35.93% | 30.76% |
| Random Forest | 99.89% | 48.12% | 39.02% | 36.56% | 35.79% |
| SVM (RBF) | 86.30% | 49.93% | 48.94% | 39.78% | 38.90% |
| Logistic Regression | 92.66% | 50.64% | 49.45% | 41.65% | 40.77% |

These values are actual results from the current saved split and model settings, not targets or hard-coded predictions. Running the notebook again recalculates and replaces the result files. For Bernoulli Naive Bayes, PCA produces continuous-valued components that the estimator treats as Bernoulli inputs; interpret that PCA comparison cautiously.

## Generated outputs

```text
data/processed/
├── X_train.csv
├── X_test.csv
├── y_train.csv
└── y_test.csv

models/
├── .gitkeep
├── naive_bayes.pkl              # generated locally; ignored by Git
├── random_forest.pkl            # generated locally; ignored by Git
├── svm_rbf.pkl                  # generated locally; ignored by Git
└── logistic_regression.pkl      # generated locally; ignored by Git

results/
├── model_results.csv            # final accuracy comparison table
├── model_metrics.csv            # baseline F1 scores and runtime metrics
├── accuracy_comparison.png      # accuracy chart
└── classification_reports.txt   # baseline per-class reports
```

The Random Forest pickle is about 2.8 GB and is intentionally not included in Git. Pickle files should only be loaded from trusted sources and require a compatible Python/scikit-learn environment.
