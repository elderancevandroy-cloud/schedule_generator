import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(schedule.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      schedule.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: schedule.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatChip(
                    Icons.task_alt,
                    '${schedule.completedItems}/${schedule.totalItems}',
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.schedule,
                    '${schedule.items.length} tasks',
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  if (schedule.completionRate > 0)
                    _buildStatChip(
                      Icons.percent,
                      '${(schedule.completionRate * 100).toInt()}%',
                      Colors.orange,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: schedule.completionRate,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  schedule.completionRate == 1.0 ? Colors.green : Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}