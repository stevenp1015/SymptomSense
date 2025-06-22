import 'package:flutter/material.dart';
import 'package:myapp/data/data_model.dart'; // For UserListItemType
import 'package:myapp/screens/settings/manage_medications_screen.dart';
import 'package:myapp/screens/settings/manage_user_defined_list_screen.dart';
import 'package:myapp/screens/settings/configure_quick_log_screen.dart';

class SettingsHubScreen extends StatelessWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Customization'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.medication_outlined),
            title: const Text('Manage Medications'),
            subtitle: const Text('Add or edit your medication list'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageMedicationsScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text('Manage Pain Locations'),
            subtitle: const Text('Customize your common pain areas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageUserDefinedListScreen(
                title: 'Manage Pain Locations',
                listType: UserListItemType.painLocation,
               )));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('Manage Key Symptoms'),
            subtitle: const Text('Define your top symptoms for quick logging'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageUserDefinedListScreen(
                title: 'Manage Key Symptoms',
                listType: UserListItemType.keySymptom,
              )));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.fastfood_outlined),
            title: const Text('Manage Food Categories'),
            subtitle: const Text('Set up your food tags'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageUserDefinedListScreen(
                title: 'Manage Food Categories',
                listType: UserListItemType.foodCategory,
              )));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dashboard_customize_outlined),
            title: const Text('Configure Quick Log Buttons'),
            subtitle: const Text('Customize your dashboard shortcuts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigureQuickLogScreen()));
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configure Quick Log screen (Not Implemented Yet)')),
              );
            },
          ),
          const Divider(),
          // Add more settings later, e.g., API consent, theme, etc.
        ],
      ),
    );
  }
}
