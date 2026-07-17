# Model Compatibility Matrices

## 1. Model Format Support Matrix

For every new model, use this table to determine which quantization formats and runtimes are supported.

| Model Family | GGUF | Ollama | AWQ | GPTQ | EXL2 | vLLM | TGI |
|-------------|------|--------|-----|------|------|------|-----|
| Llama 3.1/3.2/4 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mistral 7B | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mixtral 8x7B/8x22B | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Qwen 2.5 (all sizes) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Qwen 2.5 110B (MoE) | ⚠️ | ⚠️ | ✅ | ✅ | ❌ | ✅ | ✅ |
| DeepSeek V2/V3 | ✅ | ⚠️ | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| DeepSeek R1 (671B) | ✅ | ✅ | ⚠️ | ⚠️ | ⚠️ | ✅ | ⚠️ |
| DeepSeek Coder | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| Gemma 2B/9B/27B | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| Phi-3/Phi-4 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| GLM-4 9B | ⚠️ | ⚠️ | ⚠️ | ✅ | ❌ | ✅ | ⚠️ |
| GLM-5 130B (MoE) | ❌ | ❌ | ⚠️ | ⚠️ | ❌ | ⚠️ | ⚠️ |
| Command-R / R+ | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| DBRX 132B | ✅ | ⚠️ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Falcon 7B/40B/180B | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| InternLM 2 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| OLMo | ✅ | ✅ | ⚠️ | ✅ | ❌ | ✅ | ⚠️ |
| StableLM 2 / Zephyr | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Jais 30B | ✅ | ✅ | ❌ | ✅ | ❌ | ⚠️ | ⚠️ |
| Baichuan 2 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Nemotron 4 | ⚠️ | ⚠️ | ❌ | ✅ | ❌ | ✅ | ❌ |
| EXAONE 3.0 | ⚠️ | ⚠️ | ❌ | ⚠️ | ❌ | ⚠️ | ❌ |
| MPT 7B/30B | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |

**Legend**: ✅ = Supported, ⚠️ = Partial/Check, ❌ = Not supported

## 2. Quantization Format Capabilities

| Feature | GGUF | AWQ | GPTQ | EXL2 |
|---------|------|-----|------|------|
| Bit-width | 2-8 bit | 4 bit only | 2/3/4/8 bit | Variable (2-8 bpw) |
| Quality at 4-bit | Good | Excellent | Very Good | Excellent |
| CPU inference | ✅ (primary) | ❌ | ❌ | ❌ |
| GPU inference | ✅ | ✅ (Marlin) | ✅ (ExLlama) | ✅ (fastest) |
| Calibration required | Only for I-quants | Yes | Yes | Yes |
| Batch inference | Limited | Excellent | Excellent | Single-batch focused |
| MoE support | ✅ | ✅ | ✅ | ✅ |
| Transformers loadable | ❌ | ✅ | ✅ | ❌ |
| vLLM integration | ❌ | ✅ | ✅ | ❌ |
| Ollama support | ✅ | ⚠️ (via llama.cpp) | ❌ | ❌ |
| File size at 4-bit (7B) | ~4.5 GB | ~4.0 GB | ~4.0 GB | ~4.0 GB |
| File size at 4-bit (70B) | ~39 GB | ~35 GB | ~35 GB | ~35 GB |

## 3. Runtime Compatibility

| Runtime | GGUF | AWQ | GPTQ | EXL2 | NF4 |
|---------|------|-----|------|------|-----|
| llama.cpp | ✅ native | ❌ | ❌ | ❌ | ❌ |
| Ollama | ✅ native | ⚠️ (via backend) | ❌ | ❌ | ❌ |
| vLLM | ❌ | ✅ native | ✅ native | ❌ | ✅ |
| TGI | ❌ | ✅ native | ✅ native | ❌ | ❌ |
| SGLang | ❌ | ✅ | ✅ | ❌ | ❌ |
| ExLlamaV2 | ❌ | ✅ | ✅ | ✅ native | ❌ |
| Transformers | ❌ | ✅ | ✅ | ❌ | ✅ (bnb) |
| LM Studio | ✅ native | ❌ | ❌ | ❌ | ❌ |
| GPT4All | ✅ native | ❌ | ❌ | ❌ | ❌ |
| KoboldCPP | ✅ native | ❌ | ❌ | ❌ | ❌ |
| llama-cpp-python | ✅ native | ❌ | ❌ | ❌ | ❌ |

## 4. Architecture Support by Runtime

| Architecture | llama.cpp | vLLM | TGI | ExLlamaV2 |
|-------------|-----------|------|-----|-----------|
| LlamaForCausalLM | ✅ | ✅ | ✅ | ✅ |
| MistralForCausalLM | ✅ | ✅ | ✅ | ✅ |
| MixtralForCausalLM | ✅ | ✅ | ✅ | ✅ |
| Qwen2ForCausalLM | ✅ | ✅ | ✅ | ⚠️ |
| Qwen2MoeForCausalLM | ✅ | ✅ | ✅ | ❌ |
| DeepseekV2ForCausalLM | ✅ | ✅ | ✅ | ⚠️ |
| DeepseekV3ForCausalLM | ✅ | ✅ | ⚠️ | ❌ |
| GemmaForCausalLM | ✅ | ✅ | ✅ | ✅ |
| Gemma2ForCausalLM | ✅ | ✅ | ✅ | ✅ |
| Phi3ForCausalLM | ✅ | ✅ | ✅ | ❌ |
| PhiForCausalLM | ✅ | ✅ | ✅ | ❌ |
| PhiMoEForCausalLM | ✅ | ✅ | ✅ | ❌ |
| FalconForCausalLM | ✅ | ✅ | ✅ | ❌ |
| CohereForCausalLM | ✅ | ✅ | ✅ | ❌ |
| DbrxForCausalLM | ✅ | ✅ | ✅ | ❌ |
| InternLM2ForCausalLM | ✅ | ✅ | ✅ | ❌ |
| GLMForCausalLM | ⚠️ | ✅ | ⚠️ | ❌ |
| ChatGLMForCausalLM | ⚠️ | ✅ | ⚠️ | ❌ |
| BaichuanForCausalLM | ✅ | ✅ | ✅ | ❌ |
| MPTForCausalLM | ✅ | ✅ | ✅ | ❌ |
| OPTForCausalLM | ✅ | ❌ | ❌ | ❌ |
