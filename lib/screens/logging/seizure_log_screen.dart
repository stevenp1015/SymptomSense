import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary after .g.dart generation
// import 'package:myapp/services/database_service.dart'; // Will be used once DB is working

// --- Providers for State Management ---
final seizureOccurredProvider = StateProvider<bool>((ref) => false);
final seizureSeverityProvider = StateProvider<int?>((ref) => null); // Nullable for "not set"
final seizureNotesProvider = StateProvider<String>((ref) => '');

class SeizureLogScreen extends ConsumerWidget {
  final CDLoggedEvent? existingEvent; // To pass an event for editing

  const SeizureLogScreen({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize providers if existingEvent is present (only on first build of this instance)
    // This is a common pattern. For more complex scenarios, consider a dedicated init provider.
    if (existingEvent != null && ModalRoute.of(context)?.isCurrent == true) { // Check isCurrent to avoid re-init on pop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) { // Double check after frame
            // Check if providers already match existingEvent to prevent re-init if state managed elsewhere or on rebuilds
            if (ref.read(seizureOccurredProvider) != (existingEvent?.isSeizureEvent ?? false) ||
                ref.read(seizureSeverityProvider) != existingEvent?.seizureSeverity ||
                ref.read(seizureNotesProvider) != (existingEvent?.notes ?? '')) {

                ref.read(seizureOccurredProvider.notifier).state = existingEvent?.isSeizureEvent ?? false;
                ref.read(seizureSeverityProvider.notifier).state = existingEvent?.seizureSeverity;
                ref.read(seizureNotesProvider.notifier).state = existingEvent?.notes ?? '';
                // Note: Timestamp editing UI is not part of this simple log screen yet.
                // If it were, you'd initialize its provider here too.
            }
        }
      });
    }


    final bool seizureOccurred = ref.watch(seizureOccurredProvider);
    final int? severity = ref.watch(seizureSeverityProvider);
    final String notes = ref.watch(seizureNotesProvider);

    // Placeholder for database service
    // final dbService = ref.watch(databaseServiceProvider); // Assuming you'll have a provider for DatabaseService

    return Scaffold(
      appBar: AppBar(
        title: Text(existingEvent == null ? 'Log Seizure' : 'Edit Seizure Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (seizureOccurred && severity != null) || !seizureOccurred // Enable save if occurred + severity, or if not occurred
                ? () async {
                    if (!seizureOccurred) {
                      // If user explicitly saves a "no seizure" state
                      print('Seizure Log: "No seizure occurred" indicated by user.');
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Noted: No seizure occurred this time.')),
                      );
                      Navigator.pop(context);
                      return;
                    }

                    if (severity == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please choose a severity for the seizure.')),
                      );
                      return;
                    }

                    CDLoggedEvent eventToSave;
                    if (existingEvent != null) {
                      // Update existing event
                      eventToSave = existingEvent!.copyWith( // Assuming a copyWith method
                        isSeizureEvent: true, // If seizureOccurred is true
                        seizureSeverity: severity,
                        notes: notes.isNotEmpty ? notes : null,
                        // timestampOccurredUTC should be editable on screen if needed
                        // timestampLoggedUTC remains from original log
                      );
                       // If CDLoggedEvent doesn't have copyWith, manually update fields:
                       // existingEvent!.isSeizureEvent = true;
                       // existingEvent!.seizureSeverity = severity;
                       // existingEvent!.notes = notes.isNotEmpty ? notes : null;
                       // eventToSave = existingEvent!;
                    } else {
                      // Create new event
                      eventToSave = CDLoggedEvent(
                        timestampOccurredUTC: DateTime.now().toUtc(), // User might adjust this on screen
                        eventType: EventType.seizure,
                        isSeizureEvent: true,
                        seizureSeverity: severity,
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
                    //     SnackBar(content: Text('Seizure details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Take care.')),
                    //   );
                    //   if (existingEvent == null) { // Only reset for new logs
                    //      ref.read(seizureOccurredProvider.notifier).state = false;
                    //      ref.read(seizureSeverityProvider.notifier).state = null;
                    //      ref.read(seizureNotesProvider.notifier).state = '';
                    //   }
                    //   Navigator.pop(context);
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Sorry, could not save seizure log: $e')),
                    //   );
                    // }
                    print('--- SIMULATED ${existingEvent == null ? "SAVE" : "UPDATE"} ---');
                    print('Seizure Logged:');
                    print('  ID: ${eventToSave.id}');
                    print('  Occurred: ${eventToSave.isSeizureEvent}');
                    print('  Severity: ${eventToSave.seizureSeverity}');
                    print('  Notes: ${eventToSave.notes}');
                    print('  Timestamp Occurred: ${eventToSave.timestampOccurredUTC}');
                    print('  Timestamp Logged: ${eventToSave.timestampLoggedUTC}');
                    print('----------------------');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Seizure details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Take care.')),
                    );

                    if (existingEvent == null) { // Only reset for new logs to allow further edits if needed
                         ref.read(seizureOccurredProvider.notifier).state = false;
                         ref.read(seizureSeverityProvider.notifier).state = null;
                         ref.read(seizureNotesProvider.notifier).state = '';
                    }
                    Navigator.pop(context);
                  }
                : null, // Disable button if occurred but no severity (for new log)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Option 1: Simple Yes/No for occurrence
            Text("Did a seizure occur recently?", style: Theme.of(context).textTheme.titleMedium),
            SwitchListTile(
              title: Text(seizureOccurred ? 'Yes, a seizure occurred' : 'No, thankfully no seizure'),
              value: seizureOccurred,
              onChanged: (bool value) {
                ref.read(seizureOccurredProvider.notifier).state = value;
                if (!value) {
                  // If no seizure, clear severity
                  ref.read(seizureSeverityProvider.notifier).state = null;
                }
              },
            ),
            const SizedBox(height: 20),

            if (seizureOccurred) ...[
              Text('How severe was it? (0-10): ${severity ?? "Not set"}', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: (severity ?? 0).toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: (severity ?? 0).toString(),
                onChanged: (double value) {
                  ref.read(seizureSeverityProvider.notifier).state = value.toInt();
                },
              ),
              const SizedBox(height: 20),
              Text('Optional Notes:', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                initialValue: notes,
                decoration: const InputDecoration(
                  hintText: 'e.g., what happened before, during, after...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ref.read(seizureNotesProvider.notifier).state = value;
                },
              ),
            ],
            if (!seizureOccurred)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "If no seizure occurred, you can simply go back or tap save to acknowledge checking.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
      ),
    );
  }
}
