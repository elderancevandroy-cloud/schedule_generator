import 'schedule_item.dart';

class Schedule {
  final String id;
  final String name;
  final DateTime date;
  final List<ScheduleItem> items;
  final DateTime createdAt;
  final String? aiPrompt;
  final bool isFavorite;

  Schedule({
    required this.id,
    required this.name,
    required this.date,
    required this.items,
    required this.createdAt,
    this.aiPrompt,
    this.isFavorite = false,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => ScheduleItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      aiPrompt: json['aiPrompt'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'aiPrompt': aiPrompt,
      'isFavorite': isFavorite,
    };
  }

  Schedule copyWith({
    String? id,
    String? name,
    DateTime? date,
    List<ScheduleItem>? items,
    DateTime? createdAt,
    String? aiPrompt,
    bool? isFavorite,
  }) {
    return Schedule(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      aiPrompt: aiPrompt ?? this.aiPrompt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  int get totalItems => items.length;
  int get completedItems => items.where((item) => item.isCompleted).length;
  double get completionRate => totalItems > 0 ? completedItems / totalItems : 0.0;
}