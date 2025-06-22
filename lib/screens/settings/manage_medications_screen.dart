import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary

// --- Mock Data and Providers ---
// This would eventually hold CDUserMedication objects
final mockUserMedicationsProvider = StateNotifierProvider<MockUserMedicationsNotifier, List<CDUserMedication>>((ref) {
  return MockUserMedicationsNotifier([
    CDUserMedication(medicationName: "Medication A"),
    CDUserMedication(medicationName: "Medication B (Old)", isActive: false), // Example of inactive
    CDUserMedication(medicationName: "PainRelief X"),
  ]);
});

class MockUserMedicationsNotifier extends StateNotifier<List<CDUserMedication>> {
  MockUserMedicationsNotifier(super.state);

  // Simulates adding to DB and updating state
  void addMedication(String name) {
    final newMed = CDUserMedication(medicationName: name);
    // In real app: await dbService.saveUserMedication(newMed);
    // Then refetch or update state based on successful save.
    state = [...state, newMed];
    print("SIMULATED ADD: Medication '${newMed.medicationName}' added.");
  }

  // Simulates updating in DB
  void editMedication(int id, String newName, bool isActive) {
     // In real app, you'd fetch by original name or a proper ID from Isar
     // For mock, we'll find by current name if ID is not reliable yet
    final index = state.indexWhere((med) => med.medicationName == state.firstWhere((m) => m.id == id, orElse: () => state[0]).medicationName); // Mock find
    if (index != -1) {
      final oldMed = state[index];
      final updatedMed = CDUserMedication(medicationName: newName)..id = oldMed.id..isActive = isActive;
      // In real app: await dbService.saveUserMedication(updatedMed);
      final newState = List<CDUserMedication>.from(state);
      newState[index] = updatedMed;
      state = newState;
      print("SIMULATED EDIT: Medication '${oldMed.medicationName}' to '${updatedMed.medicationName}', Active: ${updatedMed.isActive}");
    }
  }

  // Simulates toggling active status
  void toggleActiveStatus(CDUserMedication medication) {
    editMedication(medication.id, medication.medicationName, !medication.isActive);
  }
}


class ManageMedicationsScreen extends ConsumerWidget {
  const ManageMedicationsScreen({super.key});

  void _showMedicationDialog(BuildContext context, WidgetRef ref, {CDUserMedication? medicationToEdit}) {
    final TextEditingController nameController = TextEditingController(text: medicationToEdit?.medicationName ?? '');
    bool isActive = medicationToEdit?.isActive ?? true;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(medicationToEdit == null ? 'Add New Medication' : 'Edit Medication'),
          content: StatefulBuilder( // For the active toggle within the dialog
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Medication Name'),
                    autofocus: true,
                  ),
                  if (medicationToEdit != null)
                    SwitchListTile(
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (bool value) {
                        setState(() { // Update dialog's local state for the switch
                          isActive = value;
                        });
                      },
                    ),
                ],
              );
            }
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(medicationToEdit == null ? 'Add' : 'Save'),
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  if (medicationToEdit == null) {
                    ref.read(mockUserMedicationsProvider.notifier).addMedication(name);
                  } else {
                    // For mock, we pass the original medication's 'id' if it has one, or a placeholder
                    ref.read(mockUserMedicationsProvider.notifier).editMedication(medicationToEdit.id, name, isActive);
                  }
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name for the medication.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CDUserMedication> medications = ref.watch(mockUserMedicationsProvider);
    // Filter to show active ones first, then inactive, or sort alphabetically then by active status
    final sortedMedications = List<CDUserMedication>.from(medications)
      ..sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return a.medicationName.toLowerCase().compareTo(b.medicationName.toLowerCase());
      });


    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Medications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Medication',
            onPressed: () => _showMedicationDialog(context, ref),
          ),
        ],
      ),
      body: medications.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No medications added yet. Tap the + icon to add your first one. Keeping this list updated helps with quick logging!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ))
          : ListView.builder(
              itemCount: sortedMedications.length,
              itemBuilder: (context, index) {
                final med = sortedMedications[index];
                return ListTile(
                  title: Text(
                    med.medicationName,
                    style: TextStyle(
                      decoration: !med.isActive ? TextDecoration.lineThrough : null,
                      color: !med.isActive ? Colors.grey : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(med.isActive ? Icons.toggle_on_outlined : Icons.toggle_off_outlined),
                        tooltip: med.isActive ? 'Mark as Inactive' : 'Mark as Active',
                        color: med.isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
                        onPressed: () {
                           ref.read(mockUserMedicationsProvider.notifier).toggleActiveStatus(med);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Medication',
                        onPressed: () => _showMedicationDialog(context, ref, medicationToEdit: med),
                      ),
                    ],
                  ),
                  onTap: () => _showMedicationDialog(context, ref, medicationToEdit: med),
                );
              },
            ),
    );
  }
}
