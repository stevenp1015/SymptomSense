import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart'; // This import will fail until pub get works
import 'package:myapp/data/data_model.dart';
import 'package:intl/intl.dart';

// Using the same mock provider from chronological view for consistency
import 'package:myapp/screens/history/chronological_history_screen.dart' show mockChronologicalEventsProvider, ChronologicalHistoryScreen; // Re-use formatting logic

// --- State Providers ---
final selectedCalendarDayProvider = StateProvider<DateTime?>((ref) => DateTime.now());
final focusedCalendarDayProvider = StateProvider<DateTime>((ref) => DateTime.now());


class CalendarHistoryScreen extends ConsumerWidget {
  const CalendarHistoryScreen({super.key});

  // Helper to get events for a specific day
  List<CDLoggedEvent> _getEventsForDay(DateTime day, List<CDLoggedEvent> allEvents) {
    return allEvents.where((event) {
      final eventDate = event.timestampOccurredUTC.toLocal();
      return isSameDay(eventDate, day);
    }).toList();
  }

  // Helper to determine if a day has "significant" symptoms (MVP: any symptom or seizure)
  bool _hasSignificantSymptom(DateTime day, List<CDLoggedEvent> allEvents) {
    final dayEvents = _getEventsForDay(day, allEvents);
    return dayEvents.any((event) =>
        event.eventType == EventType.seizure ||
        (event.eventType == EventType.symptom && (event.painSeverity ?? 0) > 5) ||
        (event.eventType == EventType.symptom && (event.keySymptomSeverity ?? 0) > 5)
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime? selectedDay = ref.watch(selectedCalendarDayProvider);
    final DateTime focusedDay = ref.watch(focusedCalendarDayProvider);
    final List<CDLoggedEvent> allEvents = ref.watch(mockChronologicalEventsProvider);

    final List<CDLoggedEvent> eventsForSelectedDay = selectedDay != null
        ? _getEventsForDay(selectedDay, allEvents)
        : [];

    // For event loader in TableCalendar
    List<CDLoggedEvent> eventLoader(DateTime day) {
      return _getEventsForDay(day, allEvents);
    }

    // For marker builder in TableCalendar
    Widget? markerBuilder(BuildContext context, DateTime day, List<CDLoggedEvent> eventsOnDay) {
      if (eventsOnDay.isNotEmpty) {
        bool isSignificant = _hasSignificantSymptom(day, eventsOnDay);
        return Positioned(
          right: 1,
          bottom: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSignificant ? Colors.redAccent.withOpacity(0.8) : Colors.blueAccent.withOpacity(0.8),
            ),
            width: 7.0,
            height: 7.0,
          ),
        );
      }
      return null;
    }

    // Instantiate the ChronologicalHistoryScreen to reuse its methods (not ideal, but works for mock)
    // In a real app, this logic would be in a shared service/viewmodel.
    final chronoScreenHelper = const ChronologicalHistoryScreen();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar View'),
      ),
      body: Column(
        children: [
          // --- This TableCalendar widget will cause errors until 'table_calendar' is fetched ---
          TableCalendar<CDLoggedEvent>(
            firstDay: DateTime.utc(2020, 1, 1), // Arbitrary start
            lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31), // Arbitrary end
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            calendarFormat: CalendarFormat.month,
            eventLoader: eventLoader,
            calendarBuilders: CalendarBuilders(
              markerBuilder: markerBuilder,
            ),
            onDaySelected: (newSelectedDay, newFocusedDay) {
              ref.read(selectedCalendarDayProvider.notifier).state = newSelectedDay;
              ref.read(focusedCalendarDayProvider.notifier).state = newFocusedDay;
            },
            onPageChanged: (newFocusedDay) {
              ref.read(focusedCalendarDayProvider.notifier).state = newFocusedDay;
              // ref.read(selectedCalendarDayProvider.notifier).state = null; // Optionally clear selection on page change
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, // MVP: Month view only
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              // Weekend text color
              // weekendTextStyle: TextStyle(color: Colors.red),
              // Today's date highlight
              todayDecoration: BoxDecoration(
                color: Colors.amberAccent,
                shape: BoxShape.circle,
              ),
              // Selected date highlight
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                 Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent.withOpacity(0.8))),
                 const SizedBox(width: 4),
                 const Text("Significant Symptom"),
                 const SizedBox(width: 10),
                 Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent.withOpacity(0.8))),
                 const SizedBox(width: 4),
                 const Text("Logged Event(s)"),
              ],
            )
          ),
          const Divider(),
          Expanded(
            child: eventsForSelectedDay.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        selectedDay != null
                            ? 'No events logged for ${DateFormat.yMMMEd().format(selectedDay.toLocal())}. Keep tracking!'
                            : 'Tap a day on the calendar to see your logged events for that day.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: eventsForSelectedDay.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final event = eventsForSelectedDay[index];
                      return ListTile(
                        leading: chronoScreenHelper.buildEventIcon(event.eventType), // Reuse icon logic
                        title: Text(
                          event.eventType.name[0].toUpperCase() + event.eventType.name.substring(1),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                           "${DateFormat.jm().format(event.timestampOccurredUTC.toLocal())}\n" // Only time for selected day view
                           "${chronoScreenHelper.formatEventDetails(event)}", // Reuse formatting logic
                        ),
                         isThreeLine: (event.notes != null && event.notes!.isNotEmpty) || chronoScreenHelper.formatEventDetails(event).contains("\n"),
                         trailing: IconButton(
                            icon: const Icon(Icons.edit_note_outlined),
                            tooltip: "Edit/View Details",
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('View/Edit for event ID ${event.id} (Not Implemented Yet)')),
                              );
                            },
                          ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
