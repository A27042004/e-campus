import 'package:flutter/foundation.dart';

import '../models/models.dart';

/// Holds the signed-in user. Swap `login` for Firebase Auth later.
class SessionProvider extends ChangeNotifier {
  AppUser? user;

  bool get loggedIn => user != null;

  void login(UserRole role, {String identifier = ''}) {
    final email = identifier.contains('@') ? identifier : 'user@ecampus.edu';
    final phone = RegExp(r'^\d{10}$').hasMatch(identifier) ? identifier : '9876543210';
    user = switch (role) {
      UserRole.student => AppUser(
          id: 'CS2023-045', name: 'Aarav Sharma', email: email, phone: phone, role: role,
          department: 'Computer Science', semester: 'Semester 5'),
      UserRole.teacher => AppUser(
          id: 'T-0192', name: 'Dr. Meera Iyer', email: email, phone: phone, role: role,
          department: 'Computer Science', semester: 'Faculty'),
      UserRole.cr => AppUser(
          id: 'CS2023-012', name: 'Rohan Patil', email: email, phone: phone, role: role,
          department: 'Computer Science', semester: 'Semester 5'),
      UserRole.admin => AppUser(
          id: 'A-0001', name: 'Admin Office', email: email, phone: phone, role: role,
          department: 'Administration', semester: 'Management'),
    };
    notifyListeners();
  }

  void register({
    required String name,
    required String email,
    required String phone,
    required String department,
    required String semester,
  }) {
    user = AppUser(
      id: 'NEW-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: name, email: email, phone: phone, role: UserRole.student,
      department: department, semester: semester,
    );
    notifyListeners();
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
