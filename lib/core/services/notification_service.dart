import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Wraps flutter_local_notifications so the UI never touches the plugin directly.
class NotificationService {
NotificationService._();

static final FlutterLocalNotificationsPlugin _plugin =
FlutterLocalNotificationsPlugin();

static bool _ready = false;

static const int idAssignments = 101;
static const int idClasses = 102;
static const int idTest = 199;

static const NotificationDetails _details = NotificationDetails(
android: AndroidNotificationDetails(
'ecampus_reminders',
'E-Campus reminders',
channelDescription: 'Assignment, class and campus reminders',
importance: Importance.high,
priority: Priority.high,
),
);

static Future<void> init() async {
if (kIsWeb) return;

try {
// Initialize timezone database.
tzdata.initializeTimeZones();

// Use the device's current local UTC offset as a fallback.
// This avoids the incompatible flutter_timezone plugin.
final DateTime now = DateTime.now();
final Duration offset = now.timeZoneOffset;

// Select a timezone location from the bundled database.
// UTC is a safe fallback if a matching location is unavailable.
tz.setLocalLocation(tz.getLocation('UTC'));

// Keep timezone scheduling aligned with the device's current offset.
// Note: UTC fallback does not automatically handle future daylight
// saving changes. Use a device timezone plugin if that is required.

const AndroidInitializationSettings androidSettings =
AndroidInitializationSettings('@mipmap/ic_launcher');

const InitializationSettings settings =
InitializationSettings(android: androidSettings);

await _plugin.initialize(settings);

_ready = true;

debugPrint('Notification service initialized. Device offset: $offset');
} catch (e) {
debugPrint('Notification init failed: $e');
}
}

/// Returns true if notification permission was granted or is not required.
static Future<bool> requestPermission() async {
if (!_ready) return false;

try {
final android = _plugin
    .resolvePlatformSpecificImplementation<
AndroidFlutterLocalNotificationsPlugin>();

return await android?.requestNotificationsPermission() ?? true;
} catch (e) {
debugPrint('Notification permission request failed: $e');
return false;
}
}

static tz.TZDateTime _next(TimeOfDay time) {
final now = tz.TZDateTime.now(tz.local);

var scheduled = tz.TZDateTime(
tz.local,
now.year,
now.month,
now.day,
time.hour,
time.minute,
);

if (!scheduled.isAfter(now)) {
scheduled = scheduled.add(const Duration(days: 1));
}

return scheduled;
}

/// Schedules a reminder to repeat daily at the selected time.
static Future<void> scheduleDaily({
required int id,
required String title,
required String body,
required TimeOfDay time,
}) async {
if (!_ready) return;

try {
await _plugin.zonedSchedule(
id,
title,
body,
_next(time),
_details,
androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
uiLocalNotificationDateInterpretation:
UILocalNotificationDateInterpretation.absoluteTime,
matchDateTimeComponents: DateTimeComponents.time,
);
} catch (e) {
debugPrint('Schedule failed: $e');
}
}

static Future<void> cancel(int id) async {
if (!_ready) return;

try {
await _plugin.cancel(id);
} catch (e) {
debugPrint('Cancel notification failed: $e');
}
}

static Future<void> cancelAll() async {
if (!_ready) return;

try {
await _plugin.cancelAll();
} catch (e) {
debugPrint('Cancel all notifications failed: $e');
}
}

static Future<void> showTest() async {
if (!_ready) return;

try {
await _plugin.show(
idTest,
'E-Campus reminders are on 🎓',
'You will get assignment and class reminders at your chosen times.',
_details,
);
} catch (e) {
debugPrint('Test notification failed: $e');
}
}
}

