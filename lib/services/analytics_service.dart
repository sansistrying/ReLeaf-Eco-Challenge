// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> properties,
  }) async {
    await _analytics.setUserId(id: userId);
    properties.forEach((key, value) async {
      await _analytics.setUserProperty(name: key, value: value.toString());
    });
  }
}

