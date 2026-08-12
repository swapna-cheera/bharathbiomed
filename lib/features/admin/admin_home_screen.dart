import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/error/user_facing_error.dart';
import '../../core/theme/accent_palette.dart';
import '../../core/widgets/dashboard_tile.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/stat_tile.dart';
import '../auth/auth_controller.dart';
import '../sync/sync_app_bar_actions.dart';
import 'admin_catalog_controller.dart';
import 'admin_notifications_controller.dart';
import 'employee_controller.dart';

/// Entry point for the admin section: departments (tap to manage that
/// department's products) plus links to department/designation/employee
/// management and adding a new product.
class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    debugPrint('AdminHomeScreen._logout: logout requested');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You\'ll need to sign in again to reach the admin panel.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Log out')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    debugPrint('AdminHomeScreen._logout: signing out');
    await ref.read(authControllerProvider.notifier).signOut();
    debugPrint('AdminHomeScreen._logout: signed out');
    if (!context.mounted) return;
    context.go('/login');
  }

  /// Every quick-action tile, grouped by section. Filtered against the
  /// search field below so the ~17 tiles here (more once Financial/Other
  /// grow further) stay scannable instead of relying purely on eyeballing
  /// the grid — a whole section disappears once none of its tiles match.
  List<MapEntry<String, List<DashboardTile>>> _sections(BuildContext context) {
    return [
      MapEntry('Catalog & People', [
        DashboardTile(icon: Icons.storefront_outlined, label: 'View Catalog', onTap: () => context.push('/catalog')),
        DashboardTile(
            icon: Icons.apartment, label: 'Departments', onTap: () => context.push('/admin/departments')),
        DashboardTile(
            icon: Icons.badge_outlined, label: 'Designations', onTap: () => context.push('/admin/designations')),
        DashboardTile(
            icon: Icons.people_outline, label: 'Employees', onTap: () => context.push('/admin/employees')),
        DashboardTile(
            icon: Icons.local_hospital_outlined, label: 'Doctors', onTap: () => context.push('/admin/doctors')),
        DashboardTile(icon: Icons.add_business_outlined, label: 'Agencies', onTap: () => context.push('/agencies')),
        DashboardTile(
            icon: Icons.local_pharmacy_outlined, label: 'Pharmacies', onTap: () => context.push('/pharmacies')),
        DashboardTile(
            icon: Icons.pending_actions_outlined,
            label: 'Partner Requests',
            onTap: () => context.push('/entity-requests')),
      ]),
      MapEntry('Field Operations', [
        DashboardTile(
            icon: Icons.assignment_outlined, label: 'Visit Logs', onTap: () => context.push('/team/visit-logs')),
        DashboardTile(
            icon: Icons.checklist_outlined, label: 'RCPA Entries', onTap: () => context.push('/team/rcpa')),
        DashboardTile(
            icon: Icons.bar_chart, label: 'Usage Dashboard', onTap: () => context.push('/admin/dashboard')),
      ]),
      MapEntry('Financial', [
        DashboardTile(
            icon: Icons.inventory_2_outlined, label: 'Inventory', onTap: () => context.push('/admin/inventory')),
        DashboardTile(
            icon: Icons.warning_amber_outlined,
            label: 'Expiry Alerts',
            onTap: () => context.push('/admin/inventory/expiry-alerts')),
        DashboardTile(
            icon: Icons.receipt_long_outlined, label: 'Order Workflow', onTap: () => context.push('/team/orders')),
        DashboardTile(
            icon: Icons.track_changes_outlined, label: 'Team Targets', onTap: () => context.push('/team/targets')),
      ]),
      MapEntry('Other', [
        DashboardTile(icon: Icons.add_alert_outlined, label: 'Reminders', onTap: () => context.push('/reminders')),
        DashboardTile(
            icon: Icons.person_outline, label: 'Profile', onTap: () => context.push('/account/profile')),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(adminCatalogControllerProvider);
    final employees = ref.watch(employeeControllerProvider);
    final unreadNotifications = ref.watch(unreadAdminNotificationsCountProvider);
    final query = _searchController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          const SyncAppBarActions(),
          IconButton(
            icon: Badge(
              label: Text('$unreadNotifications'),
              isLabelVisible: unreadNotifications > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            tooltip: 'Notifications',
            onPressed: () => context.push('/admin/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to load catalog: ${UserFacingError.describe(error)}'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  debugPrint('AdminHomeScreen: retry button tapped');
                  ref.read(adminCatalogControllerProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (snapshot) {
          final allSections = _sections(context);
          final filteredSections = query.isEmpty
              ? allSections
              : allSections
                  .map((section) => MapEntry(
                        section.key,
                        section.value.where((tile) => tile.label.toLowerCase().contains(query)).toList(),
                      ))
                  .where((section) => section.value.isNotEmpty)
                  .toList();
          // Departments get their own list (with live product counts) right
          // under the header, ahead of the quick-action grid — hidden while
          // searching since the grid's filtered results take that spot.
          final showDepartments = query.isEmpty;
          final departmentsEmpty = showDepartments && snapshot.departments.isEmpty;
          final departmentItemCount = showDepartments ? (departmentsEmpty ? 1 : snapshot.departments.length) : 0;
          final departmentSectionLength = showDepartments ? 1 + departmentItemCount : 0;
          final gridIndex = 1 + departmentSectionLength;

          return RefreshIndicator(
            onRefresh: () {
              debugPrint('AdminHomeScreen: pull-to-refresh triggered');
              return ref.read(adminCatalogControllerProvider.notifier).refresh();
            },
            child: ListView.builder(
              itemCount: gridIndex + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatTile(
                                icon: Icons.apartment,
                                color: const Color(0xFF3470B2),
                                label: 'Departments',
                                value: snapshot.departments.length.toString(),
                                onTap: () => context.push('/admin/departments'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatTile(
                                icon: Icons.inventory_2_outlined,
                                color: const Color(0xFF2E7D32),
                                label: 'Products',
                                value: snapshot.products.length.toString(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatTile(
                                icon: Icons.people_outline,
                                color: const Color(0xFFEF6C00),
                                label: 'Users',
                                value: employees.maybeWhen(
                                  data: (list) => list.length.toString(),
                                  orElse: () => '–',
                                ),
                                onTap: () => context.push('/admin/employees'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search admin actions…',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: query.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => _searchController.clear(),
                                  ),
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (showDepartments) {
                  if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text('Departments', style: Theme.of(context).textTheme.titleSmall),
                    );
                  }
                  if (departmentsEmpty && index == 2) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Text(
                        'No departments yet.\nUse Departments in the grid below to add one.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (!departmentsEmpty && index >= 2 && index < 2 + departmentItemCount) {
                    final department = snapshot.departments[index - 2];
                    final count = snapshot.products.where((p) => p.departments.containsKey(department)).length;
                    final color = AccentPalette.forLabel(department);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        foregroundColor: color,
                        child: Text(department.isNotEmpty ? department[0].toUpperCase() : '?'),
                      ),
                      title: Text(department),
                      subtitle: Text('$count product${count == 1 ? '' : 's'}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.push('/admin/departments/products', extra: department),
                    );
                  }
                }
                // index == gridIndex
                if (filteredSections.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Text('No admin actions match your search.', textAlign: TextAlign.center),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final section in filteredSections) ...[
                      SectionHeader(title: section.key),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: DashboardGrid(children: section.value),
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/products/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
