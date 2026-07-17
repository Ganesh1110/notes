# Repository Validation Script

## 1. Overview

Before downloading or converting a model, validate that the Hugging Face repository is complete and compatible with your target format. This script checks all critical files and reports issues early.

## 2. Validation Script

Save as `validate_hf_repo.py` and run against any Hugging Face model directory:

```python
#!/usr/bin/env python3
"""validate_hf_repo.py — Validate a Hugging Face model repository before conversion.

Usage:
    python validate_hf_repo.py /path/to/model/dir
    python validate_hf_repo.py meta-llama/Llama-3.1-8B  (downloads first)
"""

import json
import os
import sys
import math
from pathlib import Path


def check_repo(repo_path: str) -> dict:
    results = {
        "repository": repo_path,
        "status": "PASS",
        "checks": [],
        "warnings": [],
        "errors": [],
    }

    repo = Path(repo_path)
    if not repo.exists():
        results["status"] = "FAIL"
        results["errors"].append(f"Path does not exist: {repo_path}")
        return results

    def _check(label, condition, details=""):
        if condition:
            results["checks"].append({"check": label, "status": "✅", "details": details})
        else:
            results["checks"].append({"check": label, "status": "❌", "details": details})
            results["errors"].append(f"Missing or invalid: {label}")
            results["status"] = "FAIL"

    def _warn(label, details):
        results["warnings"].append(f"{label}: {details}")
        results["checks"].append({"check": label, "status": "⚠️", "details": details})

    # ── Required files ──
    _check("config.json exists", (repo / "config.json").exists())

    # ── Architecture ──
    if (repo / "config.json").exists():
        with open(repo / "config.json") as f:
            config = json.load(f)
        archs = config.get("architectures", [])
        if archs:
            results["architecture"] = archs[0]
            _check(f"Architecture detected: {archs[0]}", True)
        else:
            _warn("Architecture", "No 'architectures' field in config.json")

        # Parameter count
        params = None
        for key in ["num_parameters", "num_params", "parameter_count"]:
            if key in config:
                params = config[key]
                break
        if params:
            billions = params / 1e9
            results["parameters"] = f"{billions:.1f}B"
            _check(f"Parameter count: {results['parameters']}", True)
        else:
            _warn("Parameters", "Could not determine parameter count from config.json")

        # Context length
        ctx = config.get("max_position_embeddings") or config.get("max_sequence_length")
        if ctx:
            results["context_length"] = ctx
            _check(f"Context length: {ctx}", True)
        else:
            _warn("Context length", "Not found in config.json")

    # ── Tokenizer files ──
    tokenizer_variants = [
        "tokenizer.json",
        "tokenizer.model",
        "vocab.json",
        "merges.txt",
        "tokenizer_config.json",
    ]
    found_tokenizers = [f for f in tokenizer_variants if (repo / f).exists()]
    _check(f"Tokenizer files: {', '.join(found_tokenizers) or 'NONE'}", len(found_tokenizers) > 0)

    _check("tokenizer_config.json exists", (repo / "tokenizer_config.json").exists())

    tokenizer_config_path = repo / "tokenizer_config.json"
    if tokenizer_config_path.exists():
        with open(tokenizer_config_path) as f:
            tc = json.load(f)
        if "chat_template" in tc and tc["chat_template"]:
            results["chat_template"] = "Present"
        else:
            _warn("Chat template", "No chat_template in tokenizer_config.json")

    # ── Generation config ──
    _check("generation_config.json exists", (repo / "generation_config.json").exists())

    # ── Weight files ──
    safetensors = list(repo.glob("*.safetensors"))
    pytorch_bins = list(repo.glob("pytorch_model*.bin"))
    has_index = (repo / "model.safetensors.index.json").exists()
    has_safetensors = len(safetensors) > 0
    has_bins = len(pytorch_bins) > 0

    if has_safetensors:
        total_size_gb = sum(f.stat().st_size for f in safetensors if f.is_file()) / (1024**3)
        _check(f"Weight files: {len(safetensors)} .safetensors files ({total_size_gb:.1f} GB)", True)
        if len(safetensors) > 1 and not has_index:
            _warn("Multi-shard index", "Multiple .safetensors files found but no model.safetensors.index.json")
        results["weight_format"] = "safetensors"
    elif has_bins:
        total_size_gb = sum(f.stat().st_size for f in pytorch_bins if f.is_file()) / (1024**3)
        _check(f"Weight files: {len(pytorch_bins)} .bin files ({total_size_gb:.1f} GB)", True)
        _warn("Weight format", "Using PyTorch .bin format — consider safetensors for faster loading")
        results["weight_format"] = "pytorch"
    else:
        _check("Weight files found", False)
        results["weight_format"] = "none"

    # ── Verification ──
    if (repo / "sha256sums.txt").exists():
        _check("SHA256 checksums present", True)
    elif (repo / "md5sums.txt").exists():
        _check("MD5 checksums present", True)

    return results


def print_report(results: dict):
    print(f"\n{'='*60}")
    print(f"  Repository Validation Report")
    print(f"{'='*60}")
    print(f"  Repository:  {results['repository']}")
    print(f"  Status:      {'✅ PASS' if results['status'] == 'PASS' else '❌ FAIL'}")
    if results.get("architecture"):
        print(f"  Architecture: {results['architecture']}")
    if results.get("parameters"):
        print(f"  Parameters:   {results['parameters']}")
    if results.get("context_length"):
        print(f"  Context:      {results['context_length']} tokens")
    if results.get("weight_format"):
        print(f"  Weights:      {results['weight_format']}")
    if results.get("chat_template"):
        print(f"  Chat Tmpl:    {results['chat_template']}")
    print(f"{'='*60}")
    print()

    if results["errors"]:
        print("  ❌ ERRORS:")
        for err in results["errors"]:
            print(f"    • {err}")
        print()

    if results["warnings"]:
        print("  ⚠️  WARNINGS:")
        for warn in results["warnings"]:
            print(f"    • {warn}")
        print()

    print("  Checks:")
    for c in results["checks"]:
        print(f"    {c['status']} {c['check']}")

    print(f"\n{'='*60}")
    if results["status"] == "PASS":
        print("  ✅ Repository is valid and ready for conversion.")
    else:
        print("  ❌ Repository has issues. Fix errors before proceeding.")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate_hf_repo.py <path_or_repo_id>")
        sys.exit(1)

    repo_input = sys.argv[1]

    # If it looks like a Hugging Face repo ID, try to download it
    if "/" in repo_input and not Path(repo_input).exists():
        print(f"Repository path not found locally. Attempting to download from Hugging Face...")
        try:
            from huggingface_hub import snapshot_download
            local_path = snapshot_download(
                repo_id=repo_input,
                local_dir_use_symlinks=False,
                resume_download=True,
            )
            print(f"Downloaded to: {local_path}")
            repo_input = local_path
        except ImportError:
            print("ERROR: huggingface_hub not installed. Install with: pip install huggingface-hub")
            sys.exit(1)
        except Exception as e:
            print(f"ERROR: Failed to download: {e}")
            sys.exit(1)

    report = check_repo(repo_input)
    print_report(report)

    if report["status"] != "PASS":
        sys.exit(1)
```

## 3. Usage Examples

```bash
# Validate a local model directory
python validate_hf_repo.py ./models/Llama-3.1-8B

# Validate by Hugging Face repo ID (auto-downloads)
python validate_hf_repo.py meta-llama/Llama-3.1-8B

# Integrate into conversion script
python validate_hf_repo.py ./model && python convert_hf_to_gguf.py ./model
```

## 4. Expected Output

```
============================================================
  Repository Validation Report
============================================================
  Repository:  ./models/Llama-3.1-8B
  Status:      ✅ PASS
  Architecture: LlamaForCausalLM
  Parameters:   8.0B
  Context:      8192 tokens
  Weights:      safetensors
  Chat Tmpl:    Present
============================================================

  Checks:
    ✅ config.json exists
    ✅ Architecture detected: LlamaForCausalLM
    ✅ Parameter count: 8.0B
    ✅ Context length: 8192
    ✅ Tokenizer files: tokenizer.json, tokenizer_config.json
    ✅ tokenizer_config.json exists
    ✅ generation_config.json exists
    ✅ Weight files: 2 .safetensors files (15.8 GB)

============================================================
  ✅ Repository is valid and ready for conversion.
============================================================
```

## 5. Integration with Pipeline

Add to your conversion script:

```python
from validate_hf_repo import check_repo, print_report

report = check_repo(model_path)
print_report(report)
if report["status"] != "PASS":
    sys.exit(1)
```
