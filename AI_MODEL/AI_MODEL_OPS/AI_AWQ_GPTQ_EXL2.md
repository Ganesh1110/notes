# AWQ, GPTQ & EXL2 Quantization

## 1. Overview

AWQ, GPTQ, and EXL2 are three quantization formats designed for GPU-accelerated inference of large language models. Unlike GGUF, which is optimized for CPU and hybrid CPU/GPU inference primarily through the llama.cpp ecosystem, these three formats target GPU-native deployment scenarios.

### Comparison with GGUF

GGUF is the dominant format for local, single-machine inference across CPU and GPU. It supports a wide range of quantization types (2-bit through 8-bit) and is designed for maximum compatibility across hardware. The three formats covered in this guide are designed specifically for GPU inference frameworks:

- **AWQ** (Activation-aware Weight Quantization): Optimized for serving frameworks like vLLM and Hugging Face TGI.
- **GPTQ** (GPT Post-Training Quantization): The original GPU quantized format, widely supported across transformers, vLLM, and TGI.
- **EXL2**: A format specific to the ExLlamaV2 inference engine, offering variable bit-rate quantization for maximum quality at a given model size.

### When to Use Each Format

| Scenario | Recommended Format |
|----------|-------------------|
| Deploying with vLLM for API serving | AWQ or GPTQ |
| Deploying with Hugging Face TGI | AWQ or GPTQ |
| Maximum inference speed on single GPU | EXL2 |
| Maximum quality at given model size | EXL2 (variable bpw) |
| Integration with transformers library | AWQ or GPTQ |
| Ollama / local tooling | GGUF (not covered here) |

### Hardware Requirements

All three formats require an NVIDIA GPU with:

- **CUDA 11.8+** (CUDA 12.x recommended for latest kernels)
- **At least 8 GB VRAM** (for 7B models at 4-bit), scaling with model size
- **Sufficient system RAM** to load the full-precision model during quantization (typically 2x the FP16 model size)

---

## 2. AWQ (Activation-aware Weight Quantization)

AWQ is a 4-bit quantization method that preserves the most important weights by analyzing activation statistics. It was introduced in the paper "AWQ: Activation-aware Weight Quantization for LLM Compression and Acceleration."

### How AWQ Works

AWQ identifies important weights by analyzing activation magnitudes on a calibration dataset. Rather than quantizing all weights uniformly, AWQ applies per-channel scaling to protect salient weights from quantization error. The key insight is that a small fraction of weights (those corresponding to large activations) disproportionately affect model quality. AWQ protects these by scaling them before quantization and rescaling after.

The result is a 4-bit quantization that typically achieves lower perplexity than vanilla round-to-nearest 4-bit quantization while maintaining the same memory footprint and inference speed.

### Prerequisites

- CUDA Toolkit 11.8 or later
- PyTorch 2.0 or later
- NVIDIA GPU with compute capability 7.0+ (Turing, Ampere, Ada, Hopper)

### Installation

```bash
pip install autoawq
```

For the latest features and kernel optimizations (including the Marlin kernel):

```bash
pip install autoawq --upgrade
```

Or install from source:

```bash
git clone https://github.com/casper-hansen/AutoAWQ
cd AutoAWQ
pip install -e .
```

### Calibration Dataset

AWQ requires a calibration dataset to measure activation statistics. The quality of the calibration data directly affects quantization quality. Recommended calibration datasets:

- **Wikitext-2**: Standard choice, works well for most models.
- **C4** (Colossal Clean Crawled Corpus): Good for general-domain models.
- **Alpaca** or **ShareGPT**: Better for instruction-tuned models.
- **Custom domain-specific data**: Best for specialized models (code, medical, legal).

Small calibration sets (128-512 samples) are typically sufficient. Using more data rarely improves quality.

### Step-by-Step AWQ Quantization

```python
from awq import AutoAWQForCausalLM
from transformers import AutoTokenizer

model_path = "meta-llama/Llama-3.1-8B"
quant_path = "llama-3.1-8b-awq"

model = AutoAWQForCausalLM.from_pretrained(
    model_path,
    device_map="auto"
)

tokenizer = AutoTokenizer.from_pretrained(model_path, trust_remote_code=True)

from datasets import load_dataset
dataset = load_dataset("wikitext", "wikitext-2-raw-v1", split="train")
calibration_data = [tokenizer(text) for text in dataset["text"][:128]]

model.quantize(
    tokenizer,
    quant_config={
        "zero_point": True,
        "q_group_size": 128,
        "w_bit": 4,
        "version": "GEMM"
    },
    calib_data=calibration_data
)

model.save_quantized(quant_path)
tokenizer.save_pretrained(quant_path)
```

### Command-Line Quantization with awq Command

AutoAWQ provides a CLI for quantization:

```bash
awq quantize \
    --model_path meta-llama/Llama-3.1-8B \
    --quant_path ./llama-3.1-8b-awq \
    --calib_data wikitext \
    --num_calib_samples 128
```

### Supported Bit-Widths and Configuration

AWQ currently supports 4-bit quantization only:

- **Bit-width**: 4-bit (INT4)
- **Group size**: 128 (fixed; no 32, 64, or per-channel alternatives)
- **Zero point**: Always enabled
- **Kernel versions**: GEMM (general matrix multiply) and GEMV (vector). GEMM is preferred for batch inference; GEMV for single-sequence.

### Marlin Kernel for Fast Inference

The Marlin kernel is an optimized GPU kernel for 4-bit matrix-vector multiplication. It provides approximately 2x speedup over the standard GEMM kernel on supported GPUs (Ampere and later).

To use Marlin:

```python
quant_config = {
    "zero_point": True,
    "q_group_size": 128,
    "w_bit": 4,
    "version": "GEMM"
}
```

The Marlin kernel is enabled by default on compatible hardware.

### Example: Quantizing Llama 3.1 70B

```bash
awq quantize \
    --model_path meta-llama/Llama-3.1-70B \
    --quant_path ./llama-3.1-70b-awq \
    --calib_data wikitext \
    --num_calib_samples 128
```

Quantizing 70B models requires approximately 280 GB of system RAM to load the FP16 model, plus 80 GB for the quantized output. Use a multi-GPU machine or a high-RAM CPU node.

### Example: Quantizing Qwen 2.5 32B

```bash
awq quantize \
    --model_path Qwen/Qwen2.5-32B \
    --quant_path ./qwen2.5-32b-awq \
    --calib_data wikitext \
    --num_calib_samples 128
```

### Running AWQ Models with vLLM

```python
from vllm import LLM, SamplingParams

llm = LLM(
    model="./llama-3.1-8b-awq",
    quantization="awq",
    dtype="auto",
    max_model_len=8192
)

params = SamplingParams(temperature=0.7, top_p=0.9, max_tokens=256)
output = llm.generate("What is the capital of France?", params)
print(output[0].outputs[0].text)
```

vLLM automatically detects AWQ-quantized models and uses the Marlin kernel for inference.

### Running AWQ Models with TGI

```bash
docker run --gpus all -p 8080:80 \
    -v ./llama-3.1-8b-awq:/model \
    ghcr.io/huggingface/text-generation-inference:latest \
    --model-id /model \
    --quantize awq
```

### Quality Comparison: AWQ vs FP16

AWQ at 4-bit typically retains 99-99.5% of FP16 quality as measured by perplexity on standard benchmarks. On specific tasks (especially those requiring numeric reasoning or factual recall), the gap may be slightly larger. For most conversational and text-generation applications, the difference is imperceptible.

---

## 3. GPTQ (GPT Post-Training Quantization)

GPTQ is a post-training quantization method based on the Optimal Brain Quantizer (OBQ) framework. It was introduced in the paper "GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers."

### How GPTQ Works

GPTQ performs quantization layer by layer using second-order information from the Hessian matrix of the layer's loss function. For each layer, GPTQ:

1. Computes the Hessian of the weight matrix using a calibration dataset.
2. Quantizes weights one column at a time, updating remaining unquantized weights to compensate for the quantization error.
3. Uses the inverse Hessian to optimally allocate quantization error across weights.

This "optimal brain damage" approach minimizes the overall impact of quantization on the model's output distribution.

### Prerequisites

- CUDA Toolkit 11.8 or later
- PyTorch 2.0 or later
- NVIDIA GPU with compute capability 7.0+

### Installation

#### Using auto-gptq

```bash
pip install auto-gptq
```

For the latest version with ExLlama kernels:

```bash
pip install auto-gptq --upgrade
```

#### Using optimum (Hugging Face)

```bash
pip install optimum
pip install auto-gptq
```

### Step-by-Step GPTQ Quantization

```python
from transformers import AutoModelForCausalLM, AutoTokenizer, GPTQConfig
import torch

model_id = "meta-llama/Llama-3.1-8B"
quant_path = "./llama-3.1-8b-gptq"

tokenizer = AutoTokenizer.from_pretrained(model_id)

quant_config = GPTQConfig(
    bits=4,
    group_size=128,
    desc_act=True,
    damp_percent=0.01,
    dataset="c4",
    batch_size=1,
    use_cuda_fp16=True,
)

model = AutoModelForCausalLM.from_pretrained(
    model_id,
    torch_dtype=torch.float16,
    device_map="auto",
    quantization_config=quant_config,
)

model.save_pretrained(quant_path)
tokenizer.save_pretrained(quant_path)
```

### Group Size Options

| Group Size | Description | Quality | Memory |
|------------|-------------|---------|--------|
| 32 | Small groups, highest quality for 4-bit | Best | Higher |
| 64 | Balanced | Good | Medium |
| 128 | Default, recommended | Good | Lower |
| -1 | No grouping (per-channel) | Lowest | Lowest |

Smaller group sizes preserve more detail at the cost of slightly higher memory usage and slower inference.

### Damp Percentage Parameter

The `damp_percent` parameter controls the amount of damping applied to the Hessian matrix during quantization. It prevents numerical instability:

- **Default**: 0.01 (1% damping)
- **Range**: 0.001 to 0.1
- **Lower values**: More accurate quantization but risk of instability
- **Higher values**: More stable quantization but slightly lower quality

### Desc Activation (desc_act) Explained

`desc_act=True` (descending activation ordering) processes weight columns in order of decreasing activation magnitude. This improves quantization quality because columns with larger activations are quantized first, when the remaining unquantized weights have the most freedom to compensate.

- **desc_act=True**: Higher quality, slightly slower inference. Recommended.
- **desc_act=False**: Lower quality, faster inference.

Some inference engines (notably older versions of ExLlama) do not support `desc_act=True`.

### Supported Bit-Widths

| Bit-width | Description | Quality | Size vs FP16 |
|-----------|-------------|---------|-------------|
| 2-bit | Extreme compression | Low | ~12.5% |
| 3-bit | Aggressive compression | Medium | ~18.75% |
| 4-bit | Standard, recommended | Good | ~25% |
| 8-bit | Near lossless | Excellent | ~50% |

### Kernel Options

| Kernel | Description | Speed |
|--------|-------------|-------|
| ExLlama | Fastest GPTQ kernel, single-batch optimized | Fastest |
| Triton | Custom kernel via OpenAI Triton, good batch performance | Fast |
| CUDA | Default CUDA kernel, widest compatibility | Moderate |

Selecting the kernel:

```python
quant_config = GPTQConfig(
    bits=4,
    group_size=128,
    desc_act=True,
    use_exllama=True
)
```

### Example Commands

Quantize via command line with auto-gptq:

```bash
python -m auto_gptq.quantize \
    --model_name meta-llama/Llama-3.1-8B \
    --dataset c4 \
    --bits 4 \
    --group_size 128 \
    --desc_act True \
    --damp_percent 0.01 \
    --num_samples 128 \
    --save_dir ./llama-3.1-8b-gptq
```

### Uploading to Hugging Face Hub

```python
model.push_to_hub("username/llama-3.1-8b-gptq")
tokenizer.push_to_hub("username/llama-3.1-8b-gptq")
```

### Running GPTQ with vLLM

```python
from vllm import LLM, SamplingParams

llm = LLM(
    model="./llama-3.1-8b-gptq",
    quantization="gptq",
    dtype="auto"
)
```

### Running GPTQ with TGI

```bash
docker run --gpus all -p 8080:80 \
    -v ./llama-3.1-8b-gptq:/model \
    ghcr.io/huggingface/text-generation-inference:latest \
    --model-id /model \
    --quantize gptq
```

### Compare with AWQ: Quality and Speed

| Aspect | AWQ | GPTQ |
|--------|-----|------|
| Quality (perplexity) | Slightly better at 4-bit | Slightly worse at 4-bit |
| Inference speed (single batch) | Faster (Marlin kernel) | Fast (ExLlama kernel) |
| Inference speed (batch) | Very fast | Fast |
| Bit-width flexibility | 4-bit only | 2, 3, 4, 8-bit |
| Calibration complexity | Simple | Slightly more complex |

At 4-bit, AWQ generally achieves slightly lower perplexity than GPTQ with the same group size. However, GPTQ's support for 8-bit quantization makes it the better choice when quality is paramount.

---

## 4. EXL2 (ExLlamaV2)

EXL2 is a quantization format specific to the ExLlamaV2 inference engine. Its defining feature is variable bit-rate quantization, which allows different layers to use different bit-widths based on their importance.

### Format Specific to ExLlamaV2

EXL2 cannot be loaded with Hugging Face transformers, vLLM, or TGI. It is exclusively supported by the ExLlamaV2 library, which provides its own inference pipeline. This means EXL2 models are ideal for single-GPU local inference but cannot be used in most production serving stacks.

### Variable Bit-Rate

Unlike AWQ and GPTQ, which use a fixed number of bits per weight across all layers, EXL2 allows each layer to use a different bit-width. The user specifies a target average bit-rate (e.g., 4.0 bits per weight), and the quantizer allocates bits across layers to achieve the best overall quality. Important layers get more bits; less important layers get fewer.

This variable allocation means EXL2 often achieves better quality than fixed-bit formats at the same average bit-rate.

### Prerequisites

- CUDA Toolkit 11.8 or later
- PyTorch 2.0 or later
- NVIDIA GPU with compute capability 7.0+

### Installation

```bash
pip install exllamav2
```

For the latest version:

```bash
git clone https://github.com/turboderp/exllamav2
cd exllamav2
pip install -e .
```

### Step-by-Step EXL2 Quantization

ExLlamaV2 provides a `convert.py` script that handles the full quantization pipeline.

#### Step 1: Measurement

First, run measurement mode to determine the optimal bit allocation for the target average bit-rate:

```bash
python convert.py \
    -i /path/to/hf-model \
    -o ./output-exl2 \
    -b 4.0 \
    -om \
    -m ./measurement.json
```

The `-om` flag runs measurement only, saving the results to `measurement.json`. Measurement requires a calibration dataset (automatically downloaded if not specified).

#### Step 2: Quantization

Then run the actual quantization using the measurement data:

```bash
python convert.py \
    -i /path/to/hf-model \
    -o ./output-exl2 \
    -b 4.0 \
    -m ./measurement.json
```

This creates the quantized model in the output directory.

### Bit-Rate Targeting

EXL2 supports any target bit-rate between 2.0 and 8.0 bits per weight. Common targets:

| Target (bpw) | Description | Size vs FP16 | Quality |
|-------------|-------------|-------------|---------|
| 3.0 bpw | Aggressive compression | ~19% | Low-Medium |
| 3.5 bpw | Balanced aggressive | ~22% | Medium |
| 4.0 bpw | Standard recommendation | ~25% | Good |
| 4.5 bpw | High quality | ~28% | Very good |
| 5.0 bpw | Very high quality | ~31% | Excellent |
| 6.0 bpw | Near lossless | ~38% | Near lossless |

### Head Bits Option

The `--head_bits` parameter keeps the embedding and LM head layers at a higher precision:

```bash
python convert.py \
    -i /path/to/hf-model \
    -o ./output-exl2 \
    -b 4.0 \
    -hb 6.0
```

This allocates 6.0 bpw to the head layers and distributes remaining bits across transformer layers to achieve 4.0 bpw average. This often improves quality at minimal size cost.

### Example Commands for Different Bit-Rates

```bash
# 4.0 bpw (recommended default)
python convert.py \
    -i meta-llama/Llama-3.1-8B \
    -o ./llama-3.1-8b-exl2-4.0 \
    -b 4.0

# 4.5 bpw with head bits
python convert.py \
    -i meta-llama/Llama-3.1-8B \
    -o ./llama-3.1-8b-exl2-4.5 \
    -b 4.5 \
    -hb 6.0

# 5.0 bpw (higher quality)
python convert.py \
    -i meta-llama/Llama-3.1-8B \
    -o ./llama-3.1-8b-exl2-5.0 \
    -b 5.0

# 6.0 bpw (near lossless)
python convert.py \
    -i meta-llama/Llama-3.1-8B \
    -o ./llama-3.1-8b-exl2-6.0 \
    -b 6.0
```

### Running EXL2 Models

```python
from exllamav2 import ExLlamaV2Config, ExLlamaV2, ExLlamaV2Tokenizer
from exllamav2.generator import ExLlamaV2StreamingGenerator, ExLlamaV2Sampler

config = ExLlamaV2Config()
config.model_dir = "./llama-3.1-8b-exl2-4.0"
config.prepare()

model = ExLlamaV2(config)
model.load()
model.autosplit()

tokenizer = ExLlamaV2Tokenizer(config)

generator = ExLlamaV2StreamingGenerator(model, tokenizer)

settings = ExLlamaV2Sampler.Settings()
settings.temperature = 0.7
settings.top_p = 0.9

output = generator.generate(
    prompt="The capital of France is",
    max_new_tokens=100,
    settings=settings
)
print(output)
```

---

## 5. Comparison Table

| Feature | AWQ | GPTQ | EXL2 |
|---------|-----|------|------|
| Bit-width | 4-bit | 2/3/4/8-bit | Variable (2-8 bpw) |
| Group size | 128 | 32/64/128/-1 | Variable |
| Calibration | Required | Required | Required |
| Inference speed | Very fast (Marlin) | Fast (ExLlama) | Fastest (ExLlamaV2) |
| vLLM support | Yes | Yes | No |
| TGI support | Yes | Yes | No |
| Ollama support | Yes (llama.cpp) | No | No |
| Loading | transformers | transformers | ExLlamaV2 |
| Quality at 4-bit | Excellent | Very good | Excellent |
| Bit flexibility | None | High | Highest |
| Popularity | High | Very high | Medium |

---

## 6. Choosing Between AWQ, GPTQ, and EXL2

### Decision Flowchart

```
Are you deploying with vLLM or TGI?
    |
    |-- Yes --> Do you need bit-width flexibility?
    |       |
    |       |-- Yes --> Use GPTQ
    |       |-- No --> Use AWQ (better speed at 4-bit)
    |
    |-- No --> Is maximum single-GPU speed your goal?
            |
            |-- Yes --> Use EXL2
            |-- No --> Do you need transformers integration?
                    |
                    |-- Yes --> Use AWQ or GPTQ
                    |-- No --> Use EXL2 for best quality/size
```

### Decision Rules

- **If deploying with vLLM or TGI**: Choose AWQ or GPTQ. AWQ offers faster inference via the Marlin kernel on supported GPUs. GPTQ offers more bit-width options (2, 3, 4, 8-bit vs AWQ's fixed 4-bit).

- **If maximum speed on a single GPU**: Choose EXL2. ExLlamaV2's inference engine is highly optimized for single-batch generation and often achieves the highest tokens/second.

- **If maximum quality at a given model size**: Choose EXL2 with variable bit-rate allocation. The ability to assign more bits to important layers means better quality at the same average size.

- **If maximum quality regardless of size**: Choose GPTQ 8-bit or EXL2 at 6.0+ bpw. These are near-lossless options.

- **If maximum memory savings**: Choose GPTQ 3-bit or 2-bit, or EXL2 at 3.0-3.5 bpw.

- **If you need Hugging Face ecosystem integration**: Choose AWQ or GPTQ. Both are natively supported by the transformers library.

---

## 7. Advanced Topics

### Quantizing MoE Models (Mixtral, DeepSeek)

MoE models require additional care due to their sparse computation pattern:

- **AWQ**: Supported for MoE architectures. Each expert's weights are quantized independently with the same group size.
- **GPTQ**: Fully supported. The Hessian-based approach works per-expert.
- **EXL2**: Natively supports MoE models. The variable bit-rate allocation handles expert and router weights differently.

Mixtral 8x7B at 4-bit requires approximately 25 GB VRAM with any of the three formats.

### Quantizing VLMs (LLaVA, CogVLM)

Vision-Language Models (VLMs) combine a vision encoder with a language model. Quantization typically applies only to the language model component:

- The vision encoder is usually kept in FP16 or quantized separately at 8-bit.
- The projection layer (connecting vision encoder to LLM) is kept at higher precision.
- All three formats support the language model component. The vision encoder uses separate loading logic.

### Combining Quantization with Tensor Parallelism

For multi-GPU deployment:

- **AWQ**: Compatible with tensor parallelism in vLLM. Each GPU holds a shard of the quantized weights.
- **GPTQ**: Tensor parallelism is supported in vLLM and TGI.
- **EXL2**: ExLlamaV2 supports `model.autosplit()` for automatic tensor parallelism across GPUs.

### Using AWQ/GPTQ for QLoRA Training

Quantized models can serve as the base for QLoRA fine-tuning:

```python
from transformers import AutoModelForCausalLM, BitsAndBytesConfig

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
)

model = AutoModelForCausalLM.from_pretrained(
    model_id,
    quantization_config=bnb_config,
    device_map="auto"
)
```

Note that this uses bitsandbytes quantization (NF4), not AWQ or GPTQ directly. However, AWQ/GPTQ quantized models can be loaded and used as the base for LoRA training with appropriate adapter modules.

### Cache Quantization (KV Cache in FP8)

Modern inference engines support quantizing the KV cache to FP8 to reduce memory usage during long-context generation:

- **vLLM**: Supports KV cache quantization via `--kv-cache-dtype fp8`.
- **ExLlamaV2**: Supports Q4 and Q6 KV cache quantization.
- **TGI**: Supports FP8 KV cache on H100 GPUs.

This is orthogonal to weight quantization and can be applied in addition to AWQ, GPTQ, or EXL2.

---

## 8. Scripts and Automation

### AWQ Quantization Script

```bash
#!/bin/bash
# quantize_awq.sh - AWQ quantization automation
# Usage: ./quantize_awq.sh <model_path> [output_dir] [calib_data]

set -euo pipefail

MODEL_PATH="${1:?Usage: $0 <model_path> [output_dir] [calib_data]}"
OUTPUT_DIR="${2:-./awq-models}"
CALIB_DATA="${3:-wikitext}"
MODEL_NAME=$(basename "$MODEL_PATH")
QUANT_PATH="${OUTPUT_DIR}/${MODEL_NAME}-awq"

mkdir -p "$OUTPUT_DIR"

echo "Starting AWQ quantization of ${MODEL_PATH}"
echo "Output: ${QUANT_PATH}"
echo "Calibration: ${CALIB_DATA}"

awq quantize \
    --model_path "$MODEL_PATH" \
    --quant_path "$QUANT_PATH" \
    --calib_data "$CALIB_DATA" \
    --num_calib_samples 128

echo "Verifying quantized model..."
python -c "
from awq import AutoAWQForCausalLM
model = AutoAWQForCausalLM.from_pretrained('${QUANT_PATH}')
print('Model loaded successfully: ${QUANT_PATH}')
"

echo "Done! AWQ model saved to: ${QUANT_PATH}"
```

### GPTQ Quantization Script

```bash
#!/bin/bash
# quantize_gptq.sh - GPTQ quantization automation
# Usage: ./quantize_gptq.sh <model_path> [output_dir] [bits] [group_size]

set -euo pipefail

MODEL_PATH="${1:?Usage: $0 <model_path> [output_dir] [bits] [group_size]}"
OUTPUT_DIR="${2:-./gptq-models}"
BITS="${3:-4}"
GROUP_SIZE="${4:-128}"
MODEL_NAME=$(basename "$MODEL_PATH")
QUANT_PATH="${OUTPUT_DIR}/${MODEL_NAME}-gptq-${BITS}bit-gs${GROUP_SIZE}"

mkdir -p "$OUTPUT_DIR"

echo "Starting GPTQ quantization of ${MODEL_PATH}"
echo "Output: ${QUANT_PATH}"
echo "Bits: ${BITS}, Group size: ${GROUP_SIZE}"

python -m auto_gptq.quantize \
    --model_name "$MODEL_PATH" \
    --dataset c4 \
    --bits "$BITS" \
    --group_size "$GROUP_SIZE" \
    --desc_act True \
    --damp_percent 0.01 \
    --num_samples 128 \
    --save_dir "$QUANT_PATH"

echo "Verifying quantized model..."
python -c "
from transformers import AutoModelForCausalLM, AutoTokenizer
model = AutoModelForCausalLM.from_pretrained('${QUANT_PATH}', device_map='auto')
tokenizer = AutoTokenizer.from_pretrained('${QUANT_PATH}')
print('Model loaded successfully: ${QUANT_PATH}')
"

echo "Done! GPTQ model saved to: ${QUANT_PATH}"
```

### EXL2 Quantization Script

```bash
#!/bin/bash
# quantize_exl2.sh - EXL2 quantization automation
# Usage: ./quantize_exl2.sh <model_path> [output_dir] [bpw] [head_bits]

set -euo pipefail

MODEL_PATH="${1:?Usage: $0 <model_path> [output_dir] [bpw]}"
OUTPUT_DIR="${2:-./exl2-models}"
BPW="${3:-4.0}"
HEAD_BITS="${4:-}"
MODEL_NAME=$(basename "$MODEL_PATH")
QUANT_PATH="${OUTPUT_DIR}/${MODEL_NAME}-exl2-${BPW}bpw"

mkdir -p "$OUTPUT_DIR"

echo "Starting EXL2 quantization of ${MODEL_PATH}"
echo "Output: ${QUANT_PATH}"
echo "Target bit-rate: ${BPW} bpw"

MEASURE_FILE="${OUTPUT_DIR}/measurement_${MODEL_NAME}.json"

# Step 1: Measurement
echo "[1/2] Running measurement..."
python convert.py \
    -i "$MODEL_PATH" \
    -o "$QUANT_PATH" \
    -b "$BPW" \
    -om \
    -m "$MEASURE_FILE"

# Step 2: Quantization
echo "[2/2] Running quantization..."
HEAD_BITS_FLAG=""
if [ -n "$HEAD_BITS" ]; then
    HEAD_BITS_FLAG="-hb $HEAD_BITS"
fi

python convert.py \
    -i "$MODEL_PATH" \
    -o "$QUANT_PATH" \
    -b "$BPW" \
    -m "$MEASURE_FILE" \
    $HEAD_BITS_FLAG

echo "Done! EXL2 model saved to: ${QUANT_PATH}"
```

---

## 9. Quality Validation

### Perplexity Comparison Across Formats

Use the `lm-evaluation-harness` library to evaluate quality consistently across formats:

```bash
pip install lm-eval
```

Evaluate AWQ model:

```bash
lm_eval --model hf \
    --model_args pretrained=./llama-3.1-8b-awq \
    --tasks wikitext \
    --device cuda:0 \
    --batch_size auto
```

Evaluate GPTQ model:

```bash
lm_eval --model hf \
    --model_args pretrained=./llama-3.1-8b-gptq \
    --tasks wikitext \
    --device cuda:0 \
    --batch_size auto
```

Evaluate EXL2 model (using custom adapter):

```bash
lm_eval --model local-completions \
    --model_args model=./llama-3.1-8b-exl2-4.0 \
    --tasks wikitext \
    --device cuda:0
```

### Benchmark Scores by Quant

Typical quality retention relative to FP16:

| Format | 3-bit | 4-bit | 8-bit |
|--------|-------|-------|-------|
| AWQ | N/A | 99.2% | N/A |
| GPTQ | 97.5% | 98.8% | 99.8% |
| EXL2 3.5 bpw | 98.0% | N/A | N/A |
| EXL2 4.0 bpw | N/A | 99.3% | N/A |
| EXL2 6.0 bpw | N/A | N/A | 99.9% |

### Task-Specific Evaluation

For comprehensive quality assessment, evaluate on:

```bash
# MMLU (knowledge and reasoning)
lm_eval --model hf \
    --model_args pretrained=./quantized-model \
    --tasks mmlu \
    --num_fewshot 5

# GSM8K (math)
lm_eval --model hf \
    --model_args pretrained=./quantized-model \
    --tasks gsm8k \
    --num_fewshot 8

# HellaSwag (commonsense reasoning)
lm_eval --model hf \
    --model_args pretrained=./quantized-model \
    --tasks hellaswag \
    --num_fewshot 0
```

### Speed Benchmarks (Tokens/Second)

Measure inference speed with a fixed prompt length:

```python
import time
import torch

def benchmark_inference(model, tokenizer, prompt="Hello" * 128, max_tokens=256):
    inputs = tokenizer(prompt, return_tensors="pt")
    start = time.time()
    with torch.no_grad():
        outputs = model.generate(**inputs, max_new_tokens=max_tokens)
    elapsed = time.time() - start
    tokens = outputs.shape[1] - inputs.input_ids.shape[1]
    return tokens / elapsed
```

Typical speed comparison on RTX 4090 (7B model, 4-bit):

| Format | Tokens/sec (batch=1) | Tokens/sec (batch=8) |
|--------|---------------------|---------------------|
| AWQ (Marlin) | 180-220 | 400-500 |
| GPTQ (ExLlama) | 160-200 | 350-450 |
| EXL2 (4.0 bpw) | 200-260 | N/A (single-batch optimized) |

---

## 10. Troubleshooting

### CUDA Out of Memory During Quantization

The model in FP16 may not fit in GPU memory for quantization.

**Solutions**:
- Use CPU offloading: `device_map="cpu"` for the initial model load.
- Use a smaller batch size: `batch_size=1` in GPTQ config.
- For AWQ, use `--batch_size 1`.
- Use gradient checkpointing.
- Split across multiple GPUs: `device_map="auto"`.

### Calibration Dataset Not Found

The quantization script cannot locate or download the calibration dataset.

**Solutions**:
- Manually download the dataset and point to the local path.
- Use a different dataset that is available in your region.
- For offline environments, pre-download with `datasets.load_dataset` and save to disk.

### Tokenizer Mismatch

The tokenizer used during quantization does not match the model's original tokenizer.

**Solutions**:
- Ensure `trust_remote_code=True` is set when loading the tokenizer.
- Use the exact tokenizer from the model repository.
- Verify the tokenizer files are present (tokenizer.json, tokenizer_config.json, special_tokens_map.json).

### FP16 Not Supported on This GPU

Older GPUs may not support FP16 computation.

**Solutions**:
- Use `torch_dtype=torch.float32` instead of `torch.float16`.
- Note that this doubles memory requirements.
- For AWQ, the `autoawq` library requires FP16 support (compute capability 7.0+).

### ExLlama Kernel Compilation Issues

ExLlama kernels may fail to compile on some systems.

**Solutions**:
- Install CUDA Toolkit and ensure `nvcc` is in PATH.
- For auto-gptq, install without ExLlama: `pip install auto-gptq --no-deps` and manually install CUDA kernel.
- For ExLlamaV2, verify CUDA version compatibility.
- Try `export TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0"` to target specific architectures.

### "GPTQ model format not supported by ExLlama kernel"

The ExLlama kernel in newer versions of auto-gptq requires specific quantization parameters.

**Solutions**:
- Set `use_exllama=False` in GPTQConfig to fall back to the Triton or CUDA kernel.
- Use `desc_act=False` if the model was quantized without descending activation ordering.
- Re-quantize with `use_exllama=True` if ExLlamaV2 compatibility is needed.

### Inference Slower Than Expected

Quantized model inference is slower than the FP16 baseline.

**Solutions**:
- Verify the correct kernel is being used (Marlin for AWQ, ExLlama for GPTQ).
- Check that `device_map="auto"` is placing layers on GPU, not CPU.
- For EXL2, ensure `model.autosplit()` is called after loading.
- Reduce the number of CPU threads if using hybrid CPU/GPU offloading.
