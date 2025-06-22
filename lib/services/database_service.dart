import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/data/data_model.dart'; // Adjusted import path

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      // IMPORTANT: The schema list MUST match all @collection classes.
      // If data_model.g.dart is not generated yet due to Flutter SDK path issues,
      // this will not reflect the true schema list needed.
      // This list will need to be updated once build_runner succeeds.
      return await Isar.open(
        [
          CDLoggedEventSchema,
          CDUserMedicationSchema,
          CDUserDefinedListItemSchema,
          CDInsightFeedbackSchema,
          // Add other schemas here as they are created and generated
        ],
        directory: dir.path,
        inspector: kDebugMode, // Enable inspector in debug mode
      );
    }
    return Future.value(Isar.getInstance());
  }

  // --- CRUD Operations for CDLoggedEvent ---
  Future<void> saveLoggedEvent(CDLoggedEvent event) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cDEvents.put(event); // Corrected collection name
    });
  }

  Future<List<CDLoggedEvent>> getAllLoggedEvents() async {
    final isar = await db;
    return await isar.cDEvents.where().sortByTimestampOccurredUTCDesc().findAll(); // Corrected collection name
  }

  Future<List<CDLoggedEvent>> getLoggedEventsByDateRange(DateTime start, DateTime end) async {
    final isar = await db;
    return await isar.cDEvents // Corrected collection name
        .filter()
        .timestampOccurredUTCOrEqualTo(start)
        .and()
        .timestampOccurredUTCLessThan(end.add(const Duration(days: 1))) // Ensure end of day is included
        .sortByTimestampOccurredUTCDesc()
        .findAll();
  }

  Future<CDLoggedEvent?> getLoggedEventById(int id) async {
    final isar = await db;
    return await isar.cDEvents.get(id); // Corrected collection name
  }

  Future<void> deleteLoggedEvent(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cDEvents.delete(id); // Corrected collection name
    });
  }

  Future<void> updateLoggedEvent(CDLoggedEvent event) async {
    final isar = await db;
    // Ensure the event has an ID, otherwise it's a new event.
    // Isar's put operation handles both insert and update.
    // If event.id is null or doesn't exist, it's an insert.
    // If event.id exists, it's an update.
    // No need to change timestampLoggedUTC on update, only timestampOccurredUTC might change.
    await isar.writeTxn(() async {
      await isar.cDEvents.put(event); // Corrected collection name
    });
    print("DatabaseService: Event ID ${event.id} updated (or put).");
  }


  // --- CRUD Operations for CDUserMedication ---
  Future<void> saveUserMedication(CDUserMedication medication) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cDUserMedications.put(medication); // Corrected collection name
    });
  }

  Future<List<CDUserMedication>> getAllUserMedications() async {
    final isar = await db;
    return await isar.cDUserMedications.where().findAll(); // Corrected collection name
  }

  Future<CDUserMedication?> getUserMedicationByName(String name) async {
    final isar = await db;
    return await isar.cDUserMedications.filter().medicationNameEqualTo(name).findFirst(); // Corrected collection name
  }

  // --- CRUD Operations for CDUserDefinedListItem ---
  Future<void> saveUserDefinedListItem(CDUserDefinedListItem item) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cDUserDefinedListItems.put(item); // Corrected collection name
    });
  }

  Future<List<CDUserDefinedListItem>> getUserDefinedListItemsByType(UserListItemType type) async {
    final isar = await db;
    return await isar.cDUserDefinedListItems // Corrected collection name
        .filter()
        .listTypeEqualTo(type)
        .and()
        .isActiveEqualTo(true)
        .sortByItemOrder()
        .findAll();
  }

  // --- CRUD Operations for CDInsightFeedback ---
  Future<void> saveInsightFeedback(CDInsightFeedback feedback) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cDInsightFeedbacks.put(feedback); // Corrected collection name
    });
  }

  Future<List<CDInsightFeedback>> getAllInsightFeedback() async {
    final isar = await db;
    return await isar.cDInsightFeedbacks.where().findAll(); // Corrected collection name
  }
}
// Note: The collection names like `isar.cDEvents` are based on Isar's default naming convention
// (e.g., className -> cDClassName+s). These will be finalized once `data_model.g.dart` is generated.
// If the generator produces different names, they'll need to be updated here.
