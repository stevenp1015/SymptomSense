import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary

// --- Providers for State Management ---
final selectedPainLocationProvider = StateProvider<String?>((ref) => null);
final painSeverityProvider = StateProvider<int>((ref) => 0); // Default to 0
final painNotesProvider = StateProvider<String>((ref) => '');

// Mock data for pain locations - this will come from DatabaseService (CDUserDefinedListItem)
final mockPainLocationsProvider = Provider<List<String>>((ref) {
  return ["Right Shoulder", "Lower Back", "Generalised", "Left Knee", "Neck"];
});

class PainLogScreen extends ConsumerWidget {
  final CDLoggedEvent? existingEvent;
  const PainLogScreen({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (existingEvent != null && ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          if (ref.read(selectedPainLocationProvider) != existingEvent?.painLocationTagRef ||
              ref.read(painSeverityProvider) != (existingEvent?.painSeverity ?? 0) ||
              ref.read(painNotesProvider) != (existingEvent?.notes ?? '')) {
            ref.read(selectedPainLocationProvider.notifier).state = existingEvent?.painLocationTagRef;
            ref.read(painSeverityProvider.notifier).state = existingEvent?.painSeverity ?? 0;
            ref.read(painNotesProvider.notifier).state = existingEvent?.notes ?? '';
          }
        }
      });
    }

    final String? selectedLocation = ref.watch(selectedPainLocationProvider);
    final int severity = ref.watch(painSeverityProvider);
    final String notes = ref.watch(painNotesProvider);
    final List<String> availableLocations = ref.watch(mockPainLocationsProvider);

    // Placeholder for database service
    // final dbService = ref.watch(databaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingEvent == null ? 'Log Pain' : 'Edit Pain Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: selectedLocation != null
                ? () async {
                    CDLoggedEvent eventToSave;
                    if (existingEvent != null) {
                      eventToSave = existingEvent!.copyWith(
                        painLocationTagRef: selectedLocation,
                        painSeverity: severity,
                        notes: notes.isNotEmpty ? notes : null,
                        eventType: EventType.symptom, // Ensure eventType is set if it could be different
                      );
                    } else {
                      eventToSave = CDLoggedEvent(
                        timestampOccurredUTC: DateTime.now().toUtc(), // User might adjust
                        eventType: EventType.symptom,
                        painLocationTagRef: selectedLocation,
                        painSeverity: severity,
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
                    //     SnackBar(content: Text('Pain details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Hope you feel better soon.')),
                    //   );
                    //    if (existingEvent == null) {
                    //       ref.read(selectedPainLocationProvider.notifier).state = null;
                    //       ref.read(painSeverityProvider.notifier).state = 0;
                    //       ref.read(painNotesProvider.notifier).state = '';
                    //    }
                    //   Navigator.pop(context);
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Sorry, could not save pain log: $e')),
                    //   );
                    // }
                    print('--- SIMULATED ${existingEvent == null ? "SAVE" : "UPDATE"} ---');
                    print('Pain Logged:');
                    print('  ID: ${eventToSave.id}');
                    print('  Location: ${eventToSave.painLocationTagRef}');
                    print('  Severity: ${eventToSave.painSeverity}');
                    print('  Notes: ${eventToSave.notes}');
                    print('  Timestamp Occurred: ${eventToSave.timestampOccurredUTC}');
                    print('  Timestamp Logged: ${eventToSave.timestampLoggedUTC}');
                    print('----------------------');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pain details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Hope you feel better soon.')),
                    );

                    if (existingEvent == null) {
                        ref.read(selectedPainLocationProvider.notifier).state = null;
                        ref.read(painSeverityProvider.notifier).state = 0;
                        ref.read(painNotesProvider.notifier).state = '';
                    }
                    Navigator.pop(context);
                  }
                : null, // Disable button if no location selected
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text("Select Pain Location:", style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: selectedLocation,
              hint: const Text('Choose a location'),
              isExpanded: true,
              items: availableLocations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                ref.read(selectedPainLocationProvider.notifier).state = newValue;
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            Text('Severity (0-10): $severity', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: severity.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: severity.toString(),
              onChanged: (double value) {
                ref.read(painSeverityProvider.notifier).state = value.toInt();
              },
            ),
            const SizedBox(height: 20),

            Text('Optional Notes:', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: notes,
              decoration: const InputDecoration(
                hintText: 'e.g., type of pain, what makes it worse/better...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                ref.read(painNotesProvider.notifier).state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
