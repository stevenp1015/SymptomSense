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