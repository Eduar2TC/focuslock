import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

class AchievementRepository {
  final SharedPreferences _prefs;

  AchievementRepository(this._prefs);

  List<Achievement> getAchievements() {
    return [
      Achievement(
        id: 'first_session',
        title: 'First Step',
        description: 'Complete your first focus session',
        isUnlocked: _prefs.getBool('achievement_first_session') ?? false,
      ),
      Achievement(
        id: 'streak_3',
        title: 'Consistent',
        description: 'Maintain a 3-day streak',
        isUnlocked: _prefs.getBool('achievement_streak_3') ?? false,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Dedicated',
        description: 'Maintain a 7-day streak',
        isUnlocked: _prefs.getBool('achievement_streak_7') ?? false,
      ),
      Achievement(
        id: 'sessions_10',
        title: 'Focused',
        description: 'Complete 10 focus sessions',
        isUnlocked: _prefs.getBool('achievement_sessions_10') ?? false,
      ),
      Achievement(
        id: 'sessions_50',
        title: 'Disciplined',
        description: 'Complete 50 focus sessions',
        isUnlocked: _prefs.getBool('achievement_sessions_50') ?? false,
      ),
      Achievement(
        id: 'focus_10h',
        title: 'Deep Worker',
        description: 'Accumulate 10 hours of focus time',
        isUnlocked: _prefs.getBool('achievement_focus_10h') ?? false,
      ),
    ];
  }

  Future<void> unlockAchievement(String id) async {
    await _prefs.setBool('achievement_$id', true);
  }
}
