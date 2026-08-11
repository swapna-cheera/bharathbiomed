import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../core/error/app_logger.dart';
import '../../core/error/user_facing_error.dart';
import '../../core/tenant/tenant_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../domain/models/employee.dart';
import '../admin/admin_access.dart';
import '../profile/birthday_celebration.dart';
import '../profile/profile_controller.dart';
import '../sync/sync_controller.dart';
import 'catalog_controller.dart';
import 'selection_controller.dart';
import 'widgets/category_section.dart';

/// Main catalog screen: products grouped by department, with multi-select
/// (feeding the slideshow) and a manual sync button to refresh from Firestore.
/// The app-wide progress overlay (see app.dart/SyncController) covers the
/// screen while this runs, so this button just needs to stay disabled and
/// report the end result.
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _syncCatalog() async {
    debugPrint('ProductListScreen._syncCatalog: sync button pressed');

    String resultMessage;
    try {
      debugPrint('ProductListScreen._syncCatalog: calling syncController.startSync');
      await ref.read(syncControllerProvider.notifier).startSync();
      debugPrint('ProductListScreen._syncCatalog: sync succeeded');
      resultMessage = 'Data synced successfully.';
    } catch (error, stackTrace) {
      debugPrint('ProductListScreen._syncCatalog: sync failed error=$error');
      AppLogger.error('ProductList', 'catalog sync failed', error: error, stackTrace: stackTrace);
      // Deliberately don't rethrow: catalogControllerProvider keeps showing
      // whatever was last synced, so the user isn't left with a blank screen.
      resultMessage = 'Sync failed: ${UserFacingError.describe(error)}';
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMessage)));
  }

  void _openSlideshowForSelection() {
    debugPrint('ProductListScreen._openSlideshowForSelection: play button pressed');
    final selectedProducts = ref.read(selectionControllerProvider);
    if (selectedProducts.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'No Products Selected',
        text: 'Please select products to play the slideshow.',
      );
      return;
    }
    context.push('/slideshow', extra: selectedProducts);
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogControllerProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final isSyncing = ref.watch(syncControllerProvider).isSyncing;
    final Employee? myProfile = isAdmin ? null : ref.watch(myEmployeeProfileProvider).value;

    // Idempotent: maybeShowBirthdayCelebration only actually shows once per
    // uid/year (tracked in shared_preferences), so it's safe to re-run every
    // time this stream emits a new snapshot.
    ref.listen<AsyncValue<Employee?>>(myEmployeeProfileProvider, (previous, next) {
      final employee = next.value;
      if (employee != null) maybeShowBirthdayCelebration(context, employee);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTenant.appName),
        actions: [
          if (myProfile?.isBirthdayToday ?? false)
            IconButton(
              icon: const Text('🎂', style: TextStyle(fontSize: 20)),
              tooltip: 'Happy Birthday!',
              onPressed: () => showBirthdayCelebration(context, myProfile!),
            ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              tooltip: 'Admin',
              onPressed: () => context.push('/admin'),
            ),
          IconButton(
            icon: isSyncing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_sharp),
            tooltip: 'Sync catalog',
            onPressed: isSyncing ? null : _syncCatalog,
            color: AppTheme.success,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load catalog: ${UserFacingError.describe(error)}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('ProductListScreen: Retry button pressed, invalidating catalogControllerProvider');
                    ref.invalidate(catalogControllerProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (snapshot) {
            if (snapshot.departments.isEmpty) {
              return RefreshIndicator(
                onRefresh: _syncCatalog,
                child: ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyState(
                      icon: Icons.storefront_outlined,
                      message: 'No data synced yet.\nSign in and sync, or tap the sync button above, to download the catalog.',
                    ),
                  ],
                ),
              );
            }

            final query = _searchController.text.trim().toLowerCase();
            final departmentsWithProducts = snapshot.departments.map((department) {
              final departmentProducts = snapshot.products
                  .where((product) => product.departments.containsKey(department))
                  .where((product) =>
                      query.isEmpty ||
                      product.name.toLowerCase().contains(query) ||
                      product.info.toLowerCase().contains(query))
                  .toList()
                ..sort((a, b) => a.positionIn(department).compareTo(b.positionIn(department)));
              return (department: department, products: departmentProducts);
            }).where((entry) => entry.products.isNotEmpty).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search products',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _syncCatalog,
                    child: departmentsWithProducts.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 80),
                              EmptyState(icon: Icons.search_off, message: 'No products match this search.'),
                            ],
                          )
                        : ListView.builder(
                            itemCount: departmentsWithProducts.length,
                            itemBuilder: (context, index) {
                              final entry = departmentsWithProducts[index];
                              return CategorySection(category: entry.department, products: entry.products);
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openSlideshowForSelection,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
