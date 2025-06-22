import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary

// --- Providers for State Management ---
final selectedKeySymptomProvider = StateProvider<String?>((ref) => null);
final keySymptomSeverityProvider = StateProvider<int>((ref) => 0); // Default to 0
final keySymptomNotesProvider = StateProvider<String>((ref) => '');


// Mock data for key symptoms - this will come from DatabaseService (CDUserDefinedListItem of type SymptomName)
final mockKeySymptomsProvider = Provider<List<String>>((ref) {
  // User defines these in settings, e.g., their top 3-5 most frequent/impactful
  return ["Nausea", "Dizziness", "Fatigue", "Brain Fog", "Joint Subluxation X"];
});

class KeySymptomLogScreen extends ConsumerWidget {
  final CDLoggedEvent? existingEvent;
  const KeySymptomLogScreen({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (existingEvent != null && ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (ModalRoute.of(context)?.isCurrent == true) {
            if (ref.read(selectedKeySymptomProvider) != existingEvent?.keySymptomNameRef ||
                ref.read(keySymptomSeverityProvider) != (existingEvent?.keySymptomSeverity ?? 0) ||
                ref.read(keySymptomNotesProvider) != (existingEvent?.notes ?? '')) {
              ref.read(selectedKeySymptomProvider.notifier).state = existingEvent?.keySymptomNameRef;
              ref.read(keySymptomSeverityProvider.notifier).state = existingEvent?.keySymptomSeverity ?? 0;
              ref.read(keySymptomNotesProvider.notifier).state = existingEvent?.notes ?? '';
            }
         }
      });
    }

    final String? selectedSymptom = ref.watch(selectedKeySymptomProvider);
    final int severity = ref.watch(keySymptomSeverityProvider);
    final String notes = ref.watch(keySymptomNotesProvider); // General notes
    final List<String> availableSymptoms = ref.watch(mockKeySymptomsProvider);

    // Placeholder for database service
    // final dbService = ref.watch(databaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingEvent == null ? 'Log Key Symptom' : 'Edit Symptom Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: selectedSymptom != null
                ? () async {
                    CDLoggedEvent eventToSave;
                    if (existingEvent != null) {
                      eventToSave = existingEvent!.copyWith(
                        keySymptomNameRef: selectedSymptom,
                        keySymptomSeverity: severity,
                        notes: notes.isNotEmpty ? notes : null,
                        eventType: EventType.symptom,
                      );
                    } else {
                      eventToSave = CDLoggedEvent(
                        timestampOccurredUTC: DateTime.now().toUtc(), // User might adjust
                        eventType: EventType.symptom,
                        keySymptomNameRef: selectedSymptom,
                        keySymptomSeverity: severity,
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
                    //     SnackBar(content: Text('Symptom details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Tracking this is helpful!')),
                    //   );
                    //   if (existingEvent == null) {
                    //      ref.read(selectedKeySymptomProvider.notifier).state = null;
                    //      ref.read(keySymptomSeverityProvider.notifier).state = 0;
                    //      ref.read(keySymptomNotesProvider.notifier).state = '';
                    //   }
                    //   Navigator.pop(context);
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Sorry, could not save symptom log: $e')),
                    //   );
                    // }
                    print('--- SIMULATED ${existingEvent == null ? "SAVE" : "UPDATE"} ---');
                    print('Key Symptom Logged:');
                    print('  ID: ${eventToSave.id}');
                    print('  Symptom: ${eventToSave.keySymptomNameRef}');
                    print('  Severity: ${eventToSave.keySymptomSeverity}');
                    print('  Notes: ${eventToSave.notes}');
                    print('  Timestamp Occurred: ${eventToSave.timestampOccurredUTC}');
                    print('  Timestamp Logged: ${eventToSave.timestampLoggedUTC}');
                    print('----------------------');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Symptom details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Tracking this is helpful!')),
                    );

                    if (existingEvent == null) {
                        ref.read(selectedKeySymptomProvider.notifier).state = null;
                        ref.read(keySymptomSeverityProvider.notifier).state = 0;
                        ref.read(keySymptomNotesProvider.notifier).state = '';
                    }
                    Navigator.pop(context);
                  }
                : null, // Disable button if no symptom selected
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text("Select Symptom:", style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: selectedSymptom,
              hint: const Text('Choose a key symptom'),
              isExpanded: true,
              items: availableSymptoms.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                ref.read(selectedKeySymptomProvider.notifier).state = newValue;
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
                ref.read(keySymptomSeverityProvider.notifier).state = value.toInt();
              },
            ),
            const SizedBox(height: 20),

            Text('Optional Notes:', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: notes,
              decoration: const InputDecoration(
                hintText: 'Any additional details...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                ref.read(keySymptomNotesProvider.notifier).state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
