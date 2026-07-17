# Troubleshooting AI Model Operations

## 1. General Diagnostics

- Checking system info: `nvidia-smi`, `free -h`, `uname -a`
- Finding logs: `~/.ollama/logs/`, llama.cpp stderr, Python tracebacks
- Reproduction checklist: model, quant, command, hardware, software versions

### Diagnostic commands to run first

```bash
nvidia-smi                    # GPU model, driver, VRAM usage, processes
free -h                       # System RAM and swap usage
uname -a                      # Kernel and architecture info
cat /etc/os-release           # OS distribution and version
python --version && pip list  # Python environment
```

### Log locations by tool

- Ollama: `~/.ollama/logs/server.log`
- llama.cpp: stderr (redirect with `2>&1 | tee log.txt`)
- vLLM: stdout with configurable log level
- TGI: container stdout or log files
- Transformers: `transformers.logger` or `logging.basicConfig(level=logging.INFO)`

### Reproducibility checklist

Always capture these details when filing a bug:
1. Exact model identifier (name, source URL, filename, size)
2. Quantization type and parameters
3. Full command line or invocation
4. Hardware: GPU model(s), CPU, RAM capacity
5. Software: OS, CUDA version, Python version, inference tool version
6. Complete error message (not truncated)

## 2. Installation Issues

### Git LFS not working

- `git lfs install` missing
- `git lfs pull` not downloading model files
- Fix: `git lfs install --skip-repo && git lfs pull`

### llama.cpp build fails

- Missing CUDA toolkit: install `nvidia-cuda-toolkit`
- `nvcc` not found: check PATH
- Missing build-essential: `apt install build-essential` or Xcode CLT
- CMake version too old: `pip install --upgrade cmake`
- Mac M-series: use `LLAMA_METAL=1`
- GPU architecture not detected: `LLAMA_CUDA_ARCH="80;86"`

### Python package conflicts

- torch CUDA version mismatch: `pip install torch --index-url https://download.pytorch.org/whl/cu121`
- Use conda environment to isolate
- Pin package versions for reproducibility
- `pip install` vs `conda install` mixing can cause ABI incompatibilities
- torch compiled against a different CUDA version than the system runtime

### CUDA toolkit version mismatch

- Symptoms: `CUDA error: no kernel image is available for execution on the device`, `libcudart.so: cannot open shared object file`
- Check driver version: `nvidia-smi` shows max CUDA version supported
- Check runtime version: `nvcc --version` shows toolkit version
- Driver >= runtime version is required (backward compatible but not forward)
- Install compatible toolkit: `conda install cuda -c nvidia` or system package manager

### MacOS-specific installation issues

- Xcode Command Line Tools not installed: `xcode-select --install`
- Metal not available on Intel Macs (only Apple Silicon M-series)
- Homebrew llama.cpp: `brew install llama.cpp` (may be behind latest release)
- Python 3.11+ required for some inference libraries on ARM Macs

### Docker GPU access

- `nvidia-smi` works on host but not inside container: install `nvidia-container-toolkit`
- Container sees different CUDA version than host: mismatch between base image and driver
- Buildkit cache issues: `DOCKER_BUILDKIT=0 docker build` to disable

## 3. Model Download Issues

### Hugging Face authentication

- `OSError: gated model`: login with `huggingface-cli login`
- Token format: `hf_...` read token
- Need to accept model terms on HF website for gated models (Llama, Gemma)

### Download interrupted

- Resume with `huggingface-cli download --resume-download`
- Or `git lfs pull` in the repo
- Check disk space first

### Incomplete download

- `.bin` or `.safetensors` files are placeholders: need to run `git lfs pull`
- Verify file sizes match expected

### Network/proxy issues

- Hugging Face blocked in some regions: use mirror (`HF_ENDPOINT=https://hf-mirror.com`)
- Corporate proxy: set `HTTP_PROXY` and `HTTPS_PROXY` environment variables
- SSL certificate errors: `REQUESTS_CA_BUNDLE` or `CURL_CA_BUNDLE`
- Rate limiting: Hugging Face may throttle excessive downloads; add delays between requests

## 4. Conversion Issues

### convert.py errors

- "Tokenizer model not found": missing tokenizer model file, use `--no-tokenizer` to skip
- "Unknown model architecture": update llama.cpp to latest; newer model formats not yet supported
- "CUDA out of memory": use `--outtype q8_0` or quantize on CPU
- Conversion hangs: check disk space, try with `--verbose`

### Tokenizer issues

- Wrong vocabulary size: `--pad-vocab` or adjust config.json
- Missing `added_tokens.json`: model may use special tokens not captured
- Chat template missing: add template in metadata after conversion
- Byte-level BPE vs SentencePiece tokenizer mismatch: check the original model's tokenizer type
- Tokenizer vocabulary order assumed differently by tool: verify special token IDs

## 5. Quantization Issues

### llama-quantize errors

- "File too large" for 32-bit systems: use 64-bit system
- "Not enough memory": use smaller batch size or quantize on CPU
- Output file already exists: use `--allow-destructive` or remove output

### AWQ/GPTQ quantization errors

- CUDA OOM during calibration: reduce calibration dataset size
- "No module named 'awq'": `pip install autoawq`
- ExLlama kernel not available: specific GPU architecture required
- Calibration data format incompatible: ensure tokenized inputs match expected format
- "group_size must divide hidden_size": choose group size that evenly divides the model's hidden dimension
- No performance gain after AWQ: ensure you use ExLlama or AutoAWQ inference kernel, not default PyTorch

### EXL2 quantization issues

- Only works with specific model architectures (Llama, Mistral, Qwen)
- Requires significant VRAM for calibration (similar to inference)
- Kernel selection: use `--kernel xq` for Turing/Ampere, `--kernel xq2` for Ada Lovelace+

## 6. Inference Issues

### Out of memory

- Symptoms: crash, "CUDA out of memory", killed process
- Solution 1: reduce context length (`-c 4096`)
- Solution 2: reduce GPU layers (`-ngl 20`)
- Solution 3: use lower quant (Q4_K_M -> Q4_0 -> Q3_K_M -> Q2_K)
- Solution 4: enable KV cache quantization
- Solution 5: switch to CPU-only (`-ngl 0`)
- OOM on M-series Mac: unified memory means everything shares RAM; close other apps

### Slow inference

- Symptoms: < 5 tokens/second
- Check 1: are GPU layers being used? (`-ngl N` > 0)
- Check 2: thread count optimal? (`-t` = number of performance cores)
- Check 3: thermal throttling? -> clean fans, lower ambient temp
- Check 4: disk swapping? -> check `free -h` or Activity Monitor
- Check 5: context length too long? -> reduces effective batch size
- On Mac: ensure Metal backend (`LLAMA_METAL=1`)
- Benchmark: use `llama-bench` to identify bottleneck

### Nonsensical / garbled output

- Wrong quantization type for model architecture
- Chat template mismatch: use correct `--chat-template`
- Temperature too high: reduce to 0.5-0.8
- Corrupted model file: re-download
- Tokenizer mismatch: re-convert with correct tokenizer
- Context overflow: increase context or use summarization

### Repetitive output

- Increase repeat_penalty (1.1 to 1.3)
- Decrease repeat_last_n
- Try mirostat sampling (mode=2, tau=5.0, eta=0.1)
- Check if frequency_penalty and presence_penalty are set too low
- Some models (especially quantized) are more prone to repetition; consider a higher quant

### Hallucination / factually incorrect output

- Not necessarily a bug: LLMs inherently generate plausible-sounding text
- Reduce temperature to 0.1-0.3 for factual tasks
- Increase min_p or top_p to tighten sampling
- Use prompting techniques (chain-of-thought, retrieval-augmented generation)
- Consider fine-tuning on domain-specific data

### Truncated output

- Max tokens limit reached: increase `-n` or `--max-tokens`
- Context window full: model reached its maximum context length
- EOS token generated prematurely: check if tokenizer defines a proper EOS token
- Some quantizations may cause early EOS generation (rare; re-quantize if persistent)

## 7. Ollama-Specific Issues

### Model not found

- Local model: check Modelfile path (absolute path recommended)
- Library model: `ollama pull name:tag`
- Custom model: `ollama create name -f Modelfile`

### GPU not being used

- Check: `ollama run --verbose model`
- Set `num_gpu` in Modelfile
- Ensure nvidia-container-toolkit installed for Docker
- Mac: Metal should be automatic; check Activity Monitor GPU history

### Ollama server issues

- "connection refused": ensure `ollama serve` is running
- Port conflict: `OLLAMA_HOST=0.0.0.0:11435`
- Timeout: increase keep-alive or reduce model load
- Crash on model load: check `~/.ollama/logs/`

### Slow inference in Ollama

- Adjust `num_ctx` (context size) in Modelfile
- Check if multiple models are loaded
- `OLLAMA_NUM_PARALLEL` may cause contention
- Mac: ensure Activity Monitor shows GPU usage during inference
- Linux: check `nvidia-smi` for GPU utilization; low utilization suggests CPU bottleneck
- Monitor VRAM: if model + KV cache exceeds VRAM, Ollama falls back to CPU

### Ollama Modelfile issues

- Incorrect TEMPLATE syntax causes garbled chat output
- Missing PARAMETER values fall back to defaults (often suboptimal)
- FROM path with relative paths may not resolve; use absolute paths
- Modelfile not found: ensure filename is exactly `Modelfile` (capital M) or specify with `-f`

## 8. Server/Deployment Issues

### vLLM errors

- "CUDA graph" errors: `VLLM_USE_GRAPH_CAPTURE=0`
- Model not supported: check vLLM model registry
- DType mismatch: FP16 vs BF16 vs FP32

### TGI errors

- `SHARDED=True` but not enough GPUs
- Tokenizer mismatch with model config

### Docker issues

- GPU not available in container: `--gpus all` flag, nvidia-container-toolkit
- Volume permissions: `:Z` SELinux context
- Port mapping conflicts

### llama.cpp server mode

- Port already in use: change with `--port` flag
- CORS errors from web UI: `--cors-origin *` (dev) or specific origin (production)
- SSL/TLS not supported natively: use reverse proxy (Nginx, Caddy) with HTTPS termination

## 9. Quality Issues After Quantization

- Quantization too aggressive (Q2_K or IQ2): use Q4_K_M or higher
- Calibration dataset mismatch for AWQ/GPTQ: use dataset similar to your task
- Group size too large: use group size 32 or 64
- Test with diverse prompts
- Compare PPL against unquantized baseline

## 10. Performance Tuning Tips

### Batch size tuning for serving

- Small batch (1-4): lowest latency per request, lower throughput
- Large batch (8-64): higher throughput, higher latency for individual requests
- Find the sweet spot: increase batch size until VRAM is 90-95% utilized
- Use dynamic batching (vLLM continuous batching, TGI dynamic batching)

### GPU utilization optimization

- Low GPU util (< 50%): CPU or I/O bottleneck; increase batch size or use more threads
- High GPU util but low tokens/sec: memory bandwidth limited; check HBM bandwidth utilization
- Medium GPU util with power limit hit: increase power limit or reduce clock speed for efficiency
- Context processing and token generation use different GPU resources: profile separately

### CPU vs GPU offloading ratio

- Each GPU-offloaded layer adds ~1-2 GB of VRAM use (varies by model)
- Offload too few layers: slow prompt processing (CPU-bound)
- Offload too many layers: OOM on GPU
- Rule of thumb: start with `-ngl 20` and increase until VRAM is 90% full

## 11. Getting Help

What to include in a bug report:
- Exact command and output
- Model name and source
- Hardware: GPU, CPU, RAM
- Software versions: Python, CUDA, llama.cpp, etc.
- Full error message (not just summary)

Where to report:
- llama.cpp issues: https://github.com/ggerganov/llama.cpp/issues
- Ollama issues: https://github.com/ollama/ollama/issues
- vLLM issues: https://github.com/vllm-project/vllm/issues
- Transformers issues: https://github.com/huggingface/transformers/issues
- Hugging Face Hub issues: https://github.com/huggingface/huggingface_hub/issues
