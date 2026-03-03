import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAPISettings(context),
          const SizedBox(height: 32),
          _buildThemeSettings(context),
          const SizedBox(height: 32),
          _buildDataSettings(context),
          const SizedBox(height: 32),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildAPISettings(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, scheduleProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Configuration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OpenAI API Key',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your OpenAI API key to enable AI-powered schedule generation.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'sk-...',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            // Toggle visibility
                          },
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          scheduleProvider.setApiKey(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('API key saved successfully!'),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAPIKeyDialog(context, scheduleProvider);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save API Key'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: const Text('Light Mode'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.brightness_auto),
                    title: const Text('System Default'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Management',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear All Data'),
                subtitle: const Text('Delete all schedules and settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearDataDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Schedule Generator',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Text(
                  'An intelligent scheduling app powered by AI to help you organize your day efficiently.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAPIKeyDialog(BuildContext context, ScheduleProvider provider) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter API Key'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'sk-...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.setApiKey(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('API key saved successfully!'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all schedules and settings? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear data logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data cleared successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}