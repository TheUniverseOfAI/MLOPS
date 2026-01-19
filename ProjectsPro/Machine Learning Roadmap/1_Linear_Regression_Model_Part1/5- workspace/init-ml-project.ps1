param(
  [string]$ProjectName = "ml-project-example"
)

$root = Join-Path (Get-Location) $ProjectName

# Create folders
$dirs = @(
  "config",
  "data/01-raw",
  "data/02-preprocessed",
  "data/03-features",
  "data/04-predictions",
  "entrypoint",
  "notebooks",
  "src/pipelines",
  "tests"
)

foreach ($d in $dirs) {
  New-Item -ItemType Directory -Force -Path (Join-Path $root $d) | Out-Null
}

# Helper to write files
function Write-File($path, $content) {
  $full = Join-Path $root $path
  $dir = Split-Path $full
  if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  Set-Content -Path $full -Value $content -Encoding UTF8
}

# =========================
# Config files
# =========================
Write-File "config/local.yaml" @"
env: local
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
"@

Write-File "config/prod.yaml" @"
env: prod
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
"@

# =========================
# Entrypoints
# =========================
Write-File "entrypoint/train.py" @"
from src.pipelines.training_pipeline import run_training

if __name__ == "__main__":
    run_training()
"@

Write-File "entrypoint/inference.py" @"
from src.pipelines.inference_pipeline import run_inference

if __name__ == "__main__":
    run_inference()
"@

# =========================
# src package
# =========================
Write-File "src/__init__.py" @"
"@

Write-File "src/utils.py" @"
from pathlib import Path
import yaml

def load_config(path: str):
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def ensure_dir(p: str):
    Path(p).mkdir(parents=True, exist_ok=True)
"@

Write-File "src/pipelines/__init__.py" @"
"@

Write-File "src/pipelines/feature_eng_pipeline.py" @"
def run_feature_engineering(cfg: dict):
    # TODO: implement
    # - read preprocessed data
    # - generate features
    # - write to cfg['paths']['features']
    print(""[feature_eng] ok"")
"@

Write-File "src/pipelines/training_pipeline.py" @"
from src.utils import load_config, ensure_dir
from src.pipelines.feature_eng_pipeline import run_feature_engineering

def run_training(config_path: str = ""config/local.yaml""):
    cfg = load_config(config_path)

    # Ensure output dirs
    ensure_dir(cfg["paths"]["preprocessed"])
    ensure_dir(cfg["paths"]["features"])

    # TODO: preprocess -> features -> train -> save model
    run_feature_engineering(cfg)
    print(""[train] ok"", ""env="", cfg.get(""env""))
"@

Write-File "src/pipelines/inference_pipeline.py" @"
from src.utils import load_config, ensure_dir

def run_inference(config_path: str = ""config/local.yaml""):
    cfg = load_config(config_path)

    ensure_dir(cfg["paths"]["predictions"])

    # TODO:
    # - load model
    # - load features
    # - generate predictions
    print(""[inference] ok"", ""env="", cfg.get(""env""))
"@

# =========================
# tests
# =========================
Write-File "tests/__init__.py" @"
"@

Write-File "tests/test_training.py" @"
def test_smoke():
    assert 1 + 1 == 2
"@

# =========================
# Environment & deps
# =========================
Write-File "requirements-dev.txt" @"
pytest
pyyaml
black
ruff
"@

Write-File "requirements-prod.txt" @"
numpy
pandas
scikit-learn
pyyaml
"@

Write-File "env.yaml" @"
name: ml-project
channels:
  - conda-forge
dependencies:
  - python=3.11
  - pip
  - pip:
      - -r requirements-prod.txt
      - -r requirements-dev.txt
"@

Write-File "env-dev.yaml" @"
name: ml-project-dev
channels:
  - conda-forge
dependencies:
  - python=3.11
  - pip
  - pip:
      - -r requirements-prod.txt
      - -r requirements-dev.txt
"@

# =========================
# Docker + CI
# =========================
Write-File "Dockerfile" @"
FROM python:3.11-slim

WORKDIR /app
COPY requirements-prod.txt requirements-prod.txt
RUN pip install --no-cache-dir -r requirements-prod.txt

COPY . .
CMD [""python"", ""entrypoint/train.py""]
"@

Write-File "docker-compose.yml" @"
services:
  mlapp:
    build: .
    volumes:
      - .:/app
    command: python entrypoint/train.py
"@

Write-File ".gitlab-ci.yml" @"
stages:
  - test

test:
  image: python:3.11
  script:
    - pip install -r requirements-dev.txt
    - pytest -q
"@

Write-File "Makefile" @"
.PHONY: test format lint

test:
\tpytest -q

format:
\tblack .

lint:
\truff check .
"@

# =========================
# README + .gitignore
# =========================
Write-File "README.md" @"
# $ProjectName

Production-ready ML project layout:
- config-driven pipelines
- clear data lifecycle
- clean entrypoints
- modular pipelines under src/
- notebooks kept separate
- tests + CI + Docker

## Run (example)
\`\`\`bash
python entrypoint/train.py
python entrypoint/inference.py
\`\`\`

## Config
- config/local.yaml
- config/prod.yaml
"@

Write-File ".gitignore" @"
.venv/
__pycache__/
.ipynb_checkpoints/
*.pyc
*.pkl
*.joblib
data/02-preprocessed/
data/03-features/
data/04-predictions/
"@

Write-Host "✅ Created project structure at: $root"
Write-Host "Next:"
Write-Host "  cd $ProjectName"
Write-Host "  uv venv --python 3.11 .venv"
Write-Host "  uv pip install -r requirements-prod.txt"
Write-Host "  uv pip install -r requirements-dev.txt"


#.\init-ml-project.ps1 -ProjectName "ml-project-example"
