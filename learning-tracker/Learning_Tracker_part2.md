---
# 📱 TRACK B — React Native `🟦 LEARNING`
---

## B.1 JavaScript Fundamentals Refresh `🟦 LEARNING`

> You know basic JS — this section fills the gaps that matter for React Native.

---

### B.1.1 Modern JavaScript (ES6+) `🟦 LEARNING`

#### 📌 What to Learn

- Destructuring: arrays, objects, nested, with defaults
- Spread / rest operator
- Template literals
- Optional chaining (`?.`) and nullish coalescing (`??`)
- Modules: `import` / `export` (named vs default)
- `Promise`, `async/await`, `Promise.all`
- Array methods: `map`, `filter`, `reduce`, `find`, `some`, `every`, `flat`, `flatMap`
- Object methods: `Object.keys`, `Object.values`, `Object.entries`, `Object.assign`
- Short-circuit evaluation: `&&`, `||` for conditional rendering

#### 🎯 Why It Matters

React Native is JavaScript. If your JS is shaky, your RN code will be full of bugs that are hard to trace. These ES6+ patterns appear in EVERY React Native codebase.

#### 🌍 Real-World Example

```javascript
// Destructuring API response — used constantly
const {
  data: { user, posts },
  error,
} = await fetchDashboard();
const { name = "Anonymous", avatar = defaultAvatar } = user ?? {};

// Array transformation — rendering lists
const postCards = posts
  .filter((p) => p.isPublished)
  .map(({ id, title, author }) => ({ id, title, authorName: author.name }));

// Optional chaining — safe navigation in JS
const firstPostTitle = user?.posts?.[0]?.title ?? "No posts yet";

// Short-circuit for conditional rendering
return (
  <View>
    {isLoading && <ActivityIndicator />}
    {error && <ErrorText message={error.message} />}
    {data && <DataList items={data} />}
  </View>
);
```

#### 🏋️ Mini Exercises

- [ ] Destructure a deeply nested API response object (3 levels deep)
- [ ] Use `reduce` to group an array of transactions by category
- [ ] Rewrite 5 promise chains as async/await
- [ ] Use `Promise.all` to fetch 3 resources in parallel
- [ ] Use optional chaining on a navigation params object

#### ✅ Revision Checklist

- [ ] Can destructure complex nested objects confidently
- [ ] Can explain `&&` conditional rendering without notes
- [ ] Can rewrite callback-based code as async/await
- [ ] Can use `reduce` to transform arrays into objects

---

## B.2 React Fundamentals `🟦 LEARNING`

### B.2.1 Hooks — The Core of Modern React/RN `🟦 LEARNING`

#### 📌 What to Learn

- `useState` — local component state
- `useEffect` — side effects, subscriptions, cleanup
- `useRef` — mutable values without re-render, DOM refs
- `useCallback` — memoize functions
- `useMemo` — memoize computed values
- `useContext` — consume React context
- Custom hooks — extract and reuse stateful logic

#### 🎯 Why It Matters

Hooks ARE modern React Native. Every component uses them. Understanding when NOT to use `useEffect` is what separates senior from junior developers.

#### 🌍 Real-World Example

```javascript
// Custom hook — encapsulates API fetching logic
function usePosts(userId) {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false; // cleanup flag — prevents state update after unmount

    async function fetchPosts() {
      setLoading(true);
      try {
        const data = await api.getPosts(userId);
        if (!cancelled) setPosts(data);
      } catch (e) {
        if (!cancelled) setError(e);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    fetchPosts();
    return () => {
      cancelled = true;
    }; // cleanup on unmount
  }, [userId]); // re-fetch when userId changes

  return { posts, loading, error };
}

// useCallback — prevent child re-renders
const handleAddToCart = useCallback(
  (product) => {
    dispatch({ type: "ADD_TO_CART", payload: product });
  },
  [dispatch],
); // stable reference — only changes if dispatch changes

// useMemo — expensive computation
const sortedProducts = useMemo(
  () => [...products].sort((a, b) => a.price - b.price),
  [products], // only re-sorts when products array changes
);
```

#### 🏋️ Mini Exercises

- [ ] Build a counter with useState — add reset and step functionality
- [ ] Build a useEffect that subscribes to a WebSocket and cleans up on unmount
- [ ] Build a custom `useDebounce(value, delay)` hook
- [ ] Build a custom `useLocalStorage(key, initialValue)` hook
- [ ] Build a custom `useApi(url)` hook with loading/error/data states
- [ ] Demonstrate the difference between with/without useCallback using console.logs

#### 🛠️ Mini Project

**"Custom Hooks Library"** (`hooks/` folder)

- [ ] `useAuth()` — login, logout, current user state
- [ ] `useInfiniteScroll(fetchFn)` — paginated list loading
- [ ] `useNetworkStatus()` — online/offline detection
- [ ] `useDebounce(value, ms)` — delay input processing
- [ ] `usePersistentState(key, initial)` — AsyncStorage-backed state

#### ⚠️ Common Mistakes

- [ ] I understand: missing `useEffect` dependency causes stale closures — ESLint exhaustive-deps is your friend
- [ ] I understand: `useEffect` with no deps runs once; with `[]` runs once; with `[x]` runs when x changes
- [ ] I understand: updating state inside `useEffect` without conditions = infinite loop
- [ ] I understand: `useCallback` and `useMemo` have costs — only use when profiling shows the benefit

---

## B.3 React Native Core `🔲 NOT STARTED`

### B.3.1 RN Fundamentals `🔲 NOT STARTED`

#### 📌 What to Learn

- `View`, `Text`, `Image`, `ScrollView`, `FlatList`, `SectionList`
- `StyleSheet.create` vs inline styles
- Flexbox in React Native (default is column, not row)
- `TouchableOpacity`, `Pressable` (preferred in 2026)
- `TextInput` with all props
- `Modal`, `ActivityIndicator`, `Alert`
- Platform-specific code: `Platform.OS`, `.ios.js` / `.android.js` files
- Dimensions API and `useWindowDimensions`

#### 🎯 Why It Matters

These are the building blocks. Every screen you'll ever build in React Native uses these components. RN Flexbox differs from web CSS Flexbox — the differences trip up everyone.

#### 🌍 Real-World Example

```javascript
// FlatList — the correct way to render lists (not ScrollView + map)
<FlatList
  data={products}
  keyExtractor={(item) => item.id.toString()}
  renderItem={({ item, index }) => <ProductCard product={item} index={index} />}
  ItemSeparatorComponent={() => <View style={styles.separator} />}
  ListEmptyComponent={<EmptyState message="No products found" />}
  ListHeaderComponent={<SearchBar />}
  onEndReached={loadMoreProducts}
  onEndReachedThreshold={0.5}
  refreshControl={
    <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
  }
/>
```

#### 🛠️ Mini Project

**"Product Catalog App"**

- [ ] `FlatList` with pull-to-refresh and infinite scroll
- [ ] Product card with `Pressable` (scale animation on press)
- [ ] Search bar with debounced filtering
- [ ] `Modal` for quick-view product details
- [ ] Platform-specific header (different style on iOS vs Android)

---

### B.3.2 Navigation with React Navigation `🔲 NOT STARTED`

#### 📌 What to Learn

- Stack Navigator
- Tab Navigator (Bottom Tabs)
- Drawer Navigator
- Nested navigators
- Passing params between screens
- Navigation lifecycle
- Deep linking configuration
- Expo Router (file-based) as an alternative

#### 🛠️ Mini Project

**"Full Navigation Structure"**

- [ ] Auth flow: Login → Register → ForgotPassword (Stack)
- [ ] Main app: Home | Search | Profile (Bottom Tabs)
- [ ] Home tab has its own Stack: Feed → PostDetail → UserProfile
- [ ] Deep link: `myapp://post/123` opens PostDetail directly

---

### B.3.3 State Management with Zustand + React Query `🔲 NOT STARTED`

#### 📌 What to Learn

- Zustand: create store, selectors, actions, middleware
- React Query (TanStack Query): `useQuery`, `useMutation`, `useInfiniteQuery`
- Cache invalidation in React Query
- Optimistic updates
- When to use Zustand (UI state) vs React Query (server state) — the key insight

#### 🎯 Why It Matters

This combination is the modern standard for React Native in 2026. React Query eliminates 80% of useEffect/useState patterns for server data. Zustand handles everything else.

#### 🌍 Real-World Example

```javascript
// Zustand store — for UI/app state only (no server data here)
const useAppStore = create((set) => ({
  theme: "light",
  cartItemCount: 0,
  setTheme: (theme) => set({ theme }),
  incrementCart: () =>
    set((state) => ({ cartItemCount: state.cartItemCount + 1 })),
}));

// React Query — for ALL server state
function useProducts(categoryId) {
  return useQuery({
    queryKey: ["products", categoryId], // cache key
    queryFn: () => api.getProducts(categoryId),
    staleTime: 5 * 60 * 1000, // consider fresh for 5 minutes
  });
}

function useAddToCart() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (product) => api.addToCart(product),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["cart"] }); // refresh cart
    },
    onMutate: async (product) => {
      // optimistic update
      await queryClient.cancelQueries({ queryKey: ["cart"] });
      const previous = queryClient.getQueryData(["cart"]);
      queryClient.setQueryData(["cart"], (old) => [...old, product]);
      return { previous };
    },
    onError: (err, product, context) => {
      queryClient.setQueryData(["cart"], context.previous); // rollback
    },
  });
}
```

#### 🛠️ Mini Project

**"E-Commerce App with Modern State"**

- [ ] `useProducts()` — React Query fetching product list with caching
- [ ] `useAddToCart()` mutation with optimistic update
- [ ] Zustand store for: cart count badge, active filter, selected theme
- [ ] Offline support: React Query persists to AsyncStorage
- [ ] Infinite scroll with `useInfiniteQuery`

---

### B.3.4 Performance Optimization `🔲 NOT STARTED`

#### 📌 What to Learn

- `React.memo` — prevent unnecessary re-renders
- `FlatList` optimization: `getItemLayout`, `windowSize`, `maxToRenderPerBatch`
- `InteractionManager` — defer expensive work until animations finish
- Hermes engine: what it is and why it matters
- Flipper + React DevTools Profiler
- Reanimated 3 vs Animated API — why Reanimated is faster
- Image caching with `react-native-fast-image`
- Bundle size analysis

#### 🛠️ Mini Project

**"Performance Audit & Fix"**
Take your product catalog app and:

- [ ] Identify re-renders using React DevTools Profiler
- [ ] Add `React.memo` to ProductCard — verify re-renders stop
- [ ] Add `getItemLayout` to FlatList — verify smoother scrolling
- [ ] Replace `Animated` with Reanimated 3 — measure frame rate improvement
- [ ] Replace `Image` with `FastImage` — measure load time improvement

---

### B.3.5 Native Modules & New Architecture `🔲 NOT STARTED`

#### 📌 What to Learn

- Old architecture: JS Bridge (why it's slow)
- New architecture: JSI (JavaScript Interface) — direct native calls
- TurboModules: lazy-loaded native modules
- Fabric: new rendering system
- Writing a simple TurboModule in Kotlin (Android)
- Expo Modules API (easier alternative)

#### 🛠️ Mini Project

**"Custom Biometric Auth Module"**

- [ ] Write a TurboModule that exposes `authenticate()` native biometric API
- [ ] Call it from JavaScript with JSI (no bridge)
- [ ] Use it in a login screen
- [ ] Compare latency vs old bridge approach using `performance.now()`

---

---

# 🐍 TRACK C — Python for AI `🔲 NOT STARTED`

> You're learning Python specifically to work with AI tools. Focus on practical, not academic.

---

## C.1 Python Basics `🔲 NOT STARTED`

### C.1.1 Variables, Types & Control Flow `🔲 NOT STARTED`

#### 📌 What to Learn

- Primitive types: `int`, `float`, `str`, `bool`, `None`
- Type hints (Python 3.10+): `def greet(name: str) -> str:`
- String formatting: f-strings
- `if/elif/else`, `for`, `while`, `break`, `continue`
- `try/except/finally`
- List comprehensions
- Dictionary comprehensions

#### 🎯 Why It Matters

Python is the language of AI. Every AI library (LangChain, Hugging Face, TensorFlow) is Python. You need enough Python to write AI scripts, FastAPI backends, and data processing pipelines.

#### 🌍 Real-World Analogy

Python is to AI what JavaScript is to the web. You don't need to be a Python expert — you need to be comfortable enough to read documentation, modify examples, and write your own scripts.

#### 🌍 Real-World Example

```python
# Type-annotated functions — used in all modern Python AI code
from typing import Optional

def build_prompt(user_query: str, context: Optional[str] = None) -> str:
    """Build a prompt for an LLM with optional context."""
    if context:
        return f"""You are a helpful assistant.
Context: {context}

User Question: {user_query}

Answer:"""
    return f"Answer this question clearly: {user_query}"

# List comprehension — transforming data for AI
def chunk_text(text: str, chunk_size: int = 500) -> list[str]:
    words = text.split()
    return [
        " ".join(words[i:i + chunk_size])
        for i in range(0, len(words), chunk_size)
    ]

# Dictionary comprehension — building request payloads
def build_headers(api_key: str, extras: dict = {}) -> dict[str, str]:
    base = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
    return {**base, **extras}
```

#### 🏋️ Mini Exercises

- [ ] Write a function that takes a list of strings and returns only those over 5 chars
- [ ] Use f-strings to format a user profile summary
- [ ] Write a list comprehension that extracts all email addresses from a list of dicts
- [ ] Write try/except handling for a `ValueError` and `KeyError` separately
- [ ] Write a dictionary comprehension inverting keys and values

#### 🛠️ Mini Project

**"AI Text Preprocessor"**

```python
# Build these functions:
def clean_text(text: str) -> str         # remove extra whitespace, special chars
def chunk_text(text, size=500) -> list   # split into overlapping chunks
def extract_keywords(text) -> list       # basic word frequency analysis
def summarize_stats(text) -> dict        # char count, word count, sentence count
```

#### ✅ Revision Checklist

- [ ] Can write Python functions with type hints
- [ ] Can use list and dict comprehensions confidently
- [ ] Can handle exceptions properly
- [ ] Can read any Python AI script and understand the control flow

---

### C.1.2 Functions, Classes & Modules `🔲 NOT STARTED`

#### 📌 What to Learn

- `*args` and `**kwargs`
- Decorators (`@property`, `@staticmethod`, writing custom ones)
- Dataclasses (`@dataclass`)
- Python classes for models and services
- `import` system: absolute vs relative imports
- Virtual environments: `pip install`, `requirements.txt`, `pyproject.toml`
- `__init__.py` and package structure

#### 🌍 Real-World Example

```python
from dataclasses import dataclass, field
from typing import Optional
import json

@dataclass
class ChatMessage:
    role: str                              # "user" | "assistant" | "system"
    content: str
    tokens: Optional[int] = None
    metadata: dict = field(default_factory=dict)

    def to_openai_format(self) -> dict:
        return {"role": self.role, "content": self.content}

@dataclass
class Conversation:
    messages: list[ChatMessage] = field(default_factory=list)
    max_tokens: int = 4000

    def add_message(self, role: str, content: str) -> None:
        self.messages.append(ChatMessage(role=role, content=content))

    def to_api_payload(self) -> list[dict]:
        return [msg.to_openai_format() for msg in self.messages]

    def token_count(self) -> int:
        return sum(msg.tokens or 0 for msg in self.messages)
```

#### 🛠️ Mini Project

**"Conversation Manager Class"**

- [ ] Build the `Conversation` dataclass above
- [ ] Add `trim_to_token_limit(limit)` that removes oldest messages
- [ ] Add `add_system_prompt(prompt)` that always prepends system message
- [ ] Add `save_to_file(path)` and `load_from_file(path)` using JSON
- [ ] Write a decorator `@log_calls` that prints function name and args when called

---

### C.1.3 Async Python `🔲 NOT STARTED`

#### 📌 What to Learn

- `async def` and `await`
- `asyncio.run()` — entry point for async programs
- `asyncio.gather()` — parallel async calls
- `httpx` — async HTTP client (replaces `requests` for AI work)
- When to use async (I/O bound tasks: API calls, file reads)

#### 🎯 Why It Matters

LLM API calls are slow (1–10 seconds). Running them in parallel with `asyncio.gather` can make your AI pipelines 5–10x faster. FastAPI is async. LangChain is async. This is non-negotiable.

#### 🌍 Real-World Example

```python
import asyncio
import httpx

async def call_llm(prompt: str, model: str = "gpt-4o") -> str:
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.openai.com/v1/chat/completions",
            headers={"Authorization": f"Bearer {api_key}"},
            json={"model": model, "messages": [{"role": "user", "content": prompt}]},
            timeout=30.0,
        )
        return response.json()["choices"][0]["message"]["content"]

# Run 3 LLM calls in parallel instead of sequentially
async def generate_article_sections(topic: str) -> dict:
    intro, body, conclusion = await asyncio.gather(
        call_llm(f"Write an intro paragraph about {topic}"),
        call_llm(f"Write the main body (3 paragraphs) about {topic}"),
        call_llm(f"Write a conclusion about {topic}"),
    )
    return {"intro": intro, "body": body, "conclusion": conclusion}

# Entry point
if __name__ == "__main__":
    result = asyncio.run(generate_article_sections("AI in mobile apps"))
```

#### 🛠️ Mini Project

**"Parallel LLM Pipeline"**

- [ ] Call 3 different LLM providers simultaneously: OpenAI, Gemini, Claude
- [ ] Compare responses — same prompt, different models
- [ ] Time sequential vs parallel — show speedup
- [ ] Add `asyncio.timeout(10)` to each call for safety

---

### C.1.4 NumPy & Pandas `🔲 NOT STARTED`

#### 📌 What to Learn

- **NumPy:** ndarray, array operations, broadcasting, dot product, reshape
- **Pandas:** DataFrame, Series, read_csv, filtering, groupby, merge, apply

#### 🎯 Why It Matters

Embeddings (the heart of RAG) are NumPy arrays. Similarity search is a dot product operation. Every ML tutorial uses NumPy. Pandas is used to process datasets for fine-tuning.

#### 🌍 Real-World Example

```python
import numpy as np

# Embeddings are NumPy arrays
embedding_a = np.array([0.1, 0.8, 0.3, 0.5])
embedding_b = np.array([0.2, 0.7, 0.4, 0.4])

# Cosine similarity — the heart of semantic search
def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

similarity = cosine_similarity(embedding_a, embedding_b)
print(f"Similarity: {similarity:.4f}")  # 0.9921 — very similar

# Finding most similar document from a collection
def find_most_similar(query_embedding, document_embeddings):
    similarities = np.array([
        cosine_similarity(query_embedding, doc_emb)
        for doc_emb in document_embeddings
    ])
    return np.argmax(similarities)  # index of most similar doc
```

#### 🛠️ Mini Project

**"Mini Semantic Search"**

- [ ] Create 10 "fake" embeddings (random NumPy arrays)
- [ ] Implement `cosine_similarity` from scratch
- [ ] Find the top-3 most similar to a query embedding
- [ ] Use Pandas to load a CSV of movie descriptions
- [ ] Basic analysis: average description length, most common words

---

---

# 🤖 TRACK D — AI Engineering `🔲 NOT STARTED`

---

## PHASE D1 — Machine Learning Basics `🔲 NOT STARTED`

---

### D.1.1 What is Machine Learning? `🔲 NOT STARTED`

#### 📌 What to Learn

- AI vs ML vs Deep Learning vs LLM — the hierarchy
- Supervised, unsupervised, and reinforcement learning
- Training, validation, and test splits
- Overfitting and underfitting
- The concept of a model: input → function → output
- Features vs labels

#### 🎯 Why It Matters

You don't need to train models from scratch. But you DO need to understand what a model IS, why it makes mistakes, and how to evaluate it. This is what separates someone who "calls AI APIs" from an AI Engineer.

#### 🌍 Real-World Analogy

Machine learning is teaching by example. Instead of writing rules ("if the email contains 'win a prize', it's spam"), you show the system 10,000 spam emails and 10,000 real emails and let it find the pattern itself. The "pattern" it learns is the model.

#### 🌍 Real-World Example

```python
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Supervised learning: spam detection
# X = features (word counts), y = labels (0=not spam, 1=spam)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LogisticRegression()
model.fit(X_train, y_train)  # TRAINING — model learns from examples

predictions = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, predictions):.2%}")
```

#### 🏋️ Mini Exercises

- [ ] Draw the AI → ML → Deep Learning → LLM hierarchy and explain each layer
- [ ] Give 3 real-world examples of supervised learning
- [ ] Give 3 real-world examples of unsupervised learning
- [ ] Explain overfitting using a real-world analogy (student memorizing answers vs understanding)

#### ✅ Revision Checklist

- [ ] Can explain supervised vs unsupervised learning to a non-technical person
- [ ] Can explain what "training a model" means in plain English
- [ ] Can explain why a model might fail in production despite high test accuracy

---

### D.1.2 Classification, Regression & Clustering `🔲 NOT STARTED`

#### 📌 What to Learn

- **Classification:** Predict a category (spam/not spam, churn/no churn, dog/cat)
- **Regression:** Predict a number (house price, user rating, next month's revenue)
- **Clustering:** Group similar items without labels (customer segments, topic grouping)
- Key algorithms (conceptual understanding): Logistic Regression, Decision Trees, K-Means
- Evaluation metrics: Accuracy, Precision, Recall, F1, RMSE

#### 🎯 Why It Matters

When you build an AI mobile app that classifies images, recommends products, or groups users into segments — you're applying these concepts. Understanding them helps you choose the right approach and explain your choices in interviews.

#### 🌍 Real-World Example

```python
# Classification: Is this app review positive or negative?
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB

reviews = ["Great app!", "Crashes constantly", "Love the design", "Terrible experience"]
labels = [1, 0, 1, 0]  # 1=positive, 0=negative

vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(reviews)

classifier = MultinomialNB()
classifier.fit(X, labels)

new_review = vectorizer.transform(["Amazing user interface"])
print(classifier.predict(new_review))  # [1] — predicted positive

# Clustering: Group users by behavior (without labels)
from sklearn.cluster import KMeans
import numpy as np

# User features: [sessions_per_week, avg_session_minutes, purchases]
user_data = np.array([[5, 30, 10], [1, 5, 0], [8, 45, 25], [2, 8, 1]])

kmeans = KMeans(n_clusters=2, random_state=42)
segments = kmeans.fit_predict(user_data)
# Output: [1, 0, 1, 0] — two clusters: power users and casual users
```

#### 🛠️ Mini Project

**"App Review Sentiment Classifier"**

- [ ] Collect 50 fake app reviews (25 positive, 25 negative)
- [ ] Build and train a classifier using sklearn
- [ ] Evaluate: accuracy, precision, recall on test set
- [ ] Predict the sentiment of 5 new reviews
- [ ] Visualize confusion matrix

---

## PHASE D2 — LLM Fundamentals `🔲 NOT STARTED`

---

### D.2.1 Tokens `🔲 NOT STARTED`

#### 📌 What to Learn

- What a token is (NOT a word — it's a word piece)
- How tokenization works (BPE, WordPiece)
- Token counts and their relationship to cost and speed
- Context window: what it is and why it matters
- Tools: Tiktokenizer (OpenAI tokenizer playground)

#### 🎯 Why It Matters

Token counts determine your API costs, response latency, and what fits in a context window. "My app's context window is full" is a real production problem. You must understand this.

#### 🌍 Real-World Analogy

Think of tokens like syllables, not words. "unhappy" is 1 word but 3 tokens: "un", "hap", "py". Common words like "the" are 1 token. Rare words split into many tokens. Code is expensive because variable names like `calculateTotalRevenue` split into many tokens.

#### 🌍 Real-World Example

```python
import tiktoken

# Count tokens BEFORE sending to API — control costs
encoding = tiktoken.encoding_for_model("gpt-4o")

def count_tokens(text: str) -> int:
    return len(encoding.encode(text))

def estimate_cost(prompt: str, response: str, model: str = "gpt-4o") -> float:
    COSTS = {
        "gpt-4o": {"input": 0.0025 / 1000, "output": 0.01 / 1000},
        "gpt-4o-mini": {"input": 0.00015 / 1000, "output": 0.0006 / 1000},
    }
    input_tokens = count_tokens(prompt)
    output_tokens = count_tokens(response)
    cost = (input_tokens * COSTS[model]["input"] +
            output_tokens * COSTS[model]["output"])
    return cost

# Real-world usage
prompt = "Summarize this document in 3 bullet points: ..."
print(f"Prompt tokens: {count_tokens(prompt)}")  # e.g., 847 tokens
print(f"Estimated cost: ${estimate_cost(prompt, ''):.6f}")
```

#### 🏋️ Mini Exercises

- [ ] Go to platform.openai.com/tokenizer — tokenize 10 different sentences
- [ ] Tokenize code vs plain text — notice the difference in token count
- [ ] Calculate the cost of sending 1000 users a 500-token prompt per day
- [ ] Find a way to reduce a 1000-token prompt to 600 tokens without losing meaning

#### ✅ Revision Checklist

- [ ] Can explain what a token is in 30 seconds
- [ ] Can estimate token count for a prompt without a tool
- [ ] Can explain context window limits and their practical implications
- [ ] Can calculate approximate API costs for a given usage scenario

---

### D.2.2 Embeddings `🔲 NOT STARTED`

#### 📌 What to Learn

- What embeddings are: turning text into vectors
- Why embeddings capture meaning (semantic similarity)
- Embedding models: `text-embedding-3-small`, `nomic-embed-text`
- Cosine similarity as a similarity metric
- When to use embeddings (semantic search, recommendations, clustering)

#### 🎯 Why It Matters

Embeddings are the foundation of RAG systems, semantic search, and recommendation engines — the three most common AI engineering tasks you'll encounter. Without understanding embeddings, you cannot build RAG.

#### 🌍 Real-World Analogy

Imagine every sentence as a point in a 1536-dimensional space. Sentences with similar meaning are close together. "I love pizza" and "Pizza is my favorite food" are neighbors. "The stock market crashed" is far away. Embeddings find semantic neighbors — not just keyword matches.

#### 🌍 Real-World Example

```python
from openai import OpenAI
import numpy as np

client = OpenAI()

def embed(text: str) -> list[float]:
    response = client.embeddings.create(
        model="text-embedding-3-small",
        input=text
    )
    return response.data[0].embedding

def cosine_similarity(a: list[float], b: list[float]) -> float:
    a, b = np.array(a), np.array(b)
    return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))

# Test semantic similarity
query = "How do I reset my password?"
docs = [
    "Click forgot password on the login screen",  # semantically similar ✅
    "Our pricing starts at $10/month",             # unrelated ❌
    "To recover your account, use the email link", # similar ✅
]

query_embedding = embed(query)
for doc in docs:
    doc_embedding = embed(doc)
    sim = cosine_similarity(query_embedding, doc_embedding)
    print(f"{sim:.3f} | {doc[:50]}")
# Output:
# 0.872 | Click forgot password on the login screen
# 0.213 | Our pricing starts at $10/month
# 0.841 | To recover your account, use the email link
```

#### 🏋️ Mini Exercises

- [ ] Embed 10 sentences and find the 3 most similar to a query
- [ ] Show that rephrasing a question gives a very similar embedding
- [ ] Show that changing the language (English → Hindi) changes the similarity score
- [ ] Visualize embeddings in 2D using PCA (sklearn)

#### 🛠️ Mini Project

**"Semantic FAQ Search"**

- [ ] Write 20 FAQ pairs (question + answer)
- [ ] Embed all questions and store in a Python dictionary
- [ ] Accept a user question → embed it → find top 3 similar FAQ questions
- [ ] Return the corresponding answers
- [ ] Compare semantic search vs keyword search (grep) — show where semantic wins

---

### D.2.3 Temperature, Top-P & Sampling Parameters `🔲 NOT STARTED`

#### 📌 What to Learn

- Temperature: 0 = deterministic, 1 = creative, 2 = chaotic
- Top-P (nucleus sampling): controls diversity differently from temperature
- `max_tokens`: output length limit
- `frequency_penalty` and `presence_penalty`
- `stop` sequences
- When to use what (code generation vs creative writing vs classification)

#### 🎯 Why It Matters

These parameters directly control output quality. Using temperature=1 for a code generator produces buggy code. Using temperature=0 for a creative writer produces boring output. Knowing when to use each is an AI engineering skill.

#### 🌍 Real-World Analogy

Temperature is like a creativity dial on a writer. At 0, they write the most predictable, by-the-book text. At 1, they take creative risks. At 2, they're incoherent. For a contract lawyer (code generation), you want 0. For a creative ad copywriter, you want 0.7–1.0.

#### 🌍 Real-World Example

```python
from openai import OpenAI

client = OpenAI()

# TASK: Code generation — use low temperature for deterministic output
def generate_code(spec: str) -> str:
    return client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": f"Write Python code for: {spec}"}],
        temperature=0.1,   # nearly deterministic — we want correct, not creative
        max_tokens=500,
    ).choices[0].message.content

# TASK: Marketing copy — use higher temperature for variety
def generate_tagline(product: str) -> str:
    return client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": f"Write a catchy tagline for: {product}"}],
        temperature=0.9,   # creative and varied
        max_tokens=50,
    ).choices[0].message.content

# TASK: Classification — use temperature=0 for consistency
def classify_sentiment(text: str) -> str:
    return client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{
            "role": "user",
            "content": f"Classify as POSITIVE, NEGATIVE, or NEUTRAL only: {text}"
        }],
        temperature=0,  # always the same classification for the same input
        max_tokens=1,
        stop=[".", "\n"],
    ).choices[0].message.content
```

#### 🏋️ Mini Exercises

- [ ] Call the same prompt with temperatures: 0, 0.3, 0.7, 1.0, 1.5 — compare outputs
- [ ] Find the right temperature for: 1) SQL generation, 2) poem writing, 3) JSON output
- [ ] Use `stop` sequences to ensure the model stops at a specific token
- [ ] Experiment with `frequency_penalty` to reduce repetition in long outputs

---

### D.2.4 Context Windows `🔲 NOT STARTED`

#### 📌 What to Learn

- What a context window is (total tokens model can see at once)
- Input vs output tokens
- Context window sizes: GPT-4o (128K), Gemini 1.5 Pro (1M), Claude (200K)
- "Lost in the middle" problem — models forget context in the middle of long windows
- Practical strategies: summarization, truncation, chunking

#### 🌍 Real-World Example

```python
class ConversationManager:
    """Manages conversation history within token limits."""

    def __init__(self, max_tokens: int = 100_000, model: str = "gpt-4o"):
        self.messages: list[dict] = []
        self.max_tokens = max_tokens
        self.model = model

    def add_message(self, role: str, content: str) -> None:
        self.messages.append({"role": role, "content": content})
        self._trim_if_needed()

    def _trim_if_needed(self) -> None:
        """Remove oldest non-system messages when approaching limit."""
        while self._count_tokens() > self.max_tokens * 0.9:
            # Keep system message (index 0), remove oldest user/assistant pair
            if len(self.messages) > 3:
                self.messages.pop(1)
                self.messages.pop(1)
            else:
                break

    def _count_tokens(self) -> int:
        return sum(count_tokens(msg["content"]) for msg in self.messages)
```

---

## PHASE D3 — Prompt Engineering `🔲 NOT STARTED`

---

### D.3.1 Zero-Shot Prompting `🔲 NOT STARTED`

#### 📌 What to Learn

- What zero-shot means: no examples, just instructions
- Persona prompting: "You are an expert..."
- Role + Task + Format structure
- Negative prompting: "Do NOT..."
- Chain-of-thought instruction: "Think step by step"

#### 🌍 Real-World Analogy

Zero-shot is like asking a new employee to do a task with just a description — no examples. The quality depends entirely on how clearly you write the job description.

#### 🌍 Real-World Example

```python
# Bad zero-shot prompt
bad_prompt = "Summarize this article"

# Good zero-shot prompt — role + task + constraints + format
good_prompt = """You are a senior technical writer creating summaries for mobile developers.

Summarize the following article about AI in mobile apps.

Requirements:
- Maximum 100 words
- Use simple language (assume the reader knows mobile dev but is new to AI)
- Start with the single most important takeaway
- Do NOT include any marketing language or hype
- End with one practical action the reader can take today

Article:
{article_text}

Summary:"""
```

#### 🏋️ Mini Exercises

- [ ] Rewrite these bad prompts as structured zero-shot prompts:
  - "Translate this" → add language, tone, audience
  - "Fix my code" → add language, error, what you expect
  - "Write a bio" → add length, tone, audience, key points
- [ ] Add "Think step by step" to a reasoning prompt — observe improvement

---

### D.3.2 Few-Shot Prompting `🔲 NOT STARTED`

#### 📌 What to Learn

- What few-shot means: providing 2–5 examples of input → output
- Why examples are more powerful than descriptions
- Choosing good examples (diverse, representative)
- One-shot vs few-shot vs many-shot

#### 🎯 Why It Matters

Few-shot prompting improves accuracy on classification, extraction, and formatting tasks by 20–40% compared to zero-shot. It's the easiest improvement available without fine-tuning.

#### 🌍 Real-World Example

```python
few_shot_prompt = """Extract the action item, person responsible, and deadline from meeting notes.
Output as JSON only.

Example 1:
Input: "John will review the API docs by Friday"
Output: {"action": "Review API docs", "person": "John", "deadline": "Friday"}

Example 2:
Input: "Sarah needs to update the mobile app screenshots before the demo"
Output: {"action": "Update mobile app screenshots", "person": "Sarah", "deadline": "before the demo"}

Example 3:
Input: "The team should complete the RAG integration by end of sprint"
Output: {"action": "Complete RAG integration", "person": "Team", "deadline": "end of sprint"}

Now extract from:
Input: "{meeting_note}"
Output:"""
```

#### 🛠️ Mini Project

**"Few-Shot Classifier"**

- [ ] Build a task priority classifier: LOW / MEDIUM / HIGH / URGENT
- [ ] Start with zero-shot — measure accuracy on 20 test cases
- [ ] Add 5 examples — re-measure accuracy
- [ ] Add 10 examples — re-measure accuracy
- [ ] Document the improvement percentage

---

### D.3.3 Structured Output `🔲 NOT STARTED`

#### 📌 What to Learn

- JSON mode in OpenAI API
- Pydantic models for structured output
- `response_format = {"type": "json_object"}`
- OpenAI structured outputs with schemas
- Handling and validating LLM JSON output

#### 🎯 Why It Matters

Mobile apps need structured data, not prose. If you ask an LLM to "analyze this review" and get back a paragraph, you can't display it in a structured UI. Structured outputs turn LLMs into structured data extractors.

#### 🌍 Real-World Example

```python
from openai import OpenAI
from pydantic import BaseModel
from typing import Literal

client = OpenAI()

class AppReviewAnalysis(BaseModel):
    sentiment: Literal["positive", "negative", "neutral"]
    rating_prediction: int  # 1-5
    main_issue: str | None
    feature_request: str | None
    urgency: Literal["low", "medium", "high", "critical"]
    suggested_response: str

def analyze_review(review_text: str) -> AppReviewAnalysis:
    response = client.beta.chat.completions.parse(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "You are an app review analyst. Analyze the review and return structured data."},
            {"role": "user", "content": review_text}
        ],
        response_format=AppReviewAnalysis,
    )
    return response.choices[0].message.parsed

# Usage
analysis = analyze_review("App crashes when I upload photos larger than 5MB. This is a dealbreaker.")
print(analysis.sentiment)      # "negative"
print(analysis.urgency)        # "critical"
print(analysis.main_issue)     # "App crashes on large photo upload"
```

#### 🛠️ Mini Project

**"App Review Intelligence Dashboard"**

- [ ] Analyze 20 app reviews from the Play Store
- [ ] Extract: sentiment, main issue, feature request, urgency for each
- [ ] Aggregate: count by sentiment, list top 5 issues
- [ ] Output: JSON report ready to display in a Flutter app

---

## PHASE D4 — AI APIs `🔲 NOT STARTED`

---

### D.4.1 OpenAI API `🔲 NOT STARTED`

#### 📌 What to Learn

- Chat completions with `messages` array
- System, user, and assistant roles
- Function calling (tool use)
- Streaming responses
- Image input (GPT-4o Vision)
- Audio transcription (Whisper)
- Embeddings endpoint
- Error handling: rate limits, quota errors, timeout

#### 🌍 Real-World Example

```python
from openai import OpenAI, APIError, RateLimitError
import time

client = OpenAI()

def chat_with_retry(messages: list, model: str = "gpt-4o-mini",
                    max_retries: int = 3) -> str:
    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model=model,
                messages=messages,
                temperature=0.7,
                max_tokens=1000,
            )
            return response.choices[0].message.content

        except RateLimitError:
            wait_time = 2 ** attempt  # exponential backoff: 1s, 2s, 4s
            print(f"Rate limited. Waiting {wait_time}s...")
            time.sleep(wait_time)

        except APIError as e:
            if e.status_code >= 500:
                time.sleep(1)  # server error, retry
            else:
                raise  # client error (400s), don't retry

    raise Exception(f"Failed after {max_retries} retries")

# Streaming to show text as it generates (critical for mobile UX)
def stream_response(prompt: str):
    with client.chat.completions.stream(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}],
    ) as stream:
        for chunk in stream:
            if chunk.choices[0].delta.content:
                print(chunk.choices[0].delta.content, end="", flush=True)
```

#### 🛠️ Mini Project

**"OpenAI-Powered Flutter App"**

- [ ] FastAPI backend with OpenAI streaming endpoint
- [ ] Flutter frontend that connects and shows streaming text character by character
- [ ] Error handling: rate limit banner, retry button
- [ ] Cost tracking: display token usage per conversation

---

### D.4.2 Google Gemini API `🔲 NOT STARTED`

#### 📌 What to Learn

- `google-generativeai` SDK
- Gemini models: `gemini-1.5-flash` (fast/cheap), `gemini-1.5-pro` (powerful), `gemini-2.0-flash`
- Multimodal: text + image + video + audio in one call
- Long context (1M tokens)
- Grounding with Google Search
- Streaming
- Safety settings

#### 🌍 Real-World Example

```python
import google.generativeai as genai
from pathlib import Path

genai.configure(api_key="YOUR_KEY")

model = genai.GenerativeModel("gemini-1.5-flash")

# Multimodal: analyze an image from a mobile camera
def analyze_app_screenshot(image_path: str) -> str:
    image_data = Path(image_path).read_bytes()
    image_part = {"mime_type": "image/png", "data": image_data}

    response = model.generate_content([
        image_part,
        "You are a UX reviewer. Identify 3 UX issues in this mobile app screenshot and suggest improvements."
    ])
    return response.text

# Multi-turn conversation (chat session with memory)
chat = model.start_chat(history=[])

def chat_with_memory(user_message: str) -> str:
    response = chat.send_message(user_message)
    return response.text  # chat object retains full history automatically
```

#### 🛠️ Mini Project

**"AI-Powered App Screenshot Reviewer"**

- [ ] Take screenshots of 5 real apps
- [ ] Use Gemini Vision to identify UX issues in each
- [ ] Generate: issue list, severity rating, fix suggestion
- [ ] Build a Flutter screen to take a screenshot and show the analysis

---

## PHASE D5 — RAG Systems `🔲 NOT STARTED`

---

### D.5.1 What is RAG and Why It Exists `🔲 NOT STARTED`

#### 📌 What to Learn

- The problem: LLMs have a knowledge cutoff and no access to your data
- The solution: Retrieval-Augmented Generation — fetch relevant context, inject into prompt
- RAG vs fine-tuning vs prompt stuffing
- The RAG pipeline: ingest → retrieve → augment → generate

#### 🌍 Real-World Analogy

RAG is like giving a smart consultant access to your company's internal documentation before they answer a question. Without RAG, the consultant answers from general knowledge (may be outdated/wrong). With RAG, they look up your specific docs first and answer with accurate, current information.

#### 🌍 Real-World Example — The RAG Pipeline

```python
# Step 1: INGEST — process documents into searchable chunks
def ingest_document(file_path: str, collection: str) -> None:
    text = extract_text(file_path)               # extract raw text
    chunks = semantic_chunk(text, size=500)       # split into chunks
    embeddings = [embed(chunk) for chunk in chunks]  # embed each chunk
    vector_db.upsert(collection, chunks, embeddings)  # store

# Step 2: RETRIEVE — find relevant chunks for a query
def retrieve(query: str, collection: str, top_k: int = 5) -> list[str]:
    query_embedding = embed(query)
    results = vector_db.query(collection, query_embedding, top_k=top_k)
    return [r.text for r in results]

# Step 3: AUGMENT + GENERATE — inject context into LLM prompt
def rag_query(user_question: str, collection: str) -> str:
    relevant_chunks = retrieve(user_question, collection)
    context = "\n\n---\n\n".join(relevant_chunks)

    prompt = f"""Answer the question using ONLY the provided context.
If the answer is not in the context, say "I don't have that information."

Context:
{context}

Question: {user_question}

Answer:"""

    return call_llm(prompt)
```

---

### D.5.2 Chunking Strategies `🔲 NOT STARTED`

#### 📌 What to Learn

- Fixed-size chunking (simple but loses context)
- Sentence-based chunking
- Semantic chunking (split by topic change)
- Overlapping chunks (adds redundancy for better retrieval)
- Parent-child chunking (small chunks for retrieval, large for context)

#### 🌍 Real-World Example

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

# Fixed-size with overlap — most reliable starting point
splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,       # target size in characters
    chunk_overlap=50,     # overlap to preserve context across chunks
    separators=["\n\n", "\n", ". ", " "],  # try these separators in order
)

chunks = splitter.split_text(document_text)

# Why overlap matters:
# Chunk 1: "...the API requires authentication using Bearer tokens."
# Chunk 2: "Bearer tokens expire after 24 hours and must be refreshed."
# Without overlap, a question about "token expiry after authentication" might miss this
```

#### 🛠️ Mini Project

**"Chunking Comparison"**

- [ ] Take a 5000-word technical document
- [ ] Chunk it 3 ways: fixed-size 200, fixed-size 500, semantic
- [ ] For each strategy: run 10 test questions → count how many are answered correctly
- [ ] Document: which strategy performed best and why

---

### D.5.3 Vector Databases `🔲 NOT STARTED`

#### 📌 What to Learn

- What a vector database is and why regular SQL can't do this
- Supabase + pgvector (best for beginners — SQL + vectors together)
- Pinecone (managed, serverless)
- HNSW index (Hierarchical Navigable Small World) — why it's fast
- Filtering: metadata + vector search combined

#### 🌍 Real-World Example

```python
# Supabase + pgvector — SQL and vector search in one place
from supabase import create_client

supabase = create_client(url, key)

# Store a document chunk with its embedding
def store_chunk(text: str, embedding: list[float], metadata: dict) -> None:
    supabase.table("documents").insert({
        "content": text,
        "embedding": embedding,
        "source": metadata.get("source"),
        "page": metadata.get("page"),
    }).execute()

# Semantic search
def search(query_embedding: list[float], match_count: int = 5) -> list[dict]:
    return supabase.rpc(
        "match_documents",
        {
            "query_embedding": query_embedding,
            "match_threshold": 0.78,   # minimum similarity score
            "match_count": match_count,
        }
    ).execute().data
```

#### 🛠️ Mini Project

**"Personal Knowledge Base RAG App"**
Full pipeline:

- [ ] Ingest: accept PDF uploads, chunk with overlap, embed, store in Supabase pgvector
- [ ] Retrieve: semantic search top-5 chunks for any query
- [ ] Generate: stream answer with source citations
- [ ] Flutter frontend: upload docs, ask questions, see highlighted sources
- [ ] Evaluate with RAGAS: 20 Q&A test pairs

---

## PHASE D6 — AI Agents `🔲 NOT STARTED`

---

### D.6.1 What is an AI Agent? `🔲 NOT STARTED`

#### 📌 What to Learn

- The definition: an LLM that can take actions in the world
- Tool use: giving an LLM functions it can call
- The ReAct loop: Reason → Act → Observe → Reason → ...
- Agent vs. chain vs. single LLM call
- When to use agents vs. simpler approaches

#### 🌍 Real-World Analogy

A regular LLM call is like asking someone a question and getting an answer. An AI agent is like hiring an employee — they can think, use tools (computer, phone, internet), take actions, observe results, and iterate until the task is done.

#### 🌍 Real-World Example

```python
from langchain.agents import create_react_agent, AgentExecutor
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI

# Define tools the agent can use
@tool
def search_web(query: str) -> str:
    """Search the web for current information about a topic."""
    return web_search(query)

@tool
def get_weather(city: str) -> str:
    """Get current weather for a city."""
    return weather_api.get(city)

@tool
def send_notification(message: str, user_id: str) -> str:
    """Send a push notification to a mobile user."""
    return push_service.send(user_id, message)

llm = ChatOpenAI(model="gpt-4o", temperature=0)
tools = [search_web, get_weather, send_notification]

agent = create_react_agent(llm, tools, prompt)
executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

# Agent reasons about which tools to use
result = executor.invoke({
    "input": "Check if it's raining in Mumbai and notify user_123 if it is"
})
# Agent calls: get_weather("Mumbai") → sees rain → send_notification(...)
```

---

### D.6.2 Function Calling `🔲 NOT STARTED`

#### 📌 What to Learn

- Defining tool schemas (name, description, parameters as JSON Schema)
- How the LLM decides which tool to call
- Handling tool results and feeding them back
- Parallel function calling
- Error handling when tools fail

#### 🌍 Real-World Example

```python
from openai import OpenAI

client = OpenAI()

tools = [
    {
        "type": "function",
        "function": {
            "name": "get_product_details",
            "description": "Get detailed information about a product by its ID",
            "parameters": {
                "type": "object",
                "properties": {
                    "product_id": {
                        "type": "string",
                        "description": "The unique product ID from the catalog"
                    },
                    "include_reviews": {
                        "type": "boolean",
                        "description": "Whether to include customer reviews",
                        "default": False
                    }
                },
                "required": ["product_id"]
            }
        }
    }
]

def run_agent_turn(messages: list, user_input: str) -> str:
    messages.append({"role": "user", "content": user_input})

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=messages,
        tools=tools,
        tool_choice="auto",
    )

    message = response.choices[0].message

    # LLM decided to call a tool
    if message.tool_calls:
        messages.append(message)
        for tool_call in message.tool_calls:
            result = execute_tool(tool_call.function.name,
                                  json.loads(tool_call.function.arguments))
            messages.append({
                "role": "tool",
                "tool_call_id": tool_call.id,
                "content": json.dumps(result)
            })
        # Continue with tool results
        return run_agent_turn(messages, "")

    return message.content
```

#### 🛠️ Mini Project

**"Shopping Assistant Agent"**

- [ ] Tools: `search_products`, `get_product_details`, `add_to_cart`, `get_cart_total`, `apply_coupon`
- [ ] Agent handles: "Find me a blue shirt under $50, add the best-rated one to cart"
- [ ] Stream agent's reasoning steps to Flutter UI
- [ ] Handle tool failures gracefully (out of stock, invalid coupon)

---

### D.6.3 LangGraph Basics `🔲 NOT STARTED`

#### 📌 What to Learn

- Why LangGraph exists: stateful, multi-step agent workflows
- Nodes: Python functions in the graph
- Edges: connections between nodes
- State: shared dictionary that flows through all nodes
- Conditional edges: routing based on state
- Human-in-the-loop: pausing for human approval

#### 🌍 Real-World Example

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict, Annotated
import operator

class AgentState(TypedDict):
    user_query: str
    retrieved_docs: list[str]
    draft_answer: str
    quality_score: float
    final_answer: str

def retrieve_node(state: AgentState) -> AgentState:
    """Retrieve relevant documents for the query."""
    docs = vector_db.search(state["user_query"])
    return {"retrieved_docs": docs}

def generate_node(state: AgentState) -> AgentState:
    """Generate an answer from retrieved docs."""
    answer = llm.generate(state["user_query"], state["retrieved_docs"])
    return {"draft_answer": answer}

def evaluate_node(state: AgentState) -> AgentState:
    """Score the answer quality."""
    score = evaluator.score(state["user_query"], state["draft_answer"])
    return {"quality_score": score}

def route_by_quality(state: AgentState) -> str:
    """Conditional routing: good enough? → END. Too low? → regenerate."""
    return END if state["quality_score"] > 0.8 else "generate"

# Build the graph
workflow = StateGraph(AgentState)
workflow.add_node("retrieve", retrieve_node)
workflow.add_node("generate", generate_node)
workflow.add_node("evaluate", evaluate_node)

workflow.set_entry_point("retrieve")
workflow.add_edge("retrieve", "generate")
workflow.add_edge("generate", "evaluate")
workflow.add_conditional_edges("evaluate", route_by_quality)

app = workflow.compile()
result = app.invoke({"user_query": "How do I set up Firebase in Flutter?"})
```

#### 🛠️ Mini Project (Capstone AI Project)

**"AI-Powered Code Reviewer Agent"**
Full LangGraph agent:

- [ ] Node 1: Parse the code (identify language, framework, patterns)
- [ ] Node 2: Check for common bugs (null checks, async issues, memory leaks)
- [ ] Node 3: Check style and best practices
- [ ] Node 4: Generate improvement suggestions
- [ ] Node 5: Score overall quality (0-100)
- [ ] Conditional: if score < 60, loop back to deeper analysis
- [ ] Flutter frontend: paste code → see agent steps streaming → get report
- [ ] GitHub integration: analyze a PR and post comments

---
