import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // For CDLoggedEvent and Enums
// import 'package:myapp/services/database_service.dart'; // Will use this later
import 'package:intl/intl.dart'; // For date formatting

// Import logging screens for navigation and their providers for invalidation
import 'package:myapp/screens/logging/seizure_log_screen.dart';
import 'package:myapp/screens/logging/medication_log_screen.dart';
import 'package:myapp/screens/logging/pain_log_screen.dart';
import 'package:myapp/screens/logging/key_symptom_log_screen.dart';
import 'package:myapp/screens/logging/sleep_log_screen.dart';
import 'package:myapp/screens/logging/food_log_screen.dart';


// --- Mock Data Provider ---
// This provider will supply mock CDLoggedEvent data until DB is working.
// In a real scenario, this would fetch from DatabaseService.
final mockChronologicalEventsProvider = Provider<List<CDLoggedEvent>>((ref) {
  // Create some diverse mock events
  return [
    CDLoggedEvent(
      timestampOccurredUTC: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
      eventType: EventType.medication,
      medicationNameRef: "Medication A",
      isPRN: false,
      notes: "Morning dose",
    )..id=1,
    CDLoggedEvent(
      timestampOccurredUTC: DateTime.now().toUtc().subtract(const Duration(hours: 2)),
      eventType: EventType.pain,
      painLocationTagRef: "Right Shoulder",
      painSeverity: 6,
    )..id=2,
    CDLoggedEvent(
      timestampOccurredUTC: DateTime.now().toUtc().subtract(const Duration(hours: 4)),
      eventType: EventType.food,
      foodCategoryTagsRef: ["Carbs", "Protein Meal"],
      notes: "Lunch with a friend",
    )..id=3,
    CDLoggedEvent(
      timestampOccurredUTC: DateTime.now().toUtc().subtract(const Duration(days: 1, hours:1)),
      eventType: EventType.seizure,
      isSeizureEvent: true,
      seizureSeverity: 7,
      notes: "Felt tired beforehand",
    )..id=4,
     CDLoggedEvent(
      timestampOccurredUTC: DateTime.now().toUtc().subtract(const Duration(days: 1, hours:10)),
      eventType: EventType.sleep,
      sleepTotalHours: 7,
      notes: "Woke up once",
    )..id=5,
    CDLoggedEvent(
      timestampOccurredUTC: DateTime.now().toUtc().subtract(const Duration(days: 2, hours:3)),
      eventType: EventType.keySymptom,
      keySymptomNameRef: "Fatigue",
      keySymptomSeverity: 8,
    )..id=6,
  ]..sort((a,b) => b.timestampOccurredUTC.compareTo(a.timestampOccurredUTC)); // Ensure reverse chrono
});


class ChronologicalHistoryScreen extends ConsumerWidget {
  const ChronologicalHistoryScreen({super.key});

  Widget _buildEventIcon(EventType type) {
    switch (type) {
      case EventType.symptom:
        return const Icon(Icons.thermostat_outlined, color: Colors.orange); // Generic symptom
      case EventType.seizure:
        return const Icon(Icons.bolt_outlined, color: Colors.redAccent);
      case EventType.medication:
        return const Icon(Icons.medication_outlined, color: Colors.blue);
      case EventType.food:
        return const Icon(Icons.fastfood_outlined, color: Colors.green);
      case EventType.sleep:
        return const Icon(Icons.bedtime_outlined, color: Colors.purple);
      default:
        return const Icon(Icons.notes_outlined, color: Colors.grey);
    }
  }

  String _formatEventDetails(CDLoggedEvent event) {
    String details = "";
    switch (event.eventType) {
      case EventType.symptom: // This also covers pain and keySymptom for now as per data_model
        if (event.painLocationTagRef != null) { // Pain
          details = "Pain: ${event.painLocationTagRef}, Severity: ${event.painSeverity}/10";
        } else if (event.keySymptomNameRef != null) { // Key Symptom
          details = "Symptom: ${event.keySymptomNameRef}, Severity: ${event.keySymptomSeverity}/10";
        } else {
          details = "General Symptom Logged"; // Fallback
        }
        break;
      case EventType.seizure:
        details = "Seizure Occurred, Severity: ${event.seizureSeverity}/10";
        break;
      case EventType.medication:
        details = "Took: ${event.medicationNameRef ?? 'N/A'}${event.isPRN == true ? ' (PRN)' : ''}";
        break;
      case EventType.food:
        details = "Ate: ${event.foodCategoryTagsRef?.join(', ') ?? 'N/A'}";
        break;
      case EventType.sleep:
        details = "Slept: ${event.sleepTotalHours ?? 'N/A'} hours";
        break;
      default:
        details = "Logged Event";
    }
    if (event.notes != null && event.notes!.isNotEmpty) {
      details += "\nNotes: ${event.notes}";
    }
    return details;
  }

  void _navigateToEditScreen(BuildContext context, WidgetRef ref, CDLoggedEvent event) {
    // Check if event is within editable timeframe (e.g., last 48 hours)
    final bool isEditable = DateTime.now().toUtc().difference(event.timestampOccurredUTC).inHours <= 48;

    if (!isEditable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This log is too old to edit (older than 48 hours).')),
      );
      return;
    }

    // Clear relevant providers before navigating to ensure fresh state for editing screen
    // This is a simplified approach. Depending on how providers are structured,
    // you might need more targeted invalidation or a way to pass initial data without
    // relying on global provider reset if multiple edit instances could exist.

    Widget screenToNavigate;
    switch (event.eventType) {
      case EventType.seizure:
        ref.invalidate(seizureOccurredProvider);
        ref.invalidate(seizureSeverityProvider);
        ref.invalidate(seizureNotesProvider);
        screenToNavigate = SeizureLogScreen(existingEvent: event);
        break;
      case EventType.medication:
        ref.invalidate(selectedMedicationProvider);
        ref.invalidate(isPRNProvider);
        ref.invalidate(medicationNotesProvider);
        screenToNavigate = MedicationLogScreen(existingEvent: event);
        break;
      case EventType.symptom: // This covers Pain and KeySymptom based on current model
        if (event.painLocationTagRef != null) { // It's a Pain log
            ref.invalidate(selectedPainLocationProvider);
            ref.invalidate(painSeverityProvider);
            ref.invalidate(painNotesProvider);
            screenToNavigate = PainLogScreen(existingEvent: event);
        } else if (event.keySymptomNameRef != null) { // It's a Key Symptom log
            ref.invalidate(selectedKeySymptomProvider);
            ref.invalidate(keySymptomSeverityProvider);
            ref.invalidate(keySymptomNotesProvider);
            screenToNavigate = KeySymptomLogScreen(existingEvent: event);
        } else {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot edit this type of general symptom log yet.')));
            return;
        }
        break;
      case EventType.sleep:
        ref.invalidate(sleepHoursProvider);
        ref.invalidate(sleepDateProvider);
        ref.invalidate(sleepNotesProvider);
        screenToNavigate = SleepLogScreen(existingEvent: event);
        break;
      case EventType.food:
        ref.invalidate(selectedFoodCategoriesProvider);
        ref.invalidate(foodNotesProvider);
        screenToNavigate = FoodLogScreen(existingEvent: event);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing for "${event.eventType.name}" logs is not implemented yet.')),
        );
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => screenToNavigate));
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<CDLoggedEvent> events = ref.watch(databaseServiceProvider).getAllLoggedEvents(); // Real call
    final List<CDLoggedEvent> events = ref.watch(mockChronologicalEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Log History'),
      ),
      body: events.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No events logged yet. Start tracking to see your history here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ))
          : ListView.separated(
              itemCount: events.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  leading: _buildEventIcon(event.eventType),
                  title: Text(
                    // Capitalize first letter of event type for display
                    event.eventType.name[0].toUpperCase() + event.eventType.name.substring(1),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    "${DateFormat.yMMMEd().add_jm().format(event.timestampOccurredUTC.toLocal())}\n"
                    "${_formatEventDetails(event)}",
                  ),
                  isThreeLine: (event.notes != null && event.notes!.isNotEmpty) || _formatEventDetails(event).contains("\n"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_note_outlined),
                    tooltip: "Edit Log Entry",
                    onPressed: () => _navigateToEditScreen(context, ref, event),
                  ),
                  onTap: () => _navigateToEditScreen(context, ref, event),
                ); // Removed extra comma/brace here
              },
            ),
    );
  }
}
