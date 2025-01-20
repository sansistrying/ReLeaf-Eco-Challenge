// lib/utils/app_logger.dart
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class AppLogger {
  static const String _defaultTag = 'APP';
  static bool _enabled = true;

  // Enable/disable logging
  static void enable() => _enabled = true;
  static void disable() => _enabled = false;

  // Log levels
  static void debug(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      'DEBUG',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[37m', // White
    );
  }

  static void info(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      'INFO',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[34m', // Blue
    );
  }

  static void warning(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      'WARNING',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[33m', // Yellow
    );
  }

  static void error(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      'ERROR',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[31m', // Red
    );
  }

  static void success(
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log(
      'SUCCESS',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[32m', // Green
    );
  }

  // Main logging method
  static void _log(
    String level,
    dynamic message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    String color = '\x1B[37m', // Default: White
  }) {
    if (!_enabled) return;

    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    final finalTag = tag ?? _defaultTag;
    final reset = '\x1B[0m';
    
    // Build the log message
    final buffer = StringBuffer()
      ..write('$color[$timeString][$finalTag][$level] ')
      ..write(message)
      ..write(reset);

    if (error != null) {
      buffer
        ..write('\n$color┌── Error: ')
        ..write(error)
        ..write(reset);
    }

    if (stackTrace != null) {
      buffer
        ..write('\n$color├── Stack trace:\n')
        ..write(stackTrace)
        ..write(reset);
    }

    // Use debugPrint in debug mode, developer.log in release mode
    if (kDebugMode) {
      debugPrint(buffer.toString());
    } else {
      developer.log(
        buffer.toString(),
        time: now,
        name: finalTag,
        level: _getLevelNumber(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Helper method to get numeric log level
  static int _getLevelNumber(String level) {
    switch (level) {
      case 'DEBUG':
        return 500;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
        return 1000;
      case 'SUCCESS':
        return 800;
      default:
        return 800;
    }
  }

  // Performance logging
  static void logPerformance(
    String operation,
    Duration duration, {
    String? tag,
    Map<String, dynamic>? additionalInfo,
  }) {
    final buffer = StringBuffer()
      ..write('Performance: $operation')
      ..write(' (${duration.inMilliseconds}ms)');

    if (additionalInfo != null) {
      buffer.write('\nAdditional Info: $additionalInfo');
    }

    info(buffer.toString(), tag: tag ?? 'PERFORMANCE');
  }

  // Network logging
  static void logNetwork(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
    dynamic response,
    Duration? duration,
    String? tag,
  }) {
    final buffer = StringBuffer()
      ..write('Network Request: $method $url');

    if (headers != null) {
      buffer.write('\nHeaders: $headers');
    }

    if (body != null) {
      buffer.write('\nBody: $body');
    }

    if (response != null) {
      buffer.write('\nResponse: $response');
    }

    if (duration != null) {
      buffer.write('\nDuration: ${duration.inMilliseconds}ms');
    }

    info(buffer.toString(), tag: tag ?? 'NETWORK');
  }

  // State logging
  static void logState(
    String stateName,
    dynamic oldState,
    dynamic newState, {
    String? tag,
  }) {
    final buffer = StringBuffer()
      ..write('State Change: $stateName')
      ..write('\nOld State: $oldState')
      ..write('\nNew State: $newState');

    debug(buffer.toString(), tag: tag ?? 'STATE');
  }
}

// Example usage:
/*
void main() {
  // Enable logging (enabled by default)
  AppLogger.enable();

  // Basic logging
  AppLogger.debug('Debug message');
  AppLogger.info('Info message');
  AppLogger.warning('Warning message');
  AppLogger.error('Error message');
  AppLogger.success('Success message');

  // Logging with tags
  AppLogger.info('User logged in', tag: 'AUTH');

  // Logging errors with stack traces
  try {
    throw Exception('Something went wrong');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to process request',
      tag: 'API',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // Performance logging
  final stopwatch = Stopwatch()..start();
  // ... perform operation
  stopwatch.stop();
  AppLogger.logPerformance(
    'Load user data',
    stopwatch.elapsed,
    additionalInfo: {'userId': '123'},
  );

  // Network logging
  AppLogger.logNetwork(
    'GET',
    'https://api.example.com/users',
    headers: {'Authorization': 'Bearer token'},
    response: {'status': 'success'},
    duration: Duration(milliseconds: 200),
  );

  // State logging
  AppLogger.logState(
    'UserState',
    {'isLoggedIn': false},
    {'isLoggedIn': true},
  );
}
*/