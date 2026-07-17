# Version Compatibility Matrix

## 1. Tested Tool Versions

Always record which tool versions you used. This enables reproducing results months later.

### Core Tools

| Tool | Minimum | Recommended | Latest Tested | Notes |
|------|---------|-------------|---------------|-------|
| llama.cpp | b3000 | b4381+ | b4732 | New architectures added frequently |
| Ollama | 0.1.0 | 0.3.0+ | 0.5.0 | 0.3.0+ supports direct GGUF import |
| CUDA Toolkit | 11.8 | 12.4 | 12.8 | CUDA 12.x required for Marlin kernel |
| Python | 3.10 | 3.12 | 3.13 | 3.13 packages may lag |
| PyTorch | 2.0 | 2.5 | 2.6 | CUDA 12.4 recommended |
| Transformers | 4.36 | 4.48 | 4.50 | Needed for AWQ/GPTQ loading |
| huggingface-hub | 0.20 | 0.27 | 0.29 | For download/snapshot APIs |

### Quantization Libraries

| Library | Minimum | Recommended | Latest Tested | Notes |
|---------|---------|-------------|---------------|-------|
| AutoAWQ | 0.2.0 | 0.2.8 | 0.2.9 | 4-bit only, Marlin kernel included |
| AutoGPTQ | 0.7.0 | 0.8.0 | 0.8.1 | Supports 2/3/4/8-bit |
| ExLlamaV2 | 0.1.0 | 0.3.0 | 0.3.2 | Variable bit-rate quantization |
| bitsandbytes | 0.43.0 | 0.45.0 | 0.45.2 | NF4/FP4 for QLoRA |
| llama-cpp-python | 0.2.0 | 0.3.0 | 0.3.2 | Python bindings for llama.cpp |

### GPU Drivers

| GPU | Min Driver | Recommended | Notes |
|-----|------------|-------------|-------|
| NVIDIA (Linux) | 525.60 | 550.120 | CUDA 12.4 requires 550+ |
| NVIDIA (Windows) | 528.00 | 552.00 | Game-ready or Studio drivers |
| AMD ROCm | 5.7 | 6.2 | ROCm 6+ for RX 7900 series |
| Intel (SYCL) | oneAPI 2024.0 | oneAPI 2025.0 | Limited model support |

## 2. Known Breaking Changes

### llama.cpp

| Version Range | Breaking Change | Impact |
|---------------|-----------------|--------|
| < b3000 | Old GGUF format | Files not loadable by newer versions |
| b3000-b3500 | KV cache format change | Cache not compatible across versions |
| b4000+ | Renamed executables | `main` → `llama-cli`, `quantize` → `llama-quantize` |
| b4200+ | Python API changes | `llama_cpp.Llama()` kwargs changed |
| b4381+ | Flash attention default | Enabled by default, may change memory usage |
| b4500+ | New quant types | IQ4_NL, IQ4_XS added |
| b4700+ | DeepSeek V3 architecture | Requires this version or later |
| b4732+ | Llama 4 support | MoE architecture with 1M context |

### Ollama

| Version | Breaking Change | Impact |
|---------|-----------------|--------|
| < 0.1.15 | No Modelfile support | Must use library models only |
| 0.1.15+ | Modelfile syntax | Current standard |
| 0.3.0+ | Direct GGUF from HF | New `ollama pull hf.co/...` syntax |
| 0.3.5+ | GPU detection changed | Check `ollama run --verbose` for GPU info |
| 0.5.0+ | Parallel request support | `OLLAMA_NUM_PARALLEL` env var |

### AutoAWQ

| Version | Breaking Change | Impact |
|---------|-----------------|--------|
| < 0.2.0 | No Marlin kernel | Slower inference |
| 0.2.0+ | Marlin kernel default | Faster, but Ampere+ GPU required |
| 0.2.5+ | Quant config API change | `quant_config` dict format changed |
| 0.2.8+ | New `awq` CLI | `python -m awq` replaced by `awq` command |

### AutoGPTQ

| Version | Breaking Change | Impact |
|---------|-----------------|--------|
| < 0.5.0 | Transformers integration | Manual model loading required |
| 0.5.0+ | Native transformers support | `GPTQConfig` class added |
| 0.7.0+ | ExLlama kernel update | `use_exllama=True` kwarg changed |
| 0.8.0+ | New Marlin kernel | `use_marlin=True` for 4-bit |

## 3. Architecture Support by llama.cpp Version

| Architecture | First Supported | Stable Since | Notes |
|-------------|-----------------|--------------|-------|
| LlamaForCausalLM | b1 | b1 | Most mature support |
| MistralForCausalLM | b450 | b500 | Same as Llama with sliding window |
| MixtralForCausalLM | b1500 | b1800 | MoE support |
| Qwen2ForCausalLM | b2000 | b2500 | |
| Qwen2MoeForCausalLM | b3000 | b3500 | |
| DeepseekV2ForCausalLM | b3500 | b4000 | MLA attention |
| DeepseekV3ForCausalLM | b4700 | b4732 | MoE + MLA |
| GemmaForCausalLM | b1500 | b1800 | |
| Gemma2ForCausalLM | b2500 | b3000 | |
| Phi3ForCausalLM | b3500 | b4000 | |
| PhiMoEForCausalLM | b4000 | b4200 | |
| GLMForCausalLM | b3000 | b4000 | |
| ChatGLMForCausalLM | b3000 | b4000 | |
| CohereForCausalLM | b3000 | b3500 | |
| DbrxForCausalLM | b2500 | b3000 | |
| ExaoneForCausalLM | b4500 | b4732 | |
| NemotronForCausalLM | b4000 | b4500 | |

## 4. Python Package Version Compatibility

| Python | PyTorch 2.0 | PyTorch 2.1 | PyTorch 2.2 | PyTorch 2.3 | PyTorch 2.4 | PyTorch 2.5 | PyTorch 2.6 |
|--------|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| 3.10 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.11 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.12 | ⚠️ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3.13 | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ⚠️ |

| CUDA | PyTorch 2.0 | PyTorch 2.1 | PyTorch 2.2 | PyTorch 2.3 | PyTorch 2.4 | PyTorch 2.5 |
|------|-------------|-------------|-------------|-------------|-------------|-------------|
| 11.8 | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ | 
| 12.1 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 12.4 | ❌ | ⚠️ | ✅ | ✅ | ✅ | ✅ |

## 5. Reproducibility Record

When running a benchmark or quantization, record:

```
Date: 2025-03-15
llama.cpp commit: abcdef1
Ollama version: 0.5.0
CUDA version: 12.4
Driver version: 550.120
Python version: 3.12.2
PyTorch version: 2.5.1
OS: Ubuntu 22.04 (Linux 6.5.0)
GPU: NVIDIA RTX 4090 (driver 550.120)
```

This makes results reproducible and comparable across team members.
