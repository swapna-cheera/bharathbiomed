import 'package:flutter/material.dart';

/// A small title label above a group of related content (e.g. a
/// [DashboardGrid] section, or a list section) — see dashboard_screen.dart
/// and admin_home_screen.dart for callers.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
