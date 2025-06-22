import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary
import 'package:intl/intl.dart'; // For date formatting

// --- Providers for State Management ---
final sleepHoursProvider = StateProvider<double?>((ref) => null); // Using double for .5 hours
final sleepDateProvider = StateProvider<DateTime>((ref) => DateTime.now().subtract(const Duration(days: 1))); // Defaults to "last night"
final sleepNotesProvider = StateProvider<String>((ref) => '');


class SleepLogScreen extends ConsumerWidget {
  final CDLoggedEvent? existingEvent;
  const SleepLogScreen({super.key, this.existingEvent});

  Future<void> _selectDate(BuildContext context, WidgetRef ref, DateTime currentSleepDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentSleepDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Cannot log sleep for the future
    );
    if (picked != null && picked != ref.read(sleepDateProvider)) {
      ref.read(sleepDateProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (existingEvent != null && ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
           final currentProviderDate = ref.read(sleepDateProvider);
           final eventDate = existingEvent?.timestampOccurredUTC.toLocal();
           bool datesSame = false;
           if (eventDate != null) {
             datesSame = isSameDay(currentProviderDate, eventDate);
           }

          if (ref.read(sleepHoursProvider) != (existingEvent?.sleepTotalHours?.toDouble()) ||
              (eventDate != null && !datesSame) ||
              ref.read(sleepNotesProvider) != (existingEvent?.notes ?? '')) {

            ref.read(sleepHoursProvider.notifier).state = existingEvent?.sleepTotalHours?.toDouble();
            if (eventDate != null) {
              // The sleepDateProvider stores the "night of" date.
              // If timestampOccurredUTC is e.g. March 10th 7 AM (meaning sleep for night of March 9th),
              // then sleepDateProvider should be March 9th.
              // For MVP simplicity, if editing, we'll set sleepDate to the date part of occurred timestamp.
              // User can then adjust if needed.
              ref.read(sleepDateProvider.notifier).state = DateTime(eventDate.year, eventDate.month, eventDate.day);
            }
            ref.read(sleepNotesProvider.notifier).state = existingEvent?.notes ?? '';
          }
        }
      });
    }

    final double? hoursSlept = ref.watch(sleepHoursProvider);
    final DateTime sleepDate = ref.watch(sleepDateProvider); // This is the date for which sleep is logged (e.g., night of)
    final String notes = ref.watch(sleepNotesProvider);

    // Placeholder for database service
    // final dbService = ref.watch(databaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingEvent == null ? 'Log Sleep' : 'Edit Sleep Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: hoursSlept != null && hoursSlept >=0
                ? () async {
                    // For new logs, timestampOccurredUTC is typically the morning after sleepDate.
                    // For edited logs, we might want to preserve the original time component of timestampOccurredUTC
                    // unless the user explicitly changes the sleepDate.
                    DateTime occurredTimestamp;
                    if (existingEvent != null) {
                        // If date was changed by user, use new date with original time. Otherwise use original timestamp.
                        final originalOccurred = existingEvent!.timestampOccurredUTC.toLocal();
                        if (isSameDay(originalOccurred, sleepDate)) {
                            occurredTimestamp = existingEvent!.timestampOccurredUTC; // Keep original UTC timestamp if date part unchanged
                        } else {
                            // Date was changed, keep original time of day but apply to new date
                            occurredTimestamp = DateTime(sleepDate.year, sleepDate.month, sleepDate.day, originalOccurred.hour, originalOccurred.minute).toUtc();
                        }
                    } else {
                        // New log: night ending on sleepDate's morning.
                        // Default to 7 AM on the sleepDate (which represents end of night)
                        occurredTimestamp = DateTime(sleepDate.year, sleepDate.month, sleepDate.day, 7, 0, 0).toUtc();
                    }

                    CDLoggedEvent eventToSave;
                    if (existingEvent != null) {
                      eventToSave = existingEvent!.copyWith(
                        timestampOccurredUTC: occurredTimestamp, // Potentially updated
                        sleepTotalHours: hoursSlept.toInt(),
                        notes: notes.isNotEmpty ? notes : null,
                        eventType: EventType.sleep,
                      );
                    } else {
                      eventToSave = CDLoggedEvent(
                        timestampOccurredUTC: occurredTimestamp,
                        eventType: EventType.sleep,
                        sleepTotalHours: hoursSlept.toInt(),
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
                    //     SnackBar(content: Text('Sleep details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Hope you rested well!')),
                    //   );
                    //   if (existingEvent == null) {
                    //      ref.read(sleepHoursProvider.notifier).state = null;
                    //      ref.read(sleepDateProvider.notifier).state = DateTime.now().subtract(const Duration(days: 1));
                    //      ref.read(sleepNotesProvider.notifier).state = '';
                    //   }
                    //   Navigator.pop(context);
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Sorry, could not save sleep log: $e')),
                    //   );
                    // }
                    print('--- SIMULATED ${existingEvent == null ? "SAVE" : "UPDATE"} ---');
                    print('Sleep Logged:');
                    print('  ID: ${eventToSave.id}');
                    print('  Date (for night ending on): ${DateFormat.yMd().format(sleepDate)}');
                    print('  Hours: ${eventToSave.sleepTotalHours}');
                    print('  Notes: ${eventToSave.notes}');
                    print('  Timestamp Occurred (UTC): ${eventToSave.timestampOccurredUTC}');
                    print('  Timestamp Logged (UTC): ${eventToSave.timestampLoggedUTC}');
                    print('----------------------');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sleep details ${existingEvent == null ? "recorded" : "updated"} (Simulated). Hope you rested well!')),
                    );

                    if (existingEvent == null) {
                        ref.read(sleepHoursProvider.notifier).state = null;
                        ref.read(sleepDateProvider.notifier).state = DateTime.now().subtract(const Duration(days: 1));
                        ref.read(sleepNotesProvider.notifier).state = '';
                    }
                    Navigator.pop(context);
                  }
                : null, // Disable button if hours not set or invalid
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text("For the night ending on:", style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat.yMMMEd().format(sleepDate), // e.g., Wed, Sep 27, 2023
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: "Change Sleep Date",
                  onPressed: () => _selectDate(context, ref, sleepDate),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text('Total Hours Slept:', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: hoursSlept?.toString() ?? '',
              decoration: const InputDecoration(
                hintText: 'e.g., 7.5',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                ref.read(sleepHoursProvider.notifier).state = double.tryParse(value);
              },
            ),
            const SizedBox(height: 20),

            Text('Optional Notes (e.g., quality, awakenings):', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: notes,
              decoration: const InputDecoration(
                hintText: 'How was your sleep?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                ref.read(sleepNotesProvider.notifier).state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
