# AI Model Quantization -- Complete Guide

## 1. Overview

Quantization is the process of reducing the numerical precision of a model's weights and activations from the standard 16-bit floating point (FP16) to lower bit-widths such as 8-bit, 4-bit, or even 2-bit integers. This reduction dramatically decreases memory footprint and accelerates inference at the cost of a small, measurable degradation in output quality.

### Why Quantize

- **Reduced memory**: A 70B parameter model at FP16 requires ~140 GB of memory. At 4-bit, the same model requires ~35 GB, fitting on a single consumer GPU.
- **Faster inference**: Lower precision enables higher arithmetic throughput and reduced memory bandwidth pressure, yielding 2-5x speed improvements on compatible hardware.
- **Lower cost**: Smaller memory and compute requirements reduce cloud instance costs and enable local deployment on edge devices.

### Quality Trade-offs

Quantization introduces information loss. The key insight is that neural network weights exhibit significant redundancy -- not all bits carry equal importance. Modern quantization methods preserve the most important information while discarding noise. Typical perplexity increases range from <0.1 (Q8_0) to ~2-4 (Q2_K) on standard benchmarks.

### Supported Formats

| Format | Tool | Primary Use Case | Runtime |
|--------|------|-----------------|---------|
| GGUF | llama.cpp | Local / edge inference | llama.cpp, Ollama, LM Studio |
| AWQ | autoawq | Production serving | vLLM, TGI, SGLang |
| GPTQ | auto-gptq | Production serving | vLLM, TGI, ExLlama |
| EXL2 | exllamav2 | High-throughput inference | ExLlamaV2 |
| NF4 / FP4 | bitsandbytes | Fine-tuning (QLoRA) | Transformers, PEFT |
| FP8 | TensorRT-LLM | H100 data center | TensorRT-LLM |

### When to Use Each Format

```
Is the model for local / personal use?
  Yes --> GGUF (Ollama, llama.cpp, LM Studio)
  No --> Is throughput > 1000 req/s needed?
           Yes --> AWQ or GPTQ (vLLM)
           No --> EXL2 (best quality at low bit-widths)

Is the goal fine-tuning (not just inference)?
  Yes --> NF4 / FP4 (bitsandbytes + QLoRA)

Is the target hardware H100?
  Yes --> FP8 (TensorRT-LLM)
```

---

## 2. Prerequisites

### Software

| Dependency | Version | Notes |
|------------|---------|-------|
| Python | 3.10 - 3.12 | 3.9 EOL; 3.13 packages may be unavailable |
| PyTorch | 2.1+ | CUDA 12.1 recommended |
| CUDA Toolkit | 12.x | Required for GPU quantization (Linux) |
| Git LFS | 3.0+ | For downloading models from Hugging Face |
| CMake | 3.22+ | For building llama.cpp |
| C++ compiler | GCC 11+ / Clang 14+ | MSVC 2022 on Windows |

### Disk Space

| Model Size | Raw (FP16) | After Quantization (Q4) |
|------------|-----------|------------------------|
| 7B | ~14 GB | ~4 GB |
| 8B | ~16 GB | ~5 GB |
| 13B | ~26 GB | ~7 GB |
| 34B | ~68 GB | ~17 GB |
| 70B | ~140 GB | ~35 GB |
| 120B | ~240 GB | ~60 GB |
| 180B (MoE) | ~360 GB | ~90 GB |

Plan for at least 2x the raw model size during conversion (source + output).

### Platform-Specific Notes

- **Linux (recommended)**: Full CUDA support for all quantization methods. Ubuntu 22.04 or 24.04 with GCC 11+ is the reference platform.
- **macOS**: CPU-only for AWQ and GPTQ. llama.cpp supports Metal acceleration for GGUF quantization on Apple Silicon. EXL2 requires CUDA.
- **Windows**: Use WSL2 with Ubuntu 22.04 for all GPU-accelerated quantization tools. Native Windows builds of llama.cpp work but have limited CUDA support.

---

## 3. Quantization Concepts

### Bit-widths

| Bit-width | Storage Format | Compression Ratio | Quality Retention |
|-----------|---------------|------------------|------------------|
| FP16 | 16-bit float | 1.0x | Baseline |
| Q8_0 | 8-bit integer | 2.0x | Near lossless |
| Q6_K | 6-bit integer | 2.7x | Excellent |
| Q5_K_M | 5-bit integer | 3.2x | Very good |
| Q4_K_M | 4-bit integer | 4.0x | Good |
| Q3_K_M | 3-bit integer | 5.3x | Fair |
| Q2_K | 2-bit integer | 8.0x | Degraded |
| IQ2_XXS | 2.1-bit | 7.5x | Marginal |

### Symmetric vs. Asymmetric Quantization

- **Symmetric**: Range is centered at zero (`[-127, 127]` for int8). Simpler computation, preferred for weights. Used by default in llama.cpp K-quants.
- **Asymmetric**: Range can shift (`[0, 255]` for uint8). Better utilization of the dynamic range, common in activations. Used in GPTQ and AWQ.

### Per-Tensor, Per-Channel, Per-Group

- **Per-tensor**: Single scale and zero-point for the entire weight tensor. Lowest overhead, lowest quality.
- **Per-channel**: Separate scale per output channel. Standard for most quantization methods.
- **Per-group**: Weights are divided into groups (typically 32 or 128 elements), each with its own scale. Highest quality, used in GPTQ, AWQ, and GGUF k-quants.

### Calibration Datasets

Data-dependent quantization methods (AWQ, GPTQ) require a calibration dataset -- a small set of representative text samples used to determine optimal quantization parameters. Common choices:

- `wikitext-2-raw-v1` (128 samples)
- `c4` (128-256 samples)
- Custom domain-specific data (recommended for specialized models)

### K-Quants (llama.cpp)

K-quants are block-scaled quantization types developed for llama.cpp. The "K" suffix indicates k-means clustering was used during quantization design. Available types from lowest to highest quality:

| Type | Bits/Weight | Description |
|------|-----------|-------------|
| Q2_K | 2.56 | Smallest usable; significant quality loss |
| Q3_K_S | 3.28 | Small 3-bit; use Q3_K_M if space allows |
| Q3_K_M | 3.33 | Medium 3-bit; balanced for small models |
| Q3_K_L | 3.56 | Large 3-bit; best 3-bit quality |
| Q4_K_S | 4.28 | Small 4-bit; fast, decent quality |
| Q4_K_M | 4.33 | Medium 4-bit; recommended default for 7-13B |
| Q4_K_L | 4.56 | Large 4-bit; minimal quality loss from Q5 |
| Q5_K_S | 5.06 | Small 5-bit; good for production |
| Q5_K_M | 5.08 | Medium 5-bit; recommended for most use cases |
| Q5_K_L | 5.56 | Large 5-bit; near FP16 quality |
| Q6_K | 6.56 | Excellent quality; large files |
| Q8_0 | 8.25 | Near lossless; roughly 2x compression |

### I-Quants (Importance Quantization)

I-quants are an improved family using importance-based quantization. They achieve better quality at very low bit-widths compared to K-quants.

| Type | Bits/Weight | Notes |
|------|-----------|-------|
| IQ1_S | 1.56 | Extreme compression; experimental |
| IQ2_XXS | 2.06 | Tiny; usable for small experiments |
| IQ2_XS | 2.31 | Very small; marginal quality |
| IQ2_S | 2.50 | Comparable to Q2_K |
| IQ2_M | 2.70 | Medium 2-bit; best of the 2-bit types |
| IQ3_XXS | 3.06 | Better than Q3_K_S at same size |
| IQ3_S | 3.44 | Comparable to Q3_K_M |
| IQ4_NL | 4.25 | 4-bit no-list; fast on CPU |
| IQ4_XS | 4.25 | 4-bit extra-small |

### Group Size

Relevant for GPTQ, AWQ, and EXL2:

| Group Size | Quality | Speed | Memory Overhead |
|-----------|---------|-------|----------------|
| None (per-channel) | Lowest | Fastest | Minimal |
| 128 | Standard | Fast | Low |
| 64 | Better | Moderate | Moderate |
| 32 | Best | Slower | Higher |

Smaller group sizes produce higher quality quantizations at the same bit-width but increase memory overhead and slow down inference slightly.

---

## 4. GGUF Quantization (llama.cpp)

### Step 1: Build llama.cpp

```bash
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp

# CPU-only
cmake -B build
cmake --build build

# With CUDA
cmake -B build -DLLAMA_CUDA=ON
cmake --build build

# With Metal (macOS)
cmake -B build -DLLAMA_METAL=ON
cmake --build build
```

### Step 2: Convert Model to FP16 GGUF

```bash
python convert_hf_to_gguf.py /path/to/model \
    --outfile /output/path/model.f16.gguf \
    --concurrency 4
```

Key flags:

| Flag | Description | Default |
|------|-------------|---------|
| `--outfile` | Output GGUF file path | Required |
| `--concurrency` | Parallel conversion threads | 1 |
| `--pad-vocab` | Pad vocabulary to multiple of 32 | false |
| `--model-name` | Override model name | from config |
| `--verbose` | Detailed logging | false |

### Step 3: Quantize

```bash
./build/bin/llama-quantize \
    /output/path/model.f16.gguf \
    /output/path/model.q5_k_m.gguf \
    Q5_K_M
```

The `llama-quantize` command signature is:

```
llama-quantize [options] input.gguf output.gguf quant-type
```

Options:

| Flag | Description |
|------|-------------|
| `--allow-requantize` | Allow quantizing an already-quantized model |
| `--leave-output-tensor` | Keep output tensor in FP16 |
| `--pure` | Disable k-quant mixing for pure type |
| `--imatrix` | Importance matrix file for I-quants |

### Recommended Quant Types Per Use Case

| Use Case | Recommended | Alternative |
|----------|------------|-------------|
| Production quality, max retention | Q8_0 | Q6_K |
| Best balance (default recommendation) | Q5_K_M | Q5_K_L |
| Good quality, reduced size | Q4_K_M | Q4_K_L |
| Large models (70B+), tight memory | Q3_K_M | IQ3_XXS |
| Maximum compression | Q2_K | IQ2_M |
| CPU inference priority | Q4_K_M | Q5_K_M |
| GPU inference priority | Q6_K | Q8_0 |
| Chat, general purpose | Q5_K_M | Q4_K_M |
| Code generation | Q8_0 | Q6_K |
| Retrieval (RAG) | Q5_K_M | Q4_K_M |

### Example Commands Per Model Family

```bash
# Llama 3 8B
python convert_hf_to_gguf.py ./Meta-Llama-3-8B --outfile llama3-8b.f16.gguf
./build/bin/llama-quantize llama3-8b.f16.gguf llama3-8b.q5_k_m.gguf Q5_K_M

# Llama 3 70B
python convert_hf_to_gguf.py ./Meta-Llama-3-70B --outfile llama3-70b.f16.gguf
./build/bin/llama-quantize llama3-70b.f16.gguf llama3-70b.q4_k_m.gguf Q4_K_M
./build/bin/llama-quantize llama3-70b.f16.gguf llama3-70b.q3_k_m.gguf Q3_K_M

# Mistral 7B
python convert_hf_to_gguf.py ./Mistral-7B-v0.3 --outfile mistral-7b.f16.gguf
./build/bin/llama-quantize mistral-7b.f16.gguf mistral-7b.q5_k_m.gguf Q5_K_M

# Qwen 2.5 32B
python convert_hf_to_gguf.py ./Qwen2.5-32B --outfile qwen2.5-32b.f16.gguf
./build/bin/llama-quantize qwen2.5-32b.f16.gguf qwen2.5-32b.q4_k_m.gguf Q4_K_M

# DeepSeek-V2 (MoE)
python convert_hf_to_gguf.py ./DeepSeek-V2 --outfile deepseek-v2.f16.gguf
./build/bin/llama-quantize deepseek-v2.f16.gguf deepseek-v2.q4_k_m.gguf Q4_K_M

# Gemma 2 27B
python convert_hf_to_gguf.py ./gemma-2-27b --outfile gemma2-27b.f16.gguf
./build/bin/llama-quantize gemma2-27b.f16.gguf gemma2-27b.q5_k_m.gguf Q5_K_M

# Phi-3 14B
python convert_hf_to_gguf.py ./Phi-3-14B --outfile phi3-14b.f16.gguf
./build/bin/llama-quantize phi3-14b.f16.gguf phi3-14b.q5_k_m.gguf Q5_K_M

# GLM-4 9B
python convert_hf_to_gguf.py ./glm-4-9b --outfile glm4-9b.f16.gguf
./build/bin/llama-quantize glm4-9b.f16.gguf glm4-9b.q5_k_m.gguf Q5_K_M
```

---

## 5. AWQ Quantization

Activation-Aware Weight Quantization (AWQ) is a data-dependent method that preserves critical weights by scaling them based on activation magnitudes.

### Installation

```bash
pip install autoawq
```

### Calibration

AWQ requires a calibration dataset. The default is 128 samples from `wikitext-2-raw-v1`.

### Basic Usage

```bash
python -m autoawq \
    --model /path/to/hf-model \
    --output /path/to/awq-model \
    --quant 4-bit \
    --group-size 128 \
    --calibration-dataset wikitext-2-raw-v1 \
    --num-calibration-samples 128
```

### Advanced Usage

```bash
python -m autoawq \
    --model meta-llama/Meta-Llama-3-8B \
    --output ./llama3-8b-awq \
    --quant 4-bit \
    --group-size 128 \
    --damp-percent 0.01 \
    --calibration-dataset c4 \
    --num-calibration-samples 256 \
    --calibration-seqlen 2048 \
    --no-wandb \
    --eval \
    --tasks wikitext
```

### Key Parameters

| Parameter | Description | Default | Recommended |
|-----------|-------------|---------|-------------|
| `--quant` | Bit precision | `4-bit` | `4-bit` or `3-bit` |
| `--group-size` | Group size for quantization | `128` | `128` (balance) |
| `--damp-percent` | Damping factor for HESS matrix | `0.01` | `0.01` |
| `--zero-point` | Whether to use zero-point | `True` | `True` |
| `--calibration-dataset` | Calibration dataset | `wikitext-2-raw-v1` | `c4` for diversity |

### When to Use AWQ vs. GGUF

| Criteria | AWQ | GGUF |
|----------|-----|------|
| Runtime | vLLM, TGI | llama.cpp, Ollama |
| Batch size | Large (>= 1) | Small (1) |
| Throughput | Thousands req/s | Single user |
| GPU required | Yes | Optional (CPU works) |
| Quality at 4-bit | Slightly better | Good |
| Ease of use | Moderate | Straightforward |

---

## 6. GPTQ Quantization

GPTQ (Post-Training Quantization via Optimal Brain Quantization) is a one-shot weight quantization method based on approximate second-order information.

### Installation

```bash
pip install auto-gptq
```

For ExLlama kernel support (recommended for speed):

```bash
pip install auto-gptq[exllama]
```

### Basic Usage

```bash
python -m autogptq \
    --model /path/to/hf-model \
    --output /path/to/gptq-model \
    --bits 4 \
    --group-size 128 \
    --calibration-dataset wikitext-2-raw-v1 \
    --num-calibration-samples 128
```

### Advanced Usage with All Flags

```bash
python -m autogptq \
    --model meta-llama/Meta-Llama-3-8B \
    --output ./llama3-8b-gptq \
    --bits 4 \
    --group-size 128 \
    --desc-act \
    --damp 0.01 \
    --damp-percent 0.01 \
    --calibration-dataset c4 \
    --num-calibration-samples 256 \
    --calibration-seqlen 2048 \
    --use-fast-kernel \
    --use-marlin \
    --eval \
    --tasks wikitext
```

### Key Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `--bits` | Bit-width (2, 3, 4, 8) | 4 |
| `--group-size` | Group size (32, 64, 128) | 128 |
| `--desc-act` | Descending activation ordering | False |
| `--damp` | Damping factor | 0.01 |
| `--damp-percent` | Damping as percentage | 0.01 |
| `--sym` | Symmetric quantization | False |
| `--use-fast-kernel` | Use optimized CUDA kernel | False |
| `--use-marlin` | Use Marlin kernel (4-bit only) | False |

### Group Size Comparison

```bash
# Group size 32 (best quality, slowest)
python -m autogptq --model ./model --output ./model-gptq-g32 --bits 4 --group-size 32

# Group size 128 (balanced - recommended)
python -m autogptq --model ./model --output ./model-gptq-g128 --bits 4 --group-size 128

# No group size (fastest, lowest quality)
python -m autogptq --model ./model --output ./model-gptq-raw --bits 4 --group-size -1
```

---

## 7. EXL2 Quantization

EXL2 is the quantization format used by ExLlamaV2. It allows mixed-precision within a single model, achieving better quality at a given average bit-rate compared to uniform quantization.

### Installation

```bash
git clone https://github.com/turboderp/exllamav2
cd exllamav2
pip install -r requirements.txt
```

### Bit-Rate Targeting

EXL2 uses a target bit-rate (average bits per weight) instead of a fixed bit-width. The quantizer automatically allocates more bits to important layers and fewer bits to less important ones.

```bash
python convert.py \
    -i /path/to/hf-model \
    -o /path/to/exl2-model \
    -hb 4.5 \
    -b 4.5 \
    -c wikitext-2-raw-v1 \
    -n 128
```

### Key Parameters

| Flag | Description |
|------|-------------|
| `-i` | Input model path |
| `-o` | Output directory |
| `-hb` | Head bit-rate (higher bits for attention) |
| `-b` | Average bit-rate target |
| `-c` | Calibration dataset |
| `-n` | Calibration samples |
| `-om` | Measurement mode (dry run) |
| `-mh` | Maximum measurement heads |
| `-l` | Max sequence length for calibration |

### Recommended Bit-Rates

| Bit-Rate | Equivalent GGUF | Quality | Use Case |
|----------|----------------|---------|----------|
| 6.0 | Q6_K | Excellent | Production, quality-critical |
| 5.0 | Q5_K_M | Very good | Default recommendation |
| 4.5 | Q4_K_L | Good | Balanced for 70B+ models |
| 4.0 | Q4_K_M | Good | Memory-constrained |
| 3.5 | Q3_K_L | Fair | Tight memory |
| 3.0 | Q3_K_M | Low | Exploration only |

### Measurement Mode

Before running the full quantization, measure the model to get accurate bit-rate estimates:

```bash
python convert.py \
    -i /path/to/hf-model \
    -o /dev/null \
    -om \
    -mh 64
```

### Advanced Options

```bash
# Mixed precision: vary bit-rates by module type
python convert.py \
    -i ./Qwen2.5-32B \
    -o ./qwen2.5-exl2 \
    -b 4.5 \
    -hb 5.0 \
    -c c4 \
    -n 256 \
    -l 4096 \
    --fast

# Use binary and scaling separately
python convert.py \
    -i ./model \
    -o ./model-exl2 \
    -b 4.0 \
    --two-shot
```

---

## 8. Bitsandbytes (NF4/FP4)

The bitsandbytes library provides 4-bit quantization primarily designed for fine-tuning (QLoRA) rather than pure inference.

### Installation

```bash
pip install bitsandbytes
```

### Normal Float 4 (NF4)

NF4 is a 4-bit data type designed for normally distributed weights. It uses a non-uniform quantization grid that allocates more representational power to values near zero, where normal distributions concentrate.

```bash
from transformers import AutoModelForCausalLM, BitsAndBytesConfig
import torch

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True,
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Meta-Llama-3-8B",
    quantization_config=bnb_config,
    device_map="auto",
)
```

### FP4 Quantization

FP4 uses a 4-bit floating point format instead of the normal-float format:

```bash
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="fp4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True,
)
```

### Double Quantization

Double quantization (use_double_quant) quantizes the quantization constants themselves, saving an additional 0.5 bits per parameter with minimal quality impact.

### NF4 vs. FP4

| Aspect | NF4 | FP4 |
|--------|-----|-----|
| Distribution | Normal | Uniform |
| Grid points | 16 (non-uniform) | 16 (uniform) |
| Best for | Weights (normal dist.) | Activations (uniform dist.) |
| Quality | Slightly better | Good |
| QLoRA recommended | Yes | No |

### When to Use

- **Training / Fine-tuning**: NF4 with QLoRA is the standard approach. Activates LoRA adapters while keeping base weights quantized.
- **Inference**: GGUF, AWQ, or GPTQ are generally preferred for inference-only workloads because they are faster and have better tooling.
- **Exploring models**: bitsandbytes is convenient for quickly loading and testing large models on a single GPU without committing to a full quantization workflow.

---

## 9. Quantization Comparison

### Full Method Comparison

| Method | Format | Bit-width | Quality (PPL) | Speed | GPU Required | Calibration | Ease |
|--------|--------|-----------|---------------|-------|-------------|-------------|------|
| Q8_0 | GGUF | 8.25 | Baseline +0.1 | 2.0x | No | No | Easy |
| Q6_K | GGUF | 6.56 | Baseline +0.2 | 2.5x | No | No | Easy |
| Q5_K_M | GGUF | 5.08 | Baseline +0.4 | 3.0x | No | No | Easy |
| Q4_K_M | GGUF | 4.33 | Baseline +0.8 | 3.5x | No | No | Easy |
| Q3_K_M | GGUF | 3.33 | Baseline +1.5 | 4.0x | No | No | Easy |
| Q2_K | GGUF | 2.56 | Baseline +3.0 | 4.5x | No | No | Easy |
| IQ2_M | GGUF | 2.70 | Baseline +2.5 | 4.5x | No | Yes | Moderate |
| AWQ 4-bit | AWQ | 4.00 | Baseline +0.5 | 3.5x | Yes | Yes | Moderate |
| AWQ 3-bit | AWQ | 3.00 | Baseline +1.2 | 4.0x | Yes | Yes | Moderate |
| GPTQ 4-bit g128 | GPTQ | 4.00 | Baseline +0.6 | 3.5x | Yes | Yes | Moderate |
| GPTQ 4-bit g32 | GPTQ | 4.00 | Baseline +0.4 | 3.0x | Yes | Yes | Moderate |
| EXL2 5.0 bpw | EXL2 | 5.00 | Baseline +0.3 | 3.0x | Yes | Yes | Moderate |
| EXL2 4.0 bpw | EXL2 | 4.00 | Baseline +0.6 | 3.5x | Yes | Yes | Moderate |
| EXL2 3.0 bpw | EXL2 | 3.00 | Baseline +1.5 | 4.5x | Yes | Yes | Moderate |
| NF4 | bnb | 4.00 | Baseline +0.8 | 2.0x | Yes | No | Easy |

Note: PPL (perplexity) deltas are approximate values for Llama 3 8B on wikitext-2. Actual results vary by model family, size, and dataset.

### Memory Comparison (70B Model)

| Quantization | VRAM Required | Suitable GPUs |
|-------------|--------------|---------------|
| FP16 | ~140 GB | 2x A100-80GB |
| Q8_0 | ~70 GB | A100-80GB, 2x RTX 6000 |
| Q6_K | ~56 GB | A100-80GB, 2x RTX 4090 |
| Q5_K_M | ~45 GB | A100-80GB, 2x RTX 4090 |
| Q4_K_M | ~38 GB | A100-40GB, 2x RTX 3090 |
| Q3_K_M | ~30 GB | RTX 6000, 2x RTX 3090 |
| Q2_K | ~22 GB | RTX 4090, RTX 3090 |
| AWQ 4-bit | ~40 GB | A100-40GB, 2x RTX 3090 |
| GPTQ 4-bit | ~40 GB | A100-40GB, 2x RTX 3090 |
| EXL2 4.0 bpw | ~40 GB | A100-40GB, 2x RTX 3090 |

### Quality Retention Ranking

1. Q8_0 (near lossless)
2. Q6_K
3. EXL2 5.0 bpw
4. Q5_K_L
5. AWQ 4-bit g128
6. Q5_K_M
7. EXL2 4.5 bpw
8. GPTQ 4-bit g32
9. Q4_K_L
10. Q4_K_M
11. GPTQ 4-bit g128
12. EXL2 4.0 bpw
13. Q3_K_L
14. AWQ 3-bit
15. Q3_K_M
16. IQ3_XXS
17. Q2_K
18. IQ2_M
19. IQ1_S

---

## 10. Model Families -- Specific Guidance

### Llama 3.x (8B, 70B, 405B)

Llama 3 models respond very well to quantization. The preferred GGUF types are Q5_K_M for 8B and Q4_K_M for 70B. AWQ 4-bit and GPTQ 4-bit g128 both work excellently with vLLM. The 405B model requires 4-bit quantization to fit on 8x A100-80GB nodes.

### Mistral / Mixtral

Mistral 7B and Mixtral 8x7B (MoE) are robust to quantization. Mixtral benefits from Q4_K_M or Q4_K_L due to its larger effective parameter count. AWQ produces excellent results for Mixtral on vLLM. Note that MoE models have a higher memory multiplier per active parameter.

### Qwen 2.5 (7B, 14B, 32B, 72B, 110B)

Qwen 2.5 models use a different tokenizer size (151,936 tokens vs. Llama's 128,256). The `convert_hf_to_gguf.py` script handles this automatically. Qwen 2.5 32B at Q4_K_M is an excellent sweet spot for Chinese-English bilingual use. The 110B model is an MoE architecture.

### DeepSeek (DeepSeek-V2, DeepSeek-R1, DeepSeek-Coder)

DeepSeek uses MoE architecture with fine-grained expert splitting. Convert with `convert_hf_to_gguf.py` which has specific support for DeepSeek architectures. Use Q4_K_M for balanced quality. DeepSeek-Coder models benefit from Q8_0 for code generation tasks where precision matters.

### Gemma 2 (2B, 9B, 27B)

Gemma 2 models use GQA (Grouped Query Attention) and logits soft-capping. Quantization works well but produces slightly higher perplexity deltas than Llama models at the same bit-width. Recommended: Q5_K_M for quality-critical uses, Q4_K_M for memory-constrained.

### Phi-3 / Phi-4 (3.8B, 7B, 14B)

Smaller models are more affected by quantization. Phi-3-mini (3.8B) at Q5_K_M or higher is strongly recommended. Phi-4 14B is more robust and works well at Q4_K_M. These are good candidates for CPU inference at Q5_K_M.

### GLM-4 (9B, 130B)

GLM-4 models from Zhipu AI use a bidirectional attention variant and Chinese-optimized tokenizer. The `convert_hf_to_gguf.py` script has explicit GLM support. Use Q5_K_M for the 9B model. The 130B model requires Q4_K_M or Q3_K_M.

---

## 11. Advanced Topics

### Split Quantization

Different layers can be quantized to different bit-widths. This is useful when:
- Attention layers benefit from higher precision than feed-forward layers
- The first and last layers are more sensitive to quantization
- You want to fit a model into a specific memory budget

In GGUF, this is partially achieved through importance matrix-based quantization (I-quants). EXL2 natively supports this through bit-rate targeting.

### Combining Quantization with Pruning

Pruning removes redundant weights entirely, while quantization reduces precision. These techniques are complementary:

1. Prune (e.g., SparseGPT or Wanda) to remove 20-50% of weights
2. Quantize the remaining weights to 4-bit or 3-bit

The combined compression ratio can reach 10-20x with moderate quality loss, but tooling support is limited outside of research frameworks.

### QAT vs. PTQ

| Aspect | Post-Training Quantization (PTQ) | Quantization-Aware Training (QAT) |
|--------|----------------------------------|-----------------------------------|
| Training required | No | Yes (fine-tuning) |
| Data required | Small calibration set | Full training dataset |
| Compute cost | Low (hours) | High (days) |
| Quality at 4-bit | Good | Near FP16 |
| Quality at 2-bit | Poor | Fair |
| Tools | autoawq, autogptq, llama.cpp | PyTorch FX, Brevitas |
| Recommendation | Default approach | Only for 2-bit or extreme compression |

All methods in this guide are PTQ. For most production use cases, PTQ provides sufficient quality.

### FP8 on H100

H100 GPUs support native FP8 computation, offering 2x throughput over FP16 with minimal quality loss. This is distinct from the quantization methods above:

```bash
# TensorRT-LLM FP8 quantization
python quantize.py \
    --model_dir /path/to/model \
    --output_dir ./model-fp8 \
    --dtype float16 \
    --qformat fp8 \
    --kv_cache_dtype fp8 \
    --calib_dataset c4
```

FP8 requires TensorRT-LLM or Transformer Engine and is only available on H100 or B200 hardware.

---

## 12. Automated Quantization Pipeline

### Bash Script: Full GGUF Pipeline

```bash
#!/bin/bash
set -euo pipefail

MODEL_PATH="$1"
MODEL_NAME="${MODEL_PATH##*/}"
OUTPUT_DIR="${2:-./output}"

echo "Converting $MODEL_NAME to GGUF..."

python llama.cpp/convert_hf_to_gguf.py "$MODEL_PATH" \
    --outfile "$OUTPUT_DIR/$MODEL_NAME.f16.gguf"

QUANTS=("Q8_0" "Q6_K" "Q5_K_M" "Q4_K_M" "Q3_K_M")

for QUANT in "${QUANTS[@]}"; do
    echo "Quantizing to $QUANT..."
    ./llama.cpp/build/bin/llama-quantize \
        "$OUTPUT_DIR/$MODEL_NAME.f16.gguf" \
        "$OUTPUT_DIR/$MODEL_NAME.$QUANT.gguf" \
        "$QUANT"
done

echo "All quantizations complete."
echo "Results in: $OUTPUT_DIR"
```

### Python Automation with Subprocess

```python
import subprocess
import sys
from pathlib import Path

def quantize_model(
    model_path: str,
    output_dir: str,
    quant_types: list[str] | None = None,
    llama_cpp_path: str = "./llama.cpp",
):
    if quant_types is None:
        quant_types = ["Q8_0", "Q6_K", "Q5_K_M", "Q4_K_M"]

    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    model_name = Path(model_path).name
    f16_file = output_dir / f"{model_name}.f16.gguf"

    subprocess.run([
        "python", f"{llama_cpp_path}/convert_hf_to_gguf.py",
        model_path,
        "--outfile", str(f16_file),
    ], check=True)

    for quant in quant_types:
        quant_file = output_dir / f"{model_name}.{quant}.gguf"
        subprocess.run([
            f"{llama_cpp_path}/build/bin/llama-quantize",
            str(f16_file),
            str(quant_file),
            quant,
        ], check=True)
        print(f"Created {quant_file} ({quant})")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python quantize_pipeline.py /path/to/model")
        sys.exit(1)
    quantize_model(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "./output")
```

### CI/CD Integration Notes

- **Disk space**: Ensure the CI runner has sufficient disk (200 GB+ for 70B models).
- **GPU runners**: AWQ/GPTQ require GPU runners with at least 24 GB VRAM.
- **Caching**: Cache the raw model and FP16 GGUF across pipeline runs.
- **Artifacts**: Store quantized models as pipeline artifacts or upload to Hugging Face.
- **Validation**: Run perplexity benchmarks after each quantization and fail the pipeline if delta exceeds thresholds.

---

## 13. Verification and Validation

### Perplexity Testing

```bash
# llama.cpp built-in perplexity
./build/bin/llama-perplexity \
    -m model.q5_k_m.gguf \
    -f test_data.txt \
    -c 4096 \
    -b 512

# Expected output:
# perplexity: 6.2345
```

Compare perplexity against the FP16 baseline:

```bash
./build/bin/llama-perplexity -m model.f16.gguf -f test_data.txt -c 4096 -b 512
```

A well-quantized model should show <10% perplexity increase at Q4 and <2% at Q8.

### Output Quality Checks

```bash
# Generate text with the same seed for comparison
./build/bin/llama-cli \
    -m model.q5_k_m.gguf \
    -p "Explain quantum computing in three sentences." \
    --seed 42 \
    -n 200 2>/dev/null

# Compare output with the FP16 version (same prompt, seed, and parameters)
./build/bin/llama-cli \
    -m model.f16.gguf \
    -p "Explain quantum computing in three sentences." \
    --seed 42 \
    -n 200 2>/dev/null
```

Compare outputs for semantic similarity. Minor word choice differences are expected; major factual divergence indicates quality degradation.

### Speed Benchmarks

```bash
./build/bin/llama-bench \
    -m model.q5_k_m.gguf \
    -p 512 \
    -n 2048 \
    -ngl 99
```

Output fields:
- `ppl` -- prompt processing rate (tokens/sec)
- `tg` -- text generation rate (tokens/sec)
- `total` -- total combined throughput

### Memory Measurement

```bash
# Monitor VRAM during inference
watch -n 1 nvidia-smi --query-gpu=memory.used --format=csv

# Ollama memory usage
ollama ps

# Process-level memory (Linux)
ps -o pid,ruid,vsz,rss,comm -p $(pgrep llama-cli)
```

---

## 14. Troubleshooting

### Out of Memory

| Symptom | Cause | Solution |
|---------|-------|----------|
| CUDA OOM during conversion | Model too large for GPU RAM | Use CPU conversion (`--concurrency 1`) |
| System OOM during quantization | Insufficient RAM | Close other processes; use swap |
| Inference OOM | Context too long | Reduce context length or batch size |
| Quantization fails silently | Disk full | Check disk space; free at least 2x model size |

### Conversion Failures

| Symptom | Cause | Solution |
|---------|-------|----------|
| `KeyError: 'model.embed_tokens.weight'` | Unsupported architecture | Check llama.cpp compatibility; file an issue |
| `AttributeError: 'NoneType'` | Missing config key | Manually inspect config.json; set default values |
| `ValueError: Unknown architecture` | Very new model | Update llama.cpp to latest commit |
| `convert_hf_to_gguf.py` crashes on tokenizer | Custom tokenizer | Use `--pad-vocab` or manually fix tokenizer_config.json |

### Quality Degradation

| Symptom | Cause | Solution |
|---------|-------|----------|
| Nonsensical output | Over-quantized (Q2 on small model) | Use higher bit-width for models < 7B |
| Repetitive loops | Too aggressive quantization | Reduce temperature or increase bit-width |
| Language mixing | Tokenizer mismatch | Re-convert from original HF model |
| Poor QA accuracy | Calibration data mismatch | Use domain-specific calibration for AWQ/GPTQ |

### CUDA Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `CUDA error: out of memory` | VRAM exceeded | Reduce batch size; use CPU offloading |
| `CUDA error: no kernel image is available` | Wrong CUDA arch | Set `CMAKE_CUDA_ARCHITECTURES` correctly |
| `CUDA error: invalid device ordinal` | Wrong device index | Check `CUDA_VISIBLE_DEVICES` |
| `libcuda.so not found` | CUDA not in LD_LIBRARY_PATH | Install CUDA toolkit; set `LD_LIBRARY_PATH` |
| `Torch not compiled with CUDA` | Wrong PyTorch version | `pip install torch --index-url https://download.pytorch.org/whl/cu121` |

---

## 15. References and Further Reading

- llama.cpp repository: https://github.com/ggml-org/llama.cpp
- AutoAWQ: https://github.com/casper-hansen/AutoAWQ
- AutoGPTQ: https://github.com/PanQiWei/AutoGPTQ
- ExLlamaV2: https://github.com/turboderp/exllamav2
- Bitsandbytes: https://github.com/bitsandbytes-foundation/bitsandbytes
- TensorRT-LLM: https://github.com/NVIDIA/TensorRT-LLM
- Hugging Face Transformers quantization docs: https://huggingface.co/docs/transformers/quantization
- QLoRA paper (NF4): https://arxiv.org/abs/2305.14314
- GPTQ paper: https://arxiv.org/abs/2210.17323
- AWQ paper: https://arxiv.org/abs/2306.00978
- llama.cpp quantization types: https://github.com/ggml-org/llama.cpp/blob/master/gguf-py/README.md
- vLLM quantization support: https://docs.vllm.ai/en/latest/features/quantization.html
