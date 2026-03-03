import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';
import '../models/schedule_item.dart';

class ScheduleTimeline extends StatelessWidget {
  final Schedule schedule;
  final Function(String itemId) onItemToggle;

  const ScheduleTimeline({
    super.key,
    required this.schedule,
    required this.onItemToggle,
  });

  @override
  Widget build(BuildContext context) {
    final sortedItems = List<ScheduleItem>.from(schedule.items)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...sortedItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final showTime = index == 0 ||
              sortedItems[index - 1].startTime != item.startTime;
          return _buildTimelineItem(context, item, showTime);
        }),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, ScheduleItem item, bool showTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: showTime
                ? Text(
                    DateFormat('HH:mm').format(item.startTime),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Card(
              elevation: item.isCompleted ? 1 : 2,
              color: item.isCompleted
                  ? Colors.grey[100]
                  : _getPriorityColor(item.priority).withOpacity(0.1),
              child: InkWell(
                onTap: () => onItemToggle(item.id),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: item.isCompleted
                                ? Colors.green
                                : _getPriorityColor(item.priority),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.isCompleted
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                          ),
                          _buildPriorityBadge(item.priority),
                        ],
                      ),
                      if (item.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('HH:mm').format(item.startTime)} - ${DateFormat('HH:mm').format(item.endTime)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.category, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            item.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (item.tags != null && item.tags!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: item.tags!.map((tag) {
                            return Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(fontSize: 10),
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    String label;

    switch (priority) {
      case 'high':
        color = Colors.red;
        label = 'HIGH';
        break;
      case 'medium':
        color = Colors.orange;
        label = 'MED';
        break;
      case 'low':
        color = Colors.green;
        label = 'LOW';
        break;
      default:
        color = Colors.grey;
        label = priority.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}