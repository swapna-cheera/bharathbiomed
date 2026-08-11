import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/tenant/tenant_config.dart';
import '../../core/widgets/dashboard_tile.dart';
import '../../core/widgets/section_header.dart';
import '../auth/auth_controller.dart';
import '../profile/birthday_celebration.dart';
import '../profile/profile_controller.dart';
import '../sync/sync_app_bar_actions.dart';
import '../team/team_access.dart';

/// Entry point for every non-admin (MR) user: every feature reachable as a
/// labeled icon tile in one grid, so nothing depends on remembering what a
/// bare icon means (see admin_home_screen.dart's equivalent quick-actions
/// grid for the admin side). Product Catalog is just one tile here — the
/// actual product browsing lives at '/catalog' (ProductListScreen).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can keep browsing the catalog offline after logging out — sync just needs signing in again.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log out')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfile = ref.watch(myEmployeeProfileProvider).value;
    final isOfficeAdmin = ref.watch(isOfficeAdminProvider);

    ref.listen(myEmployeeProfileProvider, (previous, next) {
      final employee = next.value;
      if (employee != null) maybeShowBirthdayCelebration(context, employee);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTenant.appName),
        actions: [
          const SyncAppBarActions(),
          if (myProfile?.isBirthdayToday ?? false)
            IconButton(
              icon: const Text('🎂', style: TextStyle(fontSize: 20)),
              tooltip: 'Happy Birthday!',
              onPressed: () => showBirthdayCelebration(context, myProfile!),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SectionHeader(title: 'Field Work'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.today_outlined,
                  label: "Today's Visits",
                  onTap: () => context.push('/doctors/today'),
                ),
                DashboardTile(
                  icon: Icons.calendar_month_outlined,
                  label: 'Weekly Visit Plan',
                  onTap: () => context.push('/doctors/plan'),
                ),
                DashboardTile(
                  icon: Icons.local_hospital_outlined,
                  label: 'My Doctors',
                  onTap: () => context.push('/doctors'),
                ),
                DashboardTile(
                  icon: Icons.groups_outlined,
                  label: 'My Team',
                  onTap: () => context.push('/team'),
                ),
                DashboardTile(
                  icon: Icons.add_business_outlined,
                  label: 'Agencies',
                  onTap: () => context.push('/agencies'),
                ),
                DashboardTile(
                  icon: Icons.local_pharmacy_outlined,
                  label: 'Pharmacies',
                  onTap: () => context.push('/pharmacies'),
                ),
                if (isOfficeAdmin)
                  DashboardTile(
                    icon: Icons.pending_actions_outlined,
                    label: 'Partner Requests',
                    onTap: () => context.push('/entity-requests'),
                  ),
                DashboardTile(
                  icon: Icons.add_alert_outlined,
                  label: 'Reminders',
                  onTap: () => context.push('/reminders'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Catalog & Orders'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.storefront_outlined,
                  label: 'Product Catalog',
                  onTap: () => context.push('/catalog'),
                ),
                DashboardTile(
                  icon: Icons.add_shopping_cart,
                  label: 'My Orders',
                  onTap: () => context.push('/orders'),
                ),
                if (isOfficeAdmin)
                  DashboardTile(
                    icon: Icons.inventory_2_outlined,
                    label: 'Manage Inventory',
                    onTap: () => context.push('/admin/inventory'),
                  ),
              ],
            ),
          ),
          const SectionHeader(title: 'Performance & Compliance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.track_changes_outlined,
                  label: 'My Target',
                  onTap: () => context.push('/targets'),
                ),
                DashboardTile(
                  icon: Icons.checklist_outlined,
                  label: 'RCPA Entries',
                  onTap: () => context.push('/rcpa'),
                ),
                DashboardTile(
                  icon: Icons.request_page_outlined,
                  label: 'My Expense Claims',
                  onTap: () => context.push('/expenses'),
                ),
                DashboardTile(
                  icon: Icons.gavel_outlined,
                  label: 'Compliance Log',
                  onTap: () => context.push('/compliance'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Account'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashboardGrid(
              children: [
                DashboardTile(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  onTap: () => context.push('/account/profile'),
                ),
                DashboardTile(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  onTap: () => context.push('/account/change-password'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
