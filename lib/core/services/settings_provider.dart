import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

/// Persists theme + notification preferences and (re)schedules reminders.
class SettingsProvider extends ChangeNotifier {
  SharedPreferences? _p;

  ThemeMode themeMode = ThemeMode.system;
  bool notificationsEnabled = true;
  bool assignmentReminders = true;
  bool classReminders = true;
  bool newsAlerts = false;
  TimeOfDay assignmentTime = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay classTime = const TimeOfDay(hour: 7, minute: 30);

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    themeMode = ThemeMode.values[_p!.getInt('theme') ?? 0];
    notificationsEnabled = _p!.getBool('notif') ?? true;
    assignmentReminders = _p!.getBool('assign') ?? true;
    classReminders = _p!.getBool('class') ?? true;
    newsAlerts = _p!.getBool('news') ?? false;
    assignmentTime = _toTime(_p!.getInt('assignTime') ?? 20 * 60);
    classTime = _toTime(_p!.getInt('classTime') ?? 7 * 60 + 30);
    await _apply();
  }

  TimeOfDay _toTime(int m) => TimeOfDay(hour: m ~/ 60, minute: m % 60);
  int _toMin(TimeOfDay t) => t.hour * 60 + t.minute;

  Future<void> setThemeMode(ThemeMode m) async {
    themeMode = m;
    await _p?.setInt('theme', m.index);
    notifyListeners();
  }

  /// Returns false when the OS permission was denied.
  Future<bool> setNotificationsEnabled(bool v) async {
    if (v) {
      final ok = await NotificationService.requestPermission();
      if (!ok) return false;
    }
    notificationsEnabled = v;
    await _p?.setBool('notif', v);
    await _apply();
    notifyListeners();
    return true;
  }

  Future<void> setAssignmentReminders(bool v) async {
    assignmentReminders = v;
    await _p?.setBool('assign', v);
    await _apply();
    notifyListeners();
  }

  Future<void> setClassReminders(bool v) async {
    classReminders = v;
    await _p?.setBool('class', v);
    await _apply();
    notifyListeners();
  }

  Future<void> setNewsAlerts(bool v) async {
    newsAlerts = v;
    await _p?.setBool('news', v);
    notifyListeners();
  }

  Future<void> setAssignmentTime(TimeOfDay t) async {
    assignmentTime = t;
    await _p?.setInt('assignTime', _toMin(t));
    await _apply();
    notifyListeners();
  }

  Future<void> setClassTime(TimeOfDay t) async {
    classTime = t;
    await _p?.setInt('classTime', _toMin(t));
    await _apply();
    notifyListeners();
  }

  Future<void> _apply() async {
    if (!notificationsEnabled) {
      await NotificationService.cancelAll();
      return;
    }
    if (assignmentReminders) {
      await NotificationService.scheduleDaily(
        id: NotificationService.idAssignments,
        title: 'Assignment reminder 📚',
        body: 'You have pending assignments. Check your deadlines.',
        time: assignmentTime,
      );
    } else {
      await NotificationService.cancel(NotificationService.idAssignments);
    }
    if (classReminders) {
      await NotificationService.scheduleDaily(
        id: NotificationService.idClasses,
        title: "Today's classes 🎓",
        body: "Open E-Campus to see today's timetable.",
        time: classTime,
      );
    } else {
      await NotificationService.cancel(NotificationService.idClasses);
    }
  }
}
