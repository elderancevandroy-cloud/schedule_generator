import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule_timeline.dart';
import '../widgets/schedule_stats.dart';

class ScheduleDetailScreen extends StatefulWidget {
  final Schedule schedule;

  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  late Schedule _schedule;

  @override
  void initState() {
    super.initState();
    _schedule = widget.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_schedule.name),
        actions: [
          IconButton(
            icon: Icon(
              _schedule.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _schedule.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              context.read<ScheduleProvider>().toggleFavorite(_schedule.id);
              setState(() {
                _schedule = _schedule.copyWith(
                  isFavorite: !_schedule.isFavorite,
                );
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (choice) {
              if (choice == 'export') {
                _exportSchedule();
              } else if (choice == 'share') {
                _shareSchedule();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          ScheduleStats(schedule: _schedule),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          ScheduleTimeline(
            schedule: _schedule,
            onItemToggle: (itemId) {
              context.read<ScheduleProvider>().toggleItemCompletion(
                    _schedule.id,
                    itemId,
                  );
              setState(() {
                final updatedItems = _schedule.items.map((item) {
                  if (item.id == itemId) {
                    return item.copyWith(isCompleted: !item.isCompleted);
                  }
                  return item;
                }).toList();
                _schedule = _schedule.copyWith(items: updatedItems);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(_schedule.date),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${_schedule.items.length} tasks',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.check_circle, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${_schedule.completedItems} completed',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  void _exportSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF export feature coming soon!')),
    );
  }

  void _shareSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }
}