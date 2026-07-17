# LLM Benchmarking Methodology

## 1. Why Benchmark?

Benchmarking is the practice of measuring LLM performance in a controlled, repeatable manner. Without benchmarking, deployment decisions are based on intuition and marketing claims rather than empirical data.

### Goals of Benchmarking

- **Measure inference speed**: Determine whether a model meets latency requirements for your application (real-time chat requires 5+ t/s; batch processing can tolerate lower).
- **Compare quantization quality**: Quantization saves memory and speeds up inference but degrades output quality. Benchmarking quantifies the tradeoff.
- **Validate hardware utilization**: Ensure your GPU is being fully utilized (GPU utilization, memory bandwidth saturation).
- **Optimize deployment configuration**: Test thread counts, batch sizes, GPU layers, context lengths to find optimal settings.
- **Track regressions across versions**: When you update llama.cpp, change drivers, or switch model versions, benchmarks detect performance changes.

## 2. Types of Benchmarks

### Speed Benchmarks

- **Generation speed (tokens per second)**: Number of output tokens generated per second during the decode phase. The primary metric for real-time applications.
- **Prompt processing speed (tokens per second)**: Number of input tokens processed per second during the prefill phase. Important for RAG and long-context applications.
- **Time to first token (TTFT)**: Latency from submission to first output token. Critical for interactive applications; affects perceived responsiveness.

### Quality Benchmarks

- **Perplexity (PPL)**: A measure of how well the model predicts a test corpus. Lower is better. Useful for comparing quantization levels against an unquantized baseline.
- **Task-specific evaluations**: Standardized benchmarks (MMLU, GSM8K, HumanEval, HellaSwag) measure specific capabilities. Compare scores between quantized and unquantized models to detect quality degradation.
- **Human evaluation**: The gold standard. Have human raters compare outputs from different models or configurations. Expensive but irreplaceable for creative and open-ended tasks.

### Memory Benchmarks

- **Peak VRAM usage**: Maximum GPU memory consumed during inference. Determines whether a model fits on your hardware.
- **Peak RAM usage**: System memory used, especially for CPU layers and overhead.
- **Model load time**: Time to load the model weights from disk into memory. Important for serverless or cold-start scenarios.

### Throughput Benchmarks

- **Requests per second**: Number of inference requests handled per second under concurrent load.
- **Concurrent users**: Maximum number of simultaneous users before quality-of-service degrades.
- **Batch efficiency**: Tokens per second per user under continuous batching.

## 3. Speed Benchmarking

### Tools

- **llama-bench**: Built into llama.cpp. The most widely used tool for benchmarking llama.cpp-based deployments. Provides consistent, reproducible measurements.
- **Custom scripts with time/perf**: For custom inference stacks or non-llama.cpp deployments.
- **Python with transformers + timeit**: For Hugging Face Transformers-based inference. Less precise than llama-bench due to Python overhead.
- **vLLM benchmarking scripts**: vLLM includes benchmarking tools for throughput and latency under continuous batching.

### Key Metrics

- **Prompt processing speed (tokens/sec)**: How fast the model reads your input. Measured as `(prompt_tokens) / (prefill_time)`.
- **Generation speed (tokens/sec)**: How fast the model generates output. Measured as `(generated_tokens) / (decode_time)`.
- **Time to first token (ms)**: Latency before first output token. Calculated as `(time_to_first_token - request_submit_time)`.

### Methodology

For reproducible speed benchmarks, follow this protocol:

1. Fixed prompt length: 512 tokens (pad or truncate to this length)
2. Fixed generation length: 256 tokens (set `n_predict` to this value)
3. Multiple runs: minimum 5 runs for statistical significance
4. Report: mean, median, min, max, standard deviation
5. Warm-up runs: 2 warm-up runs before measurement (cold cache can skew results)
6. Document all configuration parameters (see reporting section)

### Example Benchmark Runs Table

| Model | Quant | GPU Layers | Prompt t/s | Gen t/s | TTFT (ms) |
|-------|-------|------------|------------|---------|-----------|
| Llama 3.1 8B | Q4_K_M | 33/33 | 1250 | 85 | 45 |
| Llama 3.1 8B | Q8_0 | 33/33 | 1100 | 62 | 52 |
| Qwen 2.5 32B | Q4_K_M | 49/49 | 450 | 28 | 120 |
| DeepSeek V2 | Q4_K_M | 62/62 | 380 | 22 | 180 |
| Llama 3.1 70B | Q4_K_M | 80/80 | 180 | 12 | 310 |
| Qwen 2.5 72B | Q4_K_M | 80/80 | 160 | 10 | 350 |
| Mixtral 8x7B | Q4_K_M | 32/32 | 520 | 35 | 95 |
| Gemma 2 9B | Q4_K_M | 42/42 | 890 | 55 | 60 |

### Controlling Variables

- **Context length**: Fixed across all runs. Longer contexts increase TTFT and reduce generation speed.
- **Batch size**: 1 for single-user benchmarks; higher for throughput testing.
- **Thread count**: Total threads used. Typically `n_threads` should not exceed the number of physical cores minus 1-2 for system overhead.
- **GPU vs CPU layers**: Document how many layers are offloaded to GPU (`n_gpu_layers`).
- **Temperature**: Use 1.0 for deterministic comparisons (but note that top-k/top-p still introduce randomness — see seed).
- **Random seed**: Use a fixed seed (e.g., 42) for reproducibility. Without a fixed seed, sampling noise will vary between runs.
- **Flash attention**: Note whether flash attention is enabled. It can significantly change speed, especially at long contexts.
- **Backend**: Metal (Apple), CUDA (NVIDIA), Vulkan (cross-platform), SYCL (Intel). Different backends have different performance characteristics.

## 4. Quality Benchmarking

### Perplexity (PPL)

Perplexity measures how well the model predicts a test corpus. It is the exponentiated average negative log-likelihood per token. Lower is better.

**Using llama-perplexity**:
```
./llama-perplexity -m model.gguf -f test.txt
```

**Methodology**:
1. Prepare a test corpus of ~1M tokens representative of your domain
2. Measure perplexity on the unquantized FP16 model (baseline)
3. Measure perplexity on each quantized variant
4. Compare PPL increase vs baseline

**Acceptable PPL increase thresholds**:
| Quant Type | PPL Increase vs FP16 |
|------------|----------------------|
| Q8_0 | < 1% |
| Q6_K | < 3% |
| Q5_K_M | < 5% |
| Q4_K_M | < 5-10% |
| Q4_0 | < 10% |
| Q3_K_M | < 15% |
| Q2_K | < 25% |

### Task-Specific Evaluations

Use `lm-evaluation-harness` (EleutherAI) for standardized benchmarks.

**Installation**:
```
pip install lm-eval
```

**Basic usage**:
```
lm_eval --model hf \
  --model_args pretrained=model_name,trust_remote_code=True \
  --tasks mmlu,gsm8k,hellaswag \
  --num_fewshot 5 \
  --batch_size auto
```

**Key tasks**:

| Task | What It Measures | Typical Max | Relevance |
|------|-----------------|-------------|-----------|
| MMLU | Knowledge across 57 subjects | 90%+ (GPT-4) | General knowledge |
| GSM8K | Grade-school math word problems | 95%+ | Mathematical reasoning |
| HumanEval | Code generation from docstrings | 90%+ | Coding ability |
| HellaSwag | Commonsense reasoning | 95%+ | Everyday reasoning |
| TruthfulQA | Truthfulness and misconception resistance | 90%+ | Factual accuracy |
| ARC-Challenge | Grade-school science questions | 90%+ | Scientific reasoning |

### Quality Degradation Table (Example: Llama 3.1 8B)

| Quant Type | PPL Increase | MMLU Drop | GSM8K Drop |
|------------|-------------|-----------|------------|
| Q8_0 | +0.1% | -0.2% | -0.1% |
| Q6_K | +0.3% | -0.5% | -0.3% |
| Q5_K_M | +0.5% | -0.8% | -0.5% |
| Q4_K_M | +1.0% | -1.5% | -1.2% |
| Q4_0 | +2.0% | -3.0% | -2.5% |
| Q3_K_M | +5.0% | -8.0% | -6.0% |
| Q2_K | +15.0% | -20.0% | -15.0% |

**Important caveat**: These values are model-specific. A different base model may show larger or smaller degradation at the same quant level. Always benchmark your specific model.

## 5. Memory Benchmarking

### VRAM Measurement

```
nvidia-smi --query-gpu=memory.used,memory.total --format=csv -l 1
```

For precise peak tracking, log memory at 100ms intervals:
```
nvidia-smi --query-gpu=memory.used --format=csv -lms 100 > vram_log.csv
```

### Peak Memory Tracking

- **Model weights**: The base memory footprint of the loaded model.
- **KV cache**: Grows with context length and batch size. For a model with `n_layers` layers, `n_heads` attention heads, `d_head` head dimension, and batch size 1, KV cache per token is approximately `2 * n_layers * n_heads * d_head` elements (2 for key and value) stored at the quantization precision.
- **Overhead**: Inference framework overhead (buffers, intermediate tensors, Python runtime).

### Model Load Time

Measure from the start of model loading to the first inference call. This matters for serverless deployments where models are loaded on-demand.

### Memory Formula Validation

Expected memory for model weights:
```
Model Memory (GB) = Parameters * Bytes Per Parameter
  - FP16: 2 bytes per parameter
  - Q8_0: 1 byte per parameter
  - Q4_K_M: ~0.5 bytes per parameter (variable due to block quantization)
```

Example: Llama 3.1 70B at Q4_K_M: 70B * 0.5 bytes = ~35 GB for weights + ~2-4 GB for KV cache at 4096 context.

### Memory Comparison Table

| Model | FP16 | Q8_0 | Q5_K_M | Q4_K_M | Q3_K_M | Q2_K |
|-------|------|------|--------|--------|--------|------|
| Llama 3.1 8B | 16 GB | 8 GB | 5.5 GB | 4.5 GB | 3.5 GB | 2.5 GB |
| Qwen 2.5 7B | 14 GB | 7 GB | 4.8 GB | 4.0 GB | 3.0 GB | 2.2 GB |
| Llama 3.1 70B | 140 GB | 70 GB | 48 GB | 39 GB | 30 GB | 22 GB |
| Qwen 2.5 72B | 144 GB | 72 GB | 50 GB | 40 GB | 31 GB | 23 GB |
| Mixtral 8x7B | 56 GB | 28 GB | 20 GB | 16 GB | 12 GB | 9 GB |
| Qwen 2.5 32B | 64 GB | 32 GB | 22 GB | 18 GB | 14 GB | 10 GB |

Note: Actual memory usage will be 10-20% higher than weights alone due to KV cache, overhead, and intermediate buffers.

## 6. Throughput Benchmarking

### Using llama-server with Continuous Batching

```
./llama-server -m model.gguf -ngl 80 -c 4096 --cont-batching -np 8
```

The `--cont-batching` flag enables continuous batching, which improves throughput under concurrent load.

### Load Testing with Custom Scripts

Use tools like `oha`, `wrk`, or custom Python scripts using `aiohttp` to send concurrent requests. The `llama-server` metrics endpoint provides real-time statistics.

### vLLM Benchmarking

vLLM provides built-in benchmarking:
```
python -m vllm.entrypoints.openai.benchmarks.benchmark_serving \
  --model model_name \
  --dataset sharegpt \
  --num-prompts 1000
```

### Key Throughput Metrics

- **Requests per second**: Total completed requests divided by elapsed time.
- **Tokens per second (aggregate)**: Total generated tokens divided by elapsed time across all concurrent requests.
- **Latency percentiles (p50, p95, p99)**: Distribution of per-request latency. p95 and p99 are critical for SLA compliance.
- **Inter-token latency variance**: Variability in time between tokens. High variance leads to a choppy user experience.

## 7. Automation Scripts

### Full Benchmark Suite Template (benchmark.sh)

```bash
#!/bin/bash
# LLM Benchmark Suite
# Usage: ./benchmark.sh /path/to/models/dir

MODEL_DIR="${1:-./models}"
RESULTS_DIR="./benchmark_results"
DATE=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="${RESULTS_DIR}/benchmark_${DATE}.csv"

mkdir -p "${RESULTS_DIR}"

echo "model,quant,gpu_layers,prompt_tokens,gen_tokens,prompt_tps,gen_tps,ttft_ms,ppl" > "${RESULTS_FILE}"

for MODEL in "${MODEL_DIR}"/*.gguf; do
  MODEL_NAME=$(basename "${MODEL}" .gguf)
  echo "Benchmarking ${MODEL_NAME}..."

  # Extract quant from filename (assumes format: ModelName-Q4_K_M-*.gguf)
  QUANT=$(echo "${MODEL_NAME}" | grep -oE 'Q[0-9]_(K_[A-Z]|0|8_0)')

  # Speed benchmark
  ./llama-bench \
    -m "${MODEL}" \
    -p 512 \
    -n 256 \
    -ngl 99 \
    -t 8 \
    -r 5 \
    -o csv \
    >> "${RESULTS_FILE}"

  # Perplexity benchmark
  PPL=$(./llama-perplexity \
    -m "${MODEL}" \
    -f ./test_corpus.txt \
    -ngl 99 \
    2>&1 | grep -oP 'PPL = \K[0-9.]+')

  # Append PPL to the last line in CSV
  sed -i '' '$s/$/,'"${PPL}"'/' "${RESULTS_FILE}"
done

echo "Results saved to ${RESULTS_FILE}"
```

### Python Report Generator

```python
#!/usr/bin/env python3
import csv
import sys

def generate_report(csv_file):
    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    print("# LLM Benchmark Report")
    print()
    print(f"Source: {csv_file}")
    print()

    for row in rows:
        print(f"## {row['model']} ({row['quant']})")
        print()
        print(f"| Metric | Value |")
        print(f"|--------|-------|")
        print(f"| GPU Layers | {row['gpu_layers']} |")
        print(f"| Prompt t/s | {row['prompt_tps']} |")
        print(f"| Gen t/s | {row['gen_tps']} |")
        print(f"| TTFT (ms) | {row['ttft_ms']} |")
        print(f"| Perplexity | {row['ppl']} |")
        print()

if __name__ == '__main__':
    generate_report(sys.argv[1])
```

### CI/CD Integration

Add benchmark regression detection to your CI pipeline:

1. Run benchmark suite on every release of your inference stack
2. Store historical results (e.g., in a JSON file committed to the repo)
3. Compare current results against the last known good baseline
4. Fail CI if any metric degrades beyond a threshold (e.g., gen t/s drops by more than 10%)
5. Generate a comparison report as a CI artifact

## 8. Reporting Results

### CSV Format for Easy Analysis

```
timestamp,model,quant,gpu_layers,prompt_tokens,gen_tokens,prompt_tps,gen_tps,ttft_ms,ppl,hardware
2025-01-15T14:30:00,llama-3.1-8b,Q4_K_M,33/33,512,256,1250,85,45,6.23,RTX4090
```

### Markdown Tables for Human Reading

| Model | Quant | Prompt t/s | Gen t/s | TTFT (ms) | PPL | PPL Increase |
|-------|-------|------------|---------|-----------|-----|-------------|
| Llama 3.1 8B | FP16 | 950 | 52 | 55 | 6.20 | Baseline |
| Llama 3.1 8B | Q8_0 | 1100 | 62 | 52 | 6.21 | +0.1% |
| Llama 3.1 8B | Q4_K_M | 1250 | 85 | 45 | 6.26 | +1.0% |
| Llama 3.1 8B | Q3_K_M | 1400 | 102 | 38 | 6.51 | +5.0% |

### Charts

Use matplotlib or gnuplot to generate visualizations:
- Bar charts comparing gen t/s across quants (speed vs quality)
- Line charts showing PPL increase vs quantization level
- Scatter plots of gen t/s vs PPL increase (Pareto frontier)

### What to Include in Every Benchmark Report

1. **Date and time** of the benchmark run
2. **Hardware specifications**: GPU model(s), CPU model, RAM, storage type
3. **Software versions**: llama.cpp commit hash (or version), CUDA version, driver version, OS version
4. **Model metadata**: Model name, quant type, file size, source URL
5. **All configuration parameters**: Prompt length, generation length, GPU layers, thread count, batch size, context length, flash attention enabled/disabled, backend
6. **Results with statistical measures**: Mean, median, min, max, standard deviation for each metric
7. **Comparison baseline**: Unquantized (FP16) or previous run for regression detection

## 9. Benchmarking Best Practices

### Always Include an Unquantized Baseline

Without a baseline, you cannot measure the cost of quantization. Run benchmarks on the FP16 model first, even if it does not fit in your target hardware. This provides the quality ceiling and speed floor.

### Use Consistent Test Hardware

Do not compare benchmarks across different GPU models, driver versions, or inference backends. Even the same GPU model with different thermal environments can produce different results. Document everything.

### Close Background Processes

Background processes consume GPU memory, CPU cycles, and memory bandwidth. Before running benchmarks:
```
pkill -f nvidia-smi   # stop monitoring tools
sudo systemctl stop snapd  # stop background services
```

### Pin CPU Frequency (for Reproducible Results)

CPU frequency scaling introduces variability in prompt processing (which is CPU-bound for the prefill phase on some configurations). Pin frequency:
```
sudo cpupower frequency-set --governor performance
sudo cpupower frequency-set --min 2.5GHz --max 2.5GHz
```

### Use a Fixed Random Seed

Without a fixed seed, sampling introduces noise into generation speed (different tokens have different computational cost) and quality metrics.
```
--seed 42
```

### Run at Least 3-5 Iterations

A single run is not statistically significant. Report mean and standard deviation across multiple runs. For critical benchmarks, use 10+ iterations.

### Report Both Prompt Processing and Generation Speeds

Both metrics matter for different use cases. RAG applications care more about prompt processing speed. Chat applications care more about generation speed. Always report both.

### Include Confidence Intervals

For the mean of each metric, report the 95% confidence interval. This tells readers how reliable your measurements are.

### Share Full Configuration, Not Just Results

A benchmark result without configuration is useless. Include every parameter that could affect performance in your report.

## 10. Troubleshooting Benchmarks

### Inconsistent Results Between Runs

| Likely Cause | Solution |
|-------------|----------|
| Thermal throttling | Check GPU/CPU temperatures during runs. Ensure adequate cooling. Run shorter benchmarks. |
| Background processes | Close all non-essential processes. Use a dedicated benchmarking environment. |
| Power management | Set GPU to maximum performance mode: `nvidia-smi -pm 1`; `nvidia-smi -pl 300` (set power limit). |
| Memory bandwidth contention | Do not run other memory-intensive applications during benchmarks. |
| CPU frequency scaling | Pin CPU frequency or run multiple iterations and report median. |

### Unusually Slow Performance

| Likely Cause | Solution |
|-------------|----------|
| Not enough GPU layers | Increase `--n-gpu-layers` to offload more layers to GPU. |
| Wrong thread count | Set `--threads` to the number of physical CPU cores (not logical/hyperthreaded). |
| CPU-only fallback | Verify that GPU layers are actually being offloaded (check llama.cpp logs for "offloading X layers to GPU"). |
| Swap thrashing | Reduce context length or model size. Ensure you have enough RAM. |
| Lack of flash attention | Enable flash attention for long contexts (`--flash-attn`). |

### VRAM Out of Memory

| Solution | Description |
|----------|-------------|
| Reduce context length | KV cache scales linearly with context length. Halving context halves KV cache memory. |
| Reduce GPU layers | Offload fewer layers to GPU. Remaining layers run on CPU (slower but fits). |
| Use higher quantization | Going from Q4 to Q3 reduces model weight memory by ~25%. |
| Use split mode | For multi-GPU, use `--tensor-split` to distribute across GPUs. |
| Use memory mapping | `--mlock` prevents swapping; without it, OS can page memory (but may slow down). |

### Non-Deterministic Output

| Cause | Solution |
|-------|----------|
| Sampling with temperature != 0 | Use `--temp 0.0` or `--temp 0` for deterministic output. |
| No fixed seed | Use `--seed 42` (or any fixed value). |
| GPU nondeterminism | CUDA operations are not strictly deterministic. For exact reproducibility, use CPU inference. |
| Flash attention variance | Flash attention may introduce minor numerical differences across runs. Accept small variance. |
