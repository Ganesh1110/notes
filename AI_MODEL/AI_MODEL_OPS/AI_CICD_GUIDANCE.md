# CI/CD Pipeline for Model Quantization & Deployment

## 1. Overview

Automate the model download → convert → quantize → benchmark → publish pipeline. This enables reproducible builds, regression detection, and streamlined releases.

## 2. Pipeline Architecture

```
                         ┌──────────────┐
                         │  Trigger      │
                         │  (webhook/manual) │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │  1. Validate │
                         │  Repository  │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │  2. Download │
                         │  Model       │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │  3. Convert  │
                         │  to FP16 GGUF│
                         └──────┬───────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
             ┌──────▼───────┐       ┌──────▼───────┐
             │ 4a. Quantize  │       │ 4b. Quantize  │
             │ Q4_K_M       │       │ Q8_0         │
             └──────┬───────┘       └──────┬───────┘
                    │                       │
             ┌──────▼───────┐       ┌──────▼───────┐
             │ 5a. Benchmark │       │ 5b. Benchmark │
             │ + Validate   │       │ + Validate   │
             └──────┬───────┘       └──────┬───────┘
                    │                       │
                    └───────────┬───────────┘
                                │
                         ┌──────▼───────┐
                         │  6. Publish  │
                         │  GGUF to HF  │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │  7. Release  │
                         │  (GitHub)    │
                         └──────────────┘
```

## 3. GitHub Actions Workflow

### Full Pipeline Workflow

Save as `.github/workflows/quantize-model.yml`:

```yaml
name: Quantize & Release Model

on:
  workflow_dispatch:
    inputs:
      model_id:
        description: 'Hugging Face model ID (e.g., meta-llama/Llama-3.1-8B)'
        required: true
      quant_types:
        description: 'Quantization types (space-separated)'
        required: false
        default: 'Q4_K_M Q5_K_M Q8_0'
      hf_token:
        description: 'Hugging Face token for gated models'
        required: false
      upload_to_hf:
        description: 'Upload GGUF to Hugging Face? (true/false)'
        required: false
        default: 'false'
      hf_upload_repo:
        description: 'HF repo to upload to (e.g., myuser/my-model-GGUF)'
        required: false

env:
  LLAMA_CPP_DIR: llama.cpp
  MODEL_DIR: models
  OUTPUT_DIR: output
  QUANT_TYPES: ${{ github.event.inputs.quant_types || 'Q4_K_M Q5_K_M Q8_0' }}

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - name: Validate Repository
        run: |
          pip install huggingface-hub
          python scripts/validate_hf_repo.py ${{ github.event.inputs.model_id }}

  quantize:
    needs: validate
    runs-on: [self-hosted, gpu, large]
    timeout-minutes: 180
    steps:
      - uses: actions/checkout@v4

      - name: Setup environment
        run: |
          sudo apt-get update
          sudo apt-get install -y cmake build-essential git-lfs
          git lfs install

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Build llama.cpp
        run: |
          git clone https://github.com/ggml-org/llama.cpp ${{ env.LLAMA_CPP_DIR }}
          cd ${{ env.LLAMA_CPP_DIR }}
          cmake -B build -DLLAMA_CUDA=ON
          cmake --build build --config Release -j

      - name: Download model
        run: |
          mkdir -p ${{ env.MODEL_DIR }}
          huggingface-cli download ${{ github.event.inputs.model_id }} \
            --local-dir ${{ env.MODEL_DIR }}/model \
            --local-dir-use-symlinks False \
            --resume-download
        env:
          HF_TOKEN: ${{ secrets.HF_TOKEN }}

      - name: Convert to FP16 GGUF
        run: |
          mkdir -p ${{ env.OUTPUT_DIR }}
          MODEL_NAME=$(basename ${{ github.event.inputs.model_id }})
          python ${{ env.LLAMA_CPP_DIR }}/convert_hf_to_gguf.py \
            ${{ env.MODEL_DIR }}/model \
            --outfile ${{ env.OUTPUT_DIR }}/${MODEL_NAME}.f16.gguf \
            --outtype f16

      - name: Verify FP16 conversion
        run: |
          MODEL_NAME=$(basename ${{ github.event.inputs.model_id }})
          ${{ env.LLAMA_CPP_DIR }}/build/bin/llama-cli \
            -m ${{ env.OUTPUT_DIR }}/${MODEL_NAME}.f16.gguf \
            -p "Hello" -n 10 --seed 42 -ngl 99

      - name: Quantize
        run: |
          MODEL_NAME=$(basename ${{ github.event.inputs.model_id }})
          FP16_FILE=${{ env.OUTPUT_DIR }}/${MODEL_NAME}.f16.gguf
          for QUANT in ${{ env.QUANT_TYPES }}; do
            QUANT_FILE=${{ env.OUTPUT_DIR }}/${MODEL_NAME}.${QUANT,,}.gguf
            echo "Quantizing to ${QUANT}..."
            ${{ env.LLAMA_CPP_DIR }}/build/bin/llama-quantize \
              "$FP16_FILE" "$QUANT_FILE" "${QUANT,,}"
            # Verify
            ${{ env.LLAMA_CPP_DIR }}/build/bin/llama-cli \
              -m "$QUANT_FILE" -p "Hello" -n 10 --seed 42 -ngl 99
          done

      - name: Benchmark
        run: |
          MODEL_NAME=$(basename ${{ github.event.inputs.model_id }})
          for GGUF in ${{ env.OUTPUT_DIR }}/${MODEL_NAME}.*.gguf; do
            echo "=== Benchmarking $(basename $GGUF) ==="
            ${{ env.LLAMA_CPP_DIR }}/build/bin/llama-bench \
              -m "$GGUF" -p 512 -n 256 -ngl 99 -r 3
          done

      - name: Upload to Hugging Face
        if: github.event.inputs.upload_to_hf == 'true'
        run: |
          pip install huggingface-hub
          MODEL_NAME=$(basename ${{ github.event.inputs.model_id }})
          HF_UPLOAD_REPO=${{ github.event.inputs.hf_upload_repo }}
          huggingface-cli repo create "$HF_UPLOAD_REPO" --type model --yes || true
          for GGUF in ${{ env.OUTPUT_DIR }}/${MODEL_NAME}.*.gguf; do
            huggingface-cli upload "$HF_UPLOAD_REPO" "$GGUF" \
              --repo-type model
          done
        env:
          HF_TOKEN: ${{ secrets.HF_TOKEN }}

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: quantized-models
          path: ${{ env.OUTPUT_DIR }}/*.gguf
          retention-days: 7

      - name: Cleanup
        if: always()
        run: |
          rm -rf ${{ env.MODEL_DIR }} ${{ env.OUTPUT_DIR }}
```

### Trigger on New Release of a Model

```yaml
name: Auto-Quantize on Upstream Release

on:
  schedule:
    - cron: '0 6 * * 1'  # Every Monday
  workflow_dispatch:
    inputs:
      models:
        description: 'Models to check (JSON array)'
        default: '["meta-llama/Llama-3.1-8B", "Qwen/Qwen2.5-7B"]'

jobs:
  check-and-quantize:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check for new model versions
        run: |
          pip install huggingface-hub
          python scripts/check_model_updates.py
```

## 4. Runner Requirements

| Job | Runner Type | Min Specs | Approx Cost |
|-----|-------------|-----------|-------------|
| validate | ubuntu-latest | 2 CPU, 4GB RAM | Free |
| quantize (7B) | GPU, 16GB VRAM | 8 CPU, 32GB RAM, RTX 3090 | $0.50-1.00/hr |
| quantize (70B) | GPU, 48GB+ VRAM | 16 CPU, 128GB RAM, A6000 | $2-5/hr |
| quantize (405B) | Multi-GPU | 32 CPU, 512GB RAM, 8x A100 | $20-50/hr |

For self-hosted runners, ensure:
- Docker installed with NVIDIA container toolkit
- `git lfs` installed globally
- CUDA Toolkit 12.x installed
- 200GB+ free disk for 70B models
- `nvidia-smi` accessible from the runner user

## 5. Script: Check Model Updates

Save as `scripts/check_model_updates.py`:

```python
#!/usr/bin/env python3
"""Check if model repositories have new commits since last build."""

import json
import os
import hashlib
from huggingface_hub import HfApi

CACHE_FILE = ".model_versions.json"
MODELS = json.loads(os.environ.get("INPUT_MODELS", '["meta-llama/Llama-3.1-8B"]'))

def get_model_hash(repo_id: str) -> str:
    api = HfApi()
    commits = api.list_repo_commits(repo_id)
    if commits:
        return commits[0].sha
    return ""

def main():
    cache = {}
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE) as f:
            cache = json.load(f)

    changed = []
    for model in MODELS:
        current_hash = get_model_hash(model)
        cached_hash = cache.get(model)
        if current_hash and current_hash != cached_hash:
            changed.append(model)
        cache[model] = current_hash

    with open(CACHE_FILE, "w") as f:
        json.dump(cache, f, indent=2)

    print(f"Changed models: {changed}")
    if changed:
        with open(os.environ.get("GITHUB_OUTPUT"), "a") as f:
            print(f"changed_models={json.dumps(changed)}", file=f)

if __name__ == "__main__":
    main()
```

## 6. Quality Gate Configuration

### Benchmark Regression Detection

```yaml
- name: Check benchmark regression
  run: |
    PREVIOUS=$(cat .benchmark_baseline.json 2>/dev/null || echo "{}")
    CURRENT=$(./benchmark.sh 2>&1 | tail -1)
    python scripts/check_regression.py \
      --baseline "$PREVIOUS" \
      --current "$CURRENT" \
      --threshold 0.10  # Fail if 10% slower
```

Save as `scripts/check_regression.py`:

```python
#!/usr/bin/env python3
"""Compare current benchmark against baseline and fail if regressed."""

import json
import sys

def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--current", required=True)
    parser.add_argument("--threshold", type=float, default=0.10)
    args = parser.parse_args()

    baseline = json.loads(args.baseline) if args.baseline else {}
    current = json.loads(args.current)

    regressions = []
    for metric in ["gen_tps", "prompt_tps"]:
        if metric in baseline and metric in current:
            old = baseline[metric]
            new = current[metric]
            if old > 0 and (old - new) / old > args.threshold:
                regressions.append(f"{metric}: {old:.1f} → {new:.1f} ({((old-new)/old*100):.1f}% drop)")

    if regressions:
        print("❌ Regression detected:")
        for r in regressions:
            print(f"  {r}")
        sys.exit(1)
    else:
        print("✅ No significant regression")

if __name__ == "__main__":
    main()
```

## 7. Hugging Face Upload Automation

### Publishing to a GGUF Collection

```python
#!/usr/bin/env python3
"""Upload quantized models to a Hugging Face repository."""

from huggingface_hub import HfApi, create_repo
from pathlib import Path
import os

REPO_ID = os.environ.get("HF_UPLOAD_REPO", "myuser/my-model-GGUF")
MODEL_DIR = Path(os.environ.get("OUTPUT_DIR", "./output"))

api = HfApi()

# Create repo if it doesn't exist
create_repo(REPO_ID, repo_type="model", exist_ok=True)

# Upload all GGUF files
for gguf_file in MODEL_DIR.glob("*.gguf"):
    print(f"Uploading {gguf_file.name}...")
    api.upload_file(
        path_or_fileobj=str(gguf_file),
        path_in_repo=gguf_file.name,
        repo_id=REPO_ID,
        repo_type="model",
    )

# Upload README with model card
readme = f"""---
license: mit
library_name: gguf
---

# Quantized {REPO_ID.split('/')[-1]}

Automatically quantized from Hugging Face.
"""
api.upload_file(
    path_or_fileobj=readme.encode(),
    path_in_repo="README.md",
    repo_id=REPO_ID,
    repo_type="model",
)

print(f"Upload complete: https://huggingface.co/{REPO_ID}")
```

## 8. Local Automation (No CI)

For local use without GitHub Actions:

```bash
#!/bin/bash
set -euo pipefail

MODEL_ID="${1:?Usage: $0 <model_id> [quant_types]}"
QUANT_TYPES="${2:-Q4_K_M Q5_K_M Q8_0}"
MODEL_NAME=$(basename "$MODEL_ID")
DATE=$(date +%Y%m%d)

WORK_DIR="./build-${MODEL_NAME}-${DATE}"
OUTPUT="./gguf/${MODEL_NAME}"

mkdir -p "$OUTPUT" "$WORK_DIR"

echo "[1/4] Downloading $MODEL_ID"
huggingface-cli download "$MODEL_ID" \
    --local-dir "$WORK_DIR/model" \
    --resume-download

echo "[2/4] Converting to FP16"
python llama.cpp/convert_hf_to_gguf.py "$WORK_DIR/model" \
    --outfile "$OUTPUT/$MODEL_NAME.f16.gguf"

echo "[3/4] Quantizing"
for QUANT in $QUANT_TYPES; do
    echo "  → $QUANT"
    ./llama.cpp/build/bin/llama-quantize \
        "$OUTPUT/$MODEL_NAME.f16.gguf" \
        "$OUTPUT/$MODEL_NAME.${QUANT,,}.gguf" \
        "${QUANT,,}"
done

echo "[4/4] Benchmarking"
for GGUF in "$OUTPUT"/*.gguf; do
    echo "=== $(basename $GGUF) ==="
    ./llama.cpp/build/bin/llama-bench -m "$GGUF" -p 512 -n 256 -ngl 99
done

echo "Done! Models in: $OUTPUT"
rm -rf "$WORK_DIR"
```

## 9. Best Practices

- **Cache the raw model** between pipeline runs to avoid re-downloading
- **Use a lock file** to prevent concurrent quantization of the same model
- **Separate FP16 GGUF as an artifact** so you can re-quantize without re-converting
- **Tag releases** with model name + quant type + date (e.g., `llama-3.1-8b-Q4_K_M-2025-03-01`)
- **Store benchmark baselines** in the repo to detect regressions
- **Set disk space alerts** — 70B conversion needs 200 GB+ free
- **Use spot/preemptible instances** for cost savings (add checkpoint/resume logic)
- **Sign GGUF files** with GPG for supply chain security in production
