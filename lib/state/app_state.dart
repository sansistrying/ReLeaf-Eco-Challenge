// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/eco_action.dart';
import '../models/achievement.dart';
import '../models/reward.dart';

// App State Management using ChangeNotifier
class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  // User State
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Lists
  List<EcoAction> _ecoActions = [];
  List<Achievement> _achievements = [];
  List<Reward> _rewards = [];

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<EcoAction> get ecoActions => _ecoActions;
  List<Achievement> get achievements => _achievements;
  List<Reward> get rewards => _rewards;
  bool get isAuthenticated => _currentUser != null;

  // User Methods
  Future<void> setUser(User user) async {
    try {
      _setLoading(true);
      _currentUser = user;
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearUser() async {
    try {
      _setLoading(true);
      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Eco Actions Methods
  Future<void> setEcoActions(List<EcoAction> actions) async {
    try {
      _setLoading(true);
      _ecoActions = actions;
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addEcoAction(EcoAction action) async {
    try {
      _setLoading(true);
      _ecoActions.add(action);
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Achievements Methods
  Future<void> setAchievements(List<Achievement> achievements) async {
    try {
      _setLoading(true);
      _achievements = achievements;
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> unlockAchievement(Achievement achievement) async {
    try {
      _setLoading(true);
      _achievements.add(achievement);
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Rewards Methods
  Future<void> setRewards(List<Reward> rewards) async {
    try {
      _setLoading(true);
      _rewards = rewards;
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> redeemReward(Reward reward) async {
    try {
      _setLoading(true);
      // Implement reward redemption logic
      _error = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Helper Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Points Management
  int get totalPoints => _currentUser?.points ?? 0;

  Future<void> addPoints(int points) async {
    if (_currentUser != null) {
      try {
        _setLoading(true);
        final updatedUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          points: _currentUser!.points + points,
          avatar: _currentUser!.avatar,
          level: _currentUser!.level,
          preferences: _currentUser!.preferences,
          joinDate: _currentUser!.joinDate,
        );
        await setUser(updatedUser);
      } catch (e) {
        _setError(e.toString());
      } finally {
        _setLoading(false);
      }
    }
  }

  // State Reset
  void resetState() {
    _currentUser = null;
    _ecoActions = [];
    _achievements = [];
    _rewards = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}

// Example usage:
/*
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return CircularProgressIndicator();
        }
        
        if (appState.error != null) {
          return Text('Error: ${appState.error}');
        }
        
        return MaterialApp(
          home: appState.isAuthenticated 
            ? HomeScreen() 
            : LoginScreen(),
        );
      },
    );
  }
}

// In your widgets:
final appState = Provider.of<AppState>(context);
// or
final appState = context.read<AppState>();

// Update state
await appState.setUser(newUser);
await appState.addEcoAction(newAction);
await appState.unlockAchievement(achievement);
*/