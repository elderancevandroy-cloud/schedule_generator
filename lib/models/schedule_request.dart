class ScheduleRequest {
  final DateTime date;
  final String? workHours;
  final List<String> tasks;
  final List<String> priorities;
  final String? additionalNotes;
  final int? breakDuration;
  final List<String>? preferredCategories;

  ScheduleRequest({
    required this.date,
    this.workHours,
    required this.tasks,
    required this.priorities,
    this.additionalNotes,
    this.breakDuration,
    this.preferredCategories,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'workHours': workHours,
      'tasks': tasks,
      'priorities': priorities,
      'additionalNotes': additionalNotes,
      'breakDuration': breakDuration,
      'preferredCategories': preferredCategories,
    };
  }

  String toAIPrompt() {
    final buffer = StringBuffer();
    buffer.writeln('Generate a schedule for ${_formatDate(date)}');
    
    if (workHours != null) {
      buffer.writeln('Working hours: $workHours');
    }
    
    if (tasks.isNotEmpty) {
      buffer.writeln('Tasks to include:');
      for (final task in tasks) {
        buffer.writeln('- $task');
      }
    }
    
    if (priorities.isNotEmpty) {
      buffer.writeln('Priorities: ${priorities.join(', ')}');
    }
    
    if (breakDuration != null) {
      buffer.writeln('Break duration: $breakDuration minutes');
    }
    
    if (preferredCategories != null && preferredCategories!.isNotEmpty) {
      buffer.writeln('Preferred categories: ${preferredCategories!.join(', ')}');
    }
    
    if (additionalNotes != null && additionalNotes!.isNotEmpty) {
      buffer.writeln('Additional notes: $additionalNotes');
    }
    
    buffer.writeln('\nPlease provide the schedule in JSON format with the following structure:');
    buffer.writeln('''
{
  "name": "Schedule name",
  "items": [
    {
      "title": "Task title",
      "description": "Task description",
      "startTime": "YYYY-MM-DDTHH:mm:ss",
      "endTime": "YYYY-MM-DDTHH:mm:ss",
      "priority": "high|medium|low",
      "category": "category name",
      "tags": ["tag1", "tag2"]
    }
  ]
}''');
    
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}