import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

// Import mock providers from other settings screens for available items
import 'package:myapp/screens/settings/manage_medications_screen.dart' show mockUserMedicationsProvider;
import 'package:myapp/screens/settings/manage_user_defined_list_screen.dart' show userDefinedListProvider;
import 'package:myapp/data/data_model.dart';
import 'package:myapp/services/widget_service.dart'; // Moved import to top


// --- Data Structure for a Quick Log Button Configuration ---
class QuickLogConfigItem {
  final String id; // Unique ID for the config slot, e.g., "quicklog_1"
  final String type; // e.g., "medication", "pain", "keysymptom", "food"
  final String primaryValue; // e.g., Medication Name, Pain Location, Symptom Name, Food Category
  String? secondaryValue; // e.g., Pre-selected severity for pain, or a specific food tag if type is 'food_single_tag'

  QuickLogConfigItem({
    required this.id,
    required this.type,
    required this.primaryValue,
    this.secondaryValue,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'primaryValue': primaryValue,
    'secondaryValue': secondaryValue,
  };

  factory QuickLogConfigItem.fromJson(Map<String, dynamic> json) => QuickLogConfigItem(
    id: json['id'],
    type: json['type'],
    primaryValue: json['primaryValue'],
    secondaryValue: json['secondaryValue'],
  );
}

// --- Provider for Quick Log Configuration ---
const String quickLogConfigKey = 'quickLogConfiguration';
final quickLogConfigProvider = StateNotifierProvider<QuickLogConfigNotifier, List<QuickLogConfigItem?>>((ref) {
  // Max 5 quick log buttons for MVP
  return QuickLogConfigNotifier(ref, List.generate(5, (_) => null));
});

// Removed duplicated/misplaced import and provider definitions that were here.

class QuickLogConfigNotifier extends StateNotifier<List<QuickLogConfigItem?>> {
  final Ref _ref;
  QuickLogConfigNotifier(this._ref, List<QuickLogConfigItem?> initialState) : super(initialState) {
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(quickLogConfigKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final loadedConfig = List<QuickLogConfigItem?>.generate(state.length, (index) => null);
      for (int i = 0; i < jsonList.length; i++) {
        if (i < loadedConfig.length && jsonList[i] != null) {
          loadedConfig[i] = QuickLogConfigItem.fromJson(jsonList[i] as Map<String, dynamic>);
        }
      }
      state = loadedConfig;
      // Also update widget when config is loaded initially
      // No need to await this, can run in background
      _ref.read(widgetServiceProvider).updateWidgetData(state);
    }
  }

  Future<void> _saveConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>?> jsonList = state.map((item) => item?.toJson()).toList();
    await prefs.setString(quickLogConfigKey, jsonEncode(jsonList));
    print("SIMULATED SAVE: Quick Log Configuration saved to SharedPreferences.");
    // Update the widget whenever the configuration is saved
    // No need to await this, can run in background
    _ref.read(widgetServiceProvider).updateWidgetData(state);
  }

  void setQuickLogItem(int index, QuickLogConfigItem? item) {
    if (index >= 0 && index < state.length) {
      final newState = List<QuickLogConfigItem?>.from(state);
      newState[index] = item;
      state = newState;
      _saveConfiguration(); // This will also trigger widget update
    }
  }

  void clearQuickLogItem(int index) {
    setQuickLogItem(index, null); // This will also trigger widget update
  }
}

// --- Helper to get available choices ---
class _AvailableChoice {
  final String displayValue;
  final String type; // "medication", "pain_location", "key_symptom", "food_category"
  final String primaryValue;

  _AvailableChoice({required this.displayValue, required this.type, required this.primaryValue});
}


class ConfigureQuickLogScreen extends ConsumerWidget {
  const ConfigureQuickLogScreen({super.key});

  List<_AvailableChoice> _getAvailableChoices(WidgetRef ref) {
    final List<_AvailableChoice> choices = [
      _AvailableChoice(displayValue: "--- Log Seizure ---", type: "seizure", primaryValue: "Seizure"),
      _AvailableChoice(displayValue: "--- Log Sleep ---", type: "sleep", primaryValue: "Sleep"),
    ];

    final medications = ref.watch(mockUserMedicationsProvider);
    for (var med in medications.where((m) => m.isActive)) {
      choices.add(_AvailableChoice(displayValue: "Med: ${med.medicationName}", type: "medication", primaryValue: med.medicationName));
    }

    final painLocations = ref.watch(userDefinedListProvider(UserListItemType.painLocation));
    for (var loc in painLocations.where((l) => l.isActive)) {
      choices.add(_AvailableChoice(displayValue: "Pain: ${loc.itemName}", type: "pain_location", primaryValue: loc.itemName));
    }

    final keySymptoms = ref.watch(userDefinedListProvider(UserListItemType.keySymptom));
    for (var sym in keySymptoms.where((s) => s.isActive)) {
      choices.add(_AvailableChoice(displayValue: "Symptom: ${sym.itemName}", type: "key_symptom", primaryValue: sym.itemName));
    }

    final foodCategories = ref.watch(userDefinedListProvider(UserListItemType.foodCategory));
     for (var cat in foodCategories.where((c) => c.isActive)) {
      choices.add(_AvailableChoice(displayValue: "Food: ${cat.itemName}", type: "food_category", primaryValue: cat.itemName));
    }
    // Could also add an option for "Log General Food Entry"
     choices.add(_AvailableChoice(displayValue: "--- Log General Food Entry ---", type: "food_general", primaryValue: "Food (General)"));


    return choices;
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<QuickLogConfigItem?> quickLogConfigs = ref.watch(quickLogConfigProvider);
    final List<_AvailableChoice> availableChoices = _getAvailableChoices(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Quick Log'),
        actions: [
            IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: "Help", // Simpler tooltip
                onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Choose up to 5 actions for quick access from your dashboard.')),
                    );
                },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: quickLogConfigs.length, // Max 5 slots
          itemBuilder: (context, index) {
            final currentConfig = quickLogConfigs[index];
            String dropdownValue = "empty"; // Special value for "None"
            if (currentConfig != null) {
                 dropdownValue = "${currentConfig.type}::${currentConfig.primaryValue}";
            }


            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dashboard Shortcut ${index + 1}:", style: Theme.of(context).textTheme.titleMedium),
                    DropdownButtonFormField<String>(
                      value: availableChoices.any((c) => "${c.type}::${c.primaryValue}" == dropdownValue) ? dropdownValue : "empty",
                      isExpanded: true,
                      hint: const Text("Choose a shortcut..."),
                      items: [
                        const DropdownMenuItem<String>(
                          value: "empty",
                          child: Text("-- None --", style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                        ...availableChoices.map((_AvailableChoice choice) {
                          return DropdownMenuItem<String>(
                            value: "${choice.type}::${choice.primaryValue}", // Combine type and value for uniqueness
                            child: Text(choice.displayValue),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue == null || newValue == "empty") {
                          ref.read(quickLogConfigProvider.notifier).clearQuickLogItem(index);
                        } else {
                          final parts = newValue.split("::");
                          final type = parts[0];
                          final primaryValue = parts[1];
                          ref.read(quickLogConfigProvider.notifier).setQuickLogItem(
                            index,
                            QuickLogConfigItem(
                              id: "quicklog_${index + 1}",
                              type: type,
                              primaryValue: primaryValue,
                              // Secondary value (like pain severity) could be configured here too in a more advanced UI
                            ),
                          );
                        }
                      },
                    ),
                     if (currentConfig != null && currentConfig.type == "pain_location")
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Note: Default severity for pain quick logs will be 0. User must adjust on log screen.", style: Theme.of(context).textTheme.bodySmall),
                        )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
