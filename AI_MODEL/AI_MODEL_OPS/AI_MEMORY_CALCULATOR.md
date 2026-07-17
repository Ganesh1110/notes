# RAM & VRAM Planning for LLMs

## 1. Why Memory Planning Matters

Models are memory-bound, not compute-bound. Running out of memory causes crashes or swapping (very slow). Correct planning prevents wasted GPU spend.

Large language models require significant memory for three main components: model weights loaded from disk and held in GPU VRAM, the KV cache that grows with each token generated, and intermediate activations calculated during forward passes. Without proper planning, even powerful GPUs can be insufficient for a given model and context configuration.

Understanding the memory budget helps you avoid costly trial-and-error on cloud GPU instances, prevents silent performance degradation from swapping, and enables informed decisions about quantization levels, context lengths, and hardware requirements before committing to a deployment.

### Key memory pressure points

- Model weights dominate at larger parameter counts (70B+ even at Q4)
- KV cache dominates at long context (128K+) regardless of model size
- Batch size multiplies KV cache and activation memory for serving
- Quantization reduces model weights but not proportionally for KV cache

## 2. Core Memory Formulas

### Model weights memory (no quantization)

The most fundamental formula for estimating memory consumption is straightforward: multiply the number of parameters by the number of bytes per parameter at the chosen precision. This gives the bare minimum without any framework overhead or additional data structures.

```
memory_gb = num_parameters * bytes_per_param / (1024^3)
```

- FP32: 4 bytes/param
- FP16: 2 bytes/param
- INT8: 1 byte/param
- INT4: 0.5 bytes/param

### With quantization overhead

Quantized formats never achieve the exact theoretical minimum size. The overhead comes from metadata needed to reconstruct the original range and scale for each group of weights, block-level quantization tables, and file format headers.

- GGUF: ~1-5% overhead beyond raw bit count
- AWQ/GPTQ: group size adds header metadata (~1-3%)
- EXL2: variable bit-rate with per-group quantization metadata
- Actual sizes vary; always check the real file size rather than relying on theoretical minimum

### Activation memory

During inference, each layer produces intermediate activations that must be held in memory until backpropagation (training) or the next layer's computation (inference). For inference:

```
activation_memory = batch_size * sequence_length * hidden_size * bytes_per_param * n_layers
```

In practice, activation memory is usually small for single-sequence inference (batch_size=1) but becomes significant for batched serving scenarios. Flash attention can dramatically reduce activation memory by avoiding materialization of the full attention matrix.

### KV Cache memory

```
kv_cache_gb = 2 * n_layers * (n_kv_heads * d_head) * context_length * dtype_bytes / (1024^3)
```

- For GQA (grouped query attention): n_kv_heads < n_heads
- For MHA (multi-head attention): n_kv_heads = n_heads

### Total GPU memory

```
total_vram = model_weights + kv_cache + activation_memory + overhead
```

## 3. Model Memory Tables

### FP16 size by parameter count

| Parameters | FP16 Size | FP32 Size |
|------------|-----------|-----------|
| 1B | 2 GB | 4 GB |
| 3B | 6 GB | 12 GB |
| 7B | 14 GB | 28 GB |
| 8B | 16 GB | 32 GB |
| 13B | 26 GB | 52 GB |
| 30B | 60 GB | 120 GB |
| 34B | 68 GB | 136 GB |
| 70B | 140 GB | 280 GB |
| 72B | 144 GB | 288 GB |
| 110B | 220 GB | 440 GB |
| 405B | 810 GB | 1620 GB |

### GGUF size by quant type (for 7B model)

| Quant | Size |
|-------|------|
| Q2_K | 2.8 GB |
| Q3_K_M | 3.5 GB |
| Q4_0 | 4.0 GB |
| Q4_K_M | 4.5 GB |
| Q5_K_M | 5.3 GB |
| Q6_K | 6.0 GB |
| Q8_0 | 7.0 GB |
| F16 | 14.0 GB |

### GGUF size by quant type (for 70B model)

| Quant | Size |
|-------|------|
| Q2_K | 24 GB |
| Q3_K_M | 31 GB |
| Q4_0 | 37 GB |
| Q4_K_M | 41 GB |
| Q5_K_M | 49 GB |
| Q6_K | 56 GB |
| Q8_0 | 66 GB |
| F16 | 140 GB |

## 4. KV Cache Memory Tables

### KV cache per model architecture (at 8K context)

| Model | Layers | KV Heads | Head Dim | KV Cache (FP16) |
|-------|--------|----------|----------|-----------------|
| Llama 3 8B | 32 | 8 | 128 | 1.0 GB |
| Llama 3 70B | 80 | 8 | 128 | 2.5 GB |
| Qwen 2.5 7B | 28 | 4 | 128 | 0.44 GB |
| Qwen 2.5 72B | 80 | 8 | 128 | 2.5 GB |
| Mixtral 8x7B | 32 | 8 | 128 | 1.0 GB |
| DeepSeek V2 | 60 | 16 | 128 | 4.7 GB |

### KV cache at different context lengths

- 4096: 0.5x
- 8192: 1.0x (baseline)
- 16384: 2.0x
- 32768: 4.0x
- 65536: 8.0x
- 131072: 16.0x

### Quantized KV Cache

- Q8_0: ~50% of FP16 KV cache
- Q4_0: ~25% of FP16 KV cache
- FP8: ~50% of FP16 KV cache

## 5. Total Memory Estimation Examples

### Scenario: Llama 3.1 8B Q4_K_M on single GPU

- Weights: ~4.5 GB (Q4_K_M)
- KV cache (8K): ~1.0 GB (FP16) or ~0.5 GB (Q8 KV)
- Overhead: ~0.5 GB
- **Total: ~5.5-6.0 GB VRAM**

### Scenario: Qwen 2.5 32B Q4_K_M on single GPU

- Weights: ~19 GB (Q4_K_M)
- KV cache (8K): ~1.5 GB
- Overhead: ~1 GB
- **Total: ~21.5 GB VRAM** (fits on 24GB GPU)

### Scenario: Llama 3.1 70B Q4_K_M

- Weights: ~41 GB (Q4_K_M)
- KV cache (8K): ~2.5 GB
- Overhead: ~2 GB
- **Total: ~45.5 GB VRAM** (needs 48GB GPU or dual 24GB)

### Scenario: DeepSeek V2 Q4_K_M

- Effective parameters: ~32B active (236B total, sparse MoE)
- Weights: ~17 GB (Q4_K_M) for active params
- KV cache: ~4.7 GB
- Overhead: ~2 GB
- **Total: ~24 GB VRAM**

### Scenario: Llama 3.1 405B Q3_K_M

- Weights: ~190 GB (Q3_K_M)
- KV cache: ~8 GB
- Overhead: ~10 GB
- **Total: ~208 GB VRAM** (needs 8x 24GB or 4x 80GB GPUs)

## 6. CPU RAM Requirements

- For CPU-only inference: RAM = model size + ~20% overhead
- For GPU offloading (partial): RAM = model size * (1 - offload_ratio) + system overhead
- Minimum recommended RAM: 16 GB (for 7B models), 32 GB (for 13-30B), 64 GB (for 70B+)
- Swap space should equal RAM at minimum

## 7. Context Length Planning

- Memory scales linearly with context length (for KV cache)
- Rule of thumb: halving context halves KV cache memory
- For very long contexts (128K+), KV cache dominates memory usage
- Solutions for long context:
  - Use models with smaller KV heads (GQA)
  - Quantize KV cache to Q8_0 or Q4_0
  - Use sliding window attention
  - Use context distillation for RAG

## 8. Multi-GPU Memory Planning

- Model parallelism: split weights across GPUs
- Tensor parallelism: split each layer across GPUs
- Pipeline parallelism: split layers across GPUs
- Memory per GPU with N GPUs approximately:
  `per_gpu = total_vram / N + communication_overhead`

## 9. Practical Memory Calculator (Interactive Formula)

```python
def estimate_vram(params_b, quant_bits, n_layers, n_kv_heads, d_head, ctx_len, kv_quant_bits=16):
    weights_gb = params_b * quant_bits / 8 / 1024**3
    kv_gb = 2 * n_layers * n_kv_heads * d_head * ctx_len * (kv_quant_bits/8) / 1024**3
    overhead_gb = max(0.5, weights_gb * 0.05)
    return weights_gb + kv_gb + overhead_gb
```

Example usage: call `estimate_vram(8, 4, 32, 8, 128, 8192)` for Llama 3 8B at Q4_K_M with 8K context. Model config values (n_layers, n_kv_heads, d_head) can be retrieved from the model's `config.json` on Hugging Face under `num_hidden_layers`, `num_key_value_heads`, and `hidden_size / num_attention_heads`.

### Retrieving model config from Hugging Face

```python
from transformers import AutoConfig
config = AutoConfig.from_pretrained("meta-llama/Meta-Llama-3-8B")
n_layers = config.num_hidden_layers
n_kv_heads = getattr(config, "num_key_value_heads", config.num_attention_heads)
n_heads = config.num_attention_heads
d_head = config.hidden_size // n_heads
```

### Calculator examples

| Model | Params | Quant | Layers | KV Heads | d_head | Context | Est. VRAM |
|-------|--------|-------|--------|----------|--------|---------|-----------|
| Llama 3.1 8B | 8B | Q4_K_M (4-bit) | 32 | 8 | 128 | 8K | 5.5 GB |
| Llama 3.1 70B | 70B | Q4_K_M (4-bit) | 80 | 8 | 128 | 8K | 45.5 GB |
| Qwen 2.5 32B | 32B | Q4_K_M (4-bit) | 64 | 8 | 128 | 8K | 21.5 GB |
| DeepSeek V2 | 236B | Q4_K_M (4-bit) | 60 | 16 | 128 | 8K | 24 GB* |

*MoE models only load active parameters; figure based on ~32B active.

## 10. Memory Optimization Tips

- Use Q4_K_M as minimum for quality-sensitive tasks
- Use Q4_0 or Q3_K_M for memory-constrained scenarios
- Quantize KV cache to Q8_0 or Q4_0 to reduce its footprint by 50-75%
- Use flash attention to reduce activation memory
- Reduce context length for memory-constrained environments
- Use CPU offloading for layers that don't fit in VRAM
- Close other GPU-using applications before inference
- Consider model with fewer layers (smaller model)
- For MoE models, only active parameters are loaded, making them more memory-efficient than dense models of equivalent total parameter count

## 11. Batch Size Effects on Memory

For serving multiple concurrent requests, each additional request in a batch adds its own KV cache and activation memory. The batch multiplier affects:

- KV cache: grows linearly with batch size (each sequence needs its own KV cache)
- Activation memory: grows linearly with batch size
- Model weights: unchanged (shared across batch)

```
batch_vram = model_weights + kv_cache * batch_size + activations * batch_size + overhead
```

For example, serving Llama 3 8B Q4_K_M with batch size 4 at 8K context:
- Weights: 4.5 GB
- KV cache: 1.0 GB * 4 = 4.0 GB
- Overhead: 0.5 GB
- Total: ~9.0 GB (vs 6.0 GB for batch size 1)

This is why production serving systems use continuous batching and PagedAttention (vLLM) to minimize wasted memory across variable-length sequences.

## 12. Flash Attention Memory Savings

Flash Attention (Dao et al., 2022) tiles the attention computation so that the full N x N attention matrix is never materialized in HBM. Memory savings are most significant for:

- Long context sequences (32K+): standard attention requires O(N^2) memory while flash attention requires O(N)
- Large batch sizes: each sequence's attention matrix is computed in tiles
- Training: the backward pass benefits even more than inference

Typical memory reduction from Flash Attention: 2-5x for long contexts. Combined with KV cache quantization, this enables context lengths that would otherwise require multi-GPU setups on a single GPU.
