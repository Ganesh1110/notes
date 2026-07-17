# Model Metadata Template

## 1. Purpose

Use this template to document every model you work with. Consistent metadata makes it easy to compare models, reproduce results, and share findings across a team.

## 2. Blank Template

```yaml
# ── Identity ──
Model Name:
Provider:
Date Acquired:
Model Version / Tag:

# ── Architecture ──
Architecture (from config.json):
Base Architecture Family:
Parameter Count (total):
Parameter Count (active, if MoE):
Hidden Size:
Number of Layers:
Number of Attention Heads:
Number of KV Heads:
Head Dimension:
Intermediate Size:
Vocabulary Size:
Max Context Length (native):
RoPE / Position Encoding:

# ── Training Details ──
Training Data:
Training Method (RLHF/DPO/GRPO/etc.):
Knowledge Cutoff:
Base Model (if fine-tuned):

# ── License ──
License Type:
Commercial Use Allowed:
Attribution Required:
MAU Limit:
Additional Restrictions:

# ── Tokenizer ──
Tokenizer Type (BPE/Unigram/WordPiece):
Tokenizer File(s):
Vocabulary Size:
Special Tokens (bos/eos/pad/unk):
Chat Template:
Chat Template String (paste below):
```

```
<chat_template_string>
```

```
# ── Prompt Format ──
System Prompt Format:
User Prompt Format:
Assistant Response Format:
Stop Tokens:
Function Calling Format:

# ── Inference Configuration ──
Recommended Temperature:
Recommended Top-P:
Recommended Top-K:
Recommended Repeat Penalty:
Recommended Context Length:

# ── Quantization ──
GGUF Supported:
AWQ Supported:
GPTQ Supported:
EXL2 Supported:
Ollama Support:
Pre-quantized Available (HF):

# ── Quant Levels Tested ──
- [ ] FP16 / unquantized
- [ ] Q8_0
- [ ] Q6_K
- [ ] Q5_K_M
- [ ] Q4_K_M
- [ ] Q3_K_M
- [ ] Q2_K
- [ ] IQ4_XS
- [ ] IQ3_XXS
- [ ] AWQ 4-bit
- [ ] GPTQ 4-bit
- [ ] EXL2 4.0 bpw

# ── Benchmark Results ──
Benchmark Date:
Hardware Used:
Inference Engine:
Engine Version:
GPU Model:
CPU Model:
RAM:

## Speed (Q4_K_M unless noted)
Prompt Processing (t/s):
Generation (t/s):
Time to First Token (ms):
Peak VRAM Usage:
Peak RAM Usage:

## Quality
Perplexity (FP16 baseline):
Perplexity (Q4_K_M):
Perplexity (Q8_0):
MMLU Score:
GSM8K Score:
HumanEval Score:

# ── Deployment ──
Runtime Used:
Quantization Used:
Context Length Used:
GPU Layers:
Batch Size:
Ollama Modelfile (paste below):
```

```
<modelfile_content>
```

```
# ── Known Issues ──
- Issue 1:
- Issue 2:
- Issue 3:

# ── Notes ──
- Note 1:
- Note 2:

# ── Comparison with Alternatives ──
Compared Model 1:
Outcome:
Compared Model 2:
Outcome:
```

## 3. Filled Example (Llama 3.1 8B)

```yaml
# ── Identity ──
Model Name: Llama 3.1 8B Instruct
Provider: Meta
Date Acquired: 2025-01-15
Model Version / Tag: meta-llama/Llama-3.1-8B-Instruct

# ── Architecture ──
Architecture: LlamaForCausalLM
Base Architecture Family: Llama
Parameter Count (total): 8.03B
Parameter Count (active): 8.03B (dense)
Hidden Size: 4096
Number of Layers: 32
Number of Attention Heads: 32
Number of KV Heads: 8 (GQA)
Head Dimension: 128
Intermediate Size: 14336
Vocabulary Size: 128256
Max Context Length (native): 131072
RoPE / Position Encoding: RoPE (default), YaRN for extension

# ── Training Details ──
Training Data: 15T tokens, mostly English web + code
Training Method: RLHF (PPO)
Knowledge Cutoff: December 2023
Base Model: N/A (base model)

# ── License ──
License Type: Llama 3 Community License
Commercial Use Allowed: Yes
Attribution Required: No
MAU Limit: >700M MAU needs Meta approval
Additional Restrictions: None

# ── Tokenizer ──
Tokenizer Type: BPE (tiktoken)
Tokenizer File(s): tokenizer.json, tokenizer_config.json
Vocabulary Size: 128256
Special Tokens: <|begin_of_text|>, <|end_of_text|>, <|eot_id|>
Chat Template: Llama 3 Instruct (built-in apply_chat_template)

# ── Prompt Format ──
System Prompt Format: <|start_header_id|>system<|end_header_id|>\n\n{system}<|eot_id|>
User Prompt Format: <|start_header_id|>user<|end_header_id|>\n\n{user}<|eot_id|>
Assistant Response Format: <|start_header_id|>assistant<|end_header_id|>\n\n{response}<|eot_id|>
Stop Tokens: <|eot_id|>, <|end_of_text|>
Function Calling Format: Built-in (tool_use.json)

# ── Inference Configuration ──
Recommended Temperature: 0.6
Recommended Top-P: 0.9
Recommended Top-K: 40
Recommended Repeat Penalty: 1.1
Recommended Context Length: 8192

# ── Quantization ──
GGUF Supported: ✅
AWQ Supported: ✅
GPTQ Supported: ✅
EXL2 Supported: ✅
Ollama Support: ✅ (ollama pull llama3.1)
Pre-quantized Available (HF): ✅ (bartowski, MaziyarPanahi, etc.)

# ── Quant Levels Tested ──
- [x] FP16 / unquantized
- [x] Q8_0
- [x] Q6_K
- [x] Q5_K_M
- [x] Q4_K_M
- [x] Q3_K_M
- [ ] Q2_K
- [ ] IQ4_XS
- [ ] IQ3_XXS
- [x] AWQ 4-bit
- [x] GPTQ 4-bit
- [ ] EXL2 4.0 bpw

# ── Benchmark Results ──
Benchmark Date: 2025-03-01
Hardware Used: RTX 4090 + Ryzen 7950X
Inference Engine: llama.cpp
Engine Version: b4381
GPU Model: RTX 4090 24GB
CPU Model: Ryzen 9 7950X
RAM: 64GB DDR5

## Speed
Prompt Processing (t/s): 1250 (Q4_K_M, 512 prompt)
Generation (t/s): 85 (Q4_K_M)
Time to First Token (ms): 45
Peak VRAM Usage: 5.5 GB (8K context)
Peak RAM Usage: 2.1 GB

## Quality
Perplexity (FP16 baseline): 6.20
Perplexity (Q4_K_M): 6.26 (+1.0%)
Perplexity (Q8_0): 6.21 (+0.1%)
MMLU Score: 68.4 (FP16) / 67.8 (Q4_K_M)
GSM8K Score: 78.2 (FP16) / 77.5 (Q4_K_M)
HumanEval Score: N/A

# ── Known Issues ──
- Chat template must be applied with apply_chat_template() — raw prompting degrades quality significantly
- 405B model requires 8x A100 for full precision inference

# ── Notes ──
- Best all-round open model for English tasks as of 2025 Q1
- Strong ecosystem support — most tools test against Llama first

# ── Comparison with Alternatives ──
Compared Model 1: Qwen 2.5 7B
Outcome: Llama better at English creative writing; Qwen better at math
Compared Model 2: Mistral 7B v0.3
Outcome: Llama significantly better at instruction following; Mistral more efficient
```
