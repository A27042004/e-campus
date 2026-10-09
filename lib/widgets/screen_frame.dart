import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

/// Lets a screen work both as a bottom-nav tab (embedded) and as a pushed page.
class ScreenFrame extends StatelessWidget {
  final bool embedded;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget child;

  const ScreenFrame({
    super.key,
    required this.embedded,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (embedded) return child;
    return Scaffold(
      appBar: CustomAppBar(title: title, subtitle: subtitle, actions: actions),
      body: child,
    );
  }
}
