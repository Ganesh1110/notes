# Hardware Recommendation Tables

## 1. GPU-to-Model Mapping

Real-world recommendations for common GPUs. Assumes Q4_K_M GGUF quantization and 8K context unless noted.

| GPU | VRAM | Max Model (Q4) | Recommended Models | Est. Gen t/s |
|-----|------|----------------|--------------------|--------------|
| RTX 3050 / RTX 4050 | 6 GB | 7B @ Q4_K_M | Llama 3.1 8B, Mistral 7B, Qwen 2.5 7B | 15-25 |
| RTX 3060 12GB | 12 GB | 13B @ Q4_K_M | Qwen 2.5 14B, Mistral 7B @ Q6_K, Gemma 2 9B @ Q5 | 30-50 |
| RTX 4060 Ti 16GB | 16 GB | 20B @ Q4_K_M | Qwen 2.5 14B @ Q5, Gemma 2 27B @ Q4, Phi-4 @ Q6 | 35-55 |
| RTX 3070 / RTX 4070 | 8 GB | 7B @ Q4_K_M | Llama 3.1 8B @ Q5, Mistral 7B @ Q6, Qwen 2.5 7B @ Q5 | 40-65 |
| RTX 3080 / RTX 4080 | 12 GB | 13B @ Q4_K_M | Same as 3060 12GB but faster | 60-90 |
| RTX 3080 Ti / RTX 4080 Ti | 16 GB | 20B @ Q4_K_M | Same as 4060 Ti 16GB but faster | 65-100 |
| RTX 3090 | 24 GB | 32B @ Q4_K_M | Qwen 2.5 32B, Llama 3.1 70B @ Q3_K_M, Mixtral 8x7B @ Q5 | 50-80 |
| RTX 4090 | 24 GB | 32B @ Q4_K_M | Qwen 2.5 32B, Llama 3.1 70B @ Q3_K_M, Mixtral 8x22B @ Q4 | 80-140 |
| RTX 5090 | 32 GB | 70B @ Q4_K_M | Llama 3.1 70B, Qwen 2.5 72B, DeepSeek V3 @ Q4 | 60-100 |
| RTX 6000 Ada | 48 GB | 70B @ Q5_K_M | Llama 3.1 70B @ Q5, Qwen 2.5 72B @ Q5 | 70-110 |
| A100 40GB | 40 GB | 70B @ Q4_K_M | Llama 3.1 70B, DeepSeek V3, Mixtral 8x22B @ Q5 | 100-180 |
| A100 80GB | 80 GB | 70B @ Q8_0 | Llama 3.1 70B @ Q8, DeepSeek R1 @ Q4, 405B @ Q3 | 120-200 |
| Dual A100 80GB | 160 GB | 405B @ Q4_K_M | Llama 3.1 405B, DeepSeek R1 @ Q5 | 80-150 |
| H100 80GB | 80 GB | 405B @ Q3_K_M | Llama 3.1 405B @ Q4, all smaller models @ FP8 | 150-300 |
| 8x A100 80GB | 640 GB | 405B @ FP16 | Any open-weight model at full precision | 500+ |

## 2. CPU-Only Inference

| CPU | RAM | Max Model | Quant | Est. Gen t/s |
|-----|-----|-----------|-------|--------------|
| Apple M1 (8GB) | 8 GB | 3B @ Q4_K_M | Llama 3.2 3B, Phi-3 Mini, Qwen 2.5 3B | 10-20 |
| Apple M1 Max (32GB) | 32 GB | 13B @ Q4_K_M | Qwen 2.5 14B, Mistral 7B @ Q5 | 15-25 |
| Apple M2 Ultra (64GB) | 64 GB | 32B @ Q4_K_M | Qwen 2.5 32B, Llama 3.1 70B @ Q3_K_M | 20-35 |
| Apple M3 Max (48GB) | 48 GB | 32B @ Q5_K_M | Qwen 2.5 32B, Llama 3.1 70B @ Q3_K_M | 25-40 |
| Apple M4 Ultra (128GB) | 128 GB | 70B @ Q4_K_M | Llama 3.1 70B, Qwen 2.5 72B | 30-50 |
| Intel i9 + DDR5 (32GB) | 32 GB | 7B @ Q4_K_M | Llama 3.1 8B, Mistral 7B | 3-6 |
| AMD Ryzen 9 + DDR5 (64GB) | 64 GB | 13B @ Q4_K_M | Qwen 2.5 14B, Gemma 2 9B @ Q5 | 4-8 |
| Xeon + DDR5 (256GB) | 256 GB | 70B @ Q4_K_M | Llama 3.1 70B, Qwen 2.5 72B | 5-10 |

## 3. Memory Bands & Gen Speed

| Memory Type | BW (GB/s) | 7B Q4 t/s | 32B Q4 t/s | 70B Q4 t/s |
|-------------|-----------|-----------|------------|------------|
| DDR4-3200 | 25 | 1-2 | 0.3-0.5 | 0.1-0.2 |
| DDR5-6000 | 55 | 3-5 | 0.8-1.2 | 0.3-0.5 |
| Apple M1 (unified) | 70 | 8-12 | 2-3 | 0.5-1 |
| Apple M2 (unified) | 100 | 12-18 | 3-4 | 1-1.5 |
| Apple M3 (unified) | 150 | 18-25 | 4-6 | 1.5-2.5 |
| Apple M4 (unified) | 200 | 25-35 | 6-9 | 2.5-4 |
| RTX 4060 (GDDR6) | 280 | 35-55 | 8-12 | 4-6 |
| RTX 3090 (GDDR6X) | 936 | 50-80 | 12-18 | 5-8 |
| RTX 4090 (GDDR6X) | 1008 | 80-140 | 20-35 | 10-15 |
| A100 80GB (HBM2e) | 2039 | 100-180 | 30-50 | 15-25 |
| H100 (HBM3) | 3350 | 150-300 | 50-80 | 25-50 |

## 4. Multi-GPU Configurations

| Config | Effective VRAM | Max Model |
|--------|---------------|-----------|
| 2x RTX 3090 (NVLink) | 48 GB | 70B @ Q5_K_M, 32B @ Q8_0 |
| 2x RTX 4090 | 48 GB | 70B @ Q5_K_M, 405B @ Q2_K |
| 2x A100 80GB | 160 GB | 405B @ Q4_K_M, DeepSeek R1 @ Q5 |
| 4x RTX 3090 | 96 GB | 70B @ Q8_0, 405B @ Q3_K_M |
| 4x A100 80GB | 320 GB | 405B @ Q8_0, DeepSeek R1 @ Q8 |
| 8x A100 80GB | 640 GB | 405B @ FP16, any model full precision |

## 5. Context Length Impact on Memory

Additional VRAM needed for KV cache at different context lengths (FP16 KV cache):

| Model | 4K | 8K | 16K | 32K | 64K | 128K |
|-------|-----|-----|------|------|------|-------|
| 7-8B (32L, 8 KV heads) | 0.5 GB | 1.0 GB | 2.0 GB | 4.0 GB | 8.0 GB | 16 GB |
| 14B (40L, 8 KV heads) | 0.6 GB | 1.3 GB | 2.5 GB | 5.0 GB | 10 GB | 20 GB |
| 32B (64L, 8 KV heads) | 1.0 GB | 2.0 GB | 4.0 GB | 8.0 GB | 16 GB | 32 GB |
| 70B (80L, 8 KV heads) | 1.3 GB | 2.5 GB | 5.0 GB | 10 GB | 20 GB | 40 GB |
| 405B (126L, 8 KV heads) | 2.0 GB | 4.0 GB | 8.0 GB | 16 GB | 32 GB | 64 GB |

With Q8_0 KV cache quantization, halve all values. With Q4_0 KV cache, divide by 4.

## 6. Minimum System Recommendations

### By Model Size

| Model Size | Min RAM | Min VRAM (GPU) | Min Disk | Recommended CPU |
|------------|---------|----------------|----------|-----------------|
| 1-3B | 8 GB | 4 GB | 10 GB | Any 4+ cores |
| 7-8B | 16 GB | 8 GB | 25 GB | 6+ cores |
| 14-20B | 32 GB | 12 GB | 50 GB | 8+ cores |
| 32B | 32 GB | 16 GB | 80 GB | 8+ cores |
| 70B | 64 GB | 24 GB | 150 GB | 12+ cores |
| 405B | 256 GB | 80 GB+ | 1 TB | 32+ cores |

### By Task

| Task | Min RAM | Min VRAM | Recommended GPU |
|------|---------|----------|-----------------|
| Chat (7B Q4) | 16 GB | 6 GB | RTX 3060 12GB |
| Chat (70B Q4) | 32 GB | 24 GB | RTX 4090 24GB |
| Code (small) | 16 GB | 8 GB | RTX 4060 Ti 16GB |
| Code (large) | 64 GB | 24 GB | RTX 4090 / A5000 |
| RAG (long context) | 32 GB | 16 GB | RTX 4090 (fast) |
| Fine-tuning (7B QLoRA) | 32 GB | 16 GB | RTX 4090 |
| Fine-tuning (70B QLoRA) | 128 GB | 48 GB | A6000 / A100 |
| Batch serving | 64 GB | 48 GB | A100 / H100 |

## 7. Power & Thermal Considerations

| GPU | TDP | PSU Min | Cooling |
|-----|-----|---------|---------|
| RTX 3060 12GB | 170W | 550W | Open air |
| RTX 4060 Ti 16GB | 160W | 550W | Open air |
| RTX 3090 | 350W | 750W | Good airflow |
| RTX 4090 | 450W | 850W | Excellent airflow |
| RTX 5090 | 575W | 1000W | Liquid recommended |
| A100 80GB | 400W | 1000W | Server cooling |
| H100 | 700W | 1500W | Server / liquid |
| Dual 4090 | 900W | 1200W | Liquid recommended |

Sustained inference keeps GPUs at high utilization for hours. Ensure adequate cooling to prevent thermal throttling.
