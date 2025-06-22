# SymptomSense Project Setup & Automation Guide

This guide provides instructions and automation scripts to set up the SymptomSense Flutter project with minimal manual effort.

## 1. Prerequisites

Before you begin, ensure you have the following installed on your system:

*   **Flutter SDK:** Download and install from [flutter.dev](https://flutter.dev/docs/get-started/install).
*   **Git:** For version control.
*   **An IDE (Optional but Recommended):** Android Studio (with Flutter plugin) or Visual Studio Code (with Flutter extension).
*   **Xcode (for iOS development/widgets):** Required for building and running the iOS version and setting up the iOS widget.

## 2. Critical: Flutter SDK Path Configuration

For the Flutter command-line tools (`flutter`, `dart`) to work correctly in your terminal, the Flutter SDK's `bin` directory must be in your system's `PATH` environment variable. **This is the most common reason for setup failures like `flutter: command not found`.**

**Finding your Flutter SDK Path:**
This is the directory where you unzipped the Flutter SDK download. For example, it might be `~/development/flutter` or `C:\flutter`.

**Adding Flutter to your PATH:**

*   **macOS & Linux:**
    1.  Open your shell configuration file (e.g., `~/.zshrc` for Zsh, `~/.bashrc` or `~/.bash_profile` for Bash).
    2.  Add the following line, replacing `[PATH_TO_FLUTTER_SDK]` with the actual path to your Flutter SDK directory:
        ```bash
        export PATH="$PATH:[PATH_TO_FLUTTER_SDK]/bin"
        ```
        *Example:* `export PATH="$PATH:/Users/yourname/development/flutter/bin"`
    3.  Save the file and restart your terminal or run `source ~/.zshrc` (or equivalent for your shell).
    4.  Verify by typing `flutter doctor` in a new terminal window. You should see output from Flutter, not "command not found".

*   **Windows:**
    1.  From the Start search bar, type 'env' and select "Edit environment variables for your account".
    2.  Under "User variables", find the entry for "Path". If it doesn't exist, create it.
    3.  Select the "Path" variable and click "Edit...".
    4.  Click "New" and add the full path to your Flutter SDK's `bin` directory (e.g., `C:\flutter\bin`).
    5.  Click "OK" on all dialog windows to save the changes.
    6.  Close and reopen any existing terminal windows.
    7.  Verify by typing `flutter doctor` in a new Command Prompt or PowerShell window.

## 3. Project Dependencies & Code Generation

Once Flutter is correctly in your PATH, you need to fetch project dependencies and generate necessary code (like Isar database files).

**Automated Script (macOS/Linux):**

1.  Save the following as `setup_project.sh` in the root of this project:
    ```bash
    #!/bin/bash
    echo "SymptomSense Project Setup Script"
    echo "----------------------------------"

    # Step 1: Ensure Flutter SDK is found
    if ! command -v flutter &> /dev/null
    then
        echo "ERROR: Flutter command could not be found."
        echo "Please ensure the Flutter SDK 'bin' directory is in your PATH."
        echo "Refer to SETUP_AUTOMATION.md for instructions."
        exit 1
    fi
    echo "Flutter SDK found!"

    # Step 2: Get Flutter packages
    echo ""
    echo "Running 'flutter pub get' to fetch dependencies..."
    flutter pub get
    if [ $? -ne 0 ]; then
        echo "ERROR: 'flutter pub get' failed. Please check your internet connection and Flutter setup."
        exit 1
    fi
    echo "'flutter pub get' completed successfully."

    # Step 3: Run build_runner for code generation (Isar, etc.)
    echo ""
    echo "Running 'flutter pub run build_runner build --delete-conflicting-outputs'..."
    flutter pub run build_runner build --delete-conflicting-outputs
    if [ $? -ne 0 ]; then
        echo "ERROR: 'build_runner' failed. This often happens if 'pub get' had issues or there are code errors."
        echo "Review any error messages above. Ensure all dependencies are compatible."
        exit 1
    fi
    echo "'build_runner' completed successfully."

    echo ""
    echo "----------------------------------"
    echo "Project setup seems complete! You should now be able to run the app."
    echo "Next steps: Configure API Keys and check iOS Widget setup."
    ```
2.  Make it executable: `chmod +x setup_project.sh`
3.  Run it: `./setup_project.sh`

**Manual Commands (All Platforms - if script fails or for Windows):**

Open your terminal/command prompt in the project root directory and run:

1.  `flutter pub get`
2.  `flutter pub run build_runner build --delete-conflicting-outputs`

If these commands succeed, your project's dependencies and generated files are ready.

## 4. API Key Configuration (Gemini API)

The application uses the Gemini API for generating insights.

1.  **Obtain an API Key:** You'll need to get an API key from Google AI Studio (or your Gemini provider).
2.  **Update Placeholder:**
    *   Open the file: `lib/services/gemini_service.dart`
    *   Find the line: `const String _geminiApiKeyPlaceholder = "YOUR_GEMINI_API_KEY_HERE";`
    *   Replace `"YOUR_GEMINI_API_KEY_HERE"` with your actual Gemini API key.
    ```dart
    // Example:
    // const String _geminiApiKeyPlaceholder = "AIzaSyB...your...actual...key...xyz";
    ```
3.  **Security Warning (IMPORTANT for Production):**
    *   Storing API keys directly in client-side code is **highly insecure** and not recommended for production apps.
    *   **Post-MVP, you MUST move to a more secure solution**, such as:
        *   Storing the key in environment variables that are accessed during the build process (e.g., using `flutter_dotenv` package).
        *   Using a backend proxy server that securely stores the API key and makes requests to the Gemini API on behalf of the app. The app then communicates with your proxy.

## 5. iOS Widget Setup (Reminder)

For the iOS Quick Log widgets to function, you need to perform native iOS setup in Xcode. Please refer to the detailed instructions provided at the end of **Step 7 (Implement iOS Widget Launchers)** in the agent's plan log or comments in `lib/services/widget_service.dart`. Key tasks include:

*   Configuring an **App Group** in Xcode for both the main app target and the Widget Extension target.
*   Ensuring the **App Group ID** matches the one in `lib/services/widget_service.dart`.
*   Implementing the Widget Extension's UI (SwiftUI) to display buttons and construct deep links.
*   Configuring `Info.plist` for URL Schemes (`symptomsense://`).
*   Verifying `AppDelegate.swift` setup for `home_widget`.

## 6. Running the Application

Once the above steps are complete:

*   **Connect a device or start an emulator/simulator.**
*   In your terminal, from the project root, run:
    ```bash
    flutter run
    ```
*   To choose a specific device/emulator if multiple are connected:
    ```bash
    flutter devices # Lists available devices
    flutter run -d [DEVICE_ID] # Replace [DEVICE_ID] with the ID from the list
    ```

## 7. Troubleshooting Common Issues

*   **`flutter: command not found` or `dart: command not found`:**
    *   Your Flutter SDK `bin` directory is not in your system's PATH. Refer to **Section 2**.
*   **`build_runner` errors or "Generated file ... not found":**
    *   Ensure `flutter pub get` completed without errors.
    *   Delete the `.dart_tool` directory and try `flutter pub get` and the `build_runner` command again.
    *   Check for any Dart analysis errors in your code that might prevent generation.
*   **`home_widget` related errors or widget not updating/launching app:**
    *   Double-check the **App Group ID** matches exactly between Xcode (main app target, widget extension target) and `lib/services/widget_service.dart`.
    *   Ensure the Widget Extension target is correctly configured in Xcode (see native iOS setup instructions).
    *   Verify the URL Scheme in `Info.plist` and the deep link URI structure used by the widget.
    *   Make sure `flutter pub get` has successfully fetched `home_widget`.
*   **API Key issues / Gemini API errors:**
    *   Ensure the API key in `gemini_service.dart` is correct and has the necessary permissions.
    *   For real API calls (post-MVP), check network connectivity.
    *   The current MVP uses simulated API calls, so errors here would likely be in the parsing or display logic if the simulation itself is changed.

---
This document aims to make your setup process as smooth as possible. If you encounter issues not covered here, please refer to the official Flutter and package documentations.
