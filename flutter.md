# 🚀 Flutter Learning Roadmap 2026

> **Your complete guide to mastering Flutter from zero to production-ready developer.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Beginner → Intermediate → Advanced Roadmap](#2-beginner--intermediate--advanced-roadmap)
- [3. Dart Fundamentals](#3-dart-fundamentals)
- [4. Flutter Widgets & UI](#4-flutter-widgets--ui)
- [5. Navigation](#5-navigation)
- [6. State Management](#6-state-management)
- [7. REST APIs & GraphQL](#7-rest-apis--graphql)
- [8. Local Storage](#8-local-storage)
- [9. Firebase](#9-firebase)
- [10. Architecture](#10-architecture)
- [11. Animations](#11-animations)
- [12. Testing](#12-testing)
- [13. CI/CD](#13-cicd)
- [14. Play Store & App Store Deployment](#14-play-store--app-store-deployment)
- [15. Real-World Projects](#15-real-world-projects)
- [16. Curated Free Resources](#16-curated-free-resources)
- [17. Best YouTube Playlists](#17-best-youtube-playlists)
- [18. Progress Checklists](#18-progress-checklists)
- [19. Learning Timeline (6-Month Plan)](#19-learning-timeline-6-month-plan)
- [20. Career Roadmap](#20-career-roadmap)

---

## 1. Overview

### What is Flutter?

Flutter is Google's open-source UI toolkit for building **natively compiled** applications for mobile (iOS, Android), web, desktop (macOS, Windows, Linux), and embedded devices — all from a **single Dart codebase**.

| Feature | Description |
|---------|-------------|
| **Language** | Dart (Google, 2011, v3.x in 2026) |
| **First release** | 2017 (stable) |
| **Rendering** | Skia/Impeller — no OEM widgets, full control |
| **Platforms** | iOS, Android, Web, macOS, Windows, Linux, Fuchsia |
| **License** | BSD-3-Clause |
| **Latest stable** | Flutter 3.x (continuous releases) |
| **Package manager** | pub.dev (~50,000+ packages) |

### Why Learn Flutter in 2026?

- **Single codebase, six platforms** — lowest total cost of ownership for cross-platform.
- **Dart 3 + records + patterns + sealed classes** — modern language features that make code expressive and safe.
- **Impeller renderer** — eliminates the jank of Skia, delivers 120fps consistently.
- **Growing market share** — Flutter is #1 cross-platform framework on Stack Overflow (2024–2026).
- **Strong hiring signal** — Google, BMW, Toyota, Alibaba, ByteDance, eBay, Tencent, and thousands of startups use Flutter.
- **Web and desktop maturity** — Flutter Web now supports SEO (dart:html replacement), and Flutter desktop ships stable on all three OSes.
- **Dart VM in the browser** — Dart compiled to Wasm for near-native web performance.

> 💡 **Tip:** If you already know React Native or SwiftUI, you'll pick up Flutter fast — but the widget composition model is closer to SwiftUI.

### The Dart Ecosystem

```
pub.dev          → Package registry (like npm/nuget)
dart.dev         → Official language docs
api.flutter.dev  → API reference
dartpad.dev      → Online playground
dartfmt          → Opinionated formatter
dart analyze     → Lint/static analysis
```

---

## 2. Beginner → Intermediate → Advanced Roadmap

### 🟢 Stage 1: Beginner (Weeks 1–6)

**Goal:** Build simple static UIs and understand widget tree.

| Milestone | Details |
|-----------|---------|
| **Dart basics** | Variables, control flow, functions, classes |
| **First app** | Scaffold, AppBar, Text, Center, MaterialApp |
| **Layouts** | Row, Column, Container, Padding, Expanded, Stack |
| **State** | setState, StatefulWidget lifecycle |
| **Lists** | ListView, ListTile, dynamic data |
| **Navigation** | Navigator.push/pop, named routes |
| **Forms** | TextField, Form, FormState, validation |
| **Theming** | ThemeData, Theme.of, TextTheme |

- [x] Run `flutter create` and understand the project structure
- [x] Build a profile/portfolio screen with static data
- [x] Build a to-do list app (add/delete items via setState)
- [x] Build a multi-screen app with route transitions

---

### 🟡 Stage 2: Intermediate (Weeks 7–16)

**Goal:** Build real apps with state management, networking, and local storage.

| Milestone | Details |
|-----------|---------|
| **State management (Provider)** | ChangeNotifier, Consumer, context.watch |
| **HTTP & JSON** | http package, JSON serialization, model classes |
| **Async Dart** | Future, Stream, async/await, error handling |
| **Local storage** | SharedPreferences, Hive, sqflite |
| **Forms & validation** | Reactive forms, form keys, regex |
| **Firebase basics** | Auth, Firestore CRUD, Cloud Storage |
| **Navigation 2.0 / GoRouter** | Declarative routing, deep links |
| **Animations** | AnimatedContainer, FadeTransition, SlideTransition |
| **Testing** | Unit tests, widget tests |

- [x] Build a weather app (REST API + Provider)
- [x] Build a note-taking app (Hive + Riverpod)
- [x] Build a chat UI (Firebase + StreamBuilder)
- [x] Build a movie browsing app (API + GoRouter + caching)

---

### 🔴 Stage 3: Advanced (Weeks 17–26)

**Goal:** Production-quality apps with clean architecture, CI/CD, and platform features.

| Milestone | Details |
|-----------|---------|
| **Clean Architecture** | data/domain/presentation layers, use cases, repos |
| **Riverpod / Bloc** | Full state management mastery |
| **GraphQL** | graphql_flutter, code generation |
| **Drift / Isar** | Type-safe databases, migrations |
| **Firebase advanced** | Cloud Functions, FCM, security rules |
| **Custom painter** | Canvas, CustomPainter, Path, animations |
| **Platform channels** | MethodChannel, EventChannel, Pigeon |
| **CI/CD** | GitHub Actions, Codemagic, Fastlane |
| **Deployment** | Play Store, App Store, flavors, code signing |
| **Performance** | DevTools, profiling, shader warmup, memory |

- [x] Build an e-commerce app (Clean Architecture + Bloc)
- [x] Build a fitness tracker (Bluetooth + charts + Isar)
- [x] Build a social media clone (Firebase + Riverpod + Rive)
- [x] Deploy to both stores with CI/CD

---

## 3. Dart Fundamentals

> **Foundation:** Every Flutter app is a Dart app. Master the language before touching widgets.

### 3.1 Variables & Types

```dart
// Type inference
var name = 'Alice';           // String
final age = 30;               // int, cannot reassign
const pi = 3.14159;           // Compile-time constant

// Explicit types
String country = 'India';
int count = 42;
double price = 19.99;
bool isActive = true;

// Dart 3 records
final record = ('first', 42, true);
final (String name, int age) = ('Bob', 25);

// Null safety (sound — Dart 2.12+)
String? nullable = null;      // Nullable
String nonNullable = 'hello'; // Non-nullable
late String initialized;      // Late initialization
```

### 3.2 Null Safety Deep Dive

```dart
// Nullable vs non-nullable
int? maybeInt;
int definitelyInt = 5;

// Null-aware operators
print(maybeInt ?? 0);         // ?? (if-null)
maybeInt?.isEven;             // ?. (conditional access)
maybeInt ??= 42;              // ??= (assign if null)

// Assertion (use sparingly)
print(maybeInt!);             // ! (force unwrap)

// Dart 3 null safety patterns
if (maybeInt case var v?) {   // Pattern matching
  print('value: $v');
}

// Required named parameter
void greet({required String name}) => print('Hi $name');
```

### 3.3 Functions

```dart
// Positional + named + default values
double calculateTotal(double price, {double tax = 0.0, double discount = 0.0}) {
  return price + tax - discount;
}

// Arrow syntax
int square(int x) => x * x;

// Anonymous functions
list.forEach((item) => print(item));

// Dart 3 — records as return types
(int, String) getUser() => (1, 'Alice');

// Higher-order functions
List<int> mapList(List<int> items, int Function(int) fn) {
  return items.map(fn).toList();
}

// Extension functions
extension IntParsing on String {
  int parseInt() => int.parse(this);
}
'42'.parseInt(); // 42
```

### 3.4 Collections

```dart
// List
final fruits = ['apple', 'banana', 'cherry'];
fruits.add('date');
fruits.sort();

// Set (unique)
final unique = <int>{1, 2, 3, 3, 3}; // {1, 2, 3}

// Map
final capitals = {'IN': 'New Delhi', 'US': 'Washington D.C.'};

// Collection operators
fruits.map((f) => f.toUpperCase());
fruits.where((f) => f.startsWith('a'));
fruits.expand((f) => f.codeUnits);

// Spread and null-spread
final all = [...fruits, ...?nullableList];

// Collection-if and collection-for
final widgets = [
  if (isLoggedIn) DashboardWidget(),
  for (final item in items) ItemWidget(item: item),
];
```

### 3.5 Object-Oriented Programming

```dart
// Abstract class
abstract class Animal {
  void makeSound();          // Abstract method
  void breathe() => print('Breathing...');
}

// Inheritance
class Dog extends Animal {
  @override
  void makeSound() => print('Woof!');
}

// Mixin
mixin Swimmer {
  void swim() => print('Swimming');
}

class Duck extends Animal with Swimmer {
  @override
  void makeSound() => print('Quack!');
}

// Interfaces (implicit — every class is an interface)
class Flyable {
  void fly() => print('Flying');
}

class Bird implements Flyable {
  @override
  void fly() => print('Bird flying');
}

// Dart 3 — sealed classes
sealed class Result<T> {}
final class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}
final class Failure<T> extends Result<T> {
  final String message;
  Failure(this.message);
}
```

### 3.6 Async Programming

```dart
// Future
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'data';
}

// Stream
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

// Await for (Dart 3+)
await for (final value in countStream(5)) {
  print(value);
}

// Error handling
try {
  final data = await fetchData();
} on TimeoutException catch (e) {
  print('Timed out: $e');
} catch (e, stackTrace) {
  print('Error: $e');
} finally {
  cleanup();
}
```

### 3.7 Streams

| Stream Type | Description | Use Case |
|-------------|-------------|----------|
| `Single-subscription` | One listener | HTTP response, file read |
| `Broadcast` | Multiple listeners | WebSocket, UI events |
| `StreamController` | Manual control | Custom event buses |
| `StreamTransformer` | Transform stream | Debounce, throttle |

```dart
// Broadcast stream
final controller = StreamController<String>.broadcast();
controller.stream.listen((event) => print('Listener 1: $event'));
controller.stream.listen((event) => print('Listener 2: $event'));
controller.add('Hello');

// Transform
final debounced = controller.stream.debounce(Duration(milliseconds: 300));
```

### 3.8 Isolates

```dart
// Heavy computation off the main thread
Future<int> computeFibonacci(int n) async {
  return Isolate.run(() {
    // Runs on a separate thread
    int fib(int n) => n <= 2 ? 1 : fib(n - 1) + fib(n - 2);
    return fib(n);
  });
}

// With Flutter — use compute()
final result = await compute(heavyFunction, input);

// Dart 3 — spawn multiple isolates
final results = await Future.wait([
  Isolate.run(() => task1()),
  Isolate.run(() => task2()),
  Isolate.run(() => task3()),
]);
```

> ⚠️ **Note:** Isolates cannot share memory. Communication happens via message passing (SendPort/ReceivePort).

### 3.9 Dart 3+ Features (2026)

| Feature | Description | Example |
|---------|-------------|---------|
| **Records** | Anonymous immutable aggregates | `(int, String) pair = (42, 'hello');` |
| **Patterns** | Destructuring, matching | `if (json case [_, var name, _])` |
| **Sealed classes** | Exhaustive type hierarchy | `sealed class Shape { ... }` |
| **Wildcard** | Discard values | `var (_, name, _) = record;` |
| **Class modifiers** | `base`, `interface`, `mixin class` | `base class Vehicle { }` |
| **Enhanced enums** | Fields, methods, generics | `enum Status<T> { active(1); }` |

---

## 4. Flutter Widgets & UI

### 4.1 StatelessWidget vs StatefulWidget

```dart
// Stateless — immutable configuration
class GreetingWidget extends StatelessWidget {
  final String name;
  const GreetingWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// Stateful — mutable state
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),
      child: Text('$_count'),
    );
  }
}
```

### 4.2 Lifecycle of a StatefulWidget

```
createState() → initState() → didChangeDependencies() → build()
  → didUpdateWidget() → build() → setState() → build()
  → deactivate() → dispose()
```

### 4.3 Layout Widgets

| Widget | Purpose |
|--------|---------|
| `Row` | Horizontal layout |
| `Column` | Vertical layout |
| `Stack` | Overlapping children (z-axis) |
| `Container` | A box with decoration, padding, margins |
| `SizedBox` | Fixed-size box |
| `Expanded` | Fill remaining space (Row/Column) |
| `Flexible` | Proportional space (Row/Column) |
| `Wrap` | Overflow to next line |
| `Flow` | Custom layout delegate |
| `Align` | Alignment within parent |
| `Padding` | Padding around child |
| `Center` | Center child |
| `AspectRatio` | Child with fixed aspect ratio |
| `ConstrainedBox` | Min/max constraints |

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.star),
        Expanded(child: Text('Title')),
      ],
    ),
    Expanded(
      child: Stack(
        children: [
          Container(color: Colors.blue),
          Positioned(bottom: 0, child: Text('Overlay')),
        ],
      ),
    ),
  ],
)
```

### 4.4 Material & Cupertino Widgets

| Material | Cupertino | Purpose |
|----------|-----------|---------|
| `Scaffold` | `CupertinoPageScaffold` | Page structure |
| `AppBar` | `CupertinoNavigationBar` | Top bar |
| `ElevatedButton` | `CupertinoButton` | Button |
| `TextField` | `CupertinoTextField` | Text input |
| `Switch` | `CupertinoSwitch` | Toggle |
| `Slider` | `CupertinoSlider` | Slider |
| `Dialog` | `CupertinoAlertDialog` | Dialog |
| `BottomNavigationBar` | `CupertinoTabBar` | Bottom tabs |
| `TabBar` | `CupertinoSlidingSegmentedControl` | Segmented control |
| `ListView` | — | Scrollable list |
| `Card` | — | Elevated card |

> 💡 **Tip:** Use `Platform.isIOS` from `dart:io` (or `Theme.of(context).platform`) to switch between Material and Cupertino per platform.

### 4.5 CustomPainter & Canvas

```dart
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(100, 100), 50, paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### 4.6 Responsive Design

```dart
// LayoutBuilder — responds to constraints
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    }
    return TabletLayout();
  },
)

// MediaQuery — screen info
final size = MediaQuery.of(context).size;
final isMobile = size.width < 600;

// OrientationBuilder
OrientationBuilder(
  builder: (context, orientation) {
    return orientation == Orientation.portrait
        ? PortraitLayout()
        : LandscapeLayout();
  },
)

// FractionallySizedBox — percentage-based sizing
FractionallySizedBox(
  widthFactor: 0.5,
  heightFactor: 0.3,
  child: Card(child: Text('Half width, 30% height')),
)
```

---

## 5. Navigation

### 5.1 Navigator 1.0 (Imperative)

```dart
// Push
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailScreen(id: 42)),
);

// Pop
Navigator.pop(context);

// Send data back
Navigator.pop(context, resultData);

// Receive result
final result = await Navigator.push(...);

// Named routes (basic)
MaterialApp(
  routes: {
    '/': (context) => HomeScreen(),
    '/detail': (context) => DetailScreen(),
  },
);
Navigator.pushNamed(context, '/detail');
```

### 5.2 Navigator 2.0 (Declarative)

```dart
// Router with Pages
MaterialApp.router(
  routerDelegate: routerDelegate,
  routeInformationParser: routeInformationParser,
);

// Page-based navigation
class AppRouterDelegate extends RouterDelegate<AppRouteState> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(child: HomeScreen()),
        if (selectedItem != null)
          MaterialPage(child: DetailScreen(item: selectedItem)),
      ],
    );
  }
}
```

### 5.3 GoRouter (Recommended for most apps)

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) => DetailScreen(
            id: state.pathParameters['id']!,
          ),
          // Nested routes
          routes: [
            GoRoute(
              path: 'photos',
              builder: (context, state) => PhotosScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: SettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],
    ),
  ],
);

// Usage
context.go('/detail/42');
context.goNamed('detail', pathParameters: {'id': '42'});
context.push('/detail/42/photos');
context.pop();

// Redirects & guards
GoRouter(
  redirect: (context, state) {
    final loggedIn = authService.isLoggedIn;
    if (!loggedIn && state.matchedLocation != '/login') {
      return '/login';
    }
    return null;
  },
);

// Deep linking
// Android: AndroidManifest.xml intent-filter
// iOS: Info.plist FlutterDeepLinkingEnabled
```

### Router Comparison

| Feature | Navigator 1.0 | Navigator 2.0 | GoRouter |
|---------|:---:|:---:|:---:|
| Ease of setup | ⭐⭐⭐ | ⭐ | ⭐⭐⭐ |
| Deep linking | Manual | Native | Built-in |
| URL path matching | ❌ | Manual | ✅ |
| Redirects | ❌ | Manual | ✅ |
| Nested navigation | ❌ | ✅ | ✅ |
| Custom transitions | ✅ | ✅ | ✅ |
| State restoration | Manual | Manual | Auto |

---

## 6. State Management

### 6.1 Provider (Ecosystem: `provider` package)

```dart
// Model
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Provide
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: MyApp(),
    ),
  );
}

// MultiProvider
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
    ],
    child: MyApp(),
  ),
);

// Consume
// Option A: context.watch (rebuilds on change)
final counter = context.watch<CounterModel>();
Text('${counter.count}');

// Option B: context.read (no rebuild)
context.read<CounterModel>().increment();

// Option C: Selector (rebuild only when specific value changes)
Selector<CounterModel, int>(
  selector: (_, model) => model.count,
  builder: (_, count, __) => Text('$count'),
);

// Option D: Consumer (rebuilds child)
Consumer<CounterModel>(
  builder: (_, model, __) => Text('${model.count}'),
);
```

### 6.2 Riverpod (Ecosystem: `flutter_riverpod`, `riverpod_annotation`)

```dart
// Provider basics
final counterProvider = StateProvider<int>((ref) => 0);

// Consume
final count = ref.watch(counterProvider);

// Modify
ref.read(counterProvider.notifier).state++;

// FutureProvider — async data
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.watch(apiProvider);
  return api.fetchUser();
});

// StreamProvider
final messagesProvider = StreamProvider<List<Message>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchMessages();
});

// StateNotifierProvider — complex state
class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);
  void add(Todo todo) => state = [...state, todo];
  void toggle(String id) {
    state = state.map((t) =>
      t.id == id ? t.copyWith(done: !t.done) : t
    ).toList();
  }
}

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList();
});

// Autodispose
final tempProvider = FutureProvider.autoDispose((ref) async {
  final data = await fetch();
  ref.onDispose(() => print('Disposed'));
  return data;
});

// Family — parameterized providers
final userProvider = FutureProvider.family<User, String>((ref, id) async {
  return api.fetchUser(id);
});
final user = ref.watch(userProvider('user-123'));

// Riverpod with code generation (riverpod_annotation)
@riverpod
String greeting(GreetingRef ref, String name) {
  return 'Hello $name';
}
```

| Provider Type | Use Case |
|---------------|----------|
| `Provider` | Sync value (no rebuild trigger) |
| `StateProvider` | Simple mutable state |
| `StateNotifierProvider` | Complex mutable state |
| `FutureProvider` | Async data (one-shot) |
| `StreamProvider` | Async stream |
| `ChangeNotifierProvider` | Bridge from Provider code |
| `NotifierProvider` | New Riverpod 2.x pattern |

### 6.3 Bloc / Cubit (Ecosystem: `flutter_bloc`)

```dart
// Cubit (simpler — no events, just methods)
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// Bloc (with events + states)
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// State
class CounterState {
  final int count;
  const CounterState(this.count);
}

// Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.count + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.count - 1)));
  }
}

// Provide
BlocProvider(
  create: (_) => CounterBloc(),
  child: MyApp(),
)

// MultiBlocProvider
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => CartBloc()),
  ],
  child: MyApp(),
)

// Consume
// BlocBuilder — rebuilds on state change
BlocBuilder<CounterBloc, CounterState>(
  builder: (_, state) => Text('${state.count}'),
  buildWhen: (previous, current) => previous.count != current.count,
)

// BlocListener — side effects (snackbar, navigation)
BlocListener<CounterBloc, CounterState>(
  listener: (_, state) {
    if (state.count >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(...);
    }
  },
  child: SomeWidget(),
)

// BlocConsumer — builder + listener combined
BlocConsumer<CounterBloc, CounterState>(
  builder: (_, state) => Text('${state.count}'),
  listener: (_, state) { /* side effects */ },
)

// BlocSelector — select only needed value
BlocSelector<CounterBloc, CounterState, int>(
  selector: (state) => state.count,
  builder: (_, count) => Text('$count'),
)

// Repository provider pattern
BlocProvider(create: (_) => CounterBloc(repository: Repository()))
```

### State Management Comparison

| Library | Boilerplate | Learning Curve | Testability | Community | When to Use |
|---------|:---:|:---:|:---:|:---:|------------|
| `setState` | None | None | ⭐ | — | Simple local state |
| **Provider** | Low | Low | ⭐⭐⭐ | Largest | Medium apps, legacy |
| **Riverpod** | Low | Medium | ⭐⭐⭐⭐ | Growing | New apps, complex state |
| **Bloc** | High | Medium-High | ⭐⭐⭐⭐⭐ | Large | Enterprise, team projects |
| **GetX** | Low | Low | ⭐ | Medium | Prototypes (avoid for prod) |
| **Redux** | High | High | ⭐⭐⭐⭐ | Declining | Legacy migration |

> 💡 **Recommendation (2026):** Start with Provider to learn the patterns, then graduate to **Riverpod** for new projects. Use **Bloc** when working on team projects that need strict state contracts.

---

## 7. REST APIs & GraphQL

### 7.1 HTTP Package (`http`)

```dart
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(String id) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album: ${response.statusCode}');
  }
}
```

### 7.2 Dio (Advanced HTTP Client)

```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
));

// Interceptors
dio.interceptors.addAll([
  LogInterceptor(requestBody: true, responseBody: true),
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer ${await getToken()}';
      return handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // Refresh token logic
      }
      return handler.next(error);
    },
  ),
]);

// Retry interceptor (dio_smart_retry)
dio.interceptors.add(RetryInterceptor(
  dio: dio,
  retries: 3,
  retryDelays: [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 3)],
));

// Usage
final response = await dio.get('/albums');
final response = await dio.post('/albums', data: {'title': 'New'});
final response = await dio.download('/file', './local/file.zip');
final response = await Dio().fetch(RequestOptions(path: '/stream'));

// Cancel token
final cancelToken = CancelToken();
dio.get('/long-operation', cancelToken: cancelToken);
cancelToken.cancel('Operation cancelled by user');
```

### 7.3 Retrofit (Type-safe API Client)

```dart
// 1. Define interface
@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @GET('/albums')
  Future<List<Album>> getAlbums();

  @GET('/albums/{id}')
  Future<Album> getAlbum(@Path('id') int id);

  @POST('/albums')
  Future<Album> createAlbum(@Body() Album album);

  @PUT('/albums/{id}')
  Future<Album> updateAlbum(@Path('id') int id, @Body() Album album);

  @DELETE('/albums/{id}')
  Future<void> deleteAlbum(@Path('id') int id);
}

// 2. Generate (build_runner)
// flutter pub run build_runner build

// 3. Use
final client = ApiClient(dio);
final albums = await client.getAlbums();
```

### 7.4 GraphQL (`graphql_flutter`)

```dart
// Client
final client = GraphQLClient(
  cache: GraphQLCache(store: HiveStore()),
  link: AuthLink(getToken: () async => 'Bearer $token')
      .concat(HttpLink('https://api.example.com/graphql')),
);

// Wrap app
GraphQLProvider(
  client: ValueNotifier(client),
  child: MyApp(),
);

// Query
const query = gql('''
  query GetUser(\$id: ID!) {
    user(id: \$id) {
      name
      email
      posts { id title }
    }
  }
''');

// Option A: Query widget
Query(
  options: QueryOptions(document: query, variables: {'id': '123'}),
  builder: (result, {fetchMore, refetch}) {
    if (result.isLoading) return CircularProgressIndicator();
    if (result.hasException) return Text('Error: ${result.exception}');
    return Text(result.data?['user']['name'] ?? '');
  },
);

// Option B: Run manually
final result = await client.query(QueryOptions(document: query, variables: {...}));

// Mutation
const mutation = gql('''
  mutation CreatePost(\$title: String!, \$content: String!) {
    createPost(title: \$title, content: \$content) { id title }
  }
''');
final result = await client.mutate(MutationOptions(
  document: mutation,
  variables: {'title': 'Hello', 'content': 'World'},
));

// Subscription
graphqlClient.subscribe(SubscriptionOptions(
  document: gql('''
    subscription OnMessageAdded {
      messageAdded { id text }
    }
  '''),
)).listen((event) {
  print(event.data?['messageAdded']);
});
```

### 7.5 Caching Strategies

| Strategy | Package | Best For |
|----------|---------|----------|
| In-memory cache | `dart:collection` LRU | Short-lived sessions |
| Disk cache | `dio_cache_interceptor` | HTTP GET responses |
| Hive + staled-while-revalidate | `hive` + custom | Offline-first apps |
| SQLite persistent | `drift` | Complex offline data |
| GraphQL normalized cache | `graphql_flutter` | GraphQL apps |

```dart
// dio_cache_interceptor
dio.interceptors.add(DioCacheInterceptor(
  options: CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.forceCache,
    hitCacheOnError: true,
    maxStale: Duration(days: 7),
  ),
));
```

---

## 8. Local Storage

### 8.1 SharedPreferences (Simple KV)

```dart
final prefs = await SharedPreferences.getInstance();

// Write
await prefs.setString('name', 'Alice');
await prefs.setInt('age', 30);
await prefs.setBool('darkMode', true);
await prefs.setStringList('items', ['a', 'b', 'c']);

// Read
final name = prefs.getString('name') ?? 'Guest';
final age = prefs.getInt('age') ?? 0;

// Clear
await prefs.remove('name');
await prefs.clear();
```

> ⚠️ **Limit:** SharedPreferences serializes the entire file on every write. Not suitable for large datasets (>100KB) or complex schemas.

### 8.2 Hive (Fast KV Store)

```dart
// Initialize
await Hive.initFlutter();

// TypeAdapter (for custom types)
@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool done;

  Todo({required this.title, this.done = false});
}

// Register adapter
Hive.registerAdapter(TodoAdapter());

// Open box
final box = await Hive.openBox<Todo>('todos');

// CRUD
await box.add(Todo(title: 'Learn Flutter'));
await box.put('key', todo);
final todo = box.get('key');
await box.delete('key');
await box.clear();

// Watch
box.listenable().addListener(() => setState(() {}));

// Lazy box (for huge datasets)
final lazyBox = await Hive.openLazyBox<Todo>('todos_lazy');
final compressed = await Hive.openBox('compressed', compression: SnappyCompression());

// Encryption
final encrypted = await Hive.openBox('secure', encryptionKey: key);
```

| Hive Feature | Description |
|--------------|-------------|
| **Boxes** | Named collections (like tables) |
| **TypeAdapters** | Custom serialization (code-gen) |
| **LazyBox** | Only load entries on demand |
| **Encryption** | AES-256 encrypted boxes |
| **Compression** | Snappy/LZ4 compression |
| **Listeners** | Reactive change notifications |

### 8.3 sqflite (SQLite)

```dart
final database = await openDatabase(
  'my_db.db',
  version: 1,
  onCreate: (db, version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
      )
    ''');
  },
);

// CRUD
await database.insert('todos', {'title': 'Learn sqflite', 'done': 0});
final todos = await database.query('todos', where: 'done = ?', whereArgs: [0]);
await database.update('todos', {'done': 1}, where: 'id = ?', whereArgs: [id]);
await database.delete('todos', where: 'id = ?', whereArgs: [id]);

// Raw queries (for complex joins/reports)
final result = await database.rawQuery('''
  SELECT t.title, c.name AS category
  FROM todos t
  LEFT JOIN categories c ON t.category_id = c.id
  WHERE t.done = 0
  ORDER BY t.id DESC
''');
```

### 8.4 Drift (Type-Safe ORM — formerly Moor)

```dart
// 1. Define tables
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

// 2. Drift database
@DriftDatabase(tables: [Todos, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Seed data
      await batch((b) {
        b.insert(categories, CategoriesCompanion.insert(name: 'General'));
      });
    },
  );

  // Custom queries
  Future<List<TodoWithCategory>> getTodosWithCategory() {
    return (select(todos)
      .join([leftOuterJoin(categories, categories.id.equalsExp(todos.id))])
    ).map((row) => TodoWithCategory(
      todo: row.readTable(todos),
      category: row.readTableOrNull(categories),
    )).get();
  }
}

// 3. Query executor
final db = AppDatabase(LazyDatabase(() async {
  return NativeDatabase(await getApplicationDocumentsDirectory().path + '/db.sqlite');
}));

// 4. Use (reactive)
Stream<List<Todo>> watchAll() => select(todos).watch();
Future<int> addTodo(TodosCompanion todo) => into(todos).insert(todo);
Future<bool> updateTodo(Todo updated) => update(todos).replace(updated);
Future<int> deleteTodo(Todo target) => delete(todos).delete(target);

// DAO pattern
@DriftAccessor(tables: [Todos, Categories])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(super.db);
}
```

### 8.5 Isar (High-Performance NoSQL)

```dart
// 1. Define model
@collection
class Todo {
  Id id = Isar.autoIncrement;
  late String title;
  bool? done;
  DateTime? createdAt;
  final categories = IsarLinks<Category>();
}

// 2. Open database
final isar = await Isar.open([TodoSchema]);

// 3. CRUD
await isar.writeTxn(() => isar.todos.put(Todo()..title = 'Learn Isar'));
final todo = await isar.todos.get(id);
await isar.writeTxn(() => isar.todos.delete(id));

// 4. Queries
final todos = await isar.todos
  .filter()
  .titleContains('Flutter')
  .and()
  .doneEqualTo(false)
  .sortByTitleDesc()
  .limit(10)
  .findAll();

// 5. Links (relationships)
final category = Category()..name = 'Work';
await isar.writeTxn(() => isar.categorys.put(category));
await isar.writeTxn(() {
  todo.categories.add(category);
  isar.todos.save(todo);
});

// 6. Watch (reactive)
isar.todos.watchLazy().listen(() => setState(() {}));
isar.todos.filter().doneEqualTo(false).watch().listen((todos) {
  print('Pending: ${todos.length}');
});

// 7. Full-text search
final results = await isar.todos
  .where()
  .titleMatches('lear*')
  .findAll();
```

### Storage Comparison

| Feature | SharedPrefs | Hive | sqflite | Drift | Isar |
|---------|:---:|:---:|:---:|:---:|:---:|
| **Type** | KV | KV | SQL | SQL ORM | NoSQL |
| **Speed** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Type-safe** | ❌ | ✅ (adapters) | ❌ | ✅ | ✅ |
| **Reactive** | ❌ | ✅ | ❌ | ✅ (Stream) | ✅ (Stream) |
| **Relations** | ❌ | ❌ | ✅ | ✅ | ✅ (Links) |
| **Migrations** | Manual | Manual | Manual | ✅ | Auto |
| **Web** | ✅ | ❌ | ❌ | ✅ | ✅ (IDB) |
| **Binary** | ❌ | ✅ | ❌ | ❌ | ✅ |
| **Encryption** | ❌ | ✅ | ❌ | ❌ | ✅ |
| **Package** | built-in | hive | sqflite | drift | isar |

---

## 9. Firebase

### 9.1 Firebase Auth

```dart
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

// Email/Password
Future<UserCredential> signUp(String email, String password) async {
  return await auth.createUserWithEmailAndPassword(email: email, password: password);
}

Future<UserCredential> signIn(String email, String password) async {
  return await auth.signInWithEmailAndPassword(email: email, password: password);
}

// Google Sign-In
Future<UserCredential> signInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();
  final googleAuth = await googleUser!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await auth.signInWithCredential(credential);
}

// Apple Sign-In
Future<UserCredential> signInWithApple() async {
  final appleProvider = AppleAuthProvider();
  appleProvider.addScope('email');
  appleProvider.addScope('name');
  return await auth.signInWithPopup(appleProvider);
}

// Phone Auth
Future<void> verifyPhone(String phone) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phone,
    verificationCompleted: (credential) => auth.signInWithCredential(credential),
    verificationFailed: (e) => print('Failed: $e'),
    codeSent: (verificationId, forceResendingToken) {
      // Show OTP dialog
      final smsCode = await showOtpDialog();
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
    },
    codeAutoRetrievalTimeout: (verificationId) {},
  );
}

// Auth state listener
Stream<User?> get userStream => auth.authStateChanges();

// Sign out
await auth.signOut();

// Anonymous auth
await auth.signInAnonymously();
```

### 9.2 Cloud Firestore

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
final usersRef = firestore.collection('users');
final postsRef = firestore.collection('posts');

// CREATE
await usersRef.doc('user123').set({
  'name': 'Alice',
  'email': 'alice@example.com',
  'createdAt': FieldValue.serverTimestamp(),
});

// READ (once)
final doc = await usersRef.doc('user123').get();
final data = doc.data() as Map<String, dynamic>;

// READ (realtime)
Stream<User?> getUserStream(String uid) {
  return usersRef.doc(uid).snapshots().map((snap) {
    return snap.exists ? User.fromMap(snap.data()!) : null;
  });
}

// QUERY
final popularPosts = await postsRef
  .where('published', isEqualTo: true)
  .where('likes', isGreaterThan: 100)
  .orderBy('createdAt', descending: true)
  .limit(20)
  .get();

// REAL-TIME QUERY
Stream<List<Post>> streamPosts() {
  return postsRef
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snap) => snap.docs.map((d) => Post.fromMap(d.data(), d.id)).toList());
}

// SUBCOLLECTION
final commentsRef = postsRef.doc('post123').collection('comments');

// BATCH WRITE
final batch = firestore.batch();
batch.set(usersRef.doc('user1'), {'name': 'Bob'});
batch.update(postsRef.doc('post1'), {'likes': FieldValue.increment(1)});
batch.delete(commentsRef.doc('comment1'));
await batch.commit();

// TRANSACTION (atomic)
await firestore.runTransaction((transaction) async {
  final doc = await transaction.get(postsRef.doc('post1'));
  final likes = doc.data()?['likes'] ?? 0;
  transaction.update(postsRef.doc('post1'), {'likes': likes + 1});
});

// OFFLINE — enabled by default
await firestore.settings = Settings(persistenceEnabled: true);

// AGGREGATION (2024+)
final snapshot = await postsRef.count().get();
print('Total posts: ${snapshot.count}');

// PAGINATION
final first = await postsRef.limit(20).get();
final lastDoc = first.docs.last;
final next = await postsRef.startAfterDocument(lastDoc).limit(20).get();
```

### 9.3 Firebase Storage

```dart
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;
final ref = storage.ref('users/user123/avatar.jpg');

// Upload from file
await ref.putFile(File('/path/to/image.jpg'));

// Upload from bytes
await ref.putData(Uint8List.fromBytes(bytes));

// Metadata
await ref.updateMetadata(SettableMetadata(
  contentType: 'image/jpeg',
  customMetadata: {'userId': '123'},
));

// Download URL
final url = await ref.getDownloadURL();

// Delete
await ref.delete();

// List
final listResult = await storage.ref('users/user123/').listAll();
for (final item in listResult.items) {
  print(item.name);
}
```

### 9.4 Cloud Functions

```javascript
// index.js (Firebase Functions)
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Callable function
exports.addAdminRole = functions.https.onCall(async (data, context) => {
  const { email } = data;
  const user = await admin.auth().getUserByEmail(email);
  await admin.auth().setCustomUserClaims(user.uid, { admin: true });
  return { message: `${email} is now an admin!` };
});

// Firestore trigger
exports.onNewOrder = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const order = snap.data();
    await admin.messaging().sendToTopic('admins', {
      notification: {
        title: 'New Order',
        body: `Order #${order.orderNumber} placed`,
      },
    });
  });
```

```dart
// Dart client
final result = await FirebaseFunctions.instance
    .httpsCallable('addAdminRole')
    .call({'email': 'admin@example.com'});
```

### 9.5 Cloud Messaging (FCM / Push Notifications)

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

final messaging = FirebaseMessaging.instance;

// Request permission
final settings = await messaging.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);

// Get device token
final token = await messaging.getToken();

// Listen to token refresh
messaging.onTokenRefresh.listen((newToken) {
  // Update server
});

// Foreground messages
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Received: ${message.notification?.title}');
  // Show local notification
});

// Background (on message tapped)
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Navigate to specific screen
});

// App terminated state
final initialMessage = await messaging.getInitialMessage();
if (initialMessage != null) {
  // Handle deep navigation from terminated state
}

// Local notifications (flutter_local_notifications)
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
await flutterLocalNotificationsPlugin.initialize(
  InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  ),
  onDidReceiveNotificationResponse: (response) {
    // Handle notification tap while app in foreground
  },
);
```

### 9.6 Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /posts/{postId} {
      allow read: if resource.data.published == true || request.auth.uid == resource.data.authorId;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.authorId;
      allow delete: if request.auth.uid == resource.data.authorId;
    }

    match /posts/{postId}/comments/{commentId} {
      allow read: if true;
      allow create: if request.auth != null && request.resource.data.authorId == request.auth.uid;
      allow delete: if request.auth.uid == resource.data.authorId;
    }

    // Validate data
    allow create: if request.resource.data.title is string
                && request.resource.data.title.size() < 200;
  }
}
```

---

## 10. Architecture

### 10.1 MVVM Pattern

```
View (Widget)       ← Observes →    ViewModel         ← Calls →     Model / Repository
    │                                  │                                │
    │ User taps button                 │ Notifies listeners              │
    │────────────────→ onIncrement() ──│──────→ incrementCount() ──────│
    │                                  │←────── Future<int> ──────────│
    │←── rebuild UI ←── notifyListeners()                             │
```

```dart
// ViewModel
class CounterViewModel extends ChangeNotifier {
  final CounterRepository _repo;
  int _count = 0;
  bool _isLoading = false;

  CounterViewModel(this._repo);

  int get count => _count;
  bool get isLoading => _isLoading;

  Future<void> loadCount() async {
    _isLoading = true;
    notifyListeners();
    _count = await _repo.fetchCount();
    _isLoading = false;
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }
}

// View
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CounterViewModel>();
    return Scaffold(
      body: vm.isLoading
          ? CircularProgressIndicator()
          : Text('${vm.count}'),
      floatingActionButton: FAB(
        onPressed: () => context.read<CounterViewModel>().increment(),
      ),
    );
  }
}
```

### 10.2 Clean Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Presentation Layer                 │
│  ┌──────────┐   ┌──────────────┐   ┌────────────┐   │
│  │  Widgets  │──▶│ ViewModels / │──▶│ Providers  │   │
│  │ (UI)      │◀──│ StateNotifier│   │            │   │
│  └──────────┘   └──────────────┘   └──────┬─────┘   │
└────────────────────────────────────────────┼─────────┘
                                             │ calls
┌────────────────────────────────────────────┼─────────┐
│                   Domain Layer             │         │
│  ┌──────────┐   ┌──────────────┐   ┌──────┴─────┐  │
│  │ Entities │   │  Use Cases   │   │  Repos     │  │
│  │ (Models) │   │ (Business    │──▶│ (Abstract) │  │
│  │          │   │  Logic)      │   │            │  │
│  └──────────┘   └──────────────┘   └────────────┘  │
└────────────────────────────────────────────────────┘
                         │ implements
┌────────────────────────┼────────────────────────────┐
│                 Data Layer                          │
│  ┌────────────┐   ┌───┴──────────┐   ┌───────────┐ │
│  │ API / DB   │   │ Repo Impl   │   │ DTO /     │ │
│  │ (Data Src)  │◀──│             │──▶│ Mappers  │ │
│  └────────────┘   └──────────────┘   └───────────┘ │
└────────────────────────────────────────────────────┘
```

```dart
// ── Domain Layer ──

// Entity
class User {
  final String id;
  final String name;
  final String email;
  const User({required this.id, required this.name, required this.email});
}

// Abstract Repository
abstract class UserRepository {
  Future<User> getUserById(String id);
  Future<List<User>> searchUsers(String query);
}

// Use Case
class GetUserProfile {
  final UserRepository _repo;
  GetUserProfile(this._repo);

  Future<User> execute(String userId) async {
    return _repo.getUserById(userId);
  }
}

// ── Data Layer ──

// Data Source
class UserRemoteDataSource {
  final Dio _dio;
  UserRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> fetchUser(String id) async {
    final response = await _dio.get('/users/$id');
    return response.data;
  }
}

// Repository Implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;

  UserRepositoryImpl(this._remote, this._local);

  @override
  Future<User> getUserById(String id) async {
    try {
      final json = await _remote.fetchUser(id);
      final user = UserMapper.fromJson(json);
      await _local.cacheUser(user);
      return user;
    } on DioException {
      // Fallback to cache
      return _local.getCachedUser(id);
    }
  }
}

// ── Presentation Layer ──

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<User> build(String userId) {
    return ref.read(getUserProfileProvider).execute(userId);
  }
}

// Usage in widget
final userAsync = ref.watch(userProfileNotifierProvider('user-123'));
userAsync.when(
  data: (user) => Text(user.name),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
);
```

### 10.3 Repository Pattern

```dart
abstract class AuthRepository {
  Stream<User?> get user;
  Future<User> signIn(String email, String password);
  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._firebaseAuth, this._local);

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges().map((firebaseUser) {
    if (firebaseUser == null) return null;
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
    );
  });

  @override
  Future<User> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _mapFirebaseUser(credential.user!);
    await _local.cacheCredentials(email, password);
    return user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _local.clearCredentials();
  }
}
```

### 10.4 Dependency Injection

```dart
// ── get_it ──
final sl = GetIt.instance;

void setupDI() {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // Blocs / Cubits
  sl.registerFactory(() => UserCubit(sl()));
}

// ── Provider ──
MultiProvider(
  providers: [
    Provider<Dio>(create: (_) => Dio()),
    Provider<UserRepository>(create: (_) => UserRepositoryImpl(...)),
  ],
)

// ── Riverpod (auto-DI) ──
final dioProvider = Provider<Dio>((ref) => Dio());
final userRepoProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(dioProvider), ...);
});
final userProfileProvider = FutureProvider.family<User, String>((ref, id) {
  return ref.watch(userRepoProvider).getUserById(id);
});
```

---

## 11. Animations

### 11.1 Implicit Animations (Simplest)

```dart
// AnimatedContainer
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  width: isExpanded ? 200 : 100,
  height: isExpanded ? 200 : 100,
  color: isExpanded ? Colors.blue : Colors.red,
  curve: Curves.easeInOut,
);

// AnimatedOpacity
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Fade me'),
);

// AnimatedPadding, AnimatedAlign, AnimatedPositioned
AnimatedPadding(
  padding: EdgeInsets.all(isExpanded ? 50 : 10),
  duration: Duration(seconds: 1),
  child: Card(child: Text('Hello')),
);

// TweenAnimationBuilder
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: 1),
  duration: Duration(seconds: 2),
  builder: (_, value, __) => Opacity(
    opacity: value,
    child: Transform.scale(scale: value, child: Text('Animated')),
  ),
);
```

### 11.2 Explicit Animations (Full Control)

```dart
class _ExpandWidgetState extends State<ExpandWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  void _toggle() {
    if (_expanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _expanded = !_expanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Transform.scale(
        scale: _animation.value,
        child: child,
      ),
      child: ElevatedButton(onPressed: _toggle, child: Text('Toggle')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 11.3 Hero Animation

```dart
// Source screen
Hero(
  tag: 'profile-${user.id}',
  child: CircleAvatar(
    radius: 40,
    backgroundImage: NetworkImage(user.avatarUrl),
  ),
)

// Destination screen
Hero(
  tag: 'profile-${user.id}',
  child: CircleAvatar(
    radius: 120,   // Hero will animate the size change
    backgroundImage: NetworkImage(user.avatarUrl),
  ),
)

// Custom Hero flight
Hero(
  tag: tag,
  flightShuttleBuilder: (ctx, anim, direction, fromCtx, toCtx) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Transform.rotate(
        angle: anim.value * 2 * 3.14,
        child: fromCtx?.widget,
      ),
    );
  },
  child: widget,
)
```

### 11.4 Staggered Animations (Chained)

```dart
class StaggeredAnimation extends StatefulWidget {
  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _slide = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _scale = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: SlideTransition(
          position: _slide,
          child: Transform.scale(
            scale: _scale.value,
            child: Card(child: Text('Staggered')),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 11.5 Rive & Lottie

```dart
// Rive — interactive vector animations
import 'package:rive/rive.dart';

RiveAnimation.asset(
  'assets/animations/button.riv',
  artboard: 'Button',
  stateMachines: ['State Machine 1'],
  fit: BoxFit.contain,
  onInit: (artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    final input = controller.findInput<bool>('isHover') as SMIBool;
    input.value = true;
  },
);

// Lottie — JSON animations (After Effects)
import 'package:lottie/lottie.dart';

Lottie.asset(
  'assets/animations/loading.json',
  animate: true,
  repeat: true,
  reverse: true,
  delegates: LottieDelegates(values: [
    ValueDelegate.color(
      keyPath: ['Oxygen', 'Base', 'Center Ellipse'],
      value: Colors.blue,
    ),
  ]),
);
```

---

## 12. Testing

### 12.1 Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterBloc', () {
    late CounterBloc bloc;

    setUp(() {
      bloc = CounterBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is 0', () {
      expect(bloc.state.count, equals(0));
    });

    blocTest<CounterBloc, CounterState>(
      'emits [1] when increment is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(Increment()),
      expect: () => [CounterState(1)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits [-1] when decrement is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(Decrement()),
      expect: () => [CounterState(-1)],
    );
  });
}
```

### 12.2 Widget Tests

```dart
void main() {
  testWidgets('Counter increments when tapped', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: CounterScreen()),
    );

    // Verify initial
    expect(find.text('0'), findsOneWidget);

    // Tap FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify updated
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Form validation shows error', (tester) async {
    await tester.pumpWidget(FormScreen());

    // Tap submit without filling fields
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify error appears
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('Navigation works via GoRouter', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    // Tap on item
    await tester.tap(find.text('Item 1'));
    await tester.pumpAndSettle();

    // Verify we navigated
    expect(find.text('Detail: Item 1'), findsOneWidget);
  });
}
```

### 12.3 Integration Tests

```dart
// test_driver/app_test.dart
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full login flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // Navigate to login
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Fill credentials
    await tester.enterText(find.byType(TextField).at(0), 'user@test.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Verify we reached home
    expect(find.text('Welcome, User!'), findsOneWidget);

    // Take screenshot
    await tester.takeScreenshot('after_login');
  });
}
```

### 12.4 Golden Tests (Visual Regression)

```dart
testWidgets('ProfileScreen golden test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: ProfileScreen(user: testUser)),
  );
  await expectLater(
    find.byType(ProfileScreen),
    matchesGoldenFile('goldens/profile_screen.png'),
  );
});
```

### 12.5 Mocking

```dart
// Mocktail (lighter than Mockito — no code gen)
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;
  late GetUserProfile useCase;

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = GetUserProfile(mockRepo);
  });

  test('returns user when found', () async {
    when(() => mockRepo.getUserById('123'))
        .thenAnswer((_) async => testUser);

    final user = await useCase.execute('123');

    expect(user.id, equals('123'));
    verify(() => mockRepo.getUserById('123')).called(1);
  });

  test('throws when user not found', () async {
    when(() => mockRepo.getUserById('404'))
        .thenThrow(Exception('User not found'));

    expect(
      () => useCase.execute('404'),
      throwsException,
    );
  });
}

// Mockito (with code gen)
@GenerateMocks([UserRepository])
void main() {
  test('mockito test', () async {
    final repo = MockUserRepository();
    when(repo.getUserById('123')).thenAnswer((_) async => testUser);
    // ...
  });
}
```

### Test Pyramid

```
         ╱ ╲
        ╱ E2E ╲         ← Few (smoke tests, critical paths)
       ╱────────╲
      ╱ Widget   ╲      ← Some (UI behavior, user flows)
     ╱────────────╲
    ╱   Unit Tests  ╲   ← Many (business logic, models, controllers)
   ╱──────────────────╲
```

---

## 13. CI/CD

### 13.1 GitHub Actions

```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  analyze-and-test:
    name: Analyze & Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter analyze --no-fatal-infos --no-fatal-warnings
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          token: ${{ secrets.CODECOV_TOKEN }}

  build-android:
    name: Build Android APK/AAB
    needs: analyze-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v4
        with:
          name: android-release
          path: build/app/outputs/bundle/release/*.aab

  build-ios:
    name: Build iOS IPA
    needs: analyze-and-test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
      - run: |
          cd ios
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner \
            -sdk iphoneos \
            -configuration Release \
            archive -archivePath build/Runner.xcarchive
```

### 13.2 Codemagic (Flutter-Specific CI/CD)

```yaml
# codemagic.yaml
workflows:
  flutter-workflow:
    name: Flutter Build & Deploy
    environment:
      flutter: stable
      xcode: latest
    scripts:
      - flutter pub get
      - flutter analyze
      - flutter test
      - flutter build appbundle --release
      - flutter build ios --release --no-codesign
    artifacts:
      - build/**/outputs/**/*.aab
      - build/**/outputs/**/*.ipa
      - build/**/outputs/**/*.apk
    publishing:
      email:
        recipients:
          - team@example.com
      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal
      app_store_connect:
        auth: $APP_STORE_CONNECT_API_KEY
```

### 13.3 Fastlane (Automated Deployment)

```ruby
# fastlane/Fastfile
platform :android do
  lane :deploy_internal do
    build_flutter_app(
      build_type: 'release',
      flavor: 'production',
    )
    upload_to_play_store(
      track: 'internal',
      aab: 'build/app/outputs/bundle/productionRelease/app-production-release.aab',
    )
  end

  lane :increment_version do
    increment_version_name(
      gradle_file_path: 'android/app/build.gradle',
    )
    increment_version_code(
      gradle_file_path: 'android/app/build.gradle',
    )
  end
end

platform :ios do
  lane :deploy_testflight do
    build_flutter_app(
      build_type: 'release',
      flavor: 'production',
    )
    upload_to_testflight(
      app_identifier: 'com.example.myapp',
      skip_waiting_for_build_processing: true,
    )
  end

  lane :sync_signing do
    match(
      type: 'development',
      readonly: true,
    )
  end
end
```

---

## 14. Play Store & App Store Deployment

### 14.1 Android Signing

```groovy
// android/app/build.gradle
android {
    signingConfigs {
        release {
            storeFile file("../keystore.jks")
            storePassword System.env("KEYSTORE_PASSWORD")
            keyAlias System.env("KEY_ALIAS")
            keyPassword System.env("KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ProGuard
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 14.2 App Bundle vs APK

| Format | Size | Dynamic Delivery | Play Feature |
|--------|:----:|:---:|:---:|
| APK | Larger | ❌ | Direct install |
| AAB | ~40% smaller | ✅ | Split by config, on-demand modules |

```bash
flutter build appbundle --release        # For Play Store
flutter build apk --release --split-per-abi  # For direct distribution
```

### 14.3 Flavors (Dev / Staging / Prod)

```yaml
# pubspec.yaml
flutter:
  flavors:
    dev:
      app_name: "MyApp Dev"
      bundle_id: "com.example.myapp.dev"
    staging:
      app_name: "MyApp Staging"
      bundle_id: "com.example.myapp.staging"
    prod:
      app_name: "MyApp"
      bundle_id: "com.example.myapp"
```

```dart
// Using flavor
class AppConfig {
  final String apiBaseUrl;

  AppConfig._({
    required this.apiBaseUrl,
  });

  static AppConfig get fromFlavor {
    switch (F.appFlavor) {  // From package:flutter_flavorizr
      case 'dev':
        return AppConfig._(apiBaseUrl: 'https://dev.api.example.com');
      case 'staging':
        return AppConfig._(apiBaseUrl: 'https://staging.api.example.com');
      case 'prod':
        return AppConfig._(apiBaseUrl: 'https://api.example.com');
      default:
        throw Exception('Unknown flavor');
    }
  }
}
```

```bash
# Build specific flavor
flutter build appbundle --flavor dev -t lib/main_dev.dart
flutter build ios --flavor staging -t lib/main_staging.dart
```

### 14.4 App Store Connect

```
1. Enroll in Apple Developer Program ($99/year)
2. Create App ID in Apple Developer Portal
3. Generate certificates & provisioning profiles
4. Configure Xcode project:

   ios/Runner.xcodeproj
   ├─ Bundle Identifier: com.example.myapp
   ├─ Signing & Capabilities: + Push Notifications, + In-App Purchase
   └─ Info.plist:
       ├─ FlutterDeepLinkingEnabled → YES
       └─ applinks:example.com (Associated Domains)

5. Build & Archive:
   flutter build ipa --release

6. Upload via Transporter or Xcode Organizer
7. App Store Connect → Pricing & Availability → Submit for Review
```

### 14.5 Google Play Console

```
1. Enroll in Google Play Developer account ($25 one-time)
2. Create app → Fill store listing (screenshots, description, category)
3. Set up in-app products / subscriptions if needed
4. App signing → Let Google manage signing key (recommended)
5. Production track → Roll-out percentage
6. Testing tracks: Internal → Closed Alpha → Open Beta → Production
7. Managed publishing → Review with "Publishing overview"
```

### 14.6 In-App Purchases & Ads

```dart
// In-App Purchase (in_app_purchase)
import 'package:in_app_purchase/in_app_purchase.dart';

final purchase = InAppPurchase.instance;

// Load products
final products = await purchase.queryProductDetails({'premium_subscription'});

// Buy
final purchaseParam = PurchaseParam(productDetails: products.details.first);
await purchase.buyNonConsumable(purchaseParam: purchaseParam);

// Restore
await purchase.restorePurchases();

// Listen to purchase updates
purchase.purchaseStream.listen((purchases) {
  for (final p in purchases) {
    if (p.status == PurchaseStatus.purchased) {
      // Grant content
      await _verifyAndDeliver(p);
    }
  }
});

// Ads (Google Mobile Ads)
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() => MobileAds.instance.initialize();

// Banner
final banner = BannerAd(
  adUnitId: 'ca-app-pub-3940256099942544/6300978111',  // Test ID
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(
    onAdLoaded: (ad) => print('Banner loaded'),
    onAdFailedToLoad: (ad, error) => print('Failed: $error'),
  ),
);
banner.load();

// Rewarded Interstitial
final rewarded = RewardedInterstitialAd.load(
  adUnitId: 'ca-app-pub-3940256099942544/6978759866',  // Test ID
  request: AdRequest(),
  rewardedInterstitialAdLoadCallback: AdLoadCallback(
    onAdLoaded: (ad) => ad.show(userEarnedReward: (reward) {
      print('User earned ${reward.amount} ${reward.type}');
    }),
    onAdFailedToLoad: (error) => print('Failed: $error'),
  ),
);
```

---

## 15. Real-World Projects (10+)

### Project 1: Personal Portfolio App

| Aspect | Details |
|--------|---------|
| **What** | Multi-screen app showing bio, skills, projects, resume |
| **Concepts** | StatelessWidget, theming, ListView, navigation, URL launcher |
| **Outcome** | Understanding widget tree, basic layouts, and navigation |

### Project 2: Todo List with Categories

| Aspect | Details |
|--------|---------|
| **What** | CRUD todo app with categories, search, dark mode |
| **Concepts** | StatefulWidget, setState, forms, animations, SharedPreferences |
| **Outcome** | State management basics, form validation, local persistence |

### Project 3: Weather App

| Aspect | Details |
|--------|---------|
| **What** | Real-time weather with location, 7-day forecast, city search |
| **Concepts** | HTTP (REST API), JSON parsing, Provider, geolocation |
| **Outcome** | Networking, JSON serialization, state management |

### Project 4: Note-Taking App with Markdown

| Aspect | Details |
|--------|---------|
| **What** | Rich text notes with markdown rendering, tags, search |
| **Concepts** | Riverpod, Hive/Isar, Markdown package, RichText |
| **Outcome** | Local storage mastery, complex state management |

### Project 5: E-Commerce App

| Aspect | Details |
|--------|---------|
| **What** | Product catalog, cart, checkout, order history |
| **Concepts** | Clean Architecture, Bloc, REST API, GoRouter, Drift (offline cart) |
| **Outcome** | Production architecture patterns, full app lifecycle |

### Project 6: Chat Application

| Aspect | Details |
|--------|---------|
| **What** | Real-time chat with Firebase, image sharing, read receipts |
| **Concepts** | Firebase Auth, Firestore streams, Cloud Storage, FCM |
| **Outcome** | Real-time data flows, authentication, push notifications |

### Project 7: Social Media Clone

| Aspect | Details |
|--------|---------|
| **What** | Feed with posts/likes/comments, user profiles, stories |
| **Concepts** | Riverpod, Firebase, image upload, infinite scroll, animations |
| **Outcome** | Complex data modeling, scalable architecture |

### Project 8: Fitness Tracker

| Aspect | Details |
|--------|---------|
| **What** | Workout logging, step counter, charts, weekly reports |
| **Concepts** | Isar (time-series data), fl_chart, health package, Bluetooth |
| **Outcome** | Real-time data viz, platform channels, performance optimization |

### Project 9: Music Player

| Aspect | Details |
|--------|---------|
| **What** | Audio playback, playlists, album art, search, equalizer |
| **Concepts** | just_audio, audio_service, Isar, custom painter (waveforms) |
| **Outcome** | Background services, audio processing, custom paint |

### Project 10: Expense Tracker

| Aspect | Details |
|--------|---------|
| **What** | Budgeting, recurring expenses, charts, CSV export |
| **Concepts** | Bloc, Drift (complex queries), fl_chart, share_plus |
| **Outcome** | Complex queries, data aggregation, file I/O |

### Project 11: Food Delivery App

| Aspect | Details |
|--------|---------|
| **What** | Restaurant menu, cart, order tracking, maps integration |
| **Concepts** | Riverpod, Firebase, Google Maps, real-time tracking |
| **Outcome** | Map integration, real-time location, complex UI composition |

### Project 12: Habit Tracker with Gamification

| Aspect | Details |
|--------|---------|
| **What** | Daily habits, streaks, achievements, calendar view |
| **Concepts** | Isar, Rive animations, local notifications, table_calendar |
| **Outcome** | Gamification mechanics, calendar UI, notification scheduling |

### Project 13: Quiz / Trivia Game

| Aspect | Details |
|--------|---------|
| **What** | Timed quizzes, leaderboard, categories, multiplayer |
| **Concepts** | GoRouter, animations, WebSockets, Isar, Firebase |
| **Outcome** | Game loop design, real-time multiplayer, animation sequences |

### Project 14: AI Chatbot Client

| Aspect | Details |
|--------|---------|
| **What** | GPT/Claude client with streaming responses, history |
| **Concepts** | Stream-based HTTP, Markdown rendering, Riverpod, Isar |
| **Outcome** | Streaming responses, token counting, prompt engineering |

### Project 15: Cross-Platform Desktop App

| Aspect | Details |
|--------|---------|
| **What** | File manager or markdown editor with keyboard shortcuts |
| **Concepts** | Flutter desktop, window management, file I/O, platform channels |
| **Outcome** | Desktop-specific patterns, menu bars, keyboard handling |

---

## 16. Curated Free Resources

### Official Documentation

| Resource | URL | Covers |
|----------|-----|--------|
| Flutter Official Docs | https://docs.flutter.dev | Everything — start here |
| Dart Language Tour | https://dart.dev/language | Language fundamentals |
| Flutter API Reference | https://api.flutter.dev | Widget-level docs |
| Flutter Cookbook | https://docs.flutter.dev/cookbook | Recipes for common tasks |
| Dart API Reference | https://api.dart.dev | Core Dart libraries |
| Flutter Samples | https://flutter.github.io/samples | Real app code |

### Free Courses

| Course | Platform | Description |
|--------|----------|-------------|
| **Flutter & Dart — The Complete Guide** (free preview) | Udemy | 40h+ of content by Maximilian Schwarzmüller |
| **Dart Introduction** | dart.dev | Official interactive tour |
| **Flutter Codelabs** | https://codelabs.developers.google.com/?cat=flutter | 30+ step-by-step labs |
| **Dart Academy** | https://dart.academy | Free tutorials for beginners |
| **Flutter by Example** | https://flutterbyexample.com | Searchable example-driven docs |
| **Build a Flutter App from Scratch** | https://flutter.dev/learn | Official learning path |

### Free Books

| Book | Author | Link |
|------|--------|------|
| **Flutter Complete Reference** | Alberto Miola | https://fluttercompletereference.com |
| **Pragmatic State Management in Flutter** | Google | https://docs.flutter.dev/data-and-backend/state-mgmt |
| **Dart Up & Running** | Kathy Walrath | https://dart.dev/guides/language/tour (free online) |
| **Flutter Succinctly** | Ed Freitas | https://www.syncfusion.com/succinctly-free-ebooks/flutter |
| **Google Flutter Codelabs** | Google | https://codelabs.developers.google.com |
| **Flutter Animation** | Various | https://docs.flutter.dev/ui/animations/tutorial |

### Tools & Utilities

| Tool | Description |
|------|-------------|
| **DartPad** (https://dartpad.dev) | Online Dart/Flutter editor |
| **Flutter DevTools** | Built-in profiler, inspector, debugger |
| **pub.dev** | Package registry with 50k+ packages |
| **dart.guide** | https://dart.guide — Interactive Dart tutorials |
| **Awesome Flutter** | https://github.com/Solido/awesome-flutter |
| **Flutter Gems** | https://fluttergems.dev |

---

## 17. Best YouTube Playlists

> 🎯 Each playlist is mapped to the roadmap section(s) it covers. Watch the playlist alongside that section.

### Top YouTube Channels

| Channel | URL | Focus | Covers Section(s) |
|---------|-----|-------|-------------------|
| Flutter (Official) | https://youtube.com/@flutterdev | Official Flutter content | 4, 5, 9, 11, 12 |
| The Net Ninja | https://youtube.com/@NetNinja | Beginner to advanced Flutter | 3, 4, 6 |
| Vandad Nahavandipoor | https://youtube.com/@VandadNahavandipoor | Deep-dive Flutter & Dart | 3, 4, 10 |
| Fireship | https://youtube.com/@fireship | High-density Flutter concepts | 9, 13, 14 |
| Code With Andrea | https://youtube.com/@CodeWithAndrea | State management, architecture | 6, 10 |
| Reso Coder | https://youtube.com/@ResoCoder | Clean Architecture, TDD | 10, 12 |
| Rivaan Ranawat | https://youtube.com/@RivaanRanawat | Full Flutter apps | 4, 15 |
| Mitch Koko | https://youtube.com/@mitchkoko | Animations & UI design | 4, 11 |
| Johannes Milke | https://youtube.com/@JohannesMilke | Flutter tips & packages | 4, 8, 9 |
| Tadas Petra | https://youtube.com/@tadaspetra | Bloc & state management | 6 |
| Marcus Ng | https://youtube.com/@marcusng | Firebase & Flutter | 9 |
| Widget Wisdom | https://youtube.com/@WidgetWisdom | Flutter UI & animations | 4, 11 |
| Flutterly | https://youtube.com/@Flutterly | Animations & widgets | 4, 11 |
| HeyFlutter | https://youtube.com/@HeyFlutter | Packages & tips | 3, 4 |
| dbestech | https://youtube.com/@dbestech | Full-stack Flutter apps | 7, 9, 15 |
| Retro Studio | https://youtube.com/@retrostudio | UI challenges & design | 4, 11 |
| FlutterDevs | https://youtube.com/@flutterdevs | Complete Flutter tutorials | 3, 4, 15 |

### Playlists by Topic

| # | Channel | Playlist | Covers Section | URL |
|---|---------|----------|----------------|-----|
| 1 | Flutter (Official) | Widget of the Week | 4 | https://youtube.com/playlist?list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2 |
| 2 | Flutter (Official) | Flutter in Focus | 4 | https://youtube.com/playlist?list=PLjxrf2q8roU0Netg1wRqS0M4p3QASZqG1 |
| 3 | Flutter (Official) | Flutter Decode | 4, 10 | https://youtube.com/playlist?list=PLjxrf2q8roU3icxBXbR3mp5fM6K0JipAc |
| 4 | Flutter (Official) | Flutter Navigation | 5 | https://youtube.com/playlist?list=PLjxrf2q8roU3M0C1gX5Z-UiG4qWzXlXdP |
| 5 | Flutter (Official) | Flutter Testing | 12 | https://youtube.com/playlist?list=PLjxrf2q8roU3PjTZ2sDl3kY2lTQm2fLkN |
| 6 | Fireship | Flutter Firebase | 9 | https://youtube.com/playlist?list=PL0vfts4VzfNixQT9mJyrQZ3p4gM12jE5i |
| 7 | The Net Ninja | Flutter Tutorial for Beginners | 3, 4 | https://youtube.com/playlist?list=PL4cUxeGkcC9jLYyp2Aoh6hcWIVFDZhi1J |
| 8 | The Net Ninja | State Management (Riverpod) | 6 | https://youtube.com/playlist?list=PL4cUxeGkcC9gjxL2V4VEVhOabN3C6sKOk |
| 9 | Vandad Nahavandipoor | Flutter Tutorials | 3, 4, 5 | https://youtube.com/playlist?list=PL6yRaaP0WPkVTOeN108RZAGet5n2MlQb- |
| 10 | Robert Brunhage | Riverpod 2.0 | 6 | https://youtube.com/playlist?list=PLnBvgoOXZNCOiVH4xMV-DAC2kmFYvTcBy |
| 11 | Rivaan Ranawat | Flutter Tutorials | 4, 15 | https://youtube.com/playlist?list=PLMcxgeGEZutAHbgFn3vvBQ5hF6Yh-B2Vq |
| 12 | Code With Andrea | State Management Guide | 6 | https://youtube.com/playlist?list=PLNQvYATPbpvIINHL7tozmck66o8eKf5l9 |
| 13 | Flutterly | Flutter Animations | 11 | https://youtube.com/playlist?list=PLslGZnQoQ4E5PM9VUpK1Jq4T_fSdkA6jf |
| 14 | Reso Coder | Clean Architecture with Flutter | 10 | https://youtube.com/playlist?list=PLB6lc7nQ1n4jSBMK2c1EzFT8_7PJfM3Kv |
| 15 | dbestech | Flutter Full Apps | 7, 9, 15 | https://youtube.com/playlist?list=PLFyjjoCMAPtxnN2vWNkYRWoRpv9F3JvLm |
| 16 | Johannes Milke | Flutter Tips & Tricks | 4, 8 | https://youtube.com/@JohannesMilke |
| 17 | Tadas Petra | Flutter Bloc | 6 | https://youtube.com/@tadaspetra |
| 18 | Marcus Ng | Flutter Firebase | 9 | https://youtube.com/@marcusng |
| 19 | freeCodeCamp | Flutter Full Course | 3, 4 | https://youtube.com/watch?v=VPvVD8t02U8 |
| 20 | Dart (Official) | Dart Language Tutorials | 3 | https://youtube.com/playlist?list=PLjxrf2q8roU1fzIqUx1Jj3zY6J9Wv2kNz |

> 💡 **Pro tip:** Watch at 1.25x–1.5x speed. Pause and code along. Do NOT just binge-watch — build each project yourself.

---

## 18. Progress Checklists

### 18.1 Dart Fundamentals

- [ ] Variables (`var`, `final`, `const`)
- [ ] Built-in types (`String`, `int`, `double`, `bool`)
- [ ] Null safety (`?`, `!`, `??`, `late`)
- [ ] Control flow (`if`, `for`, `while`, `switch`)
- [ ] Functions (parameters, arrows, anonymous)
- [ ] Collections (`List`, `Set`, `Map`, spread, collection-if)
- [ ] OOP (classes, extends, mixins, abstract, interfaces)
- [ ] Dart 3 features (records, patterns, sealed classes)
- [ ] Async/await (`Future`, `Stream`)
- [ ] Error handling (`try`/`catch`/`finally`)
- [ ] Isolates and `compute()`
- [ ] Extensions and generics

### 18.2 Flutter Widgets & UI

- [ ] `MaterialApp` and `Scaffold`
- [ ] `StatelessWidget` vs `StatefulWidget`
- [ ] Layout widgets: `Row`, `Column`, `Stack`, `Container`, `SizedBox`, `Expanded`
- [ ] `ListView`, `GridView`, `CustomScrollView`
- [ ] `TextField`, `Form`, form validation
- [ ] `Image` (network, asset, cached)
- [ ] `Button` variants: `Elevated`, `Text`, `Outlined`, `Icon`
- [ ] `BottomNavigationBar`, `TabBar`, `Drawer`
- [ ] `AlertDialog`, `BottomSheet`, `SnackBar`
- [ ] `SafeArea`, `MediaQuery`, `LayoutBuilder`
- [ ] Cupertino widgets (iOS-style)
- [ ] `CustomPaint` / `CustomPainter`
- [ ] Themes: `ThemeData`, `Theme.of`, `TextTheme`

### 18.3 Navigation

- [ ] `Navigator.push` / `Navigator.pop`
- [ ] Named routes
- [ ] Passing arguments
- [ ] Returning results
- [ ] `GoRouter` setup and routes
- [ ] Path parameters and query parameters
- [ ] Nested routes
- [ ] Redirects and guards
- [ ] Deep linking configuration
- [ ] Custom transitions
- [ ] `Navigator 2.0` (declarative)

### 18.4 State Management

- [ ] Provider: `ChangeNotifierProvider`, `MultiProvider`
- [ ] Provider: `context.watch`, `context.read`, `context.select`
- [ ] Provider: `Consumer`, `Selector`
- [ ] Provider: ProxyProvider, FutureProvider
- [ ] Riverpod: `Provider`, `StateProvider`, `FutureProvider`
- [ ] Riverpod: `StateNotifierProvider`, `StreamProvider`
- [ ] Riverpod: `autoDispose`, `family`
- [ ] Riverpod: code generation (`@riverpod`)
- [ ] Riverpod: `ref.watch`, `ref.read`, `ref.listen`, `ref.invalidate`
- [ ] Bloc: Events, States, Bloc, Cubit
- [ ] Bloc: `BlocProvider`, `BlocBuilder`, `BlocListener`, `BlocConsumer`
- [ ] Bloc: `BlocSelector`, `buildWhen`, `listenWhen`
- [ ] Bloc: `bloc_test` for unit testing

### 18.5 Networking

- [ ] `http` package GET/POST/PUT/DELETE
- [ ] JSON serialization (`jsonEncode`/`jsonDecode`)
- [ ] Model classes with `fromJson`/`toJson`
- [ ] Dio setup with interceptors
- [ ] Dio error handling and retry
- [ ] Retrofit code generation
- [ ] GraphQL queries and mutations
- [ ] GraphQL subscriptions
- [ ] Caching strategies
- [ ] Offline-first patterns

### 18.6 Local Storage

- [ ] `SharedPreferences` (simple KV)
- [ ] Hive: boxes, adapters, lazy boxes
- [ ] Hive: encryption, compression
- [ ] sqflite: database init, CRUD, raw queries
- [ ] Drift: table definitions, database class, DAOs
- [ ] Drift: migrations, custom queries, streams
- [ ] Isar: schema, CRUD, filters, links
- [ ] Isar: full-text search, watchers
- [ ] Compare and choose the right storage

### 18.7 Firebase

- [ ] Firebase project setup
- [ ] Firebase Auth: email/password
- [ ] Firebase Auth: Google, Apple, Phone, Anonymous
- [ ] Auth state stream
- [ ] Firestore: CRUD operations
- [ ] Firestore: real-time listeners
- [ ] Firestore: queries, compound queries, ordering, limits
- [ ] Firestore: subcollections, batch writes, transactions
- [ ] Firestore: security rules
- [ ] Firebase Storage: upload, download, images
- [ ] Cloud Functions: callable, triggers
- [ ] FCM: push notifications
- [ ] Offline persistence

### 18.8 Architecture

- [ ] MVVM pattern
- [ ] Repository pattern
- [ ] Clean Architecture (data/domain/presentation)
- [ ] Dependency Injection (get_it)
- [ ] Dependency Injection (Riverpod)
- [ ] Use cases / interactors
- [ ] Data sources (remote and local)
- [ ] Mappers between DTOs and entities
- [ ] Error handling in layers
- [ ] Feature-first project structure

### 18.9 Animations

- [ ] `AnimatedContainer`, `AnimatedOpacity`, `AnimatedPadding`
- [ ] `TweenAnimationBuilder`
- [ ] `AnimationController` lifecycle
- [ ] `Tween` and `CurvedAnimation`
- [ ] `AnimatedBuilder`
- [ ] `Hero` animations
- [ ] Staggered animations
- [ ] `SlideTransition`, `ScaleTransition`, `FadeTransition`
- [ ] Lottie animations
- [ ] Rive interactive animations
- [ ] Custom transitions with GoRouter

### 18.10 Testing & CI/CD

- [ ] Unit tests with `test` package
- [ ] `blocTest` for Bloc testing
- [ ] Widget tests with `flutter_test`
- [ ] `find`, `pumpWidget`, `pump`, `pumpAndSettle`
- [ ] Mocking with `mocktail`
- [ ] Integration tests
- [ ] Golden file tests
- [ ] GitHub Actions: analyze + test
- [ ] GitHub Actions: build APK/IPA
- [ ] Codemagic: build and deploy
- [ ] Fastlane: automate store upload

### 18.11 Deployment

- [ ] Android: keystore generation
- [ ] Android: app signing
- [ ] Android: app bundle build
- [ ] Android: Google Play Console setup
- [ ] iOS: certificates and provisioning profiles
- [ ] iOS: App Store Connect setup
- [ ] iOS: IPA build and upload
- [ ] Flavors: dev/staging/prod
- [ ] In-app purchases integration
- [ ] AdMob / Google Mobile Ads
- [ ] Version management
- [ ] App store screenshots (screenshot automation)

---

## 19. Learning Timeline (6-Month Plan)

### Month 1: Foundations 🟢

| Week | Focus | Goals | Projects |
|------|-------|-------|----------|
| **1** | Dart basics | Variables, types, control flow, functions, collections | Code in DartPad |
| **2** | Dart OOP | Classes, inheritance, mixins, async, null safety, streams | Small scripts: JSON reader, file parser |
| **3** | Flutter intro | `flutter create`, project structure, first widget, hot reload | Hello World, static profile screen |
| **4** | Layouts & state | Row/Column/Stack, StatefulWidget, setState, forms, lists | Todo list (setState), BMI calculator |
| **5** | Navigation | Navigator push/pop, named routes, passing args | Multi-screen profile app |
| **6** | Review & polish | Theme, custom fonts, images, list details | Portfolio app with animations |

### Month 2: Intermediate 🟡

| Week | Focus | Goals | Projects |
|------|-------|-------|----------|
| **7** | Provider | ChangeNotifier, MultiProvider, Consumer, context.watch/read | Refactor apps to use Provider |
| **8** | REST APIs | http package, JSON parsing, model classes, error handling | Weather app (OpenWeatherMap API) |
| **9** | Dio & Retrofit | Interceptors, Dio setup, Retrofit code-gen | Refactor weather app with Dio |
| **10** | Local Storage | SharedPreferences, Hive (boxes, adapters) | Note-taking app with Hive |
| **11** | Firebase Auth + Firestore | Auth state, CRUD, realtime listeners | Chat UI with Firebase |
| **12** | GoRouter | Declarative routing, deep links, redirects | Refactor navigation, add auth guard |

### Month 3: Advanced Tools 🔵

| Week | Focus | Goals | Projects |
|------|-------|-------|----------|
| **13** | Riverpod | StateProvider, FutureProvider, StateNotifierProvider | Convert Provider apps to Riverpod |
| **14** | Riverpod advanced | autoDispose, family, code-gen | E-commerce cart with Riverpod |
| **15** | Bloc/Cubit | Events, states, BlocBuilder, BlocListener, blocTest | Counter → full app with Bloc |
| **16** | Animations | Implicit, explicit, Hero, staggered, Lottie | Interactive onboarding, splash screen |
| **17** | GraphQL | graphql_flutter, queries, mutations, subscriptions | GitHub client / blog reader |
| **18** | Drift / Isar | Type-safe ORM, migrations, relationships | Expense tracker with Drift |

### Month 4: Architecture & Firebase 🔴

| Week | Focus | Goals | Projects |
|------|-------|-------|----------|
| **19** | Clean Architecture | data/domain/presentation layers, repository pattern | Restructure e-commerce app |
| **20** | DI & Testing | get_it, Riverpod DI, unit tests, mocktail | Write tests for Clean Architecture app |
| **21** | Firebase Storage + Functions | Image upload, callable functions, FCM | Social media clone — post images |
| **22** | Widget testing | pumpWidget, find, matchers, golden tests | Write widget tests for existing apps |
| **23** | Integration testing | Integration test driver, screenshots | Write E2E tests for chat app |
| **24** | CI/CD | GitHub Actions, Codemagic setup | Automate build + test for a project |

### Month 5: Production Ready 🏭

| Week | Focus | Goals | Projects |
|------|-------|-------|----------|
| **25** | Flavors & Signing | Dev/staging/prod, keystore, provisioning | Set up flavors for e-commerce app |
| **26** | Play Store | Console setup, app bundle, store listing | Deploy Android app to Internal track |
| **27** | App Store | Certificates, TestFlight, App Store Connect | Deploy iOS app to TestFlight |
| **28** | Performance | DevTools, profiling, shader warmup, memory | Profile and optimize a production app |
| **29** | IAP & Ads | in_app_purchase, google_mobile_ads | Add monetization to an existing app |
| **30** | Notifications | FCM deep integration, local notifications | Notification-driven features |

### Month 6: Mastery & Portfolio 🚀

| Week | Focus | Goals | Projects |
|------|-------|-------|----------|
| **31** | Platform channels | MethodChannel, EventChannel, Pigeon | Hardware integration (BLE, NFC) |
| **32** | Desktop & Web | Responsive layout, desktop menus, web SEO | Port app to web + desktop |
| **33** | Open source | Contribute to a Flutter/Dart package | PR to pub.dev package |
| **34** | Portfolio | Polish portfolio apps, README screenshots | Publish 3 polished apps to GitHub |
| **35** | Mock interviews | System design, Flutter architecture Q&A | Practice with peers |
| **36** | Job search | Resume, GitHub, LinkedIn, freelancing | Apply to 10+ positions |

---

## 20. Career Roadmap

### 20.1 Flutter Developer Career Levels

#### 🟢 Junior Flutter Developer (0–2 years)

| Skill | Expectation |
|-------|-------------|
| Dart | Basic — variables, classes, async, null safety |
| Widgets | Common widgets, basic layout, theming |
| State | setState, Provider basics |
| API | http/JSON, basic error handling |
| Firebase | Auth + Firestore CRUD |
| Testing | Basic unit tests |
| Git | Branching, PRs, merge conflicts |

- **Salary range (2026):**
  - 🇺🇸 US: $70k–$90k
  - 🇮🇳 India: ₹6L–₹12L
  - 🇪🇺 Europe: €35k–€55k
  - 🌍 Remote: $40k–$60k

#### 🟡 Mid-Level Flutter Developer (2–5 years)

| Skill | Expectation |
|-------|-------------|
| Dart | Advanced: isolates, streams, Dart 3 features |
| State | Riverpod or Bloc mastery |
| Architecture | Clean Architecture, MVVM, Repository |
| CI/CD | GitHub Actions, Codemagic, Fastlane |
| Testing | Widget + integration + golden tests |
| Performance | Profiling, lazy loading, memory optimization |
| Platform | Both stores, IAP, ads, push notifications |

- **Salary range (2026):**
  - 🇺🇸 US: $95k–$130k
  - 🇮🇳 India: ₹15L–₹25L
  - 🇪🇺 Europe: €55k–€85k
  - 🌍 Remote: $70k–$100k

#### 🔴 Senior Flutter Developer (5+ years)

| Skill | Expectation |
|-------|-------------|
| Architecture | Design system-level architecture, tech stack decisions |
| Leadership | Code reviews, mentoring, sprint planning |
| Cross-team | Coordinating with design, backend, QA |
| Custom packages | Publishing and maintaining packages |
| Performance | Deep performance tuning, Impeller optimization |
| Multi-platform | Web, desktop, mobile simultaneously |
| Open source | Community contributions, Flutter ecosystem |

- **Salary range (2026):**
  - 🇺🇸 US: $130k–$180k+
  - 🇮🇳 India: ₹30L–₹60L+
  - 🇪🇺 Europe: €85k–€130k+
  - 🌍 Remote: $100k–$150k+

#### 🏆 Lead / Staff / Principal (8+ years)

- Leads multiple squads
- Drives Flutter adoption across the organization
- Contributes to Flutter framework (Google patches)
- Architects cross-platform strategies
- **Salary:** $150k–$250k+ (US), ₹50L–₹1Cr+ (India)

### 20.2 Portfolio Building

```
portfolio/
├── README.md              # Your story, tech stack, links
├── lib/
│   ├── main.dart
│   ├── projects/
│   │   ├── weather_app/
│   │   ├── ecommerce_app/
│   │   ├── chat_app/
│   │   └── fitness_tracker/
├── assets/
│   ├── screenshots/
│   └── demo_gifs/
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── .github/workflows/     # CI/CD configs
├── pubspec.yaml
└── README.md per project  # Screenshots, features, challenges
```

### 20.3 What Employers Look For

- **GitHub profile** with 3+ well-documented projects
- **Clean code** — follows Dart style guide, linting passes
- **Testing** — visible test coverage in repos
- **Architecture** — Clean Architecture or similar
- **CI/CD** — green build badges
- **Published apps** — even 1 app in Play Store / App Store
- **Open source contributions** — PRs to popular packages
- **Blog posts** — Medium/dev.to articles about Flutter

### 20.4 Getting Hired in 2026

```
1. Portfolio (GitHub)        → 3 polished apps with READMEs
2. LinkedIn presence          → "Flutter Developer" + projects
3. Networking                 → Flutter Discord, Reddit r/FlutterDev, Twitter/X
4. Freelance (optional)       → Upwork, Fiverr — build real-world experience
5. Open source contributions  → 5+ PRs to major packages
6. Blog posts                 → 5 articles on Medium/dev.to
7. Certification              → Google Associate Android Developer (Flutter path)
8. Job platforms              → LinkedIn, Wellfound, Indeed, Flutter.dev jobs board
```

### 20.5 Stay Updated

| Resource | Why |
|----------|-----|
| https://flutter.dev/blog | Official updates |
| https://dart.dev | Language evolution |
| https://pub.dev/feed | New packages |
| Flutter YouTube channel | Release videos |
| Flutter Discord | Community + help |
| Flutter Reddit (r/FlutterDev) | Discussion |
| FlutterGems.dev | Curated packages |
| Awesome Flutter GitHub | Trending resources |

---

## 💡 Final Advice

> **"The only way to learn Flutter is to build Flutter apps."**

1. **Code every day.** Even 30 minutes. Consistency > intensity.
2. **Type out code.** Don't copy-paste. Muscle memory matters.
3. **Read error messages.** They tell you exactly what's wrong.
4. **Use `dart analyze`.** Zero warnings before commit.
5. **Learn the debugger.** Breakpoints > print statements.
6. **Read other people's code.** GitHub is your textbook.
7. **Build from scratch.** Follow tutorials but then rebuild without them.
8. **Write tests.** They save hours of manual QA.
9. **Ship something.** Nothing teaches like a real user hitting bugs.
10. **Enjoy it.** Flutter is genuinely fun. The instant hot reload loop is addictive.

---

> **This roadmap is a living document. Flutter evolves fast — star the official blog and keep your skills current.**

---

*Roadmap generated June 2026 — accurate for Flutter 3.x and Dart 3.x.*
