import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/screens/settings/configure_quick_log_screen.dart' show quickLogConfigProvider, QuickLogConfigItem;

// Import logging screens
import 'package:myapp/screens/logging/seizure_log_screen.dart';
import 'package:myapp/screens/logging/medication_log_screen.dart';
import 'package:myapp/screens/logging/pain_log_screen.dart';
import 'package:myapp/screens/logging/key_symptom_log_screen.dart';
import 'package:myapp/screens/logging/sleep_log_screen.dart';
import 'package:myapp/screens/logging/food_log_screen.dart';
// Import settings hub to navigate if no quick logs are set up
import 'package:myapp/screens/settings/settings_hub_screen.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _navigateToLogScreen(BuildContext context, WidgetRef ref, QuickLogConfigItem item) {
    // Reset relevant providers before navigating to ensure fresh state on log screens
    // This is a simple approach; more sophisticated state reset might be needed for complex scenarios.

    switch (item.type) {
      case "seizure":
        // Reset seizure providers
        ref.invalidate(seizureOccurredProvider);
        ref.invalidate(seizureSeverityProvider);
        ref.invalidate(seizureNotesProvider);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SeizureLogScreen()));
        break;
      case "sleep":
        // Reset sleep providers
        ref.invalidate(sleepHoursProvider);
        ref.invalidate(sleepDateProvider);
        ref.invalidate(sleepNotesProvider);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SleepLogScreen()));
        break;
      case "medication":
        // Reset medication providers
        ref.invalidate(selectedMedicationProvider);
        ref.invalidate(isPRNProvider);
        ref.invalidate(medicationNotesProvider);
        // Potentially pre-fill medication if item.primaryValue is the med name
        // For MVP, direct navigation is fine. Pre-fill can be an enhancement.
        // ref.read(selectedMedicationProvider.notifier).state = item.primaryValue; // Example pre-fill
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicationLogScreen()));
        break;
      case "pain_location":
        // Reset pain providers
        ref.invalidate(selectedPainLocationProvider);
        ref.invalidate(painSeverityProvider);
        ref.invalidate(painNotesProvider);
        // ref.read(selectedPainLocationProvider.notifier).state = item.primaryValue; // Example pre-fill
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PainLogScreen()));
        break;
      case "key_symptom":
        // Reset key symptom providers
        ref.invalidate(selectedKeySymptomProvider);
        ref.invalidate(keySymptomSeverityProvider);
        ref.invalidate(keySymptomNotesProvider);
        // ref.read(selectedKeySymptomProvider.notifier).state = item.primaryValue; // Example pre-fill
        Navigator.push(context, MaterialPageRoute(builder: (context) => const KeySymptomLogScreen()));
        break;
      case "food_category": // This assumes logging a specific pre-selected category
      case "food_general": // This is for opening the general food log screen
         // Reset food providers
        ref.invalidate(selectedFoodCategoriesProvider);
        ref.invalidate(foodNotesProvider);
        // if (item.type == "food_category") {
        //   ref.read(selectedFoodCategoriesProvider.notifier).state = [item.primaryValue]; // Example pre-fill
        // }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodLogScreen()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown quick log type: ${item.type}')),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<QuickLogConfigItem?> quickLogConfigs = ref.watch(quickLogConfigProvider);
    final List<QuickLogConfigItem> activeQuickLogs = quickLogConfigs.whereType<QuickLogConfigItem>().toList();

    // For MVP, a simple greeting. Could be personalized later.
    final String greeting = "Welcome!";
    // final String userName = ref.watch(userProfileProvider).userName; // Example for future
    // final String greeting = "Good ${DateTime.now().hour < 12 ? 'morning' : DateTime.now().hour < 18 ? 'afternoon' : 'evening'}, [User Name]!"; // Placeholder for actual name

    // More empathetic greeting generation
    String timeOfDayGreeting;
    final hour = DateTime.now().hour;
    if (hour < 12) {
        timeOfDayGreeting = "Good morning";
    } else if (hour < 18) {
        timeOfDayGreeting = "Good afternoon";
    } else {
        timeOfDayGreeting = "Good evening";
    }
    // For MVP, as user's name isn't stored yet:
    final String greeting = "$timeOfDayGreeting! Ready to log or see how you're doing?";


    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsHubScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(greeting, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            Text("Quick Log:", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            if (activeQuickLogs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Your quick log shortcuts will appear here once set up.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.dashboard_customize_outlined),
                        label: const Text("Set Up Dashboard Shortcuts"),
                        onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigureQuickLogScreen()));
                        },
                      )
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Dashboard is not scrollable itself
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust for desired number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5, // Adjust for button aspect ratio
                ),
                itemCount: activeQuickLogs.length,
                itemBuilder: (context, index) {
                  final item = activeQuickLogs[index];
                  // Create a user-friendly label for the button
                  String buttonLabel = item.primaryValue;
                  if (item.type == "seizure") buttonLabel = "Log Seizure";
                  else if (item.type == "sleep") buttonLabel = "Log Sleep";
                  else if (item.type == "food_general") buttonLabel = "Log Food";
                  else if (item.type == "pain_location") buttonLabel = "Pain: ${item.primaryValue}";
                  else if (item.type == "medication") buttonLabel = "Med: ${item.primaryValue.split(' ').first}"; // Shorten
                  else if (item.type == "key_symptom") buttonLabel = item.primaryValue; // Already descriptive
                  else if (item.type == "food_category") buttonLabel = "Food: ${item.primaryValue}";


                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _navigateToLogScreen(context, ref, item),
                    child: Text(buttonLabel, textAlign: TextAlign.center),
                  );
                },
              ),

            const SizedBox(height: 30),
            // Placeholder for "Recent Activity Feed" or "Insight Card Snippet" (Post-MVP)
            // Text("Recent Activity:", style: Theme.of(context).textTheme.titleLarge),
            // Expanded(child: Center(child: Text("Recent logs will appear here."))),
            const SizedBox(height: 20),
            Text("View History:", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.list_alt_outlined),
                    label: const Text("List View"),
                    onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const ChronologicalHistoryScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text("Calendar View"),
                    onPressed: () {
                      // This will fail if table_calendar is not fetched
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarHistoryScreen()));
                    },
                  ),
                ),
              ],
            ),
             const SizedBox(height: 30),
            // Placeholder for "Insight Card Snippet" (Post-MVP)
            Text("Discover Insights:", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text("Analyze Symptom Correlations"),
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const InsightsScreen()));
                },
              ),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
      // --- Navigation Bar (Placeholder for MVP, actual navigation will be part of main.dart or a wrapper) ---
      // This is where a BottomNavigationBar would typically go.
      // For MVP, navigation is primarily through the dashboard and settings.
    );
  }
}

// Importing history screens
import 'package:myapp/screens/history/chronological_history_screen.dart';
import 'package:myapp/screens/history/calendar_history_screen.dart';
// Importing insights screen
import 'package:myapp/screens/insights/insights_screen.dart';
