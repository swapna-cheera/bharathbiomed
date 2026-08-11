import 'package:flutter/material.dart';

/// A single icon+label destination tile used by dashboard-style grids
/// (see [DashboardScreen] and [AdminHomeScreen]'s quick-actions grid) so
/// every navigation option is readable at a glance instead of relying on
/// icon-only buttons/tooltips.
class DashboardTile extends StatelessWidget {
  const DashboardTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.badgeCount,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? Theme.of(context).colorScheme.primary;
    Widget iconWidget = Icon(icon, color: tileColor, size: 26);
    if (badgeCount != null && badgeCount! > 0) {
      iconWidget = Badge(label: Text('$badgeCount'), child: iconWidget);
    }

    return Material(
      color: tileColor.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600, color: tileColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lays out [DashboardTile]s (or any children) in a grid whose tiles stay a
/// fixed, compact size regardless of screen width — a plain column-count
/// grid stretches each cell edge-to-edge, which balloons into oversized
/// tiles on tablets. More columns simply appear on wider screens instead.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key, required this.children, this.maxTileExtent = 110});

  final List<Widget> children;
  final double maxTileExtent;

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: maxTileExtent,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: children,
    );
  }
}
