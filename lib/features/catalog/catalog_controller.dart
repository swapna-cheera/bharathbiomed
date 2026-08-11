import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/repositories/product_repository.dart';
import '../admin/admin_access.dart';
import '../agencies/agency_controller.dart';
import '../auth/auth_controller.dart';
import '../doctors/doctor_controller.dart';
import '../pharmacies/pharmacy_controller.dart';

/// Holds the catalog (products + departments) currently shown on screen.
final catalogControllerProvider = AsyncNotifierProvider<CatalogController, CatalogSnapshot>(CatalogController.new);

/// Reports progress after each step of [CatalogController.pull]/[push]/
/// [sync] finishes, so a caller (see `features/sync/sync_controller.dart`)
/// can show a percentage instead of a bare spinner.
typedef SyncProgressCallback = void Function(int completed, int total, String label);

/// Drives the catalog screen. The app is offline-first, so [build] only ever
/// reads the local cache; [pull], [push], and [sync] are the only places
/// that talk to Firestore, triggered explicitly by the user (login screen,
/// the sync button, the app-bar get/send actions, or the "new data
/// available" sync prompt — see `features/sync/sync_controller.dart`). Each
/// individual step below is best-effort — one failing must never block or
/// mask the others — except downloading the catalog itself, whose failure
/// deliberately propagates so a previously synced catalog stays on screen
/// instead of being replaced by an error view; callers should catch and
/// report that failure themselves.
class CatalogController extends AsyncNotifier<CatalogSnapshot> {
  @override
  Future<CatalogSnapshot> build() {
    debugPrint('CatalogController.build: loading cached catalog');
    return ref.read(productRepositoryProvider).loadCachedCatalog();
  }

  static const _pullStepCount = 4;
  static const _pushStepCount = 9;
  static const _totalSteps = _pullStepCount + _pushStepCount;

  Future<void> _downloadCatalog() async {
    final snapshot = await ref.read(productRepositoryProvider).sync();
    debugPrint('CatalogController: catalog sync succeeded');
    state = AsyncData(snapshot);
  }

  Future<void> _downloadDoctors() async {
    try {
      debugPrint('CatalogController: syncing doctor list');
      await ref.read(doctorControllerProvider.notifier).sync();
    } catch (error) {
      debugPrint('CatalogController: doctor sync failed error=$error');
    }
  }

  Future<void> _downloadAgencies() async {
    try {
      debugPrint('CatalogController: syncing agencies');
      await ref.read(agencyControllerProvider.notifier).sync();
    } catch (error) {
      debugPrint('CatalogController: agency sync failed error=$error');
    }
  }

  Future<void> _downloadPharmacies() async {
    try {
      debugPrint('CatalogController: syncing pharmacies');
      await ref.read(pharmacyControllerProvider.notifier).sync();
    } catch (error) {
      debugPrint('CatalogController: pharmacy sync failed error=$error');
    }
  }

  Future<void> _uploadUsageSessions() async {
    try {
      debugPrint('CatalogController: uploading pending usage sessions');
      await ref.read(usageSessionRepositoryProvider).uploadPending();
      debugPrint('CatalogController: usage session uploadPending succeeded');
    } catch (error) {
      debugPrint('CatalogController: usage session uploadPending failed error=$error');
    }
  }

  Future<void> _uploadDoctorRequests() async {
    try {
      debugPrint('CatalogController: uploading pending doctor change requests');
      await ref.read(doctorChangeRequestRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: doctor change request uploadPending failed error=$error');
    }
  }

  Future<void> _uploadVisitLogs() async {
    try {
      debugPrint('CatalogController: uploading pending doctor visit logs');
      await ref.read(doctorVisitLogRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: doctor visit log uploadPending failed error=$error');
    }
  }

  Future<void> _uploadVisitPlan() async {
    final mrUid = ref.read(isAdminProvider) ? null : ref.read(authControllerProvider).value?.uid;
    if (mrUid == null) return;
    try {
      debugPrint('CatalogController: pushing unsynced visit plan');
      await ref.read(doctorVisitPlanRepositoryProvider).pushUnsynced(mrUid);
    } catch (error) {
      debugPrint('CatalogController: visit plan pushUnsynced failed error=$error');
    }
  }

  Future<void> _uploadEntityRequests() async {
    try {
      debugPrint('CatalogController: uploading pending entity change requests');
      await ref.read(entityChangeRequestRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: entity change request uploadPending failed error=$error');
    }
  }

  Future<void> _uploadOrders() async {
    try {
      debugPrint('CatalogController: uploading pending orders');
      await ref.read(orderRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: order uploadPending failed error=$error');
    }
  }

  Future<void> _uploadRcpaEntries() async {
    try {
      debugPrint('CatalogController: uploading pending RCPA entries');
      await ref.read(rcpaRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: RCPA uploadPending failed error=$error');
    }
  }

  Future<void> _uploadExpenseClaims() async {
    try {
      debugPrint('CatalogController: uploading pending expense claims');
      await ref.read(expenseClaimRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: expense claim uploadPending failed error=$error');
    }
  }

  Future<void> _uploadComplianceLogs() async {
    try {
      debugPrint('CatalogController: uploading pending compliance logs');
      await ref.read(complianceLogRepositoryProvider).uploadPending();
    } catch (error) {
      debugPrint('CatalogController: compliance log uploadPending failed error=$error');
    }
  }

  /// Downloads the latest catalog, doctor list, agencies and pharmacies from
  /// Firestore and overwrites the local cache — the "get data" half of a
  /// sync (see [push] for "send data", and [sync] for both combined).
  Future<void> pull({SyncProgressCallback? onProgress}) async {
    debugPrint('CatalogController.pull: starting catalog download');
    var completed = 0;
    void report(String label) => onProgress?.call(completed, _pullStepCount, label);

    report('Downloading catalog…');
    await _downloadCatalog();
    completed++;

    report('Downloading doctor list…');
    await _downloadDoctors();
    completed++;

    report('Downloading agencies…');
    await _downloadAgencies();
    completed++;

    report('Downloading pharmacies…');
    await _downloadPharmacies();
    completed++;

    onProgress?.call(completed, _pullStepCount, 'Download complete');
  }

  /// Pushes every locally-queued offline record (usage sessions, doctor and
  /// agency/pharmacy change requests, visit logs, an MR's visit plan,
  /// orders, RCPA entries, expense claims, compliance logs) up to Firestore
  /// — the "send data" half of a sync (see [pull] for "get data").
  Future<void> push({SyncProgressCallback? onProgress}) async {
    debugPrint('CatalogController.push: starting catalog upload');
    var completed = 0;
    void report(String label) => onProgress?.call(completed, _pushStepCount, label);

    report('Uploading usage data…');
    await _uploadUsageSessions();
    completed++;

    report('Uploading doctor requests…');
    await _uploadDoctorRequests();
    completed++;

    report('Uploading visit logs…');
    await _uploadVisitLogs();
    completed++;

    report('Uploading visit plan…');
    await _uploadVisitPlan();
    completed++;

    report('Uploading agency/pharmacy requests…');
    await _uploadEntityRequests();
    completed++;

    report('Uploading orders…');
    await _uploadOrders();
    completed++;

    report('Uploading RCPA entries…');
    await _uploadRcpaEntries();
    completed++;

    report('Uploading expense claims…');
    await _uploadExpenseClaims();
    completed++;

    report('Uploading compliance logs…');
    await _uploadComplianceLogs();
    completed++;

    onProgress?.call(completed, _pushStepCount, 'Upload complete');
  }

  /// Downloads the catalog and pushes every locally-queued offline record in
  /// one combined pass — both directions, in the same interleaved order and
  /// against the same shared total this method has always reported, so an
  /// existing caller (login screen, the catalog screen's manual sync button,
  /// the catalog-update push handler) keeps seeing one continuous
  /// percentage ending in "Sync complete".
  Future<void> sync({SyncProgressCallback? onProgress}) async {
    debugPrint('CatalogController.sync: starting catalog sync with Firestore');
    var completed = 0;
    void report(String label) => onProgress?.call(completed, _totalSteps, label);

    report('Downloading catalog…');
    await _downloadCatalog();
    completed++;

    report('Uploading usage data…');
    await _uploadUsageSessions();
    completed++;

    report('Uploading doctor requests…');
    await _uploadDoctorRequests();
    completed++;

    report('Uploading visit logs…');
    await _uploadVisitLogs();
    completed++;

    report('Uploading visit plan…');
    await _uploadVisitPlan();
    completed++;

    report('Downloading doctor list…');
    await _downloadDoctors();
    completed++;

    report('Uploading agency/pharmacy requests…');
    await _uploadEntityRequests();
    completed++;

    report('Downloading agencies…');
    await _downloadAgencies();
    completed++;

    report('Downloading pharmacies…');
    await _downloadPharmacies();
    completed++;

    report('Uploading orders…');
    await _uploadOrders();
    completed++;

    report('Uploading RCPA entries…');
    await _uploadRcpaEntries();
    completed++;

    report('Uploading expense claims…');
    await _uploadExpenseClaims();
    completed++;

    report('Uploading compliance logs…');
    await _uploadComplianceLogs();
    completed++;

    onProgress?.call(completed, _totalSteps, 'Sync complete');
  }
}
