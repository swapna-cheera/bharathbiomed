import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/dashboard_tile.dart';
import '../../core/widgets/section_header.dart';
import '../../domain/models/permission.dart';
import 'team_access.dart';

/// Entry point for a manager's view of their own reporting-chain downline
/// (or, for a `view_global_data` holder, everyone): usage/location,
/// doctor-visit-log reports, the order workflow queue, team targets, RCPA
/// entries, expense-claim approvals, visit-plan approvals, Doctor/Agency-
/// Pharmacy request reviews (for an `approve_requests` holder — see below),
/// and the UCPMP compliance dashboard. Reachable by any signed-in employee;
/// every screen behind it simply shows an empty state if the signed-in user
/// doesn't actually manage anyone (see `resolveVisibleEmployees`) or lacks
/// the specific permission that screen's actions need (e.g.
/// `approve_expenses`). Uses the same icon+label grid as the Admin/MR home
/// screens (see `dashboard_tile.dart`) so all three logins share one visual
/// language.
class TeamHomeScreen extends ConsumerWidget {
  const TeamHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canApproveRequests = ref.watch(hasPermissionProvider(Permission.approveRequests));

    return Scaffold(
      appBar: AppBar(title: const Text('My Team')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SectionHeader(title: 'Overview'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.bar_chart,
                  label: 'Usage & Location',
                  onTap: () => context.push('/team/usage'),
                ),
                DashboardTile(
                  icon: Icons.gavel_outlined,
                  label: 'Compliance Dashboard',
                  onTap: () => context.push('/team/compliance'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Field Work'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.local_hospital_outlined,
                  label: 'Visit Logs',
                  onTap: () => context.push('/team/visit-logs'),
                ),
                DashboardTile(
                  icon: Icons.map_outlined,
                  label: 'Visit Plan Approvals',
                  onTap: () => context.push('/team/visit-plans'),
                ),
                DashboardTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'Order Workflow',
                  onTap: () => context.push('/team/orders'),
                ),
                if (canApproveRequests)
                  DashboardTile(
                    icon: Icons.how_to_reg_outlined,
                    label: 'Doctor Requests',
                    onTap: () => context.push('/doctor-requests'),
                  ),
                if (canApproveRequests)
                  DashboardTile(
                    icon: Icons.pending_actions_outlined,
                    label: 'Agency / Pharmacy Requests',
                    onTap: () => context.push('/entity-requests'),
                  ),
              ],
            ),
          ),
          const SectionHeader(title: 'Performance & Approvals'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.track_changes_outlined,
                  label: 'Team Targets',
                  onTap: () => context.push('/team/targets'),
                ),
                DashboardTile(
                  icon: Icons.checklist_outlined,
                  label: 'RCPA Entries',
                  onTap: () => context.push('/team/rcpa'),
                ),
                DashboardTile(
                  icon: Icons.request_page_outlined,
                  label: 'Expense Claims',
                  onTap: () => context.push('/team/expenses'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
