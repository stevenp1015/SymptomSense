import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary

// --- Providers for State Management ---
final selectedMedicationProvider = StateProvider<String?>((ref) => null);
final isPRNProvider = StateProvider<bool>((ref) => false);
final medicationNotesProvider = StateProvider<String>((ref) => '');

// Mock data for predefined medications - this will come from DatabaseService later
final mockMedicationsProvider = Provider<List<String>>((ref) {
  // In a real app, this would fetch from CDUserMedication via DatabaseService
  // For MVP, user defines medication names.
  return ["Medication A", "Medication B", "Medication C", "PainRelief X (PRN)", "AntiNausea Y"];
});

class MedicationLogScreen extends ConsumerWidget {
  final CDLoggedEvent? existingEvent;
  const MedicationLogScreen({super.key, this.existingEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (existingEvent != null && ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
           if (ref.read(selectedMedicationProvider) != existingEvent?.medicationNameRef ||
               ref.read(isPRNProvider) != (existingEvent?.isPRN ?? false) ||
               ref.read(medicationNotesProvider) != (existingEvent?.notes ?? '')) {
              ref.read(selectedMedicationProvider.notifier).state = existingEvent?.medicationNameRef;
              ref.read(isPRNProvider.notifier).state = existingEvent?.isPRN ?? false;
              ref.read(medicationNotesProvider.notifier).state = existingEvent?.notes ?? '';
           }
        }
      });
    }

    final String? selectedMedication = ref.watch(selectedMedicationProvider);
    final bool isPRN = ref.watch(isPRNProvider);
    final String notes = ref.watch(medicationNotesProvider);
    final List<String> availableMedications = ref.watch(mockMedicationsProvider);

    // Placeholder for database service
    // final dbService = ref.watch(databaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingEvent == null ? 'Log Medication' : 'Edit Medication Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: selectedMedication != null
                ? () async {
                    CDLoggedEvent eventToSave;
                    if (existingEvent != null) {
                      eventToSave = existingEvent!.copyWith(
                        medicationNameRef: selectedMedication,
                        isPRN: isPRN,
                        notes: notes.isNotEmpty ? notes : null,
                      );
                    } else {
                      eventToSave = CDLoggedEvent(
                        timestampOccurredUTC: DateTime.now().toUtc(), // User might adjust
                        eventType: EventType.medication,
                        medicationNameRef: selectedMedication,
                        isPRN: isPRN,
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
                    //     SnackBar(content: Text('Medication intake ${existingEvent == null ? "recorded" : "updated"} (Simulated). Good job staying on top of it!')),
                    //   );
                    //   if (existingEvent == null) {
                    //      ref.read(selectedMedicationProvider.notifier).state = null;
                    //      ref.read(isPRNProvider.notifier).state = false;
                    //      ref.read(medicationNotesProvider.notifier).state = '';
                    //   }
                    //   Navigator.pop(context);
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Sorry, could not save medication log: $e')),
                    //   );
                    // }
                    print('--- SIMULATED ${existingEvent == null ? "SAVE" : "UPDATE"} ---');
                    print('Medication Logged:');
                    print('  ID: ${eventToSave.id}');
                    print('  Name: ${eventToSave.medicationNameRef}');
                    print('  PRN: ${eventToSave.isPRN}');
                    print('  Notes: ${eventToSave.notes}');
                    print('  Timestamp Occurred: ${eventToSave.timestampOccurredUTC}');
                    print('  Timestamp Logged: ${eventToSave.timestampLoggedUTC}');
                    print('----------------------');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Medication intake ${existingEvent == null ? "recorded" : "updated"} (Simulated). Good job staying on top of it!')),
                    );

                    if (existingEvent == null) {
                         ref.read(selectedMedicationProvider.notifier).state = null;
                         ref.read(isPRNProvider.notifier).state = false;
                         ref.read(medicationNotesProvider.notifier).state = '';
                    }
                    Navigator.pop(context);
                  }
                : null, // Disable button if no medication selected
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text("Select Medication:", style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: selectedMedication,
              hint: const Text('Choose a medication'),
              isExpanded: true,
              items: availableMedications.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                ref.read(selectedMedicationProvider.notifier).state = newValue;
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text('Taken as PRN (as-needed)?'),
              value: isPRN,
              onChanged: (bool value) {
                ref.read(isPRNProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 20),

            Text('Optional Notes:', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: notes,
              decoration: const InputDecoration(
                hintText: 'e.g., reason for PRN, efficacy...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                ref.read(medicationNotesProvider.notifier).state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
