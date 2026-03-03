class ValidationUtils {
  /// Validate API key format
  static bool isValidApiKey(String apiKey) {
    if (apiKey.isEmpty) return false;
    // Basic validation for OpenAI API key format
    return apiKey.startsWith('sk-') && apiKey.length > 20;
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate time range
  static bool isValidTimeRange(String startTime, String endTime) {
    // Basic validation - can be enhanced
    return startTime.isNotEmpty && endTime.isNotEmpty;
  }

  /// Validate task list
  static bool isValidTaskList(List<String> tasks) {
    return tasks.isNotEmpty && tasks.every((task) => task.trim().isNotEmpty);
  }

  /// Validate date is not in the past
  static bool isValidDate(DateTime date) {
    return !date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
  }

  /// Sanitize input string
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Truncate text to specified length
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}