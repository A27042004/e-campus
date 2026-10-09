import 'package:flutter/material.dart';

import '../core/models/models.dart';

/// Replace these with Firebase / REST calls later. Every screen already handles
/// loading, empty and error states, so only this file needs to change.
class MockApi {
  MockApi._();

  static Future<T> _wait<T>(T v, [int ms = 700]) async {
    await Future.delayed(Duration(milliseconds: ms));
    return v;
  }

  static Future<List<NewsItem>> news() => _wait(_news);
  static Future<List<Book>> books() => _wait(_books);
  static Future<List<ChatPreview>> chats() => _wait(_chats);
  static Future<List<AppNotification>> notifications() => _wait(_notifications(), 500);
  static Future<List<Assignment>> assignments() => _wait(_assignments);
  static Future<List<SubjectAttendance>> attendance() => _wait(_attendance);
  static Future<List<ClassSlot>> timetable(int day) => _wait(_timetable[day] ?? const [], 400);

  static const departments = ['All', 'CSE', 'IT', 'ECE', 'MECH', 'General'];
  static const categories = [
    'All', 'Computer Science', 'Programming', 'AI & ML', 'Cybersecurity', 'Database', 'Networking'
  ];

  static const _news = <NewsItem>[
    NewsItem(
      id: 'n1', category: 'Placement', department: 'General', important: true,
      title: 'Campus placement drive begins next Monday',
      description: 'Over 40 companies will visit for the 2026 batch. Register on the portal before Friday.',
      date: '08 Oct 2026', color: Color(0xFF6366F1), icon: Icons.work_rounded,
    ),
    NewsItem(
      id: 'n2', category: 'AI & ML', department: 'CSE',
      title: 'New open-source LLMs reshape student projects',
      description: 'Lightweight models now run on laptops, opening new options for final-year work.',
      date: '07 Oct 2026', color: Color(0xFF14B8A6), icon: Icons.auto_awesome_rounded,
    ),
    NewsItem(
      id: 'n3', category: 'Security', department: 'IT',
      title: 'Cybersecurity workshop with industry experts',
      description: 'A two-day hands-on workshop on ethical hacking and secure coding practices.',
      date: '06 Oct 2026', color: Color(0xFFF59E0B), icon: Icons.shield_rounded,
    ),
    NewsItem(
      id: 'n4', category: 'Exams', department: 'General', important: true,
      title: 'Mid-semester exam timetable released',
      description: 'The schedule is now live. Check your department notice board for room allotments.',
      date: '05 Oct 2026', color: Color(0xFFDC2626), icon: Icons.event_note_rounded,
    ),
    NewsItem(
      id: 'n5', category: 'Hardware', department: 'ECE',
      title: 'RISC-V boards available in the electronics lab',
      description: 'Students can now borrow development boards for semester projects.',
      date: '03 Oct 2026', color: Color(0xFF0EA5E9), icon: Icons.memory_rounded,
    ),
    NewsItem(
      id: 'n6', category: 'Event', department: 'MECH',
      title: 'Inter-college robotics challenge announced',
      description: 'Teams of up to four can register. Prizes worth ₹1,00,000 to be won.',
      date: '01 Oct 2026', color: Color(0xFF8B5CF6), icon: Icons.precision_manufacturing_rounded,
    ),
  ];

  static const _books = <Book>[
    Book(id: 'b1', title: 'Introduction to Algorithms', author: 'Cormen et al.', category: 'Computer Science',
        c1: Color(0xFF3730A3), c2: Color(0xFF6366F1), icon: Icons.account_tree_rounded),
    Book(id: 'b2', title: 'Clean Code', author: 'Robert C. Martin', category: 'Programming',
        c1: Color(0xFF0D9488), c2: Color(0xFF2DD4BF), icon: Icons.code_rounded),
    Book(id: 'b3', title: 'Deep Learning', author: 'Goodfellow, Bengio', category: 'AI & ML',
        c1: Color(0xFF7C3AED), c2: Color(0xFFA78BFA), icon: Icons.psychology_rounded),
    Book(id: 'b4', title: "Web Application Hacker's Handbook", author: 'D. Stuttard', category: 'Cybersecurity',
        c1: Color(0xFFB91C1C), c2: Color(0xFFF87171), icon: Icons.security_rounded),
    Book(id: 'b5', title: 'Database System Concepts', author: 'Silberschatz', category: 'Database',
        c1: Color(0xFF0369A1), c2: Color(0xFF38BDF8), icon: Icons.storage_rounded),
    Book(id: 'b6', title: 'Computer Networking', author: 'Kurose & Ross', category: 'Networking',
        c1: Color(0xFFB45309), c2: Color(0xFFFBBF24), icon: Icons.hub_rounded),
    Book(id: 'b7', title: 'Python Crash Course', author: 'Eric Matthes', category: 'Programming',
        c1: Color(0xFF047857), c2: Color(0xFF34D399), icon: Icons.terminal_rounded),
    Book(id: 'b8', title: 'Hands-On Machine Learning', author: 'Aurélien Géron', category: 'AI & ML',
        c1: Color(0xFF4338CA), c2: Color(0xFF818CF8), icon: Icons.smart_toy_rounded),
  ];

  static const _chats = <ChatPreview>[
    ChatPreview(name: 'CSE – Semester 5', last: 'Rohan: Notes for unit 3 uploaded', time: '10:42', unread: 3, group: true),
    ChatPreview(name: 'Dr. Meera Iyer', last: 'Please submit the assignment by Friday', time: '09:15', unread: 1, online: true),
    ChatPreview(name: 'Ananya Desai', last: 'Are you coming to the library?', time: 'Yesterday', online: true),
    ChatPreview(name: 'Project Team Alpha', last: 'Meeting at 4 PM tomorrow', time: 'Yesterday', unread: 5, group: true),
    ChatPreview(name: 'Karan Mehta', last: 'Thanks for the notes!', time: 'Mon'),
    ChatPreview(name: 'Prof. Sanjay Rao', last: 'Lab viva schedule shared', time: 'Sun'),
  ];

  static List<AppNotification> _notifications() => [
        AppNotification(id: '1', title: 'Assignment due tomorrow', body: 'Operating Systems – Process scheduling report',
            time: '2h ago', icon: Icons.assignment_rounded, color: const Color(0xFFF59E0B)),
        AppNotification(id: '2', title: 'New circular published', body: 'Mid-semester exam timetable is now available',
            time: '5h ago', icon: Icons.campaign_rounded, color: const Color(0xFF6366F1)),
        AppNotification(id: '3', title: 'Bus 01 is arriving', body: 'Your bus is 5 minutes away from Main Road stop',
            time: 'Yesterday', icon: Icons.directions_bus_rounded, color: const Color(0xFF14B8A6), unread: false),
        AppNotification(id: '4', title: 'Library reminder', body: '"Clean Code" is due for return in 2 days',
            time: '2 days ago', icon: Icons.menu_book_rounded, color: const Color(0xFF16A34A), unread: false),
      ];

  static const _assignments = <Assignment>[
    Assignment('Process Scheduling Report', 'Operating Systems', 'Due tomorrow', 0.7, urgent: true),
    Assignment('ER Diagram for Library System', 'DBMS', 'Due in 3 days', 0.4),
    Assignment('Binary Tree Implementation', 'Data Structures', 'Due in 5 days', 0.15),
  ];

  static const _attendance = <SubjectAttendance>[
    SubjectAttendance('Operating Systems', 0.92),
    SubjectAttendance('Database Systems', 0.88),
    SubjectAttendance('Computer Networks', 0.81),
    SubjectAttendance('Software Engineering', 0.90),
    SubjectAttendance('Distributed Computing', 0.84),
  ];

  static const _timetable = <int, List<ClassSlot>>{
    0: [
      ClassSlot('09:00 – 10:00', 'Operating Systems', 'Room 301', 'Dr. Meera Iyer'),
      ClassSlot('10:00 – 11:00', 'Database Systems', 'Room 301', 'Prof. Sanjay Rao'),
      ClassSlot('11:15 – 12:15', 'Computer Networks', 'Room 204', 'Dr. A. Khan'),
      ClassSlot('01:00 – 03:00', 'DBMS Lab', 'Lab 2', 'Prof. Sanjay Rao'),
    ],
    1: [
      ClassSlot('09:00 – 10:00', 'Software Engineering', 'Room 305', 'Prof. L. Nair'),
      ClassSlot('10:00 – 11:00', 'Distributed Computing', 'Room 305', 'Dr. Meera Iyer'),
      ClassSlot('11:15 – 12:15', 'Operating Systems', 'Room 301', 'Dr. Meera Iyer'),
    ],
    2: [
      ClassSlot('09:00 – 10:00', 'Computer Networks', 'Room 204', 'Dr. A. Khan'),
      ClassSlot('10:00 – 12:00', 'Networks Lab', 'Lab 4', 'Dr. A. Khan'),
    ],
    3: [
      ClassSlot('09:00 – 10:00', 'Database Systems', 'Room 301', 'Prof. Sanjay Rao'),
      ClassSlot('10:00 – 11:00', 'Distributed Computing', 'Room 305', 'Dr. Meera Iyer'),
      ClassSlot('11:15 – 12:15', 'Software Engineering', 'Room 305', 'Prof. L. Nair'),
    ],
    4: [
      ClassSlot('09:00 – 11:00', 'OS Lab', 'Lab 1', 'Dr. Meera Iyer'),
      ClassSlot('11:15 – 12:15', 'Seminar', 'Auditorium', 'All faculty'),
    ],
    // 5 (Saturday) intentionally empty to demo the empty state
  };
}
