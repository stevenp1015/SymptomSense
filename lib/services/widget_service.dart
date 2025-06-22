import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// home_widget will cause errors until pub get works
import 'package:home_widget/home_widget.dart';
// import 'package:home_widget_json_store/home_widget_json_store.dart'; // Alternative storage if needed

import 'package:myapp/screens/settings/configure_quick_log_screen.dart' show QuickLogConfigItem;
// Import logging screen providers to reset them
import 'package:myapp/screens/logging/seizure_log_screen.dart';
import 'package:myapp/screens/logging/medication_log_screen.dart';
import 'package:myapp/screens/logging/pain_log_screen.dart';
import 'package:myapp/screens/logging/key_symptom_log_screen.dart';
import 'package:myapp/screens/logging/sleep_log_screen.dart';
import 'package:myapp/screens/logging/food_log_screen.dart';

// --- App Group ID (Needs to be configured in Xcode) ---
// IMPORTANT: Replace with your actual App Group ID
const String appGroupId = 'group.com.example.symptomsense'; // Placeholder

// --- Widget Data Keys (must match keys used in the native widget code) ---
const String widgetDataKeyPrefix = 'quickLogButton_'; // e.g., quickLogButton_0, quickLogButton_1
const String widgetConfigCountKey = 'quickLogConfigCount';


final widgetServiceProvider = Provider<WidgetService>((ref) {
  return WidgetService(ref);
});

class WidgetService {
  final Ref _ref;
  WidgetService(this._ref) {
    // Initialize HomeWidget settings if needed (though typically done in main)
    // HomeWidget.setAppGroupId(appGroupId); // Set App Group ID
  }

  // Call this when quick log configurations change to update the widget's data
  Future<void> updateWidgetData(List<QuickLogConfigItem?> configs) async {
    if (!await _isHomeWidgetAvailable()) return;

    final Map<String, dynamic> dataToSave = {};
    int activeConfigs = 0;
    for (int i = 0; i < configs.length; i++) {
      final config = configs[i];
      if (config != null) {
        activeConfigs++;
        // For MVP, we'll store enough info for the widget to construct a deep link
        // The widget itself won't display complex data, just be a launcher.
        dataToSave['${widgetDataKeyPrefix}type_$i'] = config.type;
        dataToSave['${widgetDataKeyPrefix}value_$i'] = config.primaryValue;
        // A user-friendly label for the widget button itself could also be stored
        dataToSave['${widgetDataKeyPrefix}label_$i'] = _getWidgetButtonLabel(config);
      } else {
        // Clear old data if a slot is now empty
        dataToSave['${widgetDataKeyPrefix}type_$i'] = null;
        dataToSave['${widgetDataKeyPrefix}value_$i'] = null;
        dataToSave['${widgetDataKeyPrefix}label_$i'] = null;
      }
    }
    dataToSave[widgetConfigCountKey] = activeConfigs;

    try {
      // HomeWidget.saveWidgetData uses SharedPreferences specific to the widget extension (via App Group)
      // This allows the native widget to read this data.
      final success = await HomeWidget.saveWidgetData<String>(jsonEncode(dataToSave)); // Encode the whole map as a single JSON string
      if (success == true) {
         print("WidgetService: Successfully saved widget data.");
         await HomeWidget.updateWidget(
            name: 'SymptomSenseQuickLogWidget', // iOS: Widget Extension Bundle ID (or kind)
            iOSName: 'SymptomSenseQuickLogWidget', // iOS: Widget Extension Bundle ID (Target Name)
         );
         print("WidgetService: Requested widget update.");
      } else {
         print("WidgetService: Failed to save widget data.");
      }
    } catch (e) {
      print("WidgetService: Error saving widget data: $e");
      // This might fail if home_widget is not properly set up or App Group ID is missing/incorrect.
    }
  }

  String _getWidgetButtonLabel(QuickLogConfigItem item) {
    if (item.type == "seizure") return "Log Seizure";
    if (item.type == "sleep") return "Log Sleep";
    if (item.type == "food_general") return "Log Food";
    if (item.type == "pain_location") return "Pain: ${item.primaryValue.split(' ').first}";
    if (item.type == "medication") return "Med: ${item.primaryValue.split(' ').first}";
    if (item.type == "key_symptom") return item.primaryValue.split(' ').first; // Shorten
    if (item.type == "food_category") return "Food: ${item.primaryValue.split(' ').first}";
    return item.primaryValue;
  }

  // Initialize listener for widget clicks (deep links)
  // This should be called early in your app's lifecycle, e.g., in main.dart or a root widget.
  void initWidgetClickListener(GlobalKey<NavigatorState> navigatorKey) {
    HomeWidget.setAppGroupId(appGroupId); // Ensure App Group ID is set
    HomeWidget.initiallyLaunchedFromHomeWidget().then((Uri? uri) {
      if (uri != null) {
        print("WidgetService: App initially launched from widget with URI: $uri");
        _handleDeepLink(uri, navigatorKey);
      }
    });

    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        print("WidgetService: Widget clicked with URI: $uri");
        _handleDeepLink(uri, navigatorKey);
      }
    }, onError: (dynamic error) {
        print('WidgetService: Error listening to widget clicks: $error');
    });
  }

  void _handleDeepLink(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
    // Deep link format: symptomsense://log?type=medication&value=Medication%20A
    // Or: symptomsense://log/seizure (if path based)
    final String? actionType = uri.queryParameters['actionType']; // e.g., "seizure", "medication", "pain"
    final String? primaryValue = uri.queryParameters['primaryValue']; // e.g., "Medication A", "Right Shoulder"

    print("WidgetService: Handling deep link - Action: $actionType, Value: $primaryValue");

    if (actionType == null) {
      print("WidgetService: Deep link actionType is null. Cannot navigate.");
      return;
    }

    // Ensure we have context to navigate
    final context = navigatorKey.currentContext;
    if (context == null) {
        print("WidgetService: Navigator context is null. Cannot navigate via deep link.");
        return;
    }
    final WidgetRef ref = ProviderScope.containerOf(context, listen: false);


    // Navigate to the appropriate logging screen
    // It's crucial to reset the state providers for these screens before navigating.
    switch (actionType) {
      case "seizure":
        ref.invalidate(seizureOccurredProvider);
        ref.invalidate(seizureSeverityProvider);
        ref.invalidate(seizureNotesProvider);
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SeizureLogScreen()));
        break;
      case "sleep":
        ref.invalidate(sleepHoursProvider);
        ref.invalidate(sleepDateProvider);
        ref.invalidate(sleepNotesProvider);
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SleepLogScreen()));
        break;
      case "medication":
        ref.invalidate(selectedMedicationProvider);
        ref.invalidate(isPRNProvider);
        ref.invalidate(medicationNotesProvider);
        if (primaryValue != null) {
          // Attempt to pre-select the medication. This assumes primaryValue is the exact medication name.
          // The MedicationLogScreen would need to be adapted to potentially receive this initial value.
          // For MVP, simple navigation is okay; pre-fill is an enhancement.
           WidgetsBinding.instance.addPostFrameCallback((_) {
             ref.read(selectedMedicationProvider.notifier).state = primaryValue;
           });
        }
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MedicationLogScreen()));
        break;
      case "pain_location":
        ref.invalidate(selectedPainLocationProvider);
        ref.invalidate(painSeverityProvider);
        ref.invalidate(painNotesProvider);
         if (primaryValue != null) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedPainLocationProvider.notifier).state = primaryValue;
           });
        }
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PainLogScreen()));
        break;
      case "key_symptom":
        ref.invalidate(selectedKeySymptomProvider);
        ref.invalidate(keySymptomSeverityProvider);
        ref.invalidate(keySymptomNotesProvider);
        if (primaryValue != null) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedKeySymptomProvider.notifier).state = primaryValue;
           });
        }
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const KeySymptomLogScreen()));
        break;
      case "food_general":
      case "food_category": // For MVP, both can just open the general food log. Pre-selection for category is enhancement.
        ref.invalidate(selectedFoodCategoriesProvider);
        ref.invalidate(foodNotesProvider);
        if (actionType == "food_category" && primaryValue != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(selectedFoodCategoriesProvider.notifier).state = [primaryValue];
            });
        }
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FoodLogScreen()));
        break;
      default:
        print("WidgetService: Unknown deep link action type: $actionType");
        // Optionally navigate to a default screen or show an error
    }
  }

  Future<bool> _isHomeWidgetAvailable() async {
    try {
      return await HomeWidget.isSupported;
    } catch(e) {
      print("WidgetService: Error checking HomeWidget support (likely plugin not fully initialized): $e");
      return false;
    }
  }
}

// --- Global Navigator Key (to be defined in main.dart) ---
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// And then pass it to initWidgetClickListener
// ref.read(widgetServiceProvider).initWidgetClickListener(navigatorKey);
