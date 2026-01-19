import os
import sys
from pathlib import Path

TEMPLATE_FILES = {
    "config/local.yaml": """env: local
paths:
  data_dir: data
  raw: data/01-raw
  preprocessed: data/02-preprocessed
  features: data/03-features
  predictions: data/04-predictions
training:
  random_seed: 42
  test_size: 0.2
model:
  name: baseline
""",
    "config/prod.yaml": """env: prod
paths:
  data_dir: data
  raw: data/01-raw
  preprocessed: data/02-preprocessed
  features: data/03-features
  predictions: data/04-predictions
training:
  random_seed: 42
  test_size: 0.2
model:
  name: production
""",
    "entrypoint/train.py": """from src.pipelines.training_pipeline import run_training

if __name__ == "__main__":
    run_training()
""",
    "entrypoint/inference.py": """from src.pipelines.inference_pipeline import run_inference

if __name__ == "__main__":
    run_inference()
""",
    "src/__init__.py": "",
    "src/utils.py": """from pathlib import Path
import yaml

def load_config(path: str):
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def ensure_dir(p: str):
    Path(p).mkdir(parents=True, exist_ok=True)
""",
    "src/pipelines/__init__.py": "",
    "src/pipelines/feature_eng_pipeline.py": """def run_feature_engineering(cfg: dict):
    # TODO: implement feature engineering
    print("[feature_eng] ok")
""",
    "src/pipelines/training_pipeline.py": """from src.utils import load_config, ensure_dir
from src.pipelines.feature_eng_pipeline import run_feature_engineering

def run_training(config_path: str = "config/local.yaml"):
    cfg = load_config(config_path)
    ensure_dir(cfg["paths"]["preprocessed"])
    ensure_dir(cfg["paths"]["features"])
    run_feature_engineering(cfg)
    print("[train] ok", "env=", cfg.get("env"))
""",
    "src/pipelines/inference_pipeline.py": """from src.utils import load_config, ensure_dir

def run_inference(config_path: str = "config/local.yaml"):
    cfg = load_config(config_path)
    ensure_dir(cfg["paths"]["predictions"])
    print("[inference] ok", "env=", cfg.get("env"))
""",
    "tests/__init__.py": "",
    "tests/test_training.py": """def test_smoke():
    assert 1 + 1 == 2
""",
    "requirements-dev.txt": """pytest
pyyaml
black
ruff
""",
    "requirements-prod.txt": """numpy
pandas
scikit-learn
pyyaml
""",
    "Dockerfile": """FROM python:3.11-slim
WORKDIR /app
COPY requirements-prod.txt requirements-prod.txt
RUN pip install --no-cache-dir -r requirements-prod.txt
COPY . .
CMD ["python", "entrypoint/train.py"]
""",
    "docker-compose.yml": """services:
  mlapp:
    build: .
    volumes:
      - .:/app
    command: python entrypoint/train.py
""",
    ".gitlab-ci.yml": """stages:
  - test

test:
  image: python:3.11
  script:
    - pip install -r requirements-dev.txt
    - pytest -q
""",
    "Makefile": """.PHONY: test format lint

test:
\tpytest -q

format:
\tblack .

lint:
\truff check .
""",
    "README.md": """# ML Project

Production-ready ML repo layout.

## Run
python entrypoint/train.py
python entrypoint/inference.py
""",
    ".gitignore": """.venv/
__pycache__/
.ipynb_checkpoints/
*.pyc
*.pkl
*.joblib
data/02-preprocessed/
data/03-features/
data/04-predictions/
""",
}

DIRS = [
    "config",
    "data/01-raw",
    "data/02-preprocessed",
    "data/03-features",
    "data/04-predictions",
    "entrypoint",
    "notebooks",
    "src/pipelines",
    "tests",
    "models",
    "reports/figures",
    "outputs/logs",
    "docs",
]

def write_file(root: Path, rel: str, content: str) -> None:
    p = root / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content, encoding="utf-8")

def main():
    name = sys.argv[1] if len(sys.argv) > 1 else "ml-project-example"
    root = Path.cwd() / name
    root.mkdir(parents=True, exist_ok=True)

    for d in DIRS:
        (root / d).mkdir(parents=True, exist_ok=True)

    for rel, content in TEMPLATE_FILES.items():
        write_file(root, rel, content)

    print(f"✅ Created project structure at: {root}")

if __name__ == "__main__":
    main()
