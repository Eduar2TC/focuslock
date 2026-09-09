import 'package:focuslock/l10n/app_localizations.dart';

extension DateTimeExtension on DateTime {
  String greeting(AppLocalizations l10n) {
    final hour = this.hour;
    if (hour < 12) {
      return l10n.greetingMorning;
    } else if (hour < 18) {
      return l10n.greetingAfternoon;
    } else {
      return l10n.greetingEvening;
    }
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  String timeFormatted(AppLocalizations l10n) {
    final h = hour;
    final m = minute;
    final period = h >= 12 ? l10n.timePM : l10n.timeAM;
    final displayHour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$displayHour:${m.toString().padLeft(2, '0')} $period';
  }
}

extension DurationExtension on Duration {
  String get formatted {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get formattedShort {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get timerFormatted {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

extension IntDurationExtension on int {
  Duration get minutes => Duration(minutes: this);
}
