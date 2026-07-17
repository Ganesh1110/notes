# GGUF Model Conversion Guide

## 1. What is GGUF?

GGUF (GPT-Generated Unified Format) is a binary file format designed for storing machine learning models, specifically transformer-based language models, for efficient inference on consumer hardware. It is the successor to a lineage of formats developed within the llama.cpp ecosystem.

### History

The format evolved through several iterations:

- **GGML** (2023): The original tensor format used by llama.cpp. It stored raw weights as binary blobs with minimal metadata. Each model required its own loader implementation, and there was no standardized way to store tokenizer data or configuration.
- **GGMF** (2023): A minor revision that added magic bytes and basic versioning to the GGML format. Still limited in metadata and extensibility.
- **GGJT** (2023): Introduced a more structured file layout with improved versioning but remained constrained in its metadata capabilities. The format struggled to keep up with the rapid pace of new model architectures.
- **GGUF** (August 2023): A ground-up redesign that addressed the shortcomings of all prior formats. GGUF was designed to be forward-compatible, extensible, and self-describing.

### Key Features

- **Single-file format**: A complete model, including weights, tokenizer, configuration, and metadata, is stored in one file. This simplifies distribution and deployment compared to the multi-file Safetensors or PyTorch checkpoint formats.
- **Rich metadata support**: GGUF embeds key-value metadata (model architecture, context length, tensor layout, hyperparameters) directly in the file header. This allows the loader to dynamically configure itself without requiring separate `config.json` or tokenizer files.
- **Tokenizer embedding**: The tokenizer model (vocabulary, merges, scores, special tokens) is stored inside the GGUF file. This eliminates tokenizer mismatches between training and inference.
- **Quantization support**: Tensors can be stored at multiple precision levels within a single file. The format natively supports a wide range of quantization types, from 2-bit to 16-bit.
- **Split support**: Large models can be split across multiple GGUF files for environments with file size limits, with metadata replicated across all splits.
- **Backward compatibility**: Loaders can safely ignore unknown metadata keys, meaning newer GGUF files with additional metadata can be loaded by older versions of llama.cpp.

### Why GGUF Dominates Local Inference

GGUF has become the de facto standard for local LLM inference due to its tight integration with the llama.cpp ecosystem. Tools like Ollama, LM Studio, GPT4All, KoboldCPP, and text-generation-webui all use GGUF as their primary format. The ability to quantize models aggressively (down to 2-bit) while maintaining reasonable quality makes it possible to run large models (70B+, 100B+) on consumer GPUs and even CPUs. The single-file nature simplifies sharing on Hugging Face and other model hubs.

---

## 2. Prerequisites

Before starting the conversion process, ensure your environment meets the following requirements:

### Software Requirements

- **Python 3.10+**: The conversion scripts are Python-based. Python 3.10 or later is required for full compatibility.
- **Git LFS**: Large model files are stored with Git Large File Storage. Install it on your system:
  - macOS: `brew install git-lfs`
  - Linux (Debian/Ubuntu): `sudo apt install git-lfs`
  - Linux (RHEL/Fedora): `sudo dnf install git-lfs`
  - Windows: Download from `git-lfs.com`
  - After installation: `git lfs install`
- **CMake 3.20+**: Required for building llama.cpp and its tools.
- **C++ Compiler**:
  - macOS: Install Xcode Command Line Tools (`xcode-select --install`)
  - Linux: Install `build-essential` (`sudo apt install build-essential`)
  - Windows: Install Visual Studio Build Tools or MinGW
- **make**: Build system used for compiling llama.cpp.

### Hardware Requirements

- **Disk space**: At least 2x the model size in free disk space. For example, converting a 70B parameter model in FP16 (~140 GB) requires roughly 280 GB of free space for the original weights, the intermediate FP16 GGUF file, and the final quantized file.
- **RAM**: 16 GB minimum; 32 GB+ recommended for models larger than 13B parameters.
- **GPU (optional)**: GPU acceleration is not required for conversion but speeds up quantization significantly.

---

## 3. Installing llama.cpp

llama.cpp is the reference implementation for working with GGUF files. It provides conversion, quantization, and inference tools.

### Clone the Repository

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
```

### Build Options

#### CPU-Only Build

```bash
make -j
```

This produces binaries for inference (`llama-cli` or `main`), quantization (`llama-quantize`), and other utilities.

#### CUDA Build (NVIDIA GPUs)

```bash
make -j LLAMA_CUDA=1
```

Requires the CUDA Toolkit to be installed. The `LLAMA_CUDA` flag enables GPU offloading for both inference and quantization.

#### Metal Build (Apple Silicon)

```bash
make -j LLAMA_METAL=1
```

Enables GPU acceleration on Apple Silicon Macs (M1, M2, M3, M4 series). This significantly improves inference speed.

#### Additional Build Flags

- `LLAMA_CUDA_FORCE_DMMV=1`: Force dequantize + matrix-vector multiplication on GPU.
- `LLAMA_CUBLAS=1`: Alternative CUDA backend (older).
- `LLAMA_VULKAN=1`: Vulkan backend for cross-platform GPU support.
- `LLAMA_HIPBLAS=1`: AMD GPU support via ROCm.
- `LLAMA_OPENBLAS=1`: CPU acceleration via OpenBLAS.

### Verify Installation

```bash
./llama-cli --help
```

Or for older versions:

```bash
./main --help
```

If the help text displays, llama.cpp is installed correctly.

### Docker Option

For users who prefer containerized builds:

```bash
docker build -t llama.cpp .
docker run --rm -it -v /path/to/models:/models llama.cpp ./llama-cli --help
```

Pre-built Docker images are also available on Docker Hub under `ghcr.io/ggerganov/llama.cpp`.

---

## 4. Downloading Models from Hugging Face

Hugging Face is the primary source for open-weight language models. Several methods are available for downloading models.

### Install the Hugging Face Hub CLI

```bash
pip install huggingface-hub
```

### Authenticate

```bash
huggingface-cli login
```

You will need a Hugging Face access token. Generate one at `huggingface.co/settings/tokens`. For gated models (e.g., Llama 3.1, Gemma), you must also accept the license agreement on the model's Hugging Face page.

### Downloading Specific Files

To download individual model files:

```bash
huggingface-cli download meta-llama/Llama-3.1-8B --local-dir ./models/Llama-3.1-8B
```

This downloads the model files (config.json, tokenizer files, model weights in safetensors format) to the specified local directory.

### Downloading Full Repository with Git LFS

For cloning the entire repository (including all git history):

```bash
git clone https://huggingface.co/meta-llama/Llama-3.1-8B
```

Ensure Git LFS is initialized (`git lfs install`) before cloning, or LFS files will be downloaded as pointer files instead of actual weights.

### Using snapshot_download

For programmatic downloads with more control:

```python
from huggingface_hub import snapshot_download

snapshot_download(
    repo_id="meta-llama/Llama-3.1-8B",
    local_dir="./models/Llama-3.1-8B",
    local_dir_use_symlinks=False,
    resume_download=True
)
```

### Resuming Interrupted Downloads

The `huggingface-cli download` command supports resuming interrupted downloads automatically. If using Git LFS, use:

```bash
GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/meta-llama/Llama-3.1-8B
cd Llama-3.1-8B
git lfs pull --include="*.safetensors"
```

Partial LFS pulls can be resumed by re-running `git lfs pull`.

### Verifying File Integrity

Many model repositories provide SHA256 checksums. Verify downloads with:

```bash
sha256sum model.safetensors
```

Compare the output against the checksums provided in the model repository (often in a file named `sha256sums.txt` or similar).

---

## 4.5 Architecture Detection (Before Conversion)

Before attempting conversion, identify the model's architecture from `config.json`. This determines whether `convert_hf_to_gguf.py` can handle it.

### Reading config.json

Every Hugging Face model has a `config.json` in its root directory. The critical field is `architectures`:

```json
{
  "architectures": ["LlamaForCausalLM"],
  "model_type": "llama",
  "num_hidden_layers": 32,
  "hidden_size": 4096,
  "num_attention_heads": 32,
  "num_key_value_heads": 8
}
```

### Architecture-to-Support Decision Tree

```
Read config.json → Check "architectures" field
                             |
        Is architecture in the support table below?
                             |
                     ┌───────┴───────┐
                    Yes              No
                     │               │
             Can convert            Is it a variant of a supported arch?
                                     │
                              ┌──────┴──────┐
                             Yes            No
                              │              │
                     Try conversion    Update llama.cpp
                     (may work)       or wait for support
```

### Key Architecture Values

| architectures[] Value | Model Family | Supported? | Notes |
|-----------------------|-------------|------------|-------|
| `LlamaForCausalLM` | Llama 3.x, CodeLlama | ✅ Yes | Most stable, fully tested |
| `MistralForCausalLM` | Mistral 7B | ✅ Yes | Same arch as Llama with sliding window |
| `MixtralForCausalLM` | Mixtral 8x7B, 8x22B | ✅ Yes | MoE variant |
| `Qwen2ForCausalLM` | Qwen 2.5 | ✅ Yes | Handles 151k tokenizer |
| `Qwen2MoeForCausalLM` | Qwen 2.5 110B | ✅ Yes | MoE variant |
| `DeepseekV2ForCausalLM` | DeepSeek V2 | ✅ Yes | MLA attention |
| `DeepseekV3ForCausalLM` | DeepSeek V3/R1 | ✅ Yes | MoE + MLA |
| `GemmaForCausalLM` | Gemma 2B | ✅ Yes | |
| `Gemma2ForCausalLM` | Gemma 2 9B/27B | ✅ Yes | |
| `Phi3ForCausalLM` | Phi-3 mini/small/medium | ✅ Yes | |
| `PhiForCausalLM` | Phi-1/2 | ✅ Yes | |
| `PhiMoEForCausalLM` | Phi-3 MoE | ✅ Yes | |
| `StableLmForCausalLM` | StableLM 2/Zephyr | ✅ Yes | |
| `FalconForCausalLM` | Falcon 7B/40B/180B | ✅ Yes | |
| `CohereForCausalLM` | Command-R/Command-R+ | ✅ Yes | |
| `InternLM2ForCausalLM` | InternLM 2 | ✅ Yes | |
| `DbrxForCausalLM` | DBRX 132B | ✅ Yes | MoE |
| `GPT2LMHeadModel` | GPT-2 | ✅ Yes | Legacy |
| `ExaoneForCausalLM` | EXAONE 3.0 | ⚠️ Check | Recent addition |
| `NemotronForCausalLM` | Nemotron 4 | ⚠️ Check | May need latest build |
| `OlmoForCausalLM` | OLMo | ✅ Yes | |
| `JAISLMHeadModel` | Jais 30B | ✅ Yes | |
| `MPTForCausalLM` | MPT 7B/30B | ✅ Yes | |
| `OPTForCausalLM` | OPT 125M-66B | ✅ Yes | Legacy |
| `BaichuanForCausalLM` | Baichuan 2 7B/13B | ✅ Yes | |
| `XverseForCausalLM` | XVERSE 13B | ✅ Yes | |
| `GLMForCausalLM`/`ChatGLMForCausalLM` | GLM-4/5 | ⚠️ Partial | Check build date |

### What Happens If Architecture Is Unsupported

You'll see:
```
ValueError: Unknown model architecture: 'FooForCausalLM'
```

**Solutions** (in order):
1. `git pull && make -j` — update llama.cpp to latest (new architectures land frequently)
2. Check the [llama.cpp issue tracker](https://github.com/ggerganov/llama.cpp/issues) for pending support
3. Add support yourself by implementing a new model class in `llama.cpp/convert_hf_to_gguf.py`
4. Wait for upstream support

> **⚠️ Critical Note**: `convert_hf_to_gguf.py` is **not** a universal converter. It only works for architectures explicitly implemented in llama.cpp. Before planning a workflow, always verify the architecture is supported. Running conversion on an unsupported architecture wastes hours of download and compute time.

### Automatic Architecture Check

Run this before conversion to validate:

```bash
python -c "
import json
with open('config.json') as f:
    cfg = json.load(f)
arch = cfg.get('architectures', ['Unknown'])[0]
print(f'Architecture: {arch}')
# Basic validation
known = ['LlamaForCausalLM', 'MistralForCausalLM', 'MixtralForCausalLM',
         'Qwen2ForCausalLM', 'Qwen2MoeForCausalLM', 'DeepseekV2ForCausalLM',
         'DeepseekV3ForCausalLM', 'GemmaForCausalLM', 'Gemma2ForCausalLM',
         'Phi3ForCausalLM', 'PhiForCausalLM', 'PhiMoEForCausalLM',
         'FalconForCausalLM', 'CohereForCausalLM', 'StableLmForCausalLM',
         'InternLM2ForCausalLM', 'DbrxForCausalLM', 'GLMForCausalLM',
         'ChatGLMForCausalLM', 'BaichuanForCausalLM', 'XverseForCausalLM',
         'GPT2LMHeadModel', 'OlmoForCausalLM', 'JAISLMHeadModel',
         'MPTForCausalLM', 'OPTForCausalLM']
if arch in known:
    print('✅ Supported architecture')
else:
    print('⚠️ Unknown architecture — verify llama.cpp supports this')
    print('   Update llama.cpp or check for pending PRs')
"
```

Run this from the model directory before spending time on full conversion.

---

## 5. Conversion to GGUF

The conversion process transforms Hugging Face model weights (stored as SafeTensors or PyTorch bin files) into the GGUF format.

### Locating the Conversion Script

In llama.cpp, the conversion script is located at:

- **Legacy**: `convert.py` (supports older model architectures)
- **Current**: `convert_hf_to_gguf.py` (supports modern architectures, preferred)

Both scripts are in the root of the llama.cpp repository.

### Basic Usage

```bash
python convert_hf_to_gguf.py /path/to/model \
    --outfile model.gguf \
    --outtype f16
```

This converts the model at `/path/to/model` to a GGUF file named `model.gguf` with FP16 precision weights.

### All Flags Explained

| Flag | Description | Default |
|------|-------------|---------|
| `--outfile` | Output GGUF filename | `model.gguf` in current dir |
| `--outtype` | Weight precision: `f16`, `f32`, `q8_0`, `bf16` | `f16` |
| `--model-name` | Metadata name stored in the GGUF file | Auto-detected from config |
| `--verbose` | Enable debug output | `False` |
| `--pad-vocab` | Pad vocabulary size to a multiple (e.g., `--pad-vocab 256`) | Disabled |
| `--no-tokenizer` | Skip embedding tokenizer data | `False` |
| `--split` | Split output into multiple files | Disabled |

### Converting Specific Model Architectures

The conversion script automatically detects the model architecture from `config.json` and applies the appropriate conversion logic. The internal architecture mapping is:

| Hugging Face Class | GGUF Architecture Name |
|--------------------|----------------------|
| `LlamaForCausalLM` | `LlamaModel` |
| `MistralForCausalLM` | `MistralModel` |
| `MixtralForCausalLM` | `MixtralModel` |
| `Qwen2ForCausalLM` | `Qwen2Model` |
| `Qwen2MoeForCausalLM` | `Qwen2MoeModel` |
| `DeepseekV2ForCausalLM` | `DeepseekV2Model` |
| `GemmaForCausalLM` | `GemmaModel` |
| `Gemma2ForCausalLM` | `Gemma2Model` |
| `Phi3ForCausalLM` | `Phi3Model` |
| `PhiForCausalLM` | `PhiModel` |
| `StableLmForCausalLM` | `StableLMModel` |
| `FalconForCausalLM` | `FalconModel` |
| `GPT2LMHeadModel` | `GPT2Model` |
| `GPTNeoXForCausalLM` | `GPTNeoXModel` |
| `BaichuanForCausalLM` | `BaichuanModel` |
| `InternLM2ForCausalLM` | `InternLM2Model` |
| `CodeLlamaForCausalLM` | `LlamaModel` (same as Llama) |
| `CohereForCausalLM` | `CohereModel` |
| `DbrxForCausalLM` | `DbrxModel` |
| `JAISLMHeadModel` | `JAISModel` |
| `MPTForCausalLM` | `MPTModel` |
| `OlmoForCausalLM` | `OlmoModel` |
| `OpenELMForCausalLM` | `OpenELMModel` |
| `OPTForCausalLM` | `OPTModel` |
| `OrionForCausalLM` | `OrionModel` |
| `PersimmonForCausalLM` | `PersimmonModel` |
| `PhiMoEForCausalLM` | `PhiMoEModel` |
| `QWenLMHeadModel` | `QWenModel` |
| `RefinedWebModel` | `RefinedWebModel` |
| `Starcoder2ForCausalLM` | `Starcoder2Model` |
| `XverseForCausalLM` | `XverseModel` |

If the architecture is not recognized, the script will raise an "Unknown model architecture" error. In that case, you may need to update llama.cpp or provide a custom mapping.

### Handling SafeTensors vs PyTorch Bin Files

Modern Hugging Face models use SafeTensors (`.safetensors`) as the default format. The conversion script supports both:

- **SafeTensors**: Preferred. Faster to load, memory-safe, and supports lazy loading.
- **PyTorch bin** (`pytorch_model.bin`): Older format. Slower to load and requires more memory.

The script auto-detects which format is present. If both are available, SafeTensors takes precedence.

### Multi-Part Model Shards

Large models are often split into multiple shard files (e.g., `model-00001-of-00010.safetensors`). The conversion script handles sharded models automatically by reading the `model.safetensors.index.json` file that maps tensor names to shard files. No manual merging is required.

---

## 6. Quantizing GGUF

After converting to FP16 GGUF, the next step is quantization to reduce file size and improve inference speed.

### The llama-quantize Tool

```bash
./llama-quantize model-f16.gguf model-q4_k_m.gguf q4_k_m
```

Arguments:
1. Input FP16 GGUF file
2. Output quantized GGUF file
3. Quantization type

### Full Quant Type Table

| Quant Type | Bits/Weight | Size vs FP16 | Quality | Recommended Use |
|------------|-------------|--------------|---------|-----------------|
| Q2_K | 2.56 | ~16% | Lowest | Extreme compression, small models only |
| Q3_K_S | 3.35 | ~21% | Very low | Minimal viable quality |
| Q3_K_M | 3.52 | ~22% | Low | Balance of size and minimal quality |
| Q3_K_L | 3.62 | ~23% | Low | Slightly better than Q3_K_M |
| Q4_0 | 4.00 | ~25% | Medium | Legacy, use Q4_K_M instead |
| Q4_K_S | 4.00 | ~25% | Medium | Small 4-bit, good for CPU |
| Q4_K_M | 4.38 | ~27% | Good | **Recommended default** |
| Q5_0 | 5.00 | ~31% | Good | Legacy, use Q5_K_M instead |
| Q5_K_S | 5.00 | ~31% | Good | Small 5-bit |
| Q5_K_M | 5.38 | ~34% | Very good | Recommended for quality |
| Q6_K | 6.56 | ~41% | Excellent | High quality, larger file |
| Q8_0 | 8.00 | ~50% | Near lossless | Maximum quality quantization |
| F16 | 16.00 | 100% | Lossless | No quantization |

### I-Quant Types (Importance-Aware Quantization)

Newer llama.cpp versions support "importance-aware" quant types, denoted with the `IQ` prefix:

- **IQ1_S**: 1.56 bits/weight, extreme compression, significant quality loss.
- **IQ2_XXS**: 2.06 bits/weight, better than IQ1 but still very compressed.
- **IQ2_XS**: 2.16 bits/weight.
- **IQ2_S**: 2.50 bits/weight, comparable to Q2_K.
- **IQ2_M**: 2.70 bits/weight.
- **IQ3_XXS**: 3.06 bits/weight.
- **IQ3_XS**: 3.30 bits/weight, comparable to Q3_K.
- **IQ3_S**: 3.44 bits/weight.
- **IQ3_M**: 3.66 bits/weight.
- **IQ4_NL**: 4.25 bits/weight (non-linear).
- **IQ4_XS**: 4.25 bits/weight.

I-quants generally offer better quality at the same bit-rate compared to standard K-quants, but require more computation during inference.

### Recommended Defaults per Use Case

| Use Case | Recommended Quant |
|----------|-----------------|
| Maximum quality (sufficient VRAM) | Q8_0 or F16 |
| High quality (consumer GPU) | Q5_K_M or Q6_K |
| General purpose (recommended) | Q4_K_M |
| Low resource / CPU inference | Q4_K_M |
| Very low resource | Q3_K_M or Q2_K |
| Experimental / edge devices | IQ2_XXS or IQ1_S |

### Batch Processing Multiple Models

Quantize all FP16 GGUF files in a directory:

```bash
for f in *.f16.gguf; do
    out="${f%.f16.gguf}.Q4_K_M.gguf"
    ./llama-quantize "$f" "$out" q4_k_m
done
```

---

## 7. Verifying GGUF Files

After conversion and quantization, verify that the model works correctly.

### Basic Inference Test

```bash
./llama-cli -m model.q4_k_m.gguf -p "Hello, how are you?" -n 50
```

This runs 50 tokens of generation with the given prompt. Verify that the output is coherent and matches expectations for the model.

### Checking Metadata

View all embedded metadata in the GGUF file:

```bash
python scripts/show-info.py model.gguf
```

This shows the architecture, tensor names, quantization type, context length, and all key-value metadata. Alternatively:

```bash
./llama-cli -m model.gguf --verbose-prompt 2>&1 | head -50
```

### Perplexity Testing

For rigorous quality validation:

```bash
./llama-perplexity -m model.gguf -f test_data.txt
```

This computes the perplexity of the model on a test corpus. Compare the perplexity of the quantized model against the original FP16 model to quantify quality loss.

### Comparing Output Before and After Quantization

```bash
# FP16 output
./llama-cli -m model.f16.gguf -p "The capital of France is" -n 20 --seed 42

# Quantized output (same seed)
./llama-cli -m model.q4_k_m.gguf -p "The capital of France is" -n 20 --seed 42
```

Using the same seed ensures deterministic output. Differences between the FP16 and quantized outputs indicate quality degradation. Minor differences at higher bit-rates (Q6_K, Q8_0) are expected and usually acceptable.

---

## 8. Advanced Conversion

### Converting LoRA Adapters

LoRA adapters cannot be directly converted to GGUF. Instead, merge the LoRA weights into the base model before conversion:

```python
from peft import PeftModel
from transformers import AutoModelForCausalLM

base_model = AutoModelForCausalLM.from_pretrained("base-model-path")
model = PeftModel.from_pretrained(base_model, "lora-path")
merged = model.merge_and_unload()
merged.save_pretrained("./merged-model")
```

Then convert `./merged-model` to GGUF using the standard conversion process.

### Merging LoRA into Base Model Before Conversion

For adapter weights distributed separately:

```bash
python scripts/merge_lora.py --base-model /path/to/base --lora /path/to/lora --output /path/to/merged
```

Check llama.cpp for utilities that handle LoRA merging natively at the GGUF level.

### Custom Tokenizer Models

GGUF supports multiple tokenizer types:

- **BPE** (GPT-2 style): Used by Llama, Mistral, Qwen.
- **SentencePiece / Unigram**: Used by Gemma, some multilingual models.
- **WordPiece**: Used by BERT-derived models.

The conversion script automatically selects the tokenizer type based on the model's `tokenizer.json`. For custom tokenizers, you may need to manually specify the tokenizer type using:

```bash
python convert_hf_to_gguf.py /path/to/model \
    --outfile model.gguf \
    --tokenizer bpe \
    --vocab-path /path/to/vocab.json \
    --merges-path /path/to/merges.txt
```

### Handling MoE Architectures

Mixture-of-Experts (MoE) models like Mixtral 8x7B, DeepSeek-V2, and Qwen2 MoE are supported. The conversion script handles them automatically. Key considerations:

- MoE models have additional tensors for expert weights and routing parameters.
- Quantization of MoE models works the same as dense models.
- The `llama-quantize` tool handles expert tensors correctly, applying quantization per-expert.

### Multimodal Models (LLaVA, LLaVA-NeXT)

Multimodal models require special handling:

1. Convert the language model part to GGUF normally.
2. Use a separate MMProj (multimodal projector) file for the vision encoder.
3. Run inference with both files:

```bash
./llama-cli -m llava-v1.6-vicuna-7b.gguf \
    --mmproj llava-v1.6-vicuna-7b-mmproj.gguf \
    --image input.jpg \
    -p "Describe this image" \
    -n 200
```

The `llama.cpp` repository provides separate conversion scripts (`convert-image-encoder-to-gguf.py`) for vision encoders.

### Adding Custom Metadata

Embed custom metadata into a GGUF file:

```bash
python scripts/add-metadata.py model.gguf \
    --key custom.source "My training run" \
    --key custom.date "2025-06-15" \
    --key custom.notes "Fine-tuned on domain data"
```

This is useful for tracking provenance, quantization parameters, and other auditing information.

---

## 9. Batch Conversion Script

Below is a complete bash script that downloads, converts, and quantizes a model in one step.

```bash
#!/bin/bash
# batch_convert.sh - Download, convert, and quantize a Hugging Face model to GGUF
# Usage: ./batch_convert.sh <huggingface_repo_id> [output_dir] [quant_types]

set -euo pipefail

REPO_ID="${1:?Usage: $0 <huggingface_repo_id> [output_dir] [quant_types]}"
OUTPUT_DIR="${2:-./gguf-models}"
QUANT_TYPES="${3:-Q4_K_M Q5_K_M Q8_0}"
LLAMA_CPP_DIR="${LLAMA_CPP_DIR:-./llama.cpp}"
CONVERT_SCRIPT="${LLAMA_CPP_DIR}/convert_hf_to_gguf.py"
QUANTIZE_BIN="${LLAMA_CPP_DIR}/llama-quantize"

MODEL_NAME=$(basename "$REPO_ID")
WORK_DIR="${OUTPUT_DIR}/tmp_${MODEL_NAME}"
FP16_FILE="${OUTPUT_DIR}/${MODEL_NAME}.f16.gguf"

# Create output directory
mkdir -p "$OUTPUT_DIR" "$WORK_DIR"

echo "[1/4] Downloading model: $REPO_ID"
huggingface-cli download "$REPO_ID" --local-dir "$WORK_DIR" --resume-download

echo "[2/4] Converting to FP16 GGUF"
python "$CONVERT_SCRIPT" "$WORK_DIR" --outfile "$FP16_FILE" --outtype f16

echo "[3/4] Verifying FP16 conversion"
${LLAMA_CPP_DIR}/llama-cli -m "$FP16_FILE" -p "Hello" -n 10 --seed 42 > /dev/null 2>&1

echo "[4/4] Quantizing"
for QUANT in $QUANT_TYPES; do
    QUANT_FILE="${OUTPUT_DIR}/${MODEL_NAME}.${QUANT,,}.gguf"
    echo "  Quantizing to ${QUANT}..."
    "$QUANTIZE_BIN" "$FP16_FILE" "$QUANT_FILE" "${QUANT,,}"
    
    # Verify quantized file
    ${LLAMA_CPP_DIR}/llama-cli -m "$QUANT_FILE" -p "Hello" -n 10 --seed 42 > /dev/null 2>&1
    echo "  Verified: $QUANT_FILE"
done

echo "[Cleanup] Removing temporary files"
rm -rf "$WORK_DIR"

echo "Done! Models saved to: $OUTPUT_DIR"
ls -lh "${OUTPUT_DIR}/${MODEL_NAME}".*.gguf
```

### Usage Examples

```bash
# Default: Q4_K_M, Q5_K_M, Q8_0
./batch_convert.sh meta-llama/Llama-3.1-8B

# Custom output directory and quant types
./batch_convert.sh mistralai/Mistral-7B-v0.3 ./my-models "Q2_K Q4_K_M Q6_K"

# Specify llama.cpp directory
LLAMA_CPP_DIR=/opt/llama.cpp ./batch_convert.sh microsoft/Phi-3-mini-4k-instruct
```

---

## 10. Troubleshooting

### "Tokenizer model not found"

The conversion script cannot locate tokenizer files. Ensure the model directory contains at least one of: `tokenizer.json`, `tokenizer.model`, `vocab.json`, `merges.txt`. For SentencePiece models, `tokenizer.model` is required.

**Solution**: Download the full model repository with Git LFS, not just individual files.

### "Unknown model architecture"

The model's `config.json` contains an `architectures` field that the conversion script does not recognize.

**Solution**: Update llama.cpp to the latest commit. If the architecture is still not supported, you may need to implement a custom converter or wait for upstream support.

### CUDA out of memory during conversion

Conversion loads the entire model into memory before writing to disk.

**Solution**: Use FP16 conversion (not FP32) to reduce memory usage. Add `--outtype f16` explicitly. If memory is still insufficient, use a machine with more RAM or convert on CPU only.

### Conversion hanging on large models

Models with 70B+ parameters can take 30-60 minutes to convert.

**Solution**: Add `--verbose` to monitor progress. Ensure the process is not being OOM-killed. Consider using a swap partition or increasing swap space.

### Incorrect vocabulary size

The GGUF file shows a different vocabulary size than expected.

**Solution**: Use `--pad-vocab 256` to pad the vocabulary to the nearest multiple of 256. This is required for some inference engines that expect aligned vocabulary sizes.

### Missing safetensors index file

The model directory contains individual `.safetensors` files but no `model.safetensors.index.json`.

**Solution**: The index file is required for multi-shard models. If it is missing, the conversion script may not load all shards. Re-download the model with `huggingface-cli download` to ensure all files are present.

---

## 11. Best Practices

- **Always convert to FP16 first, then quantize**: Converting directly from Hugging Face to a quantized GGUF type is not supported. The two-step process (convert to FP16, then quantize) is required and also serves as a verification checkpoint.

- **Verify after each step**: Run a quick inference test after conversion and after each quantization. This catches errors early and avoids wasting computation on corrupted files.

- **Keep original Safetensors for backup**: Once you delete the original model files, you cannot regenerate the GGUF with different quantization types without re-downloading. Store originals on cold storage if disk space is limited.

- **Use Q4_K_M as the default "good enough" quant**: Q4_K_M provides the best quality-to-size ratio for most use cases. Start with Q4_K_M, and only use higher bit-rates if quality is insufficient for your application.

- **Document model metadata**: Record the source model, quantization parameters, conversion date, and any custom settings. Embed this metadata in the GGUF file using the custom metadata feature for traceability.

- **Use consistent file naming**: Adopt a naming convention like `{model_name}.{quant_type}.gguf` (e.g., `Llama-3.1-8B.Q4_K_M.gguf`). This makes it easy to identify files at a glance.

- **Test on representative prompts**: Before deploying a quantized model, test it on prompts that match your use case. Perplexity is a useful metric, but qualitative evaluation on real tasks is essential.

- **Monitor for quantization artifacts**: Lower bit-rate quantizations can introduce artifacts such as repetition, incoherence, or reduced instruction-following ability. Always evaluate on your specific task before committing to an aggressive quantization.
