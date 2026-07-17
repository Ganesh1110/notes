# Choosing the Right Foundation Model

## 1. Introduction

### Why Model Selection Matters More Than Quantization

Quantization reduces model size and speeds up inference, but it cannot compensate for choosing the wrong model architecture for your task. A heavily quantized frontier model can outperform a full-precision small model on complex reasoning, while a tiny model at FP16 might be faster and more appropriate for simple classification. The choice of foundation model is the single highest-impact decision you will make in any LLM deployment.

### The Landscape: Open vs Closed Models

The ecosystem has bifurcated into two tracks. Open-weight models (Llama, Mistral, Qwen, DeepSeek, Gemma, Phi) are downloadable, auditable, and deployable on your own hardware. They offer full control over latency, data privacy, and cost at the expense of convenience. Closed models (GPT-4o, Claude, Gemini) are API-only, provide state-of-the-art quality with zero infrastructure burden, but lock you into their pricing, latency, and usage policies. This guide focuses on open-weight models because selection nuance matters most when you control deployment.

### Factors to Consider

- **Task**: What are you asking the model to do? Chat, coding, reasoning, retrieval, creative writing, classification, summarization, tool use?
- **Hardware**: What GPU or CPU resources are available? VRAM is the primary constraint, followed by memory bandwidth and total RAM.
- **Latency**: Is this real-time (chat, assistant) or batch (offline processing)? Real-time demands shorter models or higher quantization.
- **Quality**: What is the minimum acceptable output quality? Benchmark scores correlate roughly with parameter count but vary significantly between families.
- **Language**: Does the application require strong support for a language other than English? Some models are strongly English-optimized, while others (Qwen, GLM) excel at Chinese.
- **Cost**: Hardware cost (CAPEX/rental), power cost, and operational complexity all factor into total cost of ownership.

## 2. Model Size vs Capability

### The Size Spectrum

Open-weight models span roughly two orders of magnitude in parameter count: from 500 million parameters (edge deployment) to 405 billion (frontier-level inference). Parameter count correlates with capability but with diminishing returns — a well-trained 8B model can outperform a poorly trained 70B model.

### What Parameter Count Really Means

Parameters are the learnable weights of the neural network. More parameters mean more capacity to store knowledge, model nuance, and follow complex instructions. However, parameter count alone does not guarantee quality. Training data quality, architecture choices (MoE vs dense, attention variants), and training methodology (RLHF, DPO, GRPO) matter enormously. A 2024-era 8B model routinely beats a 2023-era 70B model on most benchmarks.

### General Capability by Size Tier

| Size Tier | Parameters | Capability | Hardware Needed |
|-----------|------------|------------|-----------------|
| Tiny | < 3B | Basic QA, simple chat, classification | Laptop CPU, no GPU required |
| Small | 3B-8B | Good chat, small coding tasks, summarization | 8GB VRAM (Q4) |
| Medium | 8B-30B | Strong reasoning, competent coding, RAG | 16-24GB VRAM (Q4) |
| Large | 30B-70B | Expert-level at most tasks, agent workflows | 48GB+ VRAM (Q4) |
| XL | 70B-405B | Frontier-level, rivaling closed models | Multi-GPU (80GB+ per node) |

## 3. Model Families Deep Dive

### Llama 3.1 / 3.2 / 4 (Meta)

| Property | Details |
|----------|---------|
| Available Sizes | 1B, 3B, 8B (3.2); 8B, 70B, 405B (3.1); 90B (4, MoE) |
| Context Length | 128K (3.1); 8K-128K (3.2); 1M (4) |
| Languages | English, multilingual (limited for 3.2) |
| License | Llama 3 Community License (commercial OK, >700M MAU needs Meta approval) |

**Strengths**: Exceptional general reasoning, strong instruction following, broad multilingual support (3.1), large ecosystem and tooling support, fine-tuning community is largest of any family.

**Weaknesses**: Verbose outputs (tendency to over-explain), safety filters can refuse legitimate requests, 405B requires significant infrastructure.

**Best For**: General-purpose chat, coding assistants, RAG pipelines, fine-tuning starting point, agent frameworks.

**Quirk**: Requires the correct chat template (Llama 3 Instruct format). Using the wrong template degrades output quality severely. Always verify your inference server applies `tokenizer.apply_chat_template()`.

### Mistral / Mixtral (Mistral AI)

| Property | Details |
|----------|---------|
| Available Sizes | 7B (Mistral), 8x7B (Mixtral), 8x22B (Mixtral Large), 12B (Nemo), 123B |
| Context Length | 32K native (extendable via RoPE scaling) |
| Languages | English, French, German, Spanish, Italian (strong European language support) |
| License | Apache 2.0 |

**Strengths**: Mixture-of-Experts (MoE) architecture provides large-model capability at small-model compute budget, excellent efficiency, strong base models for fine-tuning, Apache 2.0 license is maximally permissive.

**Weaknesses**: Smaller native context (32K), some models exhibit quirkiness in output style, smaller community than Llama.

**Best For**: Efficient inference at quality-to-compute ratio, CPU deployment (via llama.cpp), applications requiring permissive licensing, Mixtral 8x22B for near-frontier quality at reduced compute.

**Quirk**: MoE models require specialized quantization tooling. Standard quants may not work correctly. Use `llama.cpp` imatrix quantization for best results with Mixtral.

### Qwen 2.5 (Alibaba)

| Property | Details |
|----------|---------|
| Available Sizes | 0.5B, 1.5B, 3B, 7B, 14B, 32B, 72B, 110B |
| Context Length | 128K+ (32K native, extended via YaRN) |
| Languages | Chinese (native), English (strong), multilingual (decent) |
| License | Qwen License (commercial OK with conditions, free for <100M MAU) |

**Strengths**: Long context (128K+) out of the box, strong math and coding capabilities, exceptional Chinese language support, broad size range covering edge to large deployments.

**Weaknesses**: Slightly behind Llama on English creative writing and nuanced instruction following, smaller ecosystem, less community fine-tune availability.

**Best For**: Long-context applications (document analysis, RAG), multilingual (especially Chinese), code generation and completion, math-heavy workloads.

**Quirk**: Qwen 2.5 uses a different tokenizer (tiktoken-based) with higher compression for Chinese text. English token efficiency is slightly lower than Llama.

### DeepSeek (DeepSeek)

| Property | Details |
|----------|---------|
| Available Sizes | V2/V3 (236B MoE), Coder V2 (Coder/Base), R1 (671B reasoning) |
| Context Length | 128K |
| Languages | English, Chinese |
| License | MIT (most permissive for open models) |

**Strengths**: Exceptional coding capability (rivals GPT-4 on coding benchmarks), strong mathematical reasoning, highly efficient MoE architecture (only ~37B active parameters for V3 with 671B total), R1 adds chain-of-thought reasoning.

**Weaknesses**: MoE architecture complicates quantization (non-uniform importance across experts), Chinese bias in training data, R1 is extremely large (671B), quantization tooling less mature than dense models.

**Best For**: Coding assistance and code generation, mathematical reasoning, complex multi-step reasoning tasks (R1), STEM applications.

**Quirk**: DeepSeek V3 uses Multi-head Latent Attention (MLA) which reduces KV cache size significantly. R1 is a reasoning model that generates chain-of-thought by default — you may need to control this for latency-sensitive apps.

### Gemma 2 (Google)

| Property | Details |
|----------|---------|
| Available Sizes | 2B, 9B, 27B |
| Context Length | 8K |
| Languages | English (primary), multilingual (limited) |
| License | Gemma License (commercial OK, usage restrictions) |

**Strengths**: Remarkable quality at small sizes (2B punches above its weight), strong safety and alignment, excellent for fine-tuning (clean base models), good documentation and tooling from Google.

**Weaknesses**: Small context (8K only), not competitive with larger models at the high end, less popular fine-tuning ecosystem.

**Best For**: Fine-tuning for domain adaptation, safety-critical applications, small deployments (mobile, edge), applications where Google's safety stance is valued.

**Quirk**: Gemma 2 uses a different architecture (GeGLU, RoPE, Grouped-Query Attention). It benefits significantly from the correct tokenizer configuration.

### Phi-3 / Phi-4 (Microsoft)

| Property | Details |
|----------|---------|
| Available Sizes | 3.8B (Phi-3 mini), 7B, 14B |
| Context Length | 4K-128K (varies by variant) |
| Languages | English |
| License | MIT |

**Strengths**: Surprisingly capable for their size (synthetic/textbook-quality training data), strong code generation for small models, MIT license, good for resource-constrained deployment.

**Weaknesses**: Smaller context in base variants, less general knowledge than comparably sized models trained on web data, weaker than frontier models for complex tasks.

**Best For**: Resource-constrained deployments (CPU, mobile), simple code tasks, educational applications, applications requiring permissive licensing.

**Quirk**: Phi-3 was trained primarily on synthetic textbook-quality data. It performs best on tasks that resemble its training distribution (code, reasoning) and less well on open-ended creative tasks.

### GLM-4 (Zhipu AI)

| Property | Details |
|----------|---------|
| Available Sizes | 9B, 130B (MoE) |
| Context Length | 128K |
| Languages | Chinese (native), English |
| License | MIT |

**Strengths**: Chinese language excellence (native-level), strong tool use and function calling capabilities, agent workflow support, MIT license.

**Weaknesses**: Less popular in Western ecosystem, smaller community and fewer fine-tuned variants, English performance trails Llama/Qwen.

**Best For**: Chinese language applications, tool use and function calling, agent workflows, applications requiring MIT licensing.

**Quirk**: GLM-4 has native tool-use training — it can call functions without additional fine-tuning. This makes it a strong choice for agent architectures.

### Model Family Comparison Table

| Family | Sizes | Max Context | Languages | License | Key Strength |
|--------|-------|-------------|-----------|---------|--------------|
| Llama 3.1 | 8B, 70B, 405B | 128K | Multilingual | Llama Community | General reasoning, ecosystem |
| Llama 3.2 | 1B, 3B, 90B (MoE) | 128K | English | Llama Community | Edge (1B/3B), MoE (90B) |
| Llama 4 | 90B (MoE) | 1M | Multilingual | Llama Community | MoE efficiency |
| Mistral 7B | 7B | 32K | European langs | Apache 2.0 | Efficiency per parameter |
| Mixtral | 8x7B, 8x22B | 32K | European langs | Apache 2.0 | MoE at scale |
| Qwen 2.5 | 0.5B-110B | 128K | Chinese, English | Qwen License | Long context, math |
| DeepSeek V3 | 236B MoE | 128K | Chinese, English | MIT | Coding, efficiency |
| DeepSeek R1 | 671B MoE | 128K | Chinese, English | MIT | Reasoning |
| Gemma 2 | 2B, 9B, 27B | 8K | English | Gemma License | Quality at small sizes |
| Phi-3/4 | 3.8B-14B | 4K-128K | English | MIT | Resource-constrained |
| GLM-4 | 9B, 130B MoE | 128K | Chinese, English | MIT | Tool use, Chinese |

## 4. Task-Specific Recommendations

### General Chat / Assistant

- **Best**: Llama 3.1 70B, Qwen 2.5 72B
- **Budget**: Llama 3.1 8B, Mistral 7B, Qwen 2.5 7B
- **Why**: These models have the best instruction-following and conversational ability. Llama excels at nuanced English dialog; Qwen matches it closely with better multilingual support.

### Coding

- **Best**: DeepSeek Coder V2, Qwen 2.5 Coder 32B, Llama 3.1 70B
- **Budget**: DeepSeek Coder V2 Lite, Qwen 2.5 Coder 7B, Phi-4 14B
- **Why**: DeepSeek dominates coding benchmarks with its specialized training. Qwen 2.5 Coder is close behind. Llama 3.1 is a strong generalist that also codes well.

### RAG / Knowledge Retrieval

- **Best**: Qwen 2.5 32B (128K context), Mistral Nemo 12B
- **Budget**: Qwen 2.5 7B, Llama 3.1 8B
- **Why**: Long context is critical for RAG. Qwen 2.5 handles 128K natively. Mistral Nemo has excellent instruction following for retrieval prompts.

### Math / Reasoning

- **Best**: DeepSeek R1, Qwen 2.5 72B, Llama 3.1 70B
- **Budget**: Qwen 2.5 32B, DeepSeek V3, Llama 3.1 8B
- **Why**: DeepSeek R1 is specialized for chain-of-thought reasoning. Qwen 2.5 has strong math capabilities. Llama 3.1 is a solid generalist.

### Creative Writing

- **Best**: Llama 3.1 70B, Mixtral 8x22B, Qwen 2.5 72B
- **Budget**: Llama 3.1 8B, Mistral 7B, Qwen 2.5 7B
- **Why**: Creative writing benefits from the largest models with the most nuanced language understanding. Llama leads here, Mixtral brings diversity.

### Multilingual (Non-English)

- **Best**: Qwen 2.5 (Chinese), Llama 3.1 (general multilingual), Aya (Cohere, 101 languages)
- **Budget**: Qwen 2.5 7B, Llama 3.1 8B
- **Why**: Qwen 2.5 is top for Chinese; Llama 3.1 supports dozens of languages well. Aya is specialized for extreme multilingual.

### Fine-Tuning / Domain Adaptation

- **Best**: Gemma 2 9B/27B, Llama 3.1 8B/70B, Mistral 7B
- **Why**: Gemma 2 has exceptionally clean base models ideal for fine-tuning. Llama has the largest ecosystem of fine-tuning tools and community adapters. Mistral is Apache 2.0 and easy to work with.

### Edge / Mobile

- **Best**: Phi-4 14B, Gemma 2 2B, Llama 3.2 1B/3B, Qwen 2.5 0.5B/1.5B
- **Why**: These models are designed for resource-constrained environments. Phi-4 offers the best quality-per-parameter. Llama 3.2 1B/3B are optimized for on-device deployment.

### Tool Use / Function Calling

- **Best**: GLM-4, Llama 3.1, Qwen 2.5
- **Why**: GLM-4 has native tool-use capabilities. Llama 3.1 and Qwen 2.5 both have strong function-calling fine-tunes available.

## 5. Hardware Constraint Decision Matrix

### VRAM Decision Flowchart

```
Available VRAM?
  |
  +-- < 8GB: Tiny models (1-3B), Q4 or Q5
  |          Llama 3.2 1B/3B, Qwen 2.5 0.5B/1.5B, Gemma 2 2B
  |
  +-- 8-16GB: Small models (7-8B), Q4_K_M to Q5_K_M
  |           Llama 3.1 8B, Mistral 7B, Qwen 2.5 7B, Phi-4
  |
  +-- 16-24GB: Medium models (13-30B), Q4_K_M
  |            Qwen 2.5 14B/32B, Gemma 2 27B, Phi-14B
  |
  +-- 24-48GB: Large models (30-70B), Q4_K_M or Q5_K_M
  |            Qwen 2.5 72B (Q4), Llama 3.1 70B (Q4)
  |
  +-- 48-80GB: Large models (70B), Q4_K_M to Q6_K; XL at Q3
  |            Llama 3.1 70B (Q5/Q6), Qwen 2.5 72B (Q5/Q6)
  |            Mixtral 8x22B (Q4)
  |
  +-- > 80GB: Multi-GPU, any model at higher quants
               DeepSeek R1, Llama 3.1 405B, Qwen 2.5 110B
```

### CPU RAM Requirements (for llama.cpp offloading without GPU)

- **1-3B models**: 2-6GB RAM (Q4-FP16)
- **7-8B models**: 4-16GB RAM (Q4-FP16)
- **14-32B models**: 10-32GB RAM (Q4-FP16)
- **70B models**: 40-80GB RAM (Q4-FP16)
- **405B models**: 200-500GB RAM (Q4-FP16)

### Bandwidth Requirements for Acceptable Speed

CPU inference is bandwidth-bound. Generation speed is roughly proportional to memory bandwidth:

- **DDR4 (25-40 GB/s)**: 1-3 t/s on 7B Q4, usable only for tiny models
- **DDR5 (50-80 GB/s)**: 3-6 t/s on 7B Q4, acceptable for non-real-time
- **Apple Silicon Unified (100-200 GB/s)**: 10-30 t/s on 7B Q4, real-time capable for medium models
- **GPU VRAM (1000-2000 GB/s)**: 100-200 t/s on 7B Q4, real-time for all model sizes

For real-time chat, target at least 10 t/s generation speed. For batch processing, 1-2 t/s may be acceptable.

## 6. License Considerations

| Model Family | License | Commercial Use | Attribution Required | Usage Limit |
|-------------|--------|---------------|-------------------|-------------|
| Llama 3.1 | Llama Community | Yes | No | >700M MAU needs Meta approval |
| Llama 3.2 | Llama Community | Yes | No | >700M MAU needs Meta approval |
| Llama 4 | Llama Community | Yes | No | >700M MAU needs Meta approval |
| Mistral/Mixtral | Apache 2.0 | Yes | Yes (retain notices) | None |
| Qwen 2.5 | Qwen License | Yes | No | <100M MAU free, negotiable above |
| DeepSeek | MIT | Yes | Yes (retain notice) | None |
| Gemma 2 | Gemma License | Yes | No | Usage restrictions apply |
| Phi-3/4 | MIT | Yes | Yes (retain notice) | None |
| GLM-4 | MIT | Yes | Yes (retain notice) | None |

**Key Takeaways**:
- **Apache 2.0 and MIT** are the most permissive. MIT requires only retaining the copyright notice; Apache 2.0 adds patent protection.
- **Llama Community License** is broadly permissive but has the 700M MAU threshold that triggers a special negotiation with Meta. Most companies will never cross this threshold.
- **Gemma License** includes usage restrictions that prohibit certain applications (e.g., surveillance, medical advice without disclaimers). Review the full text.
- **Qwen License** has a 100M MAU monthly active user threshold similar to Llama's.

**Always consult a lawyer for your specific jurisdiction and use case. This table is not legal advice.**

## 7. Emerging Models to Watch

### Llama 4 (Meta)
- First MoE model from Meta (90B total, ~17B active)
- 1M token context window
- Improved multilingual and multimodal capabilities
- Expected to close the gap with GPT-4 quality

### DeepSeek R1 (DeepSeek)
- 671B MoE model specialized for reasoning
- Chain-of-thought trained (GRPO, not PPO/DPO)
- Rivals GPT-4 and Claude on reasoning benchmarks
- Extremely large — requires multi-GPU or extreme quantization

### Qwen 3 (Alibaba)
- Anticipated successor to Qwen 2.5
- Expected improvements in reasoning, context handling, and efficiency
- Early benchmarks suggest significant gains

### Gemma 3 (Google)
- Upcoming larger Gemma model
- Expected with longer context and improved multilingual
- Likely to expand the size range beyond 27B

### Command R+ (Cohere)
- 104B model optimized for RAG and tool use
- Strong multilingual support (10 languages)
- 128K context window
- Custom license

### Dbrx / Databricks
- 132B MoE model (36B active)
- Open weights, Apache 2.0 (conditional)
- Strong coding and reasoning
- Enterprise-focused

## 8. Testing Models Before Committing

### Using Hugging Face Chat / Playgrounds

Many models have free hosted demos:
- Hugging Face Chat (huggingface.co/chat): Llama 3.1, Mistral, Qwen, Gemma, Phi
- DeepSeek Chat (chat.deepseek.com): DeepSeek V3, R1
- Perplexity Labs (labs.perplexity.ai): Various open models

Use these for zero-cost quality assessment before downloading.

### Local Testing with Small Quants First

Download a Q4_K_M quant from Hugging Face (many are pre-quantized by TheBloke, MaziyarPanahi, or other community members). Test on a small sample of your actual data before committing to full-precision deployment.

### Arena Rankings

- **Chatbot Arena** (lmarena.ai): Elo-based ranking from human preferences. Best proxy for real-world conversational quality.
- **Open LLM Leaderboard** (huggingface.co/spaces/open-llm-leaderboard): Automated benchmark leaderboard. Good for comparing standard metrics (MMLU, GSM8K, etc.).

### Benchmark Score Relevance

Benchmarks measure specific capabilities. A high MMLU score does not guarantee good creative writing. A high HumanEval score does not guarantee good conversational ability. Match the benchmark to your task:
- **MMLU**: General knowledge — relevant for QA, information retrieval
- **GSM8K**: Math — relevant for analytical tasks
- **HumanEval / MBPP**: Coding — relevant for code generation
- **HellaSwag / WinoGrande**: Common sense — relevant for decision support

### How to Run Your Own Evaluation

1. Collect 50-100 representative prompts from your use case
2. Build a golden dataset with expected outputs or rubrics
3. Run all candidate models with identical parameters (temp=0, same system prompt)
4. Blind-evaluate outputs (use an LLM judge like GPT-4 or human raters)
5. Score and rank models
6. Factor in speed, memory, and cost

## 9. Decision Checklist

### Before Choosing a Model

- [ ] Define the primary task (chat, coding, retrieval, writing, classification)
- [ ] Define secondary tasks (if any)
- [ ] Determine minimum acceptable quality (example-based)
- [ ] Determine maximum acceptable latency (real-time vs batch)
- [ ] Identify target deployment hardware (GPU model, VRAM, RAM, CPU)
- [ ] Check license compatibility with your use case (commercial, attribution, MAU limits)
- [ ] Verify model supports required languages
- [ ] Check context length requirements against your data

### Before Deploying

- [ ] Download base model (full precision or target quant)
- [ ] Quantize to target level (if not pre-quantized)
- [ ] Test on representative sample (50+ prompts)
- [ ] Benchmark speed (prompt processing and generation t/s)
- [ ] Measure peak memory usage (VRAM and RAM)
- [ ] Compare quality against baseline (unquantized or API model)
- [ ] Verify chat template is correctly applied
- [ ] Test with expected concurrent load
- [ ] Document configuration for reproducibility
- [ ] Set up monitoring for performance regressions

### Ongoing

- [ ] Re-benchmark when model versions change
- [ ] Monitor for quality drift (output changes over time)
- [ ] Track serving costs (compute, power, API equivalents)
- [ ] Evaluate new model releases quarterly
- [ ] Revisit quantization level as hardware needs evolve
