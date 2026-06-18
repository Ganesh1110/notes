# 📓 Learning Tracker — Top 1% Mobile + AI Engineer

> **Purpose:** This is NOT a roadmap. This is your daily execution guide, revision notebook, progress tracker, and interview prep system — all in one file.
> **Update this file every single day.** Even one checkbox ticked is a win.

---

## 🗂️ Table of Contents

1. [Legend & How to Use This File](#legend)
2. [Master Progress Dashboard](#dashboard)
3. [TRACK A — Flutter & Dart](#flutter)
   - Phase 1: Dart Fundamentals
   - Phase 2: Flutter UI & Widgets
   - Phase 3: State, APIs & Storage
   - Phase 4: Architecture, Testing & DevOps
4. [TRACK B — React Native](#reactnative)
5. [TRACK C — Python for AI](#python)
6. [TRACK D — AI Engineering](#ai)
   - Phase 1: ML Basics
   - Phase 2: LLM Fundamentals
   - Phase 3: Prompt Engineering
   - Phase 4: AI APIs
   - Phase 5: RAG Systems
   - Phase 6: AI Agents
7. [Weekly Review Log](#weekly)
8. [Monthly Review Log](#monthly)
9. [Project Portfolio Tracker](#portfolio)
10. [Interview Readiness Tracker](#interview)
11. [Mistakes & Lessons Journal](#mistakes)
12. [Resources & References](#resources)

---

## 📖 Legend & How to Use This File {#legend}

### Status Badges — Add to section headings as you progress

| Badge                | Meaning                                    |
| -------------------- | ------------------------------------------ |
| `🔲 NOT STARTED`     | Haven't touched this yet                   |
| `🟦 LEARNING`        | Actively studying — concepts not solid yet |
| `🟨 PRACTICING`      | Understand it, doing exercises to solidify |
| `🟧 BUILT PROJECT`   | Applied it in a real mini-project          |
| `🟩 REVISED`         | Revisited after a gap, still solid         |
| `✅ INTERVIEW READY` | Can explain, code, and teach this topic    |

### Checkbox Conventions

```
- [ ]  Not done
- [x]  Done
- [~]  Partially done / needs revisit  (use tilde manually)
```

### Daily Habit

Open this file every day. Before starting: scan your current topic. After finishing: tick boxes. Once a week: fill in the Weekly Review. Once a month: fill in the Monthly Review.

---

## 📊 Master Progress Dashboard {#dashboard}

> Update percentages manually by counting checked boxes.

| Track          | Phase                 | Status         | % Complete | Last Touched |
| -------------- | --------------------- | -------------- | ---------- | ------------ |
| Flutter        | Phase 1: Dart         | 🟦 LEARNING    | 0%         | —            |
| Flutter        | Phase 2: Widgets & UI | 🔲 NOT STARTED | 0%         | —            |
| Flutter        | Phase 3: State, APIs  | 🔲 NOT STARTED | 0%         | —            |
| Flutter        | Phase 4: Architecture | 🔲 NOT STARTED | 0%         | —            |
| React Native   | JS Fundamentals       | 🟦 LEARNING    | 0%         | —            |
| React Native   | RN Core               | 🔲 NOT STARTED | 0%         | —            |
| React Native   | Advanced RN           | 🔲 NOT STARTED | 0%         | —            |
| Python for AI  | Basics                | 🔲 NOT STARTED | 0%         | —            |
| AI Engineering | ML Basics             | 🔲 NOT STARTED | 0%         | —            |
| AI Engineering | LLM Fundamentals      | 🔲 NOT STARTED | 0%         | —            |
| AI Engineering | Prompt Engineering    | 🔲 NOT STARTED | 0%         | —            |
| AI Engineering | AI APIs               | 🔲 NOT STARTED | 0%         | —            |
| AI Engineering | RAG Systems           | 🔲 NOT STARTED | 0%         | —            |
| AI Engineering | AI Agents             | 🔲 NOT STARTED | 0%         | —            |

---

---

# 🐦 TRACK A — Flutter & Dart {#flutter}

---

## PHASE 1 — Dart Fundamentals `🟦 LEARNING`

> Master Dart before Flutter. Flutter is just Dart with a UI library on top.

---

### 1.1 Dart Variables & Data Types `🔲 NOT STARTED`

#### 📌 What to Learn

- `int`, `double`, `String`, `bool`, `dynamic`, `var`, `Object`
- `final` vs `const` — the most important distinction in Dart
- `late` keyword for deferred initialization
- Type inference

#### 🎯 Why It Matters

Every widget property, state value, and API response in Flutter is a Dart variable. Understanding types prevents runtime crashes and makes null safety work for you, not against you.

#### 🌍 Real-World Example

```dart
// A Flutter profile screen might hold:
final String userName = "Arjun";          // immutable, set at runtime
const int maxRetries = 3;                 // compile-time constant
late double userRating;                   // assigned after async fetch
var isLoggedIn = false;                   // type inferred as bool
dynamic apiResponse;                      // avoid unless truly needed
```

#### 🏋️ Mini Exercises

- [ ] Create variables for: name, age, height, isStudent, score
- [ ] Try to reassign a `final` variable — observe the error
- [ ] Try to reassign a `const` variable — observe the error
- [ ] Create a `late` String, print it before assigning — observe the LateInitializationError
- [ ] Use `var` for 5 variables and verify inferred types using the IDE tooltip

#### 🛠️ Mini Project

**"Personal Profile Card Data"**

- [ ] Create a Dart file (`profile.dart`) with 10 variables representing a user profile
- [ ] Mix `final`, `const`, `var`, and `late`
- [ ] Print all values to console in a formatted way
- [ ] Add a `const` map of user preferences

#### ⚠️ Common Mistakes

- [ ] I understand: `var` infers a type permanently — `var x = 5;` means x can never hold a String
- [ ] I understand: `dynamic` turns off type checking — use it only for truly unknown types
- [ ] I understand: `const` is compile-time, `final` is runtime — a `final` DateTime is fine, a `const` DateTime is not
- [ ] I understand: `late` defers initialization but crashes if you read before writing

#### ✅ Revision Checklist

- [ ] Can explain `final` vs `const` without looking at notes
- [ ] Can explain when to use `late`
- [ ] Can list all primitive types in Dart from memory
- [ ] Can explain why `dynamic` is dangerous

---

### 1.2 Functions `🔲 NOT STARTED`

#### 📌 What to Learn

- Named parameters vs positional parameters
- Required vs optional parameters (`{}` vs `[]`)
- Default parameter values
- Arrow functions (`=>`)
- Higher-order functions (functions as parameters)
- Anonymous functions / lambdas
- `typedef`

#### 🎯 Why It Matters

Flutter's entire widget system is built on functions. `onPressed`, `onChanged`, `builder` — these all accept functions. Understanding function signatures is essential for reading Flutter source code and writing callbacks.

#### 🌍 Real-World Example

```dart
// Named parameters — Flutter uses this everywhere
Widget buildButton({
  required String label,
  required VoidCallback onTap,
  Color color = Colors.blue,    // default value
}) {
  return ElevatedButton(onPressed: onTap, child: Text(label));
}

// Arrow function — common in Flutter build methods
String greet(String name) => "Hello, $name!";

// Higher-order function
List<int> doubleAll(List<int> nums) => nums.map((n) => n * 2).toList();
```

#### 🏋️ Mini Exercises

- [ ] Write a function with all positional parameters
- [ ] Rewrite it with all named parameters
- [ ] Add default values to two parameters
- [ ] Write a function that accepts another function as a parameter
- [ ] Convert 5 regular functions to arrow functions
- [ ] Write a function that returns a function (closure)

#### 🛠️ Mini Project

**"Calculator Functions"**

- [ ] Build a Dart calculator with functions: `add`, `subtract`, `multiply`, `divide`
- [ ] Each function uses named parameters: `calculate(a: 5, b: 3)`
- [ ] Add a `compute(operation, a, b)` function that accepts an operation function
- [ ] Call it: `compute(add, a: 10, b: 5)` — this is the higher-order pattern Flutter uses

#### ⚠️ Common Mistakes

- [ ] I understand: positional optional `[int? x]` and named optional `{int? x}` are different syntax
- [ ] I understand: `required` makes a named parameter mandatory
- [ ] I understand: you cannot mix required positional and named in Flutter — named is almost always preferred
- [ ] I understand: arrow functions only work for single expressions, not multi-line

#### ✅ Revision Checklist

- [ ] Can write named parameter function from memory
- [ ] Can explain `VoidCallback` and `Function(T)` typedefs
- [ ] Can use a function as a parameter
- [ ] Can explain the difference between `() {}` and `() =>`

---

### 1.3 Object-Oriented Programming in Dart `🔲 NOT STARTED`

#### 📌 What to Learn

- Classes, constructors, named constructors
- `this`, instance vs static members
- Inheritance (`extends`), Interfaces (`implements`), Mixins (`with`)
- Abstract classes
- Getters and setters
- Factory constructors
- `@override`
- The `==` operator and `hashCode`

#### 🎯 Why It Matters

Every Flutter widget is a class. Every model (User, Product, Post) is a class. Clean Architecture depends entirely on abstract classes and interfaces. Without solid OOP, you cannot write maintainable Flutter code.

#### 🌍 Real-World Example

```dart
// Abstract class = interface contract
abstract class Repository {
  Future<List<User>> getUsers();
  Future<void> saveUser(User user);
}

// Concrete implementation
class UserRepositoryImpl extends Repository {
  @override
  Future<List<User>> getUsers() async => await api.fetchUsers();

  @override
  Future<void> saveUser(User user) async => await db.insert(user);
}

// Mixin — add capabilities without inheritance
mixin Loggable {
  void log(String message) => print("[LOG] $message");
}

class AuthService with Loggable {
  void login() {
    log("User logged in");  // from mixin
  }
}

// Factory constructor — common pattern for JSON
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], age: json['age']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}
```

#### 🏋️ Mini Exercises

- [ ] Create an `Animal` class with name, sound, and a `speak()` method
- [ ] Create `Dog` and `Cat` that extend `Animal` and override `speak()`
- [ ] Create an abstract class `Shape` with abstract method `area()`
- [ ] Implement `Circle` and `Rectangle` from `Shape`
- [ ] Create a `User` class with a factory constructor from JSON
- [ ] Create a mixin `Timestamped` that adds `createdAt` and `updatedAt`
- [ ] Apply the mixin to `User` and `Post` classes

#### 🛠️ Mini Project

**"Social Post Model Layer"**

- [ ] Create `User` class with factory constructor + toJson
- [ ] Create `Post` class (has a User author)
- [ ] Create `Comment` class (has a User author, belongs to a Post)
- [ ] Create abstract `Repository<T>` with generic CRUD methods
- [ ] Create `PostRepository` implementing the abstract class
- [ ] Apply `Loggable` mixin to the repository

#### ⚠️ Common Mistakes

- [ ] I understand: `implements` requires implementing ALL methods; `extends` inherits them
- [ ] I understand: Dart has no true interfaces — any class can be used as one
- [ ] I understand: mixins cannot have constructors
- [ ] I understand: factory constructors don't always create new instances — they can return cached ones
- [ ] I understand: `==` must always be overridden with `hashCode` together

#### ✅ Revision Checklist

- [ ] Can explain extends vs implements vs with from memory
- [ ] Can write a factory constructor for JSON parsing without notes
- [ ] Can create an abstract repository class and implementation
- [ ] Can explain why mixins are useful in Flutter (think: TickerProviderStateMixin)

---

### 1.4 Collections — List, Map, Set `🔲 NOT STARTED`

#### 📌 What to Learn

- List: creation, CRUD, sorting, filtering
- Map: creation, access, null-safe access (`[]?`), iteration
- Set: uniqueness, intersection, difference
- Spread operator (`...`)
- Collection if / collection for
- `where`, `map`, `reduce`, `fold`, `any`, `every`, `firstWhere`

#### 🎯 Why It Matters

API responses return JSON arrays and objects — these become List and Map. State management stores data in Lists. Almost every widget that displays multiple items (ListView, GridView) takes a List.

#### 🌍 Real-World Example

```dart
// Collection if / for — Flutter uses these inside widget trees
final tabs = [
  if (isAdmin) const AdminTab(),
  const HomeTab(),
  const ProfileTab(),
  for (final category in categories) CategoryTab(category),
];

// Filtering a product list from an API response
final cheapProducts = products
    .where((p) => p.price < 100)
    .where((p) => p.inStock)
    .map((p) => ProductCard(product: p))
    .toList();

// Map iteration
final headers = {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
};
headers.forEach((key, value) => print("$key: $value"));
```

#### 🏋️ Mini Exercises

- [ ] Create a list of 10 integers, sort ascending and descending
- [ ] Filter a list to only even numbers using `where`
- [ ] Transform a list of names to uppercase using `map`
- [ ] Find the first item matching a condition with `firstWhere`
- [ ] Create a Map of student names to grades, add/update/delete entries
- [ ] Create two Sets, find their intersection and union
- [ ] Use spread operator to merge two lists
- [ ] Use `collection if` to conditionally add to a list

#### 🛠️ Mini Project

**"Student Grade Manager"**

- [ ] List of 10 `Student` objects (name, grade, subject)
- [ ] Filter: only students with grade > 70
- [ ] Sort: by grade descending
- [ ] Group by subject using `fold` into a `Map<String, List<Student>>`
- [ ] Print formatted summary using `forEach`

#### ⚠️ Common Mistakes

- [ ] I understand: `list[index]` throws RangeError if empty; use `elementAtOrNull` or check length first
- [ ] I understand: `map()` returns an `Iterable`, not a `List` — you often need `.toList()`
- [ ] I understand: modifying a list while iterating it throws a concurrent modification error
- [ ] I understand: `const []` creates an unmodifiable list — cannot call `.add()`

#### ✅ Revision Checklist

- [ ] Can use `where`, `map`, `fold`, `reduce` without docs
- [ ] Can explain the difference between List and Set
- [ ] Can use collection if/for in a widget tree
- [ ] Can parse a JSON array into `List<MyModel>` from memory

---

### 1.5 Null Safety `🔲 NOT STARTED`

#### 📌 What to Learn

- Nullable vs non-nullable types (`String` vs `String?`)
- Null assertion operator (`!`)
- Null-aware operators: `?.`, `??`, `??=`
- Late variables
- The `required` keyword in null safety context
- Null safety in generics

#### 🎯 Why It Matters

Null safety is Dart's most important feature. It eliminates an entire class of runtime crashes. Flutter's entire API is built around it. If you don't understand null safety, you'll spend hours debugging `Null check operator used on a null value`.

#### 🌍 Real-World Example

```dart
class UserProfile {
  final String name;           // NEVER null
  final String? bio;           // CAN be null — user might not have set it
  final String? avatarUrl;

  UserProfile({required this.name, this.bio, this.avatarUrl});
}

// Safe navigation — the ?. chain
final bioLength = user.bio?.length;           // null if bio is null, int if not
final displayBio = user.bio ?? "No bio yet";  // fallback value
user.bio ??= "Default bio";                   // assign only if currently null

// Assertion — use only when YOU KNOW it's not null
final url = user.avatarUrl!;  // crashes if avatarUrl is null — use carefully!

// Pattern in Flutter UI
Text(user.bio ?? "No bio provided"),
Image.network(user.avatarUrl ?? defaultAvatarUrl),
```

#### 🏋️ Mini Exercises

- [ ] Create a nullable String, access its length safely using `?.`
- [ ] Use `??` to provide a fallback for 5 nullable values
- [ ] Try using `!` on a null value — observe the crash
- [ ] Create a function that accepts a nullable parameter and handles both cases
- [ ] Write a null-safe `fromJson` factory for a model with optional fields

#### 🛠️ Mini Project

**"Null-Safe API Response Model"**

- [ ] Create a `BlogPost` model: `id` (required), `title` (required), `subtitle` (optional), `imageUrl` (optional), `author` (optional)
- [ ] Write `fromJson` using null-safe access for optional fields
- [ ] Write `toJson` that omits null fields
- [ ] Write a `displayTitle` getter that returns title or "Untitled"

#### ⚠️ Common Mistakes

- [ ] I understand: `!` is a promise to the compiler — breaking that promise crashes the app
- [ ] I understand: `late` defers initialization but doesn't make something nullable
- [ ] I understand: `?.` returns null for the WHOLE expression if any part is null — chain carefully
- [ ] I understand: `required` in named parameters prevents null — different from nullable

#### ✅ Revision Checklist

- [ ] Can explain the four null-aware operators without notes
- [ ] Can write a null-safe model class with optional fields
- [ ] Can explain when to use `late` vs `?`
- [ ] Can read a nullable chain `a?.b?.c?.d` and explain what happens when b is null

---

### 1.6 Async / Await & Futures `🔲 NOT STARTED`

#### 📌 What to Learn

- What is asynchronous programming and why it matters on mobile
- `Future<T>` — a value that arrives in the future
- `async` / `await` syntax
- `FutureBuilder` widget
- Error handling with `try / catch / finally`
- `Stream<T>` and `StreamBuilder`
- `async*` and `yield` for creating streams
- `Future.wait` for parallel execution

#### 🎯 Why It Matters

Every network call, database operation, file read, and GPS request in Flutter is asynchronous. If you block the main thread, the UI freezes. This is the most critical concept for building responsive apps.

#### 🌍 Real-World Example

```dart
// Fetching user data from an API
Future<User> fetchUser(String id) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Server returned ${response.statusCode}');
  } catch (e) {
    throw UserFetchException('Failed to fetch user: $e');
  }
}

// Running two API calls in parallel (2x faster than sequential)
Future<void> loadDashboard() async {
  final results = await Future.wait([
    fetchUser(userId),
    fetchNotifications(userId),
  ]);
}

// Streaming real-time updates (e.g., chat messages)
Stream<List<Message>> messagesStream(String chatId) async* {
  while (true) {
    yield await fetchMessages(chatId);
    await Future.delayed(Duration(seconds: 5));
  }
}
```

#### 🏋️ Mini Exercises

- [ ] Write an async function that simulates an API call with `Future.delayed`
- [ ] Chain 3 async calls: fetch user → fetch their posts → fetch comments on first post
- [ ] Implement proper try/catch/finally on an async function
- [ ] Use `Future.wait` to run 3 calls in parallel and measure time difference
- [ ] Create a `Stream` that emits a number every second for 10 seconds
- [ ] Use `StreamBuilder` in Flutter to display the stream values

#### 🛠️ Mini Project

**"Async User Dashboard" (Flutter)**

- [ ] `FutureBuilder` to fetch and display user profile
- [ ] Show loading spinner while fetching
- [ ] Show error widget on failure with retry button
- [ ] `StreamBuilder` for a "live" notification counter that updates every 5 seconds
- [ ] `Future.wait` to load profile + stats in parallel

#### ⚠️ Common Mistakes

- [ ] I understand: forgetting `await` gives you a `Future<T>`, not `T` — a very common bug
- [ ] I understand: `async` functions always return `Future` — even `async void`
- [ ] I understand: don't call async functions in `initState` — use a helper method
- [ ] I understand: `Future.delayed` doesn't block the UI thread — it schedules work
- [ ] I understand: streams stay open until cancelled — always cancel StreamSubscriptions in dispose()

#### ✅ Revision Checklist

- [ ] Can explain the event loop and why async doesn't block the UI
- [ ] Can write async/await with proper error handling from memory
- [ ] Can use `FutureBuilder` with loading/error/data states
- [ ] Can explain `Future.wait` and when to use it
- [ ] Can create a simple `Stream` and consume it with `StreamBuilder`

---

## PHASE 2 — Flutter Widgets & UI `🔲 NOT STARTED`

---

### 2.1 Widget Fundamentals `🔲 NOT STARTED`

#### 📌 What to Learn

- `StatelessWidget` vs `StatefulWidget` — when to use each
- The widget tree, element tree, and render tree
- `BuildContext` — what it is and why it matters
- `setState()` — triggering UI updates
- Widget lifecycle: `initState`, `didChangeDependencies`, `build`, `dispose`
- `const` constructor optimization
- `Key` types: ValueKey, GlobalKey, ObjectKey

#### 🎯 Why It Matters

Knowing when to use StatelessWidget vs StatefulWidget is the first question in every Flutter interview. The widget/element/render tree distinction explains every performance issue you'll encounter.

#### 🌍 Real-World Example

```dart
// StatelessWidget — pure function of its inputs
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}

// StatefulWidget — has mutable internal state
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _liked = false;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_liked ? Icons.favorite : Icons.favorite_border),
      color: _liked ? Colors.red : Colors.grey,
      onPressed: () => setState(() {
        _liked = !_liked;
        _count += _liked ? 1 : -1;
      }),
    );
  }
}
```

#### 🏋️ Mini Exercises

- [ ] Build 5 StatelessWidgets (badge, avatar, tag chip, rating stars, price label)
- [ ] Build a counter with StatefulWidget — add increment, decrement, reset
- [ ] Add lifecycle print statements to a StatefulWidget — observe the order
- [ ] Add `const` to every possible widget in a screen — observe the yellow highlights disappear in DevTools
- [ ] Use a `GlobalKey` to access a widget's state from outside

#### 🛠️ Mini Project

**"Reusable Component Library"**
Build these 5 components as StatelessWidgets:

- [ ] `AppButton` — customizable label, color, loading state
- [ ] `UserChip` — avatar + name + optional badge
- [ ] `StatCard` — icon + title + value (for dashboards)
- [ ] `EmptyState` — illustration + message + CTA button
- [ ] `ErrorBanner` — icon + message + retry callback

#### ⚠️ Common Mistakes

- [ ] I understand: `BuildContext` can become stale — don't store it across async gaps without checking `mounted`
- [ ] I understand: never call `setState()` after `dispose()` — always check `if (mounted)`
- [ ] I understand: `const` widgets are never rebuilt — they're reused from cache
- [ ] I understand: `StatefulWidget` itself is immutable — the `State` holds the mutable data

#### ✅ Revision Checklist

- [ ] Can draw the three-tree Flutter architecture from memory
- [ ] Can explain every lifecycle method of a StatefulWidget
- [ ] Can decide StatelessWidget vs StatefulWidget in 10 seconds for any scenario
- [ ] Can explain what GlobalKey does and when it's needed

---

### 2.2 Layouts `🔲 NOT STARTED`

#### 📌 What to Learn

- `Column`, `Row`, `Stack` — the three layout primitives
- `Expanded`, `Flexible`, `Spacer`
- `Padding`, `Margin`, `SizedBox`, `Container`
- `Align`, `Center`, `Positioned`
- `ListView`, `GridView`, `SingleChildScrollView`
- `Wrap`, `Flow` for dynamic layouts
- `LayoutBuilder` for responsive design
- `MediaQuery` for screen dimensions

#### 🎯 Why It Matters

UI layout is 60% of a Flutter developer's job. Layout bugs are the most visible bugs. Mastering the layout system means you can implement any design a designer hands you.

#### 🌍 Real-World Example

```dart
// A real product card layout
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image fills available width, fixed height
          SizedBox(
            height: 180,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(product.price, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),     // pushes rating to the right
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text("${product.rating}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

#### 🏋️ Mini Exercises

- [ ] Build a Row with 3 items — make the middle one take all remaining space with `Expanded`
- [ ] Build a Column with items at top, middle, and bottom using `Spacer`
- [ ] Build a Stack with an image, a gradient overlay, and text on top
- [ ] Build a responsive 2-column grid using `GridView.builder`
- [ ] Use `LayoutBuilder` to switch between 1-column (phone) and 2-column (tablet) layout
- [ ] Build a horizontal scrolling list with `ListView.builder` and `scrollDirection: Axis.horizontal`

#### 🛠️ Mini Project

**"Social Feed Screen"**

- [ ] AppBar with avatar + search icon
- [ ] Horizontal `ListView` of story circles at the top
- [ ] Vertical `ListView.builder` of post cards
- [ ] Each post card: `Stack` with image + gradient + author info
- [ ] Each post card: Row with like, comment, share buttons + Spacer + bookmark

#### ⚠️ Common Mistakes

- [ ] I understand: `Column` inside `SingleChildScrollView` doesn't need a height, but `Column` inside `ListView` does
- [ ] I understand: nested `Column`/`Row` with `Expanded` children causes RenderFlex overflow — use `Flexible` instead
- [ ] I understand: `Container` with no child has zero size unless given explicit dimensions
- [ ] I understand: `ListView` inside `Column` requires a fixed height or `Expanded` wrapper

#### ✅ Revision Checklist

- [ ] Can implement any Figma layout using Column/Row/Stack without trial-and-error
- [ ] Can explain Expanded vs Flexible vs Spacer
- [ ] Can build a responsive layout with LayoutBuilder
- [ ] Can debug RenderFlex overflow errors immediately

---

### 2.3 Navigation `🔲 NOT STARTED`

#### 📌 What to Learn

- `Navigator.push` and `Navigator.pop` (imperative)
- Named routes with `MaterialApp.routes`
- `go_router` package (declarative — industry standard)
- Passing data between screens
- Returning data from screens
- Deep linking
- Bottom tab navigation
- Nested navigation

#### 🎯 Why It Matters

Every real app has multiple screens. `go_router` is the modern standard used in production Flutter apps. Deep linking is required for AI apps that open to specific content from notifications.

#### 🌍 Real-World Example

```dart
// go_router setup — used in production apps
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return ProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/post/:postId',
      builder: (context, state) => PostDetailScreen(
        postId: state.pathParameters['postId']!,
        // Extra data passed along
        post: state.extra as Post?,
      ),
    ),
  ],
);

// Navigate with extra data
context.push('/post/123', extra: myPostObject);

// Navigate and replace current route (no back button)
context.go('/home');
```

#### 🏋️ Mini Exercises

- [ ] Build a 3-screen app with imperative navigation (push/pop)
- [ ] Pass a user object from screen 1 to screen 2
- [ ] Return a value from screen 2 back to screen 1 using `pop(result)`
- [ ] Migrate the same app to `go_router`
- [ ] Add a bottom navigation bar with 3 tabs using `go_router` with `ShellRoute`
- [ ] Implement deep link: opening `/post/123` directly

#### 🛠️ Mini Project

**"Multi-Screen Notes App"**

- [ ] `HomeScreen` — list of notes with FAB
- [ ] `CreateNoteScreen` — form, saves on submit, returns note to HomeScreen
- [ ] `NoteDetailScreen` — shows full note, edit/delete buttons
- [ ] Bottom tab: Notes | Search | Settings
- [ ] Deep link support: `myapp://note/123` opens NoteDetailScreen directly
- [ ] All navigation with `go_router`

#### ⚠️ Common Mistakes

- [ ] I understand: `context.go()` replaces the stack; `context.push()` adds to it — wrong choice breaks the back button
- [ ] I understand: passing complex objects via route params requires using `extra` — not URL params
- [ ] I understand: named routes are outdated — prefer `go_router` for new projects
- [ ] I understand: nested `Navigator` widgets can cause back button issues — use `ShellRoute` in go_router instead

#### ✅ Revision Checklist

- [ ] Can set up go_router with 5+ routes from memory
- [ ] Can implement nested tab navigation with ShellRoute
- [ ] Can pass and receive data between screens both ways
- [ ] Can explain deep linking and implement a basic example

---

### 2.4 Forms & Input Handling `🔲 NOT STARTED`

#### 📌 What to Learn

- `TextFormField` and `TextField`
- `Form` widget and `GlobalKey<FormState>`
- Validation: `validator` function
- `TextEditingController`
- `FocusNode` and keyboard management
- Input formatters
- `Checkbox`, `Radio`, `Switch`, `Slider`, `DropdownButton`
- Form state: validate, save, reset

#### 🎯 Why It Matters

Every app has login, registration, settings, and data entry screens. A broken form is an app killer. Validation, focus management, and accessibility are expected in production.

#### 🌍 Real-World Example

```dart
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();     // CRITICAL — prevents memory leak
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      // proceed with login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,  // shows "next" on keyboard
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!value.contains('@')) return 'Enter a valid email';
              return null;  // null = valid
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) => (value?.length ?? 0) < 8
                ? 'Password must be at least 8 characters' : null,
          ),
          ElevatedButton(onPressed: _submit, child: const Text('Login')),
        ],
      ),
    );
  }
}
```

#### 🏋️ Mini Exercises

- [ ] Build a login form with email + password validation
- [ ] Add "confirm password" field — validate both match
- [ ] Add a registration form with 6 fields, all validated
- [ ] Implement `FocusNode` to auto-advance focus between fields on "next"
- [ ] Build a settings screen with Switch, Slider, Dropdown, and Radio buttons

#### 🛠️ Mini Project

**"Full Registration + Profile Setup Flow"**

- [ ] Screen 1: Email + password + confirm password
- [ ] Screen 2: Name + bio + avatar (image picker)
- [ ] Screen 3: Preferences (notifications: Switch, theme: Radio, text size: Slider)
- [ ] Final: Summary screen showing all entered data
- [ ] All fields validated, proper keyboard types, focus management

#### ⚠️ Common Mistakes

- [ ] I understand: always `dispose()` TextEditingController — memory leak if not
- [ ] I understand: `validator` returns a String (error message) or null (valid) — never bool
- [ ] I understand: `formKey.currentState?.validate()` runs ALL validators simultaneously
- [ ] I understand: `TextInputAction.done` doesn't auto-submit — you need `onFieldSubmitted`

#### ✅ Revision Checklist

- [ ] Can build a multi-field form with full validation from memory
- [ ] Can explain the GlobalKey<FormState> pattern
- [ ] Can implement password visibility toggle
- [ ] Can handle keyboard actions properly (next, done, submit)

---

### 2.5 State Management with Riverpod `🔲 NOT STARTED`

#### 📌 What to Learn

- Why setState isn't enough for real apps
- Provider vs Riverpod (why Riverpod wins)
- `Provider`, `StateProvider`, `FutureProvider`, `StreamProvider`
- `NotifierProvider` and `AsyncNotifierProvider`
- `ConsumerWidget` and `ConsumerStatefulWidget`
- `ref.watch` vs `ref.read` vs `ref.listen`
- Provider families (parameterized providers)
- Auto-dispose
- Provider overrides for testing

#### 🎯 Why It Matters

Riverpod is the state management solution used in most serious Flutter projects in 2026. It replaces setState for anything beyond trivial UI state. Every senior Flutter interview asks about state management.

#### 🌍 Real-World Example

```dart
// auth_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // Auto-runs on first watch; re-runs on invalidate
    return await ref.watch(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(email, password),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.invalidateSelf();  // triggers rebuild → back to null user
  }
}

// In a widget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) => user != null ? MainApp(user) : const LoginScreen(),
      loading: () => const SplashScreen(),
      error: (e, _) => ErrorScreen(error: e),
    );
  }
}
```

#### 🏋️ Mini Exercises

- [ ] Create a `StateProvider<int>` for a counter — increment/decrement from two different widgets
- [ ] Create a `FutureProvider` that fetches a random joke from an API — consume in a widget
- [ ] Create a `NotifierProvider` for a todo list — add, remove, toggle done
- [ ] Use `.family` to create a provider parameterized by user ID
- [ ] Use `ref.listen` to show a SnackBar when auth state changes
- [ ] Test a provider by overriding it with a mock in `ProviderScope`

#### 🛠️ Mini Project

**"Riverpod Shopping Cart"**

- [ ] `productListProvider` — FutureProvider fetching products from API
- [ ] `cartProvider` — NotifierProvider with add/remove/clear methods
- [ ] `cartTotalProvider` — computed provider that derives total from cart
- [ ] `searchQueryProvider` — StateProvider for search input
- [ ] `filteredProductsProvider` — derived from productList + searchQuery
- [ ] ProductListScreen, CartScreen, and CartBadge sharing state seamlessly

#### ⚠️ Common Mistakes

- [ ] I understand: `ref.read` inside `build()` won't trigger rebuilds — use `ref.watch` in build
- [ ] I understand: `ref.watch` outside `build()` (e.g., in a button callback) throws — use `ref.read`
- [ ] I understand: `autoDispose` providers are destroyed when last listener detaches — great for pagination
- [ ] I understand: `AsyncValue.guard` wraps Future errors into AsyncError automatically

#### ✅ Revision Checklist

- [ ] Can explain the difference between watch/read/listen without notes
- [ ] Can implement a full CRUD flow with NotifierProvider
- [ ] Can derive a computed provider from two other providers
- [ ] Can use .family for parameterized providers
- [ ] Can override a provider in tests

---

## PHASE 3 — APIs, Storage & Firebase `🔲 NOT STARTED`

---

### 3.1 REST API Integration with Dio `🔲 NOT STARTED`

#### 📌 What to Learn

- `http` package vs `Dio` — why Dio is better for real apps
- GET, POST, PUT, DELETE requests
- Request/response interceptors
- Retry logic
- Authentication headers (Bearer tokens)
- Error handling (`DioException`)
- `FormData` for file uploads
- Response parsing with `fromJson`

#### 🎯 Why It Matters

Every real-world app fetches data from a server. Interceptors are how you add auth tokens to every request without repeating yourself. Retry logic is what makes your app resilient to network hiccups.

#### 🌍 Real-World Example

```dart
class ApiClient {
  late final Dio _dio;

  ApiClient(String baseUrl, TokenStorage tokenStorage) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ));

    // Auth interceptor — adds token to every request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired — refresh and retry
          await tokenStorage.refreshToken();
          return handler.resolve(await _retry(error.requestOptions));
        }
        handler.next(error);
      },
    ));
  }

  Future<List<Post>> getPosts() async {
    final response = await _dio.get('/posts');
    return (response.data as List).map((e) => Post.fromJson(e)).toList();
  }
}
```

#### 🛠️ Mini Project

**"News Feed App with Full API Layer"**

- [ ] `NewsApiClient` with Dio + auth interceptor
- [ ] GET `/articles` → `List<Article>`
- [ ] GET `/articles/:id` → `Article`
- [ ] POST `/articles` with image upload via FormData
- [ ] Retry interceptor (3 retries on network error)
- [ ] Display in Flutter with pull-to-refresh and pagination

---

### 3.2 Local Storage `🔲 NOT STARTED`

#### 📌 What to Learn

- `SharedPreferences` — simple key-value (user settings)
- `Hive` — fast NoSQL (caching, simple models)
- `Drift` (SQLite) — relational data with queries
- `flutter_secure_storage` — encrypted storage (tokens, secrets)
- When to use each

#### 🎯 Why It Matters

Offline-first is a top requirement for international remote jobs. Users expect apps to work on poor connections. Tokens must NEVER be in SharedPreferences — security knowledge differentiates seniors.

#### 🌍 Real-World Example

```dart
// Never do this — insecure
await prefs.setString('auth_token', token);   // ❌ readable by root

// Always do this — encrypted
await secureStorage.write(key: 'auth_token', value: token);  // ✅

// Drift (SQLite) for complex data
@DriftDatabase(tables: [Posts, Users])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;

  Future<List<Post>> getPostsByUser(int userId) =>
      (select(posts)..where((p) => p.userId.equals(userId))).get();
}
```

#### 🛠️ Mini Project

**"Offline-First Articles App"**

- [ ] Fetch articles from API, store in Drift
- [ ] Load from Drift if offline (no network request)
- [ ] Store user preferences in SharedPreferences (theme, language)
- [ ] Store auth token in flutter_secure_storage
- [ ] Show "offline mode" banner when using cached data

---

### 3.3 Firebase Integration `🔲 NOT STARTED`

#### 📌 What to Learn

- `firebase_core` setup (iOS + Android)
- Firestore: CRUD, real-time listeners, queries, subcollections
- Firebase Auth: email/password, Google, Apple sign-in
- Firebase Storage: upload/download files
- Firebase Cloud Messaging (FCM) for push notifications
- Firebase Crashlytics for error reporting
- Firebase Remote Config for feature flags

#### 🛠️ Mini Project

**"Real-Time Chat App"**

- [ ] Firebase Auth (email + Google sign-in)
- [ ] Firestore: messages collection with real-time StreamBuilder
- [ ] Firebase Storage: image message uploads
- [ ] FCM: push notification when new message arrives (app in background)
- [ ] Crashlytics integrated and tested with a forced crash

---

## PHASE 4 — Architecture, Testing & CI/CD `🔲 NOT STARTED`

---

### 4.1 Clean Architecture in Flutter `🔲 NOT STARTED`

#### 📌 What to Learn

- The three layers: Presentation, Domain, Data
- Dependency rule: outer layers depend on inner layers, never the reverse
- `Entity` vs `Model` — why they're separate
- Use Cases (Interactors)
- Repository pattern (abstract + implementation)
- Dependency injection with GetIt

#### 🎯 Why It Matters

This is THE pattern used at any professional Flutter company. Clean Architecture is the single answer to "how do you structure large Flutter apps?" in senior interviews.

#### 🌍 Real-World Example

```
lib/
├── core/                          # Shared utilities
├── features/
│   └── auth/
│       ├── data/
│       │   ├── models/            # UserModel (has fromJson/toJson)
│       │   ├── datasources/       # AuthRemoteDataSource, AuthLocalDataSource
│       │   └── repositories/     # AuthRepositoryImpl
│       ├── domain/
│       │   ├── entities/          # User (pure Dart — no JSON)
│       │   ├── repositories/     # AuthRepository (abstract)
│       │   └── usecases/         # LoginUseCase, LogoutUseCase
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── providers/        # Riverpod providers
```

#### 🛠️ Mini Project

**"Clean Architecture Auth Feature"**

- [ ] `User` entity (domain) vs `UserModel` (data) — separate classes
- [ ] `AuthRepository` abstract class
- [ ] `AuthRepositoryImpl` using Dio remote + Hive local
- [ ] `LoginUseCase` that calls the repository
- [ ] `AuthNotifier` (Riverpod) that calls the use case
- [ ] `LoginScreen` that watches the notifier

---

### 4.2 Testing `🔲 NOT STARTED`

#### 📌 What to Learn

- Unit tests: `flutter_test`, testing use cases and repositories
- Widget tests: `WidgetTester`, finding and interacting with widgets
- Integration tests: `integration_test` package
- Mocking with `mocktail`
- Code coverage with `--coverage` flag

#### 🛠️ Mini Project

**"Fully Tested Feature"**

- [ ] Unit test: `LoginUseCase` with mock repository
- [ ] Unit test: `UserModel.fromJson` with edge cases
- [ ] Widget test: `LoginForm` — fill fields, tap submit, verify navigation
- [ ] Integration test: full login flow on a real simulator
- [ ] Achieve 80%+ code coverage on the auth feature

---
