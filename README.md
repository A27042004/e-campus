# E-Campus – College Management App (Flutter)

Premium, Material 3 UI with a centralised design system, role-based dashboards, dark mode and
reminder notifications. Works out of the box with mock data (no Firebase / API keys needed).

Requires **Flutter 3.24+** (Dart 3.3+).

## 1. Run it

```bash
cd e_campus
flutter create . --org com.ecampus --project-name e_campus   # generates android/ ios/ (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run
```

## 2. Android setup for reminders (one-time)

**`android/app/src/main/AndroidManifest.xml`** – add before `<application>`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```
and inside `<application>`:
```xml
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

**`android/app/build.gradle`** (Groovy) – enable desugaring:
```gradle
android {
    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'
}
```
If your project uses `build.gradle.kts`: `isCoreLibraryDesugaringEnabled = true` inside `compileOptions`
and `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")` in `dependencies`.

## 3. What's inside

```
lib/
  main.dart                      app entry, Provider setup, light/dark themes
  core/
    theme/app_colors.dart        brand colours + light/dark palette (Pal)
    theme/app_theme.dart         ONE ThemeData for light & dark (Inter font)
    services/                    settings (theme + reminders), notifications, session
    models/, utils/
  data/mock_data.dart            MockApi – replace with Firebase/REST
  widgets/                       CustomButton, CustomTextField, DashboardCard, StatCard,
                                 QuickActionCard, NewsCard, BookCard, BusTrackingCard, ChatTile,
                                 ProfileHeader, CustomAppBar, SectionHeader, LoadingWidget (shimmer),
                                 EmptyStateWidget, ErrorStateWidget, AsyncBody …
  screens/                       auth (splash, login, 3-step register), shell (drawer + bottom nav),
                                 home (role dashboards), academics, timetable, services, library,
                                 chat, ai, bus, news, notifications, profile, settings
```

### Settings
* **Theme**: System / Light / Dark – saved with `shared_preferences`, applied instantly.
* **Notifications**: master switch (asks the OS permission), daily **assignment reminder** and daily
  **class reminder** with a time picker for each, news alerts toggle, and a *send test notification* button.

### Roles
On the login screen choose a demo role (Student / Teacher / CR / Admin). Each gets different stats,
quick actions, dashboard section and drawer items – same design system.

## 4. Connecting real backends

* **Auth**: replace the body of `_submit()` in `login_screen.dart` and `SessionProvider.login/register`
  with Firebase Auth (email/password + phone OTP).
* **Data**: every screen reads from `MockApi` through `AsyncBody`, which already shows shimmer
  loading, empty and friendly error states. Swap `MockApi` methods for Firestore/REST calls; never
  show raw exceptions – throw and let `AsyncBody` render the error state.
* **Campus AI**: replace `_reply()` in `ai_chat_screen.dart` with a call to your backend
  (keep API keys on the server, not in the app).
* **Google Maps**: the bus screen uses an animated `CustomPaint` map so the app runs without a key.
  For the real map: add `google_maps_flutter`, put your API key in `AndroidManifest.xml`
  (`com.google.android.geo.API_KEY`), and replace `_MapArea` with a `GoogleMap` + `Marker`
  that listens to your bus location stream.
