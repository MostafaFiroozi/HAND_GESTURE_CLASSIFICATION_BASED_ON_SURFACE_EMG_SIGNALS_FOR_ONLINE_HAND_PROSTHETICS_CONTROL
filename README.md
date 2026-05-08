# Hand Gesture Classification from Surface EMG Signals

Real-time classification of 8 hand gestures using surface EMG signals, designed for online hand prosthetics control. Compares a CNN against 5 classical classifiers across multiple window sizes and stride configurations.

## Results

| Model | Test Accuracy | Inference Time |
|-------|-------------|----------------|
| CNN | **98.29%** | 0.072 ms/window |
| SVM | 97.68% | — |
| LDA | ~95% | — |
| Decision Tree | ~89% | — |

> Real-time constraint: total latency (window + inference) must be < 300 ms. CNN at 100 ms window achieves **100.07 ms total** — well within budget.

## Gestures

8 classes: Flexion, Extension, Supination, Pronation, Open Hand, Pinch, Lateral Pinch, Fist

## Dataset

- **Signal:** 10-channel surface EMG at 2048 Hz
- **Subject:** 1 subject, 3 day sessions, 3 rounds each
- **Windowing:** 7 window sizes (25–300 ms) × 4 stride lengths (25–100% of window)
- **Best config:** 100 ms window, 25% stride → 13,023 train / 8,346 test windows

## CNN Architecture

```
Input (204 × 10 × 1)
  → Conv2D(32, 3×3, stride 2×1) + MaxPool(3×1) + Dropout(0.5)
  → Conv2D(64, 3×1, stride 2×1) + MaxPool(2×1) + Dropout(0.5)
  → Conv2D(32, 2×1, stride 1×1) + MaxPool(2×1)
  → Flatten → Dense(64) → Dense(8, softmax)
Total params: 93,160
```

Optimizer: Adam (lr=0.001), 30 epochs, categorical cross-entropy loss.

## Classical Classifiers

Features extracted per window per channel (4 time-domain features):
- **MAV** — Mean Absolute Value
- **WL** — Waveform Length
- **ZC** — Zero Crossings
- **SSC** — Slope Sign Changes

Classifiers evaluated: SVM, LDA, Decision Tree, and 2 others.

## Key Finding

Accuracy saturates above 100 ms window size. CNN and SVM reach similar accuracy, but CNN inference time scales with window size while SVM computational time is stride-independent. At 100 ms / 25% stride, CNN achieves the best accuracy–latency trade-off for a real-time prosthetics application.

## Files

```
Final/
├── CNN_Final.ipynb                        # CNN training and evaluation
├── CNN_WITH_DATA_AUGMENTATION.ipynb       # CNN with augmentation experiments
├── Final_CLASSIC_CLASSIFIERS_4TDFs.ipynb  # SVM, LDA, DT with 4 TDFs
├── window_column.m                        # MATLAB windowing script
└── FINAL DATA AND GRAPHS.xlsx             # Results summary
```

## Stack

Python · TensorFlow/Keras · scikit-learn · NumPy · pandas · seaborn · MATLAB
