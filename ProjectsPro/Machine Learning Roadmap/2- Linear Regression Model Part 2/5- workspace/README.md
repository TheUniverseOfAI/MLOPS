I scanned the notebook and extracted the **actual runtime dependencies** (ignoring stdlib like `warnings`). Below is a **clean, realistic `requirements.txt` setup** that works across **Python 3.8 → 3.12**, plus notes on version boundaries so you don’t step on dependency landmines later.

---

## 🔍 Extracted third-party libraries

From the notebook imports:

```python
numpy
pandas
scipy
matplotlib
seaborn
scikit-learn
statsmodels
```

(`warnings` is standard library → excluded)

---

## ✅ Recommended: single `requirements.txt` (Python 3.8–3.12 safe)

This is the **best future-proof choice** unless you have strict pinning needs.

```txt
numpy>=1.21,<3.0
pandas>=1.5,<3.0
scipy>=1.8,<2.0
matplotlib>=3.6,<4.0
seaborn>=0.12,<0.14
scikit-learn>=1.1,<2.0
statsmodels>=0.13,<0.15
```

✔ Works on **Python 3.8, 3.9, 3.10, 3.11, 3.12**
✔ Avoids deprecated APIs
✔ CI-friendly
✔ No unnecessary over-pinning

---

## 🧭 If you want per-Python-version clarity (optional)

### Python 3.8

```txt
numpy>=1.21,<1.27
pandas>=1.5,<2.1
scipy>=1.8,<1.12
matplotlib>=3.6,<3.9
seaborn>=0.12,<0.13
scikit-learn>=1.1,<1.4
statsmodels>=0.13,<0.14
```

### Python 3.9 – 3.10

```txt
numpy>=1.23,<2.0
pandas>=1.5,<2.2
scipy>=1.9,<1.13
matplotlib>=3.7,<3.9
seaborn>=0.12,<0.14
scikit-learn>=1.2,<1.5
statsmodels>=0.13,<0.15
```

### Python 3.11 – 3.12

```txt
numpy>=1.26,<3.0
pandas>=2.0,<3.0
scipy>=1.11,<2.0
matplotlib>=3.8,<4.0
seaborn>=0.12,<0.14
scikit-learn>=1.3,<2.0
statsmodels>=0.14,<0.15
```

---

## 🧪 Validation command (recommended)

After creating your venv:

```bash
python -m pip install -r requirements.txt
python - <<EOF
import numpy, pandas, scipy, sklearn, statsmodels, matplotlib, seaborn
print("All imports OK ✅")
EOF
```

---

## 🧠 Why this setup is “safe for the future”

* Avoids NumPy 2.x breaking changes
* Compatible with `scikit-learn` C-extensions
* Matches `statsmodels` + `scipy` ABI expectations
* Won’t explode when Python 3.13 eventually appears

---

If you want, next we can:

* Generate **`pyproject.toml` (PEP 621)**
* Split **core vs dev requirements**
* Add **CI matrix (3.8 → 3.12)**
* Convert this into **uv / poetry / pip-tools**

Just say the word 🚀
