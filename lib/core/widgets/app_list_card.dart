import 'package:flutter/material.dart';

/// A `Card`-wrapped `ListTile` — the majority list-item pattern already used
/// by orders/expenses/compliance/rcpa list screens, made reusable so other
/// screens don't each reimplement the same margin/shape by hand.
class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isThreeLine = false,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isThreeLine;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        isThreeLine: isThreeLine,
      ),
    );
  }
}
