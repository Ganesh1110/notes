# Deploying Quantized Models with Ollama

## 1. What is Ollama?

Ollama is an open-source local LLM server that wraps llama.cpp to provide a simple REST API, model management, and a clean CLI interface. It abstracts away the complexity of running large language models on consumer hardware.

### How It Works

Ollama uses llama.cpp as its inference engine under the hood. When you pull or create a model, Ollama stores it in `~/.ollama/models/` and exposes it via:

- A REST API on `localhost:11434`
- An interactive CLI (`ollama run`)
- Programmatic access via HTTP clients

### Key Benefits

- **REST API**: OpenAI-compatible endpoints for chat, generation, and embeddings
- **Model Management**: Simple commands to pull, create, list, and remove models
- **Simple CLI**: Single binary with intuitive subcommands
- **GPU Acceleration**: Automatic detection and use of Metal, CUDA, ROCm, and DirectML
- **Quantization Support**: Runs GGUF-quantized models efficiently
- **Docker Support**: Official container images for production deployments

### Supported Platforms

| Platform | GPU Backend | Installation Method |
|----------|-------------|---------------------|
| macOS    | Metal (automatic) | Homebrew or DMG installer |
| Linux    | CUDA / ROCm / Vulkan | Shell script or manual |
| Windows  | CUDA / DirectML | Installer EXE |

---

## 2. Installation

### macOS

Using Homebrew:

```bash
brew install ollama
```

Alternatively, download the macOS DMG from [ollama.ai](https://ollama.ai).

### Linux

```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

This script detects your distribution and installs the appropriate package. For manual installation, download the Linux tarball from ollama.ai.

### Windows

Download the Windows installer from [ollama.ai](https://ollama.ai) and run it. Ollama installs as a system service.

### Verification

```bash
ollama --version
```

Expected output: `ollama version 0.x.x`

### Service Management

- Start the Ollama service: `ollama serve` (runs in foreground)
- macOS/Linux: Ollama runs as a background service automatically after installation
- Windows: Runs as a Windows service
- Check service status: `ollama ps` (shows running models)

### Configuring OLLAMA_HOST

By default, Ollama listens on `127.0.0.1:11434`. To change this:

```bash
export OLLAMA_HOST=0.0.0.0
ollama serve
```

Or set it in your shell profile for persistence. To use a custom port:

```bash
export OLLAMA_HOST=0.0.0.0:8080
```

---

## 3. Running Pre-built Models from the Library

### Pulling a Model

```bash
ollama pull llama3.1
```

This downloads the default (usually Q4_K_M quantized) version of the model from the Ollama library.

### Running a Model Interactively

```bash
ollama run llama3.1
```

You are dropped into an interactive chat session. Type your prompts and hit Enter. Use `/bye` to exit.

### Common Models in the Library

| Model | Parameter Sizes | Notes |
|-------|-----------------|-------|
| llama3.1 | 8B, 70B | Meta's Llama 3.1 instruct models |
| qwen2.5 | 0.5B, 1.5B, 3B, 7B, 14B, 32B, 72B | Qwen 2.5 chat models |
| mistral | 7B | Mistral v0.3 instruct |
| gemma2 | 2B, 9B, 27B | Google Gemma 2 instruct |
| deepseek-r1 | 1.5B, 7B, 8B, 14B, 32B, 70B, 671B | DeepSeek R1 reasoning models |
| phi4 | 14B | Microsoft Phi-4 |
| command-r | 35B | Cohere Command-R |
| mixtral | 8x7B, 8x22B | Mixtral MoE models |

### Listing Local Models

```bash
ollama list
```

Shows all models you have pulled or created locally, including their size and modification date.

### Model Tags and Quant Levels

Ollama library models come in different quantization levels specified via tags:

```bash
ollama pull llama3.1:8b-q4_K_M
ollama pull llama3.1:8b-q8_0
ollama pull llama3.1:70b-q2_K
```

Common quant tags:

| Tag | Description | Size Reduction |
|-----|-------------|----------------|
| q2_K | 2-bit K-quant | ~85% reduction |
| q3_K_M | 3-bit medium K-quant | ~80% reduction |
| q4_0 | 4-bit non-K-quant | ~75% reduction |
| q4_K_M | 4-bit medium K-quant (default for most models) | ~75% reduction |
| q5_K_M | 5-bit medium K-quant | ~70% reduction |
| q8_0 | 8-bit non-K-quant | ~60% reduction |
| fp16 | 16-bit float | ~50% reduction |

---

## 4. Importing Custom GGUF Models into Ollama

### Method A: Modelfile

A Modelfile is a configuration file (analogous to a Dockerfile) that tells Ollama how to create and run a model from a GGUF file.

#### Basic Modelfile Structure

```
FROM /path/to/model.gguf

PARAMETER temperature 0.7
PARAMETER top_p 0.9
PARAMETER context_length 8192

SYSTEM """You are a helpful AI assistant."""
```

#### All Available PARAMETER Directives

| Parameter | Default | Description |
|-----------|---------|-------------|
| temperature | 0.8 | Sampling temperature (0.0 = greedy, higher = more random) |
| top_p | 0.9 | Nucleus sampling threshold |
| top_k | 40 | Top-K sampling |
| context_length | 2048 | Context window size (num_ctx) |
| stop | (none) | Stop tokens (can be specified multiple times) |
| mirostat | 0 | Mirostat sampling mode (0=disabled, 1=static, 2=dynamic) |
| mirostat_tau | 5.0 | Mirostat target entropy |
| mirostat_eta | 0.1 | Mirostat learning rate |
| num_gpu | (auto) | Number of layers to offload to GPU (99 = all) |
| num_thread | (auto) | Number of CPU threads |
| num_keep | 0 | Number of tokens to keep from prompt |
| seed | random | Random seed for reproducibility |
| repeat_penalty | 1.1 | Repeat penalty factor |
| repeat_last_n | 64 | How far back to apply repeat penalty |
| tfs_z | 1.0 | Tail-free sampling Z value |
| typical_p | 1.0 | Typical sampling threshold |
| presence_penalty | 0.0 | Presence penalty |
| frequency_penalty | 0.0 | Frequency penalty |

#### TEMPLATE Directive

Defines the chat template using Go template syntax:

```
TEMPLATE """{{- if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>
{{- end }}
{{- range .Messages }}
{{- if eq .Role "user" }}<|start_header_id|>user<|end_header_id|>

{{ .Content }}<|eot_id|>
{{- else if eq .Role "assistant" }}<|start_header_id|>assistant<|end_header_id|>

{{ .Content }}<|eot_id|>
{{- end }}
{{- end }}
<|start_header_id|>assistant<|end_header_id|>

"""
```

#### LICENSE Directive

Embeds a license string into the model metadata:

```
LICENSE """MIT License

Copyright (c) 2024 ...
"""
```

#### MESSAGE Directive

Pre-populates the conversation history:

```
MESSAGE system "You are a coding assistant."
MESSAGE user "Write a Python function to reverse a string."
MESSAGE assistant "Here is a Python function to reverse a string..."
```

### Modelfile Examples

#### Llama 3.1 Instruct

```
FROM ./llama-3.1-8b-instruct.Q4_K_M.gguf

TEMPLATE """{{- if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>
{{- end }}
{{- range .Messages }}
{{- if eq .Role "user" }}<|start_header_id|>user<|end_header_id|>

{{ .Content }}<|eot_id|>
{{- else if eq .Role "assistant" }}<|start_header_id|>assistant<|end_header_id|>

{{ .Content }}<|eot_id|>
{{- end }}
{{- end }}
<|start_header_id|>assistant<|end_header_id|>

"""

PARAMETER temperature 0.6
PARAMETER top_p 0.9
PARAMETER context_length 8192
PARAMETER stop "<|eot_id|>"
PARAMETER stop "<|start_header_id|>"
PARAMETER stop "<|end_header_id|>"
```

#### Qwen 2.5 Chat

```
FROM ./qwen2.5-7b-instruct.Q4_K_M.gguf

TEMPLATE """{{- if .System }}<|im_start|>system
{{ .System }}<|im_end|>
{{- end }}
{{- range .Messages }}
{{- if eq .Role "user" }}<|im_start|>user
{{ .Content }}<|im_end|>
{{- else if eq .Role "assistant" }}<|im_start|>assistant
{{ .Content }}<|im_end|>
{{- end }}
{{- end }}
<|im_start|>assistant
"""

PARAMETER temperature 0.7
PARAMETER top_p 0.8
PARAMETER context_length 32768
```

#### DeepSeek Coder

```
FROM ./deepseek-coder-6.7b-instruct.Q4_K_M.gguf

TEMPLATE """{{- if .System }}system
{{ .System }}
{{- end }}
{{- range .Messages }}
{{- if eq .Role "user" }}User: {{ .Content }}
{{- else if eq .Role "assistant" }}Assistant: {{ .Content }}
{{- end }}
{{- end }}
Assistant:
"""

PARAMETER temperature 0.0
PARAMETER top_p 0.95
PARAMETER context_length 16384
```

#### Mixtral MoE

```
FROM ./mixtral-8x7b-instruct.Q4_K_M.gguf

TEMPLATE """{{- if .System }}[INST] {{ .System }} [/INST]
{{- end }}
{{- range .Messages }}
{{- if eq .Role "user" }}[INST] {{ .Content }} [/INST]
{{- else if eq .Role "assistant" }} {{ .Content }}
{{- end }}
{{- end }}
"""

PARAMETER temperature 0.7
PARAMETER top_p 0.9
PARAMETER context_length 8192
PARAMETER num_gpu 99
```

#### Custom System Prompt Model

```
FROM ./base-model.Q4_K_M.gguf

SYSTEM """You are a specialized code reviewer. Analyze code for:
1. Security vulnerabilities
2. Performance issues
3. Best practices violations
Provide concise, actionable feedback."""

PARAMETER temperature 0.2
PARAMETER top_p 0.9
PARAMETER context_length 4096
```

### Method B: Creating and Running a Model from a Modelfile

```bash
ollama create my-model -f ./Modelfile
ollama run my-model
```

The model is stored locally and appears in `ollama list`.

### Method C: Direct GGUF Import (Ollama 0.3+)

Ollama 0.3 and later can import GGUF files directly from Hugging Face:

```bash
ollama pull hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF:Q4_K_M
```

This downloads the GGUF from Hugging Face and creates an Ollama model automatically.

---

## 5. Quantization During Import

Ollama can quantize models during the import process using the `QUANTIZE` directive in a Modelfile.

### Using QUANTIZE in Modelfile

```
FROM ./model-in-fp16.gguf
QUANTIZE q4_K_M
```

When you run `ollama create`, Ollama loads the model, quantizes it to the specified type, and saves the quantized version.

### Supported Quant Types

| Quant Type | Description |
|------------|-------------|
| q4_0 | 4-bit non-K-quant (legacy) |
| q4_K_M | 4-bit medium K-quant (recommended balance) |
| q5_K_M | 5-bit medium K-quant |
| q8_0 | 8-bit non-K-quant |
| fp16 | No quantization, keep as 16-bit float |

### Recommendation

Pre-quantize models using llama.cpp's `llama-quantize` tool rather than relying on Ollama's `QUANTIZE` directive. The llama.cpp tooling gives you more control and is more reliable for batch quantization workflows.

---

## 6. Ollama REST API

All API endpoints are available at `http://localhost:11434`.

### List Models

```bash
GET /api/tags
```

```bash
curl http://localhost:11434/api/tags
```

Response:

```json
{
  "models": [
    {
      "name": "llama3.1:latest",
      "size": 4825346176,
      "digest": "sha256:...",
      "modified_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Generate (Text Completion)

```bash
POST /api/generate
```

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1",
  "prompt": "Explain quantum computing in one paragraph.",
  "stream": false,
  "options": {
    "temperature": 0.7,
    "num_predict": 200
  }
}'
```

Request fields:

| Field | Type | Description |
|-------|------|-------------|
| model | string | Model name |
| prompt | string | Input prompt |
| stream | boolean | Stream response tokens (default: true) |
| options | object | Model parameters (temperature, num_predict, etc.) |
| system | string | System prompt (overrides model default) |
| context | list | Previous response context for continuing |
| template | string | Chat template override |
| raw | boolean | Bypass template and use raw prompt |

Response (non-streaming):

```json
{
  "model": "llama3.1",
  "response": "Quantum computing...",
  "context": [1, 2, 3, ...],
  "done": true,
  "total_duration": 1234567890,
  "prompt_eval_count": 10,
  "eval_count": 50,
  "eval_duration": 987654321
}
```

### Chat (Conversational)

```bash
POST /api/chat
```

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.1",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "What is the capital of France?"},
    {"role": "assistant", "content": "The capital of France is Paris."},
    {"role": "user", "content": "What is its population?"}
  ],
  "stream": false
}'
```

Response:

```json
{
  "model": "llama3.1",
  "message": {
    "role": "assistant",
    "content": "Paris has an estimated population of..."
  },
  "done": true
}
```

### Embeddings

```bash
POST /api/embeddings
```

```bash
curl http://localhost:11434/api/embeddings -d '{
  "model": "llama3.1",
  "prompt": "The quick brown fox jumps over the lazy dog"
}'
```

Response:

```json
{
  "embedding": [0.1, 0.2, 0.3, ...]
}
```

### Model Info

```bash
POST /api/show
```

```bash
curl http://localhost:11434/api/show -d '{
  "model": "llama3.1"
}'
```

Response includes model details, parameters, template, system prompt, and license.

### Copy Model

```bash
POST /api/copy
```

```bash
curl http://localhost:11434/api/copy -d '{
  "source": "llama3.1",
  "destination": "llama3.1-backup"
}'
```

### Delete Model

```bash
DELETE /api/delete
```

```bash
curl -X DELETE http://localhost:11434/api/delete -d '{
  "model": "llama3.1-backup"
}'
```

### Pull Model

```bash
POST /api/pull
```

```bash
curl http://localhost:11434/api/pull -d '{
  "model": "llama3.1",
  "stream": false
}'
```

### Push Model

```bash
POST /api/push
```

```bash
curl http://localhost:11434/api/push -d '{
  "model": "my-model",
  "stream": false
}'
```

### Python Client Example

```python
import requests
import json

OLLAMA_HOST = "http://localhost:11434"

# Generate (non-streaming)
response = requests.post(f"{OLLAMA_HOST}/api/generate", json={
    "model": "llama3.1",
    "prompt": "Hello, how are you?",
    "stream": False
})
print(response.json()["response"])

# Generate (streaming)
response = requests.post(f"{OLLAMA_HOST}/api/generate", json={
    "model": "llama3.1",
    "prompt": "Tell me a story.",
    "stream": True
}, stream=True)

for line in response.iter_lines():
    if line:
        chunk = json.loads(line)
        if not chunk.get("done"):
            print(chunk["response"], end="", flush=True)

# Chat
response = requests.post(f"{OLLAMA_HOST}/api/chat", json={
    "model": "llama3.1",
    "messages": [
        {"role": "user", "content": "What is machine learning?"}
    ],
    "stream": False
})
print(response.json()["message"]["content"])
```

### Streaming vs Non-Streaming

- **Streaming** (`stream: true`): Each token is returned as a separate JSON line via Server-Sent Events (SSE). Lower perceived latency for interactive apps.
- **Non-Streaming** (`stream: false`): The response returns as a single JSON object after generation completes. Simpler to handle but higher latency for the first token.

---

## 7. GPU Acceleration

### Checking GPU Support

Run a model with verbose output to check GPU detection:

```bash
ollama run --verbose llama3.1
```

Look for lines indicating GPU offloading in the logs.

### Setting GPU Layers

In a Modelfile:

```
PARAMETER num_gpu 99
```

Setting `num_gpu` to 99 offloads all layers to the GPU. Lower values offload only the specified number of layers, keeping the rest on CPU.

### Platform-Specific GPU Support

#### macOS (Metal)

Ollama uses Apple's Metal framework automatically. No configuration needed. All available GPU memory is shared with the CPU via unified memory.

#### Linux (CUDA / ROCm)

- **NVIDIA GPUs**: CUDA backend is included in the Linux Ollama binary. Ensure NVIDIA drivers and CUDA toolkit are installed.
- **AMD GPUs**: ROCm backend requires compatible AMD GPUs and ROCm drivers.

#### Windows (CUDA / DirectML)

- **NVIDIA GPUs**: CUDA backend works with NVIDIA drivers.
- **Other GPUs**: DirectML backend provides acceleration for a wider range of hardware.

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| OLLAMA_NUM_PARALLEL | 1 | Number of concurrent requests a model can process |
| OLLAMA_MAX_LOADED_MODELS | 1 | Maximum number of models loaded in memory simultaneously |
| OLLAMA_KEEP_ALIVE | 5m | How long to keep a model loaded after the last request |
| CUDA_VISIBLE_DEVICES | (all) | Comma-separated list of GPU indices for CUDA |
| OLLAMA_HOST | 127.0.0.1:11434 | Host and port for the API server |

### Monitoring GPU Usage

```bash
nvidia-smi -l 1
```

Refreshes every second and shows GPU utilization, memory usage, and process information.

---

## 8. Managing Multiple Models

### Running Multiple Models

Open separate terminals or use process management:

```bash
# Terminal 1
ollama run llama3.1

# Terminal 2
ollama run qwen2.5
```

### Stopping a Model

```bash
ollama stop llama3.1
```

### Parallel Model Loading

Set `OLLAMA_MAX_LOADED_MODELS` to control how many models can remain loaded simultaneously:

```bash
export OLLAMA_MAX_LOADED_MODELS=3
```

When exceeded, Ollama unloads the least recently used model.

### Memory Management

- Each loaded model consumes VRAM proportional to its quantization level and context length.
- Use `ollama ps` to see which models are currently loaded and their memory usage.
- Set `OLLAMA_KEEP_ALIVE` to a short duration (e.g., `30s`) for memory-constrained environments.

---

## 9. Production Deployment

### Running as a systemd Service (Linux)

Create `/etc/systemd/system/ollama.service`:

```
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_NUM_PARALLEL=4"
Environment="OLLAMA_MAX_LOADED_MODELS=2"

[Install]
WantedBy=default.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl start ollama
```

### Docker Deployment

```bash
docker run -d \
  --name ollama \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --gpus all \
  ollama/ollama
```

With GPU support (NVIDIA):

```bash
docker run -d \
  --name ollama \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --gpus all \
  --runtime nvidia \
  -e OLLAMA_NUM_PARALLEL=4 \
  ollama/ollama
```

Pulling a model inside the container:

```bash
docker exec ollama ollama pull llama3.1
```

### Reverse Proxy with Nginx

```
server {
    listen 443 ssl;
    server_name ollama.example.com;

    ssl_certificate /etc/ssl/certs/ollama.crt;
    ssl_certificate_key /etc/ssl/private/ollama.key;

    location / {
        proxy_pass http://127.0.0.1:11434;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Connection '';
    }
}
```

### Authentication

#### Basic Auth via Nginx

```
location / {
    auth_basic "Ollama API";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://127.0.0.1:11434;
}
```

#### API Key via Custom Headers

Use a reverse proxy to check for an API key header before forwarding requests.

### Rate Limiting

Using Nginx:

```
location / {
    limit_req zone=ollama burst=10 nodelay;
    proxy_pass http://127.0.0.1:11434;
}
```

### Monitoring with Prometheus

Ollama exposes Prometheus metrics at `/api/metrics` (available in newer versions). Scrape with:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'ollama'
    static_configs:
      - targets: ['localhost:11434']
```

### Keeping Models Warm

Set `OLLAMA_KEEP_ALIVE` to a large value (e.g., `24h`) or `-1` to keep models loaded indefinitely:

```bash
export OLLAMA_KEEP_ALIVE=-1
```

### Multi-GPU Configuration

When using multiple GPUs, Ollama automatically distributes model layers across them. Set `CUDA_VISIBLE_DEVICES` to restrict which GPUs are used:

```bash
export CUDA_VISIBLE_DEVICES=0,1
```

---

## 10. Performance Tuning

### Context Length vs Memory

The context window (`context_length` / `num_ctx`) directly impacts memory usage:

- 8K context at Q4_K_M for a 7B model: ~6 GB VRAM
- 32K context at Q4_K_M for a 7B model: ~10 GB VRAM
- 128K context at Q4_K_M for a 7B model: ~28 GB VRAM

Reduce context length if you encounter out-of-memory errors.

### Batch Size for Generation

The batch size (`num_batch`) controls how many tokens are processed in parallel during prompt evaluation. Larger batches use more memory but can speed up prompt ingestion:

```
PARAMETER num_batch 512
```

### Thread Count Optimization

Set `num_thread` to match your CPU core count. For CPU-only inference, more threads generally improve performance up to the physical core count:

```
PARAMETER num_thread 8
```

### Flash Attention

Flash attention (Ollama 0.2+) reduces memory usage for long contexts with minimal quality loss:

```
PARAMETER flash_attn 1
```

### KV Cache Quantization

Enable KV cache quantization to reduce memory usage:

```
PARAMETER kv_cache_q8 1
```

This stores the KV cache in 8-bit quantization instead of FP16, roughly halving KV cache memory usage.

### Mirostat vs Typical Sampling

- **Mirostat** (`mirostat: 2`): Dynamically adjusts temperature to maintain a target perplexity. Produces more consistent quality.
- **Typical sampling** (`typical_p: 0.9`): Filters tokens based on how typical they are relative to the predicted distribution. Can reduce repetitive outputs.
- **Mirostat is generally recommended** for most use cases as it adapts automatically.

---

## 11. Troubleshooting

### "ollama: command not found"

The Ollama binary is not in your PATH. On macOS, ensure Homebrew's bin directory is in your PATH. On Linux, check that the install script completed successfully. On Windows, re-run the installer.

### "model not found"

The model name is incorrect or the model has not been pulled. Run `ollama list` to see available models. For custom models, ensure the Modelfile `FROM` path points to the correct GGUF file location.

### GPU Not Detected

- **macOS**: Ensure you are on an Apple Silicon Mac (M1/M2/M3/M4). Intel Macs do not support Metal acceleration.
- **Linux**: Run `nvidia-smi` to verify NVIDIA drivers. For AMD, check `rocm-smi`.
- **Windows**: Check Device Manager for GPU driver status. Reinstall NVIDIA/AMD drivers if needed.
- Set `OLLAMA_DEBUG=1` before running `ollama serve` to see detailed GPU detection logs.

### Out of Memory Errors

- Reduce `context_length` in the Modelfile.
- Use a smaller model or higher quantization (e.g., Q3_K_M instead of Q4_K_M).
- Reduce `num_batch`.
- Close other GPU-using applications.
- Set `num_gpu` to offload fewer layers to GPU.

### Slow Inference

- Check if GPU acceleration is working (verbose mode).
- Increase `num_thread` for CPU inference.
- Ensure no other processes are competing for GPU resources.
- Reduce context length.
- Use a lower quantization (Q4_K_M is faster than Q5_K_M).
- Check Ollama logs for warnings.

### "failed to load model"

The GGUF file may be corrupt or incompatible. Try:
- Re-downloading the GGUF file
- Verifying the file checksum
- Updating Ollama to the latest version
- Converting with a newer version of llama.cpp

### Connection Refused to API

- Ensure Ollama is running: `ollama serve` or check service status.
- Verify the port: `lsof -i :11434` (macOS/Linux).
- Check firewall settings.
- Ensure `OLLAMA_HOST` is set correctly.

### Modelfile Syntax Errors

- Use exact spelling for PARAMETER names (all lowercase with underscores).
- Ensure TEMPLATE uses correct Go template syntax.
- Check that FROM points to an existing file.
- Validate with `ollama create --dry-run my-model -f Modelfile`.

### Logs Location

Ollama logs are stored in `~/.ollama/logs/`. View recent logs:

```bash
tail -f ~/.ollama/logs/ollama.log
```

For debug-level logging:

```bash
export OLLAMA_DEBUG=1
ollama serve
```

---

## 12. Best Practices

### Always Use Tagged Versions in Modelfile

Specify exact GGUF file paths or Ollama library tags to ensure reproducibility:

```
FROM llama3.1:8b-q4_K_M
```

### Pre-Quantize Models Rather Than Using QUANTIZE Directive

Use llama.cpp's `llama-quantize` tool for production workflows. It provides more control, better error reporting, and is faster for batch operations.

### Set Appropriate Context Length

Match `context_length` to your use case and hardware:
- Chat: 4096-8192
- Code generation: 8192-16384
- Document analysis: 16384-32768
- Long-form reasoning: 32768-131072

### Use Streaming for Interactive Apps

Enable `stream: true` in API calls for chat interfaces. This provides lower perceived latency and a better user experience.

### Monitor Logs in Production

Regularly check `~/.ollama/logs/` for errors, warnings, and performance metrics. Set up log rotation for long-running deployments.

### Keep Ollama Updated

New versions bring performance improvements, bug fixes, and new features. Check for updates regularly:

```bash
# macOS
brew upgrade ollama

# Linux
curl -fsSL https://ollama.ai/install.sh | sh

# Docker
docker pull ollama/ollama
```

### Use Environment Variables for Configuration

Set `OLLAMA_NUM_PARALLEL`, `OLLAMA_MAX_LOADED_MODELS`, and `OLLAMA_KEEP_ALIVE` in your deployment environment rather than relying on defaults.

### Test Models Before Deployment

Validate model behavior with a test suite of prompts before deploying to production. Check for:
- Response quality
- Latency under load
- Memory usage patterns
- Error handling

### Secure the API

Never expose Ollama directly to the internet without authentication. Always use a reverse proxy with at minimum basic auth or an API key in production.
