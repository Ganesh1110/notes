# 🚀 Advanced React Native Roadmap 2026

> **For experienced React Native developers (4+ years)** — Deep-dive into production architecture, performance, native modules, and shipping at scale.

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. New Architecture (Fabric + Turbo Modules + JSI)](#2-new-architecture-fabric--turbo-modules--jsi)
- [3. Advanced Expo & CLI](#3-advanced-expo--cli)
- [4. Navigation: Deep Linking, Auth Flows, Screen Tracking](#4-navigation-deep-linking-auth-flows-screen-tracking)
- [5. State Management: Beyond the Basics](#5-state-management-beyond-the-basics)
- [6. API Integration: Production Patterns](#6-api-integration-production-patterns)
- [7. Native Modules & JSI](#7-native-modules--jsi)
- [8. Advanced Permissions Patterns](#8-advanced-permissions-patterns)
- [9. Firebase at Scale](#9-firebase-at-scale)
- [10. Offline Storage: Sync, Encryption, Multi-Process](#10-offline-storage-sync-encryption-multi-process)
- [11. Performance Optimization: Profiling & Deep Dives](#11-performance-optimization-profiling--deep-dives)
- [12. Testing: E2E, Snapshot, Performance Regression](#12-testing-e2e-snapshot-performance-regression)
- [13. CI/CD: Matrix Builds, OTA, Rollback Strategies](#13-cicd-matrix-builds-ota-rollback-strategies)
- [14. Android & iOS Deployment: Signing, Flavors, ASO](#14-android--ios-deployment-signing-flavors-aso)
- [15. Production Architecture: Monorepo, Codegen, Server-Driven UI](#15-production-architecture-monorepo-codegen-server-driven-ui)
- [16. Animations: Reanimated, Skia, Lottie, Layout](#16-animations-reanimated-skia-lottie-layout)
- [17. Real-World Projects (Advanced)](#17-real-world-projects-advanced)
- [18. Best YouTube Channels & Resources](#18-best-youtube-channels--resources)
- [19. Career: Senior → Staff → Lead](#19-career-senior--staff--lead)
- [20. Appendix: Production Cheatsheet](#20-appendix-production-cheatsheet)

---

## 1. Overview

This roadmap assumes you have **4+ years of React Native experience** using JavaScript. You already know:

- React hooks, components, navigation, state management
- Expo CLI and bare workflow
- API integration, Firebase, and basic storage
- Publishing to iOS and Android

**What this guide covers instead:**

- The React Native New Architecture (Fabric, Turbo Modules, JSI, Codegen)
- Building and shipping production apps at scale
- Deep performance profiling and optimization
- Custom native modules (Swift/Kotlin/Objective-C/C++)
- Monorepo patterns, code generation, server-driven UI
- Advanced animations with Reanimated and Skia
- CI/CD matrix builds, OTA distribution, rollback strategies
- System design for mobile: offline-first, optimistic UI, background sync

---

### ⬜ Mastery Checklist

- [ ] Enable New Architecture (Fabric + Turbo Modules) in production
- [ ] Build and publish a custom Expo module (native code)
- [ ] Achieve 60 FPS on a mid-range Android device
- [ ] Reduce TTI (Time to Interactive) under 2 seconds
- [ ] Ship OTA updates with rollback capability
- [ ] Set up a monorepo with shared packages
- [ ] Implement offline-first with WatermelonDB or sync adapter
- [ ] Write E2E tests with Detox
- [ ] Profiled and resolved a real memory leak
- [ ] Published a custom native Turbo Module

---

## 2. New Architecture (Fabric + Turbo Modules + JSI)

React Native's New Architecture has been stable since RN 0.76 (late 2024). It replaces the old bridge with **Fabric** (rendering) and **Turbo Modules** (native modules), communicating via **JSI** (JavaScript Interface).

### 2.1 Why the New Architecture Matters

| Aspect | Old Bridge | New Architecture (JSI) |
|--------|-----------|----------------------|
| Communication | Async serialized JSON over bridge | Synchronous C++ calls via JSI |
| Native module calls | Serialized, batched, async | Direct function calls |
| Rendering | Async shadow tree → native | Synchronous C++ Yoga layout |
| Memory | Multiple copies of data | Shared C++ host objects |
| Concurrency | Serial queue | Concurrent rendering (React 18+) |
| Type safety | Manual prop types | Codegen-generated types |

### 2.2 Fabric: The New Renderer

Fabric replaces the old UIManager with a synchronous rendering pipeline:

```
  JS Thread (JSI)          UI Thread (Fabric)
  ┌──────────────┐       ┌──────────────────────┐
  │ createElement │ ──►   │  Shadow Tree (C++)   │
  │   (React)    │       │  Yoga Layout Engine   │
  └──────────────┘       └──────────┬───────────┘
                                    │ mount (synchronous)
                             ┌──────▼───────┐
                             │  Host Views   │
                             │ (native UIs)  │
                             └──────────────┘
```

**Key benefits:**
- Layout is computed synchronously in C++ (no async gap)
- Mount operations are batched and atomic
- Supports React 18 concurrent features (Suspense, Transitions)
- View flattening reduces the native view hierarchy

**Enabling Fabric (RN 0.76+):**

```js
// react-native.config.js (bare RN)
module.exports = {
  project: {
    ios: {},
    android: {},
  },
};
```

```js
// android/gradle.properties
newArchEnabled=true
```

For Expo SDK 52+, Fabric is the default. You can opt-out with:

```json
// app.json
{
  "expo": {
    "experiments": {
      "baseTurboModule": true
    }
  }
}
```

### 2.3 Turbo Modules

Turbo Modules replace the old `NativeModules` bridge. They're loaded lazily and callable synchronously via JSI.

**Old bridge module:**

```objc
// Old way — bridge-based
RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(doSomething:(NSString *)input resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
```

**Turbo Module (Objective-C):**

```objc
#import <React/RCTBridgeModule.h>

@interface MyTurboModule : NSObject <RCTBridgeModule>
@end

@implementation MyTurboModule

RCT_EXPORT_MODULE();

RCT_EXPORT_SYNC_METHOD(getDeviceName) {
  return [[UIDevice currentDevice] name];
}

RCT_EXPORT_METHOD(computeHeavy:(NSString *)data resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *result = [self heavyComputation:data];
    resolve(result);
  });
}

@end
```

**Using from JS:**

```js
import { NativeModules } from 'react-native';

// Synchronous call — no bridge overhead
const deviceName = NativeModules.MyTurboModule.getDeviceName();
console.log(deviceName);

// Async for heavy work
const result = await NativeModules.MyTurboModule.computeHeavy(input);
```

### 2.4 JSI (JavaScript Interface)

JSI is the C++ layer that enables JS to hold references to C++ host objects and call them directly — no serialization, no bridge queue.

**C++ JSI Host Object example:**

```cpp
#include <jsi/jsi.h>

using namespace facebook::jsi;

void installDatabaseModule(Runtime& runtime) {
  auto db = std::make_shared<Database>();

  auto dbObject = Object(runtime);
  dbObject.setProperty(runtime, "query", Function::createFromHostFunction(
    runtime,
    PropNameID::forAscii(runtime, "query"),
    1,
    [db](Runtime& rt, const Value& thisVal, const Value* args, size_t count) -> Value {
      if (count < 1 || !args[0].isString()) {
        throw JSError(rt, "query() requires a string argument");
      }
      auto sql = args[0].getString(rt).utf8(rt);
      auto result = db->executeQuery(sql);
      return Value(rt, String::createFromUtf8(rt, result.c_str()));
    }
  ));

  runtime.global().setProperty(runtime, "NativeDatabase", dbObject);
}
```

### 2.5 Codegen

Codegen automatically generates C++ and Kotlin/ObjC interfaces from JavaScript types. It's the backbone of type-safe Turbo Modules.

```js
// AppModules.js — Codegen specs
import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  +getDeviceName: () => string;
  +computeHeavy: (data: string) => Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('MyTurboModule');
```

> **💡 Tip:** Codegen eliminates the manual `RCT_EXPORT_METHOD` boilerplate. Your specs in JS define the native API contract.

### 2.6 Migration Strategy

| Phase | Actions |
|-------|---------|
| 1. Audit | Check all native dependencies for New Architecture compatibility |
| 2. Enable Flag | Set `newArchEnabled=true` in gradle.properties |
| 3. Test | Run full test suite, especially native integrations |
| 4. Fix Issues | Replace old NativeModules with TurboModule spec files |
| 5. Remove Bridge | Disable JSC (old JS engine), rely on Hermes + JSI |

**Common migration issues:**
- Libraries using `UIManager.dispatchViewManagerCommand` need Fabric-compatible variants
- `findNodeHandle` is deprecated under Fabric
- `processColor` is unavailable — use raw color values
- Some `onLayout` measurements behave differently

---

## 3. Advanced Expo & CLI

### 3.1 EAS Build: Multi-Profile Strategy

```json
{
  "build": {
    "production": {
      "android": {
        "buildType": "app-bundle",
        "gradleCommand": ":app:assembleRelease"
      },
      "ios": {
        "autoIncrement": true
      },
      "env": {
        "API_URL": "https://api.production.com",
        "SENTRY_DSN": "@SENTRY_DSN_PROD"
      }
    },
    "staging": {
      "extends": "production",
      "android": {
        "buildType": "apk",
        "gradleCommand": ":app:assembleStagingRelease"
      },
      "ios": {
        "scheme": "MyAppStaging"
      },
      "env": {
        "API_URL": "https://api.staging.com"
      }
    },
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "android": {
        "gradleCommand": ":app:assembleDevelopmentDebug"
      },
      "env": {
        "API_URL": "http://localhost:3000"
      }
    }
  }
}
```

### 3.2 EAS Update: OTA Distribution & Rollback

```bash
# Publish OTA update
npx eas update --branch production --message "Fix payment intent null check"

# Rollback to previous
npx eas update:rollback --branch production

# Targeted updates (channel-based)
npx eas update --branch beta --message "Test new onboarding flow"

# Update with git hash tracking
npx eas update --branch production --message "v2.3.1 hotfix"
```

**EAS Update branching strategy:**

```
production  ─── v2.3.0 ─── v2.3.1 (hotfix) ─── v2.4.0
                    \              \
staging        ──── v2.4.0-rc.1 ── v2.4.0-rc.2
                       \
development     ─────── feature/new-payment
```

**Runtime version management:**

```json
{
  "expo": {
    "runtimeVersion": {
      "policy": "appVersion"
    }
  }
}
```

Use `appVersion` policy so OTA updates only apply to matching app store versions. Bump native version → users must update from the store; JS-only changes → OTA works.

### 3.3 Expo Config Plugins: Deep Customization

Config plugins run during `npx expo prebuild` to modify native project files.

```js
// app.config.js
const { withAndroidManifest, withInfoPlist } = require('expo/config-plugins');

module.exports = function withCustomConfig(config) {
  // Modify Android Manifest
  config = withAndroidManifest(config, (modConfig) => {
    const manifest = modConfig.modResults;
    // Add custom permission
    manifest.manifest['uses-permission'] = [
      ...(manifest.manifest['uses-permission'] || []),
      { $: { 'android:name': 'android.permission.BLUETOOTH_CONNECT' } },
    ];
    return modConfig;
  });

  // Modify iOS Info.plist
  config = withInfoPlist(config, (modConfig) => {
    modConfig.modResults['NSBluetoothAlwaysUsageDescription'] =
      'We need Bluetooth to connect to your device';
    return modConfig;
  });

  // Add custom podspec dependency
  config = withPodfile(config, (modConfig) => {
    modConfig.modResults.contents += `
      pod 'Stripe', :modular_headers => true
    `;
    return modConfig;
  });

  return config;
};
```

### 3.4 App Extensions

**iOS Widget (WidgetKit) with Expo:**

```json
// app.json
{
  "expo": {
    "plugins": [
      [
        "expo-widget",
        {
          "widgets": [
            {
              "name": "TodoWidget",
              "description": "Show today's tasks",
              "kind": "com.myapp.todo-widget",
              "timelines": ["src/widgets/TodoWidget.tsx"]
            }
          ]
        }
      ]
    ]
  }
}
```

**iOS Share Extension:**

Config plugins can add share extensions, notification service extensions, and more. These require native code but can be managed through `expo-modules-core`.

### 3.5 Edge-to-Edge Display (Android 15+)

Android 15 enforces edge-to-edge rendering. The system bars are transparent by default.

```js
// Handle edge-to-edge for Android 15
import { Platform, StatusBar } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

function ScreenRoot({ children }) {
  const insets = useSafeAreaInsets();

  return (
    <View
      style={{
        flex: 1,
        paddingTop: Platform.OS === 'android' ? insets.top : 0,
        paddingBottom: insets.bottom,
      }}
    >
      {children}
    </View>
  );
}
```

---

## 4. Navigation: Deep Linking, Auth Flows, Screen Tracking

### 4.1 Deep Linking with Universal Links

```js
// Linking configuration
const linking = {
  prefixes: ['myapp://', 'https://myapp.com', 'https://*.myapp.com'],
  getInitialURL: async () => {
    // Handle cold start from notification
    const url = await Linking.getInitialURL();
    if (url) return url;
    // Check if app was opened from notification (Firebase)
    const message = await messaging().getInitialNotification();
    if (message?.data?.screen) {
      return `myapp://${message.data.screen}/${message.data.id}`;
    }
    return null;
  },
  subscribe: (listener) => {
    // Handle warm start
    const linkingSubscription = Linking.addEventListener('url', ({ url }) => {
      listener(url);
    });
    // Handle notification taps while app is in background
    const notificationSubscription = messaging().onNotificationOpenedApp((message) => {
      if (message.data?.screen) {
        listener(`myapp://${message.data.screen}/${message.data.id}`);
      }
    });
    return () => {
      linkingSubscription.remove();
      notificationSubscription();
    };
  },
  config: {
    screens: {
      Main: {
        screens: {
          Home: 'home',
          Profile: 'user/:userId',
          Post: 'post/:postId',
          Notifications: 'notifications',
        },
      },
      Auth: {
        screens: {
          Login: 'login',
          ResetPassword: 'reset-password/:token',
        },
      },
      DynamicLink: {
        path: 'link/:linkId',
        parse: {
          linkId: (linkId) => `${linkId}`,
        },
      },
    },
  },
};
```

### 4.2 Authentication Flow with State Persistence

```js
function RootNavigator() {
  const { user, isLoading, isRestoringToken } = useAuth();
  const [isReady, setIsReady] = useState(false);

  // Persist navigation state
  const [navState, setNavState] = useState(null);
  const onStateChange = useCallback((state) => {
    setNavState(state);
    storage.set('nav_state', JSON.stringify(state));
  }, []);

  // Restore navigation state
  useEffect(() => {
    const saved = storage.getString('nav_state');
    if (saved) {
      setNavState(JSON.parse(saved));
    }
    setIsReady(true);
  }, []);

  if (isLoading || !isReady) {
    return <SplashScreen />;
  }

  return (
    <NavigationContainer
      linking={linking}
      initialState={navState}
      onStateChange={onStateChange}
    >
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {user ? (
          <>
            <Stack.Screen name="Main" component={MainTabs} />
            {/* Modals */}
            <Stack.Screen
              name="CreatePost"
              component={CreatePostModal}
              options={{ presentation: 'modal' }}
            />
          </>
        ) : (
          <Stack.Screen name="Auth" component={AuthStack} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

### 4.3 Screen Tracking & Analytics

```js
function NavigationTracker({ children }) {
  const navigationRef = useNavigationContainerRef();
  const routeNameRef = useRef(null);

  const onReady = useCallback(() => {
    routeNameRef.current = navigationRef.getCurrentRoute().name;
  }, []);

  const onStateChange = useCallback(async (state) => {
    const previousRouteName = routeNameRef.current;
    const currentRouteName = navigationRef.getCurrentRoute().name;

    if (previousRouteName !== currentRouteName) {
      // Log screen view
      analytics().logScreenView({
        screen_name: currentRouteName,
        screen_class: currentRouteName,
      });
      crashlytics().log(`Navigated to ${currentRouteName}`);
    }

    routeNameRef.current = currentRouteName;
  }, []);

  return (
    <NavigationContainer
      ref={navigationRef}
      linking={linking}
      onReady={onReady}
      onStateChange={onStateChange}
    >
      {children}
    </NavigationContainer>
  );
}
```

### 4.4 Advanced Navigation Patterns

**Preloading screens for instant transitions:**

```js
function HomeScreen({ navigation }) {
  useEffect(() => {
    // Preload screen ahead of time
    navigation.preload('Profile', { userId: '123' });
  }, []);

  const handleUserPress = useCallback((userId) => {
    navigation.navigate('Profile', { userId });
  }, [navigation]);
}
```

**Screen-freezing with react-native-freeze (Fabric-aware):**

```js
// Prevents unmounting off-screen tabs (keeps state alive)
import { enableFreeze } from 'react-native-freeze';

// Enable globally
enableFreeze(true);
```

---

## 5. State Management: Beyond the Basics

### 5.1 Redux Toolkit: Advanced Patterns

**Optimistic updates with rollback:**

```js
import { createAsyncThunk, createSlice } from '@reduxjs/toolkit';

const updatePost = createAsyncThunk(
  'posts/update',
  async ({ postId, changes }, { rejectWithValue, getState }) => {
    const state = getState();
    const previousPost = state.posts.entities[postId];

    try {
      // Send API request
      const response = await api.patch(`/posts/${postId}`, changes);
      return response.data;
    } catch (error) {
      // Reject with previous data for rollback
      return rejectWithValue({ postId, previousPost, error: error.message });
    }
  },
  {
    // Optimistic update immediately
    condition: ({ postId, changes }, { getState }) => {
      const state = getState();
      const post = state.posts.entities[postId];
      if (!post) return false;
      return true;
    },
  }
);

const postsSlice = createSlice({
  name: 'posts',
  initialState: { entities: {}, status: 'idle', error: null },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(updatePost.pending, (state, action) => {
        const { postId, changes } = action.meta.arg;
        // Apply changes immediately
        state.entities[postId] = { ...state.entities[postId], ...changes };
      })
      .addCase(updatePost.rejected, (state, action) => {
        const { postId, previousPost } = action.payload;
        // Rollback on failure
        state.entities[postId] = previousPost;
        state.error = action.payload.error;
      });
  },
});
```

**Entity adapters for normalized data:**

```js
import { createEntityAdapter, createSlice } from '@reduxjs/toolkit';

const postsAdapter = createEntityAdapter({
  selectId: (post) => post.id,
  sortComparer: (a, b) => b.createdAt.localeCompare(a.createdAt),
});

const postsSlice = createSlice({
  name: 'posts',
  initialState: postsAdapter.getInitialState({
    loading: false,
    cursor: null,
    hasMore: true,
  }),
  reducers: {
    addManyPosts: postsAdapter.addMany,
    updatePost: postsAdapter.updateOne,
    removePost: postsAdapter.removeOne,
    clearPosts: postsAdapter.removeAll,
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchPosts.fulfilled, (state, action) => {
        postsAdapter.upsertMany(state, action.payload.items);
        state.cursor = action.payload.cursor;
        state.hasMore = action.payload.hasMore;
        state.loading = false;
      });
  },
});

export const {
  selectById: selectPostById,
  selectIds: selectPostIds,
  selectAll: selectAllPosts,
} = postsAdapter.getSelectors((state) => state.posts);
```

### 5.2 Zustand: Middleware & Complex Stores

**Persist + Immer + DevTools middleware stack:**

```js
import { create } from 'zustand';
import { immer } from 'zustand/middleware/immer';
import { persist, createJSONStorage, devtools } from 'zustand/middleware';
import { storage } from './mmkv';

const useCartStore = create(
  devtools(
    persist(
      immer((set, get) => ({
        items: [],
        total: 0,
        addItem: (item) =>
          set((state) => {
            const existing = state.items.find((i) => i.id === item.id);
            if (existing) {
              existing.quantity += 1;
            } else {
              state.items.push({ ...item, quantity: 1 });
            }
            state.total = state.items.reduce(
              (sum, i) => sum + i.price * i.quantity,
              0
            );
          }),
        removeItem: (id) =>
          set((state) => {
            state.items = state.items.filter((i) => i.id !== id);
            state.total = state.items.reduce(
              (sum, i) => sum + i.price * i.quantity,
              0
            );
          }),
        clearCart: () => set({ items: [], total: 0 }),
      })),
      {
        name: 'cart-storage',
        storage: createJSONStorage(() => ({
          getItem: (key) => storage.getString(key),
          setItem: (key, value) => storage.set(key, value),
          removeItem: (key) => storage.delete(key),
        })),
        partialize: (state) => ({ items: state.items }),
      }
    ),
    { name: 'CartStore', enabled: __DEV__ }
  )
);
```

**Using Zustand outside React:**

```js
// Navigation interceptor
navigation.addListener('beforeRemove', (e) => {
  const { items } = useCartStore.getState();
  if (items.length > 0) {
    e.preventDefault();
    showDiscardDialog();
  }
});

// Background sync
BackgroundTask.define(async () => {
  const { items } = useCartStore.getState();
  await syncCart(items);
});
```

### 5.3 State Machines with XState

XState is excellent for complex flows (onboarding, checkout, multi-step forms).

```js
import { createMachine, interpret } from 'xstate';

const checkoutMachine = createMachine({
  id: 'checkout',
  initial: 'idle',
  context: {
    cart: [],
    shipping: null,
    payment: null,
    error: null,
  },
  states: {
    idle: {
      on: { START: 'shipping' },
    },
    shipping: {
      on: {
        SUBMIT_SHIPPING: {
          target: 'payment',
          actions: 'assignShipping',
        },
        BACK: 'idle',
      },
    },
    payment: {
      on: {
        SUBMIT_PAYMENT: 'processing',
        BACK: 'shipping',
      },
    },
    processing: {
      invoke: {
        src: 'processPayment',
        onDone: 'success',
        onError: {
          target: 'payment',
          actions: 'assignError',
        },
      },
    },
    success: {
      type: 'final',
    },
  },
}, {
  actions: {
    assignShipping: (context, event) => {
      context.shipping = event.shippingData;
    },
    assignError: (context, event) => {
      context.error = event.data;
    },
  },
  services: {
    processPayment: async (context) => {
      const response = await api.post('/checkout', {
        cart: context.cart,
        shipping: context.shipping,
        payment: context.payment,
      });
      return response.data;
    },
  },
});

// Usage in component
function CheckoutFlow() {
  const [state, send] = useMachine(checkoutMachine);

  if (state.matches('shipping')) {
    return <ShippingForm onSubmit={(data) => send('SUBMIT_SHIPPING', { shippingData: data })} />;
  }
  if (state.matches('payment')) {
    return <PaymentForm onSubmit={(data) => send('SUBMIT_PAYMENT')} />;
  }
  if (state.matches('processing')) {
    return <LoadingScreen />;
  }
  if (state.matches('success')) {
    return <OrderConfirmation />;
  }
}
```

---

## 6. API Integration: Production Patterns

### 6.1 Axios: Interceptors, Cancellation, Retry

```js
import axios from 'axios';
import NetInfo from '@react-native-community/netinfo';

const api = axios.create({
  baseURL: 'https://api.example.com/v2',
  timeout: 15000,
  headers: { 'Content-Type': 'application/json' },
});

// Request interceptor — attach token
api.interceptors.request.use((config) => {
  const token = storage.getString('auth_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  // Log request in dev
  if (__DEV__) {
    console.log(`🔷 ${config.method.toUpperCase()} ${config.url}`);
  }
  return config;
});

// Response interceptor — token refresh, error normalization
let isRefreshing = false;
let failedQueue = [];

const processQueue = (error, token = null) => {
  failedQueue.forEach(({ resolve, reject }) => {
    if (error) {
      reject(error);
    } else {
      resolve(token);
    }
  });
  failedQueue = [];
};

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        // Queue the request while token refreshes
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject });
        }).then((token) => {
          originalRequest.headers.Authorization = `Bearer ${token}`;
          return api(originalRequest);
        });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        const refreshToken = storage.getString('refresh_token');
        const { data } = await axios.post('https://api.example.com/auth/refresh', {
          refreshToken,
        });
        storage.set('auth_token', data.accessToken);
        processQueue(null, data.accessToken);
        originalRequest.headers.Authorization = `Bearer ${data.accessToken}`;
        return api(originalRequest);
      } catch (refreshError) {
        processQueue(refreshError, null);
        // Force logout
        navigationRef.navigate('Auth');
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    // Normalize error
    const normalizedError = {
      message: error.response?.data?.message || error.message || 'Unknown error',
      status: error.response?.status,
      code: error.response?.data?.code,
      data: error.response?.data,
    };

    return Promise.reject(normalizedError);
  }
);

// Network-aware retry
async function requestWithRetry(config, maxRetries = 3) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const netState = await NetInfo.fetch();
      if (!netState.isConnected) {
        throw new Error('No internet connection');
      }
      return await api(config);
    } catch (error) {
      if (attempt === maxRetries - 1) throw error;
      // Exponential backoff
      await new Promise((r) => setTimeout(r, 1000 * Math.pow(2, attempt)));
    }
  }
}

// Request cancellation
const cancelTokenSource = axios.CancelToken.source();

api.get('/search', {
  cancelToken: cancelTokenSource.token,
  params: { q: searchQuery },
});

// Cancel on unmount or new request
useEffect(() => {
  return () => cancelTokenSource.cancel('Component unmounted');
}, []);
```

### 6.2 TanStack Query: Advanced Patterns

**Infinite query with cursor pagination:**

```js
import { useInfiniteQuery, useQueryClient } from '@tanstack/react-query';

function useInfinitePosts() {
  return useInfiniteQuery({
    queryKey: ['posts', 'infinite'],
    queryFn: async ({ pageParam = null }) => {
      const params = { limit: 20 };
      if (pageParam) params.cursor = pageParam;

      const response = await api.get('/posts', { params });
      return {
        items: response.data.items,
        cursor: response.data.nextCursor,
        hasMore: response.data.hasMore,
      };
    },
    getNextPageParam: (lastPage) => lastPage.hasMore ? lastPage.cursor : undefined,
    staleTime: 5 * 60 * 1000,
    gcTime: 30 * 60 * 1000,
    refetchOnWindowFocus: false,
  });
}

// Usage
function PostList() {
  const {
    data,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
  } = useInfinitePosts();

  const allPosts = data?.pages.flatMap((page) => page.items) ?? [];

  const handleEndReached = useCallback(() => {
    if (hasNextPage && !isFetchingNextPage) {
      fetchNextPage();
    }
  }, [hasNextPage, isFetchingNextPage, fetchNextPage]);

  return (
    <FlatList
      data={allPosts}
      renderItem={renderPost}
      keyExtractor={(item) => item.id}
      onEndReached={handleEndReached}
      onEndReachedThreshold={0.5}
      ListFooterComponent={isFetchingNextPage && <Loader />}
    />
  );
}
```

**Optimistic updates with rollback UI:**

```js
const mutation = useMutation({
  mutationFn: (newPost) => api.post('/posts', newPost),
  onMutate: async (newPost) => {
    // Cancel outgoing refetches
    await queryClient.cancelQueries({ queryKey: ['posts'] });

    // Snapshot previous value
    const previousPosts = queryClient.getQueryData(['posts']);

    // Optimistically update
    queryClient.setQueryData(['posts'], (old) => ({
      ...old,
      pages: old.pages.map((page, i) =>
        i === 0
          ? { ...page, items: [newPost, ...page.items] }
          : page
      ),
    }));

    return { previousPosts };
  },
  onError: (error, newPost, context) => {
    // Rollback on error
    queryClient.setQueryData(['posts'], context.previousPosts);
    showToast('Failed to create post');
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['posts'] });
  },
});
```

**Polling with smart interval:**

```js
function useLiveOrders() {
  return useQuery({
    queryKey: ['orders', 'live'],
    queryFn: () => api.get('/orders/live'),
    refetchInterval: (query) => {
      // Poll every 2s if there are pending orders, stop if all resolved
      const data = query.state.data?.data;
      if (!data || data.length === 0) return false;
      const hasPending = data.some((order) => order.status === 'pending');
      return hasPending ? 2000 : 30000;
    },
  });
}
```

### 6.3 GraphQL Subscriptions

```js
import { ApolloClient, InMemoryCache, split, HttpLink } from '@apollo/client';
import { GraphQLWsLink } from '@apollo/client/link/subscriptions';
import { getMainDefinition } from '@apollo/client/utilities';
import { createClient } from 'graphql-ws';

const httpLink = new HttpLink({
  uri: 'https://api.example.com/graphql',
});

const wsLink = new GraphQLWsLink(
  createClient({
    url: 'wss://api.example.com/graphql',
    connectionParams: {
      authToken: storage.getString('auth_token'),
    },
    retryAttempts: 10,
    shouldRetry: () => true,
    on: {
      connected: () => console.log('WS connected'),
      closed: () => console.log('WS closed'),
      error: (error) => console.error('WS error', error),
    },
  })
);

const splitLink = split(
  ({ query }) => {
    const definition = getMainDefinition(query);
    return (
      definition.kind === 'OperationDefinition' &&
      definition.operation === 'subscription'
    );
  },
  wsLink,
  httpLink
);

const client = new ApolloClient({
  link: splitLink,
  cache: new InMemoryCache(),
});

// React component
function useOrderSubscription(orderId) {
  const { data, loading } = useSubscription(gql`
    subscription OnOrderUpdated($orderId: ID!) {
      orderUpdated(orderId: $orderId) {
        id
        status
        eta
        driverLocation {
          lat
          lng
        }
      }
    }
  `, {
    variables: { orderId },
    onData: ({ data }) => {
      // Play notification sound on status change
      if (data.orderUpdated.status === 'delivered') {
        playSound('order_delivered');
      }
    },
  });

  return data?.orderUpdated;
}
```

---

## 7. Native Modules & JSI

### 7.1 Expo Modules API (Production Path)

The recommended approach for new native modules. Works with both Expo and bare RN.

```bash
npx create-expo-module my-module
```

```swift
// ios/MyModule.swift
import ExpoModulesCore

public class MyModule: Module {
  public func definition() -> ModuleDefinition {
    Name("MyModule")

    // Synchronous function
    Function("getDeviceLocale") {
      return Locale.current.identifier
    }

    // Async function
    AsyncFunction("computeHash") { (input: String) -> String in
      let hash = try await HeavyComputation.compute(input)
      return hash
    }

    // Events
    Events("onProgress")

    // Module constants
    Constants([
      "version": "1.0.0",
      "platform": "ios"
    ])

    // View (Fabric component)
    View(MyCustomView.self) {
      Prop("color") { (view: MyCustomView, color: UIColor) in
        view.backgroundColor = color
      }
      Events("onTap")
    }

    // Lifecycle
    OnCreate {
      // Module initialized
    }

    OnDestroy {
      // Cleanup
    }
  }
}
```

```kotlin
// android/MyModule.kt
package expo.modules.mymodule

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.def
import expo.modules.kotlin.functions.AsyncFunction

class MyModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("MyModule")

    Function("getDeviceLocale") {
      return@Function Locale.getDefault().toLanguageTag()
    }

    AsyncFunction("computeHash") { input: String ->
      return@AsyncFunction HeavyComputation.compute(input)
    }

    Events("onProgress")

    Constants(
      "version" to "1.0.0",
      "platform" to "android"
    )
  }
}
```

### 7.2 Fabric Custom Components

Building a custom native UI component for the Fabric renderer.

```swift
// ios/MyFabricView.swift
import ExpoModulesCore

class MyFabricView: ExpoView {
  let gradientLayer = CAGradientLayer()

  required init() {
    super.init()
    layer.addSublayer(gradientLayer)
  }

  var colors: [UIColor] = [] {
    didSet {
      gradientLayer.colors = colors.map { $0.cgColor }
      setNeedsDisplay()
    }
  }

  var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
    didSet {
      gradientLayer.startPoint = startPoint
    }
  }

  var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
    didSet {
      gradientLayer.endPoint = endPoint
    }
  }
}
```

```js
// Usage in JS
import { requireNativeViewManager } from 'expo-modules-core';

const NativeGradientView = requireNativeViewManager('MyFabricView');

function GradientView({ colors, style, children }) {
  return (
    <NativeGradientView
      colors={colors}
      startPoint={{ x: 0, y: 0 }}
      endPoint={{ x: 1, y: 1 }}
      style={style}
    >
      {children}
    </NativeGradientView>
  );
}
```

### 7.3 JSI: C++ Turbo Modules

For maximum performance (ML inference, image processing, cryptography).

```cpp
// cpp/TurboImageProcessor.cpp
#include <jsi/jsi.h>
#include <jsi/decorator.h>
#include <memory>
#include <vector>

using namespace facebook::jsi;
using namespace facebook::react;

class JSI_EXPORT TurboImageProcessor : public TurboModule {
public:
  TurboImageProcessor(std::shared_ptr<CallInvoker> jsInvoker)
    : TurboModule("TurboImageProcessor", jsInvoker) {}

  static std::shared_ptr<TurboImageProcessor> create(
      std::shared_ptr<CallInvoker> jsInvoker) {
    return std::make_shared<TurboImageProcessor>(jsInvoker);
  }

  jsi::Value get(Runtime& runtime, const jsi::PropNameID& name) override {
    auto propName = name.utf8(runtime);
    if (propName == "resizeImage") {
      return jsi::Function::createFromHostFunction(
        runtime, name, 3,
        [this](Runtime& runtime, const Value&, const Value* args, size_t count) -> Value {
          if (count < 2) {
            throw jsi::JSError(runtime, "resizeImage requires 3 arguments");
          }
          auto imageData = args[0].getString(runtime).utf8(runtime);
          auto width = static_cast<int>(args[1].asNumber());
          auto height = static_cast<int>(args[2].asNumber());
          auto result = nativeResize(imageData, width, height);
          return Value(runtime, String::createFromUtf8(runtime, result.c_str()));
        }
      );
    }
    return jsi::Value::undefined();
  }

private:
  std::string nativeResize(const std::string& imageData, int width, int height) {
    // Implement native resize using C++ image library
    return imageData;
  }
};
```

---

## 8. Advanced Permissions Patterns

### 8.1 Permission Flow with Rationale

```js
import { check, request, PERMISSIONS, RESULTS, openSettings } from 'react-native-permissions';
import { Alert, Platform } from 'react-native';

const PERMISSION_MAP = {
  camera: {
    ios: PERMISSIONS.IOS.CAMERA,
    android: PERMISSIONS.ANDROID.CAMERA,
    rationale: {
      title: 'Camera Access Needed',
      message: 'We need camera access to take profile photos and scan documents.',
    },
  },
  location: {
    ios: PERMISSIONS.IOS.LOCATION_WHEN_IN_USE,
    android: PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
    rationale: {
      title: 'Location Access Needed',
      message: 'We need your location to show nearby restaurants and provide accurate delivery estimates.',
    },
  },
  photoLibrary: {
    ios: PERMISSIONS.IOS.PHOTO_LIBRARY,
    android: PERMISSIONS.ANDROID.READ_MEDIA_IMAGES,
    rationale: {
      title: 'Photo Library Access',
      message: 'We need access to your photos so you can upload images.',
    },
  },
  notifications: {
    ios: PERMISSIONS.IOS.NOTIFICATIONS,
    android: PERMISSIONS.ANDROID.POST_NOTIFICATIONS,
    rationale: {
      title: 'Notifications',
      message: 'We need to send you notifications about order updates and promotions.',
    },
  },
};

async function requestPermission(permissionType) {
  const config = PERMISSION_MAP[permissionType];
  if (!config) throw new Error(`Unknown permission: ${permissionType}`);

  const platformPermission = Platform.select(config);

  // Step 1: Check current status
  const currentStatus = await check(platformPermission);

  switch (currentStatus) {
    case RESULTS.GRANTED:
    case RESULTS.LIMITED:
      return true;

    case RESULTS.DENIED:
      // Step 2: Show rationale (for iOS, denied means never asked; for Android, it means denied but can ask again)
      return new Promise((resolve) => {
        Alert.alert(
          config.rationale.title,
          config.rationale.message,
          [
            { text: 'Not Now', style: 'cancel', onPress: () => resolve(false) },
            {
              text: 'Allow',
              onPress: async () => {
                const result = await request(platformPermission);
                resolve(result === RESULTS.GRANTED || result === RESULTS.LIMITED);
              },
            },
          ]
        );
      });

    case RESULTS.BLOCKED:
      // Step 3: Navigate to system settings
      return new Promise((resolve) => {
        Alert.alert(
          'Permission Required',
          `${config.rationale.title} is blocked. Please enable it in Settings.`,
          [
            { text: 'Cancel', style: 'cancel', onPress: () => resolve(false) },
            {
              text: 'Open Settings',
              onPress: () => {
                openSettings();
                resolve(false);
              },
            },
          ]
        );
      });

    case RESULTS.UNAVAILABLE:
      console.warn(`Permission ${permissionType} not available on this device`);
      return false;
  }
}
```

### 8.2 On-Demand Permissions

Request permissions only when the user triggers a feature that needs them (not on app launch).

```js
function CameraButton() {
  const [permissionGranted, setPermissionGranted] = useState(false);

  const handlePress = async () => {
    const granted = await requestPermission('camera');
    if (granted) {
      // Navigate to camera screen or open camera
      navigation.navigate('Camera');
    }
  };

  return (
    <Pressable onPress={handlePress}>
      <Icon name="camera" />
      <Text>Take Photo</Text>
    </Pressable>
  );
}
```

---

## 9. Firebase at Scale

### 9.1 Firestore Security Rules (Production)

```firebase
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // User profiles — owner only
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
      allow create: if request.auth.uid == userId
        && request.resource.data.keys().hasOnly(['name', 'email', 'photoUrl', 'createdAt']);
    }

    // Posts — public read, authenticated write
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null
        && request.resource.data.uid == request.auth.uid;
      allow update, delete: if request.auth.uid == resource.data.uid;

      // Comments subcollection
      match /comments/{commentId} {
        allow read: if true;
        allow create: if request.auth != null
          && request.resource.data.uid == request.auth.uid;
        allow delete: if request.auth.uid == resource.data.uid;
      }
    }

    // Chat rooms — participants only
    match /chats/{chatId} {
      allow read, write: if request.auth != null
        && request.auth.uid in resource.data.participants;
    }
  }
}
```

### 9.2 FCM: Advanced Push Notifications

**Data-only messages (handled by JS even in killed state):**

```js
// Background handler
messaging().setBackgroundMessageHandler(async (remoteMessage) => {
  const { type, payload } = remoteMessage.data;

  switch (type) {
    case 'new_message':
      // Update local storage
      const messages = storage.getString('pending_messages');
      const parsed = messages ? JSON.parse(messages) : [];
      parsed.push(payload);
      storage.set('pending_messages', JSON.stringify(parsed));
      break;

    case 'order_update':
      // Trigger background sync
      await BackgroundSync.syncOrder(payload.orderId);
      break;

    case 'content_refresh':
      // Invalidate query cache
      await queryClient.invalidateQueries({ queryKey: ['feed'] });
      break;
  }
});

// Notification channels (Android)
import notifee, { AndroidCategory, AndroidImportance } from '@notifee/react-native';

async function createChannels() {
  await notifee.createChannel({
    id: 'messages',
    name: 'Messages',
    description: 'Direct messages from other users',
    importance: AndroidImportance.HIGH,
    vibration: true,
    sound: 'message',
  });

  await notifee.createChannel({
    id: 'orders',
    name: 'Orders',
    description: 'Order status updates',
    importance: AndroidImportance.DEFAULT,
    vibration: true,
    sound: 'order',
  });

  await notifee.createChannel({
    id: 'marketing',
    name: 'Promotions',
    description: 'Sales and promotional offers',
    importance: AndroidImportance.LOW,
    vibration: false,
  });
}

// Rich notifications with images
async function displayRichNotification(remoteMessage) {
  await notifee.displayNotification({
    title: remoteMessage.notification.title,
    body: remoteMessage.notification.body,
    android: {
      channelId: 'messages',
      smallIcon: 'ic_notification',
      largeIcon: remoteMessage.data.avatarUrl,
      pressAction: { id: 'default' },
      // Big picture style
      style: {
        type: 'BIG_PICTURE',
        picture: remoteMessage.data.imageUrl,
      },
      actions: [
        {
          title: 'Reply',
          pressAction: { id: 'reply' },
          input: {
            placeholder: 'Type a reply...',
          },
        },
        {
          title: 'Mark as Read',
          pressAction: { id: 'mark_read' },
        },
      ],
    },
    ios: {
      categoryId: 'message',
      attachments: [remoteMessage.data.imageUrl],
    },
  });
}
```

### 9.3 Remote Config A/B Testing

```js
import remoteConfig from '@react-native-firebase/remote-config';

async function initializeRemoteConfig() {
  await remoteConfig().setDefaults({
    welcome_bonus: 500,
    new_checkout_flow: false,
    max_upload_size_mb: 10,
    supported_countries: JSON.stringify(['US', 'CA', 'UK']),
    home_screen_layout: 'grid',
  });

  // Fetch with minimum fetch interval
  await remoteConfig().fetch(0); // 0 = no cache for development
  await remoteConfig().activate();
}

function getExperiment() {
  const checkoutFlow = remoteConfig().getBoolean('new_checkout_flow');
  const layout = remoteConfig().getString('home_screen_layout');
  const maxUpload = remoteConfig().getNumber('max_upload_size_mb');
  const countries = JSON.parse(remoteConfig().getString('supported_countries'));

  return { checkoutFlow, layout, maxUpload, countries };
}

// A/B test wrapper
function ABTest({ flag, treatment, control }) {
  const value = remoteConfig().getBoolean(flag);
  return value ? treatment : control;
}

// Usage
<ABTest
  flag="new_checkout_flow"
  treatment={<NewCheckout />}
  control={<LegacyCheckout />}
/>
```

### 9.4 Analytics & Crashlytics

```js
import analytics from '@react-native-firebase/analytics';
import crashlytics from '@react-native-firebase/crashlytics';

// Custom event tracking with parameters
function trackEvent(name, params) {
  analytics().logEvent(name, {
    ...params,
    timestamp: Date.now(),
    app_version: Constants.manifest.version,
    platform: Platform.OS,
  });
}

// User properties
analytics().setUserProperties({
  subscription_tier: 'premium',
  account_age_days: daysSinceSignup,
  preferred_language: 'en',
});

// Non-fatal error tracking
function trackError(error, context) {
  crashlytics().recordError(error);
  crashlytics().setAttribute('error_context', JSON.stringify(context));
}

// Performance monitoring
import perf from '@react-native-firebase/perf';

async function traceNetworkCall(label, apiCall) {
  const trace = await perf().startTrace(label);
  try {
    const result = await apiCall();
    trace.putAttribute('status', 'success');
    return result;
  } catch (error) {
    trace.putAttribute('status', 'error');
    throw error;
  } finally {
    trace.stop();
  }
}
```

---

## 10. Offline Storage: Sync, Encryption, Multi-Process

### 10.1 MMKV: Encryption & Multi-Process

```js
import { MMKV } from 'react-native-mmkv';

// Main process storage
export const storage = new MMKV({
  id: 'app-storage',
  encryptionKey: storage.getString('encryption_key') || generateKey(),
});

// Shared storage for app group (iOS widget)
export const sharedStorage = new MMKV({
  id: 'group.com.myapp.shared',
  path: `${getAppGroupPath()}/mmkv`,
  encryptionKey: MASTER_KEY,
});

// Multi-process storage (Android widget)
export const widgetStorage = new MMKV({
  id: 'widget-storage',
  multiProcess: true,
  encryptionKey: WIDGET_KEY,
});

// Transparent encryption wrapper
function createEncryptedStorage(namespace) {
  const key = `${namespace}_cipher_key`;
  const cipherKey = storage.getString(key);

  if (!cipherKey) {
    const newKey = generateRandomKey(32);
    storage.set(key, newKey);
  }

  return new MMKV({
    id: `encrypted_${namespace}`,
    encryptionKey: storage.getString(key),
  });
}

const secureStorage = createEncryptedStorage('user_data');

// Zustand persist with encrypted MMKV
import { createJSONStorage, persist } from 'zustand/middleware';

const zustandMMKV = (mmkv) =>
  createJSONStorage(() => ({
    setItem: (name, value) => mmkv.set(name, value),
    getItem: (name) => mmkv.getString(name) ?? null,
    removeItem: (name) => mmkv.delete(name),
  }));
```

### 10.2 WatermelonDB: Production Offline-First

```js
// database/schema.js
import { appSchema, tableSchema } from '@nozbe/watermelondb';

export const schema = appSchema({
  version: 5,
  migrations: [
    // Migration from version 1 to 2
    {
      version: 2,
      tables: [
        tableSchema({
          name: 'posts',
          columns: [
            { name: 'title', type: 'string' },
            { name: 'body', type: 'string' },
            { name: 'author_id', type: 'string', isIndexed: true },
            { name: 'created_at', type: 'number' },
            { name: 'updated_at', type: 'number' },
            { name: 'server_id', type: 'string', isOptional: true },
            { name: 'is_deleted', type: 'boolean' },
          ],
        }),
      ],
    },
  ],
});

// database/models/Post.js
import { Model } from '@nozbe/watermelondb';
import { field, date, readonly, relation, children } from '@nozbe/watermelondb/decorators';
import { Q } from '@nozbe/watermelondb';

export default class Post extends Model {
  static table = 'posts';

  static associations = {
    comments: { type: 'has_many', foreignKey: 'post_id' },
    author: { type: 'belongs_to', key: 'author_id' },
  };

  @field('title') title;
  @field('body') body;
  @field('server_id') serverId;
  @field('is_deleted') isDeleted;
  @readonly @date('created_at') createdAt;
  @readonly @date('updated_at') updatedAt;
  @relation('users', 'author_id') author;
  @children('comments') comments;

  // Custom query
  static search(query) {
    return this.query(
      Q.or(
        Q.where('title', Q.like(`%${query}%`)),
        Q.where('body', Q.like(`%${query}%`))
      ),
      Q.sortBy('created_at', 'desc'),
      Q.take(20)
    );
  }

  // Mark for deletion (soft delete)
  async markDeleted() {
    await this.update((post) => {
      post.isDeleted = true;
    });
  }
}

// database/sync.js
import { synchronize } from '@nozbe/watermelondb/sync';

export async function syncDatabase() {
  const networkState = await NetInfo.fetch();
  if (!networkState.isConnected) {
    console.log('⏸️ Sync skipped — offline');
    return;
  }

  const lastSync = storage.getString('last_sync_timestamp');

  try {
    await synchronize({
      database,
      pullChanges: async ({ lastPulledAt, schemaVersion, migration }) => {
        const response = await api.post('/sync/pull', {
          lastPulledAt,
          schemaVersion,
          migration,
        });
        return {
          changes: response.data.changes,
          timestamp: response.data.timestamp,
        };
      },
      pushChanges: async ({ changes, lastPulledAt }) => {
        await api.post('/sync/push', { changes, lastPulledAt });
      },
      pullBatchSize: 500,
      migrationsEnabledAtVersion: 5,
    });

    storage.set('last_sync_timestamp', Date.now().toString());
    console.log('✅ Sync completed');
  } catch (error) {
    console.error('❌ Sync failed:', error);
    // Queue for retry
    BackgroundSync.scheduleRetry();
  }
}
```

### 10.3 SQLite: WAL Mode & Advanced Queries

```js
import { openDatabase, enablePromise } from 'react-native-sqlite-storage';

enablePromise(true);

async function initDatabase() {
  const db = await openDatabase({ name: 'app.db', location: 'default' });

  // Enable WAL mode for concurrent reads
  await db.executeSql('PRAGMA journal_mode=WAL');
  // Cache size for performance
  await db.executeSql('PRAGMA cache_size=-8000');
  // Foreign keys
  await db.executeSql('PRAGMA foreign_keys=ON');

  // Create tables with indices
  await db.executeSql(`
    CREATE TABLE IF NOT EXISTS search_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      query TEXT NOT NULL,
      result_count INTEGER,
      created_at TEXT DEFAULT (datetime('now'))
    )
  `);
  await db.executeSql(`
    CREATE INDEX IF NOT EXISTS idx_search_created
    ON search_history(created_at DESC)
  `);

  // Full-text search
  await db.executeSql(`
    CREATE VIRTUAL TABLE IF NOT EXISTS posts_fts USING fts5(
      title, body, content=posts, content_rowid=id
    )
  `);

  return db;
}

async function fullTextSearch(db, query) {
  const [results] = await db.executeSql(
    `SELECT p.*, rank
     FROM posts_fts
     JOIN posts p ON p.id = posts_fts.rowid
     WHERE posts_fts MATCH ?
     ORDER BY rank
     LIMIT 20`,
    [query]
  );
  return results.rows.raw();
}
```

---

## 11. Performance Optimization: Profiling & Deep Dives

### 11.1 Profiling Tools & Workflow

```
Production Profiling Checklist:
┌─────────────────────────────────────┐
│ 1. Flipper (Dev builds)             │
│    - React DevTools                 │
│    - Network Inspector              │
│    - Layout Inspector               │
│    - Performance Monitor (FPS/JS)   │
│    - Hermes Debugger (memory/CPU)   │
├─────────────────────────────────────┤
│ 2. Systrace (Android)               │
│    - Profile JS vs Native threads   │
│    - Identify thread contention     │
├─────────────────────────────────────┤
│ 3. Instruments (iOS)                │
│    - Time Profiler                  │
│    - Allocations (memory leaks)     │
│    - Energy Log                     │
├─────────────────────────────────────┤
│ 4. Performance Monitor (built-in)   │
│    - FPS monitor in dev mode         │
│    - RAM usage on device            │
├─────────────────────────────────────┤
│ 5. Bundle analysis                  │
│    - source-map-explorer            │
│    - react-native-bundle-visualizer │
└─────────────────────────────────────┘
```

### 11.2 React Native Reanimated 3: Worklet Optimization

```js
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
  withSequence,
  runOnJS,
  useDerivedValue,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import { GestureDetector, Gesture } from 'react-native-gesture-handler';

function SwipeableCard({ item, onSwipeLeft, onSwipeRight, children }) {
  const translateX = useSharedValue(0);
  const contextX = useSharedValue(0);
  const isActive = useSharedValue(false);

  const panGesture = Gesture.Pan()
    .onStart(() => {
      contextX.value = translateX.value;
      isActive.value = true;
    })
    .onUpdate((event) => {
      translateX.value = contextX.value + event.translationX;
    })
    .onEnd((event) => {
      const threshold = 100;
      if (translateX.value > threshold) {
        // Swipe right
        translateX.value = withSpring(500, { damping: 15 });
        runOnJS(onSwipeRight)(item);
      } else if (translateX.value < -threshold) {
        // Swipe left
        translateX.value = withSpring(-500, { damping: 15 });
        runOnJS(onSwipeLeft)(item);
      } else {
        // Snap back
        translateX.value = withSpring(0, { damping: 20 });
      }
      isActive.value = false;
    })
    .onFinalize(() => {
      isActive.value = false;
    });

  const animatedStyle = useAnimatedStyle(() => {
    const scale = interpolate(
      Math.abs(translateX.value),
      [0, 100],
      [1, 0.95],
      Extrapolate.CLAMP
    );

    const rotate = interpolate(
      translateX.value,
      [-300, 0, 300],
      [-15, 0, 15],
      Extrapolate.CLAMP
    );

    return {
      transform: [
        { translateX: translateX.value },
        { scale },
        { rotate: `${rotate}deg` },
      ],
      opacity: interpolate(
        Math.abs(translateX.value),
        [0, 200],
        [1, 0.8],
        Extrapolate.CLAMP
      ),
    };
  }, []);

  return (
    <GestureDetector gesture={panGesture}>
      <Animated.View style={animatedStyle}>
        {children}
      </Animated.View>
    </GestureDetector>
  );
}
```

### 11.3 Layout Animations

```js
import Animated, {
  Layout,
  FadingTransition,
  CurvedTransition,
} from 'react-native-reanimated';

function AnimatedList() {
  // Built-in layout animations for lists
  return (
    <Animated.FlatList
      data={items}
      renderItem={renderItem}
      keyExtractor={(item) => item.id}
      itemLayoutAnimation={Layout.springify()
        .damping(20)
        .stiffness(200)
      }
    />
  );
}

// Custom entering/exiting animations
function FadeInItem({ children, index }) {
  const entering = FadingTransition.duration(300).delay(index * 50);
  const exiting = FadingTransition.duration(200);

  return (
    <Animated.View entering={entering} exiting={exiting}>
      {children}
    </Animated.View>
  );
}
```

### 11.4 Bundle Size Optimization

| Strategy | Impact | Effort |
|----------|--------|--------|
| Hermes bytecode | -30% size | Low (toggle) |
| Remove dead code | Varies | Medium |
| Tree-shaking | -10-20% | Low (ESM) |
| Dynamic imports (lazy) | Per-screen loading | Medium |
| Image compression | Variable | Low |
| Remove unused fonts | -2-5 MB | Low |
| Flatten SVG assets | -60% SVG size | Medium |
| ProGuard/R8 (Android) | -15-25% | Low |
| WebP images | -30% image size | Low |
| Split vendors | -20% initial load | High |

```bash
# Analyze bundle
npx react-native-bundle-visualizer

# Remove unused packages
npx depcheck # Identify unused
npm uninstall <package>

# Check package sizes
npx cost-of-modules
```

### 11.5 Memory Leak Detection

```js
// Heap snapshot in Flipper (Hermes)
// 1. Take initial heap snapshot
// 2. Navigate through app
// 3. Take second snapshot
// 4. Compare: look for retained objects

// Common leak patterns:
const [data, setData] = useState(null);

useEffect(() => {
  let mounted = true;
  let subscription;

  async function load() {
    const result = await fetchData();

    // ✅ Guard against unmounted component
    if (mounted) {
      setData(result);
    }
  }

  load();
  subscription = eventEmitter.addListener('update', handleUpdate);

  return () => {
    mounted = false;
    subscription?.remove();
    // ✅ Cancel pending requests
    cancelToken.cancel('Component unmounted');
  };
}, []);

// Detecting leaks with Flipper memory plugin:
// - Watch for growing heap size over time
// - Look for stale closures in retained size
// - Check detached components
```

### 11.6 FlatList: Extreme Performance

```js
function OptimizedList({ items, searchQuery }) {
  // Memoize data transformations outside FlatList
  const filteredData = useMemo(() => {
    if (!searchQuery) return items;
    return items.filter((item) =>
      item.title.toLowerCase().includes(searchQuery.toLowerCase())
    );
  }, [items, searchQuery]);

  // Pre-compute layout
  const ITEM_HEIGHT = 96;
  const getItemLayout = useCallback(
    (_, index) => ({
      length: ITEM_HEIGHT,
      offset: ITEM_HEIGHT * index,
      index,
    }),
    []
  );

  // Stable key extractor
  const keyExtractor = useCallback((item) => item.id, []);

  // Memoized render item
  const renderItem = useCallback(({ item }) => {
    return <ListItem item={item} />;
  }, []);

  // Track visible items for analytics
  const onViewableItemsChanged = useCallback(({ viewableItems }) => {
    trackView(viewableItems.map((v) => v.item.id));
  }, []);

  const viewabilityConfig = useRef({
    itemVisiblePercentThreshold: 50,
    minimumViewTime: 500,
  }).current;

  return (
    <FlatList
      data={filteredData}
      renderItem={renderItem}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout}
      windowSize={7}
      maxToRenderPerBatch={15}
      initialNumToRender={12}
      removeClippedSubviews={Platform.OS === 'android'}
      updateCellsBatchingPeriod={50}
      onViewableItemsChanged={onViewableItemsChanged}
      viewabilityConfig={viewabilityConfig}
      maintainVisibleContentPosition={{
        minIndexForVisible: 0,
      }}
      CellRendererComponent={CellRenderer}
      // Specify estimated size for better scroll perf
      estimatedItemSize={ITEM_HEIGHT}
      inverted={isChat}
    />
  );
}

const ListItem = React.memo(({ item }) => {
  return (
    <View style={styles.item}>
      <FastImage source={{ uri: item.avatar }} style={styles.avatar} />
      <View style={styles.content}>
        <Text numberOfLines={1}>{item.title}</Text>
        <Text numberOfLines={2}>{item.description}</Text>
      </View>
    </View>
  );
}, (prev, next) => prev.item.id === next.item.id);
```

### 11.7 InteractionManager Patterns

```js
function HeavyScreen() {
  const [isInteractive, setIsInteractive] = useState(false);

  useEffect(() => {
    // Defer heavy computations until after navigation animation
    const task = InteractionManager.runAfterInteractions(() => {
      loadExpensiveData();
      setIsInteractive(true);
    });

    return () => task.cancel();
  }, []);

  if (!isInteractive) {
    return <SkeletonLoader />;
  }

  return <ExpensiveUI />;
}
```

---

## 12. Testing: E2E, Snapshot, Performance Regression

### 12.1 Unit Testing: Pure Functions & Hooks

```js
// Pure function
export function calculateDiscount(price, coupon) {
  if (!coupon.isValid || coupon.expiresAt < Date.now()) return price;
  return price * (1 - coupon.discountPercent / 100);
}

// Test
describe('calculateDiscount', () => {
  it('applies valid coupon', () => {
    const coupon = { isValid: true, expiresAt: Date.now() + 86400000, discountPercent: 20 };
    expect(calculateDiscount(100, coupon)).toBe(80);
  });

  it('returns full price for expired coupon', () => {
    const coupon = { isValid: true, expiresAt: Date.now() - 86400000, discountPercent: 20 };
    expect(calculateDiscount(100, coupon)).toBe(100);
  });
});
```

### 12.2 Integration: Component Testing

```js
import { render, screen, fireEvent, waitFor } from '@testing-library/react-native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { MMKVProvider } from 'react-native-mmkv';

function createTestQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false, gcTime: 0 },
    },
  });
}

function renderWithProviders(ui, { queryClient } = {}) {
  const client = queryClient || createTestQueryClient();

  return render(
    <QueryClientProvider client={client}>
      {ui}
    </QueryClientProvider>
  );
}

describe('ProfileScreen', () => {
  it('renders user data after loading', async () => {
    renderWithProviders(<ProfileScreen userId="123" />);

    // Wait for data to load
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeTruthy();
    });

    expect(screen.getByText('john@example.com')).toBeTruthy();
    expect(screen.getByTestId('avatar')).toBeTruthy();
  });

  it('shows error state', async () => {
    renderWithProviders(<ProfileScreen userId="error" />);

    await waitFor(() => {
      expect(screen.getByText(/failed to load/i)).toBeTruthy();
    });
  });
});
```

### 12.3 Detox: E2E Testing

```js
// e2e/login.test.js
describe('Login Flow', () => {
  beforeAll(async () => {
    await device.launchApp({
      newInstance: true,
      permissions: { notifications: 'YES' },
    });
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should show login screen', async () => {
    await expect(element(by.id('login-screen'))).toBeVisible();
    await expect(element(by.id('email-input'))).toBeVisible();
    await expect(element(by.id('password-input'))).toBeVisible();
  });

  it('should show validation errors for empty fields', async () => {
    await element(by.id('login-button')).tap();

    await expect(element(by.text('Email is required'))).toBeVisible();
    await expect(element(by.text('Password is required'))).toBeVisible();
  });

  it('should login successfully', async () => {
    await element(by.id('email-input')).typeText('test@example.com');
    await element(by.id('password-input')).typeText('password123');
    await element(by.id('login-button')).tap();

    // Wait for navigation
    await waitFor(element(by.id('home-screen')))
      .toBeVisible()
      .withTimeout(5000);

    await expect(element(by.id('welcome-message'))).toHaveText('Welcome back!');
  });

  it('should persist auth state across app restarts', async () => {
    await device.terminateApp();
    await device.launchApp();

    // Should skip login screen
    await expect(element(by.id('home-screen'))).toBeVisible();
  });
});
```

**Detox configuration:**

```js
// .detoxrc.js
module.exports = {
  testRunner: { args: { config: 'e2e/jest.config.js' }, jest: { setupTimeout: 120000 } },
  apps: {
    'ios.release': {
      type: 'ios.app',
      binaryPath: 'ios/build/Build/Products/Release-iphonesimulator/MyApp.app',
      build: 'npx react-native run-ios --configuration Release --scheme MyApp --device "iPhone 15"',
    },
    'android.release': {
      type: 'android.apk',
      binaryPath: 'android/app/build/outputs/apk/release/app-release.apk',
      build: 'cd android && ./gradlew assembleRelease assembleAndroidTest -DtestBuildType=release',
    },
  },
  devices: {
    simulator: { type: 'ios.simulator', device: { type: 'iPhone 15' } },
    emulator: { type: 'android.emulator', device: { avdName: 'Pixel_7_API_34' } },
  },
  configurations: {
    'ios.sim.release': { device: 'simulator', app: 'ios.release' },
    'android.emu.release': { device: 'emulator', app: 'android.release' },
  },
};
```

### 12.4 Performance Regression Testing

```js
// Detox performance test
describe('Feed Performance', () => {
  it('should render 100 items within performance budget', async () => {
    // Mock the API to return 100 items
    await device.setURLBlacklist(['.*api.example.com.*']);

    // Start performance profiling
    await device.startPerformance('FeedList');

    await element(by.id('feed-tab')).tap();
    await waitFor(element(by.id('feed-list')))
      .toBeVisible()
      .withTimeout(3000);

    // Scroll through the list
    for (let i = 0; i < 5; i++) {
      await element(by.id('feed-list')).swipe('up', 'fast', 0.5);
    }

    // Assert performance metrics
    const metrics = await device.stopPerformance('FeedList');
    expect(metrics.fps).toBeGreaterThan(55);
    expect(metrics.ram).toBeLessThan(200); // MB
  });
});
```

---

## 13. CI/CD: Matrix Builds, OTA, Rollback Strategies

### 13.1 GitHub Actions: Matrix Builds

```yaml
name: CI/CD
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npx eslint .
      - run: npx jest --coverage --maxWorkers=2
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/

  e2e:
    needs: lint-test
    strategy:
      matrix:
        platform: [ios, android]
    runs-on: ${{ matrix.platform == 'ios' && 'macos-14' || 'ubuntu-latest' }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - name: E2E Tests (${{ matrix.platform }})
        run: |
          npx detox build --configuration ${{ matrix.platform }}.release
          npx detox test --configuration ${{ matrix.platform }}.release --cleanup

  build-and-deploy:
    needs: [lint-test, e2e]
    if: github.ref == 'refs/heads/main'
    strategy:
      matrix:
        platform: [ios, android]
        environment: [staging, production]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: expo/expo-github-action@v8
        with:
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: npm ci
      - name: Build ${{ matrix.platform }} (${{ matrix.environment }})
        run: |
          eas build \
            --platform ${{ matrix.platform }} \
            --profile ${{ matrix.environment }} \
            --non-interactive \
            --no-wait

  ota-update:
    needs: build-and-deploy
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: expo/expo-github-action@v8
        with:
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: npm ci
      - name: Publish OTA Update
        run: |
          npx eas update \
            --branch production \
            --message "CI Build #${{ github.run_number }}"

  notify:
    needs: [build-and-deploy, ota-update]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/slack-notify@v2
        with:
          status: ${{ job.status }}
          message: "🚀 Release ${{ github.run_number }} deployed"
```

### 13.2 EAS Submit Automation

```bash
#!/bin/bash
# scripts/deploy.sh

ENVIRONMENT=${1:-staging}
VERSION=$(node -p "require('./package.json').version")

echo "🚀 Deploying v$VERSION to $ENVIRONMENT"

# Build
eas build --platform all --profile $ENVIRONMENT --non-interactive

# Submit to stores
if [ "$ENVIRONMENT" == "production" ]; then
  eas submit --platform ios \
    --profile production \
    --apple-id "$APPLE_ID" \
    --asc-app-id "$APP_ID" \
    --apple-team-id "$TEAM_ID"

  eas submit --platform android \
    --profile production \
    --service-account-key-path "./service-account.json" \
    --track "production"
fi

# OTA update for next version
if [ "$ENVIRONMENT" == "staging" ]; then
  eas update --branch staging --message "Staging v$VERSION"
fi
```

### 13.3 Rollback Strategy

```bash
# Check update history
eas update:list --branch production

# Rollback to specific update
eas update:rollback --branch production --commit <hash>

# Channel-based staged rollout
eas update --branch production-1pct --message "5% users - new checkout"
eas update --branch production-25pct --message "25% users"
eas update --branch production-100pct --message "Full rollout"

# If issues detected, redirect users back
eas update:rollback --branch production-100pct
```

### 13.4 CodePush Migration to EAS Update

| Feature | CodePush | EAS Update |
|---------|----------|-----------|
| OTA updates | ✅ | ✅ |
| Mandatory updates | ✅ | ✅ with `updateGroup` |
| Rollback | ✅ | ✅ |
| Changelog | Manual | Git-based |
| Distribution groups | ✅ Staging/Production | Branch-based |
| Binary version check | ✅ | Runtime version |
| Rollout percentage | ✅ | Through branches |

**Migration:**
```bash
# 1. Remove CodePush SDK
npm uninstall react-native-code-push

# 2. Install EAS Update
npm install expo-updates

# 3. Configure runtime version
# app.json: "runtimeVersion": { "policy": "appVersion" }

# 4. First publish
npx eas update --branch production --message "Migrated from CodePush"
```

---

## 14. Android & iOS Deployment: Signing, Flavors, ASO

### 14.1 Fastlane for Production

```ruby
# fastlane/Fastfile
default_platform :ios

platform :ios do
  lane :beta do
    match(type: 'adhoc')
    gym(scheme: 'MyApp')
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
      notify_external_testers: false,
      changelog: "Bug fixes and performance improvements"
    )
  end

  lane :release do
    match(type: 'appstore', readonly: true)
    gym(scheme: 'MyApp', configuration: 'Release')
    upload_to_app_store(
      skip_metadata: true,
      skip_screenshots: true,
      skip_app_review: false,
      force: true,
      submission_type: 'WAITING_FOR_REVIEW'
    )
  end

  lane :manage_signing do
    match(
      type: 'appstore',
      force: true,
      generate_certs: true,
      generate_profiles: true
    )
  end
end

platform :android do
  lane :beta do
    gradle(task: 'assembleRelease')
    upload_to_play_store(track: 'internal')
  end

  lane :release do
    gradle(task: 'assembleRelease')
    upload_to_play_store(
      track: 'production',
      rollout: '0.1', # 10% staged rollout
      in_app_update_priority: 2
    )
  end
end
```

### 14.2 Android App Signing & Play Store

```bash
# Create upload key
keytool -genkey -v -keystore upload-keystore.jks \
  -alias upload -keyalg RSA -keysize 2048 -validity 10000

# Register upload key with Google Play Console
# Play Console → Release → Setup → App Integrity → Upload key

# Build signed AAB
./gradlew bundleRelease

# Verify APK signature
java -jar apksigner.jar verify --verbose app-release.apk

# Check AAB content
unzip -l app-release.aab | grep "BundleConfig.pb"
```

**Play Store listing optimization (ASO):**
- Title: Primary keyword + brand (30 chars)
- Short description: 80 chars with key benefits
- Full description: First 3 lines matter most (shown in search)
- Screenshots: 6-8 per device type, include captions
- Feature graphic: 1024×500 with clear value prop
- Rating & reviews: Respond to all reviews within 24hrs

### 14.3 iOS Distribution & App Store

```bash
# Create certificates & profiles
fastlane match init
fastlane match development
fastlane match appstore

# Export for App Store
xcodebuild -exportArchive \
  -archivePath MyApp.xcarchive \
  -exportPath MyApp.ipa \
  -exportOptionsPlist ExportOptions.plist

# Upload to App Store Connect
xcrun altool --upload-app --type ios \
  --file MyApp.ipa \
  --username "user@apple.com" \
  --password @keychain:AC_PASSWORD
```

**App Store review tips:**
- Demo account credentials in the review notes
- Explain any hardware-specific features
- Don't mention beta/unreleased features
- Respond to rejection with specific fixes
- Use phased release (7-day gradual rollout)

### 14.4 Environment Flavors

```js
// app.config.js (Expo)
const ENV = process.env.ENVIRONMENT || 'development';

const configs = {
  development: {
    name: 'MyApp Dev',
    icon: './assets/icon-dev.png',
    ios: { bundleIdentifier: 'com.myapp.dev' },
    android: { package: 'com.myapp.dev' },
    extra: { apiUrl: 'http://localhost:3000', sentryDsn: '' },
  },
  staging: {
    name: 'MyApp Staging',
    icon: './assets/icon-staging.png',
    ios: { bundleIdentifier: 'com.myapp.staging' },
    android: { package: 'com.myapp.staging' },
    extra: { apiUrl: 'https://api.staging.com', sentryDsn: '@staging_dsn' },
  },
  production: {
    name: 'MyApp',
    icon: './assets/icon.png',
    ios: { bundleIdentifier: 'com.myapp' },
    android: { package: 'com.myapp' },
    extra: { apiUrl: 'https://api.production.com', sentryDsn: '@production_dsn' },
  },
};

export default ({ config }) => ({
  ...config,
  ...configs[ENV],
});
```

### 14.5 In-App Purchases & Subscriptions

```js
import RNIap from 'react-native-iap';

const productIds = Platform.select({
  ios: ['com.myapp.premium.monthly', 'com.myapp.premium.yearly'],
  android: ['com.myapp.premium.monthly', 'com.myapp.premium.yearly'],
});

async function setupIAP() {
  try {
    await RNIap.initConnection();

    // Get products
    const products = await RNIap.getProducts({ skus: productIds });

    // Get existing purchases
    const purchases = await RNIap.getAvailablePurchases();

    // Validate receipt
    await validateReceipt(purchases[0]?.transactionReceipt);

    return { products, purchases };
  } catch (error) {
    console.error('IAP setup failed:', error);
  }
}

async function purchaseSubscription(productId) {
  try {
    const purchase = await RNIap.requestPurchase({
      sku: productId,
      andDangerouslyFinishTransactionAutomatically: false,
    });

    // Validate receipt on your server
    const isValid = await validateReceipt(purchase.transactionReceipt);

    if (isValid) {
      await RNIap.finishTransaction({ purchase, isConsumable: false });
      return true;
    }
  } catch (error) {
    if (error.code !== 'E_USER_CANCELLED') {
      throw error;
    }
  }
  return false;
}

// Listen for purchases
RNIap.purchaseUpdatedListener(async (purchase) => {
  const isValid = await validateReceipt(purchase.transactionReceipt);
  if (isValid) {
    await RNIap.finishTransaction({ purchase, isConsumable: false });
    // Grant access
    storage.set('is_premium', 'true');
  }
});

RNIap.purchaseErrorListener((error) => {
  console.error('Purchase error:', error);
});
```

---

## 15. Production Architecture: Monorepo, Codegen, Server-Driven UI

### 15.1 Monorepo with Turborepo

```
my-app/
├── apps/
│   ├── mobile/                 # Expo / RN app
│   │   ├── app/
│   │   ├── src/
│   │   └── app.config.ts
│   ├── web/                    # Next.js (if shared)
│   │   └── src/
│   └── admin/                  # Admin panel
│       └── src/
├── packages/
│   ├── ui/                     # Shared component library
│   │   ├── src/
│   │   │   ├── Button.tsx
│   │   │   ├── Card.tsx
│   │   │   ├── Input.tsx
│   │   │   └── index.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   ├── api-client/             # Shared API client
│   │   ├── src/
│   │   │   ├── client.ts
│   │   │   ├── endpoints/
│   │   │   └── types.ts
│   │   ├── tsconfig.json
│   │   └── package.json
│   ├── config/                 # Shared config
│   │   ├── eslint/
│   │   ├── typescript/
│   │   └── prettier/
│   └── utils/                  # Shared utilities
│       ├── src/
│       │   ├── format.ts
│       │   ├── date.ts
│       │   └── validators.ts
│       └── package.json
├── turbo.json
├── package.json
└── pnpm-workspace.yaml
```

```json
// turbo.json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", ".expo/**"],
      "env": ["API_URL", "SENTRY_DSN"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "test": {
      "dependsOn": ["build"],
      "inputs": ["src/**/*.tsx", "src/**/*.ts", "src/**/*.test.*"]
    },
    "typecheck": {
      "dependsOn": ["^build"]
    },
    "clean": {
      "cache": false
    }
  }
}
```

```yaml
# pnpm-workspace.yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### 15.2 Server-Driven UI (SDUI)

```js
// The server sends a JSON layout; the app renders it dynamically

const layoutFromServer = {
  version: 2,
  screens: {
    home: {
      components: [
        { type: 'banner', id: 'promo', image: 'https://cdn.example.com/promo.jpg', action: { type: 'deeplink', url: 'myapp://promo/summer' } },
        { type: 'category_grid', id: 'categories', items: [
          { id: '1', title: 'Electronics', icon: 'laptop' },
          { id: '2', title: 'Fashion', icon: 'tshirt' },
        ]},
        { type: 'product_list', id: 'trending', title: 'Trending Now', endpoint: '/api/products/trending' },
        { type: 'divider', id: 'div1' },
        { type: 'product_list', id: 'recommended', title: 'Recommended For You', endpoint: '/api/products/recommended' },
        { type: 'info_card', id: 'shipping', title: 'Free Shipping', description: 'On orders over $50', icon: 'truck' },
      ],
    },
    product_detail: {
      components: [
        { type: 'image_gallery', id: 'gallery', images: ['url1', 'url2'] },
        { type: 'product_info', id: 'info' },
        { type: 'related_products', id: 'related' },
      ],
    },
  },
  theme: {
    colors: { primary: '#FF6B35', secondary: '#004E89' },
    typography: { heading: 'Inter-Bold', body: 'Inter-Regular' },
  },
};

// Component registry
const componentRegistry = {
  banner: BannerComponent,
  category_grid: CategoryGrid,
  product_list: ProductList,
  divider: Divider,
  info_card: InfoCard,
  image_gallery: ImageGallery,
  product_info: ProductInfo,
  related_products: RelatedProducts,
};

function DynamicScreen({ screenConfig }) {
  return (
    <ScrollView>
      {screenConfig.components.map((component) => {
        const Component = componentRegistry[component.type];
        if (!Component) {
          console.warn(`Unknown component type: ${component.type}`);
          return null;
        }
        return <Component key={component.id} config={component} />;
      })}
    </ScrollView>
  );
}
```

### 15.3 Code Generation with Plop

```js
// plopfile.js
module.exports = function (plop) {
  // Feature generator
  plop.setGenerator('feature', {
    description: 'Create a new feature module',
    prompts: [
      { type: 'input', name: 'name', message: 'Feature name (kebab-case):' },
      { type: 'confirm', name: 'hasApi', message: 'Include API layer?', default: true },
      { type: 'confirm', name: 'hasStore', message: 'Include store?', default: true },
    ],
    actions: (data) => {
      const actions = [
        { type: 'add', path: 'src/features/{{kebabCase name}}/index.js', templateFile: 'templates/feature/barrel.hbs' },
        { type: 'add', path: 'src/features/{{kebabCase name}}/screens/{{pascalCase name}}Screen.js', templateFile: 'templates/feature/screen.hbs' },
        { type: 'add', path: 'src/features/{{kebabCase name}}/components/{{pascalCase name}}Card.js', templateFile: 'templates/feature/component.hbs' },
        { type: 'add', path: 'src/features/{{kebabCase name}}/hooks/use{{pascalCase name}}.js', templateFile: 'templates/feature/hook.hbs' },
      ];

      if (data.hasApi) {
        actions.push(
          { type: 'add', path: 'src/features/{{kebabCase name}}/api/{{camelCase name}}Api.js', templateFile: 'templates/feature/api.hbs' }
        );
      }

      if (data.hasStore) {
        actions.push(
          { type: 'add', path: 'src/features/{{kebabCase name}}/store/{{camelCase name}}Store.js', templateFile: 'templates/feature/store.hbs' }
        );
      }

      return actions;
    },
  });

  // Screen generator
  plop.setGenerator('screen', {
    description: 'Create a new screen',
    prompts: [
      { type: 'input', name: 'name', message: 'Screen name (kebab-case):' },
      { type: 'input', name: 'feature', message: 'Feature name:' },
    ],
    actions: [
      {
        type: 'add',
        path: 'src/features/{{kebabCase feature}}/screens/{{pascalCase name}}Screen.js',
        templateFile: 'templates/screen.hbs',
      },
    ],
  });
};
```

### 15.4 Security Best Practices

```js
// 1. Certificate pinning
import { SslPinning } from 'react-native-ssl-pinning';

const api = SslPinning.create({
  baseURL: 'https://api.example.com',
  sslPinning: {
    cert: [PINNED_CERT_SHA256],
  },
});

// 2. Secure storage for tokens
import { Keychain } from 'react-native-keychain';

async function storeCredentials(token, refreshToken) {
  await Keychain.setGenericPassword(
    'auth',
    JSON.stringify({ token, refreshToken }),
    {
      service: 'com.myapp.auth',
      accessControl: Keychain.ACCESS_CONTROL.BIOMETRY_CURRENT_SET_OR_DEVICE_PASSCODE,
      accessible: Keychain.ACCESSIBLE.WHEN_UNLOCKED_THIS_DEVICE_ONLY,
    }
  );
}

// 3. App attestation (iOS)
import DeviceCheck from 'react-native-device-check';

async function verifyDevice() {
  const token = await DeviceCheck.generateToken();
  const { valid } = await api.post('/verify-device', { token });
  return valid;
}

// 4. Jailbreak / root detection
import JailMonkey from 'jail-monkey';

if (JailMonkey.isJailBroken()) {
  // Show warning or restrict functionality
}

// 5. Obfuscation
// Metro config: add `metro-react-native-babel-preset` with `compact: true`
// Android: Enable ProGuard
// iOS: Enable compiler optimizations for Release
```

---

## 16. Animations: Reanimated, Skia, Lottie, Layout

### 16.1 Reanimated 3: Shared Values & Worklets

```js
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
  withRepeat,
  withSequence,
  Easing,
  runOnJS,
  useDerivedValue,
  interpolate,
  Extrapolate,
  scrollTo,
} from 'react-native-reanimated';
import { GestureDetector, Gesture } from 'react-native-gesture-handler';

function AdvancedCarousel({ items }) {
  const translateX = useSharedValue(0);
  const currentIndex = useSharedValue(0);
  const scale = useSharedValue(1);
  const rotation = useSharedValue(0);

  const ITEM_WIDTH = 300;
  const SPACING = 16;

  const panGesture = Gesture.Pan()
    .onUpdate((event) => {
      translateX.value = event.translationX - currentIndex.value * (ITEM_WIDTH + SPACING);
      // Scale effect based on drag distance
      scale.value = interpolate(
        Math.abs(event.translationX),
        [0, 200],
        [1, 0.9],
        Extrapolate.CLAMP
      );
    })
    .onEnd((event) => {
      const offset = event.translationX;
      if (offset < -50) {
        currentIndex.value = Math.min(currentIndex.value + 1, items.length - 1);
      } else if (offset > 50) {
        currentIndex.value = Math.max(currentIndex.value - 1, 0);
      }
      translateX.value = withSpring(-currentIndex.value * (ITEM_WIDTH + SPACING), {
        damping: 20,
        stiffness: 150,
      });
      scale.value = withSpring(1);
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateX: translateX.value },
      { scale: scale.value },
      { rotate: `${rotation.value}deg` },
    ],
  }));

  return (
    <GestureDetector gesture={panGesture}>
      <Animated.View style={[styles.carousel, animatedStyle]}>
        {items.map((item, index) => (
          <Animated.View
            key={item.id}
            style={[
              styles.card,
              {
                width: ITEM_WIDTH,
                marginRight: SPACING,
              },
            ]}
          >
            <Animated.Image
              source={{ uri: item.image }}
              style={styles.cardImage}
              sharedTransitionTag={`image-${item.id}`}
            />
          </Animated.View>
        ))}
      </Animated.View>
    </GestureDetector>
  );
}
```

### 16.2 React Native Skia

High-performance 2D graphics using the Skia rendering engine.

```js
import { Canvas, Circle, Group, Paint, Shadow, Skia, useValue, useDerivedValue, runTiming, mix, Path, SkiaPath, Text, useFont } from '@shopify/react-native-skia';

function AnimatedCircle({ radius, color }) {
  const size = useValue(256);
  const progress = useValue(0);

  useEffect(() => {
    runTiming(progress, 1, { duration: 2000 });
    runTiming(size, radius, { duration: 1000 });
  }, [radius]);

  const r = useDerivedValue(() => size.current / 2, [size]);

  return (
    <Canvas style={{ width: 256, height: 256 }}>
      <Paint color={color}>
        <Shadow dx={0} dy={4} blur={8} color="rgba(0,0,0,0.3)" />
      </Paint>
      <Circle cx={128} cy={128} r={r} />
    </Canvas>
  );
}

// Donut chart with Skia
function DonutChart({ data, size = 200, strokeWidth = 40 }) {
  const center = size / 2;
  const radius = center - strokeWidth / 2;

  const total = data.reduce((sum, item) => sum + item.value, 0);
  let startAngle = -Math.PI / 2;

  return (
    <Canvas style={{ width: size, height: size }}>
      {data.map((slice) => {
        const sweepAngle = (slice.value / total) * 2 * Math.PI;
        const path = Skia.Path.Make();
        path.addCircle(center, center, radius);

        const paint = Skia.Paint();
        paint.setColor(Skia.Color(slice.color));
        paint.setStyle(PaintStyle.Stroke);
        paint.setStrokeWidth(strokeWidth);
        paint.setAntiAlias(true);

        const start = { x: center + radius * Math.cos(startAngle), y: center + radius * Math.sin(startAngle) };
        const end = { x: center + radius * Math.cos(startAngle + sweepAngle), y: center + radius * Math.sin(startAngle + sweepAngle) };

        startAngle += sweepAngle;

        return <Path key={slice.label} path={path} paint={paint} />;
      })}
    </Canvas>
  );
}
```

### 16.3 Lottie & Rive Animations

```js
// Lottie
import LottieView from 'lottie-react-native';

function AnimatedLoader({ visible }) {
  const animationRef = useRef(null);

  useEffect(() => {
    if (visible) {
      animationRef.current?.play();
    } else {
      animationRef.current?.reset();
    }
  }, [visible]);

  return (
    <Modal visible={visible} transparent>
      <View style={styles.overlay}>
        <LottieView
          ref={animationRef}
          source={require('./animations/loader.json')}
          style={{ width: 200, height: 200 }}
          autoPlay={false}
          loop
          cacheStrategy='strong'
          cacheComposition={true}
        />
      </View>
    </Modal>
  );
}

// Rive (runtime animation)
import Rive from 'rive-react-native';

function InteractiveButton() {
  const [isPressed, setIsPressed] = useState(false);
  const riveRef = useRef(null);

  const handlePressIn = () => {
    riveRef.current?.play('press');
    setIsPressed(true);
  };

  const handlePressOut = () => {
    riveRef.current?.play('release');
    setIsPressed(false);
  };

  return (
    <Pressable onPressIn={handlePressIn} onPressOut={handlePressOut}>
      <Rive
        ref={riveRef}
        resource={require('./animations/button.riv')}
        stateMachine="button"
        style={{ width: 200, height: 60 }}
      />
    </Pressable>
  );
}
```

### 16.4 Reanimated Layout Animations

```js
import Animated, {
  FadeIn,
  FadeOut,
  BounceIn,
  BounceOut,
  SlideInLeft,
  SlideOutRight,
  LightSpeedInRight,
  LightSpeedOutLeft,
  PinwheelIn,
  PinwheelOut,
  RollInLeft,
  RollOutRight,
  FlipInXUp,
  FlipOutXUp,
  ZoomIn,
  ZoomOut,
  StretchInX,
  StretchOutX,
} from 'react-native-reanimated';

function AnimatedEntry({ index = 0, children }) {
  return (
    <Animated.View
      entering={FadeIn.duration(300)
        .delay(index * 100)
        .springify()
        .damping(12)
        .stiffness(100)
      }
      exiting={FadeOut.duration(200)}
      layout={Animated.Layout.springify().damping(20)}
    >
      {children}
    </Animated.View>
  );
}

// Usage in FlatList
function AnimatedListItem({ item, index }) {
  return (
    <Animated.View
      entering={SlideInLeft.duration(400)
        .delay(index * 50)
        .springify()
      }
      exiting={SlideOutRight.duration(300)}
    >
      <ListItem item={item} />
    </Animated.View>
  );
}
```

---

## 17. Real-World Projects (Advanced)

### Project 1: Offline-First Social Media App

- **Stack:** Expo, WatermelonDB, MMKV, TanStack Query, Reanimated
- **Features:** Optimistic create/edit/delete with sync queue, offline image upload queue, conflict resolution, background sync on connectivity
- **Architecture:** Repository pattern, sync adapter, conflict resolver, retry queue
- **Learning outcome:** Deep understanding of offline-first architecture, sync strategies, and conflict resolution

### Project 2: Real-Time Delivery Tracking App

- **Stack:** Expo, GraphQL subscriptions, react-native-maps, Reanimated, FCM data messages
- **Features:** Live driver tracking on map, order status updates via WebSocket, estimated arrival, route rendering with polylines, push notifications for status changes
- **Architecture:** Apollo Client with WS link, subscription management, map clustering for multiple drivers
- **Learning outcome:** Real-time communication at scale, map performance optimization

### Project 3: Custom Native Camera App

- **Stack:** react-native-vision-camera with frame processors, Skia, C++ Turbo Module
- **Features:** Real-time camera filters using frame processors, barcode/QR scanning, document edge detection, custom camera UI with gesture controls
- **Architecture:** Frame processor plugin (C++/Swift/Kotlin), Skia overlay rendering, Turbo Module for heavy image processing
- **Learning outcome:** Native frame processing, JSI interop, Skia rendering pipeline

### Project 4: Multi-Platform Monorepo (Mobile + Web)

- **Stack:** Turborepo, Expo Router, Next.js, Tamagui, shared API client
- **Features:** Shared components between mobile and web, platform-specific behaviors via filesystem-based routing, shared auth state, shared API client
- **Architecture:** Package-based monorepo with shared types, UI package, and API client
- **Learning outcome:** Monorepo management, cross-platform component design, shared code patterns

### Project 5: AI Chat Assistant with Streaming

- **Stack:** react-native-sse, Reanimated, Markdown rendering, voice recording
- **Features:** Streaming token-by-token responses, markdown rendering with code blocks, conversation branching, voice input, model switching (GPT-4, Claude, local)
- **Architecture:** SSE connection manager, conversation context store, streaming parser, voice processing pipeline
- **Learning outcome:** Streaming response handling, gesture-driven UI, async/await patterns at scale

### Project 6: Music Player App

- **Stack:** expo-av, Reanimated shared value gestures, Audio background mode, Skia waveforms
- **Features:** Background audio playback, Lock screen controls, custom waveform visualization with Skia, gesture-driven seek, playlist management, offline downloads
- **Architecture:** Audio engine service layer, background task handling, remote command delegation
- **Learning outcome:** Background services, audio pipeline, complex gesture interactions

### Project 7: E-Commerce Platform with AR

- **Stack:** Expo, ViroReact (AR), Stripe, WatermelonDB
- **Features:** AR product preview in real-world space, Apple Pay / Google Pay, offline cart, order tracking, admin panel (web)
- **Architecture:** AR session management, payment gateway abstraction, sync engine for orders
- **Learning outcome:** ARKit/ARCore integration, payment security, complex state synchronization

### Project 8: Fitness Tracker with Widgets

- **Stack:** Expo, HealthKit / Google Fit, WidgetKit (iOS), Android Widgets, Reanimated charts
- **Features:** Step tracking from health APIs, custom iOS widget showing daily progress, Android home screen widget, workout history with Skia charts, background sync
- **Architecture:** Native health module (Expo Module API), widget data sharing via MMKV app group, background task scheduling
- **Learning outcome:** Health integrations, widget development, app group sharing

### Project 9: iOS Dynamic Island & Live Activities

- **Stack:** Expo config plugins, ActivityKit (iOS 16.1+), Live Activities, Dynamic Island
- **Features:** Sports scores in Dynamic Island, food delivery ETA as Live Activity, music player controls, tournament bracket progression
- **Architecture:** ActivityKit native module, push-to-start updates, Activity UI configuration via SwiftUI
- **Learning outcome:** iOS 16+ platform features, ActivityKit framework, system UI integration

### Project 10: Full SaaS App with SSO

- **Stack:** Monorepo (Expo + Next.js), Auth0, Stripe, Supabase, react-native-mmkv
- **Features:** Single sign-on (Google, Apple, Microsoft), subscription management with Stripe, role-based access control, team workspaces, real-time collaboration
- **Architecture:** Auth0 integration with biometric SSO, webhook-based subscription sync, RBAC across client and server
- **Learning outcome:** Enterprise auth patterns, subscription billing, multi-tenant architecture

### Project 11: Video/Reels App

- **Stack:** expo-video, Reanimated gestures, Vision Camera, AVPlayer
- **Features:** Vertical swipeable video feed like TikTok/Reels, double-tap like with heart animation, video recording with effects, comment overlay
- **Architecture:** Video preloading pool, gesture-driven feed paging, efficient video recycling
- **Learning outcome:** Video performance optimization, gesture-driven UX, media pipeline management

### Project 12: IoT Control Panel

- **Stack:** Native Modules (BLE + WiFi), react-native-ble-plx, MQTT over WebSocket
- **Features:** BLE device discovery and pairing, MQTT command publishing, real-time sensor data dashboard, scene automation
- **Architecture:** BLE native module with background scanning, MQTT client with reconnection, command queuing for offline devices
- **Learning outcome:** BLE protocol, MQTT IoT protocol, background connectivity

---

## 18. Best YouTube Channels & Resources

### 18.1 Advanced Channels

| Channel | Focus | Why |
|---------|-------|-----|
| [notJust.dev](https://youtube.com/@notjustdev) | Full RN apps, architecture | "Become a Senior React Native Developer" series, real production apps |
| [Fireship](https://youtube.com/@fireship) | High-density, 100s concepts | "React Native in 100 Seconds", New Architecture explainers |
| [Simon Grimm](https://youtube.com/@SimonGrimmDev) | Expo deep dives | EAS Build, EAS Update, config plugins |
| [Jack Herrington](https://youtube.com/@JackHerrington) | Performance, patterns | React Native performance profiling, advanced TypeScript (applicable in JS) |
| [Lee Robinson](https://youtube.com/@leerob) | Monorepos, deployment | Turborepo tutorials, shipping strategies |
| [Software Mansion](https://youtube.com/@SoftwareMansion) | Reanimated, Gesture Handler | Official library deep-dives from maintainers |
| [React Conf](https://youtube.com/@reactconf) | Conference talks | Latest architecture talks, Fabric, JSI sessions |
| [SwiftandTips](https://youtube.com/@SwiftandTips) | iOS native (Swift/Kotlin) | Native module development on Apple platforms |
| [Philipp Lackner](https://youtube.com/@PhilippLackner) | Android native (Kotlin) | Android native module creation |
| [Expo](https://youtube.com/@expo) | Official Expo channel | EAS, SDK releases, config plugin tutorials |

### 18.2 Essential Playlists

| Playlist | URL |
|----------|-----|
| notJust.dev — Become a Senior RN Dev | https://youtube.com/playlist?list=PLK0e69Lwj9-fkRi0g5qpn9O9QRmgsvvjW |
| Software Mansion — Reanimated 3 | https://youtube.com/playlist?list=PLlH0XMSM80eFIOuDZF6AR11QxMlXkYiQx |
| React Conf 2024 — New Architecture | https://youtube.com/playlist?list=PLOka8jP7n5PcSIDalE7vYR_RdFC7KsljN |
| Expo — EAS Deep Dive | https://youtube.com/playlist?list=PLVgxK5R5M5FSq7WxWbY8C1IGoV_x7GqDy |
| Lee Robinson — Turborepo | https://youtube.com/playlist?list=PL0vfts4VzfNjiWXmnFMS6YcOqTGJE8S5N |
| Jack Herrington — Performance | https://youtube.com/playlist?list=PLN0s1z7QvYVy3q1SGHnOZz5EZQRZR_8y0 |

### 18.3 Documentation & Tools

| Resource | URL |
|----------|-----|
| React Native New Architecture | https://reactnative.dev/docs/the-new-architecture/landing-page |
| Expo Documentation | https://docs.expo.dev |
| Reanimated 3 Docs | https://docs.swmansion.com/react-native-reanimated/ |
| Skia for RN | https://shopify.github.io/react-native-skia/ |
| WatermelonDB Sync | https://nozbe.github.io/WatermelonDB/Sync.html |
| EAS Build | https://docs.expo.dev/build/introduction/ |
| React Navigation v7 | https://reactnavigation.org/docs/getting-started |
| TanStack Query | https://tanstack.com/query/latest/docs/react/overview |
| Fastlane | https://docs.fastlane.tools |
| Detox E2E | https://wix.github.io/Detox/ |
| RN Directory | https://reactnative.directory |
| react-native-bundle-visualizer | https://github.com/IjzerenHein/react-native-bundle-visualizer |

---

## 19. Career: Senior → Staff → Lead

### 19.1 Role Progression

| Role | Years Exp | Key Expectations | Salary Range (USD) |
|------|-----------|------------------|-------------------|
| **Senior React Native Engineer** | 4-7 | Own large features, mentor juniors, performance optimization, architecture decisions | $130K - $175K |
| **Staff Engineer** | 7-10 | Cross-org impact, drive architectural vision, set standards, deep platform expertise | $175K - $220K |
| **Principal Engineer** | 10+ | Company-wide technical strategy, build platforms/tools, represent org externally | $200K - $280K |
| **Engineering Manager** | 7+ | Lead teams, career growth, hiring, process, technical strategy combined | $170K - $230K |
| **Tech Lead** | 6+ | Technical direction for team, code review, system design, release management | $150K - $200K |
| **Freelance / Consultant** | 5+ | End-to-end delivery, client management, technical advisory | $120 - $250/hr |

### 19.2 System Design Topics

Mobile-specific system design you should master for Staff+ interviews:

- **Offline-first architecture:** Sync engine design, conflict resolution (CRDT vs LWW), write-ahead logs
- **Image/video pipeline:** Upload optimization (multipart, chunked), CDN integration, caching layers, progressive loading
- **Real-time features:** WebSocket scaling, presence systems, message ordering, delivery guarantees
- **Push notification infrastructure:** Token management, delivery tracking, iOS vs Android routing, notification categories
- **Performance at scale:** Bundle splitting, lazy loading, memory profiling, startup optimization
- **Security:** Certificate pinning, App Attest, device integrity, runtime protection, data encryption at rest/in transit
- **Feature flagging:** A/B testing framework, gradual rollout, kill switch, experiment analysis

### 19.3 Portfolio & Visibility

- **Open source:** Contribute to React Native core, Expo, Reanimated, or popular community packages
- **Conference talks:** Submit to React Conf, Chain React, App.js Conf, React Native EU
- **Technical writing:** Publish deep-dives on performance, architecture decisions, migration stories (Dev.to, Medium, personal blog)
- **Release notes:** Document major migrations (e.g., "How we migrated 200K LOC to the New Architecture")
- **Side projects:** Ship polished apps to the App Store with 10K+ users
- **Metrics-driven impact:** Quantify everything — "Reduced crash rate by 60%", "Improved TTI by 40%", "Shipped 99th percentile FPS"

### 19.4 Interview Preparation

| Area | Topics | Resources |
|------|--------|-----------|
| **Mobile System Design** | Offline-first, sync, push, performance, security | Grokking Modern System Design, High Scalability blog |
| **React Native Deep** | New Architecture, Hermes internals, Fabric render | React Native docs, SWM blog, Meta Engineering blog |
| **Architecture** | Monorepo, micro-frontends, SDUI, modular architecture | Martin Fowler, Udi Dahan, RN Architecture forum |
| **DSA** | Arrays, trees, graphs, DP (mobile-relevant) | LeetCode (Medium/Hard), AlgoExpert |
| **Behavioral** | Leadership, conflict resolution, mentoring | Cracking the PM Interview, Staff Engineer book |
| **Debugging** | Memory leaks, thread contention, crash stacks | Flipper docs, Xcode Instruments, Android Studio Profiler |

---

## 20. Appendix: Production Cheatsheet

### 20.1 Quick Reference — Advanced Libraries

| Purpose | Library | Notes |
|---------|---------|-------|
| New Architecture | React Native 0.76+ | Enable `newArchEnabled` |
| Native Modules | expo-modules-core | Preferred for new modules |
| C++ JSI | jsi | For performance-critical native code |
| Animations | react-native-reanimated 3 | Worklets, shared values, layout |
| 2D Graphics | @shopify/react-native-skia | Canvas, paths, shaders |
| Streaming Graphics | lottie-react-native, rive-react-native | Vector animations |
| Offline DB | @nozbe/watermelondb | Sync engine, lazy queries |
| KV Storage | react-native-mmkv | Encrypted, multi-process |
| E2E Testing | detox | E2E for RN |
| Gestures | react-native-gesture-handler 2 | Composability, reanimated interop |
| Maps | react-native-maps | Clustering, custom markers |
| Camera | react-native-vision-camera | Frame processors |
| BLE | react-native-ble-plx | BLE communication |
| IAP | react-native-iap | Subscriptions, iap |
| App Attest | react-native-device-check | iOS device integrity |
| Background Tasks | react-native-background-actions | Long-running tasks |
| Permissions | react-native-permissions | Rationale flow |
| Network | @tanstack/react-query | Server state, mutations |
| Charts | victory-native | Data visualization |

### 20.2 Performance Budgets

| Metric | Target |
|--------|--------|
| App launch time (cold) | < 2 seconds |
| Time to Interactive | < 3 seconds |
| FPS (scrolling) | 60 FPS steady |
| FPS (animations) | 60 FPS steady |
| JS thread usage | < 60% during scrolling |
| Bundle size (uncompressed) | < 15 MB |
| APK size (arm64-v8a) | < 30 MB |
| IPA size | < 50 MB |
| RAM (idle) | < 150 MB |
| RAM (heavy usage) | < 300 MB |
| Crash-free rate | > 99.5% |
| App launch success rate | > 99.9% |

### 20.3 Debugging Commands

```bash
# React Native
npx react-native start --reset-cache
npx react-native log-ios
npx react-native log-android
npx react-native run-ios --simulator "iPhone 15 Pro"
npx react-native run-android --variant release

# Expo
npx expo start --tunnel
npx expo start --dev-client
npx expo run:ios --configuration Release
npx expo run:android --variant Release

# Build & Analyze
npx react-native bundle --platform ios --dev false --entry-file index.js --bundle-output bundle.js --sourcemap-output bundle.map
npx source-map-explorer bundle.js
npx react-native-bundle-visualizer

# Hermes
npx hermes --emit-binary -out index.hbc index.js
npx hermes --profile -out profile.cpuprofile -hermes-cpuprofile index.hbc

# EAS
npx eas build:list
npx eas update:list --branch production
npx eas diagnostics

# Detox
npx detox build --configuration ios.sim.release
npx detox test --configuration ios.sim.release --reuse

# Debug
adb logcat -s ReactNative:V ReactNativeJS:V     # Android logs
sudo sysdiagnose -f ./sysdiagnose                # iOS performance
```

### 20.4 Migration Checklist: RN 0.76+ New Architecture

- [ ] Update to RN 0.76+ or Expo SDK 52+
- [ ] Enable `newArchEnabled=true` in `gradle.properties`
- [ ] Set `RCT_NEW_ARCH_ENABLED=1` in `Podfile`
- [ ] Audit all dependencies for New Architecture support (use `react-native rn-diff-purge` or RN Directory)
- [ ] Test on iOS simulator and Android emulator
- [ ] Replace `NativeModules` with `TurboModuleRegistry.getEnforcing()`
- [ ] Replace `requireNativeComponent` with `codegenNativeComponent`
- [ ] Test UIManager-dependent code (drag-drop, custom layouts)
- [ ] Profile memory and FPS improvements
- [ ] Run E2E test suite
- [ ] Run performance regression tests
- [ ] Test on physical devices (minimum iOS 15, Android 10)
- [ ] Gradual rollout: 5% → 25% → 100%

### 20.5 Common Pitfalls

| Issue | Cause | Fix |
|-------|-------|-----|
| `Invariant Violation: TurboModuleRegistry` | Module not registered | Add spec file and run codegen |
| `findNodeHandle` returns null | Fabric removed imperative handles | Use refs with `useAnimatedRef` |
| Slow startup after migration | Old bridge still loaded | Disable JSC, ensure only Hermes |
| `RCTFont` size discrepancy | Fabric measures text differently | Test font sizes, use `allowFontScaling` |
| Gesture handler not working in modals | Gesture handler root missing | Wrap with `GestureHandlerRootView` |
| Memory leak after navigation | Screen not cleaned up | Use `useIsFocused` + cleanup |
| Push notification not showing | Channel not created (Android 8+) | Create notification channels |
| FlatList blank on scroll | `windowSize` too small | Increase to 7-10 |
| Keyboard avoiding not working | Missing `KeyboardAvoidingView` behavior | `behavior={Platform.OS === 'ios' ? 'padding' : 'height'}` |

---

*Last updated: June 2026*

*Built for experienced React Native engineers shipping at scale.*
