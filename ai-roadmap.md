# 🧠 AI Engineer Learning Roadmap 2026

> A comprehensive, structured guide to becoming a production-ready AI Engineer.
> Target duration: **9–12 months** | Effort: **15–20 hrs/week**

---

## Table of Contents

- [1. How to Use This Roadmap](#1-how-to-use-this-roadmap)
- [2. Python](#2-python)
- [3. Data Structures & Algorithms](#3-data-structures--algorithms)
- [4. Data Analysis & Visualization](#4-data-analysis--visualization)
- [5. Machine Learning](#5-machine-learning)
- [6. Deep Learning](#6-deep-learning)
- [7. Generative AI](#7-generative-ai)
- [8. Large Language Models](#8-large-language-models)
- [9. Prompt Engineering](#9-prompt-engineering)
- [10. Embeddings](#10-embeddings)
- [11. Vector Databases](#11-vector-databases)
- [12. Retrieval-Augmented Generation (RAG)](#12-retrieval-augmented-generation-rag)
- [13. AI Agents](#13-ai-agents)
- [14. MLOps](#14-mlops)
- [15. End-to-End Projects](#15-end-to-end-projects)
- [16. Curated Documentation](#16-curated-documentation)
- [17. Free Courses](#17-free-courses)
- [18. Books](#18-books)
- [19. Best YouTube Channels](#19-best-youtube-channels)
- [20. Best Playlists](#20-best-playlists)
- [21. GitHub Repositories](#21-github-repositories)
- [22. Weekly Milestones](#22-weekly-milestones)
- [23. Progress Tracker](#23-progress-tracker)
- [24. Interview Preparation](#24-interview-preparation)
- [25. Portfolio Projects](#25-portfolio-projects)
- [26. Career Opportunities](#26-career-opportunities)

---

## 1. How to Use This Roadmap

- [ ] Read the entire roadmap once to understand the scope
- [ ] Set up a weekly schedule blocking 15–20 hours
- [ ] Work through sections sequentially — each builds on the last
- [ ] Complete at least **one project per major section**
- [ ] Track progress using the checkboxes in Section 23
- [ ] Join communities: [r/learnmachinelearning](https://reddit.com/r/learnmachinelearning), [r/LocalLLaMA](https://reddit.com/r/LocalLLaMA), [AI Engineer Discord](https://discord.gg/ai-engineer)

> 💡 **Tip:** Don't rush. Deep understanding > breadth. Build projects, take notes, and revisit weak areas.

---

## 2. Python

> Python is the lingua franca of AI. Mastery here is non-negotiable.

### 2.1 Python Basics

- [ ] Data types: `int`, `float`, `str`, `list`, `tuple`, `dict`, `set`, `frozenset`, `bytes`, `bytearray`
- [ ] Control flow: `if`/`elif`/`else`, `for`, `while`, `match` (3.10+)
- [ ] Functions: `def`, `lambda`, `*args`, `**kwargs`, type hints (`typing` module)
- [ ] Comprehensions: list, dict, set, nested
- [ ] Error handling: `try`/`except`/`else`/`finally`, custom exceptions
- [ ] File I/O: `open`, context managers (`with`), `pathlib`
- [ ] Modules & packages: `__init__.py`, `import`, `sys.path`

### 2.2 Object-Oriented Programming

- [ ] Classes & instances, `__init__`, `self`
- [ ] Inheritance: single, multiple, MRO (`super()`)
- [ ] Magic methods: `__str__`, `__repr__`, `__len__`, `__getitem__`, `__call__`, `__enter__`/`__exit__`
- [ ] Properties: `@property`, `@setter`, `@deleter`
- [ ] Class methods & static methods: `@classmethod`, `@staticmethod`
- [ ] Decorators: `@decorator`, `functools.wraps`, decorators with args
- [ ] Metaclasses: `type()`, custom metaclasses, `__new__` vs `__init__`
- [ ] Abstract base classes: `abc.ABC`, `@abstractmethod`
- [ ] Dataclasses: `@dataclass`, `field()`, `__post_init__`
- [ ] Descriptors: `__get__`, `__set__`, `__delete__`

### 2.3 Functional Programming

- [ ] `map()`, `filter()`, `reduce()` (`functools.reduce`)
- [ ] `itertools`: `chain`, `product`, `permutations`, `combinations`, `groupby`, `cycle`, `count`
- [ ] `functools`: `partial`, `lru_cache`, `singledispatch`, `cmp_to_key`
- [ ] Generator functions: `yield`, `yield from`, generator expressions
- [ ] `operator` module: `itemgetter`, `attrgetter`, `methodcaller`

### 2.4 Async Python

- [ ] `async`/`await` syntax
- [ ] `asyncio` event loop: `run()`, `create_task()`, `gather()`, `wait()`
- [ ] `asyncio.Queue`, `asyncio.Lock`, `asyncio.Semaphore`
- [ ] `aiohttp` for async HTTP
- [ ] `httpx` (async client)
- [ ] Async generators: `async for`, `async with`
- [ ] `anyio` (cross-platform async)
- [ ] `asyncio.run_in_executor` for CPU-bound tasks

> 📘 **Resource:** [Real Python — Async IO Tutorial](https://realpython.com/async-io-python/)

---

## 3. Data Structures & Algorithms

> Essential for interviews and writing efficient ML pipelines.

### 3.1 Arrays & Strings

- [ ] Two pointers, sliding window
- [ ] Prefix sums, difference arrays
- [ ] Kadane's algorithm (max subarray)
- [ ] String matching: KMP, Rabin-Karp
- [ ] Dutch national flag problem
- [ ] Next permutation

### 3.2 Trees

- [ ] Binary trees: traversal (pre/in/post/level-order), LCA, diameter
- [ ] BST: insert, delete, search, validation, kth smallest
- [ ] AVL trees: rotations, balance factor
- [ ] Tries: insert, search, prefix search, autocomplete
- [ ] Segment trees: range queries, point updates, lazy propagation
- [ ] Binary indexed tree (Fenwick tree)
- [ ] Heap: `heapq`, min/max heap, heap sort

### 3.3 Graphs

- [ ] Representations: adjacency list, matrix, edge list
- [ ] BFS: level-order, shortest path (unweighted), bipartite check
- [ ] DFS: connected components, topological sort, cycle detection
- [ ] Dijkstra: shortest path (weighted), priority queue
- [ ] Bellman-Ford: negative edges, detect negative cycles
- [ ] Floyd-Warshall: all-pairs shortest
- [ ] Union-Find (DSU): path compression, union by rank
- [ ] Minimum spanning tree: Kruskal, Prim
- [ ] A* search algorithm

### 3.4 Dynamic Programming

- [ ] Memoization (top-down) vs tabulation (bottom-up)
- [ ] 0/1 Knapsack and unbounded knapsack
- [ ] Longest Common Subsequence (LCS)
- [ ] Longest Increasing Subsequence (LIS) — O(n log n)
- [ ] Edit distance (Levenshtein)
- [ ] Matrix chain multiplication
- [ ] DP on trees
- [ ] DP with bitmasking
- [ ] DP on intervals

### 3.5 Interview Patterns (LeetCode)

- [ ] Blind 75 / Neetcode 150
- [ ] Top 100 Liked Questions
- [ ] Company-specific: Google, Meta, OpenAI, Anthropic
- [ ] System design: distributed ML systems, model serving

> 💡 **Practice:** [LeetCode](https://leetcode.com), [NeetCode](https://neetcode.io), [HackerRank](https://hackerrank.com)

---

## 4. Data Analysis & Visualization

### 4.1 NumPy

- [ ] `ndarray`: creation, shape, reshape, dtype
- [ ] Indexing: fancy indexing, boolean masking, slicing
- [ ] Broadcasting rules and examples
- [ ] Vectorization: `np.vectorize`, ufuncs
- [ ] Linear algebra: `np.linalg.inv`, `eig`, `svd`, `qr`, `lstsq`
- [ ] Random: `np.random.rand`, `randn`, `seed`, `Generator` API
- [ ] Statistical functions: `mean`, `std`, `var`, `corrcoef`, `histogram`
- [ ] NumPy performance: `np.einsum`, memory views, strides
- [ ] Structured arrays and `np.recarray`

### 4.2 Pandas

- [ ] `Series` and `DataFrame` creation
- [ ] `read_csv`, `read_excel`, `read_parquet`, `read_sql`
- [ ] Indexing: `.loc`, `.iloc`, `query()`, `boolean indexing`
- [ ] `groupby`: aggregation, transform, filter, apply
- [ ] `merge`, `join`, `concat`
- [ ] `pivot_table`, `melt`, `stack`, `unstack`
- [ ] Time series: `date_range`, `resample`, `rolling`, `shift`, `diff`
- [ ] Handling missing data: `isna`, `fillna`, `dropna`, `interpolate`
- [ ] String operations: `.str` accessor, regex
- [ ] Categorical data: `CategoricalDtype`
- [ ] MultiIndex: creation, slicing, cross-section
- [ ] Performance: `eval`, `query`, `swifter`, `modin`

### 4.3 Matplotlib

- [ ] Figure & Axes: `plt.subplots()`, `add_axes`
- [ ] Line plots: `plot()`, markers, line styles, colors
- [ ] Scatter plots: `scatter()`, size, color maps
- [ ] Bar charts: `bar()`, `barh()`, stacked bars
- [ ] Histograms: `hist()`, bins, density, cumulative
- [ ] Subplots: `subplots()`, `GridSpec`
- [ ] Customization: titles, labels, legends, ticks, grids
- [ ] Saving figures: `savefig()`, DPI, formats
- [ ] `rcParams` and style sheets
- [ ] Animations: `FuncAnimation`, `ArtistAnimation`

### 4.4 Seaborn

- [ ] `sns.set_theme()`, `sns.set_style()`
- [ ] Relational plots: `relplot`, `scatterplot`, `lineplot`
- [ ] Categorical plots: `catplot`, `boxplot`, `violinplot`, `barplot`
- [ ] Distribution plots: `histplot`, `kdeplot`, `ecdfplot`
- [ ] Heatmaps: `heatmap()`, `clustermap()`
- [ ] Pair plots: `pairplot()`, `PairGrid()`
- [ ] Regression plots: `lmplot()`, `regplot()`

### 4.5 Polars

- [ ] Lazy vs eager execution: `pl.LazyFrame` vs `pl.DataFrame`
- [ ] Expressions API: `pl.col()`, `pl.when()`, `pl.all()`
- [ ] `group_by()`, `agg()`, `sort()`, `filter()`, `with_columns()`
- [ ] Joins: `join()`, how strategies
- [ ] Window functions: `over()`
- [ ] Performance comparison: Polars vs Pandas
- [ ] Streaming queries for out-of-core processing

> 📘 **Resource:** [Polars User Guide](https://pola-rs.github.io/polars-book/user-guide/)

---

## 5. Machine Learning

### 5.1 Scikit-Learn

- [ ] `Pipeline`: chaining transformers and estimators
- [ ] `ColumnTransformer`: applying different transforms to different columns
- [ ] `FunctionTransformer`: custom transformations
- [ ] `make_pipeline`, `make_column_transformer`
- [ ] `GridSearchCV`, `RandomizedSearchCV`, `HalvingGridSearchCV`
- [ ] `cross_val_score`, `cross_validate`, `cross_val_predict`
- [ ] Custom transformers: inheriting `BaseEstimator`, `TransformerMixin`

### 5.2 Regression

- [ ] Linear Regression: `LinearRegression`, OLS, closed-form solution
- [ ] Polynomial Regression: `PolynomialFeatures`, degree selection
- [ ] Ridge Regression: L2 regularization, `alpha` tuning
- [ ] Lasso Regression: L1 regularization, feature selection
- [ ] ElasticNet: combining L1 + L2
- [ ] Regression metrics: MSE, RMSE, MAE, R², adjusted R²
- [ ] Assumptions: linearity, homoscedasticity, normality of residuals

### 5.3 Classification

- [ ] Logistic Regression: sigmoid, log-loss, multiclass (OvR, multinomial)
- [ ] SVM: `SVC`, `SVR`, kernels (RBF, poly, sigmoid), margin, C, gamma
- [ ] Decision Trees: `DecisionTreeClassifier`, entropy, Gini, pruning
- [ ] Random Forest: `RandomForestClassifier`, bagging, feature importance
- [ ] Gradient Boosting: `GradientBoostingClassifier`, learning rate, n_estimators
- [ ] XGBoost: `xgb.XGBClassifier`, `xgb.DMatrix`, GPU training
- [ ] LightGBM: `lgb.LGBMClassifier`, categorical features, leaf-wise growth
- [ ] CatBoost: `catboost.CatBoostClassifier`, ordered boosting, text features
- [ ] Imbalanced classification: SMOTE, class_weight, `imbalanced-learn`
- [ ] Classification metrics: accuracy, precision, recall, F1, log-loss, MCC

### 5.4 Clustering

- [ ] K-Means: `KMeans`, elbow method, silhouette score
- [ ] DBSCAN: `DBSCAN`, eps, min_samples, noise points
- [ ] Hierarchical clustering: `AgglomerativeClustering`, dendrograms
- [ ] Gaussian Mixture Models: `GaussianMixture`, EM algorithm
- [ ] Clustering metrics: silhouette, Davies-Bouldin, Calinski-Harabasz

### 5.5 Feature Engineering

- [ ] Encoding: OneHotEncoder, LabelEncoder, OrdinalEncoder, TargetEncoder
- [ ] Scaling: StandardScaler, MinMaxScaler, RobustScaler, MaxAbsScaler
- [ ] Feature selection: SelectKBest, RFE, SelectFromModel, VarianceThreshold
- [ ] Dimensionality reduction: PCA, t-SNE, UMAP
- [ ] Polynomial features, spline features
- [ ] Date/time features: day of week, month, quarter, is_weekend, holidays
- [ ] Text features: TF-IDF, CountVectorizer, HashingVectorizer

### 5.6 Model Evaluation

- [ ] Train/val/test split: `train_test_split`, stratified split
- [ ] K-Fold, StratifiedKFold, GroupKFold
- [ ] ROC curve, AUC-ROC, AUC-PR
- [ ] Confusion matrix: TP, TN, FP, FN
- [ ] Bias-variance tradeoff: underfitting vs overfitting
- [ ] Learning curves, validation curves
- [ ] Calibration curves: `CalibratedClassifierCV`
- [ ] Feature importance: permutation importance, SHAP, LIME

> 📘 **Resource:** [Scikit-Learn Documentation](https://scikit-learn.org/stable/documentation.html)

---

## 6. Deep Learning

### 6.1 PyTorch

- [ ] Tensors: creation, dtype, device, shape manipulation
- [ ] Autograd: `torch.autograd`, `backward()`, `grad_fn`
- [ ] `nn.Module`: custom modules, `forward()`, `parameters()`
- [ ] `nn.Sequential`, `nn.ModuleList`, `nn.ModuleDict`
- [ ] `torch.utils.data.Dataset`, `DataLoader`, `Sampler`
- [ ] Optimizers: `optim.SGD`, `optim.Adam`, `optim.AdamW`, `optim.lr_scheduler`
- [ ] Loss functions: `nn.CrossEntropyLoss`, `nn.MSELoss`, `nn.BCEWithLogitsLoss`
- [ ] Training loop: forward pass, loss, backward, optimizer step
- [ ] Gradient clipping: `nn.utils.clip_grad_norm_`
- [ ] Mixed precision training: `torch.cuda.amp`
- [ ] Distributed training: `DistributedDataParallel`, `torchrun`
- [ ] `torch.compile`: graph compilation with `torch dynamo`
- [ ] `torch.jit.script` and `torch.jit.trace`
- [ ] ONNX export: `torch.onnx.export`
- [ ] `torch.nn.init`: weight initialization strategies
- [ ] Checkpointing: `torch.save`, `torch.load`, `state_dict`

### 6.2 TensorFlow / Keras

- [ ] `tf.keras.Sequential`, `tf.keras.Model` (Functional API)
- [ ] Custom layers: subclassing `tf.keras.layers.Layer`
- [ ] `tf.data.Dataset`: from_tensor_slices, map, batch, prefetch, cache
- [ ] Eager execution: `tf.config.run_functions_eagerly`
- [ ] Training: `model.fit()`, `model.compile()`, custom training loops
- [ ] Callbacks: `ModelCheckpoint`, `EarlyStopping`, `ReduceLROnPlateau`, `TensorBoard`
- [ ] `tf.distribute.Strategy`: MirroredStrategy, MultiWorkerMirroredStrategy
- [ ] Serving: `SavedModel` format, `tf.saved_model.save`, `TFServing`
- [ ] `tf.keras.layers.Lambda`, custom `Regularizer`
- [ ] `tf.keras.metrics`: custom metrics
- [ ] `tf.function`: graph compilation via `@tf.function`
- [ ] KerasTuner: hyperparameter search

### 6.3 CNNs

- [ ] Convolution: `nn.Conv2d`, kernel size, stride, padding, dilation
- [ ] Pooling: `nn.MaxPool2d`, `nn.AvgPool2d`, `nn.AdaptiveAvgPool2d`
- [ ] Batch Normalization: `nn.BatchNorm2d`, `nn.BatchNorm1d`
- [ ] Dropout: `nn.Dropout`, `nn.Dropout2d`
- [ ] ResNet architecture: residual connections, bottleneck blocks
- [ ] EfficientNet: compound scaling (depth, width, resolution)
- [ ] MobileNet: depthwise separable convolutions
- [ ] Architectures: VGG, Inception (GoogLeNet), DenseNet, ConvNeXt
- [ ] Transfer learning: `torchvision.models`, fine-tuning, feature extraction
- [ ] Object detection: YOLO (ultralytics), Faster R-CNN, SSD
- [ ] Semantic segmentation: U-Net, DeepLabV3+

### 6.4 RNNs / LSTMs

- [ ] RNN: `nn.RNN`, vanishing gradient problem
- [ ] LSTM: `nn.LSTM`, forget gate, input gate, output gate, cell state
- [ ] GRU: `nn.GRU`, reset gate, update gate
- [ ] Bidirectional RNNs: `bidirectional=True`
- [ ] Packing sequences: `nn.utils.rnn.pack_padded_sequence`, `pad_packed_sequence`
- [ ] Sequence classification and sequence labeling
- [ ] Encoder-decoder architecture

### 6.5 Transformers

- [ ] Self-attention: Q, K, V, scaled dot-product attention
- [ ] Multi-head attention: `nn.MultiheadAttention`
- [ ] Positional encoding: sinusoidal, learnable
- [ ] Transformer encoder: `nn.TransformerEncoder`, `nn.TransformerEncoderLayer`
- [ ] Transformer decoder: `nn.TransformerDecoder`, `nn.TransformerDecoderLayer`
- [ ] Masking: padding mask, causal mask, `attn_mask`
- [ ] Layer Normalization: `nn.LayerNorm`
- [ ] Feed-forward network: position-wise FFN
- [ ] Vision Transformer (ViT): patch embedding, CLS token

> 📘 **Resource:** [PyTorch Tutorials](https://pytorch.org/tutorials/) | [TensorFlow Tutorials](https://www.tensorflow.org/tutorials)

---

## 7. Generative AI

### 7.1 Foundation Models

- [ ] GPT family: GPT-3, GPT-3.5, GPT-4, GPT-4o, GPT-4o-mini
- [ ] Claude family: Claude 3 Haiku, Sonnet, Opus; Claude 3.5 Sonnet
- [ ] Gemini: Gemini 1.5 Pro, Flash, Nano
- [ ] Open-source: Llama 3, Mistral, Mixtral, Falcon, DeepSeek
- [ ] Multimodal: CLIP, BLIP-2, LLaVA, Qwen-VL
- [ ] Image: DALL-E 3, Midjourney, Stable Diffusion 3, Imagen

### 7.2 Diffusion Models

- [ ] DDPM: forward (noise) process, reverse (denoising) process
- [ ] Noise schedule: cosine, linear, scaled linear
- [ ] U-Net architecture for diffusion
- [ ] Classifier-free guidance: conditional vs unconditional
- [ ] Stable Diffusion: VAE, CLIP text encoder, U-Net
- [ ] Latent Diffusion Models (LDMs)
- [ ] `diffusers` library: pipelines, schedulers, models
- [ ] Text-to-image: `StableDiffusionPipeline`
- [ ] Image-to-image: `StableDiffusionImg2ImgPipeline`
- [ ] Inpainting: `StableDiffusionInpaintPipeline`
- [ ] ControlNet: conditioned control (canny, depth, pose, scribble)
- [ ] LoRA for diffusion models (DreamBooth, style transfer)
- [ ] Video diffusion: Stable Video Diffusion

### 7.3 Hugging Face Ecosystem

- [ ] `transformers`: `AutoModel`, `AutoTokenizer`, `AutoConfig`, `pipeline()`
- [ ] `diffusers`: diffusion pipelines, schedulers, DPM solvers
- [ ] `datasets`: `load_dataset()`, dataset processing, streaming
- [ ] `accelerate`: device placement, mixed precision, FSDP, DeepSpeed
- [ ] `peft`: LoRA, prefix tuning, prompt tuning, IA3
- [ ] `trl`: `SFTTrainer`, `DPOTrainer`, `PPOTrainer`
- [ ] `tokenizers`: fast BPE, WordPiece, Unigram
- [ ] `evaluate`: metrics library
- [ ] `optimum`: ONNX, Intel, OpenVINO optimizations
- [ ] Hugging Face Hub: model upload, Spaces, Git LFS

> 💡 **Tip:** The Hugging Face ecosystem is the single most important toolkit for modern AI engineering. Learn it deeply.

---

## 8. Large Language Models

### 8.1 Tokenization

- [ ] BPE: Byte-Pair Encoding (GPT-2, GPT-3, GPT-4)
- [ ] WordPiece (BERT): `##` prefix for subwords
- [ ] SentencePiece: Unigram LM, BPE, no pretokenization
- [ ] `tiktoken`: OpenAI's fast BPE tokenizer (cl100k_base, o200k_base)
- [ ] Special tokens: `[CLS]`, `[SEP]`, `[PAD]`, `[MASK]`, `<|endoftext|>`
- [ ] Tokenizer training: `train_new_from_iterator`
- [ ] Vocabulary size trade-offs

### 8.2 Attention Mechanisms

- [ ] Scaled dot-product attention: `Q*K^T / sqrt(d_k)`
- [ ] Multi-head attention: `num_heads`, `head_dim`
- [ ] Flash Attention: tiling, recomputation, IO-aware (flash-attn 2.x)
- [ ] KV Cache: key-value caching for autoregressive decoding
- [ ] Grouped Query Attention (GQA): used in Llama 2/3
- [ ] Multi-Query Attention (MQA)
- [ ] Sliding window attention: Mistral, Mixtral
- [ ] Sparse attention: Longformer, BigBird

### 8.3 Fine-Tuning LLMs

- [ ] Full fine-tuning: all parameters, requires high VRAM
- [ ] Instruction tuning: (instruction, response) pairs
- [ ] Chat templating: `apply_chat_template()`, messages format
- [ ] RLHF: reward model + PPO optimization
- [ ] DPO: Direct Preference Optimization (simpler than RLHF)
- [ ] KTO: Kahneman-Tversky Optimization
- [ ] ORPO: Odds Ratio Preference Optimization
- [ ] Supervised Fine-Tuning (SFT)
- [ ] Alignment: helpfulness, harmlessness, honesty (HHH)

### 8.4 LoRA

- [ ] Low-rank adaptation: `A * B` decomposition, `r` rank
- [ ] `peft.LoraConfig`: `r`, `lora_alpha`, `target_modules`, `lora_dropout`
- [ ] Rank selection: higher r = more capacity, lower r = more efficiency
- [ ] LoRA fusion (merge weights after training)
- [ ] Adapting only certain modules (q_proj, v_proj, k_proj, o_proj)
- [ ] Multi-LoRA serving (LoRA swapping, Punica)
- [ ] LoRA for: text, vision, multimodal models
- [ ] DoRA: Weight-Decomposed Low-Rank Adaptation

### 8.5 QLoRA

- [ ] 4-bit NormalFloat (NF4) quantization
- [ ] Double quantization: quantizing quantization constants
- [ ] Paged optimizers: offload optimizer states to CPU
- [ ] `BitsAndBytesConfig`: `load_in_4bit`, `bnb_4bit_quant_type`, `bnb_4bit_compute_dtype`
- [ ] Fine-tuning a 65B model on a single 48GB GPU
- [ ] GPTQ: post-training quantization, `auto_gptq`
- [ ] AWQ: Activation-Aware Weight Quantization
- [ ] GGUF/GGML: llama.cpp format, CPU-friendly, Mac support

### 8.6 PEFT (Parameter-Efficient Fine-Tuning)

- [ ] Prefix Tuning: learn virtual tokens prepended to keys/values
- [ ] Prompt Tuning: learn soft prompt embeddings (`soft_embeddings`)
- [ ] P-Tuning: LSTM/MLP to generate prompt embeddings
- [ ] P-Tuning v2: prefix tuning on every layer
- [ ] IA3: learn rescaling vectors (infused adapter)
- [ ] Adapter: bottleneck adapters (Houlsby et al.)
- [ ] Comparison table:

| Method | Parameters Added | Performance | Memory | Use Case |
|--------|-----------------|-------------|--------|----------|
| Full FT | 100% | Best | Very High | Max accuracy |
| LoRA | ~0.1-1% | Nearly match | Low | General fine-tuning |
| QLoRA | ~0.1-1% | 99%+ of LoRA | Very Low | Single GPU training |
| Prefix Tuning | ~0.01-0.1% | Good | Low | Task adaptation |
| Prompt Tuning | ~0.01% | Moderate | Lowest | Simple tasks |
| IA3 | ~0.01% | Good | Lowest | Efficient adaptation |
| Adapter | ~1-5% | Good | Low | Layer-wise adaptation |

---

## 9. Prompt Engineering

- [ ] **Zero-shot**: "Translate to French: Hello"
- [ ] **Few-shot**: Provide 2-5 examples before the query
- [ ] k-shot selection: random, similarity-based (k-NN on embeddings), diversity
- [ ] **Chain-of-Thought (CoT)**: "Let's think step by step"
- [ ] Auto-CoT: use "Let's think step by step" with few-shot
- [ ] Zero-shot CoT: just add "Let's think step by step"
- [ ] **Tree-of-Thought (ToT)**: explore multiple reasoning paths
- [ ] **Self-Consistency**: sample multiple CoT paths, majority vote
- [ ] **ReAct**: Reason + Act (thought, action, observation)
- [ ] **Structured Outputs**:
  - JSON mode: `response_format={ "type": "json_object" }` (OpenAI)
  - Function calling: `tools`, `tool_choice`
  - Constrained decoding: `outlines`, `lm-format-enforcer`, `guidance`
- [ ] **Prompt templates**: LangChain's `PromptTemplate`, `ChatPromptTemplate`
- [ ] **System prompts**: system role, guardrails, persona, constraints
- [ ] **Prompt engineering tips**:
  - Be specific and precise
  - Use delimiters (```, """, ---)
  - Ask for structured output (bullet points, JSON, markdown)
  - Provide examples
  - Assign a persona ("You are an expert...")
  - Use negative prompts ("Do NOT...")
- [ ] **Prompt evaluation**: promptfoo, LangSmith, Spacy

> 📘 **Resource:** [OpenAI Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)

---

## 10. Embeddings

### 10.1 Sentence Transformers

- [ ] `sentence-transformers` library: `SentenceTransformer`
- [ ] `all-MiniLM-L6-v2`: 384-dim, fast, general purpose
- [ ] `all-mpnet-base-v2`: 768-dim, better accuracy, slower
- [ ] `multi-qa-mpnet-base-dot-v1`: optimized for Q&A
- [ ] `intfloat/e5-mistral-7b-instruct`: 4096-dim, state-of-the-art
- [ ] Model comparison:

| Model | Dimensions | Speed | Quality | Use Case |
|-------|-----------|-------|---------|----------|
| all-MiniLM-L6-v2 | 384 | ⚡⚡⚡ | Good | General, quick retrieval |
| all-mpnet-base-v2 | 768 | ⚡⚡ | Better | Higher accuracy needs |
| bge-large-en-v1.5 | 1024 | ⚡ | Great | Enterprise retrieval |
| e5-mistral-7b-instruct | 4096 | 🐢 | Best | Research-grade |
| gte-Qwen2-7B-instruct | 3584 | 🐢 | Best | Multilingual retrieval |

- [ ] Pooling strategies: mean, CLS, max
- [ ] Normalization: cosine similarity requires normalized vectors
- [ ] Asymmetric retrieval: `q_model` vs `doc_model` (BGE)
- [ ] Fine-tuning embeddings: `SentenceTransformerTrainer`, triplet loss, contrastive loss

### 10.2 OpenAI Embeddings

- [ ] `text-embedding-3-small`: 512/1536 dim, $0.02/1M tokens
- [ ] `text-embedding-3-large`: 256/1024/3072 dim, $0.13/1M tokens
- [ ] `text-embedding-ada-002`: 1536 dim (legacy, $0.10/1M tokens)
- [ ] Dimensionality: can use `dimensions` parameter to truncate
- [ ] Pricing comparison: small = 6.5x cheaper than large
- [ ] Best practices: chunk before embedding, handle text length limits (8k tokens)

### 10.3 BGE (BAAI/BGE Series)

- [ ] `BAAI/bge-base-en-v1.5`: 768 dim
- [ ] `BAAI/bge-large-en-v1.5`: 1024 dim
- [ ] `BAAI/bge-m3`: multilingual, 8192 dim
- [ ] Prefixes: `"query: "` and `"passage: "` for asymmetric retrieval
- [ ] BGE embedding + reranker: `BAAI/bge-reranker-v2-m3`

### 10.4 E5

- [ ] `intfloat/e5-base-v2`: 768 dim, `"query: "` / `"passage: "` prefixes
- [ ] `intfloat/e5-large-v2`: 1024 dim
- [ ] `intfloat/e5-mistral-7b-instruct`: 4096 dim, instruction-tuned
- [ ] `intfloat/multilingual-e5-large`: multilingual, 1024 dim
- [ ] `intfloat/e5-text-embedding-adapters`: compatibility with OpenAI format

### 10.5 Embedding Evaluation

- [ ] MTEB Leaderboard: [huggingface.co/spaces/mteb/leaderboard](https://huggingface.co/spaces/mteb/leaderboard)
- [ ] Tasks: classification, clustering, pair classification, reranking, retrieval, STS, summarization
- [ ] BEIR benchmark: retrieval tasks
- [ ] Evaluate your own: `mteb` library, `sentence-transformers.evaluation`

> 📘 **Resource:** [Hugging Face Embedding Models Guide](https://huggingface.co/blog/getting-started-with-embeddings)

---

## 11. Vector Databases

### 11.1 FAISS

- [ ] Index types: `IndexFlatL2`, `IndexFlatIP`, `IndexHNSW`
- [ ] IVF: `IndexIVFFlat`, nprobe, nlist
- [ ] HNSW: `IndexHNSWFlat`, M, efConstruction, efSearch
- [ ] Product quantization: `IndexIVFPQ`, `IndexPQ`
- [ ] GPU support: `GpuIndexFlatL2`, `StandardGpuResources`
- [ ] `IndexIDMap`, `IndexIDMap2` for custom IDs
- [ ] Search parameters: `index.search()`, `index.range_search()`
- [ ] Training: `index.train()` for IVF indices
- [ ] Serialization: `faiss.write_index()`, `faiss.read_index()`
- [ ] `faiss.merge_ids` for distributed indexing
- [ ] Binary indices: `IndexBinaryFlat`, `IndexBinaryIVF`

### 11.2 Chroma DB

- [ ] In-memory: `chromadb.Client()`, ephemeral
- [ ] Persistent: `chromadb.PersistentClient(path="./chroma_db")`
- [ ] Collections: `client.create_collection()`, `get_collection()`
- [ ] Add documents: `collection.add()`, `collection.upsert()`
- [ ] Query: `collection.query()`, `collection.get()`
- [ ] Metadata filtering: `where` parameter
- [ ] Embedding functions: `OpenAIEmbeddingFunction`, `SentenceTransformerEmbeddingFunction`
- [ ] Distance functions: l2, ip, cosine
- [ ] `chromadb.utils.embedding_functions`
- [ ] Max 10M+ vectors, runs embedded, zero dependencies

### 11.3 Pinecone

- [ ] Serverless indexes: `spec=ServerlessSpec`, cloud region
- [ ] Pod-based indexes: `PodSpec`, pods, replicas, pods per shard
- [ ] Namespaces: `namespace` parameter, isolate data
- [ ] Metadata filtering: `$eq`, `$ne`, `$gt`, `$lt`, `$in`, `$and`, `$or`
- [ ] Query: `index.query()`, top_k, filter, include_metadata, include_values
- [ ] Update: `index.update()`, upsert with same ID
- [ ] Delete: `index.delete()`, by ID or filter
- [ ] Sparse-dense vectors: `index.upsert(vectors=[{"id": "...", "values": [...], "sparse_values": {...}}])`
- [ ] gRPC index: `Pinecone(protocol="grpc")` for higher throughput
- [ ] Pricing: $0.10/GB/hr (pod), $0.0008/GB/hr (serverless storage), $0.70/M query (serverless)

### 11.4 Weaviate

- [ ] Weaviate modules: `text2vec-openai`, `text2vec-cohere`, `text2vec-transformers`
- [ ] Classes: `client.collections.create()`, `class_name`, `vectorizer`
- [ ] Hybrid search: `hybrid()` combines BM25 + vector search
- [ ] `nearText()`: natural language queries with vectorizer
- [ ] `nearVector()`: raw vector queries
- [ ] `bm25()`: keyword search
- [ ] Metadata filtering: `where` filter, `and`, `or`, `not`
- [ ] Cross-references: link objects across classes
- [ ] Multi-tenancy: `multiTenancyConfig`

### 11.5 Milvus

- [ ] Collections: `collection_name`, `dim`, `metric_type`, `primary_field`
- [ ] Sharding: `shards_num`, distributed across nodes
- [ ] Indexing: IVF_FLAT, HNSW, DISKANN, GPU_IVF_FLAT
- [ ] Attu: GUI for Milvus management
- [ ] Search: `collection.search()`, `search_params`, `limit`, `expr`
- [ ] Consistency levels: Strong, Bounded, Eventually, Session
- [ ] Milvus Lite: embedded `milvus-lite`, runs in process
- [ ] Pymilvus: `from pymilvus import connections, Collection, FieldSchema`

### 11.6 Qdrant

- [ ] Collections: `client.create_collection()`, vectors_config
- [ ] Payload: attached key-value metadata per point
- [ ] Filtering: `should`, `must`, `must_not` conditions
- [ ] Quantization: scalar, product quantization for memory reduction
- [ ] Search: `client.search()`, with payload filter
- [ ] Points API: `upsert`, `delete`, `scroll`, `count`
- [ ] `qdrant-client` QdrantClient
- [ ] Geo location: `geo_radius`, `geo_bounding_box`

### 11.7 Comparison Table

| Feature | FAISS | Chroma | Pinecone | Weaviate | Milvus | Qdrant |
|---------|-------|--------|----------|----------|--------|--------|
| Type | Library | Embedded DB | Managed DB | Managed/Self | DB | DB |
| Open Source | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| Self-Host | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| Managed Cloud | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ |
| GPU Accel | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Metadata Filter | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Hybrid Search | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| Max Scale | 1B+ | 10M+ | Auto | Custom | 100B+ | 100M+ |
| Ease of Use | Medium | Easy | Easy | Medium | Medium | Easy |
| Language | Python+C++ | Python | Python | Python+Go | Python+Go | Python+Rust |

---

## 12. Retrieval-Augmented Generation (RAG)

### 12.1 Chunking Strategies

- [ ] **Fixed-size**: character or token count, overlap
- [ ] **Semantic**: segment at sentence boundaries (sentencize, spaCy, NLTK)
- [ ] **Recursive**: hierarchical splitting by separator (LangChain `RecursiveCharacterTextSplitter`)
- [ ] **Document-based**: per-paragraph, per-section, by headers (MarkdownHeaderTextSplitter)
- [ ] **Agentic**: use LLM to determine chunk boundaries
- [ ] **Contextual retrieval** (Anthropic): prepend chunk context to each chunk
- [ ] Chunk size guidelines:
  | Strategy | Tokens | Use Case |
  |----------|--------|----------|
  | Tiny | 128-256 | Q&A, fact lookup |
  | Medium | 512-1024 | General RAG |
  | Large | 2048-4096 | Summarization, analysis |
  | Full doc | Variable | Long context models |

### 12.2 Retrieval Methods

- [ ] **Dense retrieval**: embedding-based, semantic similarity
- [ ] **Sparse retrieval**: BM25, TF-IDF, Elasticsearch
- [ ] **Hybrid search**: combine dense + sparse (see below)
- [ ] **Late interaction**: ColBERT v2, ColPaLi
- [ ] **Multi-vector**: ColBERT, late interaction scoring
- [ ] **Iterative retrieval**: fetch, then refine query based on results
- [ ] **Auto-retrieval**: LLM generates search queries
- [ ] **REPLUG**: retrieve-then-generate with LM feedback

### 12.3 Hybrid Search

- [ ] **Reciprocal Rank Fusion (RRF)**: `score = 1/(k + rank_1) + 1/(k + rank_2)`
- [ ] **Weighted sum**: `alpha * dense_score + (1 - alpha) * sparse_score`
- [ ] Elasticsearch: knn + `must` bool query
- [ ] Weaviate: `hybrid(query, alpha=0.75)`
- [ ] Pinecone: sparse-dense vectors in same index
- [ ] Qdrant: dense search + payload keyword filter

### 12.4 Re-Ranking

- [ ] **Cross-encoder**: `cross-encoder/ms-marco-MiniLM-L-6-v2`, scores query-doc pair
- [ ] `cross-encoder/ms-marco-electra-base` (faster)
- [ ] Cohere Rerank: `rerank-english-v3.0`, `rerank-multilingual-v3.0`
- [ ] BGE Reranker: `BAAI/bge-reranker-v2-m3`
- [ ] monoT5: sequence-to-sequence reranking
- [ ] `FlagEmbedding/FlagReranker` collection
- [ ] Pipeline: retrieve top-k (100-200), rerank top-n (5-10)

### 12.5 Evaluation (RAGAS)

- [ ] **Faithfulness**: claims in answer vs retrieved context
- [ ] **Answer relevancy**: how relevant answer is to question
- [ ] **Context precision**: signal-to-noise in context
- [ ] **Context recall**: context coverage of the answer
- [ ] `ragas` library: `from ragas import evaluate`
- [ ] RAGAS metrics: `faithfulness`, `answer_relevancy`, `context_precision`, `context_recall`
- [ ] RAGAS + LangSmith/LangFuse integration
- [ ] `deepeval` metrics: G-Eval, faithfulness, hallucination

### 12.6 Production RAG

- [ ] **Query transformation**:
  - Query rewriting: LLM rewrites user query
  - HyDE: generate hypothetical document, embed that
  - Query decomposition: break complex questions into sub-questions
  - Step-back prompting: generate broader query
- [ ] **Multi-index routing**: different indexes for different data types
  - `LLMRouterChain`, `EmbeddingRouterChain`
  - Logical router: rule-based, LLM-based
- [ ] **Caching**:
  - Query caching: `cachetools`, Redis (exact or semantic)
  - LLM response caching: `langchain.cache`
  - Embedding caching: `GPTCache`
- [ ] **Guardrails**:
  - Input guard: detect harmful/inappropriate queries
  - Output guard: verify LLM response before returning
  - NeMo Guardrails: `nemoguardrails`
  - Guardrails AI: `guardrails-ai/guardrails`
- [ ] **Context management**:
  - Context window optimization (token count)
  - Summary-based context (map-reduce)
  - Sliding window over conversation history
- [ ] **Streaming**: stream retrieved chunks + LLM response
- [ ] **Observability**: LangFuse, LangSmith, Weights & Biases

> 📘 **Resource:** [LangChain RAG Guide](https://python.langchain.com/docs/use_cases/question_answering/)

---

## 13. AI Agents

### 13.1 LangChain

- [ ] **Chains**: `LLMChain`, `SimpleSequentialChain`, `SequentialChain`, `RouterChain`
- [ ] **LCEL** (LangChain Expression Language): `chain = prompt | model | output_parser`
- [ ] **Tools**: `@tool` decorator, `Tool`, `StructuredTool`, `requests` tool
- [ ] **Agents**: `create_react_agent`, `create_openai_functions_agent`, `create_tool_calling_agent`
- [ ] **AgentExecutor**: `AgentExecutor(agent=agent, tools=tools)`
- [ ] **Memory**: `ConversationBufferMemory`, `ConversationSummaryBufferMemory`, `PostgresChatMessageHistory`
- [ ] **Callbacks**: `BaseCallbackHandler`, `StreamingStdOutCallbackHandler`
- [ ] **Document loaders**: `PyPDFLoader`, `TextLoader`, `WebBaseLoader`, `SeleniumURLLoader`
- [ ] **Output parsers**: `StrOutputParser`, `JsonOutputParser`, `PydanticOutputParser`
- [ ] **Retrievers**: `VectorStoreRetriever`, `MultiQueryRetriever`, `ContextualCompressionRetriever`

### 13.2 LangGraph

- [ ] **Graph**: `StateGraph`, `MessageGraph`
- [ ] **Nodes**: function nodes, `add_node()`
- [ ] **Edges**: `add_edge()`, `add_conditional_edges()`
- [ ] **Cycles**: loops in workflows, `add_conditional_edges()` for loops
- [ ] **Persistence**: `MemorySaver`, `SqliteSaver`, `PostgresSaver`
- [ ] **Checkpoints**: save/restore graph state
- [ ] **Human-in-the-loop**: `interrupt()`, wait for human approval
- [ ] **Time travel**: rewind graph to previous state
- [ ] **Branching**: fan-out/fan-in from nodes
- [ ] **Agents with tools**: LangGraph + REACT pattern

### 13.3 CrewAI

- [ ] **Agent**: role, goal, backstory, verbose, allow_delegation
- [ ] **Task**: description, expected_output, agent, tools, context
- [ ] **Crew**: agents, tasks, process (sequential, hierarchical)
- [ ] **Tools**: custom `@tool`, built-in tools (file read, search, web scraping)
- [ ] **Process flow**: sequential (chain) vs hierarchical (manager agent)
- [ ] **Task delegation**: `allow_delegation=True`, agents ask other agents
- [ ] **Output**: task results, crew result
- [ ] **CrewAI with LangChain**: use LangChain tools inside CrewAI

### 13.4 AutoGen

- [ ] **ConversableAgent**: base agent class
- [ ] **AssistantAgent**: LLM-powered agent
- [ ] **UserProxyAgent**: human proxy agent (gives tools)
- [ ] **GroupChat**: multi-agent conversation
- [ ] **GroupChatManager**: manages group chat flow
- [ ] **Tool registration**: `register_function()`
- [ ] **Code execution**: UserProxyAgent can execute code
- [ ] **Nested chats**: sub-conversations within agent
- [ ] **AutoGen Studio**: UI for building multi-agent systems

### 13.5 MCP (Model Context Protocol)

- [ ] **MCP Server**: `FastMCP` (Python SDK), exposes tools, resources, prompts
- [ ] **MCP Client**: `mcp` client, connects to servers
- [ ] **Resources**: `@mcp.resource("file:///{path}")`, expose data
- [ ] **Tools**: `@mcp.tool()`, LLM-callable functions
- [ ] **Prompts**: `@mcp.prompt()`, reusable prompt templates
- [ ] **Transports**: stdio, SSE (Server-Sent Events), WebSocket
- [ ] **MCP + LangChain**: `Tool.from_mcp()`, `load_mcp_tools()`
- [ ] **MCP + Claude Desktop**: `claude_desktop_config.json`
- [ ] **Official SDKs**: Python, TypeScript, Java, Kotlin

### 13.6 Multi-Agent Patterns

- [ ] **Supervisor agent**: one agent coordinates others, delegates tasks
- [ ] **Hierarchical**: supervisor -> manager -> worker agents
- [ ] **Swarm**: agents dynamically form groups, share tasks
- [ ] **Debate**: agents take opposing views, debate to consensus
- [ ] **Voting**: multiple agents vote on solutions
- [ ] **RAG agent orchestrator**: agents retrieve, filter, synthesize
- [ ] **Tool executor pattern**: orchestrator + specialized tool agents
- [ ] **Pipeline pattern**: sequential pass-through of agents

> 📘 **Resource:** [LangGraph Quick Start](https://langchain-ai.github.io/langgraph/) | [AutoGen Docs](https://microsoft.github.io/autogen/)

---

## 14. MLOps

### 14.1 Docker

- [ ] **Images**: `FROM`, `RUN`, `COPY`, `WORKDIR`, `CMD`, `ENTRYPOINT`
- [ ] **Dockerfile**: multi-stage builds, `.dockerignore`
- [ ] **Build**: `docker build -t <name> .`, `--platform`, `--no-cache`
- [ ] **Run**: `docker run`, `-p`, `-v`, `-e`, `--gpus`, `--rm`
- [ ] **Compose**: `docker-compose.yml`, `services`, `volumes`, `networks`
- [ ] **GPU Docker**: `--gpus all`, `nvidia/cuda` base images
- [ ] **Registry**: `docker push`, `Docker Hub`, `ghcr.io`, `ECR`
- [ ] **Best practices**: slim images, `requirements.txt`, non-root user

### 14.2 Kubernetes

- [ ] **Pods**: `kubectl run`, `pod.yaml`, `containers`, `resources`
- [ ] **Deployments**: `deployment.yaml`, `replicas`, `strategy`, `rollout`
- [ ] **Services**: `ClusterIP`, `NodePort`, `LoadBalancer`
- [ ] **ConfigMaps & Secrets**: `kubectl create configmap`, `envFrom`
- [ ] **Helm**: `helm install`, `charts`, `values.yaml`, `templates`
- [ ] **Ingress**: `Ingress`, `ingress-controller` (nginx, traefik)
- [ ] **Storage**: `PersistentVolume`, `PersistentVolumeClaim`, `StorageClass`
- [ ] **GPU scheduling**: `nvidia.com/gpu` resource, `gpu-operator`
- [ ] **Kubeflow**: ML workflows on K8s, pipelines, Katib
- [ ] **minikube/kind**: local K8s development

### 14.3 MLflow

- [ ] **Tracking**: `mlflow.set_experiment()`, `mlflow.start_run()`, `log_param`, `log_metric`, `log_artifact`
- [ ] **MLflow UI**: `mlflow ui`, compare runs
- [ ] **Models**: `mlflow.pyfunc`, `mlflow.pytorch`, `mlflow.sklearn`
- [ ] **Model Registry**: register, stage, transition (Staging, Production)
- [ ] **Projects**: `MLproject` file, entry points, conda envs
- [ ] **Serving**: `mlflow models serve`, MLflow deployment
- [ ] **Autologging**: `mlflow.autolog()`, captures params/metrics/models

### 14.4 DVC

- [ ] **Init**: `dvc init`
- [ ] **Track data**: `dvc add data/`, creates `.dvc` file
- [ ] **Remote**: `dvc remote add -d myremote gdrive://...`
- [ ] **Pull/push**: `dvc push`, `dvc pull`
- [ ] **Pipelines**: `dvc.yaml`, stages, dependencies, outputs
- [ ] `dvc repro`: reproduce pipeline
- [ ] `dvc metrics`: show, diff
- [ ] `dvc plots`: visualize metrics

### 14.5 FastAPI

- [ ] **Endpoints**: `@app.get()`, `@app.post()`, `@app.put()`, `@app.delete()`
- [ ] **Path/query params**: `/items/{item_id}`, `?skip=0&limit=10`
- [ ] **Pydantic models**: `BaseModel`, `Field`, `validator`, `model_config`
- [ ] **Async**: `async def`, `await` for I/O-bound endpoints
- [ ] **Dependency injection**: `Depends()`, reusable dependencies
- [ ] **Background tasks**: `BackgroundTasks`
- [ ] **OpenAPI/Swagger**: auto-generated `/docs`
- [ ] **CORS**: `CORSMiddleware`
- [ ] **Middleware**: custom middleware, logging, auth
- [ ] **Testing**: `TestClient`
- [ ] **File uploads**: `UploadFile`, `File`
- [ ] **Error handling**: `HTTPException`, custom exception handlers

### 14.6 BentoML

- [ ] **Bento**: `bentoml.Bento`, build: `bentoml build`
- [ ] **Runners**: `@bentoml.service`, custom runners
- [ ] **Model serving**: `bentoml.models.get()`, PyTorch/Keras/scikit-learn
- [ ] **Deployment**: `bentoml serve`, Docker, AWS Lambda, SageMaker
- [ ] **Adaptive batching**: `max_batch_size`, `max_latency_ms`
- [ ] **Distributed serving**: `--replicas`, multi-GPU

### 14.7 Ray

- [ ] **Core**: `@ray.remote`, `ray.get()`, `ray.put()`, `ray.wait()`
- [ ] **Data**: `ray.data.read_parquet()`, transforms, map, streaming
- [ ] **Train**: `ray.train`, `TorchTrainer`, scaling config
- [ ] **Tune**: `ray.tune`, hyperparameter search, `ASHA`, `PopulationBasedTraining`
- [ ] **Serve**: `ray.serve`, deployment graphs, A/B testing, autoscaling
- [ ] **RLlib**: reinforcement learning, algorithms (PPO, DQN, SAC)
- [ ] **Air**: `Ray AIR` (AI Runtime)

### 14.8 Monitoring

- [ ] **Prometheus**: time-series DB, metrics collection, `prometheus.yml`
- [ ] **Grafana**: dashboards, panels, alerts, PromQL queries
- [ ] **Evidently AI**: data drift, model drift, target drift dashboards
- [ ] **whylogs**: data logging, statistical profiles, WhyLabs platform
- [ ] **Alibi Detect**: drift detection, outlier detection
- [ ] **NannyML**: post-deployment monitoring, performance estimation
- [ ] **Arize AI**: observability platform, tracing, drift
- [ ] **Grafana Loki**: log aggregation

### 14.9 Model Serving

- [ ] **NVIDIA Triton**: `tritonserver`, model repository, ensemble, concurrent execution, perf_analyzer
- [ ] **TorchServe**: `torchserve`, model archiver, inference API, batch inference, metrics
- [ ] **TFServing**: `tensorflow_model_server`, model versions, batching
- [ ] **Ray Serve**: Python-native, fast deployment, autoscaling
- [ ] **BentoML**: for Python ML model serving
- [ ] **KServe**: Kubernetes-native model serving

> 📘 **Resource:** [Full Stack Deep Learning MLOps](https://fullstackdeeplearning.com/llm-bootcamp/)

---

## 15. End-to-End Projects

### Project 1: AI Chatbot (Conversational AI with Memory)

**Stack**: FastAPI + LangChain + OpenAI + ChromaDB
- Multi-turn conversation with history
- Session management (Redis)
- Streaming responses
- Content moderation guardrails
- Deploy: Docker + Railway/Render

### Project 2: RAG PDF Chat (Document QA)

**Stack**: LlamaIndex/LangChain + OpenAI embeddings + Pinecone + Streamlit
- Upload PDFs (PyMuPDF, PyPDF2)
- Chunk + embed + store
- Hybrid search (dense + reranking)
- Source citations in answers
- Deploy: Hugging Face Spaces

### Project 3: AI Coding Assistant

**Stack**: Ollama + Llama 3 + LangChain + Code Interpreter
- Repository ingestion
- Code retrieval + RAG
- Code generation + execution (sandboxed)
- Shell command execution
- Memory of project context

### Project 4: Medical Assistant (Healthcare RAG)

**Stack**: LlamaIndex + GPT-4 + Weaviate + FastAPI
- PubMed and medical literature ingestion
- HIPAA-aware guardrails
- Medication interaction checker
- Symptom -> possible conditions
- Disclaimer system

### Project 5: Research Assistant (Paper Analysis)

**Stack**: LangChain + ArXiv API + ChromaDB + Streamlit
- Paper search and ingestion
- Paper summarization (map-reduce)
- Q&A over papers
- Citation graph extraction
- PDF export of summaries

### Project 6: Customer Support Multi-Agent System

**Stack**: CrewAI + LangGraph + OpenAI + Qdrant
- Tier-1: FAQ resolution agent
- Tier-2: Technical support agent
- Tier-3: Human escalation
- Ticket management
- Sentiment analysis
- Handoff protocol

### Project 7: SQL Agent (Natural Language to SQL)

**Stack**: LangChain + GPT-4 + SQLAlchemy + PostgreSQL
- Database schema introspection
- Query generation with validation
- Query execution + result formatting
- Few-shot examples from schema
- SQL injection prevention
- Visual query results

### Project 8: Multi-Agent Workflow

**Stack**: AutoGen + LangGraph + MCP + FastAPI
- Research agent: gathers data
- Analysis agent: processes data
- Writer agent: produces report
- Editor agent: reviews + polishes
- Supervisor agent: coordinates
- Web UI: Chainlit or Gradio

### Project 9: Voice AI Assistant

**Stack**: Whisper (STT) + GPT-4o + ElevenLabs/XTTS (TTS) + WebSockets
- Real-time speech-to-text (Whisper + faster-whisper)
- LLM response generation
- Text-to-speech (ElevenLabs, XTTS, or MeloTTS)
- WebSocket server (FastAPI)
- Conversation memory
- Wake word detection (Porcupine, OpenAI Whisper)

### Project 10: Document Intelligence System

**Stack**: Unstructured.io + YOLO (OCR) + GPT-4o + Milvus
- Document classification (Invoices, Contracts, Reports)
- Document extraction: LayoutLM, Nougat, Tesseract
- Table extraction: Camelot, Tabula
- Entity extraction + summarization
- Full-text search + vector search
- Export to structured formats (JSON, CSV, Excel)

> 💡 **Tip:** For each project: (1) build a minimal version, (2) add features iteratively, (3) deploy, (4) write a blog post, (5) add to portfolio.

---

## 16. Curated Documentation

| Library | Documentation |
|---------|---------------|
| Python | [docs.python.org/3](https://docs.python.org/3/) |
| NumPy | [numpy.org/doc/stable](https://numpy.org/doc/stable/) |
| Pandas | [pandas.pydata.org/docs](https://pandas.pydata.org/docs/) |
| Matplotlib | [matplotlib.org/stable](https://matplotlib.org/stable/) |
| Scikit-Learn | [scikit-learn.org/stable](https://scikit-learn.org/stable/) |
| PyTorch | [pytorch.org/docs/stable](https://pytorch.org/docs/stable/) |
| TensorFlow | [tensorflow.org/api_docs](https://www.tensorflow.org/api_docs) |
| Hugging Face | [huggingface.co/docs](https://huggingface.co/docs) |
| Transformers | [huggingface.co/docs/transformers](https://huggingface.co/docs/transformers) |
| Diffusers | [huggingface.co/docs/diffusers](https://huggingface.co/docs/diffusers) |
| PEFT | [huggingface.co/docs/peft](https://huggingface.co/docs/peft) |
| TRL | [huggingface.co/docs/trl](https://huggingface.co/docs/trl) |
| LangChain | [python.langchain.com/docs](https://python.langchain.com/docs) |
| LangGraph | [langchain-ai.github.io/langgraph](https://langchain-ai.github.io/langgraph/) |
| CrewAI | [docs.crewai.com](https://docs.crewai.com/) |
| AutoGen | [microsoft.github.io/autogen](https://microsoft.github.io/autogen/) |
| FastAPI | [fastapi.tiangolo.com](https://fastapi.tiangolo.com/) |
| MLflow | [mlflow.org/docs/latest](https://mlflow.org/docs/latest/) |
| DVC | [dvc.org/doc](https://dvc.org/doc) |
| Ray | [docs.ray.io/en/latest](https://docs.ray.io/en/latest/) |
| BentoML | [docs.bentoml.com](https://docs.bentoml.com/) |
| FAISS | [github.com/facebookresearch/faiss](https://github.com/facebookresearch/faiss) |
| Chroma | [docs.trychroma.com](https://docs.trychroma.com/) |
| Pinecone | [docs.pinecone.io](https://docs.pinecone.io/) |
| Weaviate | [weaviate.io/developers/weaviate](https://weaviate.io/developers/weaviate) |
| Milvus | [milvus.io/docs](https://milvus.io/docs) |
| Qdrant | [qdrant.tech/documentation](https://qdrant.tech/documentation/) |
| Docker | [docs.docker.com](https://docs.docker.com/) |
| Kubernetes | [kubernetes.io/docs](https://kubernetes.io/docs/) |
| MCP | [modelcontextprotocol.io](https://modelcontextprotocol.io/) |
| RAGAS | [docs.ragas.io](https://docs.ragas.io/) |
| NeMo Guardrails | [github.com/NVIDIA/NeMo-Guardrails](https://github.com/NVIDIA/NeMo-Guardrails) |

---

## 17. Free Courses

| Course | Provider | Topics |
|--------|----------|--------|
| [CS50's Introduction to AI](https://cs50.harvard.edu/ai/) | Harvard | Search, ML, NN, NLP |
| [Machine Learning Specialization](https://www.coursera.org/specializations/machine-learning-introduction) | DeepLearning.AI | Supervised/Unsupervised, Recommenders |
| [Deep Learning Specialization](https://www.coursera.org/specializations/deep-learning) | DeepLearning.AI | DNN, CNN, RNN, Transformers |
| [Practical Deep Learning for Coders](https://course.fast.ai/) | fast.ai | Top-down deep learning |
| [Full Stack Deep Learning](https://fullstackdeeplearning.com/) | UC Berkeley | MLOps, deployment |
| [Hugging Face NLP Course](https://huggingface.co/learn/nlp-course) | Hugging Face | Transformers, fine-tuning |
| [Hugging Face Diffusion Course](https://huggingface.co/learn/diffusion-course) | Hugging Face | Diffusion models |
| [Stanford CS224N: NLP with Deep Learning](https://web.stanford.edu/class/cs224n/) | Stanford | Transformers, LLMs |
| [Stanford CS231N: CNNs](https://cs231n.stanford.edu/) | Stanford | Computer vision |
| [MIT 6.S191: Intro to Deep Learning](https://deeplearning.mit.edu/) | MIT | DL fundamentals |
| [Google Machine Learning Crash Course](https://developers.google.com/machine-learning/crash-course) | Google | ML fundamentals, TF |
| [Reinforcement Learning Specialization](https://www.coursera.org/specializations/reinforcement-learning) | UAlberta | RL, MDP, DQN |
| [Mathematics for Machine Learning](https://www.coursera.org/specializations/mathematics-machine-learning) | Imperial | Linear algebra, calculus, stats |
| [CS50's Python](https://cs50.harvard.edu/python/) | Harvard | Python programming |
| [Data Structures & Algorithms](https://www.coursera.org/specializations/data-structures-algorithms) | UCSD | DSA fundamentals |

---

## 18. Books

| Title | Author(s) | Focus |
|-------|-----------|-------|
| *Python Machine Learning* | Sebastian Raschka & Vahid Mirjalili | ML + PyTorch/TF |
| *Deep Learning* (Goodfellow) | Ian Goodfellow, Yoshua Bengio, Aaron Courville | DL theory |
| *Hands-On Machine Learning* | Aurélien Géron | Scikit-Learn, Keras, TF |
| *The Hundred-Page ML Book* | Andriy Burkov | ML fundamentals |
| *Designing Machine Learning Systems* | Chip Huyen | MLOps, production |
| *Building Machine Learning Pipelines* | Hannes Hapke & Catherine Nelson | TFX, KubeFlow |
| *Natural Language Processing with Transformers* | Lewis Tunstall, Leandro von Werra, Thomas Wolf | Hugging Face |
| *Deep Learning with Python* | François Chollet | Keras, DL |
| *Speech and Language Processing* | Dan Jurafsky & James H. Martin | NLP |
| *Introduction to Algorithms* (CLRS) | Cormen, Leiserson, Rivest, Stein | DSA |
| *Cracking the Coding Interview* | Gayle Laakmann McDowell | Interview prep |
| *System Design Interview* | Alex Xu | System design |
| *Deep Reinforcement Learning Hands-On* | Maxim Lapan | RL |
| *Generative Deep Learning* | David Foster | VAEs, GANs, diffusion |

---

## 19. Best YouTube Channels

> 📺 Watch alongside each roadmap section. Channels are tagged with which section(s) they support.

| Channel | URL | Focus | Best For Section |
|---------|-----|-------|-----------------|
| Andrej Karpathy | [youtube.com/@AndrejKarpathy](https://youtube.com/@AndrejKarpathy) | Neural networks, LLMs | 6, 8 |
| 3Blue1Brown | [youtube.com/@3blue1brown](https://youtube.com/@3blue1brown) | Math intuition | 3, 5 |
| StatQuest | [youtube.com/@statquest](https://youtube.com/@statquest) | Statistics & ML | 4, 5 |
| sentdex | [youtube.com/@sentdex](https://youtube.com/@sentdex) | Python, ML, finance | 2, 4, 5 |
| DeepLearning.AI | [youtube.com/@Deeplearningai](https://youtube.com/@Deeplearningai) | AI courses & news | 5, 6, 7, 8 |
| Stanford Online | [youtube.com/@stanfordonline](https://youtube.com/@stanfordonline) | Stanford lectures | 5, 6, 8 |
| MIT OpenCourseWare | [youtube.com/@mitocw](https://youtube.com/@mitocw) | MIT lectures | 5, 6, 14 |
| Yannic Kilcher | [youtube.com/@YannicKilcher](https://youtube.com/@YannicKilcher) | ML paper reviews | 5, 6, 7, 8 |
| Patrick Loeber | [youtube.com/@patloeber](https://youtube.com/@patloeber) | Python, ML, PyTorch | 2, 6 |
| Nicholas Renotte | [youtube.com/@nicholasrenotte](https://youtube.com/@nicholasrenotte) | AI projects | 7, 15 |
| Sam Witteveen | [youtube.com/@samwitteveenai](https://youtube.com/@samwitteveenai) | LangChain, RAG, agents | 8, 12, 13 |
| TechWithTim | [youtube.com/@TechWithTim](https://youtube.com/@TechWithTim) | Python, AI projects | 2, 7, 15 |
| James Briggs | [youtube.com/@jamesbriggs](https://youtube.com/@jamesbriggs) | RAG, vector databases | 10, 11, 12 |
| AssemblyAI | [youtube.com/@AssemblyAI](https://youtube.com/@AssemblyAI) | ML, NLP, speech | 5, 8 |
| The AI Engineer | [youtube.com/@TheAIEngineer](https://youtube.com/@TheAIEngineer) | LLMs, agents, tools | 8, 13 |
| NeetCode | [youtube.com/@NeetCodeIO](https://youtube.com/@NeetCodeIO) | DSA, interview prep | 3, 24 |
| FreeCodeCamp | [youtube.com/@freecodecamp](https://youtube.com/@freecodecamp) | Full courses | All sections |
| AI Jason | [youtube.com/@AIJason](https://youtube.com/@AIJason) | AI agents, LangChain | 12, 13 |
| Wes Roth | [youtube.com/@WesRoth](https://youtube.com/@WesRoth) | AI news & deep dives | 7, 8 |
| Elliot Arledge | [youtube.com/@elliotarledge](https://youtube.com/@elliotarledge) | ML tutorials | 2, 5, 6 |
| **Two Minute Papers** | [youtube.com/@TwoMinutePapers](https://youtube.com/@TwoMinutePapers) | AI research simplified | 6, 7, 8 |
| **AI Explained** | [youtube.com/@aiexplained-official](https://youtube.com/@aiexplained-official) | LLM news, deep dives | 7, 8, 13 |
| **CodeEmporium** | [youtube.com/@CodeEmporium](https://youtube.com/@CodeEmporium) | ML architecture, transformers | 5, 6, 8 |
| **DataTalksClub** | [youtube.com/@DataTalksClub](https://youtube.com/@DataTalksClub) | MLOps, data engineering | 14 |
| **NeuralNine** | [youtube.com/@NeuralNine](https://youtube.com/@NeuralNine) | Python, ML algorithms | 2, 5 |
| **DeepFindr** | [youtube.com/@deepfindr](https://youtube.com/@deepfindr) | RAG, vector DBs, agents | 10, 11, 12, 13 |
| **AI Makerspace** | [youtube.com/@AI-Makerspace](https://youtube.com/@AI-Makerspace) | LLM engineering, fine-tuning | 7, 8 |
| **Hugging Face** | [youtube.com/@HuggingFace](https://youtube.com/@HuggingFace) | HF ecosystem, transformers | 8, 10, 13 |
| **LangChain** | [youtube.com/@LangChain](https://youtube.com/@LangChain) | Official LangChain tutorials | 12, 13 |
| **Pinecone** | [youtube.com/@Pinecone](https://youtube.com/@Pinecone) | Vector databases, embeddings | 10, 11 |

---

## 20. Best Playlists

> 🎯 Each playlist is mapped to the roadmap section(s) it covers. Watch the playlist alongside that section.

| Playlist | Creator | Videos | Covers Section(s) |
|----------|---------|--------|-------------------|
| [Deep Learning Lectures (CS230)](https://www.youtube.com/playlist?list=PLoROMvodv4rOABXSygHT1M9Iajzn1LbBZ) | Stanford | 30+ | 6 |
| [Neural Networks (3Blue1Brown)](https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi) | 3Blue1Brown | 5 | 5, 6 |
| [Machine Learning (StatQuest)](https://www.youtube.com/playlist?list=PLblh5JKOoLUIxGDQs4LFFD--41Vzf-ME1) | StatQuest | 150+ | 5 |
| [Reinforcement Learning (David Silver)](https://www.youtube.com/playlist?list=PLqYmG7hTraZBiGX2eD8gMEtNxR0q7l7_H) | DeepMind | 10 | 5 |
| [Natural Language Processing (CS224n)](https://www.youtube.com/playlist?list=PLoROMvodv4rMFqRtEee6uAMTdzWnY1LAU) | Stanford | 20+ | 8 |
| [Deep Learning (CS231n)](https://www.youtube.com/playlist?list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv) | Stanford | 16 | 6 |
| [Practical Deep Learning for Coders](https://www.youtube.com/playlist?list=PLfYUBJiXbdtRUvTUYpL1kY3v4GdE6Q3cJ) | fast.ai | 10 | 6 |
| [Hugging Face Course](https://www.youtube.com/playlist?list=PLo2EIpI_JMQtNqnGepQo0Uo0fCqKLM-YI) | Hugging Face | 15+ | 8, 10 |
| [Advanced Deep Learning (UvA)](https://www.youtube.com/playlist?list=PLIXJk2Tjhd2gl7dIj1ptQsF7H1dC5E7RY) | UvA | 15 | 6 |
| [LangChain & LangGraph](https://www.youtube.com/playlist?list=PLq31zO2fT-qGx0Ei8XDS3aUGV5a9x4R1T) | Sam Witteveen | 60+ | 12, 13 |
| [MLOps Course](https://www.youtube.com/playlist?list=PL3MmuxUbc_hIUISdmrCH3QHX8J3vOX7Kz) | DataTalksClub | 20+ | 14 |
| [AI Agents Course](https://www.youtube.com/playlist?list=PLlrxD0HtieHgz5Vc0Mh3Oge3FmkCjS5_v) | Hugging Face | 10+ | 13 |
| [LLM Engineering Course](https://www.youtube.com/playlist?list=PL2c0dSG3_41XqIWqhQSqoaxnAHlq9wFAh) | AI Makerspace | 20+ | 8 |
| [MIT 6.S191](https://www.youtube.com/playlist?list=PLtBw6njQRU-rwp5__7C0oIVt26ZgjG9NI) | MIT | 10+ | 6 |
| [Python for Everybody](https://www.youtube.com/playlist?list=PLlRFEj9H3Oj7Bp8-DfGpfAfDBiblRfl5p) | freeCodeCamp | 40+ | 2 |
| [Data Analysis with Python](https://www.youtube.com/playlist?list=PLoE6oM5B9VNgkO_i1Hf2IUf-2YflhFcDM) | freeCodeCamp | 15+ | 4 |
| [ML with Scikit-Learn](https://www.youtube.com/playlist?list=PLQVvvaa0QuDfKTOs3Keq_kaG2P55YRn5v) | sentdex | 40+ | 5 |
| [Deep Learning with PyTorch](https://www.youtube.com/playlist?list=PLhhyoLH6IjfxeoooqP9rhU3HJIAVAJ3Vz) | freeCodeCamp | 20+ | 6 |
| [RAG from Scratch](https://www.youtube.com/playlist?list=PLfaIDFEXuae2LXbO1_P4J1E2jItU2fRjE) | LangChain | 15+ | 12 |
| [Vector Databases](https://www.youtube.com/playlist?list=PLIE1kZ6PQ7Eo5LCEbYkx7IWKcz0H7RrV0) | Pinecone | 10+ | 10, 11 |
| [Generative AI for Beginners](https://www.youtube.com/playlist?list=PLlrxD0HtieHj0pXUPmHhv3TgBGhAOBWPo) | Microsoft | 20+ | 7 |
| [LLM Fine-Tuning](https://www.youtube.com/playlist?list=PL2c0dSG3_41UodRdbQB-nRfFoDoAErSMJ) | AI Makerspace | 15+ | 8 |
| [DSA with Python](https://www.youtube.com/playlist?list=PLKYEe2WisBTFEr6laH5bR2J19j7sl5O8R) | NeetCode | 30+ | 3 |

---

## 21. GitHub Repositories

| Repository | Stars | Description |
|------------|-------|-------------|
| [TheAlgorithms/Python](https://github.com/TheAlgorithms/Python) | 190k+ | All algorithms in Python |
| [hu-po/awesome-machine-learning](https://github.com/hu-po/awesome-machine-learning) | 66k+ | Curated ML resources |
| [practical-tutorials/project-based-learning](https://github.com/practical-tutorials/project-based-learning) | 200k+ | Tutorials for project-based learning |
| [microsoft/generative-ai-for-beginners](https://github.com/microsoft/generative-ai-for-beginners) | 70k+ | Generative AI course |
| [mlabonne/llm-course](https://github.com/mlabonne/llm-course) | 45k+ | LLM course with notebooks |
| [bbycroft/llm-viz](https://github.com/bbycroft/llm-viz) | 4k+ | LLM visualizations |
| [ray-project/ray](https://github.com/ray-project/ray) | 35k+ | Distributed computing |
| [langgenius/dify](https://github.com/langgenius/dify) | 60k+ | LLM app dev platform |
| [chatchat-space/Langchain-Chatchat](https://github.com/chatchat-space/Langchain-Chatchat) | 32k+ | Knowledge base QA |
| [run-llama/llama_index](https://github.com/run-llama/llama_index) | 38k+ | Data framework for LLMs |
| [langchain-ai/langchain](https://github.com/langchain-ai/langchain) | 100k+ | LLM application framework |
| [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph) | 10k+ | Agent orchestration |
| [joaomdmoura/crewAI](https://github.com/joaomdmoura/crewAI) | 25k+ | Multi-agent framework |
| [microsoft/autogen](https://github.com/microsoft/autogen) | 35k+ | Multi-agent conversations |
| [huggingface/diffusers](https://github.com/huggingface/diffusers) | 26k+ | Diffusion models |
| [huggingface/peft](https://github.com/huggingface/peft) | 17k+ | PEFT methods |
| [huggingface/transformers](https://github.com/huggingface/transformers) | 140k+ | State-of-the-art models |
| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | 75k+ | LLM inference in C/C++ |
| [vllm-project/vllm](https://github.com/vllm-project/vllm) | 45k+ | High-throughput LLM serving |
| [nvbn/thefuck](https://github.com/nvbn/thefuck) | 87k+ | Magnificent app which corrects console commands |
| [XingangPan/DragGAN](https://github.com/XingangPan/DragGAN) | 36k+ | Drag-based image editing |
| [deepinsight/insightface](https://github.com/deepinsight/insightface) | 23k+ | Face recognition |
| [openai/whisper](https://github.com/openai/whisper) | 75k+ | Speech recognition |
| [comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI) | 65k+ | Diffusion model UI |
| [nicedouble/StreamDiffusion](https://github.com/nicedouble/StreamDiffusion) | 10k+ | Real-time diffusion |
| [THUDM/CogVideo](https://github.com/THUDM/CogVideo) | 10k+ | Video generation |
| [NVIDIA/TensorRT-LLM](https://github.com/NVIDIA/TensorRT-LLM) | 10k+ | LLM optimization |
| [stanford-alpaca/stanford_alpaca](https://github.com/tatsu-lab/stanford_alpaca) | 30k+ | Instruction tuning |
| [tloen/alpaca-lora](https://github.com/tloen/alpaca-lora) | 19k+ | LoRA fine-tuning |
| [facebookresearch/faiss](https://github.com/facebookresearch/faiss) | 32k+ | Vector similarity search |
| [FlagOpen/FlagEmbedding](https://github.com/FlagOpen/FlagEmbedding) | 8k+ | Embedding models |
| [cpacker/MemGPT](https://github.com/cpacker/MemGPT) | 15k+ | Memory for LLMs |
| [BerriAI/litellm](https://github.com/BerriAI/litellm) | 15k+ | Unified LLM API |
| [gventuri/pandas-ai](https://github.com/gventuri/pandas-ai) | 13k+ | Data analysis with LLM |
| [ShishirPatil/gorilla](https://github.com/ShishirPatil/gorilla) | 11k+ | API function calling |
| [openai/evals](https://github.com/openai/evals) | 15k+ | LLM evaluation |
| [comet-ml/opik](https://github.com/comet-ml/opik) | 5k+ | LLM evaluation framework |
| [langfuse/langfuse](https://github.com/langfuse/langfuse) | 8k+ | LLM observability |
| [wandb/wandb](https://github.com/wandb/wandb) | 9k+ | ML experiment tracking |

---

## 22. Weekly Milestones

> A structured 9-month schedule at ~15-20 hours per week.

### Month 1: Foundations (Weeks 1-4)

| Week | Focus | Topics |
|------|-------|--------|
| 1 | Python Intensive | Data types, control flow, functions, comprehensions, file I/O |
| 2 | Python OOP | Classes, inheritance, magic methods, decorators, dataclasses |
| 3 | Python Advanced | Async, generators, itertools, functools, context managers |
| 4 | DSA Basics | Arrays, strings, hash maps, two pointers, sliding window |

**Project**: Python utility library (custom collections, async web scraper)

### Month 2: DSA & Data Analysis (Weeks 5-8)

| Week | Focus | Topics |
|------|-------|--------|
| 5 | Trees & Graphs | BST, BFS, DFS, tries, heap |
| 6 | Dynamic Programming | Memoization, tabulation, knapsack, LCS, LIS |
| 7 | NumPy & Pandas | Arrays, broadcasting, DataFrames, groupby, merge |
| 8 | Visualization | Matplotlib, Seaborn, Polars |

**Project**: EDA + visualization on a real dataset (Kaggle)

### Month 3: Machine Learning (Weeks 9-12)

| Week | Focus | Topics |
|------|-------|--------|
| 9 | Regression | Linear, polynomial, ridge, lasso, metrics |
| 10 | Classification | Logistic regression, SVM, decision trees, random forest |
| 11 | Ensemble & Boosting | XGBoost, LightGBM, CatBoost, feature engineering |
| 12 | Evaluation & Pipelines | Cross-val, metrics, pipelines, ColumnTransformer |

**Project**: End-to-end ML pipeline (House price prediction / Titanic)

### Month 4: Deep Learning (Weeks 13-16)

| Week | Focus | Topics |
|------|-------|--------|
| 13 | PyTorch | Tensors, autograd, nn.Module, training loop |
| 14 | CNNs | Convolution, pooling, batch norm, ResNet, EfficientNet |
| 15 | RNNs/LSTMs | Sequences, LSTMs, GRU, bidirectional |
| 16 | Transformers | Self-attention, multi-head, positional encoding |

**Project**: Image classifier (CIFAR-10 / Cats vs Dogs)

### Month 5: Generative AI & LLMs (Weeks 17-20)

| Week | Focus | Topics |
|------|-------|--------|
| 17 | Foundation Models & HF | Transformers library, pipelines, AutoModel |
| 18 | Tokenization & Attention | BPE, WordPiece, Flash Attention, KV Cache |
| 19 | Fine-tuning | LoRA, QLoRA, PEFT, SFT, chat templates |
| 20 | Prompt Engineering | Zero-shot, few-shot, CoT, function calling |

**Project**: Fine-tune a small LLM (Llama 3 / Mistral) with LoRA for a specific task

### Month 6: RAG & Vector Databases (Weeks 21-24)

| Week | Focus | Topics |
|------|-------|--------|
| 21 | Embeddings | Sentence Transformers, OpenAI embeddings, MTEB |
| 22 | Vector Databases | FAISS, Chroma, Pinecone (one deep dive) |
| 23 | RAG Fundamentals | Chunking, retrieval, hybrid search, reranking |
| 24 | RAG Advanced | Query transformation, evaluation, production RAG |

**Project**: RAG PDF Chat bot with Streamlit UI

### Month 7: AI Agents (Weeks 25-28)

| Week | Focus | Topics |
|------|-------|--------|
| 25 | LangChain | LCEL, chains, tools, agents, memory |
| 26 | LangGraph | StateGraph, cycles, persistence, human-in-loop |
| 27 | CrewAI & AutoGen | Multi-agent patterns, group chat, delegation |
| 28 | MCP & Agent Systems | MCP protocol, multi-agent architectures |

**Project**: Multi-agent research assistant (CrewAI/LangGraph)

### Month 8: MLOps (Weeks 29-32)

| Week | Focus | Topics |
|------|-------|--------|
| 29 | Docker | Images, Dockerfile, compose, deployment |
| 30 | MLflow & DVC | Experiment tracking, model registry, data versioning |
| 31 | FastAPI & Serving | API development, model serving (Triton/TorchServe) |
| 32 | Monitoring & K8s | Prometheus, Grafana, Kubernetes basics |

**Project**: Deploy ML model with FastAPI + Docker + MLflow

### Month 9: Projects & Polish (Weeks 33-36)

| Week | Focus | Topics |
|------|-------|--------|
| 33 | E2E Project 1 | RAG PDF Chat + Docker deployment |
| 34 | E2E Project 2 | Multi-agent system with LangGraph + FastAPI |
| 35 | E2E Project 3 | Voice AI assistant (STT + LLM + TTS) |
| 36 | Portfolio & Interview | Resume, portfolio, interview prep |

### Bonus: Month 10-12 (Specialization)

| Month | Focus | Topics |
|-------|-------|--------|
| 10 | Advanced RAG | Agentic RAG, long context, caching, routing |
| 11 | Production Systems | Kubernetes, Helm, Ray, GPU inference optimization |
| 12 | Applied Research | Read papers, implement from scratch, write blog |

---

## 23. Progress Tracker

### Python
- [ ] Python Basics (data types, control flow, functions)
- [ ] OOP (classes, inheritance, magic methods, decorators, metaclasses)
- [ ] Functional (map/filter/reduce, itertools, generators)
- [ ] Async Python (async/await, asyncio, aiohttp)

### Data Structures & Algorithms
- [ ] Arrays & Strings (two pointers, sliding window, prefix sum)
- [ ] Trees & Heaps (BST, AVL, tries, segment/ Fenwick tree)
- [ ] Graphs (BFS, DFS, Dijkstra, topological sort, Union-Find)
- [ ] Dynamic Programming (knapsack, LCS, LIS, DP patterns)
- [ ] LeetCode (Blind 75, NeetCode 150, company-specific)

### Data Analysis
- [ ] NumPy (arrays, broadcasting, vectorization, linear algebra)
- [ ] Pandas (DataFrame, groupby, merge, pivot, time series)
- [ ] Matplotlib (line, scatter, bar, histogram, subplots)
- [ ] Seaborn (heatmaps, pairplots, categorical plots)
- [ ] Polars (lazy/eager, expressions, performance)

### Machine Learning
- [ ] Scikit-Learn (pipelines, ColumnTransformer, custom transformers)
- [ ] Regression (linear, polynomial, ridge, lasso, ElasticNet)
- [ ] Classification (logistic regression, SVM, RF, XGBoost, LightGBM)
- [ ] Clustering (K-means, DBSCAN, hierarchical)
- [ ] Feature Engineering (encoding, scaling, selection, PCA)
- [ ] Model Evaluation (cross-validation, metrics, ROC, SHAP)

### Deep Learning
- [ ] PyTorch (tensors, autograd, nn.Module, DataLoader, optimizers)
- [ ] TensorFlow/Keras (Sequential, Functional, tf.data, SavedModel)
- [ ] CNNs (convolution, pooling, batch norm, ResNet, EfficientNet)
- [ ] RNNs/LSTMs (GRU, bidirectional, sequence modeling)
- [ ] Transformers (self-attention, multi-head, positional encoding)

### Generative AI
- [ ] Foundation Models (GPT, Claude, Gemini, Llama, Mistral)
- [ ] Diffusion Models (DDPM, Stable Diffusion, ControlNet)
- [ ] Hugging Face Ecosystem (transformers, diffusers, datasets, accelerate)

### Large Language Models
- [ ] Tokenization (BPE, WordPiece, SentencePiece, tiktoken)
- [ ] Attention (flash attention, KV cache, GQA)
- [ ] Fine-tuning (full, instruction, RLHF, DPO)
- [ ] LoRA (rank selection, target modules, merging)
- [ ] QLoRA (NF4, double quantization, BitsAndBytes)
- [ ] PEFT (prefix tuning, prompt tuning, IA3, adapters)

### Prompt Engineering
- [ ] Zero-shot, Few-shot, Chain-of-Thought
- [ ] Structured Outputs (JSON mode, function calling)
- [ ] System prompts, prompt templates

### Embeddings
- [ ] Sentence Transformers (all-MiniLM-L6-v2, all-mpnet-base-v2)
- [ ] OpenAI Embeddings (text-embedding-3-small/large)
- [ ] BGE & E5 models
- [ ] MTEB leaderboard and evaluation

### Vector Databases
- [ ] FAISS (IVF, HNSW, GPU, PQ)
- [ ] Chroma (in-memory, persistent, collections)
- [ ] Pinecone (serverless, namespaces, metadata filtering)
- [ ] Weaviate, Milvus, Qdrant (at least one)

### RAG
- [ ] Chunking (fixed, semantic, recursive, agentic)
- [ ] Retrieval (dense, sparse, hybrid)
- [ ] Re-ranking (cross-encoder, BGE, Cohere)
- [ ] Evaluation (RAGAS, faithfulness, answer relevancy)
- [ ] Production RAG (query transformation, routing, caching, guardrails)

### AI Agents
- [ ] LangChain (LCEL, tools, agents, memory)
- [ ] LangGraph (graphs, cycles, persistence, human-in-loop)
- [ ] CrewAI (roles, tasks, processes, tools)
- [ ] AutoGen (agent chat, group chat, code execution)
- [ ] MCP (servers, clients, tools, resources)
- [ ] Multi-agent patterns (supervisor, hierarchy, swarm)

### MLOps
- [ ] Docker (images, Dockerfile, compose, multi-stage)
- [ ] Kubernetes (pods, deployments, services, Helm)
- [ ] MLflow (tracking, models, registry)
- [ ] DVC (data versioning, pipelines)
- [ ] FastAPI (endpoints, Pydantic, async, OpenAPI)
- [ ] BentoML (model serving, runners)
- [ ] Ray (distributed computing, Serve, Tune)
- [ ] Monitoring (Prometheus, Grafana, Evidently AI)
- [ ] Model serving (Triton, TorchServe, TFServing)

### Projects
- [ ] AI Chatbot (Conversational AI with memory)
- [ ] RAG PDF Chat (Document QA)
- [ ] AI Coding Assistant
- [ ] Medical Assistant (Healthcare RAG)
- [ ] Research Assistant (Paper analysis)
- [ ] Customer Support Multi-Agent System
- [ ] SQL Agent (NL to SQL)
- [ ] Multi-Agent Workflow
- [ ] Voice AI Assistant
- [ ] Document Intelligence System

---

## 24. Interview Preparation

### Technical Topics

| Area | Topics |
|------|--------|
| ML Theory | Bias-variance, regularization, loss functions, gradient descent variants |
| DL Theory | Backpropagation, vanishing/exploding gradients, batch/layer norm |
| LLM Concepts | Attention, tokenization, fine-tuning, RLHF, alignment |
| System Design | Distributed training, model serving, RAG architecture, caching |
| Coding | Algorithms, data structures (LeetCode medium/hard) |
| ML System Design | Recommendation systems, search, ranking, fraud detection |

### Practice Platforms

| Platform | URL |
|----------|-----|
| LeetCode | [leetcode.com](https://leetcode.com) |
| NeetCode | [neetcode.io](https://neetcode.io) |
| HackerRank | [hackerrank.com](https://hackerrank.com) |
| CodeSignal | [codesignal.com](https://codesignal.com) |
| Interview Query | [interviewquery.com](https://interviewquery.com) |
| Pramp | [pramp.com](https://pramp.com) |
| StrataScratch | [stratascratch.com](https://stratascratch.com) |
| ML System Design | [grokking-ml-system-design](https://www.educative.io/courses/grokking-machine-learning-system-design) |

### Mock Interview Books

- *Machine Learning System Design Interview* by Alex Xu and Huang
- *Ace the Data Science Interview* by Nick Singh
- *Cracking the Coding Interview* by Gayle Laakmann McDowell
- *System Design Interview* by Alex Xu

### Behavioral Preparation

- [ ] STAR method (Situation, Task, Action, Result)
- [ ] Practice stories for: leadership, conflict, failure, impact
- [ ] Research company product + ML stack
- [ ] Prepare questions to ask interviewer

---

## 25. Portfolio Projects

### How to Build a Portfolio

1. **Solve real problems**: Don't build another MNIST classifier. Build something useful.
2. **Focus on production quality**: Dockerize, add tests, CI/CD, monitoring.
3. **Write about it**: Blog posts (Medium, Dev.to, Substack) explaining your approach.
4. **Show the architecture**: Diagrams, system design docs, README with badges.
5. **Deploy**: Make it accessible (Hugging Face Spaces, Railway, Render, Fly.io).
6. **Open source**: Clean code, MIT license, contribution guidelines.

### Project Descriptions for Resume

| Project | Description | Technologies |
|---------|-------------|--------------|
| RAG PDF Chatbot | Document QA system with hybrid search and reranking | LangChain, Pinecone, GPT-4, Streamlit |
| Multi-Agent Research Assistant | Collaborative agents for research, analysis, and writing | LangGraph, CrewAI, GPT-4o, FastAPI |
| Voice AI Assistant | Real-time voice conversation with STT + LLM + TTS | Whisper, GPT-4o, ElevenLabs, WebSocket |
| SQL Agent | Natural language to SQL with schema introspection | LangChain, GPT-4, PostgreSQL, FastAPI |
| Document Intelligence | Automated document classification, extraction, analysis | YOLO, LayoutLM, GPT-4o, Milvus |
| Medical RAG | Healthcare document QA with safety guardrails | LlamaIndex, GPT-4, Weaviate, FastAPI |
| Fine-tuned LLM | Domain-specific fine-tuned model with LoRA | PEFT, QLoRA, TRL, Llama 3 |
| ML Pipeline | End-to-end ML pipeline with monitoring | MLflow, Docker, FastAPI, Evidently |

### Portfolio Platform

- [ ] **Website**: Hugo/Next.js + custom domain
- [ ] **GitHub**: Well-organized repos with README
- [ ] **LinkedIn**: Projects section with links
- [ ] **Blog**: Technical blog posts explaining architecture
- [ ] **Demo**: Hosted demos on Hugging Face Spaces

---

## 26. Career Opportunities

### Job Roles

| Role | Description | Typical Salary (US) | Remote |
|------|-------------|--------------------|--------|
| AI/ML Engineer | Build and deploy ML models | $130K - $250K | ✅ |
| LLM Engineer | Build LLM applications | $150K - $300K | ✅ |
| Machine Learning Engineer | Production ML systems | $140K - $280K | ✅ |
| NLP Engineer | Natural language systems | $140K - $260K | ✅ |
| Computer Vision Engineer | Visual AI systems | $140K - $260K | ✅ |
| Generative AI Engineer | GenAI products | $150K - $350K | ✅ |
| Applied Scientist | Research + production | $160K - $350K | ✅ |
| Research Engineer | Applied research | $150K - $350K | ✅ |
| AI Product Manager | AI product strategy | $150K - $280K | ✅ |
| AI Solutions Architect | Enterprise AI consulting | $160K - $300K | ✅ |

### Salary Ranges

| Location | Entry (0-2 yr) | Mid (3-5 yr) | Senior (5-8 yr) | Staff (8+ yr) |
|----------|---------------|-------------|----------------|---------------|
| US (SF/NYC) | $120K-$160K | $160K-$220K | $220K-$300K | $300K-$500K+ |
| US (Remote) | $100K-$140K | $140K-$200K | $200K-$280K | $280K-$400K+ |
| EU (Berlin/London) | €60K-€90K | €90K-€140K | €140K-€200K | €200K-€300K+ |
| EU (Remote) | €50K-€80K | €80K-€120K | €120K-€180K | €180K-€250K+ |
| India (Bangalore) | ₹12L-₹25L | ₹25L-₹50L | ₹50L-₹80L | ₹80L-₹1.5Cr+ |

### Companies Hiring

| Type | Examples |
|------|----------|
| Big Tech | Google, Meta, Apple, Amazon, Microsoft, NVIDIA |
| AI Labs | OpenAI, Anthropic, DeepMind, Cohere, Mistral AI |
| Cloud Providers | AWS, Azure, GCP, Cloudflare |
| Enterprise | JPMorgan, Goldman Sachs, Bloomberg, Uber, Lyft, Airbnb |
| AI Startups | Notion, Perplexity, Glean, Jasper, Writer, Typeface |
| Infrastructure | Hugging Face, LangChain, Weights & Biases, Pinecone |
| Consulting | McKinsey QuantumBlack, BCG X, Deloitte AI |
| Healthcare | Epic, Tempus, PathAI, Recursion |
| Robotics | Tesla, Boston Dynamics, Covariant, Figure AI |

> 💡 **Tip:** The highest growth area in 2026 is **Generative AI Engineering** — RAG, agents, LLM fine-tuning, and AI system architecture.

---

## Final Words

> **"The best way to learn AI is to build AI."**
>
> This roadmap is a guide, not a prescription. Adapt it to your background, goals, and pace. The field moves fast — focus on fundamentals (they don't change) and build constantly (that's where real learning happens).

**Key mantras:**
1. Build projects, don't just watch tutorials
2. Read documentation, not just blog posts
3. Ship to production, not just to notebooks
4. Learn fundamentals deeply, trends pass but math doesn't
5. Join communities, share your work, get feedback
6. Teach others — it's the best way to solidify knowledge

**Good luck, and welcome to the AI Engineering journey. 🚀**

---

*Last updated: June 2026*
