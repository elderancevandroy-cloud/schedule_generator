class AppConstants {
  // App Info
  static const String appName = 'AI Schedule Generator';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String apiKeyKey = 'api_key';
  static const String themeModeKey = 'theme_mode';
  static const String schedulesKey = 'schedules';
  
  // Priority Levels
  static const List<String> priorityLevels = ['high', 'medium', 'low'];
  
  // Categories
  static const List<String> defaultCategories = [
    'Work',
    'Personal',
    'Health',
    'Education',
    'Social',
    'Creative',
  ];
  
  // Break Durations (in minutes)
  static const List<int> breakDurations = [5, 10, 15, 20, 30, 45, 60];
  
  // API Configuration
  static const String defaultApiBaseUrl = 'https://api.openai.com/v1';
  static const int defaultTimeout = 30000; // 30 seconds
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double buttonHeight = 48.0;
  
  // Animation Durations
  static const int defaultAnimationDuration = 300;
}