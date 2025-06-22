import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart';
import 'package:myapp/services/gemini_service.dart'; // Simulated service
// Mock providers for selections (eventually from DB)
import 'package:myapp/screens/settings/manage_user_defined_list_screen.dart' show userDefinedListProvider;
import 'package:myapp/screens/settings/manage_medications_screen.dart' show mockUserMedicationsProvider;
// Mock events for sending to API
import 'package:myapp/screens/history/chronological_history_screen.dart' show mockChronologicalEventsProvider;


// --- State for Insight Parameters ---
final selectedSymptomXNameProvider = StateProvider<String?>((ref) => null); // e.g., "Nausea", "Right Shoulder" (Pain)
final selectedSymptomXSeverityProvider = StateProvider<int>((ref) => 5); // Default severity condition
final selectedFactorYTypeProvider = StateProvider<String?>((ref) => null); // "FoodCategory", "Medication"
final selectedFactorYNameProvider = StateProvider<String?>((ref) => null); // e.g., "Sugar", "Medication A"
final selectedTimePeriodProvider = StateProvider<int>((ref) => 30); // Days

// --- State for API Call ---
enum InsightApiCallState { initial, loading, success, error }
final insightApiStateProvider = StateProvider<InsightApiCallState>((ref) => InsightApiCallState.initial);
final insightResultProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
final insightErrorProvider = StateProvider<String?>((ref) => null);

// Provider for GeminiService
final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());


class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  // Helper to build dropdown items for symptoms
  List<DropdownMenuItem<String>> _buildSymptomXOptions(WidgetRef ref) {
    List<DropdownMenuItem<String>> items = [];
    // Key Symptoms
    final keySymptoms = ref.watch(userDefinedListProvider(UserListItemType.keySymptom));
    items.addAll(keySymptoms.where((s) => s.isActive).map((s) => DropdownMenuItem(value: "keySymptom::${s.itemName}", child: Text("Symptom: ${s.itemName}"))));
    // Pain Locations
    final painLocations = ref.watch(userDefinedListProvider(UserListItemType.painLocation));
    items.addAll(painLocations.where((l) => l.isActive).map((l) => DropdownMenuItem(value: "painLocation::${l.itemName}", child: Text("Pain: ${l.itemName}"))));
    // Add a generic seizure option
    items.add(const DropdownMenuItem(value: "seizure::Seizure", child: Text("Event: Seizure")));

    if (items.isEmpty) {
        items.add(const DropdownMenuItem(value: null, child: Text("No symptoms defined in settings")));
    }
    return items;
  }

  // Helper to build dropdown items for Factor Y names based on Factor Y type
  List<DropdownMenuItem<String>> _buildFactorYNameOptions(WidgetRef ref, String? factorType) {
    List<DropdownMenuItem<String>> items = [];
    if (factorType == "FoodCategory") {
      final foodCats = ref.watch(userDefinedListProvider(UserListItemType.foodCategory));
      items.addAll(foodCats.where((fc) => fc.isActive).map((fc) => DropdownMenuItem(value: fc.itemName, child: Text(fc.itemName))));
    } else if (factorType == "Medication") {
      final medications = ref.watch(mockUserMedicationsProvider);
      items.addAll(medications.where((m) => m.isActive).map((m) => DropdownMenuItem(value: m.medicationName, child: Text(m.medicationName))));
    }
    // Add other factor types here (e.g., ActivityType) post-MVP
    if (items.isEmpty && factorType != null) {
         items.add(const DropdownMenuItem(value: null, child: Text("No items for this factor type")));
    } else if (factorType == null) {
        items.add(const DropdownMenuItem(value: null, child: Text("Select factor type first")));
    }
    return items;
  }


  Future<void> _runAnalysis(WidgetRef ref) async {
    final symptomX = ref.read(selectedSymptomXNameProvider);
    final symptomXSeverity = ref.read(selectedSymptomXSeverityProvider);
    final factorYType = ref.read(selectedFactorYTypeProvider);
    final factorYName = ref.read(selectedFactorYNameProvider);
    final timePeriod = ref.read(selectedTimePeriodProvider);

    if (symptomX == null || factorYType == null || factorYName == null) {
      ref.read(insightErrorProvider.notifier).state = "Please select all parameters for analysis.";
      ref.read(insightApiStateProvider.notifier).state = InsightApiCallState.error;
      return;
    }

    ref.read(insightApiStateProvider.notifier).state = InsightApiCallState.loading;
    ref.read(insightErrorProvider.notifier).state = null;
    ref.read(insightResultProvider.notifier).state = null;

    try {
      final geminiService = ref.read(geminiServiceProvider);
      final mockEvents = ref.read(mockChronologicalEventsProvider); // Use mock events for now

      // Parse SymptomX to distinguish name and original type (keySymptom, painLocation, seizure)
      final symptomParts = symptomX.split("::");
      final String symptomApiName = symptomParts[1]; // e.g. "Nausea", "Right Shoulder", "Seizure"
      // String originalSymptomType = symptomParts[0]; // e.g. "keySymptom", "painLocation", "seizure"


      // TODO: Filter mockEvents based on timePeriod for more realistic simulation
      // List<CDLoggedEvent> filteredEvents = mockEvents.where((e) => e.timestampOccurredUTC.isAfter(DateTime.now().subtract(Duration(days:timePeriod)))).toList();
      List<CDLoggedEvent> filteredEvents = mockEvents; // For now, send all mock events


      final result = await geminiService.getSymptomFactorCorrelation(
        appUserID: "mock_user_123", // Placeholder
        targetSymptomName: symptomApiName,
        targetSymptomConditionOperator: "greater than", // MVP default
        targetSymptomSeverityValue: symptomXSeverity,
        targetFactorType: factorYType, // "FoodCategory" or "Medication"
        targetFactorName: factorYName,
        timePeriodDays: timePeriod,
        maxLagHours: 3, // MVP default
        relevantUserEvents: filteredEvents,
      );
      ref.read(insightResultProvider.notifier).state = result;
      ref.read(insightApiStateProvider.notifier).state = InsightApiCallState.success;
    } catch (e) {
      ref.read(insightErrorProvider.notifier).state = "Error getting insight: ${e.toString()}";
      ref.read(insightApiStateProvider.notifier).state = InsightApiCallState.error;
    }
  }

  void _submitFeedback(WidgetRef ref, String apiInsightID, String feedbackResponse) {
    // Simulate saving feedback
    final feedback = CDInsightFeedback(
        insightAPIRefID: apiInsightID,
        userFeedbackResponse: feedbackResponse,
    );
    print("SIMULATED FEEDBACK SAVE: Insight ID '$apiInsightID', Feedback: '$feedbackResponse'");
    // In real app: await ref.read(databaseServiceProvider).saveInsightFeedback(feedback);
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(content: Text("Thanks for your feedback: $feedbackResponse")),
    );
    // Optionally hide feedback buttons or show a "thank you" message on the card
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symptomXOptions = _buildSymptomXOptions(ref);
    final String? currentSymptomX = ref.watch(selectedSymptomXNameProvider);
    final int currentSymptomSeverity = ref.watch(selectedSymptomXSeverityProvider);

    final String? currentFactorYType = ref.watch(selectedFactorYTypeProvider);
    final factorYNameOptions = _buildFactorYNameOptions(ref, currentFactorYType);
    final String? currentFactorYName = ref.watch(selectedFactorYNameProvider);

    final int currentTimePeriod = ref.watch(selectedTimePeriodProvider);

    final apiState = ref.watch(insightApiStateProvider);
    final Sresult = ref.watch(insightResultProvider); // Renamed to Sresult to avoid conflict
    final error = ref.watch(insightErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Your Patterns'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Analyze Correlation: Symptom X vs. Factor Y", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // Symptom X Selection
            Text("Symptom X:", style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: symptomXOptions.any((item) => item.value == currentSymptomX) ? currentSymptomX : null,
              hint: const Text("Select Symptom/Event"),
              isExpanded: true,
              items: symptomXOptions,
              onChanged: (value) => ref.read(selectedSymptomXNameProvider.notifier).state = value,
            ),
            if (currentSymptomX != null && !currentSymptomX.startsWith("seizure::")) ...[ // Severity only for non-seizure symptoms for MVP simplicity
                const SizedBox(height: 8),
                Text("...when severity is greater than: $currentSymptomSeverity", style: Theme.of(context).textTheme.bodyMedium),
                Slider(
                    value: currentSymptomSeverity.toDouble(),
                    min: 0, max: 9, divisions: 9, // 0-9, so "greater than 0" to "greater than 9"
                    label: currentSymptomSeverity.toString(),
                    onChanged: (val) => ref.read(selectedSymptomXSeverityProvider.notifier).state = val.toInt(),
                ),
            ] else if (currentSymptomX != null && currentSymptomX.startsWith("seizure::")) ... [
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                   child: Text("Analyzing occurrence of '${currentSymptomX.split("::")[1]}'.", style: Theme.of(context).textTheme.bodyMedium),
                 ),
                 // For seizure, severity condition is implicitly "any occurrence" or could be a fixed threshold if desired.
                 // For MVP, we simplify: if it's a seizure, we analyze occurrence vs factor. Severity is logged but not part of this MVP insight's *condition*.
            ],


            const SizedBox(height: 16),

            // Factor Y Selection
            Text("Factor Y:", style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<String>(
              value: currentFactorYType,
              hint: const Text("Select Factor Type"),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "FoodCategory", child: Text("Food Category/Tag")),
                DropdownMenuItem(value: "Medication", child: Text("Medication Taken")),
                // Add "ActivityType" etc. post-MVP
              ],
              onChanged: (value) {
                ref.read(selectedFactorYTypeProvider.notifier).state = value;
                ref.read(selectedFactorYNameProvider.notifier).state = null; // Reset name when type changes
              }
            ),
            if (currentFactorYType != null) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: factorYNameOptions.any((item) => item.value == currentFactorYName) ? currentFactorYName : null,
                hint: Text("Select Specific ${currentFactorYType == "FoodCategory" ? "Food Tag" : "Medication"}"),
                isExpanded: true,
                items: factorYNameOptions,
                onChanged: (value) => ref.read(selectedFactorYNameProvider.notifier).state = value,
              ),
            ],
            const SizedBox(height: 16),

            // Time Period
            Text("Over the last: $currentTimePeriod days", style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: currentTimePeriod.toDouble(),
              min: 7, max: 90, divisions: (90-7)~/7, // Weekly increments up to ~3 months
              label: "$currentTimePeriod days",
              onChanged: (val) => ref.read(selectedTimePeriodProvider.notifier).state = val.toInt(),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('Run Analysis'),
                onPressed: apiState == InsightApiCallState.loading ? null : () => _runAnalysis(ref),
              ),
            ),
            const SizedBox(height: 20),

            // --- Display Results ---
            if (apiState == InsightApiCallState.loading)
              const Center(child: CircularProgressIndicator()),
            if (apiState == InsightApiCallState.error && error != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer, size: 30),
                      const SizedBox(height: 10),
                      Text("Oops! Something went wrong:", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onErrorContainer)),
                      const SizedBox(height: 5),
                      Text(error, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onErrorContainer)),
                    ],
                  ),
                ),
              ),
            if (apiState == InsightApiCallState.success && Sresult != null)
              _buildInsightCard(context, Sresult, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, Map<String, dynamic> resultData, WidgetRef ref) {
    final metadata = resultData['responseMetadata'] as Map<String, dynamic>? ?? {};
    final results = resultData['insightResults'] as Map<String, dynamic>? ?? {};
    final stats = results['detailedStatistics'] as Map<String, dynamic>? ?? {};
    final prompts = (results['actionableFeedbackPrompts'] as List<dynamic>?)?.cast<String>() ?? [];
    final apiInsightID = metadata['apiInsightID'] as String? ?? 'unknown-insight-id';

    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.explore_outlined, color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(width: 8),
                Text("Your SymptomSense Insight", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            const Divider(thickness: 1.5, height: 20),
            const SizedBox(height: 8),
            Text(results['plainLanguageSummary'] as String? ?? "Insight summary is currently unavailable.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
            const SizedBox(height: 12),
            ExpansionTile(
              title: const Text("View Details (Mock Statistics)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Text("Symptom Occurrences (meeting criteria): ${stats['symptomOccurrences'] ?? 'N/A'}", style: Theme.of(context).textTheme.bodySmall),
                Text("Factor Occurrences: ${stats['factorOccurrences'] ?? 'N/A'}", style: Theme.of(context).textTheme.bodySmall),
                Text("Co-Occurrences (within lag): ${stats['coOccurrences'] ?? 'N/A'}", style: Theme.of(context).textTheme.bodySmall),
                Text("Correlation Strength: ${stats['correlationCoefficientOrStrength'] ?? 'N/A'}", style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Text("Confidence: ${results['confidenceAssessment'] ?? 'N/A'}", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 16),
            Text("Does this pattern seem familiar?", style: Theme.of(context).textTheme.titleSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(onPressed: () => _submitFeedback(ref, apiInsightID, "Yes"), child: const Text("Yes")),
                OutlinedButton(onPressed: () => _submitFeedback(ref, apiInsightID, "No"), child: const Text("No")),
                OutlinedButton(onPressed: () => _submitFeedback(ref, apiInsightID, "Maybe"), child: const Text("Maybe")),
              ],
            ),
            if (prompts.length > 1) ...[ // Show other prompts if available
                const SizedBox(height:10),
                Text(prompts[1], style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic))
            ]
          ],
        ),
      ),
    );
  }
}
