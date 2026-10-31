<div align="center">

# Bird Species Identification — Smart Bird Recognition

Bird species classification powered by structured binary attributes and classic machine learning models.

![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?style=for-the-badge&logo=python)
![scikit-learn](https://img.shields.io/badge/scikit--learn-1.5%2B-F7931E?style=for-the-badge&logo=scikit-learn)
![Pandas](https://img.shields.io/badge/Pandas-2.0%2B-150458?style=for-the-badge&logo=pandas)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=for-the-badge&logo=jupyter)

This project builds a bird-species classifier using 312 binary bird attributes per image. The dataset is already clean and ready to use, and no additional data-science preprocessing was performed beyond preparing the feature matrix and label vectors for model training and evaluation.

</div>

The pipeline includes:

- preparing the local dataset files
- splitting data into training and test sets
- evaluating multiple classifiers
- comparing baseline accuracy with PCA and feature-selection variants
- saving model metrics and visual outputs

## Overview

This project works with the Caltech-UCSD Birds-200-2011 (CUB-200-2011) attribute dataset-style structure, where each image is represented by:

- 312 binary attribute features
- one bird-species label
- 11,788 total images
- 200 bird classes

The provided dataset is already clean and ready to use. No additional data-cleaning or data-science preprocessing was performed beyond converting the prepared files into the training and test matrices used by the models.

The notebooks in this project:

1. Read the local prepared dataset files
2. Convert them into train/test arrays
3. Train multiple classification models
4. Compare model performance with and without PCA/feature selection
5. Save outputs in `results/`

## Project Structure

```text
Bird-Species-Identification/
├── data/
│   ├── separated_actual_data_required/
│   │   ├── features/
│   │   │   ├── feature_names.txt
│   │   │   └── image_features.txt
│   │   └── labels/
│   │       ├── class_names.txt
│   │       └── image_labels.txt
│   ├── processed/
│   │   ├── X_train.csv
│   │   ├── X_test.csv
│   │   ├── y_train.csv
│   │   └── y_test.csv
│   └── CUB_200_2011/            # local placeholder/not used directly
├── models/
│   ├── .gitkeep
│   ├── naive_bayes.pkl
│   ├── random_forest.pkl
│   ├── svm_rbf.pkl
│   └── logistic_regression.pkl
├── notebooks/
│   ├── prepare_bird_species_data.ipynb
│   └── train_bird_species_models.ipynb
├── results/
│   ├── accuracy_comparison.png
│   ├── classification_reports.txt
│   ├── model_metrics.csv
│   └── model_results.csv
├── .gitignore
├── README.md
├── requirements.txt
├── setup.bat
└── data.zip
```

## Data Notes

The repository does not track the dataset files in Git. The `data/` folder is excluded via `.gitignore` and should be created locally before running the notebooks.

The expected input files are:

```text
data/
├── separated_actual_data_required/
│   ├── features/
│   │   ├── feature_names.txt
│   │   └── image_features.txt
│   └── labels/
│       ├── class_names.txt
│       └── image_labels.txt
└── processed/
    ├── X_train.csv
    ├── X_test.csv
    ├── y_train.csv
    └── y_test.csv
```

The extracted `data.zip` file provides the required raw data structure. The preparation notebook reads these local files and generates the processed CSVs used by the training notebook.

## Setup

### Windows

1. Install Python 3.10+ if needed.
2. Clone or open the project folder.
3. Extract `data.zip` into the root project directory.
4. Open the project in VS Code.
5. Open a terminal in the project root and run:

```bat
setup.bat
```

This creates a local `.venv` environment and installs dependencies from `requirements.txt`.

### Activate the environment manually

```bat
.venv\Scripts\activate
```

## Run the Project

### 1) Prepare the data

Open and run all cells in:

```text
notebooks/prepare_bird_species_data.ipynb
```

This notebook:

- reads the prepared feature/label files
- creates a binary matrix of shape `(11788, 312)`
- builds the target vector of species IDs
- performs a stratified 70/30 train/test split with `random_state=42`
- saves the processed files to `data/processed/`

Generated files:

- `data/processed/X_train.csv`
- `data/processed/X_test.csv`
- `data/processed/y_train.csv`
- `data/processed/y_test.csv`

### 2) Train and evaluate models

Open and run all cells in:

```text
notebooks/train_bird_species_models.ipynb
```

This notebook trains and compares:

- Bernoulli Naive Bayes
- Random Forest
- SVM with RBF kernel
- Logistic Regression

It also evaluates each model under:

- baseline settings
- PCA reduction
- chi-square feature selection
- PCA + feature selection

## Models and Results

The current recorded results are:

| Model | Training Accuracy | Test Accuracy | PCA Test Accuracy | Feature Selection Test Accuracy | PCA + Feature Selection Test Accuracy |
| --- | ---: | ---: | ---: | ---: | ---: |
| Naive Bayes | 58.61% | 45.60% | 38.85% | 35.93% | 30.76% |
| Random Forest | 99.89% | 48.12% | 39.02% | 36.56% | 35.79% |
| SVM (RBF) | 86.30% | 49.93% | 48.94% | 39.78% | 38.90% |
| Logistic Regression | 92.66% | 50.64% | 49.45% | 41.65% | 40.77% |

The best baseline performance in the saved results is from Logistic Regression, with about 50.64% test accuracy.

## Generated Output Files

After training, the project saves the following artifacts:

```text
results/
├── accuracy_comparison.png
├── classification_reports.txt
├── model_metrics.csv
└── model_results.csv
```

Model pickle files are also generated in `models/` locally and are not committed to Git.

## Dependencies

The project uses common scientific Python libraries, including:

- numpy
- pandas
- scikit-learn
- matplotlib
- seaborn
- jupyter

See `requirements.txt` for the complete dependency list.

## Notes

- The full dataset is not stored in the repository; it is expected to be available locally after extracting `data.zip`.
- The `data/` directory is intentionally excluded from Git tracking.
- Model files are generated locally and should be treated as trusted artifacts only.

## License

No explicit project license is currently included in the repository. If you plan to share this project publicly, consider adding an appropriate open-source license.
