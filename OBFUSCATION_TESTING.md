# Security & Obfuscation Testing Guide

This document outlines the step-by-step process for verifying that the React Native application's source code, both JavaScript and Android (Java/Kotlin), is properly obfuscated and protected in a release build.

## Prerequisites

To perform these tests, you will need the following tools installed on your system:

1. **Jadx-GUI / Jadx:** A Dex to Java decompiler for inspecting Android code. (Install via `brew install jadx`)
2. **Apktool:** A tool for reverse engineering Android apk files. (Install via `brew install apktool`)
3. **Hex Viewer / Command Line Tools:** Basic tools like `unzip`, `strings`, `grep`, and `xxd` (available by default on macOS/Linux).

---

## Step 0: Generate a Release Build

Before testing, ensure you are testing a fresh **Release** build. Debug builds are never obfuscated.

```bash
cd android
./gradlew clean
./gradlew assembleRelease
```

The APK will be generated at: `android/app/build/outputs/apk/release/app-release.apk`

---

## Step 1: Verify JavaScript Protection (Hermes Bytecode)

**Goal:** Ensure the React Native JavaScript code (`App.js`, API files, logic) is compiled into a binary format and is not readable as plain text.

1. **Extract the Bundle:**
   ```bash
   unzip -p android/app/build/outputs/apk/release/app-release.apk assets/index.android.bundle > index.android.bundle
   ```
2. **Inspect the Header:**
   Check the first few bytes of the bundle file to confirm it is binary.
   ```bash
   head -c 10 index.android.bundle | xxd
   ```
3. **Expected Result:**
   The output should look like random hex values (e.g., `c61f bc03...`), and you should **not** see readable JavaScript code (like `import React...` or `function...`). This confirms Hermes is active and the JS is secure.

---

## Step 2: Verify Java/Kotlin Obfuscation (ProGuard/R8)

**Goal:** Ensure custom Android code and logic (like security checks, modules) are renamed to meaningless characters, making reverse engineering difficult.

1. **Open the APK in Jadx-GUI:**
   Launch `jadx-gui` and open the `app-release.apk` file.
2. **Navigate to the Custom Package:**
   Go to `Sources` -> `com` -> `app` -> `qrecapp`.
3. **What to Check:**
   - You should see the mandatory entry points (`MainActivity`, `MainApplication`). This is normal and required by Android.
   - You should **NOT** see internal logic files or helper classes clearly named (e.g., `SecurityCheckPackage`).
   - Look for files named `a`, `b`, `c`, etc. Inside these files, methods and variables should also be renamed to single letters.
4. **Command Line Verification (Alternative):**
   Search the `classes.dex` for a custom class you know should be hidden:
   ```bash
   unzip -p android/app/build/outputs/apk/release/app-release.apk classes.dex | strings | grep "SecurityCheckPackage"
   ```
   **Expected Result:** The command should return **no results** (empty output), meaning the string was obfuscated.

---

## Step 3: Verify Metadata and Source File Hiding

**Goal:** Ensure that decompilers cannot reconstruct original file names (e.g., `MainActivity.java`) from the compiled code's metadata.

1. **Inspect Code in Jadx-GUI:**
   Open any obfuscated class (or even `MainActivity`) in Jadx-GUI.
2. **Look for the "Source File" Comment:**
   At the very top of the decompiled class, Jadx usually prints a comment indicating the original file name.
3. **Expected Result:**
   Because of our aggressive ProGuard rules (`-renamesourcefileattribute SourceFile`), the top of the file should simply say:
   `// SourceFile: SourceFile` or `/* compiled from: SourceFile */`.
   It must **NOT** reveal the original `.java` or `.kt` file name.

---

## Conclusion of Verification

If all three steps pass:

1. **JS is binary.**
2. **Java/Kotlin is renamed.**
3. **Metadata is stripped.**

The application meets standard security requirements for code protection and is resilient against casual reverse-engineering attempts.

This file contains a clear, step-by-step guide formatted exactly for your feature project testing documentation. It details:

1.  Prerequisites (the tools needed like Jadx and Apktool).
2.  How to generate the build properly.
3.  Step 1: Verifying Hermes bytecode for JavaScript.
4.  Step 2: Verifying DEX obfuscation for Java/Kotlin classes.
5.  Step 3: Verifying metadata stripping (hiding original file names).
