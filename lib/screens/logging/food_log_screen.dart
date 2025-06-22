import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary

// --- Providers for State Management ---
// Using a list of strings for selected categories
final selectedFoodCategoriesProvider = StateProvider<List<String>>((ref) => []);
final foodNotesProvider = StateProvider<String>((ref) => '');

// Mock data for food categories - this will come from DatabaseService (CDUserDefinedListItem of type FoodCategory)
final mockFoodCategoriesProvider = Provider<List<String>>((ref) {
  return ["Carbs", "Protein Drink", "Protein Meal", "Sugar", "High Histamine", "Safe Meal", "Dairy", "Gluten"];
});

class FoodLogScreen extends ConsumerWidget {
  final CDLoggedEvent? existingEvent;
  const FoodLogScreen({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (existingEvent != null && ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          if (ref.read(selectedFoodCategoriesProvider) != (existingEvent?.foodCategoryTagsRef ?? []) ||
              ref.read(foodNotesProvider) != (existingEvent?.notes ?? '')) {
            ref.read(selectedFoodCategoriesProvider.notifier).state = List<String>.from(existingEvent?.foodCategoryTagsRef ?? []);
            ref.read(foodNotesProvider.notifier).state = existingEvent?.notes ?? '';
          }
        }
      });
    }

    final List<String> selectedCategories = ref.watch(selectedFoodCategoriesProvider);
    final String notes = ref.watch(foodNotesProvider);
    final List<String> availableCategories = ref.watch(mockFoodCategoriesProvider);

    // Placeholder for database service
    // final dbService = ref.watch(databaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingEvent == null ? 'Log Food Intake' : 'Edit Food Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: selectedCategories.isNotEmpty
                ? () async {
                    CDLoggedEvent eventToSave;
                    if (existingEvent != null) {
                      eventToSave = existingEvent!.copyWith(
                        foodCategoryTagsRef: selectedCategories,
                        notes: notes.isNotEmpty ? notes : null,
                        eventType: EventType.food,
                      );
                    } else {
                      eventToSave = CDLoggedEvent(
                        timestampOccurredUTC: DateTime.now().toUtc(), // User might adjust
                        eventType: EventType.food,
                        foodCategoryTagsRef: selectedCategories,
                        notes: notes.isNotEmpty ? notes : null,
                      );
                    }

                    // --- DATABASE INTERACTION (Commented out) ---
                    // try {
                    //   if (existingEvent != null) {
                    //     // await dbService.updateLoggedEvent(eventToSave);
                    //   } else {
                    //     // await dbService.saveLoggedEvent(eventToSave);
                    //   }
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Food intake ${existingEvent == null ? "recorded" : "updated"} (Simulated). Thanks for logging!')),
                    //   );
                    //   if (existingEvent == null) {
                    //      ref.read(selectedFoodCategoriesProvider.notifier).state = [];
                    //      ref.read(foodNotesProvider.notifier).state = '';
                    //   }
                    //   Navigator.pop(context);
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Sorry, could not save food log: $e')),
                    //   );
                    // }
                    print('--- SIMULATED ${existingEvent == null ? "SAVE" : "UPDATE"} ---');
                    print('Food Logged:');
                    print('  ID: ${eventToSave.id}');
                    print('  Categories: ${eventToSave.foodCategoryTagsRef?.join(', ')}');
                    print('  Notes: ${eventToSave.notes}');
                    print('  Timestamp Occurred: ${eventToSave.timestampOccurredUTC}');
                    print('  Timestamp Logged: ${eventToSave.timestampLoggedUTC}');
                    print('----------------------');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Food intake ${existingEvent == null ? "recorded" : "updated"} (Simulated). Thanks for logging!')),
                    );

                    if (existingEvent == null) {
                        ref.read(selectedFoodCategoriesProvider.notifier).state = [];
                        ref.read(foodNotesProvider.notifier).state = '';
                    }
                    Navigator.pop(context);
                  }
                : null, // Disable button if no categories selected
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text("Select Food Categories/Tags (multiple allowed):", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: availableCategories.map((category) {
                final isSelected = selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    final currentSelected = List<String>.from(ref.read(selectedFoodCategoriesProvider));
                    if (selected) {
                      currentSelected.add(category);
                    } else {
                      currentSelected.remove(category);
                    }
                    ref.read(selectedFoodCategoriesProvider.notifier).state = currentSelected;
                  },
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Text('Optional Notes (e.g., specific food items, reaction concerns):', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: notes,
              decoration: const InputDecoration(
                hintText: 'Details about the meal or items...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                ref.read(foodNotesProvider.notifier).state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
