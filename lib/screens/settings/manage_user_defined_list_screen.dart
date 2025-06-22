import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/data_model.dart'; // Adjust if necessary

// --- Provider for the Notifier ---
// We'll use a family modifier to create different notifiers for different list types
final userDefinedListProvider = StateNotifierProvider.family<UserDefinedListNotifier, List<CDUserDefinedListItem>, UserListItemType>((ref, listType) {
  // Initial mock data - this should be fetched from Isar based on listType
  List<CDUserDefinedListItem> initialItems = [];
  if (listType == UserListItemType.painLocation) {
    initialItems = [
      CDUserDefinedListItem(listType: listType, itemName: "Right Shoulder", itemOrder: 0),
      CDUserDefinedListItem(listType: listType, itemName: "Lower Back", itemOrder: 1),
      CDUserDefinedListItem(listType: listType, itemName: "Generalised", itemOrder: 2, isActive: false),
    ];
  } else if (listType == UserListItemType.keySymptom) {
    initialItems = [
      CDUserDefinedListItem(listType: listType, itemName: "Nausea", itemOrder: 0),
      CDUserDefinedListItem(listType: listType, itemName: "Fatigue", itemOrder: 1),
    ];
  } else if (listType == UserListItemType.foodCategory) {
    initialItems = [
      CDUserDefinedListItem(listType: listType, itemName: "Carbs", itemOrder: 0),
      CDUserDefinedListItem(listType: listType, itemName: "Protein Meal", itemOrder: 1),
      CDUserDefinedListItem(listType: listType, itemName: "Sugar", itemOrder: 2),
    ];
  }
  return UserDefinedListNotifier(initialItems, listType);
});

class UserDefinedListNotifier extends StateNotifier<List<CDUserDefinedListItem>> {
  final UserListItemType listType;
  int _nextMockId = 100; // For mock item IDs

  UserDefinedListNotifier(super.state, this.listType) {
    // Assign mock IDs if not present
    for (var item in state) {
      item.id = _nextMockId++;
    }
  }

  // Simulates adding to DB
  void addItem(String name, int order) {
    final newItem = CDUserDefinedListItem(listType: listType, itemName: name, itemOrder: order, isActive: true)
      ..id = _nextMockId++; // Assign mock ID
    // In real app: await dbService.saveUserDefinedListItem(newItem);
    state = [...state, newItem]..sort((a, b) => a.itemOrder.compareTo(b.itemOrder));
    print("SIMULATED ADD: Item '${newItem.itemName}' for type '$listType' added.");
  }

  // Simulates updating in DB
  void editItem(int id, String newName, int newOrder, bool isActive) {
    final index = state.indexWhere((item) => item.id == id);
    if (index != -1) {
      final oldItem = state[index];
      final updatedItem = CDUserDefinedListItem(listType: listType, itemName: newName, itemOrder: newOrder, isActive: isActive)
        ..id = oldItem.id; // Keep original mock ID
      // In real app: await dbService.saveUserDefinedListItem(updatedItem);
      final newState = List<CDUserDefinedListItem>.from(state);
      newState[index] = updatedItem;
      state = newState..sort((a, b) => a.itemOrder.compareTo(b.itemOrder));
      print("SIMULATED EDIT: Item ID '${updatedItem.id}' to '${updatedItem.itemName}', Order: ${updatedItem.itemOrder}, Active: ${updatedItem.isActive}");
    }
  }

  void toggleActiveStatus(CDUserDefinedListItem item) {
    editItem(item.id, item.itemName, item.itemOrder, !item.isActive);
  }
}

class ManageUserDefinedListScreen extends ConsumerWidget {
  final String title;
  final UserListItemType listType;

  const ManageUserDefinedListScreen({
    super.key,
    required this.title,
    required this.listType,
  });

  void _showItemDialog(BuildContext context, WidgetRef ref, {CDUserDefinedListItem? itemToEdit}) {
    final TextEditingController nameController = TextEditingController(text: itemToEdit?.itemName ?? '');
    final TextEditingController orderController = TextEditingController(text: itemToEdit?.itemOrder.toString() ?? '0');
    bool isActive = itemToEdit?.isActive ?? true;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(itemToEdit == null ? 'Add New Item' : 'Edit Item'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    autofocus: true,
                  ),
                  TextField(
                    controller: orderController,
                    decoration: const InputDecoration(labelText: 'Order (e.g., 0, 1, 2...)'),
                    keyboardType: TextInputType.number,
                  ),
                  if (itemToEdit != null)
                    SwitchListTile(
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (bool value) {
                         setState(() { isActive = value; });
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
              child: Text(itemToEdit == null ? 'Add' : 'Save'),
              onPressed: () {
                final name = nameController.text.trim();
                final order = int.tryParse(orderController.text.trim()) ?? 0;
                if (name.isNotEmpty) {
                  if (itemToEdit == null) {
                    ref.read(userDefinedListProvider(listType).notifier).addItem(name, order);
                  } else {
                    ref.read(userDefinedListProvider(listType).notifier).editItem(itemToEdit.id, name, order, isActive);
                  }
                  Navigator.of(dialogContext).pop();
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a name for the item.')),
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
    final List<CDUserDefinedListItem> items = ref.watch(userDefinedListProvider(listType));
    // Sort by order, then by active status, then by name for consistent display
    final sortedItems = List<CDUserDefinedListItem>.from(items)
      ..sort((a, b) {
        int orderCompare = a.itemOrder.compareTo(b.itemOrder);
        if (orderCompare != 0) return orderCompare;
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase());
      });

    String listTypeNameForUser = "items";
    if (listType == UserListItemType.painLocation) listTypeNameForUser = "pain locations";
    else if (listType == UserListItemType.keySymptom) listTypeNameForUser = "key symptoms";
    else if (listType == UserListItemType.foodCategory) listTypeNameForUser = "food categories";


    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Title is already context-specific e.g. "Manage Pain Locations"
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Item',
            onPressed: () => _showItemDialog(context, ref),
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No $listTypeNameForUser added yet. Tap + to add your first one. Personalizing these lists makes logging much faster!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ))
          : ReorderableListView.builder( // Basic reordering UI, not fully functional for DB yet
              itemCount: sortedItems.length,
              itemBuilder: (context, index) {
                final item = sortedItems[index];
                return ListTile(
                  key: ValueKey(item.id), // Unique key for ReorderableListView
                  title: Text(
                    item.itemName,
                     style: TextStyle(
                      decoration: !item.isActive ? TextDecoration.lineThrough : null,
                      color: !item.isActive ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text('Order: ${item.itemOrder}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       IconButton(
                        icon: Icon(item.isActive ? Icons.toggle_on_outlined : Icons.toggle_off_outlined),
                        tooltip: item.isActive ? 'Mark as Inactive' : 'Mark as Active',
                        color: item.isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
                        onPressed: () {
                           ref.read(userDefinedListProvider(listType).notifier).toggleActiveStatus(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Item',
                        onPressed: () => _showItemDialog(context, ref, itemToEdit: item),
                      ),
                    ],
                  ),
                  onTap: () => _showItemDialog(context, ref, itemToEdit: item),
                );
              },
              onReorder: (oldIndex, newIndex) {
                // This is where you'd update itemOrder in the database for multiple items.
                // For MVP with mock data, this is complex to simulate perfectly without DB.
                // A simple state update for visual feedback, but DB logic is deferred.
                final notifier = ref.read(userDefinedListProvider(listType).notifier);
                final List<CDUserDefinedListItem> currentList = List.from(notifier.state);
                final CDUserDefinedListItem item = currentList.removeAt(oldIndex);
                if (newIndex > oldIndex) newIndex -=1; // Adjust index if item is moved down
                currentList.insert(newIndex, item);

                // Update orders based on new positions
                for(int i=0; i < currentList.length; i++){
                  // In a real scenario, you'd call editItem or a batch update here
                  // For mock, directly modify the state for visual reordering effect
                  currentList[i].itemOrder = i;
                }
                notifier.state = currentList; // Visually reorders but doesn't call 'editItem' for each
                print("SIMULATED REORDER: For list type '$listType'. Full DB logic for reordering is pending.");
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Visual reorder applied. Full save logic pending DB.')),
                );
              }
            ),
    );
  }
}
