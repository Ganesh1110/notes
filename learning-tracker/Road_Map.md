# 🚀 Road Map: Top 1% Mobile + AI Engineer (2026)

> **Who this is for:** A developer with React Native (JS), Flutter basics, and foundational AI knowledge, aiming for production-grade AI-powered mobile apps, senior-level interviews, open-source contributions, and remote international roles.

---

## 📋 Legend

| Symbol            | Meaning                                              |
| ----------------- | ---------------------------------------------------- |
| 🔴 **Must Learn** | Non-negotiable for your goal. Skip = blocked.        |
| 🟡 **Important**  | High ROI. Learn after Must-Learns in the same phase. |
| 🟢 **Optional**   | Differentiator. Pick based on your niche.            |
| ⏱️                | Estimated focused learning time                      |
| 🏗️                | Portfolio project                                    |
| 🎯                | Interview checkpoint                                 |
| 💡                | GitHub project idea                                  |
| 🌐                | Open-source contribution path                        |

---

## 🗺️ Dependency Graph (Read First)

```
Flutter Advanced ──────────────────────────────────┐
React Native Advanced ─────────────────────────────┤
                                                    ▼
Python for AI ──► AI Engineering Foundations ──► LLM Integration
                        │                              │
                        ▼                              ▼
               On-Device ML (TFLite)           RAG Systems
                        │                              │
                        └──────────┬────────────────────┘
                                   ▼
                            AI Agents & Agentic Apps
                                   │
                    ┌──────────────┼──────────────┐
                    ▼              ▼              ▼
            Mobile System     Cloud &         Testing &
              Design          DevOps          Security
                    │              │              │
                    └──────────────┴──────────────┘
                                   │
                              Performance
                            Optimization
```

---

## PHASE 0 — Orientation & Setup (Week 1–2)

> Before writing a single line, set up your environment, learn how professionals structure their work, and create a public GitHub presence worth showing.

### Environment & Tooling

| Topic                                                                 | Priority     | Time   |
| --------------------------------------------------------------------- | ------------ | ------ |
| Git advanced: branching strategy, rebase, cherry-pick, signed commits | 🔴 Must      | 3 days |
| Monorepo concepts (Turborepo / Melos for Flutter)                     | 🟡 Important | 2 days |
| VS Code / Android Studio: profiling tools, extensions, launch configs | 🔴 Must      | 1 day  |
| SSH keys, GPG signing, `.env` management, secrets hygiene             | 🔴 Must      | 1 day  |

### GitHub Presence

- Create a profile README with your stack, goals, and roadmap progress
- Pin 3–5 repos (even WIP) to show consistent activity
- Set up GitHub Actions for at least one existing project

---

## PHASE 1 — Advanced Flutter (Month 1–2)

> Flutter is your primary delivery vehicle. Master it before layering AI on top.

### Architecture & State Management

| Topic                                                               | Priority     | Time   |
| ------------------------------------------------------------------- | ------------ | ------ |
| Clean Architecture in Flutter (Domain / Data / Presentation layers) | 🔴 Must      | 1 week |
| Riverpod (advanced: families, providers, auto-dispose, notifiers)   | 🔴 Must      | 1 week |
| BLoC pattern (advanced: hydrated bloc, stream transformers)         | 🟡 Important | 4 days |
| Feature-first folder structure vs layer-first                       | 🔴 Must      | 2 days |
| Dependency injection with GetIt + Injectable                        | 🟡 Important | 2 days |

### Flutter UI Mastery

| Topic                                                          | Priority     | Time   |
| -------------------------------------------------------------- | ------------ | ------ |
| Custom painters and canvas API                                 | 🔴 Must      | 4 days |
| Implicit vs explicit animations, AnimationController, Tween    | 🔴 Must      | 3 days |
| Slivers (SliverList, SliverAppBar, CustomScrollView)           | 🔴 Must      | 2 days |
| Responsive design: LayoutBuilder, MediaQuery, adaptive widgets | 🔴 Must      | 2 days |
| Accessibility: semantics, screen readers, contrast ratios      | 🟡 Important | 2 days |

### Flutter Platform & Native

| Topic                                                           | Priority     | Time   |
| --------------------------------------------------------------- | ------------ | ------ |
| Platform channels (MethodChannel, EventChannel)                 | 🔴 Must      | 3 days |
| Writing native modules in Kotlin (Android) and Swift (iOS)      | 🟡 Important | 1 week |
| Flutter FFI (Dart Foreign Function Interface) for C/C++ interop | 🟢 Optional  | 3 days |
| App lifecycle management, background execution                  | 🔴 Must      | 2 days |
| Deep links, universal links, dynamic links                      | 🔴 Must      | 2 days |

### Flutter Networking & Data

| Topic                                                 | Priority    | Time   |
| ----------------------------------------------------- | ----------- | ------ |
| Dio interceptors, retry logic, certificate pinning    | 🔴 Must     | 3 days |
| Offline-first architecture with Hive / Drift (SQLite) | 🔴 Must     | 3 days |
| Secure storage, Keychain / Keystore integration       | 🔴 Must     | 2 days |
| GraphQL with Ferry or gql_flutter                     | 🟢 Optional | 3 days |

### 🏗️ Milestone 1 Portfolio Project

**"NeuraNote" — AI-Ready Flutter Notes App**

- Clean Architecture + Riverpod
- Custom animations and slivers
- Offline-first with Drift
- Platform channel for biometric auth
- CI/CD pipeline with GitHub Actions

### 🎯 Interview Checkpoint 1

- [ ] Explain Clean Architecture trade-offs in mobile (vs. MVC / MVVM)
- [ ] Draw a Riverpod dependency graph for a feature from scratch
- [ ] What is the widget rebuild lifecycle? How do you prevent unnecessary rebuilds?
- [ ] When do you use isolates vs compute()?
- [ ] Explain the Flutter rendering pipeline (build → layout → paint)

### 💡 GitHub Project Idea 1

`flutter_clean_template` — A production-ready Flutter starter with Clean Architecture, Riverpod, Drift, Dio, CI/CD, and full test coverage. Add a detailed README. This type of repo gets consistent stars.

---

## PHASE 2 — Advanced React Native (Month 2–3)

> Maintain your RN edge. The market still heavily uses RN, and being strong in both makes you exceptionally hireable.

### Architecture & Performance

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| New Architecture: JSI, TurboModules, Fabric renderer               | 🔴 Must      | 1 week |
| Reanimated 3: worklets, shared values, gesture handler integration | 🔴 Must      | 1 week |
| Zustand + React Query vs Redux Toolkit (trade-off analysis)        | 🔴 Must      | 3 days |
| Writing native TurboModules in Kotlin/Swift                        | 🟡 Important | 1 week |
| Expo Modules API for custom native code                            | 🟡 Important | 3 days |

### React Native Ecosystem

| Topic                                     | Priority     | Time   |
| ----------------------------------------- | ------------ | ------ |
| React Native Skia for advanced graphics   | 🟡 Important | 3 days |
| MMKV for high-performance storage         | 🔴 Must      | 1 day  |
| WatermelonDB for reactive local database  | 🟡 Important | 3 days |
| React Native Web (universal app strategy) | 🟢 Optional  | 3 days |
| Expo Router (file-based routing)          | 🔴 Must      | 2 days |

### 🏗️ Milestone 2 Portfolio Project

**"SwiftCart" — High-Performance E-Commerce App in React Native**

- New Architecture with TurboModules
- Reanimated 3 gesture-driven animations
- React Query for server state + MMKV cache
- Offline mode with WatermelonDB
- Custom native module for payment SDK

### 🎯 Interview Checkpoint 2

- [ ] Explain JSI and why it replaces the bridge
- [ ] How does Fabric differ from the legacy renderer?
- [ ] Explain the difference between JS thread, UI thread, and native modules thread
- [ ] When would you choose WatermelonDB over AsyncStorage?
- [ ] How do you debug performance issues in React Native? (Flipper, Systrace, Profiler)

### 💡 GitHub Project Idea 2

`rn-ai-starter` — React Native Expo template pre-wired with OpenAI/Gemini API, streaming responses, voice input, and proper error boundaries.

---

## PHASE 3 — AI Engineering Foundations (Month 2–3, parallel with Phase 2)

> Python is unavoidable in AI. Learn just enough to work fluently with AI tooling.

### Python for AI Engineers

| Topic                                                            | Priority | Time   |
| ---------------------------------------------------------------- | -------- | ------ |
| Python fundamentals: data types, list comprehensions, generators | 🔴 Must  | 4 days |
| NumPy and Pandas: array ops, DataFrame manipulation              | 🔴 Must  | 3 days |
| Virtual environments: `uv`, `poetry`, `venv`                     | 🔴 Must  | 1 day  |
| Async Python: `asyncio`, `httpx`, `aiohttp`                      | 🔴 Must  | 2 days |
| FastAPI: building AI backends with async routes                  | 🔴 Must  | 4 days |
| Pydantic v2: data validation, settings management                | 🔴 Must  | 2 days |

### AI & ML Concepts

| Topic                                                                        | Priority     | Time   |
| ---------------------------------------------------------------------------- | ------------ | ------ |
| How LLMs work: transformers, tokenization, context windows, embeddings       | 🔴 Must      | 3 days |
| Prompt engineering: zero-shot, few-shot, chain-of-thought, structured output | 🔴 Must      | 3 days |
| Tokens, temperature, top-p, max_tokens — hands-on experimentation            | 🔴 Must      | 2 days |
| Embeddings and vector similarity: cosine, dot product                        | 🔴 Must      | 2 days |
| Fine-tuning vs. RAG vs. prompt engineering — when to use which               | 🔴 Must      | 2 days |
| Hugging Face ecosystem: Hub, `transformers`, `datasets`, `spaces`            | 🟡 Important | 3 days |

### 🎯 Interview Checkpoint 3

- [ ] Explain what a token is and why it matters for cost/latency
- [ ] When would you fine-tune a model vs. use RAG?
- [ ] What is temperature and how does it affect output?
- [ ] Explain embedding space intuitively
- [ ] What is hallucination and how do you mitigate it?

---

## PHASE 4 — LLM Development & Integration (Month 3–4)

> This is where your mobile skills fuse with AI. Learn to integrate LLMs into real applications.

### LLM APIs & SDKs

| Topic                                                             | Priority     | Time   |
| ----------------------------------------------------------------- | ------------ | ------ |
| OpenAI API: chat completions, function calling, streaming, vision | 🔴 Must      | 3 days |
| Google Gemini API: multimodal, long-context features              | 🔴 Must      | 2 days |
| Anthropic Claude API: tool use, document Q&A, extended context    | 🔴 Must      | 2 days |
| Structured outputs with JSON mode and Pydantic                    | 🔴 Must      | 2 days |
| Streaming responses in mobile apps (SSE / WebSockets)             | 🔴 Must      | 3 days |
| Cost optimization: caching, batching, model tiering               | 🟡 Important | 2 days |

### LLM Frameworks

| Topic                                               | Priority     | Time   |
| --------------------------------------------------- | ------------ | ------ |
| LangChain: chains, memory, callbacks                | 🟡 Important | 4 days |
| LangGraph: stateful multi-step agent workflows      | 🔴 Must      | 1 week |
| LiteLLM: unified API gateway for multiple providers | 🟡 Important | 2 days |
| OpenAI Assistants API (threads, run management)     | 🟢 Optional  | 2 days |

### Mobile LLM Integration Patterns

| Topic                                                           | Priority | Time   |
| --------------------------------------------------------------- | -------- | ------ |
| Streaming text to Flutter UI (chunked HTTP / SSE with Dio)      | 🔴 Must  | 3 days |
| Conversation history management (context window budgeting)      | 🔴 Must  | 2 days |
| Optimistic UI for AI responses                                  | 🔴 Must  | 2 days |
| Error handling: rate limits, timeouts, fallback models          | 🔴 Must  | 2 days |
| Multimodal: sending images from camera/gallery to vision models | 🔴 Must  | 2 days |

### 🏗️ Milestone 3 Portfolio Project

**"Sage" — AI Research Companion Mobile App**

- Flutter frontend with streaming chat UI
- Multimodal: camera input → Gemini Vision analysis
- Conversation history with context window management
- FastAPI backend with LangGraph workflow
- Cost tracking and model fallback logic

### 🎯 Interview Checkpoint 4

- [ ] How do you implement streaming LLM responses in a mobile app?
- [ ] Explain function calling and give a mobile use case
- [ ] How do you manage conversation context when approaching the token limit?
- [ ] How would you reduce LLM API costs in a high-traffic mobile app?
- [ ] What's the difference between LangChain and LangGraph?

### 💡 GitHub Project Idea 3

`flutter_llm_chat` — A Flutter package that abstracts OpenAI / Gemini / Claude behind one interface with streaming, retry logic, and cost tracking. Publish on pub.dev.

### 🌐 Open-Source Contribution Path 1

- Contribute to `langchain-dart` (Dart port of LangChain) — add missing tool integrations, fix docs
- Submit examples to `google/generative-ai-dart` official SDK

---

## PHASE 5 — On-Device ML & Edge AI (Month 4–5)

> Your biggest differentiator. Most AI engineers can't ship models to a phone. You will.

### TensorFlow Lite & Core ML

| Topic                                                                                          | Priority     | Time   |
| ---------------------------------------------------------------------------------------------- | ------------ | ------ |
| TensorFlow Lite: model conversion, quantization (INT8, FP16)                                   | 🔴 Must      | 4 days |
| `tflite_flutter` plugin: model loading, inference pipeline                                     | 🔴 Must      | 3 days |
| Firebase ML Kit: text recognition, face detection, barcode, pose                               | 🔴 Must      | 3 days |
| Core ML (iOS): model conversion with `coremltools`, running from Flutter via platform channels | 🟡 Important | 4 days |
| PyTorch Mobile: ONNX export, model optimization                                                | 🟢 Optional  | 3 days |

### On-Device LLMs

| Topic                                                           | Priority     | Time   |
| --------------------------------------------------------------- | ------------ | ------ |
| MediaPipe LLM Inference API in Flutter                          | 🔴 Must      | 3 days |
| Google AI Edge (Gemini Nano on-device)                          | 🔴 Must      | 3 days |
| llama.cpp integration via FFI                                   | 🟡 Important | 4 days |
| Model caching, incremental loading, memory management on mobile | 🔴 Must      | 2 days |
| Privacy-first AI: when to use on-device vs. cloud               | 🔴 Must      | 1 day  |

### 🏗️ Milestone 4 Portfolio Project

**"LensAI" — On-Device Vision Intelligence App**

- Real-time object detection with TFLite (YOLO v8)
- On-device OCR + document summarization with Gemini Nano
- Zero network required in offline mode
- Privacy dashboard showing what data stays on-device
- Model performance profiler built into the debug menu

### 🎯 Interview Checkpoint 5

- [ ] Explain INT8 quantization and its trade-offs
- [ ] How do you prevent memory crashes when running a model on a low-end Android device?
- [ ] When would you use on-device inference vs. cloud inference?
- [ ] How does MediaPipe LLM Inference differ from `tflite_flutter`?
- [ ] What is the ONNX format and why does it matter?

### 💡 GitHub Project Idea 4

`flutter_on_device_ai` — A Flutter plugin that wraps TFLite + ML Kit + MediaPipe behind a unified interface. Add model benchmarking tools.

### 🌐 Open-Source Contribution Path 2

- Contribute to `tflite_flutter` (the official Google-backed Flutter plugin) — add model examples, improve documentation, add benchmark tooling
- Submit a model to TensorFlow Hub with a Flutter integration guide

---

## PHASE 6 — RAG Systems (Month 5–6)

> RAG is the most practical AI engineering skill for product developers in 2026.

### Vector Databases & Embeddings

| Topic                                                                  | Priority     | Time   |
| ---------------------------------------------------------------------- | ------------ | ------ |
| Embedding models: `text-embedding-3-small`, `nomic-embed`, `bge`       | 🔴 Must      | 2 days |
| Pinecone: index management, upsert, query, namespaces                  | 🔴 Must      | 3 days |
| Qdrant: self-hosted, payload filtering, hybrid search                  | 🟡 Important | 3 days |
| PgVector (Supabase): SQL + vector queries, index types (IVFFlat, HNSW) | 🔴 Must      | 3 days |
| Chunking strategies: fixed, semantic, hierarchical, document-aware     | 🔴 Must      | 2 days |

### RAG Architectures

| Topic                                                                      | Priority     | Time   |
| -------------------------------------------------------------------------- | ------------ | ------ |
| Naive RAG → Advanced RAG → Modular RAG (understand the progression)        | 🔴 Must      | 3 days |
| Hybrid search: dense (semantic) + sparse (BM25) retrieval                  | 🔴 Must      | 2 days |
| Reranking with Cohere Rerank or `cross-encoder` models                     | 🔴 Must      | 2 days |
| HyDE (Hypothetical Document Embeddings)                                    | 🟡 Important | 1 day  |
| Multi-vector retrieval: parent document, summary + content                 | 🟡 Important | 2 days |
| Evaluation: RAGAS metrics (context recall, faithfulness, answer relevancy) | 🔴 Must      | 2 days |

### RAG in Mobile Context

| Topic                                                                   | Priority | Time   |
| ----------------------------------------------------------------------- | -------- | ------ |
| Mobile-optimized RAG: local SQLite + embeddings vs. remote Pinecone     | 🔴 Must  | 2 days |
| Document processing pipeline: PDF / image → chunks → embeddings → store | 🔴 Must  | 3 days |
| Streaming RAG responses to Flutter UI                                   | 🔴 Must  | 2 days |

### 🏗️ Milestone 5 Portfolio Project

**"DocMind" — Intelligent Document Assistant App**

- Upload PDFs / images from mobile → process → embed → store in Supabase PgVector
- Hybrid semantic + keyword search
- Streaming answers with source citations highlighted in the document viewer
- RAGAS evaluation pipeline with a test suite of 50 Q&A pairs
- Flutter frontend + FastAPI backend deployed on Railway

### 🎯 Interview Checkpoint 6

- [ ] Explain the difference between sparse and dense retrieval
- [ ] What is the lost-in-the-middle problem in RAG?
- [ ] How do you choose chunk size?
- [ ] What does HNSW stand for and why is it used for vector search?
- [ ] Walk me through evaluating a RAG system from scratch

### 💡 GitHub Project Idea 5

`rag_bench` — A Python tool that takes a document, builds a RAG pipeline with swappable vector DBs, and outputs RAGAS scores. Flutter companion app to visualize results.

### 🌐 Open-Source Contribution Path 3

- Contribute RAG evaluation examples to the `ragas` library
- Add mobile-specific documentation to Supabase's Flutter guides

---

## PHASE 7 — AI Agents (Month 6–7)

> Agents are the 2026 frontier. Building agentic mobile apps is a rare, extremely valuable skill.

### Agent Fundamentals

| Topic                                                           | Priority     | Time   |
| --------------------------------------------------------------- | ------------ | ------ |
| ReAct pattern (Reasoning + Acting)                              | 🔴 Must      | 2 days |
| Tool / function calling: design, schema, validation             | 🔴 Must      | 3 days |
| Agent memory types: working, episodic, semantic, procedural     | 🔴 Must      | 2 days |
| LangGraph: nodes, edges, conditional routing, human-in-the-loop | 🔴 Must      | 1 week |
| Agent evaluation: task completion rate, tool call accuracy      | 🟡 Important | 2 days |

### Multi-Agent Systems

| Topic                                              | Priority     | Time   |
| -------------------------------------------------- | ------------ | ------ |
| Orchestrator–subagent patterns                     | 🟡 Important | 3 days |
| CrewAI: role-based agents, task delegation         | 🟡 Important | 3 days |
| OpenAI Swarm / handoff patterns                    | 🟢 Optional  | 2 days |
| Agent reliability: retry, fallback, timeout guards | 🔴 Must      | 2 days |

### Agentic Mobile Apps

| Topic                                                                | Priority     | Time   |
| -------------------------------------------------------------------- | ------------ | ------ |
| Background agent execution on mobile (WorkManager / BGTaskScheduler) | 🔴 Must      | 3 days |
| Agent progress streaming to Flutter UI (LangGraph events → SSE)      | 🔴 Must      | 3 days |
| User approval workflows (human-in-the-loop in mobile UX)             | 🔴 Must      | 2 days |
| Agent observability: LangSmith traces in mobile app debug panel      | 🟡 Important | 2 days |

### 🏗️ Milestone 6 Portfolio Project

**"AutoTask" — Agentic Personal Productivity App**

- LangGraph orchestrator with 5+ tools: calendar, email, web search, notes, reminders
- Flutter UI shows agent reasoning steps in real-time (streaming events)
- Human-in-the-loop: user approves/rejects before destructive actions
- Background agent runs autonomously, notifies on completion
- Full LangSmith observability integrated

### 🎯 Interview Checkpoint 7

- [ ] Explain the ReAct pattern with a concrete example
- [ ] How do you prevent an agent from looping infinitely?
- [ ] What is human-in-the-loop and when is it critical?
- [ ] How do you test an agentic system?
- [ ] Explain the difference between an agent's working memory and its long-term memory

### 💡 GitHub Project Idea 6

`mobile_agent_kit` — A Flutter + FastAPI starter for building agentic mobile apps. Pre-built tools for contacts, calendar, and camera. Plug in your LangGraph agent.

### 🌐 Open-Source Contribution Path 4

- Contribute Flutter-specific examples to the LangGraph documentation
- Add mobile app examples to the LangSmith cookbook

---

## PHASE 8 — Mobile System Design (Month 7–8)

> System design separates senior from mid-level. For AI-powered mobile, this is uniquely complex.

### Core System Design Concepts

| Topic                                                                     | Priority     | Time   |
| ------------------------------------------------------------------------- | ------------ | ------ |
| Offline-first architecture: sync strategies, conflict resolution (CRDTs)  | 🔴 Must      | 4 days |
| Push notification architecture at scale (FCM / APNs, topic-based routing) | 🔴 Must      | 2 days |
| Authentication: JWT, refresh tokens, OAuth 2.0, biometric integration     | 🔴 Must      | 3 days |
| Real-time sync: WebSockets vs. SSE vs. polling — trade-offs               | 🔴 Must      | 2 days |
| Feature flags and A/B testing in mobile (Firebase Remote Config)          | 🟡 Important | 2 days |

### AI System Design on Mobile

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| LLM gateway pattern: rate limiting, cost allocation, model routing | 🔴 Must      | 2 days |
| Semantic cache: avoid repeated LLM calls for similar queries       | 🔴 Must      | 2 days |
| AI personalization: user embeddings, recommendation pipeline       | 🟡 Important | 3 days |
| Fallback chains: primary model → cheaper model → on-device model   | 🔴 Must      | 1 day  |
| Privacy-preserving AI: differential privacy, on-device processing  | 🟡 Important | 2 days |

### Scalability & Architecture Patterns

| Topic                                                                    | Priority     | Time   |
| ------------------------------------------------------------------------ | ------------ | ------ |
| API design: REST best practices, versioning, pagination                  | 🔴 Must      | 2 days |
| Event-driven architecture: message queues (Redis Streams / Kafka basics) | 🟡 Important | 3 days |
| CQRS pattern for AI apps (separate read/write models)                    | 🟢 Optional  | 2 days |
| Rate limiting strategies: token bucket, sliding window                   | 🔴 Must      | 1 day  |

### 🎯 Interview Checkpoint 8 (System Design)

Practice designing these systems end-to-end (whiteboard style):

- [ ] Design a ChatGPT-like mobile app for 10M users
- [ ] Design an on-device document scanner with cloud OCR fallback
- [ ] Design a real-time collaborative AI note-taking app
- [ ] Design an offline-first AI fitness coach app
- [ ] Design the LLM backend for a customer support mobile app

---

## PHASE 9 — Cloud Deployment & DevOps (Month 8–9)

> You must be able to ship your own backends. Remote companies expect full-stack ownership.

### Cloud Fundamentals

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| Docker: Dockerfiles, multi-stage builds, docker-compose            | 🔴 Must      | 4 days |
| Deploy FastAPI on Railway / Fly.io / Render (start here — easiest) | 🔴 Must      | 2 days |
| GCP: Cloud Run, Vertex AI, Firebase ecosystem                      | 🔴 Must      | 1 week |
| AWS basics: EC2, S3, Lambda, ECS (enough for interviews)           | 🟡 Important | 1 week |
| Supabase: PostgreSQL + PgVector + Auth + Storage + Realtime        | 🔴 Must      | 4 days |

### CI/CD for Mobile + AI

| Topic                                                           | Priority     | Time   |
| --------------------------------------------------------------- | ------------ | ------ |
| GitHub Actions: Flutter build, test, and deploy workflows       | 🔴 Must      | 3 days |
| Fastlane: automated iOS/Android builds, signing, uploads        | 🔴 Must      | 3 days |
| Codemagic or Bitrise for mobile CI (choose one)                 | 🟡 Important | 2 days |
| Semantic versioning and automated changelogs                    | 🟡 Important | 1 day  |
| Environment management: dev / staging / prod configs in Flutter | 🔴 Must      | 1 day  |

### Infrastructure as Code

| Topic                                                          | Priority     | Time   |
| -------------------------------------------------------------- | ------------ | ------ |
| Terraform basics: provision Cloud Run, Supabase, Redis         | 🟡 Important | 4 days |
| Environment variables and secrets management (Doppler / Vault) | 🔴 Must      | 1 day  |
| Basic Kubernetes concepts (pods, services, deployments)        | 🟢 Optional  | 3 days |

### Monitoring & Observability

| Topic                                                   | Priority | Time   |
| ------------------------------------------------------- | -------- | ------ |
| Firebase Crashlytics + Performance Monitoring           | 🔴 Must  | 2 days |
| Sentry for Flutter: error tracking, performance tracing | 🔴 Must  | 1 day  |
| LangSmith: LLM call tracing, latency, cost monitoring   | 🔴 Must  | 2 days |
| Structured logging in FastAPI (loguru + JSON logs)      | 🔴 Must  | 1 day  |

### 🎯 Interview Checkpoint 9

- [ ] Walk through your CI/CD pipeline for a Flutter app
- [ ] How do you handle secrets in a production mobile/backend setup?
- [ ] What is a container and why does it help AI deployments?
- [ ] Explain blue-green deployment
- [ ] How do you monitor LLM costs in production?

### 💡 GitHub Project Idea 7

`flutter_fastapi_template` — A production-ready monorepo: Flutter app + FastAPI backend + Docker Compose + GitHub Actions CI/CD + Terraform for GCP Cloud Run. The gold standard starter template.

---

## PHASE 10 — Testing (Month 9–10)

> Untested code is unshippable code. Top 1% engineers write tests without being asked.

### Flutter Testing

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| Unit tests: `flutter_test`, mocking with `mocktail`                | 🔴 Must      | 3 days |
| Widget tests: `WidgetTester`, pump, finders                        | 🔴 Must      | 3 days |
| Integration tests: `integration_test` package, real device testing | 🔴 Must      | 2 days |
| Golden tests: pixel-perfect UI regression testing                  | 🟡 Important | 2 days |
| TDD workflow: red–green–refactor in Flutter                        | 🟡 Important | 2 days |

### AI System Testing

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| LLM output evaluation: LLM-as-judge patterns                       | 🔴 Must      | 2 days |
| RAG evaluation with RAGAS (automated test suite)                   | 🔴 Must      | 2 days |
| Prompt regression testing: catch regressions in LLM behavior       | 🔴 Must      | 2 days |
| Mocking LLM APIs in unit tests (record/replay with VCR-like tools) | 🔴 Must      | 1 day  |
| Agent testing: deterministic tool call verification                | 🟡 Important | 2 days |

### React Native Testing

| Topic                                     | Priority     | Time   |
| ----------------------------------------- | ------------ | ------ |
| Jest + React Native Testing Library       | 🔴 Must      | 2 days |
| Detox for E2E testing on iOS/Android      | 🟡 Important | 3 days |
| MSW (Mock Service Worker) for API mocking | 🟡 Important | 1 day  |

---

## PHASE 11 — Security (Month 10)

> Mobile security is heavily tested in senior interviews and critical for international clients.

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| OWASP Mobile Top 10 (2024) — read and internalize every item       | 🔴 Must      | 3 days |
| Certificate pinning: implementation and bypassing detection        | 🔴 Must      | 2 days |
| Secure storage: never store secrets in SharedPreferences           | 🔴 Must      | 1 day  |
| Obfuscation: ProGuard / R8 (Android), bitcode stripping (iOS)      | 🔴 Must      | 1 day  |
| Jailbreak / root detection                                         | 🟡 Important | 1 day  |
| AI-specific security: prompt injection, jailbreaking, data leakage | 🔴 Must      | 3 days |
| API security: OAuth 2.0, rate limiting, input sanitization         | 🔴 Must      | 2 days |
| Dependency auditing: `flutter pub audit`, `npm audit`, Snyk        | 🟡 Important | 1 day  |

### 🎯 Interview Checkpoint 10

- [ ] Explain a prompt injection attack and how you mitigate it
- [ ] How do you store a user's API key securely on-device?
- [ ] What is certificate pinning and what are its risks?
- [ ] Walk through OWASP Mobile #1 through #5

---

## PHASE 12 — Performance Optimization (Month 10–11)

### Flutter Performance

| Topic                                                                 | Priority     | Time   |
| --------------------------------------------------------------------- | ------------ | ------ |
| DevTools profiler: CPU, memory, network, widget rebuild inspector     | 🔴 Must      | 3 days |
| Isolates and compute() for heavy operations                           | 🔴 Must      | 2 days |
| Image optimization: caching, WebP, lazy loading, thumbnail strategies | 🔴 Must      | 2 days |
| App startup time: deferred imports, lazy initialization               | 🟡 Important | 2 days |
| Bundle size: tree-shaking, deferred loading                           | 🟡 Important | 1 day  |
| Shader compilation jank (Impeller rendering engine understanding)     | 🟡 Important | 2 days |

### AI Performance on Mobile

| Topic                                                              | Priority     | Time   |
| ------------------------------------------------------------------ | ------------ | ------ |
| LLM latency optimization: streaming, speculative decoding concepts | 🔴 Must      | 2 days |
| Semantic caching: cache LLM responses for repeated queries         | 🔴 Must      | 2 days |
| Model quantization and its impact on inference speed               | 🔴 Must      | 1 day  |
| Battery impact of AI workloads: measurement and mitigation         | 🟡 Important | 2 days |

### 🎯 Interview Checkpoint 11

- [ ] Identify performance issues from a given Flutter DevTools screenshot
- [ ] How would you speed up the first AI response in your app?
- [ ] Explain the difference between jank and ANR
- [ ] How does semantic caching reduce costs and latency?

---

## PHASE 13 — Open Source & Interview Mastery (Month 11–12)

### Open Source Strategy

| Activity                                                         | Priority     | Time         |
| ---------------------------------------------------------------- | ------------ | ------------ |
| Publish 1 Flutter package on pub.dev (from your projects above)  | 🔴 Must      | 1 week       |
| Make 10+ meaningful contributions to top Flutter/AI repos        | 🔴 Must      | Ongoing      |
| Write 5 technical blog posts (pub.dev readme, Medium, Dev.to)    | 🔴 Must      | Ongoing      |
| Speak at a Flutter/AI community event or record a technical talk | 🟡 Important | 1 month prep |

### 🌐 Open-Source Contribution Targets

| Repository                  | Type of Contribution                          |
| --------------------------- | --------------------------------------------- |
| `flutter/flutter`           | Bug fixes, documentation, examples            |
| `rrousselGit/riverpod`      | Examples, issue triage, docs improvements     |
| `tflite_flutter`            | New model examples, benchmark tooling         |
| `langchain-dart`            | Missing API integrations, tool additions      |
| `supabase-flutter`          | Vector search examples, AI integration guides |
| `ragas`                     | Mobile-specific RAG evaluation examples       |
| `google/generative-ai-dart` | Examples, edge cases, docs                    |

### Interview Preparation

| Activity                                                                            | Time    |
| ----------------------------------------------------------------------------------- | ------- |
| LeetCode: 75 questions (NeetCode 75 list) focused on arrays, strings, trees, graphs | 6 weeks |
| 20 Flutter/Dart-specific coding exercises                                           | 2 weeks |
| 10 full system design mock interviews (use Excalidraw)                              | Ongoing |
| Behavioral: STAR format stories for 15 situations                                   | 1 week  |
| Salary negotiation research (levels.fyi, Glassdoor for your target roles)           | 2 days  |

### 🎯 Final Interview Checkpoint (Month 12)

**Technical:**

- [ ] Complete NeetCode 75 with solutions in Dart
- [ ] Can design any mobile system end-to-end in 45 minutes
- [ ] Can explain every project on GitHub without notes
- [ ] Can explain trade-offs of every technology choice you've made

**AI-Specific:**

- [ ] Can build a RAG pipeline from scratch in a take-home assignment
- [ ] Understand pricing and latency of top 5 LLM providers
- [ ] Have deployed at least 2 AI backends to production

**Portfolio:**

- [ ] 5+ polished GitHub projects with READMEs, demos, and tests
- [ ] 1 published pub.dev package with 10+ likes
- [ ] Technical blog with 5+ posts
- [ ] LinkedIn with project demos and recommendations

---

## 📅 12-Month Progression Plan

```
Month 1   ████████████████░░░░  Advanced Flutter (Arch, UI, Native)
Month 2   ████████░░████████░░  Adv. Flutter finish + React Native New Arch
Month 3   ████████████████████  React Native finish + AI Foundations + Python
Month 4   ████████████████████  LLM APIs + Mobile LLM Integration
Month 5   ████████████████████  On-Device ML + Edge AI
Month 6   ████████████████████  RAG Systems + Vector DBs
Month 7   ████████████████████  AI Agents + LangGraph
Month 8   ████████████████████  Mobile System Design
Month 9   ████████████████████  Cloud Deployment + DevOps + CI/CD
Month 10  ████████████████████  Testing + Security
Month 11  ████████████████████  Performance + Interview Prep Begins
Month 12  ████████████████████  Open Source + Full Interview Blitz
```

**12-Month Milestone:** You can build, test, deploy, and maintain a production AI-powered mobile application end-to-end. You pass senior mobile engineer interviews at growth-stage startups. You have a visible open-source presence.

---

## 📅 24-Month Progression Plan

### Month 13–15: Depth & Specialization

Pick ONE of these tracks to go deep on (based on what excites you most):

**Track A — AI Product Engineering**

- Advanced agent architectures: memory systems, tool orchestration
- Multi-modal apps: audio (Whisper / ElevenLabs), video analysis
- AI UX patterns: progressive disclosure, uncertainty communication
- Product metrics for AI features (engagement, latency, cost per session)

**Track B — On-Device AI Platform**

- Advanced model optimization: pruning, distillation, hardware acceleration (GPU/NPU delegates)
- Cross-platform ML deployment pipelines
- Contribute to MediaPipe or TFLite at the core level
- Write benchmarking papers / blog posts comparing model performance on devices

**Track C — AI Infrastructure & Platform**

- MLOps: model versioning (MLflow, DVC), A/B testing models in production
- Building internal AI platforms (LLM gateway + monitoring + cost allocation)
- Kubernetes for AI workloads (GPU node pools, model serving)
- Distributed inference: vLLM, TensorRT-LLM

### Month 16–18: Leadership & Reputation

| Activity                                                                      | Goal                |
| ----------------------------------------------------------------------------- | ------------------- |
| Lead an open-source project (not just contribute)                             | Establish authority |
| Publish a comprehensive technical tutorial (10K+ word guide)                  | SEO + credibility   |
| Start a newsletter or YouTube channel on Mobile AI                            | Audience building   |
| Mentor 2–3 junior developers publicly (Twitter/X, Discord)                    | Network effect      |
| Apply for speaking at Flutter Forward, Google I/O extended, or AI conferences | Public profile      |

### Month 19–21: Senior / Staff Engineer Readiness

| Skill                         | Focus                                                 |
| ----------------------------- | ----------------------------------------------------- |
| Technical leadership          | Running technical design reviews, RFC writing, ADRs   |
| Cross-functional work         | Working with PMs, designers, and data scientists      |
| Estimation & planning         | Breaking down 3-month projects into weekly milestones |
| Code review culture           | Writing reviews that teach, not just nitpick          |
| Architectural decision-making | Documenting trade-offs for future team members        |

### Month 22–24: Top 1% Positioning

**Your profile at Month 24:**

- 🏆 Staff/Principal-level technical skills
- 🌐 10+ open-source contributions across major repos
- 📦 2+ published packages/libraries with active users
- ✍️ Recognized technical writer (blog, newsletter, or YouTube)
- 💼 Portfolio of 8+ production-grade projects with live demos
- 🎙️ Conference speaker or workshop facilitator
- 💰 Targeting $150K–$250K remote roles (US-equivalent compensation)

---

## 🛠️ Master Tools Reference

### Mobile Development

`Flutter` · `Dart` · `React Native` · `Expo` · `Riverpod` · `BLoC` · `Reanimated 3` · `React Query` · `Drift` · `MMKV` · `WatermelonDB`

### AI Engineering

`Python` · `FastAPI` · `LangChain` · `LangGraph` · `LangSmith` · `OpenAI SDK` · `Google GenAI SDK` · `Anthropic SDK` · `Hugging Face` · `RAGAS`

### On-Device AI

`TensorFlow Lite` · `tflite_flutter` · `Firebase ML Kit` · `MediaPipe` · `Core ML` · `ONNX`

### Databases & Storage

`Supabase` · `Pinecone` · `Qdrant` · `PgVector` · `Redis` · `Firebase Firestore`

### DevOps & Cloud

`Docker` · `GCP Cloud Run` · `Railway` · `GitHub Actions` · `Fastlane` · `Terraform` · `Sentry` · `Firebase Crashlytics`

### Testing

`flutter_test` · `mocktail` · `integration_test` · `Jest` · `Detox` · `RAGAS` · `LangSmith`

---

## 📚 Core Resources

| Resource                                            | Type      | Phase |
| --------------------------------------------------- | --------- | ----- |
| Flutter documentation (docs.flutter.dev)            | Docs      | 1     |
| Very Good Ventures blog (verygood.ventures/blog)    | Blog      | 1     |
| fast.ai Practical Deep Learning                     | Course    | 3     |
| LangChain Academy (academy.langchain.com)           | Course    | 4, 7  |
| Full Stack LLM Bootcamp (fullstackdeeplearning.com) | Course    | 4–7   |
| Designing Machine Learning Systems — Chip Huyen     | Book      | 8     |
| NeetCode.io                                         | Practice  | 12    |
| system-design-primer (GitHub)                       | Reference | 8     |

---

> **Final Note:** Consistency beats intensity. 2–3 focused hours daily outperforms weekend cramming. Every project in this roadmap should be public on GitHub with a README that a hiring manager or open-source contributor can understand in 5 minutes. Your code is your portfolio; your GitHub is your resume.

---

_Last updated: June 2026 · Tailored for React Native + Flutter developers transitioning into AI engineering_
