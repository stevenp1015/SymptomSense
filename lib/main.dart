import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:myapp/screens/dashboard/dashboard_screen.dart'; // Import Dashboard
// It's good practice to initialize services like DB early, but for MVP structure,
// we'll rely on Riverpod providers being accessed when needed.
// If DatabaseService needed early init:
// import 'package:myapp/services/database_service.dart';

// GlobalKey for navigator, useful for services that need context or navigation without it.
import 'package:myapp/services/widget_service.dart'; // Import WidgetService
// home_widget will cause errors until pub get works
// import 'package:home_widget/home_widget.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async main and some plugins
  // It's important to set AppGroupId before using HomeWidget methods if not done by service itself.
  // However, WidgetService constructor or initWidgetClickListener can also call HomeWidget.setAppGroupId.
  // For clarity, if a specific call is needed early:
  // await HomeWidget.setAppGroupId(appGroupId); // appGroupId from widget_service.dart

  // Initialize Isar DB (DatabaseService) - this would be the place if it's not lazy loaded via Riverpod
  // However, our DatabaseService is designed to initialize on first use via Riverpod.
  // If you had a global instance:
  // final dbService = DatabaseService(); // This initializes the db Future
  // await dbService.db; // Ensure DB is open before app runs fully (optional, depends on design)

  runApp(
    ProviderScope( // Wrap with ProviderScope for Riverpod
      child: MyApp(navigatorKey: navigatorKey), // Pass navigatorKey
    ),
  );
}

class MyApp extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> { // Create State class
  @override
  void initState() {
    super.initState();
    // Initialize widget click listener here
    // Ensure WidgetService is available.
    // Use WidgetsBinding.instance.addPostFrameCallback to ensure services are ready if they depend on context/providers.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Check if widget is still in the tree
         try {
            ref.read(widgetServiceProvider).initWidgetClickListener(widget.navigatorKey);
         } catch (e) {
            print("Error initializing widget click listener in MyApp: $e");
            // This might happen if home_widget plugin isn't fully initialized or available
         }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey, // Use the passed navigatorKey
      title: 'SymptomSense', // Updated App Title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7), // A deep purple, can be customized
          brightness: Brightness.light, // Default to light theme
        ),
        useMaterial3: true, // Recommended for modern Flutter apps
        // --- Further Theme Customization based on Blueprint ---
        textTheme: const TextTheme(
          // Define some text styles that align with "calm & clear"
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500), // For greetings
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),    // For section titles
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),   // For item titles/labels
          bodyMedium: TextStyle(fontSize: 14.0),                                // For general text
          labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),   // For button text
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // backgroundColor: const Color(0xFF673AB7), // Button background
            // foregroundColor: Colors.white, // Button text/icon color
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            // borderSide: BorderSide.none, // Cleaner look if preferred
          ),
          filled: true,
          // fillColor: Colors.grey.shade100, // Light fill for text fields
        ),
        // Consider a custom font if desired later
      ),
      // TODO: Implement Dark Theme option post-MVP
      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color(0xFF673AB7),
      //     brightness: Brightness.dark,
      //   ),
      //   useMaterial3: true,
      // ),
      // themeMode: ThemeMode.system, // Or allow user to choose
      home: const DashboardScreen(), // Set DashboardScreen as the home
    );
  }
}

// The old MyHomePage widget is no longer needed as DashboardScreen is the new home.
// class MyHomePage extends StatefulWidget { ... }
// class _MyHomePageState extends State<MyHomePage> { ... }
