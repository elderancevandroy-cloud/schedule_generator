class ScheduleItem {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String priority; // high, medium, low
  final String category;
  final bool isCompleted;
  final String? notes;
  final List<String>? tags;

  ScheduleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.category,
    this.isCompleted = false,
    this.notes,
    this.tags,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      priority: json['priority'] as String,
      category: json['category'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String?,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'priority': priority,
      'category': category,
      'isCompleted': isCompleted,
      'notes': notes,
      'tags': tags,
    };
  }

  ScheduleItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? priority,
    String? category,
    bool? isCompleted,
    String? notes,
    List<String>? tags,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
    );
  }

  Duration get duration => endTime.difference(startTime);
}