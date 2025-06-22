import 'package:isar/isar.dart';

part 'data_model.g.dart';

// Enum for Event Types, mirroring CDLoggedEvent sub-entities for MVP
enum EventType {
  symptom,
  seizure, // Specific MVP item, can be a specialized symptom
  medication,
  food,
  sleep,
  // otherFactor // For future expansion
}

// Enum for UserDefinedListItem types, as per blueprint
enum UserListItemType {
  symptomName, // For Key Symptoms quick logging
  painLocation,
  foodCategory,
  medicationName, // For user's medication list
  // activityType, // Post-MVP
  // prnReason, // Post-MVP
  // auraType, // Post-MVP
  // environmentalTrigger, // Post-MVP
  // moodTag, // Post-MVP
  // contextualTag // Post-MVP
}

@collection
class CDLoggedEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestampOccurredUTC; // Actual event time

  late DateTime timestampLoggedUTC; // Time of logging

  String? notes; // Optional general notes

  @Enumerated(EnumType.name)
  late EventType eventType; // To distinguish the type of log

  // --- Fields for specific event types ---

  // For Seizure (MVP specific fields from 2.1.1)
  bool? isSeizureEvent; // If true, this was a seizure
  int? seizureSeverity; // 0-10, if isSeizureEvent is true

  // For Medication Intake (MVP specific fields from 2.1.1)
  String? medicationNameRef; // Name from CDUserMedication
  bool? isPRN;
  // Optional quick note for medication is covered by general 'notes'

  // For Pain (MVP specific fields from 2.1.1)
  String? painLocationTagRef; // Tag from CDUserDefinedListItem (PainLocation)
  int? painSeverity; // 0-10

  // For Key Symptoms (MVP specific fields from 2.1.1)
  // User selects one of their top 3-5 symptoms
  String? keySymptomNameRef; // Name from CDUserDefinedListItem (SymptomName)
  int? keySymptomSeverity; // 0-10

  // For Sleep (MVP specific fields from 2.1.1)
  int? sleepTotalHours; // Total hours slept

  // For Basic Food Categories (MVP specific fields from 2.1.1)
  List<String>? foodCategoryTagsRef; // List of tags from CDUserDefinedListItem (FoodCategory)
  // Optional quick note for food is covered by general 'notes'


  CDLoggedEvent({
    required this.timestampOccurredUTC,
    required this.eventType,
    this.notes,
    this.isSeizureEvent,
    this.seizureSeverity,
    this.medicationNameRef,
    this.isPRN,
    this.painLocationTagRef,
    this.painSeverity,
    this.keySymptomNameRef,
    this.keySymptomSeverity,
    this.sleepTotalHours,
    this.foodCategoryTagsRef,
  }) {
    timestampLoggedUTC = DateTime.now().toUtc();
  }

  //copyWith method
  CDLoggedEvent copyWith({
    Id? id,
    DateTime? timestampOccurredUTC,
    DateTime? timestampLoggedUTC, // Usually not changed on edit
    String? notes,
    EventType? eventType,
    bool? isSeizureEvent,
    int? seizureSeverity,
    String? medicationNameRef,
    bool? isPRN,
    String? painLocationTagRef,
    int? painSeverity,
    String? keySymptomNameRef,
    int? keySymptomSeverity,
    int? sleepTotalHours,
    List<String>? foodCategoryTagsRef,
  }) {
    final newEvent = CDLoggedEvent(
      timestampOccurredUTC: timestampOccurredUTC ?? this.timestampOccurredUTC,
      eventType: eventType ?? this.eventType,
      notes: notes ?? this.notes,
      isSeizureEvent: isSeizureEvent ?? this.isSeizureEvent,
      seizureSeverity: seizureSeverity ?? this.seizureSeverity,
      medicationNameRef: medicationNameRef ?? this.medicationNameRef,
      isPRN: isPRN ?? this.isPRN,
      painLocationTagRef: painLocationTagRef ?? this.painLocationTagRef,
      painSeverity: painSeverity ?? this.painSeverity,
      keySymptomNameRef: keySymptomNameRef ?? this.keySymptomNameRef,
      keySymptomSeverity: keySymptomSeverity ?? this.keySymptomSeverity,
      sleepTotalHours: sleepTotalHours ?? this.sleepTotalHours,
      foodCategoryTagsRef: foodCategoryTagsRef ?? this.foodCategoryTagsRef,
    );
    // Preserve original ID and logged timestamp
    newEvent.id = id ?? this.id;
    newEvent.timestampLoggedUTC = timestampLoggedUTC ?? this.timestampLoggedUTC;
    return newEvent;
  }
}


// Stores details of medications the user takes (MVP: name only)
@collection
class CDUserMedication {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String medicationName; // Unique name for the medication

  bool isActive = true; // For soft-delete

  CDUserMedication({required this.medicationName, this.isActive = true});
}

// Stores user's custom tags/categories for various lists
@collection
class CDUserDefinedListItem {
  Id id = Isar.autoIncrement;

  @Index()
  @Enumerated(EnumType.name) // Using custom EnumType here for Isar
  late UserListItemType listType;

  @Index() // Index for easier searching/filtering by name
  late String itemName; // The actual tag/category text

  int itemOrder = 0; // For user-defined sorting if needed
  bool isActive = true; // For soft-delete

  CDUserDefinedListItem({
    required this.listType,
    required this.itemName,
    this.itemOrder = 0,
    this.isActive = true,
  });
}

// For Gemini API Feedback (MVP 2.1.4)
@collection
class CDInsightFeedback {
  Id id = Isar.autoIncrement;
  String? insightAPIRefID; // ID from Gemini API for the insight
  late String userFeedbackResponse; // e.g., "Resonates", "DoesNotResonate", "Maybe"
  late DateTime feedbackTimestampUTC;
  String? optionalUserComment;

  CDInsightFeedback({
    this.insightAPIRefID,
    required this.userFeedbackResponse,
    this.optionalUserComment,
  }) {
    feedbackTimestampUTC = DateTime.now().toUtc();
  }
}