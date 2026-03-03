import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/schedule.dart';
import '../models/schedule_item.dart';

class StorageService {
  static const String _schedulesKey = 'schedules';
  static const String _databaseName = 'schedules.db';
  static const int _databaseVersion = 1;
  
  Database? _database;
  SharedPreferences? _prefs;

  /// Initialize storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeDatabase();
  }

  /// Initialize SQLite database
  Future<void> _initializeDatabase() async {
    try {
      final path = join(await getDatabasesPath(), _databaseName);
      _database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE schedules(
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              date TEXT NOT NULL,
              items TEXT NOT NULL,
              created_at TEXT NOT NULL,
              ai_prompt TEXT,
              is_favorite INTEGER DEFAULT 0
            )
          ''');
        },
      );
    } catch (e) {
      // Web platform doesn't support sqflite, use SharedPreferences fallback
      print('Database initialization failed (expected on web): $e');
    }
  }

  /// Save schedule to database
  Future<void> saveSchedule(Schedule schedule) async {
    if (_database == null) await _initializeDatabase();
    
    // If database is still null (web platform), use SharedPreferences
    if (_database == null) {
      await _saveScheduleToPrefs(schedule);
      return;
    }
    
    await _database!.insert(
      'schedules',
      {
        'id': schedule.id,
        'name': schedule.name,
        'date': schedule.date.toIso8601String(),
        'items': jsonEncode(schedule.items.map((item) => item.toJson()).toList()),
        'created_at': schedule.createdAt.toIso8601String(),
        'ai_prompt': schedule.aiPrompt,
        'is_favorite': schedule.isFavorite ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// Save schedule to SharedPreferences (fallback for web)
  Future<void> _saveScheduleToPrefs(Schedule schedule) async {
    final schedules = await _getSchedulesFromPrefs();
    schedules.removeWhere((s) => s.id == schedule.id);
    schedules.add(schedule);
    
    final schedulesJson = schedules.map((s) => s.toJson()).toList();
    await _prefs?.setString(_schedulesKey, jsonEncode(schedulesJson));
  }
  
  /// Get schedules from SharedPreferences
  Future<List<Schedule>> _getSchedulesFromPrefs() async {
    final schedulesStr = _prefs?.getString(_schedulesKey);
    if (schedulesStr == null) return [];
    
    final List<dynamic> schedulesJson = jsonDecode(schedulesStr);
    return schedulesJson
        .map((json) => Schedule.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get all schedules
  Future<List<Schedule>> getAllSchedules() async {
    if (_database == null) await _initializeDatabase();
    
    // If database is still null (web platform), use SharedPreferences
    if (_database == null) {
      return await _getSchedulesFromPrefs();
    }
    
    final List<Map<String, dynamic>> maps = await _database!.query('schedules');
    
    return maps.map((map) => _mapToSchedule(map)).toList();
  }

  /// Get schedule by ID
  Future<Schedule?> getScheduleById(String id) async {
    if (_database == null) await _initializeDatabase();
    
    // If database is still null (web platform), use SharedPreferences
    if (_database == null) {
      final schedules = await _getSchedulesFromPrefs();
      try {
        return schedules.firstWhere((s) => s.id == id);
      } catch (e) {
        return null;
      }
    }
    
    final List<Map<String, dynamic>> maps = await _database!.query(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return _mapToSchedule(maps.first);
  }

  /// Get favorite schedules
  Future<List<Schedule>> getFavoriteSchedules() async {
    if (_database == null) await _initializeDatabase();
    
    // If database is still null (web platform), use SharedPreferences
    if (_database == null) {
      final schedules = await _getSchedulesFromPrefs();
      return schedules.where((s) => s.isFavorite).toList();
    }
    
    final List<Map<String, dynamic>> maps = await _database!.query(
      'schedules',
      where: 'is_favorite = ?',
      whereArgs: [1],
    );
    
    return maps.map((map) => _mapToSchedule(map)).toList();
  }

  /// Update schedule
  Future<void> updateSchedule(Schedule schedule) async {
    if (_database == null) await _initializeDatabase();
    
    // If database is still null (web platform), use SharedPreferences
    if (_database == null) {
      await _saveScheduleToPrefs(schedule);
      return;
    }
    
    await _database!.update(
      'schedules',
      {
        'name': schedule.name,
        'date': schedule.date.toIso8601String(),
        'items': jsonEncode(schedule.items.map((item) => item.toJson()).toList()),
        'ai_prompt': schedule.aiPrompt,
        'is_favorite': schedule.isFavorite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  /// Delete schedule
  Future<void> deleteSchedule(String id) async {
    if (_database == null) await _initializeDatabase();
    
    // If database is still null (web platform), use SharedPreferences
    if (_database == null) {
      final schedules = await _getSchedulesFromPrefs();
      schedules.removeWhere((s) => s.id == id);
      final schedulesJson = schedules.map((s) => s.toJson()).toList();
      await _prefs?.setString(_schedulesKey, jsonEncode(schedulesJson));
      return;
    }
    
    await _database!.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final schedule = await getScheduleById(id);
    if (schedule != null) {
      final updated = schedule.copyWith(isFavorite: !schedule.isFavorite);
      await updateSchedule(updated);
    }
  }

  /// Map database row to Schedule object
  Schedule _mapToSchedule(Map<String, dynamic> map) {
    final itemsJson = jsonDecode(map['items'] as String) as List;
    final items = itemsJson
        .map((item) => ScheduleItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return Schedule(
      id: map['id'] as String,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
      items: items,
      createdAt: DateTime.parse(map['created_at'] as String),
      aiPrompt: map['ai_prompt'] as String?,
      isFavorite: (map['is_favorite'] as int) == 1,
    );
  }

  /// Save API key securely
  Future<void> saveApiKey(String apiKey) async {
    await _prefs?.setString('api_key', apiKey);
  }

  /// Get saved API key
  Future<String?> getApiKey() async {
    return _prefs?.getString('api_key');
  }

  /// Clear all data
  Future<void> clearAll() async {
    if (_database != null) {
      await _database!.delete('schedules');
    }
    await _prefs?.clear();
  }
}