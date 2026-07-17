# AI Model Operations (ModelOps)

A production-grade documentation suite for quantizing, converting, deploying, and benchmarking large language models. This project supports GLM, Qwen, DeepSeek, Gemma, Llama, Mistral, Phi, and any Hugging Face model across all major inference runtimes.

---

## Directory Structure

```
AI_MODEL_OPS/
├── README.md                  # This file — entry point and quickstart
├── AI_QUANTIZE_MODEL.md       # Full quantization guide — all formats, all tools
├── AI_CONVERT_TO_GGUF.md      # GGUF conversion using llama.cpp
├── AI_AWQ_GPTQ_EXL2.md        # AWQ, GPTQ, and EXL2 quantization workflows
├── AI_OLLAMA_DEPLOYMENT.md    # Deploy quantized models with Ollama
├── AI_LLAMACPP.md             # Build and use llama.cpp (CPU + CUDA)
├── AI_MODEL_SELECTION.md      # How to choose the right base model
├── AI_BENCHMARK.md            # Benchmarking methodology for speed and quality
├── AI_MEMORY_CALCULATOR.md    # RAM/VRAM planning formulas and tables
├── AI_TROUBLESHOOTING.md      # Common issues and solutions
├── AI_CHECKLIST.md            # Production deployment checklist
└── templates/                 # Reusable shell scripts and Modelfile templates
```

---

## Quickstart

### 1. Choose a Model

Review `AI_MODEL_SELECTION.md` to select the best base model for your use case. Consider parameter count, context length, architecture, and community support.

```bash
git lfs install
git clone https://huggingface.co/meta-llama/Meta-Llama-3-8B
```

### 2. Quantize and Convert

Choose your target format based on your inference runtime. See `AI_QUANTIZE_MODEL.md` for a complete guide.

```bash
# GGUF (for Ollama, llama.cpp, LM Studio)
python llama.cpp/convert_hf_to_gguf.py ./Meta-Llama-3-8B --outfile llama3-8b.f16.gguf
./llama.cpp/build/bin/llama-quantize llama3-8b.f16.gguf llama3-8b.q5_k_m.gguf Q5_K_M

# AWQ (for vLLM, SGLang)
python -m autoawq --model ./Meta-Llama-3-8B --output ./llama3-8b-awq

# GPTQ (for vLLM, TGI)
python -m autogptq --model ./Meta-Llama-3-8B --output ./llama3-8b-gptq
```

### 3. Deploy

```bash
# Ollama
ollama create my-model -f templates/Modelfile
ollama run my-model

# llama.cpp
./llama.cpp/build/bin/llama-cli -m llama3-8b.q5_k_m.gguf -p "Hello"

# vLLM (AWQ or GPTQ)
python -m vllm --model ./llama3-8b-awq
```

---

## Prerequisites

| Requirement          | Minimum Version / Details                          |
|----------------------|----------------------------------------------------|
| Python               | 3.10 to 3.12                                      |
| Git                  | 2.30+                                              |
| Git LFS              | 3.0+                                               |
| CMake                | 3.22+                                              |
| C++ Compiler         | GCC 11+ or Clang 14+ (MSVC 2022 on Windows)       |
| Free Disk Space      | 50 GB minimum; 200 GB recommended                  |
| NVIDIA GPU (opt.)    | 8 GB+ VRAM for local quantization; CUDA 12+        |
| RAM                  | 16 GB minimum; 32 GB+ recommended                  |

**Platform notes:**
- **Linux (recommended)**: Full CUDA support, best performance for all tools.
- **macOS**: CPU-only for most quant tools; Metal acceleration available in llama.cpp. AWQ/GPTQ require Linux.
- **Windows**: Use WSL2 with Ubuntu 22.04 for full compatibility.

---

## Document Reference

| Document | Description |
|----------|-------------|
| `AI_QUANTIZE_MODEL.md` | Complete quantization guide — all formats, all tools |
| `AI_CONVERT_TO_GGUF.md` | GGUF conversion using llama.cpp |
| `AI_AWQ_GPTQ_EXL2.md` | AWQ, GPTQ, and EXL2 quantization workflows |
| `AI_OLLAMA_DEPLOYMENT.md` | Deploy quantized models with Ollama |
| `AI_LLAMACPP.md` | Build and use llama.cpp (CPU + CUDA) |
| `AI_MODEL_SELECTION.md` | How to choose the right base model |
| `AI_BENCHMARK.md` | Benchmarking methodology for speed/quality |
| `AI_MEMORY_CALCULATOR.md` | RAM/VRAM planning formulas and tables |
| `AI_TROUBLESHOOTING.md` | Common issues and solutions |
| `AI_CHECKLIST.md` | Production deployment checklist |
| `templates/` | Reusable shell scripts and Modelfile templates |

---

## Workflow Diagram

```
Hugging Face Model
    |
    v
AI_MODEL_SELECTION.md ---> Download with Git LFS
                                |
                                v
              +-----------------+-----------------+
              |                 |                  |
              v                 v                  v
        GGUF (llama.cpp)   AWQ (autoawq)     GPTQ (autogptq)
              |                 |                  |
              v                 v                  v
        llama.cpp           vLLM / TGI        vLLM / TGI
        Ollama
        LM Studio
```

---

## Document Summaries

### AI_QUANTIZE_MODEL.md
Complete reference for all quantization methods: GGUF (Q2_K through Q8_0), AWQ, GPTQ, EXL2, and bitsandbytes NF4/FP4. Covers concepts, per-model recommendations, automated pipelines, and validation.

### AI_CONVERT_TO_GGUF.md
Step-by-step guide for converting Hugging Face models to GGUF format using llama.cpp's `convert_hf_to_gguf.py`. Covers conversion flags, architecture-specific options, and validation.

### AI_AWQ_GPTQ_EXL2.md
Focused guide for weight-only quantization methods that maintain high quality: AWQ for vLLM, GPTQ with ExLlama kernels, and EXL2 with bit-rate targeting.

### AI_OLLAMA_DEPLOYMENT.md
Deploy quantized models via Ollama: Modelfile creation, parameter tuning (temperature, context length, system prompt), model management, and serving configuration.

### AI_LLAMACPP.md
Building llama.cpp from source with CPU, CUDA, Metal, and Vulkan backends. Covers server mode, inference tuning, batching, and performance optimization.

### AI_MODEL_SELECTION.md
Framework for choosing the right base model: parameter count vs. quality, context length requirements, multilingual support, architectural considerations, and community ecosystem.

### AI_BENCHMARK.md
Standardized benchmarking methodology: tokens per second, time to first token, peak memory, perplexity, and quality evaluation. Includes automation scripts and result interpretation.

### AI_MEMORY_CALCULATOR.md
Memory planning for inference and quantization: formulas for RAM/VRAM per parameter count and quantization level, overhead accounting, context caching, and multi-model deployment.

### AI_TROUBLESHOOTING.md
Common failure modes: out-of-memory errors, conversion failures, quality degradation, CUDA errors, Ollama import issues, and llama.cpp build failures.

### AI_CHECKLIST.md
Production deployment checklist: security, monitoring, rollback plan, load testing, model versioning, API endpoint configuration, and SLA verification.

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `HF_HOME` | `~/.cache/huggingface` | Hugging Face cache directory for downloaded models |
| `CUDA_VISIBLE_DEVICES` | (all) | Restrict CUDA devices (`0` or `0,1`) |
| `CUDA_HOME` | system default | CUDA toolkit installation path |
| `CMAKE_CUDA_ARCHITECTURES` | (auto) | Target GPU architecture (`80` for A100, `90` for H100) |
| `LLAMA_CUDA` | (unset) | Enable CUDA support in llama.cpp build |
| `LLAMA_METAL` | (unset) | Enable Metal support on macOS in llama.cpp build |
| `OLLAMA_MODELS` | `~/.ollama/models` | Ollama model storage directory |
| `TRANSFORMERS_CACHE` | `~/.cache/huggingface` | Transformers library cache |
| `TORCH_DTYPE` | `auto` | Default PyTorch dtype (`float16`, `bfloat16`) |
| `OMP_NUM_THREADS` | (auto) | OpenMP threads for CPU inference |
| `VLLM_USE_V1` | `0` | Enable vLLM V1 engine |

---

## Quick Reference — Common Commands

| Task | Command |
|------|---------|
| Download model | `git clone https://huggingface.co/org/model` |
| Convert to GGUF | `python convert_hf_to_gguf.py ./model --outfile model.f16.gguf` |
| Quantize GGUF | `llama-quantize model.f16.gguf model.q5_k_m.gguf Q5_K_M` |
| AWQ quantize | `python -m autoawq --model ./model --output ./model-awq` |
| GPTQ quantize | `python -m autogptq --model ./model --output ./model-gptq` |
| EXL2 quantize | `python convert.py -i ./model -o ./model-exl2 -hb` |
| Run GGUF | `llama-cli -m model.gguf -p "prompt"` |
| Run AWQ/vLLM | `python -m vllm --model ./model-awq` |
| Run Ollama | `ollama run my-model` |
| Run benchmark | `llama-bench -m model.gguf` |
| Check perplexity | `llama-perplexity -m model.gguf -f test.txt` |
| Measure memory | `nvidia-smi` or `ollama ps` |

---

## License

This documentation suite is provided under the MIT License. See `LICENSE` in the project root for details.

## Contributing

Contributions are welcome. When adding new quantization methods, runtimes, or best practices, follow the existing document structure and format. Open an issue or pull request to discuss changes before investing significant effort.

---

## Related Projects

- [llama.cpp](https://github.com/ggml-org/llama.cpp) — GGUF format and inference engine
- [Ollama](https://ollama.com) — Local model deployment
- [vLLM](https://github.com/vllm-project/vllm) — High-throughput serving
- [AutoAWQ](https://github.com/casper-hansen/AutoAWQ) — AWQ quantization
- [AutoGPTQ](https://github.com/PanQiWei/AutoGPTQ) — GPTQ quantization
- [ExLlamaV2](https://github.com/turboderp/exllamav2) — EXL2 quantization and inference
- [Hugging Face Transformers](https://github.com/huggingface/transformers) — Model hub and loading
