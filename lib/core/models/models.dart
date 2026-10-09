import 'package:flutter/material.dart';

enum UserRole { student, teacher, cr, admin }

String roleLabel(UserRole r) => switch (r) {
      UserRole.student => 'Student',
      UserRole.teacher => 'Teacher',
      UserRole.cr => 'Class Representative',
      UserRole.admin => 'Admin',
    };

class AppUser {
  final String id, name, email, phone, department, semester;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.semester,
  });

  String get shortName => name.split(' ').take(name.startsWith('Dr.') ? 2 : 1).join(' ');

  String get initials {
    final parts = name.replaceAll('Dr. ', '').split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.length == 1
        ? parts.first[0].toUpperCase()
        : (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class NewsItem {
  final String id, category, title, description, date, department;
  final bool important;
  final Color color;
  final IconData icon;

  const NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.department,
    required this.color,
    required this.icon,
    this.important = false,
  });
}

class Book {
  final String id, title, author, category;
  final Color c1, c2;
  final IconData icon;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.c1,
    required this.c2,
    required this.icon,
  });
}

class ChatPreview {
  final String name, last, time;
  final int unread;
  final bool online, group;

  const ChatPreview({
    required this.name,
    required this.last,
    required this.time,
    this.unread = 0,
    this.online = false,
    this.group = false,
  });
}

class ChatMessage {
  final String text, time;
  final bool mine;
  const ChatMessage(this.text, this.time, this.mine);
}

class AppNotification {
  final String id, title, body, time;
  final IconData icon;
  final Color color;
  bool unread;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.color,
    this.unread = true,
  });
}

class Assignment {
  final String title, subject, due;
  final double progress;
  final bool urgent;
  const Assignment(this.title, this.subject, this.due, this.progress, {this.urgent = false});
}

class SubjectAttendance {
  final String name;
  final double percent;
  const SubjectAttendance(this.name, this.percent);
}

class ClassSlot {
  final String time, subject, room, teacher;
  const ClassSlot(this.time, this.subject, this.room, this.teacher);
}
