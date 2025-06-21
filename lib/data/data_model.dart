import 'package:isar/isar.dart';

part 'data_model.g.dart'; // Isar generates this file

@collection
class LogEntry {
  Id id = Isar.autoIncrement; // Isar auto-increments the ID

  @Index() // Index for efficient querying by date
  late DateTime timestamp;

  bool? seizure; // True if a seizure occurred
  int? seizureSeverity; // 0-10
  List<MedicationIntake>? medications; // List of medications taken
  List<PainEntry>? painEntries; // List of pain entries
  List<String>? foodCategories; // List of food categories (e.g., "Carbs", "Sugar")
  int? exerciseEffort; // 0-10
  int? exerciseDurationMinutes; // Duration in minutes
  int? timeSpentUprightMinutes; // In minutes
  String? otherSymptom; // Write-in symptom
  String? notes; // General notes
  int? hoursSlept; // Hours slept
}

@embedded // Embedded in LogEntry
class MedicationIntake {
  String? name; // Optional medication name
}

@embedded // Embedded in LogEntry
class PainEntry {
  String? location; // e.g., "shoulder", "neck"
  int? severity; // 0-10
}