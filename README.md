# Bird Species Identification

This project prepares bird-attribute annotations as a machine-learning dataset, trains four classifiers, and compares their accuracy with PCA and feature-selection variants.

## Dataset at a glance

- **11,788 images**
- **200 bird species**
- **312 binary attributes per image**

The project workflow reads the prepared files under `data/separated_actual_data_required/`. It does not need or use a separate `CUB_200_2011` directory.

## What do the classes and 312 features mean?

Each image has a numeric species label called a **class ID**. A class ID is a category identifier, not an image number or an accuracy score. For example, **class 1** maps to `001.Black_footed_Albatross` in this project's `class_names.txt`; the notebook checks the class-name mapping rather than treating the number as the species name.

The 312 features are bird attributes, not image pixels. Their names are listed in `features/feature_names.txt`. The feature matrix has one row per image and one column per attribute:

| Matrix entry | Meaning |
| --- | --- |
| `X[i, j] = 1` | Attribute `j` is present for image `i` |
| `X[i, j] = 0` | Attribute `j` is not present for image `i` |

Use the attribute ID to look up the human-readable name in `feature_names.txt` (equivalent to the source dataset's `attributes.txt`). For example, the notebook reports the first features as bill-shape attributes.

## Input files

The input files expected by the notebooks are:

```text
data/
└── separated_actual_data_required/
    ├── features/
    │   ├── image_features.txt
    │   └── feature_names.txt
    └── labels/
        ├── image_labels.txt
        └── class_names.txt
```

The corresponding source dataset files use these concepts and names:

| Source file | Information represented | Prepared project file |
| --- | --- | --- |
| `attributes/image_attribute_labels.txt` | Image ID, attribute ID, whether the attribute is present, and annotation metadata such as certainty/time when available | `features/image_features.txt` |
| `attributes/attributes.txt` | Attribute ID to attribute name | `features/feature_names.txt` |
| `image_class_labels.txt` | Image ID to numeric class ID | `labels/image_labels.txt` |
| `classes.txt` | Class ID to species name | `labels/class_names.txt` |

The project expects the prepared filenames and folder layout shown above. `image_features.txt` records at least `image_id`, `attribute_id`, and `is_present`; if a record has additional columns, the preparation notebook uses the first three fields for the binary matrix. `image_labels.txt` has an image ID and a one-based class ID. Thus, `y[i] = 1` means the image at row `i` belongs to class 1; use `class_names.txt` to find its species name.

Annotations can contain multiple judgments for the same image/attribute pair. The preparation notebook combines them by majority vote; ties count as present.

## Data preparation and split

Open `notebooks/prepare_bird_species_data.ipynb` and run all cells in order. It builds:

```text
X = (11788, 312)   # binary attributes
y = (11788,)       # one-based species class IDs
```

It then makes a reproducible, stratified 70/30 train/test split (`random_state=42`) and saves the arrays as CSV files:

| File | Shape | Contents |
| --- | ---: | --- |
| `data/processed/X_train.csv` | `(8251, 312)` | Training attributes |
| `data/processed/X_test.csv` | `(3537, 312)` | Testing attributes |
| `data/processed/y_train.csv` | `(8251,)` | Training class IDs |
| `data/processed/y_test.csv` | `(3537,)` | Testing class IDs |

For every split, row `i` of `X_train` corresponds to `y_train[i]` (and likewise for the test split). The class IDs remain one-based to match the provided label files.

## Setup

On Windows, run `setup.bat` from the project folder. It creates the project's `.venv` and installs packages listed in `requirements.txt`. In VS Code, select the `.venv` Python kernel for both notebooks. The notebooks use this environment; they do not create another one.

## Model training and comparison

After preparing the data, open `notebooks/train_bird_species_models.ipynb` and run its cells in order. It trains:

- Bernoulli Naive Bayes
- Random Forest
- SVM with an RBF kernel
- Logistic Regression

The final comparison table includes baseline training and testing accuracy, plus test accuracy for PCA, feature selection, and feature selection followed by PCA. PCA retains 95% of the training-data variance. Feature selection keeps the 100 highest-scoring attributes using chi-square. Transformations are fit on the training split only, then applied to the test split. The certainty-metric column from the example table is not included.

Latest recorded accuracy results (proportions are rounded to percentages):

| Method | Training Accuracy | Testing Accuracy | Using PCA | Using Feature Selection | Using PCA + Feature Selection |
| --- | ---: | ---: | ---: | ---: | ---: |
| Naive Bayes | 58.61% | 45.60% | 38.85% | 35.93% | 30.76% |
| Random Forest | 99.89% | 48.12% | 39.02% | 36.56% | 35.79% |
| SVM (RBF) | 86.30% | 49.93% | 48.94% | 39.78% | 38.90% |
| Logistic Regression | 92.66% | 50.64% | 49.45% | 41.65% | 40.77% |

These values are the results of the current saved data split and model settings; rerunning the notebook recomputes and replaces the result files.

## Generated files

```text
models/
├── naive_bayes.pkl
├── random_forest.pkl
├── svm_rbf.pkl
└── logistic_regression.pkl

results/
├── model_results.csv
├── model_metrics.csv
├── accuracy_comparison.png
└── classification_reports.txt
```

`model_results.csv` stores the final accuracy comparison table. `model_metrics.csv` stores baseline F1 scores and runtime measurements. The classification reports are for baseline models. The Random Forest pickle is large (about 2.8 GB). Load pickle files only from trusted sources and use a compatible scikit-learn environment.