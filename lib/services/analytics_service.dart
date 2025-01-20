// lib/services/analytics_service.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  final List<Map<String, dynamic>> _events = [];
  Map<String, dynamic>? _userProperties;
  bool _isInitialized = false;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _isInitialized = true;
      debugPrint('AnalyticsService initialized');
    } catch (e) {
      debugPrint('Failed to initialize AnalyticsService: $e');
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      debugPrint('AnalyticsService not initialized');
      return;
    }

    try {
      final eventData = {
        'name': name,
        'parameters': parameters,
        'timestamp': DateTime.now().toIso8601String(),
      };
      _events.add(eventData);

      // Debug logging
      debugPrint('Analytics Event: $name');
      if (parameters != null) {
        debugPrint('Parameters: ${jsonEncode(parameters)}');
      }
    } catch (e) {
      debugPrint('Failed to log event: $e');
    }
  }

  Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> properties,
  }) async {
    if (!_isInitialized) {
      debugPrint('AnalyticsService not initialized');
      return;
    }

    try {
      _userProperties = {
        'userId': userId,
        'properties': properties,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // Debug logging
      debugPrint('Set User Properties for user: $userId');
      debugPrint('Properties: ${jsonEncode(properties)}');
    } catch (e) {
      debugPrint('Failed to set user properties: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await logEvent(
      name: 'screen_view',
      parameters: {
        'screen_name': screenName,
        if (screenClass != null) 'screen_class': screenClass,
      },
    );
  }

  Future<void> logUserAction({
    required String action,
    required String category,
    String? label,
    int? value,
  }) async {
    await logEvent(
      name: 'user_action',
      parameters: {
        'action': action,
        'category': category,
        if (label != null) 'label': label,
        if (value != null) 'value': value,
      },
    );
  }

  Future<void> logError({
    required String error,
    StackTrace? stackTrace,
    String? fatal,
  }) async {
    await logEvent(
      name: 'error',
      parameters: {
        'description': error,
        if (stackTrace != null) 'stack_trace': stackTrace.toString(),
        if (fatal != null) 'fatal': fatal,
      },
    );
  }

  List<Map<String, dynamic>> getStoredEvents() {
    return List<Map<String, dynamic>>.from(_events);
  }

  void clearStoredEvents() {
    _events.clear();
  }

  Map<String, dynamic>? getUserProperties() {
    return _userProperties != null 
        ? Map<String, dynamic>.from(_userProperties!)
        : null;
  }

  // Predefined events
  Future<void> logAppOpen() async {
    await logEvent(name: 'app_open');
  }

  Future<void> logLogin({required String method}) async {
    await logEvent(
      name: 'login',
      parameters: {'method': method},
    );
  }

  Future<void> logSignUp({required String method}) async {
    await logEvent(
      name: 'sign_up',
      parameters: {'method': method},
    );
  }

  Future<void> logEcoAction({
    required String actionId,
    required String actionName,
    required int points,
    Map<String, dynamic>? additionalParams,
  }) async {
    await logEvent(
      name: 'eco_action_completed',
      parameters: {
        'action_id': actionId,
        'action_name': actionName,
        'points': points,
        if (additionalParams != null) ...additionalParams,
      },
    );
  }

  Future<void> logRewardRedeemed({
    required String rewardId,
    required String rewardName,
    required int pointsSpent,
  }) async {
    await logEvent(
      name: 'reward_redeemed',
      parameters: {
        'reward_id': rewardId,
        'reward_name': rewardName,
        'points_spent': pointsSpent,
      },
    );
  }

  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementName,
  }) async {
    await logEvent(
      name: 'achievement_unlocked',
      parameters: {
        'achievement_id': achievementId,
        'achievement_name': achievementName,
      },
    );
  }

  // Analytics reporting methods
  String generateAnalyticsReport() {
    if (_events.isEmpty) {
      return 'No events recorded';
    }

    final buffer = StringBuffer();
    buffer.writeln('Analytics Report');
    buffer.writeln('================');
    buffer.writeln('Total Events: ${_events.length}');
    buffer.writeln();

    // Group events by name
    final eventGroups = <String, List<Map<String, dynamic>>>{};
    for (var event in _events) {
      final name = event['name'] as String;
      eventGroups.putIfAbsent(name, () => []).add(event);
    }

    // Report for each event type
    eventGroups.forEach((eventName, events) {
      buffer.writeln('Event: $eventName');
      buffer.writeln('Occurrences: ${events.length}');
      buffer.writeln('Last occurrence: ${events.last['timestamp']}');
      buffer.writeln('----------------------------------------');
    });

    return buffer.toString();
  }

  // Debug methods
  void printCurrentState() {
    debugPrint('\nAnalytics Service State');
    debugPrint('=======================');
    debugPrint('Initialized: $_isInitialized');
    debugPrint('Total Events: ${_events.length}');
    debugPrint('User Properties: ${_userProperties != null ? jsonEncode(_userProperties) : 'None'}');
    debugPrint('=======================\n');
  }
}

// Example usage:
/*
void main() async {
  final analytics = AnalyticsService();
  await analytics.initialize();
  
  await analytics.logEcoAction(
    actionId: 'plant_tree_1',
    actionName: 'Plant a Tree',
    points: 100,
  );
  
  await analytics.logScreenView(
    screenName: 'Home Screen',
  );
  
  await analytics.setUserProperties(
    userId: 'user123',
    properties: {
      'level': 5,
      'points': 1500,
      'achievements': 10,
    },
  );
  
  analytics.printCurrentState();
  print(analytics.generateAnalyticsReport());
}
*/