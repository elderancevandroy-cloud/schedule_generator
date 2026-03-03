import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/theme_provider.dart';
import '../models/schedule.dart';
import 'schedule_input_screen.dart';
import 'schedule_detail_screen.dart';
import 'settings_screen.dart';
import '../widgets/schedule_card.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Schedule Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, scheduleProvider, child) {
          if (scheduleProvider.isLoading && scheduleProvider.schedules.isEmpty) {
            return const LoadingWidget(message: 'Loading schedules...');
          }

          if (scheduleProvider.errorMessage != null) {
            return _buildErrorView(scheduleProvider.errorMessage!);
          }

          if (scheduleProvider.schedules.isEmpty) {
            return _buildEmptyView();
          }

          return _buildScheduleList(scheduleProvider);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScheduleInputScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Generate Schedule'),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No schedules yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Create your first AI-generated schedule',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScheduleInputScreen()),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate with AI'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ScheduleProvider>().clearError();
                context.read<ScheduleProvider>().refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(ScheduleProvider scheduleProvider) {
    return RefreshIndicator(
      onRefresh: () => scheduleProvider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scheduleProvider.schedules.length,
        itemBuilder: (context, index) {
          final schedule = scheduleProvider.schedules[index];
          return ScheduleCard(
            schedule: schedule,
            onTap: () {
              scheduleProvider.selectSchedule(schedule);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduleDetailScreen(schedule: schedule),
                ),
              );
            },
            onDelete: () => _showDeleteDialog(schedule),
            onToggleFavorite: () => scheduleProvider.toggleFavorite(schedule.id),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(Schedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: Text('Are you sure you want to delete "${schedule.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ScheduleProvider>().deleteSchedule(schedule.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}