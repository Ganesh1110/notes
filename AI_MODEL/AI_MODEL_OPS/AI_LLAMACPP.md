# llama.cpp — Build, Configure, and Use

## 1. What is llama.cpp?

llama.cpp is a high-performance C++ inference engine for large language models. Originally created to run LLaMA models on consumer hardware, it has become the de-facto standard for local LLM inference.

### Key Design Principles

- **CPU-first**: Optimized for CPU inference with SIMD acceleration (AVX2, NEON, SVE)
- **GPU backends**: Supports CUDA, Metal, Vulkan, ROCm, OpenCL, and SYCL
- **GGUF format**: Native support for GGUF-quantized models
- **Minimal dependencies**: Builds with a C++ compiler and standard libraries
- **Cross-platform**: Runs on macOS, Linux, Windows, FreeBSD, and even mobile devices

### Supported Platforms

| Platform | GPU Backend | CPU Optimization |
|----------|-------------|------------------|
| macOS    | Metal       | NEON (Apple Silicon), AVX2 (Intel) |
| Linux    | CUDA, Vulkan, ROCm, SYCL | AVX2, AVX512, NEON (ARM) |
| Windows  | CUDA, Vulkan | AVX2, AVX512 |
| FreeBSD  | None        | AVX2 |
| Android  | Vulkan      | NEON |

---

## 2. Building llama.cpp

### Clone the Repository

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
```

### Build Options Reference

| Build Flag | Backend | Dependencies | Platform |
|------------|---------|--------------|----------|
| `make -j` | CPU only | None | All |
| `LLAMA_CUDA=1 make -j` | NVIDIA CUDA | CUDA Toolkit, NVIDIA driver | Linux, Windows |
| `LLAMA_METAL=1 make -j` | Apple Metal | Xcode CLI tools, macOS 12+ | macOS |
| `LLAMA_VULKAN=1 make -j` | Vulkan | Vulkan SDK, Vulkan driver | Linux, Windows |
| `LLAMA_HIPBLAS=1 make -j` | AMD ROCm | ROCm stack | Linux |
| `LLAMA_CLBLAST=1 make -j` | OpenCL | OpenCL SDK | Linux, Windows, macOS |
| `LLAMA_SYCL=1 make -j` | Intel SYCL | Intel oneAPI | Linux |

### Simple Make Build (CPU Only)

```bash
make -j
```

This produces the following executables in the build directory:
- `llama-cli` (or `main` on older builds)
- `llama-quantize` (or `quantize`)
- `llama-server` (or `server`)
- `llama-perplexity`
- `llama-embedding`
- `llama-bench`

### Make Build with CUDA

```bash
LLAMA_CUDA=1 make -j
```

Requires CUDA Toolkit to be installed. Set `CUDA_PATH` if the toolkit is in a non-standard location.

### Make Build with Metal (macOS)

```bash
LLAMA_METAL=1 make -j
```

Requires Xcode command line tools. Metal is only available on macOS 12+.

### Make Build with Vulkan

```bash
LLAMA_VULKAN=1 make -j
```

Requires the Vulkan SDK and drivers for your GPU.

### Make Build with AMD ROCm

```bash
LLAMA_HIPBLAS=1 make -j
```

Requires ROCm to be installed. Tested primarily on Linux with AMD RX 7900 series and MI-series GPUs.

### CMake Build (Recommended for Production)

```bash
cmake -B build
cmake --build build --config Release
```

### CMake with CUDA

```bash
cmake -B build -DLLAMA_CUDA=ON
cmake --build build --config Release
```

### CMake with Metal

```bash
cmake -B build -DLLAMA_METAL=ON
cmake --build build --config Release
```

### CMake with Vulkan

```bash
cmake -B build -DLLAMA_VULKAN=ON
cmake --build build --config Release
```

### Docker Build

```bash
# CPU build
docker build -t llama-cpu .

# CUDA build
docker build -t llama-cuda -f .devops/llama-cuda.Dockerfile .

# Docker Compose (full stack)
docker compose up
```

### Verify Build

```bash
# Newer versions
./build/bin/llama-cli --help

# Older versions
./main --help
```

A successful build shows the full help text with all available flags.

---

## 3. Executable Reference

| Executable (new) | Executable (old) | Purpose |
|------------------|------------------|---------|
| `llama-cli` | `main` | Text generation with prompt |
| `llama-quantize` | `quantize` | Quantize GGUF models |
| `llama-perplexity` | `perplexity` | Perplexity evaluation |
| `llama-embedding` | `embedding` | Generate embeddings |
| `llama-server` | `server` | HTTP API server (OpenAI compatible) |
| `llama-bench` | `benchmark` | Performance benchmarking |
| `llama-train` | `train-text` | LoRA fine-tuning |
| `llama-simple` | `simple` | Minimal example |
| `llama-parallel` | `parallel` | Parallel generation example |
| `llama-imatrix` | `imatrix` | Importance matrix computation |
| Conversion scripts | `convert.py`, `convert_hf_to_gguf.py` | Convert Hugging Face models to GGUF |

### Conversion Scripts

```bash
# Convert a Hugging Face model to GGUF FP16 (Python 3 required)
python convert_hf_to_gguf.py /path/to/hf-model --outfile model.fp16.gguf

# Older conversion method
python convert.py /path/to/hf-model --outfile model.fp16.gguf
```

---

## 4. Text Generation with llama-cli

### Basic Command

```bash
./build/bin/llama-cli -m model.gguf -p "The meaning of life is" -n 256
```

This loads the model, processes the prompt, and generates 256 tokens.

### Full Parameter Reference

| Flag | Parameter | Default | Description |
|------|-----------|---------|-------------|
| `-m` | path | required | Path to GGUF model file |
| `-p` | string | (none) | Input prompt |
| `-n` | int | 512 | Number of tokens to generate (0 = infinite) |
| `-t` | int | CPU cores | Thread count |
| `-ngl` | int | 0 | GPU layers to offload (0 = CPU only, 99 = all) |
| `-c` | int | 512 | Context size |
| `-b` | int | 512 | Batch size for prompt processing |
| `-temp` | float | 0.80 | Temperature (0.0 = greedy, 2.0 = very random) |
| `-top_k` | int | 40 | Top-K sampling |
| `-top_p` | float | 0.90 | Top-P (nucleus) sampling |
| `-repeat_penalty` | float | 1.10 | Repeat penalty |
| `-repeat_last_n` | int | 64 | Last N tokens for repeat penalty |
| `-fa` | flag | off | Enable flash attention |
| `-ctk` | type | f16 | KV cache type for K (f16, q8_0, q4_0) |
| `-ctv` | type | f16 | KV cache type for V (f16, q8_0, q4_0) |
| `-s` | int | random | Random seed |
| `-i` | flag | off | Interactive mode |
| `-f` | path | (none) | Read prompt from file |
| `-tf` | path | (none) | Read tokens from file |
| `-ng` | int | -1 | No GPU (alternative to ngl=0) |
| `-lora` | path | (none) | LoRA adapter path |
| `--lora-base` | path | (none) | Base model path for LoRA |
| `-mu` | float | 0.0 | Mirostat (0=off, 1=static, 2=dynamic) |
| `-mt` | float | 5.0 | Mirostat tau |
| `-me` | float | 0.1 | Mirostat eta |
| `--grammar` | path | (none) | GBNF grammar file |
| `--grammar-penalize-num` | flag | off | Penalize numbers in grammar |
| `--mlock` | flag | off | Lock model in memory (prevents swapping) |
| `--no-mmap` | flag | off | Disable memory mapping |
| `--numa` | flag | off | Enable NUMA support |
| `--chat-template` | string | (none) | Chat template file or inline template |
| `--keep` | int | 0 | Tokens to keep from initial prompt |
| `--draft-model` | path | (none) | Draft model for speculative decoding |
| `--draft-n` | int | 5 | Draft tokens per step |
| `--draft-pp` | int | 10 | Draft prompt processing batch |
| `--draft-min` | float | 0.0 | Draft minimum probability |
| `--draft-max` | float | 1.0 | Draft maximum probability |

### Interactive Mode

```bash
./build/bin/llama-cli -m model.gguf -i -p "Hello, how are you?"
```

In interactive mode, the model generates a response and then waits for your next input. Type your response and press Enter. Use Ctrl+C or type "/bye" to exit.

### Conversation Mode with Chat Template

```bash
./build/bin/llama-cli -m model.gguf -i \
  -p "USER: What is the capital of France?\nASSISTANT:" \
  --chat-template llama3.1
```

The `--chat-template` flag applies the correct formatting for the model's conversation format.

### Example Commands

#### CPU-only inference on a 7B Q4_K_M model:

```bash
./build/bin/llama-cli -m llama-7b-q4_k_m.gguf \
  -p "Write a poem about AI." \
  -n 200 -t 8 -c 4096
```

#### GPU-accelerated inference:

```bash
./build/bin/llama-cli -m llama-7b-q4_k_m.gguf \
  -p "Explain quantum computing." \
  -n 500 -ngl 99 -t 4 -c 8192
```

#### Low-memory settings:

```bash
./build/bin/llama-cli -m llama-7b-q4_k_m.gguf \
  -p "Hello" \
  -n 100 -t 4 -c 2048 -b 128
```

#### With flash attention for long context:

```bash
./build/bin/llama-cli -m llama-7b-q4_k_m.gguf \
  -p "Summarize this document..." \
  -n 300 -c 32768 -fa
```

#### Deterministic output for testing:

```bash
./build/bin/llama-cli -m model.gguf \
  -p "1 + 1 =" \
  -n 10 -temp 0.0 -s 42
```

---

## 5. llama-server (HTTP API)

### Starting the Server

```bash
./build/bin/llama-server -m model.gguf --port 8080
```

Basic server that exposes an OpenAI-compatible API on port 8080.

### Server Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `--port` | 8080 | Port to listen on |
| `--host` | 127.0.0.1 | Host address |
| `-ngl`, `--n-gpu-layers` | 0 | GPU layers |
| `-c`, `--ctx-size` | 512 | Context size |
| `--cont-batching` | off | Enable continuous batching |
| `-b`, `--batch-size` | 512 | Batch size |
| `--no-mmap` | off | Disable memory mapping |
| `--mlock` | off | Lock memory |
| `--numa` | off | NUMA support |
| `--slots` | auto | Number of slots for concurrent requests |
| `--slot-save-path` | (none) | Path to save slot states |
| `--threads-http` | (none) | Threads for HTTP processing |
| `--metrics` | off | Enable Prometheus metrics endpoint |

### Endpoints

#### POST /completion

Text completion endpoint:

```bash
curl http://localhost:8080/completion \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "The theory of relativity",
    "n_predict": 100,
    "temperature": 0.7,
    "top_k": 40,
    "top_p": 0.9,
    "repeat_penalty": 1.1,
    "stream": false
  }'
```

Response:

```json
{
  "content": " was developed by Albert Einstein in 1905 and 1915...",
  "generation_settings": {
    "temperature": 0.7,
    "top_k": 40,
    "top_p": 0.9
  },
  "timings": {
    "prompt_n": 4,
    "predicted_n": 100,
    "prompt_ms": 120.5,
    "predicted_ms": 8500.3
  }
}
```

Streaming response (one token per line):

```
data: {"content": " was", "stop": false}
data: {"content": " developed", "stop": false}
data: {"content": " by", "stop": false}
data: {"content": " Albert", "stop": false}
data: {"content": " Einstein", "stop": true}
```

#### POST /chat/completions (OpenAI-compatible)

```bash
curl http://localhost:8080/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "What is the speed of light?"}
    ],
    "temperature": 0.7,
    "stream": false
  }'
```

Response:

```json
{
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "The speed of light in a vacuum is approximately 299,792,458 meters per second."
      },
      "index": 0
    }
  ],
  "usage": {
    "prompt_tokens": 18,
    "completion_tokens": 15,
    "total_tokens": 33
  }
}
```

#### POST /embedding

```bash
curl http://localhost:8080/embedding \
  -H "Content-Type: application/json" \
  -d '{
    "content": "The quick brown fox jumps over the lazy dog"
  }'
```

Response:

```json
{
  "embedding": [0.0123, -0.0456, ...]
}
```

#### GET /health

```bash
curl http://localhost:8080/health
```

Response: `{"status": "ok"}`

#### GET /slots

```bash
curl http://localhost:8080/slots
```

Returns information about the current slot state (for continuous batching).

### OpenAI API Compatibility

The llama-server `/chat/completions` endpoint is designed to be a drop-in replacement for the OpenAI API. You can use any OpenAI client library by pointing it to your llama-server URL:

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed"
)

response = client.chat.completions.create(
    model="default",
    messages=[
        {"role": "user", "content": "Hello!"}
    ]
)
print(response.choices[0].message.content)
```

### Multi-User Support with Slots

When `--cont-batching` is enabled, the server supports multiple concurrent requests using slots. Each slot processes one request at a time. If all slots are busy, new requests are queued.

```bash
./build/bin/llama-server -m model.gguf --cont-batching --slots 4
```

---

## 6. GPU Acceleration Details

### How Layer Offloading Works

The `-ngl N` flag offloads the first N transformer layers to the GPU. The remaining layers run on the CPU. This allows you to use GPU acceleration even when your model does not entirely fit in VRAM.

- `-ngl 0`: CPU only (no GPU)
- `-ngl 99`: Offload all layers to GPU
- `-ngl 20`: Offload 20 layers (partial offloading)

### Determining Optimal -ngl Value

1. Start with `-ngl 99` (all layers on GPU)
2. If you get an out-of-memory error, reduce by 10-20 layers
3. Monitor VRAM usage with `nvidia-smi -l 1`
4. The optimal value uses 80-90% of available VRAM

### Partial Offloading When VRAM is Limited

For a 70B model with 16GB VRAM, offloading partial layers can still provide significant speedup:

```bash
./build/bin/llama-cli -m 70b-model.gguf -ngl 30 -t 8 -c 4096
```

Even 20-30 layers on GPU can provide 2-3x speedup over pure CPU.

### CUDA Specifics

NVIDIA GPU compute capability requirements:

| Compute Capability | Supported Architectures |
|--------------------|------------------------|
| 5.2+ | Maxwell 2nd gen, Pascal, Volta, Turing, Ampere, Ada Lovelace, Hopper |
| 7.0+ | Volta, Turing, Ampere, Ada Lovelace, Hopper (better performance) |

Check your GPU compute capability: `nvidia-smi --query-gpu=compute_cap --format=csv`

### Metal Specifics (macOS)

Apple Silicon Macs (M1/M2/M3/M4) have unified memory, meaning the GPU and CPU share the same memory pool. This eliminates the need for data transfer between CPU and GPU, making partial offloading less critical.

For Intel Macs, Metal acceleration is available but with lower performance gains due to PCIe bandwidth limitations.

### Multi-GPU Support

Distribute model layers across multiple GPUs:

```bash
# Using tensor split
./build/bin/llama-cli -m model.gguf --tensor-split 8,8 -ngl 99
```

The `--tensor-split` flag distributes tensors across GPUs in the specified ratio. For two identical GPUs, use `--tensor-split 1,1`.

### Keeping KV Cache on CPU

Use `--no-kv-offload` to keep the KV cache on CPU even when using GPU acceleration:

```bash
./build/bin/llama-cli -m model.gguf -ngl 99 --no-kv-offload
```

This can reduce VRAM usage at the cost of some performance, useful for models with very large context windows.

### Monitoring GPU Usage

```bash
# Real-time GPU monitoring
nvidia-smi -l 1

# One-shot GPU info
nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv
```

For AMD GPUs:

```bash
rocm-smi --showuse
```

---

## 7. KV Cache Management

### Importance of KV Cache

The Key-Value (KV) cache stores the processed keys and values for all previous tokens in the context. This avoids recomputing them for each new token, making autoregressive generation efficient.

### Context Size Impact on Memory

Increasing `-c` (context size) directly increases KV cache memory:

```
Memory = 2 * n_layers * (n_heads * d_head) * context_size * dtype_size
```

Example for a 7B model (32 layers, 32 heads, 128 d_head):

| Context | FP16 KV Cache | Q8_0 KV Cache |
|---------|---------------|---------------|
| 2048    | 1.0 GB        | 0.5 GB        |
| 8192    | 4.0 GB        | 2.0 GB        |
| 32768   | 16.0 GB       | 8.0 GB        |
| 131072  | 64.0 GB       | 32.0 GB       |

### KV Cache Quantization

Reduce KV cache memory by using quantized cache types:

```bash
./build/bin/llama-cli -m model.gguf -c 8192 -ctk q8_0 -ctv q8_0
```

| Cache Type | Memory per Value | Quality Impact |
|------------|------------------|----------------|
| f16 (default) | 2 bytes | No quality loss |
| q8_0 | 1 byte | Minimal quality loss |
| q4_0 | 0.5 bytes | Slight quality loss at very long contexts |

### FP16 vs FP8 vs Q8_0 KV Cache

- **FP16**: Full precision, no quality impact, highest memory usage
- **FP8** (via `--fp8-kv` in newer versions): Good balance of memory and quality
- **Q8_0**: 8-bit quantization, minimal quality impact, significant memory savings
- **Q4_0**: 4-bit quantization, noticeable quality impact with very long contexts

---

## 8. Prompt Processing (Prefill)

### How Prompt Processing Works

When you send a prompt, llama.cpp performs a single forward pass through all prompt tokens in parallel (within batch size limits). This is called the "prefill" or "prompt evaluation" phase.

### Batch Size for Prompt Ingestion

The batch size (`-b`) controls how many prompt tokens are processed in parallel:

```bash
./build/bin/llama-cli -m model.gguf -p "long prompt..." -b 1024
```

- Larger batches: Faster prompt processing, more memory
- Smaller batches: Less memory, but slower for long prompts

### Prompt Caching Benefits

If you send the same prompt prefix repeatedly, the KV cache can be reused, dramatically speeding up subsequent requests. This is especially useful for:
- Chat applications with long system prompts
- Few-shot examples that remain constant
- Document QA where the document is the same

### Flash Attention for Long Prompts

Flash attention (`-fa`) reduces the memory complexity of attention from O(n^2) to O(n) for the prompt processing step:

```bash
./build/bin/llama-cli -m model.gguf -p "very long prompt..." -fa
```

Benefits:
- Processes longer prompts without OOM
- Faster prompt evaluation for sequences over 4096 tokens
- Minimal impact on generation quality

---

## 9. Benchmarking

### Using llama-bench

```bash
./build/bin/llama-bench -m model.gguf -p 512 -n 256 -t 8
```

This runs a benchmark with:
- Prompt of 512 tokens
- Generation of 256 tokens
- 8 CPU threads

### More Comprehensive Benchmark

```bash
./build/bin/llama-bench \
  -m model.gguf \
  -p 512 -n 256 \
  -t 4,8,16 \
  -ngl 0,99
```

This runs all combinations of 4/8/16 threads and CPU-only/full GPU.

### Interpreting Results

llama-bench reports four key metrics:

| Metric | Description | Good Value |
|--------|-------------|------------|
| **Load time** | Time to load model into memory | Under 10 seconds |
| **Prompt eval time** | Time to process the prompt | Under 10 seconds for 512 tokens |
| **Prompt eval rate** | Tokens per second during prompt processing | Over 100 t/s for 7B Q4 |
| **Generation time** | Time to generate output tokens | Depends on token count |
| **Generation rate** | Tokens per second during generation | 20+ t/s for interactive use |

### Comparing Different Quants

```bash
# Q4_K_M
./build/bin/llama-bench -m model-q4_k_m.gguf -p 512 -n 256

# Q5_K_M
./build/bin/llama-bench -m model-q5_k_m.gguf -p 512 -n 256

# Q8_0
./build/bin/llama-bench -m model-q8_0.gguf -p 512 -n 256
```

Typically, generation speed is similar across quants for the same model size, but prompt evaluation may be faster with higher quants due to fewer cache misses.

### Comparing GPU vs CPU

```bash
# CPU only
./build/bin/llama-bench -m model.gguf -p 512 -n 256 -ngl 0

# GPU (all layers)
./build/bin/llama-bench -m model.gguf -p 512 -n 256 -ngl 99
```

GPU acceleration typically provides 2-5x speedup for generation and 5-20x speedup for prompt evaluation.

### Comparing Thread Counts

```bash
./build/bin/llama-bench -m model.gguf -p 512 -n 256 -t 1,2,4,8,16
```

Generation speed scales almost linearly with thread count up to the physical core count. Prompt evaluation speed (GPU offloaded) is less sensitive to thread count.

---

## 10. Advanced Features

### LoRA Adapters

Load a LoRA adapter on top of a base model:

```bash
./build/bin/llama-cli -m base-model.gguf --lora lora-adapter.gguf -p "Prompt"
```

Merge a LoRA adapter into the base model:

```bash
./build/bin/llama-quantize --lora base-model.gguf lora-adapter.gguf merged-model.gguf
```

### Speculative Decoding

Use a smaller "draft" model to predict tokens, which the larger "target" model then verifies. This can speed up generation by 1.5-3x:

```bash
./build/bin/llama-cli -m target-model.gguf \
  --draft-model draft-model.gguf \
  --draft-n 5 \
  --draft-pp 10 \
  -p "Write a story."
```

- `--draft-n`: Number of draft tokens per step (5-16 recommended)
- `--draft-pp`: Batch size for draft model prompt processing
- A good draft model is 3-10x smaller than the target model

### Mixtral / MoE Specific Flags

For Mixture of Experts models like Mixtral-8x7B:

```bash
./build/bin/llama-cli -m mixtral.gguf --no-mul-mat-q
```

`--no-mul-mat-q` avoids a known issue with quantized matrix multiplication on MoE architectures.

### Batching and Continuous Batching

For production servers with multiple concurrent users, use continuous batching:

```bash
./build/bin/llama-server -m model.gguf --cont-batching --slots 4 -c 8192
```

This allows the server to process multiple requests simultaneously, batching them at the token level for maximum GPU utilization.

### Grammar-Based Generation

Use GBNF (GGML BNF) grammar files to constrain output:

```bash
# Generate valid JSON
./build/bin/llama-cli -m model.gguf \
  -p "Generate a JSON object with name and age." \
  --grammar-file grammars/json.gbnf
```

Built-in grammar files are in the `grammars/` directory. You can write custom grammars for:
- JSON output
- CSV output
- Code in specific languages
- Structured data extraction

### Token Healing

Token healing attempts to fix tokenization artifacts when the prompt ends mid-token. Enabled by default in newer versions. It improves output quality by ensuring clean token boundaries.

### Penalize Newline

Use `--grammar-penalize-num` to discourage the model from generating numbers when not needed. This is useful for creative writing or conversational tasks where numeric output is undesirable.

---

## 11. Troubleshooting

### "llama.cpp: error: unable to load model"

The model file is corrupt, incomplete, or not a valid GGUF format.

**Solutions:**
- Verify the file checksum against the source
- Re-download the GGUF file
- Ensure the file was downloaded completely (check file size)
- Try converting from Hugging Face format again
- Update llama.cpp to the latest version (GGUF format evolves)

### "CUDA error: out of memory"

The GPU does not have enough VRAM for the model, context size, and batch size.

**Solutions:**
- Reduce `-ngl` to offload fewer layers
- Reduce `-c` (context size)
- Reduce `-b` (batch size)
- Use a smaller model or higher quantization
- Close other GPU-using applications
- Use `--no-kv-offload` to keep KV cache on CPU
- Enable KV cache quantization (`-ctk q8_0 -ctv q8_0`)

### Slow Generation

Generation speed is below acceptable levels (under 5 t/s for interactive use).

**Solutions:**
- Increase thread count with `-t`
- Enable GPU offloading with `-ngl 99`
- Check that you are using the correct build (GPU-enabled)
- Reduce context size
- Use a lower quantization (Q4_K_M instead of Q5_K_M)
- Enable flash attention for long contexts
- Check CPU frequency throttling (especially on laptops)
- For Macs, ensure Metal build is used

### Nonsensical Output

The model produces gibberish, repeats phrases, or ignores instructions.

**Solutions:**
- Use the correct chat template for the model
- Ensure the prompt format matches the model's training format
- Set appropriate temperature (0.5-0.7 for factual tasks, 0.7-0.9 for creative)
- Increase repeat penalty (`-repeat_penalty 1.15`)
- Check that the GGUF file is not corrupted
- Try a different quantization level
- Update llama.cpp to the latest version

### "Unknown model architecture"

The GGUF file uses a model architecture not supported by your version of llama.cpp.

**Solutions:**
- Update llama.cpp to the latest version
- Check if the architecture is listed in the supported models list
- Some very new models may require a newer build

### Build Errors

**Missing CUDA:**
```bash
# Install CUDA Toolkit from NVIDIA
# On Ubuntu:
sudo apt install nvidia-cuda-toolkit
```

**Missing Metal (macOS):**
```bash
# Install Xcode CLI tools
xcode-select --install
```

**Missing Vulkan:**
```bash
# Ubuntu/Debian
sudo apt install libvulkan-dev vulkan-tools

# Fedora
sudo dnf install vulkan-headers vulkan-tools
```

**Missing ROCm:**
```bash
# Follow AMD's ROCm installation guide for your distribution
```

### Metal Performance Issues on macOS

- Ensure you are using the Metal-enabled build (`LLAMA_METAL=1`)
- On Intel Macs, Metal acceleration provides less benefit due to PCIe bandwidth
- Apple Silicon Macs see the best performance with all layers offloaded
- Check Activity Monitor for GPU usage

---

## 12. Integration with Other Tools

### llama-cpp-python (Python Bindings)

Install:

```bash
pip install llama-cpp-python
```

Build with GPU support:

```bash
# CUDA
CMAKE_ARGS="-DLLAMA_CUDA=ON" pip install llama-cpp-python

# Metal
CMAKE_ARGS="-DLLAMA_METAL=ON" pip install llama-cpp-python

# Vulkan
CMAKE_ARGS="-DLLAMA_VULKAN=ON" pip install llama-cpp-python
```

Basic usage:

```python
from llama_cpp import Llama

llm = Llama(
    model_path="/path/to/model.gguf",
    n_gpu_layers=-1,  # All layers on GPU
    n_ctx=4096,       # Context size
    verbose=True
)

output = llm(
    "Q: What is the capital of France? A:",
    max_tokens=100,
    temperature=0.7,
    stop=["Q:", "\n"],
    echo=True
)

print(output["choices"][0]["text"])
```

### LangChain Integration

```python
from langchain_community.llms import LlamaCpp

llm = LlamaCpp(
    model_path="/path/to/model.gguf",
    temperature=0.7,
    max_tokens=2000,
    n_gpu_layers=99,
    n_ctx=4096,
    verbose=True
)

response = llm.invoke("Explain the concept of recursion.")
```

### Using with whisper.cpp for Speech-to-Text

Combine llama.cpp with whisper.cpp for a complete voice assistant pipeline:

1. Transcribe speech with whisper.cpp
2. Send transcription to llama.cpp for processing
3. Optionally convert response back to speech with a TTS engine

```bash
# Transcribe audio
./whisper-cli -m whisper-base.en -f input.wav --output-txt

# Send to LLM
./llama-cli -m model.gguf -p "Transcription: $(cat input.wav.txt)\n\nResponse:" -n 200
```

### Using with stable-diffusion.cpp for Image Generation

Pair llama.cpp with stable-diffusion.cpp for multimodal AI workflows:

```bash
# LLM generates an image prompt
IMAGE_PROMPT=$(./llama-cli -m model.gguf -p "Describe an image of a futuristic city:" -n 50)

# Stable Diffusion generates the image
./sd -m sd-model.gguf -p "$IMAGE_PROMPT" -o output.png
```
