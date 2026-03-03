import 'package:flutter/foundation.dart';
import '../models/schedule.dart';
import '../models/schedule_item.dart';
import '../models/schedule_request.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';

class ScheduleProvider with ChangeNotifier {
  final StorageService _storageService;
  AIService? _aiService;
  
  List<Schedule> _schedules = [];
  Schedule? _currentSchedule;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  ScheduleProvider(this._storageService);

  // Getters
  List<Schedule> get schedules => _schedules;
  Schedule? get currentSchedule => _currentSchedule;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  List<Schedule> get favoriteSchedules => 
      _schedules.where((s) => s.isFavorite).toList();

  /// Initialize the provider
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await _storageService.initialize();
      await loadSchedules();
      
      final apiKey = await _storageService.getApiKey();
      if (apiKey != null) {
        _aiService = AIService(apiKey: apiKey);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to initialize: $e';
      notifyListeners();
    }
  }

  /// Set API key for AI service
  Future<void> setApiKey(String apiKey) async {
    try {
      await _storageService.saveApiKey(apiKey);
      _aiService = AIService(apiKey: apiKey);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to set API key: $e';
      notifyListeners();
    }
  }

  /// Load all schedules from storage
  Future<void> loadSchedules() async {
    try {
      _schedules = await _storageService.getAllSchedules();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load schedules: $e';
      notifyListeners();
    }
  }

  /// Generate new schedule using AI
  Future<void> generateSchedule(ScheduleRequest request, {bool useDemo = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Schedule schedule;
      
      if (useDemo || _aiService == null) {
        // Generate demo schedule if API is not configured or demo is requested
        if (_aiService == null) {
          // Create a temporary AI service just for demo
          final demoService = AIService(apiKey: 'demo');
          schedule = demoService.generateDemoSchedule(request);
        } else {
          schedule = _aiService!.generateDemoSchedule(request);
        }
      } else {
        // Use AI to generate schedule
        schedule = await _aiService!.generateSchedule(request);
      }
      
      await _storageService.saveSchedule(schedule);
      
      _currentSchedule = schedule;
      _schedules.insert(0, schedule);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to generate schedule: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate demo schedule (without API)
  Future<void> generateDemoSchedule(ScheduleRequest request) async {
    await generateSchedule(request, useDemo: true);
  }

  /// Select a schedule as current
  void selectSchedule(Schedule schedule) {
    _currentSchedule = schedule;
    notifyListeners();
  }

  /// Update schedule item completion status
  Future<void> toggleItemCompletion(String scheduleId, String itemId) async {
    final scheduleIndex = _schedules.indexWhere((s) => s.id == scheduleId);
    if (scheduleIndex == -1) return;

    final schedule = _schedules[scheduleIndex];
    final itemIndex = schedule.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) return;

    final updatedItem = schedule.items[itemIndex].copyWith(
      isCompleted: !schedule.items[itemIndex].isCompleted,
    );

    final updatedItems = List<ScheduleItem>.from(schedule.items);
    updatedItems[itemIndex] = updatedItem;

    final updatedSchedule = schedule.copyWith(items: updatedItems);
    _schedules[scheduleIndex] = updatedSchedule;
    
    if (_currentSchedule?.id == scheduleId) {
      _currentSchedule = updatedSchedule;
    }

    await _storageService.updateSchedule(updatedSchedule);
    notifyListeners();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String scheduleId) async {
    await _storageService.toggleFavorite(scheduleId);
    await loadSchedules();
  }

  /// Delete schedule
  Future<void> deleteSchedule(String scheduleId) async {
    await _storageService.deleteSchedule(scheduleId);
    
    _schedules.removeWhere((s) => s.id == scheduleId);
    if (_currentSchedule?.id == scheduleId) {
      _currentSchedule = null;
    }
    
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh schedules
  Future<void> refresh() async {
    await loadSchedules();
  }
}