import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/schedule.dart';
import '../models/schedule_item.dart';
import '../models/schedule_request.dart';

class AIService {
  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;

  AIService({
    required String apiKey,
    String baseUrl = 'https://api.openai.com/v1',
  })  : _apiKey = apiKey,
        _baseUrl = baseUrl,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ));

  /// Generate a schedule using AI
  Future<Schedule> generateSchedule(ScheduleRequest request) async {
    try {
      final prompt = request.toAIPrompt();
      
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo', // Using gpt-3.5-turbo as it's more widely available
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional schedule planner. Generate well-structured, realistic schedules based on user requirements. Always respond with valid JSON in this format: {"name": "Schedule Name", "items": [{"title": "Task", "description": "Details", "startTime": "2024-01-01T09:00:00", "endTime": "2024-01-01T10:00:00", "priority": "high", "category": "Work"}]}',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      final jsonData = _extractJson(content);
      
      return _parseScheduleResponse(jsonData, request);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw AIServiceException('API endpoint not found. Please check your API key and ensure you have access to the OpenAI API.');
      } else if (e.response?.statusCode == 401) {
        throw AIServiceException('Invalid API key. Please check your OpenAI API key in Settings.');
      } else if (e.response?.statusCode == 429) {
        throw AIServiceException('Rate limit exceeded. Please try again later.');
      } else {
        throw AIServiceException('Failed to generate schedule: ${e.message}');
      }
    } catch (e) {
      throw AIServiceException('Failed to generate schedule: $e');
    }
  }

  /// Generate a demo schedule (fallback when API is not available)
  Schedule generateDemoSchedule(ScheduleRequest request) {
    final date = request.date;
    final items = <ScheduleItem>[
      ScheduleItem(
        id: '1',
        title: 'Morning Planning',
        description: 'Review daily goals and priorities',
        startTime: DateTime(date.year, date.month, date.day, 9, 0),
        endTime: DateTime(date.year, date.month, date.day, 9, 30),
        priority: 'high',
        category: 'Planning',
      ),
      ScheduleItem(
        id: '2',
        title: 'Focus Work Session',
        description: 'Deep work on main tasks',
        startTime: DateTime(date.year, date.month, date.day, 9, 30),
        endTime: DateTime(date.year, date.month, date.day, 11, 30),
        priority: 'high',
        category: 'Work',
      ),
      ScheduleItem(
        id: '3',
        title: 'Break',
        description: 'Short break and refreshment',
        startTime: DateTime(date.year, date.month, date.day, 11, 30),
        endTime: DateTime(date.year, date.month, date.day, 12, 0),
        priority: 'low',
        category: 'Break',
      ),
      ScheduleItem(
        id: '4',
        title: 'Lunch',
        description: 'Lunch break',
        startTime: DateTime(date.year, date.month, date.day, 12, 0),
        endTime: DateTime(date.year, date.month, date.day, 13, 0),
        priority: 'medium',
        category: 'Personal',
      ),
      ScheduleItem(
        id: '5',
        title: 'Meetings & Collaboration',
        description: 'Team meetings and discussions',
        startTime: DateTime(date.year, date.month, date.day, 13, 0),
        endTime: DateTime(date.year, date.month, date.day, 15, 0),
        priority: 'medium',
        category: 'Work',
      ),
      ScheduleItem(
        id: '6',
        title: 'Wrap Up',
        description: 'Review progress and plan for tomorrow',
        startTime: DateTime(date.year, date.month, date.day, 15, 0),
        endTime: DateTime(date.year, date.month, date.day, 16, 0),
        priority: 'medium',
        category: 'Planning',
      ),
    ];

    return Schedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Demo Schedule for ${date.day}/${date.month}/${date.year}',
      date: date,
      items: items,
      createdAt: DateTime.now(),
      aiPrompt: 'Demo schedule (API not configured)',
    );
  }

  /// Extract JSON from AI response
  Map<String, dynamic> _extractJson(String content) {
    // Try to find JSON in the response
    final jsonPattern = RegExp(r'\{[\s\S]*\}');
    final match = jsonPattern.firstMatch(content);
    
    if (match != null) {
      try {
        return json.decode(match.group(0)!) as Map<String, dynamic>;
      } catch (e) {
        throw AIServiceException('Failed to parse JSON from response');
      }
    }
    
    throw AIServiceException('No valid JSON found in response');
  }

  /// Parse AI response into Schedule object
  Schedule _parseScheduleResponse(
    Map<String, dynamic> jsonData,
    ScheduleRequest request,
  ) {
    final itemsList = (jsonData['items'] as List<dynamic>?)
            ?.map((item) => _parseScheduleItem(item as Map<String, dynamic>, request.date))
            .toList() ??
        [];

    return Schedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: jsonData['name'] as String? ?? 'Generated Schedule',
      date: request.date,
      items: itemsList.map((itemMap) {
        return ScheduleItem.fromJson(itemMap);
      }).toList(),
      createdAt: DateTime.now(),
      aiPrompt: request.toAIPrompt(),
    );
  }

  /// Parse individual schedule item
  Map<String, dynamic> _parseScheduleItem(
    Map<String, dynamic> itemData,
    DateTime date,
  ) {
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': itemData['title'] as String? ?? 'Untitled Task',
      'description': itemData['description'] as String? ?? '',
      'startTime': _parseDateTime(itemData['startTime'] as String?, date),
      'endTime': _parseDateTime(itemData['endTime'] as String?, date),
      'priority': itemData['priority'] as String? ?? 'medium',
      'category': itemData['category'] as String? ?? 'General',
      'isCompleted': false,
      'notes': itemData['notes'] as String?,
      'tags': itemData['tags'] as List<String>?,
    };
  }

  /// Parse datetime string
  String _parseDateTime(String? dateTimeStr, DateTime date) {
    if (dateTimeStr == null) {
      return date.toIso8601String();
    }
    
    try {
      final parsed = DateTime.parse(dateTimeStr);
      return parsed.toIso8601String();
    } catch (e) {
      return date.toIso8601String();
    }
  }

  /// Validate API key
  Future<bool> validateApiKey() async {
    try {
      await _dio.get('/models');
      return true;
    } catch (e) {
      return false;
    }
  }
}

class AIServiceException implements Exception {
  final String message;
  AIServiceException(this.message);

  @override
  String toString() => message;
}